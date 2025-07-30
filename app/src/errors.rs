// app/src/errors.rs

// dependencies
use pavex::{error_handler, Response};
use pavex::http::StatusCode;
use pavex_static_files::ServeError;
use pavex_tera_template::TemplateError;
use serde::Serialize;
use serde_json;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum ApiError {
    #[error("Template error: {0}")]
    TemplateError(#[from] TemplateError),

    #[error("Static file error: {0}")]
    StaticFileError(#[from] ServeError),
}

#[derive(Serialize)]
struct ApiErrorResponse {
    msg: String,
    status: u16,
    details: String,
}

// error handler for the static server endpoint
#[error_handler]
pub fn api_error2response(error: &ApiError) -> Response {
    let status = match error {
        ApiError::TemplateError(_) => StatusCode::INTERNAL_SERVER_ERROR,
        ApiError::StaticFileError(_) => StatusCode::INTERNAL_SERVER_ERROR,
    };

    let payload = ApiErrorResponse {
        msg: "Error".to_string(),
        status: status.as_u16(),
        details: error.to_string(),
    };

    let json = serde_json::to_string(&payload).unwrap_or_else(|_| {
        r#"{"msg":"Error","status":500,"details":"Internal server error formatting error response"}"#.to_string()
    });

    Response::new(status).set_typed_body(json)
}