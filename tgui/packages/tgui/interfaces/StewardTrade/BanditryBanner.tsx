import type { BanditryProjection } from './types';
import { bannerStyle, SEAL_AMBER, SEAL_RED_SOFT } from '../common/parchment';

export const BanditryBanner = (props: { projection: BanditryProjection }) => {
  const p = props.projection;
  const hasProjection = !!p && p.total > 0;
  const hasDebt = !!p && p.debt > 0;
  if (!hasProjection && !hasDebt) {
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
      {(p.lines || []).map((line) => (
        <div
          key={line}
          style={{
            fontWeight: 'normal',
            fontVariant: 'normal',
            fontStyle: 'italic',
            fontSize: '11px',
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
