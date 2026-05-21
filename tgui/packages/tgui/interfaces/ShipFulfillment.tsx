import { useBackend } from '../backend';
import { Window } from '../layouts';
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
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type DemandLine = {
  good: string;
  good_name: string;
  qty_target: number;
  qty_fulfilled: number;
  offered_price: number;
  tag?: string;
};

type Manifest = {
  ship_id: string;
  ship_name: string;
  realm_id: string;
  typical_provisions?: string;
  lines: DemandLine[];
};

type Data = {
  manifests: Manifest[];
  middleman_cut_percent: number;
};

const TAG_VICTUALLING_FRESH = 'victualling_fresh';
const TAG_VICTUALLING_PRESERVED = 'victualling_preserved';
const TAG_VICTUALLING_ALCOHOL = 'victualling_alcohol';

const SUBSECTION_LABELS: Record<string, string> = {
  bulk: 'Bulk Trade',
  [TAG_VICTUALLING_FRESH]: 'Victualling - Fresh',
  [TAG_VICTUALLING_PRESERVED]: 'Victualling - Preserved',
  [TAG_VICTUALLING_ALCOHOL]: 'Victualling - Alcohol',
};

const SUBSECTION_HINT: Record<string, string> = {
  bulk: 'Realm bulk demand. Larger payouts, ship-specific.',
  [TAG_VICTUALLING_FRESH]:
    'Crew shore-leave provisions. Each line caps low - no dumping.',
  [TAG_VICTUALLING_PRESERVED]:
    'Voyage hardtack and salted stores. Each line caps low - no dumping.',
  [TAG_VICTUALLING_ALCOHOL]:
    'Sealed brewer bottles only. Uncorked stock is refused.',
};

const SUBSECTION_ORDER = [
  'bulk',
  TAG_VICTUALLING_FRESH,
  TAG_VICTUALLING_PRESERVED,
  TAG_VICTUALLING_ALCOHOL,
];

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

const Subsection = (props: {
  tag: string;
  lines: DemandLine[];
  cutPercent: number;
}) => {
  const { tag, lines, cutPercent } = props;
  if (lines.length === 0) return null;
  return (
    <div style={{ marginTop: '6px' }}>
      <div
        style={{
          fontFamily: SERIF,
          fontVariant: 'small-caps',
          color: SEAL_AMBER,
          fontStyle: 'italic',
          fontSize: '11px',
          marginBottom: '2px',
        }}
      >
        {SUBSECTION_LABELS[tag] || tag}
      </div>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: '10px',
          fontStyle: 'italic',
          color: INK_FAINT,
          marginBottom: '4px',
        }}
      >
        {SUBSECTION_HINT[tag] || ''}
      </div>
      {lines.map((line) => (
        <LineRow key={`${tag}|${line.good}`} line={line} cutPercent={cutPercent} />
      ))}
    </div>
  );
};

const ManifestSection = (props: {
  manifest: Manifest;
  cutPercent: number;
}) => {
  const { manifest, cutPercent } = props;
  const grouped: Record<string, DemandLine[]> = {};
  for (const line of manifest.lines) {
    const key = line.tag || 'bulk';
    if (!grouped[key]) grouped[key] = [];
    grouped[key].push(line);
  }
  return (
    <div style={{ marginBottom: '14px' }}>
      <div style={sectionHeaderStyle}>
        {manifest.ship_name}
        <span
          style={{
            color: SEAL_AMBER,
            fontVariant: 'small-caps',
            fontSize: '11px',
            marginLeft: '8px',
          }}
        >
          {manifest.realm_id}
        </span>
      </div>
      {!!manifest.typical_provisions && (
        <div
          style={{
            fontFamily: SERIF,
            fontSize: '11px',
            fontStyle: 'italic',
            color: INK_SOFT,
            marginTop: '2px',
            marginBottom: '6px',
            paddingLeft: '4px',
            borderLeft: `2px solid ${PARCHMENT_SHADOW}`,
          }}
        >
          Typical provisions: {manifest.typical_provisions}
        </div>
      )}
      {SUBSECTION_ORDER.map((tag) => (
        <Subsection
          key={tag}
          tag={tag}
          lines={grouped[tag] || []}
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
    <Window width={620} height={680} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Manifest of Bulk Demands</div>
          <div style={subtitleStyle}>
            Drop matching goods at the crate to fulfill. The Merchant takes{' '}
            {middleman_cut_percent}% as middleman.
          </div>
          <div style={rulerStyle} />
          {manifests.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
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
