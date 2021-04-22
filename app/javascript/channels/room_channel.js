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
    changeLineCheck()
  })

  messageButton.addEventListener('click', () => {
    messageButton.classList.add('disabled')
    changeLineCount(1)
  })

  const maxLineCount = 10

  const getLineCount = () => {
    return (messageContent.value + '\n').match(/\r?\n/g).length;
  }

  let lineCount = getLineCount()
  let newLineCount

  const changeLineCheck = () => {
    newLineCount = Math.min(getLineCount(), maxLineCount)
    if (lineCount !== newLineCount) {
      changeLineCount(newLineCount)
    }
  }

  const changeLineCount = (newLineCount) => {
    messageContent.rows = lineCount = newLineCount
  }
})
