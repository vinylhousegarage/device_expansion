import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import HelloController from "./controllers/hello_controller"

const application = Application.start()
application.register("hello", HelloController)
