// Storybook (phoenix_storybook) JS entry: register the app's LiveView hooks
// so stories using phx-hook (e.g. Tooltip on disabled buttons) work.
import * as Hooks from './hooks';

(function () {
  window.storybook = { Hooks };
})();
