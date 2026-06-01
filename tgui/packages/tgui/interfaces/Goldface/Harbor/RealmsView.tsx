import {
  cardStyle,
  FONT_BODY,
  INK_FAINT,
  INK_SOFT,
  sectionHeaderStyle,
  SERIF,
} from '../../common/parchment';
import type { HarborRealm } from '../types';
import { REALM_GRID_COLUMNS, RealmRow } from './RealmRow';

const HeaderStrip = () => (
  <div
    style={{
      display: 'grid',
      gridTemplateColumns: REALM_GRID_COLUMNS,
      alignItems: 'baseline',
      columnGap: '8px',
      padding: '4px 6px',
      borderBottom: `1px solid ${INK_FAINT}`,
      fontFamily: SERIF,
      fontSize: FONT_BODY,
      color: INK_SOFT,
    }}
  >
    <div>&nbsp;</div>
    <div>Realm / Conditions</div>
    <div>Demand / Buys / Sells</div>
  </div>
);

export const RealmsView = (props: { realms: HarborRealm[] }) => {
  const { realms } = props;
  if (realms.length === 0) {
    return (
      <div
        style={{
          ...cardStyle,
          textAlign: 'center',
          color: INK_SOFT,
        }}
      >
        No foreign realms recorded.
      </div>
    );
  }
  return (
    <>
      <div style={sectionHeaderStyle}>Foreign Realms ({realms.length})</div>
      <HeaderStrip />
      {realms.map((r) => (
        <RealmRow key={r.id} realm={r} />
      ))}
    </>
  );
};
