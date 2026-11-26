import {
  bannerStyle,
  FONT_BODY,
  SEAL_AMBER,
  SEAL_RED_SOFT,
} from '../common/parchment';
import type { BanditryProjection } from './types';

export const BanditryBanner = (props: { projection: BanditryProjection }) => {
  const p = props.projection;
  const hasProjection = !!p && p.total > 0;
  const hasDebt = !!p && p.debt > 0;
  const hasHoard = !!p && p.hoard_total > 0;
  if (!hasProjection && !hasDebt && !hasHoard) {
    return null;
  }
  return (
    <div style={bannerStyle(SEAL_RED_SOFT, true)}>
      {hasDebt && (
        <div>Brigand Debt: {p.debt}m, skimmed from all inflow</div>
      )}
      {hasProjection && (
        <div>Projected Losses to Brigands: -{p.total}m next dawn</div>
      )}
      {hasHoard && (
        <div>
          Brigands are sitting on {p.hoard_total}m. When a hoard is recovered,
          the Crown taxes a share of it.
        </div>
      )}
      {(p.lines || []).map((line) => (
        <div
          key={line}
          style={{
            fontWeight: 'normal',
            fontVariant: 'normal',
            fontSize: FONT_BODY,
            color: SEAL_AMBER,
            letterSpacing: 0,
          }}
        >
          {line}
        </div>
      ))}
    </div>
  );
};
