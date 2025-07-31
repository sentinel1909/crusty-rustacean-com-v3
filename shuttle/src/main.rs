// shuttle/src/main.rs

// dependencies
use app::configuration::{StaticServer, TemplateEngine};
use opendal::Operator;
use pavex::config::ConfigLoader;
use pavex::server::Server;
use server::configuration::Profile::{Dev, Prod};
use server_sdk::{ApplicationConfig, ApplicationState};
use shuttle_opendal::Opendal;
use shuttle_runtime::{CustomError, SecretStore, Secrets};
use shuttle_shared_db::Postgres;
use sqlx::PgPool;

// module dependencies
mod shuttle_pavex;

#[shuttle_runtime::main]
async fn pavex(
    #[Postgres] db_pool: PgPool,
    #[Opendal(scheme = "s3")] op: Operator,
    #[Secrets] secrets: SecretStore,
) -> shuttle_pavex::ShuttlePavex {
    // run the database migrations
    tracing::info!("Running database migrations...");
    sqlx::migrate!("./migrations")
        .run(&db_pool)
        .await
        .map_err(|err| {
            let msg = format!("Unable to run the database migrations: {err}");
            CustomError::new(err).context(msg)
        })?;

    // get the profile from the secrets
    let profile = secrets.get("PX_PROFILE").unwrap_or_default();

    let app_profile = match profile.as_str() {
        "dev" => Dev,
        "prod" => Prod,
        _ => panic!("Unable to set the application profile."),
    };
    tracing::info!("Application profile (set from Secrets): {:?}", app_profile);

    // load the application configuration
    let app_config: ApplicationConfig =
        ConfigLoader::new()
            .profile(app_profile)
            .load()
            .map_err(|err| {
                let error_msg = format!("Unable to load the application configuration: {}", err);
                CustomError::new(err).context(error_msg)
            })?;
    tracing::info!("Application configuration loaded: {:?}", app_config);

    // build the template engine
    let template_engine =
        TemplateEngine::from_config(&app_config.templateconfig).map_err(|err| {
            let error_msg = format!("Unable to build the template engine: {}", err);
            CustomError::new(err).context(error_msg)
        })?;
    
    // build the static server
    let static_server = StaticServer::from_config(app_config.staticserverconfig.clone());

    // build the application state
    let app_state = ApplicationState::new(app_config, template_engine, static_server, db_pool)
        .await
        .map_err(|err| {
            let error_msg = format!("Unable to build the application state: {}", err);
            CustomError::new(err).context(error_msg)
        })?;
    tracing::info!("Application state built...");

    let app_server = Server::new();

    let shuttle_px = shuttle_pavex::PavexService(app_server, app_state);

    Ok(shuttle_px)
}
