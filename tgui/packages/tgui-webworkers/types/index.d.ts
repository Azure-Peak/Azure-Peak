import type * as RW from './renderer_worker';

export interface TguiWorker<Req, Res> extends Worker {
  postMessage(message: Req, transfer: Transferable[]): void;
  postMessage(message: Req, options?: StructuredSerializeOptions): void;

  addEventListener(
    type: 'message',
    listener: (ev: MessageEvent<Res>) => any,
    options?: boolean | AddEventListenerOptions,
  ): void;
  addEventListener(
    type: 'error',
    listener: (ev: ErrorEvent) => any,
    options?: boolean | AddEventListenerOptions,
  ): void;
}

declare namespace RendererWorker {
  export type RenderRequest = RW.RenderRequest;
  export type RenderResponse = RW.RenderResponse;
}
