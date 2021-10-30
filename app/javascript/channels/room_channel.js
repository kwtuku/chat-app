import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  window.messageContainer = document.getElementById('message-container')

  if (messageContainer === null) return;

  consumer.subscriptions.create("RoomChannel", {
    connected() {
    },

    disconnected() {
    },

    received(data) {
      messageContainer.insertAdjacentHTML('beforeend', data['message'])
    }
  })

  window.messageContent = document.getElementById('message_content')

  let oldestMessageId

  window.showAdditionally = true

  window.addEventListener('scroll', () => {
    if (document.documentElement.scrollTop === 0 && showAdditionally) {
      showAdditionally = false
      oldestMessageId = document.getElementsByClassName('message')[0].id.replace(/[^0-9]/g, '')
      $.ajax({
        type: 'GET',
        url: '/show_additionally',
        cache: false,
        data: { oldest_message_id: oldestMessageId, remote: true }
      })
    }
  }, { passive: true });
})
