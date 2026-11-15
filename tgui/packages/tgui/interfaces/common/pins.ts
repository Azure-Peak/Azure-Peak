// Pin and star icons
export type PinScope = 'round' | 'saved' | undefined;
export type PinMap = Record<string, string>;

export const pinGlyph = (scope?: string): string =>
  scope === 'saved' ? '📌' : scope === 'round' ? '★' : '☆';

export const pinTitle = (scope?: string): string =>
  scope === 'saved'
    ? 'Saved to this character. Click to unpin.'
    : scope === 'round'
      ? 'Pinned for this round. Click to save to this character.'
      : 'Pin for this round';
