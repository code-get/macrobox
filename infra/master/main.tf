
resource "heroku_app" "app" {
   name   = "macroweb"
   region = "us"
   acm    = "true"
}

