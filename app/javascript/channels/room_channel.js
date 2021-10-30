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
      messageContainer.insertAdjacentHTML('beforeend', data['message'])
    }
  })
})
