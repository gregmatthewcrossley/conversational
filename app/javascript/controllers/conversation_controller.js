// app/javascript/controllers/conversation_controller.js
import { Controller } from "@hotwired/stimulus"
import { 
  poll_location//, 
  // send_location 
} from "location_services/poll_client_location"

export default class extends Controller {
  connect() { // Stimulus calls this each time the controller is connected to the document.
    console.log("Conversation controller connected");
    // You can call poll_location(), send_location() here or in specific methods
  }

  poll() {
    poll_location();
  }

  // send() {
  //   send_location();
  // }
}
