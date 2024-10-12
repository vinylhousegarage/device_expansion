// Import and register all your controllers from the controllers directory
import { application } from "./application";
import { definitionsFromContext } from "@hotwired/stimulus";

// コントローラを自動で読み込む
const context = require.context("controllers", true, /\.js$/);
application.load(definitionsFromContext(context));
