// app/javascript/controllers/conversation_controller.js
import { Controller } from "@hotwired/stimulus"
import { 
  poll_location
} from "location_services/poll_client_location"

export default class extends Controller {
  connect() { // Stimulus calls this each time the controller is connected to the document.
    console.log("Conversation controller connected");
  }

  start() {
    poll_location();
  }

  stop() {
    send_location();
  }
}
