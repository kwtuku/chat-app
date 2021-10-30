export default () => {
  document.addEventListener('turbolinks:load', () => {
    const scrolledEl = document.getElementById('scroll-to-bottom')

    if (scrolledEl === null) return;

    const scrollHeight = scrolledEl.scrollHeight;

    scrolledEl.scrollTop = scrollHeight;
  });
}
