// https://philipwalton.com/articles/the-google-analytics-setup-i-use-on-every-site-i-build/
const dimensions = {
  TRACKING_VERSION: 'dimension1',
};

const TRACKING_VERSION = '1';

export const init = () => {
  window.ga = window.ga || ((...args) => (ga.q = ga.q || []).push(args));
  ga('create', 'UA-113516521-1', 'auto');
  ga('set', 'transport', 'beacon');
  ga('set', dimensions.TRACKING_VERSION, TRACKING_VERSION);
  ga('send', 'pageview');
};

let script = document.createElement('script');
script.setAttribute('async', true)
script.src = "https://www.google-analytics.com/analytics.js";
document.getElementsByTagName('head')[0].appendChild(script);

