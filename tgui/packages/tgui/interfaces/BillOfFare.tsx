import { type CSSProperties, useEffect, useMemo, useRef, useState } from 'react';
import { NumberInput } from 'tgui-core/components';

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
  PriceTag,
  pageStyle,
  rulerStyle,
  sectionHeaderStyle,
  titleStyle,
} from './common/parchment';

type Row = {
  uid: number;
  name: string;
  price: number;
  linked: boolean;
  icon?: string;
  icon_state?: string;
  desc?: string;
  color?: string;
};

type CatalogEntry = [number, string];

type ColumnInfo = {
  key: string;
  label: string;
  cap: number;
  catalog: string;
};

type Data = {
  title: string;
  notes: string;
  can_edit: boolean;
  rows: Record<string, Row[]>;
  columns: ColumnInfo[];
  max_price: number;
  title_len: number;
  line_len: number;
  notes_len: number;
  search_min: number;
  search_results: number;
  catalogs?: Record<string, CatalogEntry[]>;
};

const useCommittedText = (value: string) => {
  const [draft, setDraft] = useState(value);
  const focused = useRef(false);
  useEffect(() => {
    if (!focused.current) {
      setDraft(value);
    }
  }, [value]);
  return { draft, setDraft, focused };
};

const CommitInput = (props: {
  value: string;
  maxLength: number;
  placeholder?: string;
  style?: CSSProperties;
  onCommit: (text: string) => void;
}) => {
  const { value, maxLength, placeholder, style, onCommit } = props;
  const { draft, setDraft, focused } = useCommittedText(value);
  return (
    <input
      type="text"
      value={draft}
      maxLength={maxLength}
      placeholder={placeholder}
      style={{ ...inkInputStyle, boxSizing: 'border-box', ...style }}
      onFocus={() => {
        focused.current = true;
      }}
      onBlur={() => {
        focused.current = false;
        if (draft !== value) {
          onCommit(draft);
        }
      }}
      onChange={(e) => setDraft(e.target.value)}
      onKeyDown={(e) => {
        if (e.key === 'Enter') {
          e.currentTarget.blur();
        }
      }}
    />
  );
};

const CommitTextArea = (props: {
  value: string;
  maxLength: number;
  placeholder?: string;
  onCommit: (text: string) => void;
}) => {
  const { value, maxLength, placeholder, onCommit } = props;
  const { draft, setDraft, focused } = useCommittedText(value);
  return (
    <textarea
      value={draft}
      maxLength={maxLength}
      placeholder={placeholder}
      rows={4}
      style={{
        ...inkInputStyle,
        width: '100%',
        boxSizing: 'border-box',
        resize: 'vertical',
      }}
      onFocus={() => {
        focused.current = true;
      }}
      onBlur={() => {
        focused.current = false;
        if (draft !== value) {
          onCommit(draft);
        }
      }}
      onChange={(e) => setDraft(e.target.value)}
    />
  );
};

const ReaderRow = (props: { row: Row }) => {
  const { row } = props;
  return (
    <div style={denseRowStyle}>
      <div style={ellipsisCellStyle}>{row.name}</div>
      <PriceTag price={row.price} />
    </div>
  );
};

const WriterRow = (props: { row: Row; column: string }) => {
  const { act, data } = useBackend<Data>();
  const { row, column } = props;
  return (
    <div style={denseRowStyle}>
      <CommitInput
        value={row.name}
        maxLength={data.line_len}
        style={{ flex: 1, minWidth: 0 }}
        onCommit={(text) => act('rename', { column, uid: row.uid, text })}
      />
      <NumberInput
        step={1}
        minValue={0}
        maxValue={data.max_price}
        unit="m"
        width="60px"
        value={row.price}
        onChange={(value: number) =>
          act('set_price', { column, uid: row.uid, value })
        }
      />
      <button
        type="button"
        title="Strike it out"
        style={compactButtonStyle({})}
        onClick={() => act('remove', { column, uid: row.uid })}
      >
        ✕
      </button>
    </div>
  );
};

