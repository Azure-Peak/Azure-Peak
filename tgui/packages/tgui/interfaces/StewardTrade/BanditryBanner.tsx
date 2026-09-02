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
        <div>Outstanding Banditry Debt: {p.debt}m skimming all inflow</div>
      )}
      {hasProjection && (
        <div>Projected Banditry Losses: -{p.total}m next dawn</div>
      )}
      {hasHoard && (
        <div>
          Bandit hoards hold {p.hoard_total}m, taxed as Recovered Spoils
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
