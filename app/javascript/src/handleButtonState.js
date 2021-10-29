export default () => {
  document.addEventListener('turbolinks:load', () => {
    const button = document.getElementById('create-message-button');

    if (button === null) return;

    const messageContent = document.getElementById('message_content');

    messageContent.addEventListener('input', () => {
      if (messageContent.value.trim()) {
        button.disabled = false;
      } else {
        button.disabled = true;
      }
    });
  });
}
