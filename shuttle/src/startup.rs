// shuttle/src/startup.rs

//  dependencies
use app::configuration::{StaticServer, TemplateEngine};
use opendal::Operator;
use pavex::config::ConfigLoader;
use server::configuration::Profile::{Dev, Prod};
use server::telemetry::{get_subscriber, init_telemetry};
use server_sdk::{ApplicationConfig, ApplicationState};
use shuttle_runtime::{CustomError, SecretStore};
use sqlx::PgPool;

// setup the telemetry
pub fn setup_telemetry() -> Result<(), CustomError> {
    let subscriber = get_subscriber(
        "crusty_rustacean_com_v3".into(),
        "info".into(),
        std::io::stdout,
    );
    init_telemetry(subscriber)?;
    Ok(())
}

// run the database migrations
pub async fn run_migrations(db_pool: &PgPool) -> Result<(), CustomError> {
    tracing::info!("Running database migrations...");
    sqlx::migrate!("./migrations")
        .run(db_pool)
        .await
        .map_err(|err| {
            let msg = format!("Unable to run the database migrations: {err}");
            CustomError::new(err).context(msg)
        })
}

// determine the application profile
pub fn determine_profile(
    secrets: &SecretStore,
) -> Result<server::configuration::Profile, CustomError> {
    let profile = secrets.get("PX_PROFILE").unwrap_or_default();
    let app_profile = match profile.as_str() {
        "dev" => Dev,
        "prod" => Prod,
        _ => {
            return Err(CustomError::new(std::io::Error::new(
                std::io::ErrorKind::InvalidInput,
                "Unable to set the application profile.",
            )));
        }
    };
    tracing::info!("Application profile (set from Secrets): {:?}", app_profile);
    Ok(app_profile)
}

// load the application configuration
pub fn load_application_config(
    profile: server::configuration::Profile,
) -> Result<ApplicationConfig, CustomError> {
    let app_config: ApplicationConfig =
        ConfigLoader::new().profile(profile).load().map_err(|err| {
            let error_msg = format!("Unable to load the application configuration: {err}");
            CustomError::new(err).context(error_msg)
        })?;
    tracing::info!("Application configuration loaded: {:?}", app_config);
    Ok(app_config)
}

// setup the components
pub fn setup_components(
    app_config: &ApplicationConfig,
) -> Result<(TemplateEngine, StaticServer), CustomError> {
    let template_engine =
        TemplateEngine::from_config(&app_config.templateconfig).map_err(|err| {
            let error_msg = format!("Unable to build the template engine: {err}");
            CustomError::new(err).context(error_msg)
        })?;

    let static_server = StaticServer::from_config(app_config.staticserverconfig.clone());

    Ok((template_engine, static_server))
}

// build the application state
pub async fn build_application_state(
    app_config: ApplicationConfig,
    template_engine: TemplateEngine,
    static_server: StaticServer,
    db_pool: PgPool,
    op: Operator,
) -> Result<ApplicationState, CustomError> {
    let app_state = ApplicationState::new(app_config, template_engine, static_server, db_pool, op)
        .await
        .map_err(|err| {
            let error_msg = format!("Unable to build the application state: {err}");
            CustomError::new(err).context(error_msg)
        })?;
    tracing::info!("Application state built...");
    Ok(app_state)
}
