export function start_conversation() {
  console.log("Starting conversation ...");
  // prepare the url and the data
  const conversationId = document.querySelector("meta[name='conversation-id']").content;
  const url = "/conversations/" + conversationId + "/start";
  const csrfToken = document.querySelector("meta[name='csrf-token']").content;
  const data = {};
  // send the request
  fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken
    },
    body: JSON.stringify(data)
  })
  .then(response => {
    if (response.ok) {
      console.log("🟢 Conversation started.");
    } else {
      console.error("Request to start conversation failed.");
    }
  })
  .catch(error => {
    console.error("An error occurred:", error);
  });
}
  
export function end_conversation() {
  console.log("Ending conversation ...");
  // prepare the url and the data
  const conversationId = document.querySelector("meta[name='conversation-id']").content;
  const url = "/conversations/" + conversationId + "/end";
  const csrfToken = document.querySelector("meta[name='csrf-token']").content;
  const data = {};
  // send the request
  fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken
    },
    body: JSON.stringify(data)
  })
  .then(response => {
    if (response.ok) {
      console.log("🔴 Conversation ended.");
    } else {
      console.error("Request to end conversation failed.");
    }
  })
  .catch(error => {
    console.error("An error occurred:", error);
  });
}
  