// Import and register all your controllers from the controllers directory
import { Application } from "@hotwired/stimulus";

// Initialize Stimulus Application
const application = Application.start();

// コントローラを自動で読み込む
const context = require.context("./controllers", true, /\.js$/);
application.load(context);
