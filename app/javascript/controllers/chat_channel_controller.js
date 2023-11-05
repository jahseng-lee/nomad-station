import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  static targets = [
    "hiddenReplyToField",
    "replyDisplayName",
    "replyMessageBody"
  ];

  setReplyTo(event) {
    const messageId = event.currentTarget.dataset.messageId;
    const messageSender = event.currentTarget.dataset.messageSender;
    // Just use the first line
    let messageBody = event.currentTarget.dataset.messageBody.split("\n")[0];

    // If the first line is long, just get the first 47 characters then
    // "..."
    if (messageBody > 50) {
      messageBody = messageBody.slice(0, 47) + "...";
    }

    document.getElementById("reply-to-section").style.display = "flex";

    this.hiddenReplyToFieldTarget.value = messageId;
    this.replyDisplayNameTarget.innerText = messageSender;
    this.replyMessageBodyTarget.innerText = messageBody;
  }

  clearReplyTo() {
    document.getElementById("reply-to-section").style.display = "none";

    this.hiddenReplyToFieldTarget.value = null;
    this.replyDisplayNameTarget.innerText = "";
    this.replyMessageBodyTarget.innerText = "";
  }

  jumpToReply(event) {
    const replyToId = event.currentTarget.dataset.replyToId;

    const message = document.getElementById(`chat-message-${replyToId}`);

    if (!!message) {
      message.scrollIntoView();
      this._flashMessage(message);
    } else {
      // TODO display warning
    }
  }

  _flashMessage(message) {
    // Set the background color...
    // this is the same as lighten($primary, 70%)
    message.style.backgroundColor = "#d9d9d9";

    // Then flick a couple of times
    setTimeout(() => {
      message.style.backgroundColor = "";
    }, 3000);
  }
}
