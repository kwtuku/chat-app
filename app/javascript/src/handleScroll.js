export default () => {
  document.addEventListener('turbolinks:load', () => {
    const scrolledEl = document.getElementById('scrollable-area');

    if (scrolledEl === null) return;

    const scrollHeight = scrolledEl.scrollHeight;
    scrolledEl.scrollTop = scrollHeight;

    scrolledEl.addEventListener('scroll', () => {
      if (scrolledEl.dataset.infiniteScroll !== 'true') return false;

      const viewTop = scrolledEl.scrollTop;

      if (viewTop < scrollHeight * 0.2) {
        scrolledEl.dataset.infiniteScroll = 'false';

        const loadingAnimation = document.getElementById('loading-animation');
        loadingAnimation.click();
      }
    });
  });
}
