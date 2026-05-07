import { useState } from 'react';

import {
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  rulerStyle,
  SEAL_AMBER,
  subTabBarStyle,
  subTabStyle,
  subtitleStyle,
  titleStyle,
} from '../common/parchment';
import { type TabProps } from './types';

type AvisaSection =
  | 'charters'
  | 'trade_orders'
  | 'scouts'
  | 'events'
  | 'blockades'
  | 'assembly';

type SectionMeta = {
  key: AvisaSection;
  label: string;
  blurb: string;
};

const SECTIONS: SectionMeta[] = [
  {
    key: 'charters',
    label: 'Charters',
    blurb: "The standing edicts of the Crown - their force, their suspension, and the year of their sealing.",
  },
  {
    key: 'trade_orders',
    label: 'Trade Orders',
    blurb: "Demands of the realm's merchants and stockpiles, awaiting fulfillment.",
  },
  {
    key: 'scouts',
    label: 'Scouts',
    blurb: "The wardens' last word on the dangers of each region.",
  },
  {
    key: 'events',
    label: 'Events',
    blurb: 'Shortages and gluts now disturbing the markets.',
  },
  {
    key: 'blockades',
    label: 'Blockades',
    blurb: 'Where the trade roads are cut, and by whom.',
  },
  {
    key: 'assembly',
    label: 'Assembly',
    blurb: 'Petitions, summons, and the standing business of the City Assembly.',
  },
];

export const AvisaTab = ({ act }: TabProps) => {
  const [section, setSection] = useState<AvisaSection>('charters');
  const active = SECTIONS.find((s) => s.key === section) ?? SECTIONS[0];

  return (
    <>
      <div
        style={{
          ...titleStyle,
          fontSize: '20px',
          marginTop: 6,
          letterSpacing: '6px',
        }}
      >
        The Azurian Avisa
      </div>
      <div style={subtitleStyle}>
        Tidings, edicts, and trade of the realm
      </div>
      <hr style={rulerStyle} />

      <div style={subTabBarStyle}>
        {SECTIONS.map((s) => (
          <div
            key={s.key}
            style={subTabStyle(section === s.key)}
            onClick={() => setSection(s.key)}
          >
            {s.label}
          </div>
        ))}
      </div>

      <div
        style={{
          color: INK_SOFT,
          fontStyle: 'italic',
          fontSize: '12px',
          marginTop: 8,
          marginBottom: 8,
        }}
      >
        {active.blurb}
      </div>

      {section === 'assembly' ? (
        <AssemblySection act={act} />
      ) : (
        <ScribeStub />
      )}

      <hr style={rulerStyle} />

      {section !== 'assembly' && (
        <div style={{ textAlign: 'center', marginTop: 8 }}>
          <button
            type="button"
            style={inkButtonStyle({})}
            onClick={() => act('open_legacy_board')}
          >
            Open the Old Board
          </button>
        </div>
      )}
    </>
  );
};

const ScribeStub = () => (
  <div
    style={{
      color: SEAL_AMBER,
      fontStyle: 'italic',
      fontSize: '12px',
      textAlign: 'center',
      padding: '24px 0',
    }}
  >
    - the scribe is yet at work on this section -
  </div>
);

const AssemblySection = ({ act }: { act: TabProps['act'] }) => (
  <div style={{ padding: '12px 0', textAlign: 'center' }}>
    <div
      style={{
        color: INK_FAINT,
        fontStyle: 'italic',
        fontSize: '12px',
        marginBottom: 12,
      }}
    >
      The Assembly chamber stands ready for petition and vote.
    </div>
    <button
      type="button"
      style={inkButtonStyle({})}
      onClick={() => act('open_assembly')}
    >
      Open the Assembly
    </button>
  </div>
);
