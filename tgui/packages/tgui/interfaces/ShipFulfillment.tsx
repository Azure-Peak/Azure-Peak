import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SERIF,
  sectionHeaderStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type DemandLine = {
  good: string;
  good_name: string;
  qty_target: number;
  qty_fulfilled: number;
  offered_price: number;
  kin_offered_price?: number;
  tag?: string;
};

type Manifest = {
  ship_id: string;
  ship_name: string;
  realm_id: string;
  is_kin?: BooleanLike;
  typical_provisions?: string;
  lines: DemandLine[];
};

type Data = {
  manifests: Manifest[];
  middleman_cut_percent: number;
  kinship_sell_pct?: number;
  can_manage?: BooleanLike;
  duty_suspended?: BooleanLike;
  duty_rate_pct?: number;
  duty_collected_here?: number;
  duty_evaded_here?: number;
};

const TAG_VICTUALLING_FRESH = 'victualling_fresh';
const TAG_VICTUALLING_PRESERVED = 'victualling_preserved';
const TAG_VICTUALLING_DRINKS = 'victualling_drinks';

const SUBSECTION_LABELS: Record<string, string> = {
  bulk: 'Bulk Trade',
  [TAG_VICTUALLING_FRESH]: 'Victualling - Fresh',
  [TAG_VICTUALLING_PRESERVED]: 'Victualling - Preserved',
  [TAG_VICTUALLING_DRINKS]: 'Victualling - Drinks',
};

const SUBSECTION_HINT: Record<string, string> = {
  bulk: 'Bulk demand for the ship to carry back home.',
  [TAG_VICTUALLING_FRESH]: 'Fresh provisions for the crew.',
  [TAG_VICTUALLING_PRESERVED]: 'Preserved foods for the voyage.',
  [TAG_VICTUALLING_DRINKS]:
    'Drinks for the crews and to resell back home. Sold by the keg - drag a finished, untapped fermentation keg onto the crate. Loose bottles are refused.',
};

const SUBSECTION_ORDER = [
  'bulk',
  TAG_VICTUALLING_FRESH,
  TAG_VICTUALLING_PRESERVED,
  TAG_VICTUALLING_DRINKS,
];

const SUBSECTION_GROUP: Record<string, 'goods' | 'food' | 'drinks'> = {
  bulk: 'goods',
  [TAG_VICTUALLING_FRESH]: 'food',
  [TAG_VICTUALLING_PRESERVED]: 'food',
  [TAG_VICTUALLING_DRINKS]: 'drinks',
};

const GROUP_LABEL: Record<'goods' | 'food' | 'drinks', string> = {
  goods: 'Goods',
  food: 'Food',
  drinks: 'Drinks',
};

const GroupDivider = (props: { label: string }) => (
  <div
    style={{
      display: 'flex',
      alignItems: 'center',
      gap: '8px',
      margin: '10px 0 4px',
    }}
  >
    <div style={{ flex: 1, borderTop: `1px dashed ${PARCHMENT_SHADOW}` }} />
    <span
      style={{
        color: SEAL_AMBER,
        fontFamily: SERIF,
        fontWeight: 'bold',
        fontSize: FONT_BODY,
        letterSpacing: '2px',
      }}
    >
      {props.label}
    </span>
    <div style={{ flex: 1, borderTop: `1px dashed ${PARCHMENT_SHADOW}` }} />
  </div>
);

const LineRow = (props: { line: DemandLine; cutPercent: number }) => {
  const { line, cutPercent } = props;
  const remaining = Math.max(0, line.qty_target - line.qty_fulfilled);
  const done = remaining === 0;
  const hasKin =
    line.kin_offered_price !== undefined &&
    line.kin_offered_price > line.offered_price;
  const effectivePrice = hasKin
    ? (line.kin_offered_price as number)
    : line.offered_price;
  const producerPayout = Math.round(effectivePrice * (1 - cutPercent / 100));
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '12px',
        padding: '4px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
        opacity: done ? 0.55 : 1,
      }}
      title={
        hasKin
          ? `${effectivePrice}m each (Kinship +${effectivePrice - line.offered_price}m over base ${line.offered_price}m)`
          : undefined
      }
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
          fontWeight: 'bold',
        }}
      >
        {hasKin && (
          <span
            style={{
              color: INK_FAINT,
              textDecoration: 'line-through',
              marginRight: '4px',
              fontWeight: 'normal',
            }}
          >
            {line.offered_price}m
          </span>
        )}
        <span
          style={{ color: done ? INK_FAINT : hasKin ? SEAL_GREEN : SEAL_AMBER }}
        >
          {effectivePrice}m each
        </span>
      </span>
      <span
        style={{
          flex: '0 0 130px',
          textAlign: 'right',
          color: done ? INK_FAINT : SEAL_GREEN,
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
          color: SEAL_AMBER,
          fontSize: FONT_BODY,
          marginBottom: '2px',
        }}
      >
        {SUBSECTION_LABELS[tag] || tag}
      </div>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: FONT_BODY,
          fontStyle: 'italic',
          color: INK_FAINT,
          marginBottom: '4px',
        }}
      >
        {SUBSECTION_HINT[tag] || ''}
      </div>
      {lines.map((line) => (
        <LineRow
          key={`${tag}|${line.good}`}
          line={line}
          cutPercent={cutPercent}
        />
      ))}
    </div>
  );
};

