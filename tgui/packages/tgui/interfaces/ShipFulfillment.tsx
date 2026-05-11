import { useBackend } from '../backend';
import {
  cardStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SERIF,
  sectionHeaderStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { Window } from '../layouts';

type DemandLine = {
  good: string;
  good_name: string;
  qty_target: number;
  qty_fulfilled: number;
  offered_price: number;
};

type Manifest = {
  ship_id: string;
  ship_name: string;
  nationality_id: string;
  lines: DemandLine[];
};

type Data = {
  manifests: Manifest[];
  middleman_cut_percent: number;
};

const LineRow = (props: { line: DemandLine; cutPercent: number }) => {
  const { line, cutPercent } = props;
  const remaining = Math.max(0, line.qty_target - line.qty_fulfilled);
  const done = remaining === 0;
  const producerPayout = Math.round(
    line.offered_price * (1 - cutPercent / 100),
  );
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '12px',
        padding: '4px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: '12px',
        opacity: done ? 0.55 : 1,
      }}
    >
      <span style={{ flex: 1, color: INK, fontWeight: 'bold' }}>
        {line.good_name}
      </span>
      <span style={{ flex: '0 0 90px', color: INK_SOFT }}>
        {line.qty_fulfilled} / {line.qty_target}
      </span>
      <span
        style={{
          flex: '0 0 110px',
          textAlign: 'right',
          color: done ? INK_FAINT : SEAL_AMBER,
          fontWeight: 'bold',
        }}
      >
        {line.offered_price}m each
      </span>
      <span
        style={{
          flex: '0 0 130px',
          textAlign: 'right',
          color: done ? INK_FAINT : SEAL_GREEN,
          fontStyle: 'italic',
        }}
      >
        you get {producerPayout}m
      </span>
    </div>
  );
};

const ManifestSection = (props: {
  manifest: Manifest;
  cutPercent: number;
}) => {
  const { manifest, cutPercent } = props;
  return (
    <div style={{ marginBottom: '14px' }}>
      <div style={sectionHeaderStyle}>
        {manifest.ship_name}
        <span
          style={{
            color: SEAL_AMBER,
            fontVariant: 'small-caps',
            letterSpacing: '1px',
            fontSize: '11px',
            marginLeft: '8px',
          }}
        >
          {manifest.nationality_id}
        </span>
      </div>
      {manifest.lines.map((line) => (
        <LineRow
          key={line.good}
          line={line}
          cutPercent={cutPercent}
        />
      ))}
    </div>
  );
};

export const ShipFulfillment = () => {
  const { data } = useBackend<Data>();
  const { manifests, middleman_cut_percent } = data;

  return (
    <Window width={560} height={620} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Manifest of Bulk Demands</div>
          <div style={subtitleStyle}>
            Drop matching goods at the crate to fulfill. The Merchant takes
            {' '}
            {middleman_cut_percent}% as middleman.
          </div>
          <div style={rulerStyle} />
          {manifests.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                fontStyle: 'italic',
                color: INK_SOFT,
              }}
            >
              No vessels at the pier are buying. Hail one to open a market.
            </div>
          ) : (
            manifests.map((m) => (
              <ManifestSection
                key={m.ship_id}
                manifest={m}
                cutPercent={middleman_cut_percent}
              />
            ))
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
