export function isAtTopOfQueue(audio) {
  // does this <audio> element have any siblings that preceed it?
  return audio.previousElementSibling == null;
}
export function isAnythingPlaying() {
  // check all <audio> elements to see if any of them are playing
  let audioElements = document.querySelectorAll("audio");
  for (let i = 0; i < audioElements.length; i++) {
    if (!audioElements[i].paused) {
      return true;
    }
  }
  return false;
}
export function playAudio(audio) {
  // play the given <audio> element
  audio.play();
}
export function nextAudioAfter(audio) {
  // return the <audio> element that comes after the given one
  return audio.nextElementSibling;
}
export function removeAudioFromDOM(audio) {
  // remove the given <audio> element from the DOM
  audio.remove();
}