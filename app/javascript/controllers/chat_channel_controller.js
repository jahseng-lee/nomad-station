import { Controller } from "@hotwired/stimulus";
import { Modal } from "bootstrap";
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [
    "hiddenReplyToField",
    "messageTextarea",
    "replyDisplayName",
    "replyMessageBody"
  ];
  static values = {
    channelMemberId: String,
  };

  connect() {
    if (!!this.channelMemberIdValue) {
      setInterval(() => {
        fetch(
          `/channel_members/${this.channelMemberIdValue}/update_last_active`,
          {
            method: "PATCH",
            credentials: 'same-origin',
            headers: { 'X-CSRF_Token': Rails.csrfToken() }
          }
        )
          .catch((error) => {
            // TODO error handling
            // Pop a modal up and get them to refresh?
          });
      }, 10000);
    }
  }

  setReplyTo(event) {
    const messageId = event.currentTarget.dataset.messageId;
    const messageSender = event.currentTarget.dataset.messageSender;
    // Just use the first line
    let messageBody = event.currentTarget.dataset.messageBody.split("\n")[0];

    // If the first line is long, just get the first 47 characters then
    // "..."
    if (messageBody.length > 150) {
      messageBody = messageBody.slice(0, 147) + "...";
    }

    document.getElementById("reply-to-section").style.display = "flex";

    this.hiddenReplyToFieldTarget.value = messageId;
    this.replyDisplayNameTarget.innerText = messageSender;
    this.replyMessageBodyTarget.innerText = messageBody;
    this.messageTextareaTarget.focus();
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
      const errorMessage = document.getElementById("error-scroll-to-reply");
      errorMessage.style.display = "block";

      // NOTE: could probably animate fade...
      setTimeout(() => {
        errorMessage.style.display = "none";
      }, 3000);
    }
  }

  _flashMessage(message) {
    // Set the background color...
    // this is the same as lighten($primary, 70%)
    message.style.backgroundColor = "#d9d9d9";

    // Then switch to original again
    // NOTE: could probably animate...
    setTimeout(() => {
      message.style.backgroundColor = "";
    }, 3000);
  }
}
