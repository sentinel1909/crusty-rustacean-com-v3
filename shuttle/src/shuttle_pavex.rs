// shuttle/src/shuttle_pavex.rs

// dependencies
use pavex::server::Server;
use server_sdk::{ApplicationState, run};
use shuttle_runtime::Error;
use std::net::SocketAddr;

// type aliases
pub type ShuttlePavex = Result<PavexService, Error>;

// wrapper type for [pavex::server::Server] so we can implement [shuttle_runtime::Service] for it
pub struct PavexService(pub Server, pub ApplicationState);

#[shuttle_runtime::async_trait]
impl shuttle_runtime::Service for PavexService {
    async fn bind(mut self, addr: SocketAddr) -> Result<(), Error> {
        let server_builder = self
            .0
            .bind(addr)
            .await
            .expect("Failed to bind the server TCP listener");

        run(server_builder, self.1).await;

        Ok(())
    }
}
