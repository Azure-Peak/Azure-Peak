import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  pageStyle,
  rulerStyle,
  subtitleStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';
import { AvisaTab } from './Noticeboard/AvisaTab';
import { PostingsTab } from './Noticeboard/PostingsTab';
import { RosterTab } from './Noticeboard/RosterTab';
import { type NoticeboardData, type TabKey } from './Noticeboard/types';

export const Noticeboard = () => {
  const { data, act } = useBackend<NoticeboardData>();
  const [tab, setTab] = useState<TabKey>('postings');

  return (
    <Window title="Noticeboard" width={1000} height={760} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>The Notice Board</div>
          <div style={subtitleStyle}>
            of {data.realm_name || 'the realm'} &middot; postings of the realm and her commons
          </div>
          <hr style={rulerStyle} />

          <div style={tabBarStyle}>
            <div
              style={tabStyle(tab === 'postings')}
              onClick={() => setTab('postings')}
            >
              Postings
            </div>
            <div
              style={tabStyle(tab === 'avisa')}
              onClick={() => setTab('avisa')}
            >
              The Avisa
            </div>
            <div
              style={tabStyle(tab === 'roster')}
              onClick={() => setTab('roster')}
            >
              Mercenary Roster
            </div>
          </div>

          {tab === 'postings' && <PostingsTab data={data} act={act} />}
          {tab === 'avisa' && <AvisaTab data={data} act={act} />}
          {tab === 'roster' && <RosterTab data={data} act={act} />}
        </div>
      </Window.Content>
    </Window>
  );
};
