import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_SMALL,
  INK_FAINT,
  INK_SOFT,
  inkInputStyle,
  pageStyle,
  rulerStyle,
  sectionHeaderStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type HeldMail = {
  ref: string;
  name: string;
  recipient: string | null;
  sender: string | null;
};

type Data = {
  mail: HeldMail[];
  can_take: boolean;
};

type Recipient = {
  name: string;
  items: HeldMail[];
};

const groupByRecipient = (mail: HeldMail[]): Recipient[] => {
  const groups: Record<string, HeldMail[]> = {};
  for (const item of mail) {
    const name = item.recipient || 'Unknown';
    if (!groups[name]) {
      groups[name] = [];
    }
    groups[name].push(item);
  }
  return Object.keys(groups)
    .sort((a, b) => a.localeCompare(b))
    .map((name) => ({ name, items: groups[name] }));
};

const MailRow = (props: { item: HeldMail; canTake: boolean }) => {
  const { act } = useBackend<Data>();
  const { item, canTake } = props;
  return (
    <div style={denseRowStyle}>
      <span style={ellipsisCellStyle}>
        {item.name}
        {item.sender && (
          <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>
            {' '}
            - from {item.sender}
          </span>
        )}
      </span>
      {canTake && (
        <button
          type="button"
          style={compactButtonStyle()}
          onClick={() => act('take', { ref: item.ref })}
        >
          Take
        </button>
      )}
    </div>
  );
};

export const MasterOfMails = () => {
  const { data } = useBackend<Data>();
  const { mail, can_take } = data;
  const [search, setSearch] = useState('');

  const recipients = groupByRecipient(mail);
  const query = search.trim().toLowerCase();
  const shown = query
    ? recipients.filter((r) => r.name.toLowerCase().includes(query))
    : recipients;

  return (
    <Window width={480} height={600} title="Master of Mails" theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Master of Mails</div>
          <div style={subtitleStyle}>
            {mail.length} piece{mail.length === 1 ? '' : 's'} of mail for{' '}
            {recipients.length} recipient{recipients.length === 1 ? '' : 's'}
          </div>
          <hr style={rulerStyle} />
          <input
            type="text"
            value={search}
            placeholder="Search by name..."
            style={{ ...inkInputStyle, width: '100%', boxSizing: 'border-box' }}
            onChange={(e) => setSearch(e.target.value)}
          />
          {shown.length === 0 && (
            <div
              style={{
                color: INK_FAINT,
                fontStyle: 'italic',
                textAlign: 'center',
                marginTop: '12px',
              }}
            >
              {mail.length === 0 ? 'No mail is held.' : 'No one by that name.'}
            </div>
          )}
          {shown.map((recipient) => (
            <div key={recipient.name}>
              <div style={sectionHeaderStyle}>
                {recipient.name}
                <span
                  style={{
                    color: INK_SOFT,
                    fontSize: FONT_SMALL,
                    fontWeight: 'normal',
                  }}
                >
                  {' '}
                  ({recipient.items.length})
                </span>
              </div>
              {recipient.items.map((item) => (
                <MailRow key={item.ref} item={item} canTake={can_take} />
              ))}
            </div>
          ))}
        </div>
      </Window.Content>
    </Window>
  );
};
