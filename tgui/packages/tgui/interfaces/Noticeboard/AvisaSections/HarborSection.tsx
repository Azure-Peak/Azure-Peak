import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_AMBER,
  SEAL_BLUE,
  SERIF,
} from '../../common/parchment';
import type { HarborDemand, NoticeboardData } from '../types';

const orderGridStyle: React.CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: 10,
  alignItems: 'start',
};

const fieldLabelStyle: React.CSSProperties = {
  color: SEAL_AMBER,
  fontSize: FONT_BODY,
};

const formatDuration = (totalSeconds: number) => {
  if (totalSeconds <= 0) return 'departing';
  const minutes = Math.floor(totalSeconds / 60);
  if (minutes < 1) return 'departing soon';
  if (minutes === 1) return '1 minute';
  return `${minutes} minutes`;
};

const HarborDemandCard = ({ demand }: { demand: HarborDemand }) => (
  <div style={{ ...cardStyle, marginBottom: 0 }}>
    <div style={{ display: 'flex', alignItems: 'baseline', flexWrap: 'wrap' }}>
      <span style={badgeStyle(SEAL_BLUE)}>SHIP IN PORT</span>
    </div>
    <div
      style={{
        fontSize: FONT_TITLE,
        fontWeight: 'bold',
        color: INK,
        fontFamily: SERIF,
        marginTop: 6,
      }}
    >
      {demand.ship_name}
    </div>
    <div
      style={{
        color: INK_SOFT,
        fontSize: FONT_BODY,
        marginTop: 2,
      }}
    >
      flag of {demand.realm_name} &middot; departs in{' '}
      {formatDuration(demand.seconds_until_departure)}
    </div>
    {demand.lines.length > 0 && (
      <div style={{ marginTop: 8 }}>
        <div style={fieldLabelStyle}>Buying</div>
        <div style={{ marginTop: 2 }}>
          {demand.lines.map((line) => (
            <div
              key={line.good_name}
              style={{
                display: 'flex',
                alignItems: 'baseline',
                gap: 8,
                fontSize: FONT_BODY,
                color: INK,
                padding: '2px 0',
              }}
            >
              <span style={{ flex: 1 }}>{line.good_name}</span>
              <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
                {line.qty_fulfilled} / {line.qty_target}
              </span>
              <span
                style={{
                  flex: '0 0 auto',
                  color: SEAL_AMBER,
                  fontWeight: 'bold',
                }}
              >
                {line.offered_price}m ea
              </span>
            </div>
          ))}
        </div>
      </div>
    )}
    {demand.cultural_stock.length > 0 && (
      <div style={{ marginTop: 8 }}>
        <div style={fieldLabelStyle}>Wares Ashore</div>
        <div style={{ marginTop: 2 }}>
          {demand.cultural_stock.map((entry) => (
            <div
              key={entry.name}
              style={{
                display: 'flex',
                alignItems: 'baseline',
                gap: 8,
                fontSize: FONT_BODY,
                color: INK,
                padding: '2px 0',
              }}
            >
              <span style={{ flex: 1 }}>{entry.name}</span>
              <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
                x{entry.qty}
              </span>
            </div>
          ))}
        </div>
        <div
          style={{
            marginTop: 4,
            color: INK_SOFT,
            fontSize: FONT_BODY,
          }}
        >
          Inquire with the Merchant for terms.
        </div>
      </div>
    )}
    <div
      style={{
        marginTop: 8,
        color: INK_FAINT,
        fontSize: FONT_BODY,
      }}
    >
      Deposit goods at the Fulfillment Crate to settle the vessel&apos;s bulk
      demands.
    </div>
  </div>
);

export const HarborSection = ({ data }: { data: NoticeboardData }) => {
  const demands = data.harbor_demands ?? [];
  if (demands.length === 0) {
    return (
      <div
        style={{
          color: INK_FAINT,
          textAlign: 'center',
          padding: '24px 0',
        }}
      >
        No foreign vessels at the pier.
      </div>
    );
  }
  return (
    <div style={orderGridStyle}>
      {demands.map((d) => (
        <HarborDemandCard key={d.ship_id} demand={d} />
      ))}
    </div>
  );
};
