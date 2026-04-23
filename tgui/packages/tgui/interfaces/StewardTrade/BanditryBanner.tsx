import type { BanditryProjection } from './types';
import { bannerStyle, SEAL_AMBER, SEAL_RED_SOFT } from './styles';

export const BanditryBanner = (props: { projection: BanditryProjection }) => {
  const p = props.projection;
  if (!p || !p.total || p.total <= 0) {
    return null;
  }
  return (
    <div style={bannerStyle(SEAL_RED_SOFT, true)}>
      <div>Projected Banditry Losses: -{p.total}m next dawn</div>
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
