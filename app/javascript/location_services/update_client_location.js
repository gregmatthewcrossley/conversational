// Check for Geolocation API support and handle errors gracefully
export function update_location() {
  if ("geolocation" in navigator) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        postLocationAsJson(position);
      },
      (err) => {
        console.error("Error obtaining location:", err);
      }
    );
  } else {
    console.error("Geolocation is not supported by this browser.");
  }
}

function postLocationAsJson(position) {
  const url = "/locations";
  const conversationId = document.querySelector("meta[name='conversation-id']").content;
  const data = {
    location: {
      latitude: position.coords.latitude,
      longitude: position.coords.longitude,
      conversation_id: conversationId
    },
  };
  const csrfToken = document.querySelector("meta[name='csrf-token']").content;
  fetch(url, {
    method: "POST", // new record, so use POST
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken
    },
    body: JSON.stringify(data)
  }).then(response => {
    if (response.ok) {
      console.log("The server has received a location update.");
    } else {
      console.error("Request to post location failed.");
    }
  });
}
