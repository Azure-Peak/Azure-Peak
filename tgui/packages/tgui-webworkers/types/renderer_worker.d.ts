export type RenderRequest = {
  id: string;
  imageSize: number;
  iconRef: string;
  iconStates: string[];
  offsetX: number;
};

export type RenderResponse = {
  id: string;
  blob: Blob;
};
