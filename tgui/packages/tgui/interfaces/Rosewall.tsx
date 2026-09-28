import { Dropdown } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type AdvertEntry = {
  key: string;
  name: string;
  status: string;
  message: string;
  advjob: string;
};

type Data = {
  is_bathhouse: BooleanLike;
  my_key: string;
  message_char_limit: number;
  status_options: string[];
  adverts: AdvertEntry[];
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const STATUS_COLOR: Record<string, string> = {
  Available: SEAL_GREEN,
  Hired: SEAL_AMBER,
  'Do not Disturb': SEAL_RED,
};

const statusSortWeight = (status: string): number => {
  if (status === 'Available') return 0;
  if (status === 'Hired') return 1;
  return 2;
};

const AdvertRow = (props: {
  entry: AdvertEntry;
  isOwn: boolean;
  act: ActFn;
}) => {
  const { entry, isOwn, act } = props;
  const color = STATUS_COLOR[entry.status] || INK_SOFT;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'baseline',
        gap: '8px',
        padding: '4px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
      }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: FONT_BODY, color: INK }}>
          <b>{entry.name}</b>
          {entry.advjob && (
            <span style={{ color: INK_FAINT, fontSize: FONT_BODY }}>
              {' '}
              - {entry.advjob}
            </span>
          )}
        </div>
        {entry.message && (
          <div
            style={{
              fontSize: FONT_BODY,
              fontStyle: 'italic',
              color: INK_SOFT,
            }}
          >
            &ldquo;{entry.message}&rdquo;
          </div>
        )}
      </div>
      <span style={badgeStyle(color)}>{entry.status}</span>
      <button
        type="button"
        style={inkButtonStyle()}
        onClick={() => act('examine_headshot', { key: entry.key })}
      >
        Examine Headshot
      </button>
      {!isOwn && entry.status !== 'Do not Disturb' && (
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => act('send_offer', { key: entry.key })}
        >
          Send Offer
        </button>
      )}
    </div>
  );
};

const OwnControls = (props: {
  myEntry: AdvertEntry | undefined;
  statusOptions: string[];
  act: ActFn;
}) => {
  const { myEntry, statusOptions, act } = props;
  return (
    <div
      style={{
        ...cardStyle,
        display: 'flex',
        alignItems: 'center',
        gap: '12px',
        marginBottom: '8px',
        fontFamily: SERIF,
      }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: FONT_BODY, color: SEAL_AMBER }}>
          Bathhouse registry
        </div>
        <div style={{ fontSize: FONT_BODY, color: INK }}>
          Status:{' '}
          <b style={{ color: STATUS_COLOR[myEntry?.status || ''] || INK }}>
            {myEntry?.status || 'Not Pinned'}
          </b>
        </div>
        {myEntry?.message && (
          <div
            style={{
              fontSize: FONT_BODY,
              fontStyle: 'italic',
              color: INK_SOFT,
            }}
          >
            &ldquo;{myEntry.message}&rdquo;
          </div>
        )}
      </div>
      <Dropdown
        width="150px"
        menuWidth="150px"
        selected={myEntry?.status || statusOptions[0]}
        options={statusOptions}
        onSelected={(value) => act('set_status', { status: value })}
        style={{ margin: 0 }}
      />
      <button
        type="button"
        style={inkButtonStyle()}
        onClick={() => act('edit_advert')}
      >
        {myEntry ? 'Edit Advert' : 'Pin an Advert'}
      </button>
      {myEntry && (
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => act('remove_advert')}
        >
          Take Down
        </button>
      )}
    </div>
  );
};

export const Rosewall = () => {
  const { act, data } = useBackend<Data>();
  const myEntry = data.adverts.find((e) => e.key === data.my_key);
  const sortedAdverts = [...data.adverts].sort(
    (a, b) =>
      statusSortWeight(a.status) - statusSortWeight(b.status) ||
      a.name.localeCompare(b.name),
  );
  return (
    <Window width={620} height={600} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>The Rosewall</div>
          <div style={subtitleStyle}>
            Perfumed slips pinned by the bathhouse&apos;s workers. Peruse, and
            send an offer.
          </div>
          <div style={rulerStyle} />

          {!!data.is_bathhouse && (
            <OwnControls
              myEntry={myEntry}
              statusOptions={data.status_options}
              act={act}
            />
          )}

          <div style={sectionHeaderStyle}>
            Pinned Adverts ({data.adverts.length})
          </div>
          {data.adverts.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                color: INK_SOFT,
              }}
            >
              No adverts have been pinned.
            </div>
          ) : (
            sortedAdverts.map((entry) => (
              <AdvertRow
                key={entry.key}
                entry={entry}
                isOwn={entry.key === data.my_key}
                act={act}
              />
            ))
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
