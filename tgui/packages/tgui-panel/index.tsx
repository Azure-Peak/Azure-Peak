/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import './styles/main.scss';

import { createRoot } from 'react-dom/client';
import { setupGlobalEvents } from 'tgui-core/events';
import { captureExternalLinks } from 'tgui-core/links';
import { setupHotReloading } from 'tgui-dev-server/link/client';
import { App } from './app';
import { bus } from './events/listeners';
import { setupPanelFocusHacks } from './panelFocus';

const root = createRoot(document.getElementById('react-root')!);

function render(component: React.ReactElement) {
  root.render(component);
}

function setupApp() {
  // Delay setup
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', setupApp);
    return;
  }

  setupGlobalEvents({
    ignoreWindowFocus: true,
  });

  setupPanelFocusHacks();
  captureExternalLinks();

  render(<App />);

  // Dispatch incoming messages as store actions
  Byond.subscribe((type, payload) => bus.dispatch({ type, payload }));

  // Unhide the panel
  Byond.winset('outputwindow.legacy_output_selector', {
    left: 'output_browser',
  });

  // Resize the panel to match the non-browser output
  Byond.winget('legacy_output_selector').then((output: { size: string }) => {
    // No idea why this always returns the correct size +4px but let's call
    // it a BYOND moment and roll with the punches
    const size = output.size.split('x').map((v) => Number.parseInt(v, 10));
    size[0] -= 4;

    Byond.winset('browseroutput', {
      size: size.join('x'),
    });
  });

  // Enable hot module reloading
  if (import.meta.webpackHot) {
    setupHotReloading();

    import.meta.webpackHot.accept(['./app'], () => {
      render(<App />);
    });
  }
}

setupApp();
