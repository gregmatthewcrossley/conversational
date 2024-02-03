// Check for Geolocation API support and handle errors gracefully
export function poll_location() {
  if ("geolocation" in navigator) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        console.log("Got location:", position);
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
  fetch (url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken
    },
    body: JSON.stringify(data)
  })
}

// Extracted method to update the form, reducing repetition and improving readability
function updateFormWithLocation(position) {
  const form = document.querySelector("form[action='/locations']"); 
  if (!form) {
    console.error("Location poll form not found");
    return;
  }

  const lat = form.querySelector("input[name='location[latitude]']");
  const long = form.querySelector("input[name='location[longitude]']");
  if (lat && long) {
    lat.value = position.coords.latitude;
    long.value = position.coords.longitude;
  } else {
    console.error("Latitude and longitude fields not found in the form");
  }
}

// // Send location data; unchanged but could be extended with error handling
// export function send_location() {
//   const form = document.getElementById("location_poll_form");
//   if (!form) {
//     console.error("Location poll form not found");
//     return;
//   }

//   const lat = form.querySelector("input[name='latitude']");
//   const long = form.querySelector("input[name='longitude']");
//   console.log("Sending location:", lat.value, long.value);
//   // Additional validation or error handling could be added here
//   form.submit();
// }
