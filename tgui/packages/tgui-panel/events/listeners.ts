import { loadStyleSheet } from 'common/assets';
import { EventBus } from 'tgui-core/eventbus';
import { setChatTheme } from 'tgui-panel/theme';
import { playMusic, stopMusic } from '../audio/handlers';
import { chatMessage } from '../chat/handlers';
import { pingReply, pingSoft } from '../ping/handlers';
import {
  handleTelemetryData,
  telemetryRequest,
  testTelemetryCommand,
} from '../telemetry/handlers';
import { handleLoadAssets } from './handlers/assets';
import { roundrestart } from './handlers/roundrestart';

const listeners = {
  'asset/stylesheet': loadStyleSheet,
  'asset/mappings': handleLoadAssets,
  'audio/playMusic': playMusic,
  'audio/stopMusic': stopMusic,
  'chat/message': chatMessage,
  'ping/reply': pingReply,
  'ping/soft': pingSoft,
  roundrestart,
  set_chat_theme: setChatTheme,
  'telemetry/request': telemetryRequest,
  testTelemetryCommand,
  update: handleTelemetryData,
} as const;

export const bus = new EventBus(listeners);
