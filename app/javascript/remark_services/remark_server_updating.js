export function notifyServerThatRemarkHasBeenPlayed(remarkId) {
  const url = "/remarks/" + remarkId;
  const csrfToken = document.querySelector("meta[name='csrf-token']").content;
  const data = {
    remark: {
      heard_at: new Date().toISOString()
    }
  };
  fetch(url, {
    method: "PATCH",
    headers: {
      "Accept": "application/json", // Explicitly tell the server that the client expects JSON.
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken
    },
    body: JSON.stringify(data)
  }).then(response => {
    if (response.ok) {
      // do nothing for now
    } else {
      return response.json().then(errorData => {
        throw new Error("Request failed: " + JSON.stringify(errorData));
      });
    }
  }).then(data => {
    console.log("The server has acknowledged that remark " + remarkId + " has been heard.");
  }).catch(error => {
    console.error("An error occurred:", error);
  });
}
