import {
  BUTTON_BG,
  INK,
  INK_FAINT,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
} from '../../common/parchment';
import type { HarborRealm, MarketCondition } from '../types';

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
        fontSize: '10px',
        fontVariant: 'small-caps',
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
      fontSize: '10px',
      whiteSpace: 'nowrap',
    }}
  >
    {props.name}
  </span>
);

export const GoodPill = (props: {
  name: string;
  rare: boolean;
  color: string;
}) => {
  const { name, rare, color } = props;
  return (
    <span
      title={rare ? 'Sometimes' : 'Always'}
      style={{
        display: 'inline-block',
        padding: '0px 5px',
        marginRight: '3px',
        marginBottom: '2px',
        border: `1px ${rare ? 'dashed' : 'solid'} ${color}`,
        borderRadius: '3px',
        color: color,
        background: rare ? 'rgba(255, 255, 255, 0.55)' : BUTTON_BG,
        fontWeight: 'bold',
        fontSize: '11px',
        whiteSpace: 'nowrap',
      }}
    >
      {name}
    </span>
  );
};

const RowLabel = (props: { children: React.ReactNode; color: string }) => (
  <span
    style={{
      color: props.color,
      fontStyle: 'italic',
      fontSize: '10px',
      fontVariant: 'small-caps',
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
                key={`b-${g}`}
                name={g}
                rare={false}
                color={SEAL_GREEN}
              />
            ))}
            {realm.rare_buys.map((g) => (
              <GoodPill key={`br-${g}`} name={g} rare color={SEAL_GREEN} />
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
                key={`s-${g}`}
                name={g}
                rare={false}
                color={SEAL_RED}
              />
            ))}
            {realm.rare_sells.map((g) => (
              <GoodPill key={`sr-${g}`} name={g} rare color={SEAL_RED} />
            ))}
          </>
        )}
      </div>
    </div>
  );
};

