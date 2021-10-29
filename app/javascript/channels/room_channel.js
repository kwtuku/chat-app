import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  window.messageContainer = document.getElementById('message-container')

  if (messageContainer === null) {
    return
  }

  consumer.subscriptions.create("RoomChannel", {
    connected() {
    },

    disconnected() {
    },

    received(data) {
      messageContainer.insertAdjacentHTML('beforeend', data['message'])
    }
  })

  const documentElement = document.documentElement

  window.messageContent = document.getElementById('message_content')

  window.scrollToBottom = () => {
    window.scroll(0, documentElement.scrollHeight)
  }

  scrollToBottom()

  const messageButton = document.getElementById('message-button')

  const button_activation = () => {
    if (messageContent.value === '') {
      messageButton.classList.add('disabled')
    } else {
      messageButton.classList.remove('disabled')
    }
  }

  messageContent.addEventListener('input', () => {
    button_activation()
  })

  let oldestMessageId

  window.showAdditionally = true

  window.addEventListener('scroll', () => {
    if (documentElement.scrollTop === 0 && showAdditionally) {
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
