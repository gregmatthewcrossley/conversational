// app/javascript/controllers/audio_playback_controller.js
import { Controller } from "@hotwired/stimulus"
import { isAtTopOfQueue, isAnythingPlaying, playAudio, nextAudioAfter, removeAudioFromDOM } from "audio_playback_services/audio_playback"

export default class extends Controller {
  connect() {
    // If this <audio> element is at the top of the queue, and nothing else is playing, then play it
    if (isAtTopOfQueue(this.element) && !isAnythingPlaying()) {
      playAudio(this.element);
    }
    
    this.element.addEventListener('ended', () => {
      // If there is another <audio> element under this one, and nothing else is playing, then play it
      if (nextAudioAfter(this.element) != null && !isAnythingPlaying()) {
        playAudio(nextAudioAfter(this.element));
      }
      // Remove this <audio> element from the DOM when it is done playing
      removeAudioFromDOM(this.element);
    });
  }

  disconnect() {
    // It's a good practice to remove event listeners when the element is removed
    this.element.removeEventListener('ended', this.handleEnded);
  }

  handleEnded() {
    // Action to perform when audio ends
    console.log("Audio has finished playing");
  }
}
