// app/src/routes/storage_health.rs

// dependencies
use crate::configuration::Operator;
use pavex::get;
use pavex::http::StatusCode;

/// Respond with a `200 OK` status code to indicate that the server is alive
/// and ready to accept new requests.
#[get(path = "/storage-health")]
pub async fn storage_health(op: &Operator) -> StatusCode {
    let status = op.check().await;

    let response = match status {
        Ok(_) => StatusCode::OK,
        Err(_) => StatusCode::INTERNAL_SERVER_ERROR,
    };

    response
}