const AddBox = (props: {
  column: string;
  catalog: CatalogEntry[];
  full: boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const { column, catalog, full } = props;
  const [query, setQuery] = useState('');
  const lowered = useMemo(
    () =>
      catalog.map(([id, name]) => [id, name, name.toLowerCase()] as const),
    [catalog],
  );
  const typed = query.trim();
  const needle = typed.toLowerCase();
  const matches =
    needle.length >= data.search_min
      ? lowered
          .filter(([, , low]) => low.includes(needle))
          .slice(0, data.search_results)
      : [];

  const addWritten = () => {
    if (!typed || full) {
      return;
    }
    act('add_written', { column, text: typed });
    setQuery('');
  };

  if (full) {
    return (
      <div style={{ color: INK_FAINT, fontSize: FONT_SMALL, marginTop: '6px' }}>
        There is no room for more.
      </div>
    );
  }

  return (
    <div style={{ marginTop: '6px' }}>
      <input
        type="text"
        value={query}
        maxLength={data.line_len}
        placeholder="Find or write a line..."
        style={{ ...inkInputStyle, width: '100%', boxSizing: 'border-box' }}
        onChange={(e) => setQuery(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === 'Enter') {
            addWritten();
          }
        }}
      />
      {!!typed && (
        <div style={{ maxHeight: '12em', overflowY: 'auto' }}>
          <div
            style={{ ...denseRowStyle, cursor: 'pointer', color: INK_SOFT }}
            onClick={addWritten}
          >
            <span style={ellipsisCellStyle}>Write: {typed}</span>
          </div>
          {matches.map(([id, name]) => (
            <div
              key={id}
              style={{ ...denseRowStyle, cursor: 'pointer' }}
              onClick={() => {
                act('add_linked', { column, id });
                setQuery('');
              }}
            >
              <span style={ellipsisCellStyle}>{name}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

const FareColumn = (props: { info: ColumnInfo }) => {
  const { data } = useBackend<Data>();
  const { key: column, label, cap } = props.info;
  const rows = data.rows[column] || [];
  const catalog = data.catalogs?.[props.info.catalog];
  const editing = !!data.can_edit;
  return (
    <div style={{ flex: '1 1 240px', minWidth: 0 }}>
      <div style={sectionHeaderStyle}>
        {label}
        {editing && (
          <span
            style={{
              float: 'right',
              color: INK_FAINT,
              fontSize: FONT_SMALL,
              fontWeight: 'normal',
            }}
          >
            {rows.length} / {cap}
          </span>
        )}
      </div>
      {rows.length === 0 && !editing && (
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>None.</div>
      )}
      {rows.map((row) =>
        editing ? (
          <WriterRow key={row.uid} row={row} column={column} />
        ) : (
          <ReaderRow key={row.uid} row={row} />
        ),
      )}
      {editing && (
        <AddBox
          column={column}
          catalog={catalog || []}
          full={rows.length >= cap}
        />
      )}
    </div>
  );
};

export const BillOfFare = () => {
  const { act, data } = useBackend<Data>();
  const editing = !!data.can_edit;
  return (
    <Window title="Bill of Fare" width={960} height={660} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          {editing ? (
            <CommitInput
              value={data.title}
              maxLength={data.title_len}
              placeholder="Title"
              style={{ ...titleStyle, width: '100%', display: 'block' }}
              onCommit={(text) => act('set_title', { text })}
            />
          ) : (
            !!data.title && <div style={titleStyle}>{data.title}</div>
          )}
          <hr style={rulerStyle} />
          <div style={{ display: 'flex', flexWrap: 'wrap', gap: '24px' }}>
            {data.columns.map((info) => (
              <FareColumn key={info.key} info={info} />
            ))}
          </div>
          {(editing || !!data.notes) && <hr style={rulerStyle} />}
          {editing ? (
            <CommitTextArea
              value={data.notes}
              maxLength={data.notes_len}
              placeholder="Notes"
              onCommit={(text) => act('set_notes', { text })}
            />
          ) : (
            !!data.notes && (
              <div
                style={{
                  whiteSpace: 'pre-wrap',
                  fontStyle: 'italic',
                  color: INK_SOFT,
                }}
              >
                {data.notes}
              </div>
            )
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
