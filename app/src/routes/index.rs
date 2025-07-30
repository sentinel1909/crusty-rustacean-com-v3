// app/src/routes/index.rs

// dependencies
use crate::errors::ApiError;
use pavex::{Response, get, response::body::Html};
use pavex_tera_template::{Context, TemplateEngine};

// handler which returns the index page template
#[get(path = "/")]
pub fn index(template: &TemplateEngine) -> Result<Response, ApiError> {
    let mut context = Context::new();
    context.insert("title", "Home");
    context.insert("message", "Hello, world!");

    let body: Html = template.render("index.html", &context)?.into();

    let response = Response::ok().set_typed_body(body);

    Ok(response)
}
