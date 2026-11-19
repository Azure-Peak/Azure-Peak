import { loadStyleSheet } from 'common/assets';
import { EventBus } from 'tgui-core/eventbus';
import { handleLoadAssets } from './handlers/assets';
import {
  acknowledgePayloadChunk,
  oversizePayloadResponse,
} from './handlers/chunking';
import {
  byondCtrlDown,
  byondCtrlUp,
  byondMouseDown,
  byondMouseUp,
  byondRightMouseDown,
  byondRightMouseUp,
} from './handlers/mouse';
import { ping } from './handlers/ping';
import { suspend } from './handlers/suspense';
import { update } from './handlers/update';

/**
 * A string/handler map.
 * Ideally, these reference a function named after the respective event type.
 */
const listeners = {
  // Assets
  'asset/mappings': handleLoadAssets,
  'asset/stylesheet': loadStyleSheet,
  // Standard window events
  ping,
  suspend,
  update,
  // Mouse hook
  'byond/mousedown': byondMouseDown,
  'byond/mouseup': byondMouseUp,
  'byond/rightmousedown': byondRightMouseDown,
  'byond/rightmouseup': byondRightMouseUp,
  'byond/ctrldown': byondCtrlDown,
  'byond/ctrlup': byondCtrlUp,
  // Chunking
  oversizePayloadResponse,
  acknowledgePayloadChunk,
} as const;

export const bus = new EventBus(listeners as any);
