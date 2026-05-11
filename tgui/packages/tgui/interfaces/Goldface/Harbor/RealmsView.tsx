import {
  cardStyle,
  INK_FAINT,
  INK_SOFT,
  sectionHeaderStyle,
  SERIF,
} from '../../common/parchment';
import type { HarborRealm } from '../types';
import { RealmRow } from './RealmRow';

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
    <div style={{ flex: '0 0 130px' }}>Realm</div>
    <div style={{ flex: 1 }}>Typical Trade</div>
    <div style={{ flex: '0 0 180px', textAlign: 'right' }}>
      Market Conditions
    </div>
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
          fontStyle: 'italic',
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
