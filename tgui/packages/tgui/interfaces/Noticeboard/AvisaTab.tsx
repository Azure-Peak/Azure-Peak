import { useState } from 'react';

import {
  FONT_BODY,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  rulerStyle,
  subTabBarStyle,
  subTabStyle,
  subtitleStyle,
  titleStyle,
} from '../common/parchment';
import { ChartersSection } from './AvisaSections/ChartersSection';
import { EventsSection } from './AvisaSections/EventsSection';
import { HarborSection } from './AvisaSections/HarborSection';
import { MarketSection } from './AvisaSections/MarketSection';
import { ScoutsSection } from './AvisaSections/ScoutsSection';
import { TradeOrdersSection } from './AvisaSections/TradeOrdersSection';
import { type TabProps } from './types';

type AvisaSection =
  | 'charters'
  | 'trade_orders'
  | 'harbor'
  | 'market'
  | 'scouts'
  | 'events'
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
    blurb:
      "The standing edicts of the Crown - their force, their suspension, and the year of their sealing.",
  },
  {
    key: 'trade_orders',
    label: 'Trade Orders',
    blurb:
      "Demands of the realm's merchants and stockpiles, awaiting fulfillment.",
  },
  {
    key: 'harbor',
    label: 'Harbor',
    blurb:
      'Foreign vessels at the pier - their bulk demands and cultural wares brought ashore.',
  },
  {
    key: 'market',
    label: 'Market',
    blurb:
      "The criers' tally of what the realm's buyers hunger for and what they will no longer take.",
  },
  {
    key: 'scouts',
    label: 'Scouts',
    blurb: 'The wardens report on the dangers of each region.',
  },
  {
    key: 'events',
    label: 'Events',
    blurb: 'Shortages and gluts now disturbing the markets.',
  },
  {
    key: 'assembly',
    label: 'Assembly',
    blurb: 'Petitions, summons, and the standing business of the City Assembly.',
  },
];

export const AvisaTab = ({ data, act }: TabProps) => {
  const [section, setSection] = useState<AvisaSection>('charters');
  const active = SECTIONS.find((s) => s.key === section) ?? SECTIONS[0];

  return (
    <>
      <div
        style={{
          ...titleStyle,
          fontSize: '20px',
          marginTop: 6,
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
        {section === 'market' && (
          <button
            type="button"
            title="Open the economy guidebook"
            style={{ ...inkButtonStyle({}), marginLeft: 'auto' }}
            onClick={() => act('help_market')}
          >
            ?
          </button>
        )}
      </div>

      <div
        style={{
          color: INK_SOFT,
          fontStyle: 'italic',
          fontSize: FONT_BODY,
          marginTop: 8,
          marginBottom: 8,
        }}
      >
        {active.blurb}
      </div>

      {section === 'charters' && <ChartersSection data={data} />}
      {section === 'trade_orders' && <TradeOrdersSection data={data} />}
      {section === 'harbor' && <HarborSection data={data} />}
      {section === 'market' && <MarketSection data={data} />}
      {section === 'scouts' && <ScoutsSection data={data} />}
      {section === 'events' && <EventsSection data={data} />}
      {section === 'assembly' && <AssemblySection act={act} />}
    </>
  );
};

const AssemblySection = ({ act }: { act: TabProps['act'] }) => (
  <div style={{ padding: '12px 0', textAlign: 'center' }}>
    <div
      style={{
        color: INK_FAINT,
        fontSize: FONT_BODY,
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
