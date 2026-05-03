import { useState } from 'react';

import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_FAINT,
  inkButtonStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
  tabBarStyle,
  tabStyle,
} from '../common/parchment';
import { type PatronRoster, type TabProps } from './types';

export const PatronageTab = ({ data, act }: TabProps) => {
  const fundsWithPatronage = data.funds.filter(
    (f) => f.has_patronage && data.patron_rosters[f.id]?.can_manage,
  );
  const [selectedFundId, setSelectedFundId] = useState<string>(
    fundsWithPatronage[0]?.id ?? '',
  );

  if (!fundsWithPatronage.length) {
    return (
      <div style={cardStyle}>
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
          You hold no patronage authority.
        </div>
      </div>
    );
  }

  const roster = data.patron_rosters[selectedFundId];

  return (
    <div style={cardStyle}>
      {fundsWithPatronage.length > 1 && (
        <div style={tabBarStyle}>
          {fundsWithPatronage.map((f) => (
            <div
              key={f.id}
              style={tabStyle(selectedFundId === f.id)}
              onClick={() => setSelectedFundId(f.id)}
            >
              {f.patron_label}
            </div>
          ))}
        </div>
      )}
      {!!roster && (
        <RosterView fundId={selectedFundId} roster={roster} act={act} />
      )}
    </div>
  );
};

const RosterView = ({
  fundId,
  roster,
  act,
}: {
  fundId: string;
  roster: PatronRoster;
  act: TabProps['act'];
}) => {
  const enrolled = roster.patrons.length;
  const full = enrolled >= roster.cap;

  return (
    <>
      <div style={sectionHeaderStyle}>{roster.label}</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Roster</div>
        <div style={fieldValueStyle}>
          {enrolled} / {roster.cap} enrolled
        </div>
      </div>
      {full && (
        <div style={{ color: SEAL_AMBER, fontStyle: 'italic', marginBottom: 8 }}>
          The roster is full. Revoke an existing patron before drafting a new
          writ.
        </div>
      )}
      {roster.patrons.map((p) => (
        <div key={p.ref} style={fieldRowStyle}>
          <div style={fieldValueStyle}>
            {p.name}
            {p.job ? `, the ${p.job}` : ''}
          </div>
          <button
            type="button"
            style={inkButtonStyle({})}
            onClick={() =>
              act('revoke_patronage', {
                fund_id: fundId,
                target_ref: p.ref,
              })
            }
          >
            Revoke
          </button>
        </div>
      ))}
      <div style={{ marginTop: 10, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: full })}
          disabled={full}
          onClick={() => act('issue_patronage', { fund_id: fundId })}
        >
          Draft Writ
        </button>
      </div>
    </>
  );
};
