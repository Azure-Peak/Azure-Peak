import {
  cardStyle,
  INK_FAINT,
  INK_SOFT,
  sectionHeaderStyle,
  SERIF,
} from '../../common/parchment';
import { NationRow } from './NationRow';
import type { HarborNation } from '../types';

const HeaderStrip = () => (
  <div
    style={{
      display: 'flex',
      alignItems: 'center',
      gap: '12px',
      padding: '4px 8px',
      borderBottom: `1px solid ${INK_FAINT}`,
      fontFamily: SERIF,
      fontSize: '10px',
      fontVariant: 'small-caps',
      letterSpacing: '2px',
      color: INK_SOFT,
    }}
  >
    <div style={{ flex: '0 0 16px' }}>&nbsp;</div>
    <div style={{ flex: '0 0 140px' }}>Nation</div>
    <div style={{ flex: 1 }}>Cultural Goods</div>
    <div style={{ flex: '0 0 200px', textAlign: 'right' }}>
      Market Conditions
    </div>
  </div>
);

export const NationsView = (props: { nations: HarborNation[] }) => {
  const { nations } = props;
  if (nations.length === 0) {
    return (
      <div
        style={{
          ...cardStyle,
          textAlign: 'center',
          fontStyle: 'italic',
          color: INK_SOFT,
        }}
      >
        No foreign nations recorded.
      </div>
    );
  }
  return (
    <>
      <div style={sectionHeaderStyle}>Foreign Nations ({nations.length})</div>
      <HeaderStrip />
      {nations.map((n) => (
        <NationRow key={n.id} nation={n} />
      ))}
    </>
  );
};
