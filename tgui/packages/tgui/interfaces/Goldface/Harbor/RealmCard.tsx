import {
  BUTTON_BG,
  FONT_BODY,
  INK,
  INK_FAINT,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
} from '../../common/parchment';
import type { HarborRealm, MarketCondition, PoolGood } from '../types';

const toneToColor = (tone?: string) => {
  switch (tone) {
    case 'good':
      return SEAL_GREEN;
    case 'bad':
      return SEAL_RED;
    default:
      return SEAL_AMBER;
  }
};

export const ConditionPill = (props: { condition: MarketCondition }) => {
  const color = toneToColor(props.condition.tone);
  return (
    <span
      title={props.condition.description}
      style={{
        display: 'inline-block',
        padding: '1px 7px',
        marginRight: '4px',
        marginBottom: '2px',
        border: `1px solid ${color}`,
        borderRadius: '8px',
        color: color,
        fontSize: FONT_BODY,
        fontWeight: 'bold',
        whiteSpace: 'nowrap',
      }}
    >
      {props.condition.name}
    </span>
  );
};

export const CategoryPill = (props: { name: string }) => (
  <span
    style={{
      display: 'inline-block',
      padding: '0px 5px',
      marginRight: '3px',
      marginBottom: '2px',
      border: `1px solid ${INK_FAINT}`,
      borderRadius: '3px',
      color: INK,
      background: BUTTON_BG,
      fontSize: FONT_BODY,
      whiteSpace: 'nowrap',
    }}
  >
    {props.name}
  </span>
);

const deltaSuffix = (delta: number) => {
  if (!delta) return '';
  if (delta > 0) return ` ${'+'.repeat(Math.min(delta, 4))}`;
  return ` ${'-'.repeat(Math.min(-delta, 4))}`;
};

export const GoodPill = (props: {
  good: PoolGood;
  rare: boolean;
  color: string;
}) => {
  const { good, rare, color } = props;
  const removed = !!good.removed;
  const addedOnly = !!good.added_only;
  const delta = good.delta || 0;
  const faded = rare || addedOnly;
  const bgAlpha = removed ? 0.45 : faded ? 0.55 : 1;
  const borderAlpha = removed ? 0.5 : faded ? 0.6 : 1;
  const tooltipParts: string[] = [];
  tooltipParts.push(rare ? 'Sometimes' : 'Always');
  if (addedOnly) tooltipParts.push('introduced by an event');
  if (delta > 0)
    tooltipParts.push(`boosted by ${delta} event${delta > 1 ? 's' : ''}`);
  if (delta < 0)
    tooltipParts.push(`suppressed by ${-delta} event${-delta > 1 ? 's' : ''}`);
  if (removed) tooltipParts.push('removed by an event');
  return (
    <span
      title={tooltipParts.join(' - ')}
      style={{
        display: 'inline-block',
        padding: '0px 5px',
        marginRight: '3px',
        marginBottom: '2px',
        border: `1px ${faded ? 'dashed' : 'solid'} color-mix(in srgb, ${color} ${borderAlpha * 100}%, transparent)`,
        borderRadius: '3px',
        color: color,
        background: `color-mix(in srgb, ${BUTTON_BG} ${bgAlpha * 100}%, transparent)`,
        fontWeight: 'bold',
        fontSize: FONT_BODY,
        whiteSpace: 'nowrap',
        textDecoration: removed ? 'line-through' : 'none',
      }}
    >
      {good.name}
      {deltaSuffix(delta)}
    </span>
  );
};

const RowLabel = (props: { children: React.ReactNode; color: string }) => (
  <span
    style={{
      color: props.color,
      fontSize: FONT_BODY,
      fontWeight: 'bold',
      marginRight: '6px',
    }}
  >
    {props.children}
  </span>
);

export const RealmCard = (props: { realm: HarborRealm }) => {
  const { realm } = props;
  return (
    <div style={{ minWidth: 0 }}>
      <div style={{ lineHeight: '1.5', marginBottom: '3px' }}>
        <RowLabel color={SEAL_AMBER}>Demand</RowLabel>
        {realm.demanded_categories.length === 0 ? (
          <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>—</span>
        ) : (
          realm.demanded_categories.map((cat) => (
            <CategoryPill key={cat} name={cat} />
          ))
        )}
      </div>
      <div style={{ lineHeight: '1.5', marginBottom: '3px' }}>
        <RowLabel color={SEAL_GREEN}>Buys</RowLabel>
        {realm.basic_buys.length + realm.rare_buys.length === 0 ? (
          <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>none</span>
        ) : (
          <>
            {realm.basic_buys.map((g) => (
              <GoodPill
                key={`b-${g.name}`}
                good={g}
                rare={false}
                color={SEAL_GREEN}
              />
            ))}
            {realm.rare_buys.map((g) => (
              <GoodPill key={`br-${g.name}`} good={g} rare color={SEAL_GREEN} />
            ))}
          </>
        )}
      </div>
      <div style={{ lineHeight: '1.5' }}>
        <RowLabel color={SEAL_RED}>Sells</RowLabel>
        {realm.basic_sells.length + realm.rare_sells.length === 0 ? (
          <span style={{ color: INK_FAINT, fontStyle: 'italic' }}>none</span>
        ) : (
          <>
            {realm.basic_sells.map((g) => (
              <GoodPill
                key={`s-${g.name}`}
                good={g}
                rare={false}
                color={SEAL_RED}
              />
            ))}
            {realm.rare_sells.map((g) => (
              <GoodPill key={`sr-${g.name}`} good={g} rare color={SEAL_RED} />
            ))}
          </>
        )}
      </div>
    </div>
  );
};
