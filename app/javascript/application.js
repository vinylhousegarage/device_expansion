import { Turbo } from "@hotwired/turbo-rails";
Turbo.start();

import { Application } from "@hotwired/stimulus";

const application = Application.start();

const modules = import.meta.glob('./controllers/**/*.js');

for (const path in modules) {
  modules[path]().then((module) => {
    const controller = module.default;
    application.register(controller.name, controller);
  });
}
