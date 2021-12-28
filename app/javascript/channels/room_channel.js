import consumer from './consumer'

document.addEventListener('turbolinks:load', () => {
  const messageContainer = document.getElementById('message-container');

  if (messageContainer === null) return;

  consumer.subscriptions.create('RoomChannel', {
    connected() {
    },

    disconnected() {
    },

    received(data) {
      const currentUserId = Number(document.querySelector('[data-current-user-id]').dataset.currentUserId);

      if (currentUserId === data['message_user_id']) {
        messageContainer.insertAdjacentHTML('beforeend', data['message'])
      } else {
        messageContainer.insertAdjacentHTML('beforeend', data['other_user_message'])
      }
    }
  })
})
