// app/javascript/controllers/conversation_controller.js
import { Controller } from "@hotwired/stimulus"
import { start_conversation, end_conversation } from "conversation_services/conversation_control"
import { update_location } from "location_services/update_client_location"
export default class extends Controller {
  constructor() {
    super();
    this.periodicLocationUpdater = null;
    this.audioQueueWatcher = null;
  }

  connect() {
    // If, when the page is loaded, this conversation is already started, then start updating the location periodically
    if (document.querySelector("meta[name='conversation-started']").content === "true") {
      console.log("🟢 Conversation is already started. Starting periodic location updates.");
      update_location();
      this.update_location_periodically();
    }
  } // Stimulus calls this each time the controller is connected to the document.

  start() {
    // send an initial location update, in case this is the first time the user has started the conversation
    update_location();
    // ask the server to start generating conversation
    start_conversation();
    // update the location every 5 seconds
    this.update_location_periodically();
  }

  end() {
    // ask the server to end generating conversation
    end_conversation();
    // end updating the location
    this.stop_updating_location_periodically();
    // pause and remove each audio element
    this.pauseAndRemoveAllAudio();
  }

  update_location_periodically() {
    // Prevent multiple periodicLocationUpdaters
    if (this.periodicLocationUpdater != null) return;
    // Start updating the location every 5 seconds
    this.periodicLocationUpdater = setInterval(() => {
      update_location();
    }, 5000); // Every 5 seconds
  }

  stop_updating_location_periodically() {
    if (this.periodicLocationUpdater == null) return; 
    clearInterval(this.periodicLocationUpdater);
  }

  pauseAndRemoveAllAudio() {
    let audioElements = document.querySelectorAll("audio");
    for (let i = 0; i < audioElements.length; i++) {
      audioElements[i].pause();
      audioElements[i].remove();
    }
  }

}
