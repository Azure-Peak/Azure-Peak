import { globalEvents } from 'tgui-core/events';

/// --------- Handlers ------------------------------------------------------///

export function byondMouseDown(): void {
  globalEvents.emit('byond/mousedown');
}

export function byondMouseUp(): void {
  globalEvents.emit('byond/mouseup');
}

export function byondCtrlDown(): void {
  globalEvents.emit('byond/ctrldown');
}

export function byondCtrlUp(): void {
  globalEvents.emit('byond/ctrlup');
}
