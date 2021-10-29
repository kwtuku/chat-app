export default () => {
  document.addEventListener('turbolinks:load', () => {
    const textarea = document.getElementById('resize-textarea');
    if (textarea === null) return false;

    let textareaClientHeight = textarea.clientHeight;

    textarea.addEventListener('input', () => {
      textarea.style.height = textareaClientHeight + 2 + 'px';

      let textareaScrollHeight = textarea.scrollHeight;
      textarea.style.height = textareaScrollHeight + 2 + 'px';
    });
  });
}