const ManifestSection = (props: { manifest: Manifest; cutPercent: number }) => {
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
            fontSize: FONT_BODY,
            marginLeft: '8px',
          }}
        >
          {manifest.realm_id}
        </span>
        {!!manifest.is_kin && (
          <span
            title="Kin ship - bulk demand payouts get the Kinship bonus"
            style={{
              marginLeft: '6px',
              padding: '0 6px',
              border: `1px solid ${SEAL_GREEN}`,
              borderRadius: '8px',
              color: SEAL_GREEN,
              fontSize: FONT_BODY,
              fontWeight: 'bold',
              letterSpacing: '0.5px',
              verticalAlign: 'middle',
            }}
          >
            KIN
          </span>
        )}
      </div>
      {!!manifest.typical_provisions && (
        <div
          style={{
            fontFamily: SERIF,
            fontSize: FONT_BODY,
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
      {(() => {
        const renderable = SUBSECTION_ORDER.filter(
          (tag) => (grouped[tag] || []).length > 0,
        );
        let lastGroup: 'goods' | 'food' | 'drinks' | null = null;
        return renderable.map((tag) => {
          const group = SUBSECTION_GROUP[tag];
          const insertDivider = group !== lastGroup;
          lastGroup = group;
          return (
            <div key={tag}>
              {insertDivider && <GroupDivider label={GROUP_LABEL[group]} />}
              <Subsection
                tag={tag}
                lines={grouped[tag] || []}
                cutPercent={cutPercent}
              />
            </div>
          );
        });
      })()}
    </div>
  );
};

const Underledger = () => {
  const { data, act } = useBackend<Data>();
  const {
    duty_suspended,
    duty_rate_pct = 0,
    duty_collected_here = 0,
    duty_evaded_here = 0,
  } = data;
  return (
    <div style={{ ...cardStyle, marginTop: '14px', borderColor: SEAL_AMBER }}>
      <div style={{ ...sectionHeaderStyle, color: SEAL_AMBER }}>
        Underledger
      </div>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: '11px',
          fontStyle: 'italic',
          color: INK_SOFT,
          marginBottom: '6px',
        }}
      >
        Export duty runs {duty_rate_pct}%. Dodging keeps it off the goods sold
        here. The shortfall is only known to the Merchant or Shophand. The Crown
        must guess.
      </div>
      <button
        type="button"
        style={inkButtonStyle({ color: duty_suspended ? '#a00' : undefined })}
        onClick={() => act('toggle_duty')}
      >
        Crown Duty: {duty_suspended ? 'DODGING' : 'PAYING'}
      </button>
      <div
        style={{
          fontFamily: SERIF,
          fontSize: '11px',
          color: INK_SOFT,
          marginTop: '6px',
        }}
      >
        Paid here: {duty_collected_here}m. Dodged here: {duty_evaded_here}m.
      </div>
    </div>
  );
};

export const ShipFulfillment = () => {
  const { data, act } = useBackend<Data>();
  const { manifests, middleman_cut_percent, can_manage } = data;

  return (
    <Window width={620} height={680} theme="parchment">
      <Window.Content scrollable>
        <div style={{ ...pageStyle, position: 'relative' }}>
          <button
            type="button"
            title="Open the economy guidebook"
            style={{
              ...inkButtonStyle({}),
              position: 'absolute',
              top: 8,
              right: 8,
            }}
            onClick={() => act('help')}
          >
            ?
          </button>
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
          {!!can_manage && <Underledger />}
        </div>
      </Window.Content>
    </Window>
  );
};
