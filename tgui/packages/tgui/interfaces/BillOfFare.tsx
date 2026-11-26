import {
  type ChangeEvent,
  type CSSProperties,
  type ReactNode,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import { DmIcon, NumberInput } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_BODY,
  FONT_SMALL,
  INK_FAINT,
  INK_SOFT,
  inkInputStyle,
  PriceTag,
  pageStyle,
  rulerStyle,
  SEAL_RED,
  sectionHeaderStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
  tocLinkStyle,
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

type ColumnInfo = {
  key: string;
  label: string;
  cap: number;
};

type CatalogEntry = [
  number,
  string,
  number | null,
  string | null,
  string | null,
];

type Catalog = {
  icon_files: string[];
  entries: CatalogEntry[];
};

type PickEntry = {
  id: number;
  name: string;
  lower: string;
  icon?: string;
  icon_state?: string;
  color?: string | null;
};

type Data = {
  title: string;
  notes: string;
  can_edit: boolean;
  rows: Record<string, Row[]>;
  columns: ColumnInfo[];
  cup: { icon: string; icon_state: string; fill_state: string };
  max_price: number;
  title_len: number;
  line_len: number;
  notes_len: number;
  pen_name_len: number;
  import_len: number;
  export: string;
  signature?: string | null;
  claimed: boolean | number;
  open_to_all: boolean | number;
  is_author: boolean | number;
  foreign_hand: boolean | number;
  signature_mode?: string | null;
  pen_name?: string | null;
  author_name?: string | null;
  author_job?: string | null;
  picker_rows: number;
  catalogs?: Record<string, Catalog>;
};

const ICON_SIZE = 32;
const PRICE_WIDTH = 40;
const REMOVE_WIDTH = 28;

const softHintStyle: CSSProperties = { color: INK_SOFT, fontSize: FONT_SMALL };
const faintHintStyle: CSSProperties = {
  color: INK_FAINT,
  fontSize: FONT_SMALL,
};
const emptyNoteStyle: CSSProperties = { color: INK_FAINT, fontStyle: 'italic' };

const rowsFor = (data: Data, key: string) => data.rows[key] || [];

const iconUrl = (icon: string, state: string) => {
  const ref = Byond.iconRefMap?.[icon];
  return ref ? `${ref}?state=${state}&dir=2&movement=false&frame=1` : '';
};

const useCommittedText = (value: string, onCommit: (text: string) => void) => {
  const [draft, setDraft] = useState(value);
  const focused = useRef(false);
  useEffect(() => {
    if (!focused.current) {
      setDraft(value);
    }
  }, [value]);
  return {
    value: draft,
    onFocus: () => {
      focused.current = true;
    },
    onBlur: () => {
      focused.current = false;
      if (draft !== value) {
        onCommit(draft);
      }
    },
    onChange: (e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) =>
      setDraft(e.target.value),
  };
};

const CommitInput = (props: {
  value: string;
  maxLength: number;
  placeholder?: string;
  style?: CSSProperties;
  onCommit: (text: string) => void;
}) => {
  const { value, maxLength, placeholder, style, onCommit } = props;
  return (
    <input
      type="text"
      maxLength={maxLength}
      placeholder={placeholder}
      style={{ ...inkInputStyle, boxSizing: 'border-box', ...style }}
      {...useCommittedText(value, onCommit)}
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
  return (
    <textarea
      maxLength={maxLength}
      placeholder={placeholder}
      rows={4}
      style={{
        ...inkInputStyle,
        width: '100%',
        boxSizing: 'border-box',
        resize: 'vertical',
      }}
      {...useCommittedText(value, onCommit)}
    />
  );
};

const PriceInput = (props: {
  value: number;
  onChange: (value: number) => void;
}) => {
  const { data } = useBackend<Data>();
  return (
    <NumberInput
      step={1}
      minValue={0}
      maxValue={data.max_price}
      unit="m"
      width={`${PRICE_WIDTH}px`}
      value={props.value}
      onChange={props.onChange}
    />
  );
};

const markBoxStyle: CSSProperties = {
  position: 'relative',
  display: 'inline-flex',
  alignItems: 'center',
  justifyContent: 'center',
  width: `${ICON_SIZE}px`,
  height: `${ICON_SIZE}px`,
  flexShrink: 0,
};

const layerStyle: CSSProperties = {
  position: 'absolute',
  left: 0,
  top: 0,
  width: `${ICON_SIZE}px`,
  height: `${ICON_SIZE}px`,
};

const CupMark = (props: { color: string }) => {
  const { data } = useBackend<Data>();
  const { icon, icon_state, fill_state } = data.cup;
  const url = iconUrl(icon, fill_state);
  return (
    <>
      <DmIcon
        icon={icon}
        icon_state={icon_state}
        width={`${ICON_SIZE}px`}
        height={`${ICON_SIZE}px`}
        style={layerStyle}
      />
      {!!url && (
        <span
          style={{
            ...layerStyle,
            backgroundColor: props.color,
            maskImage: `url("${url}")`,
            WebkitMaskImage: `url("${url}")`,
            maskSize: '100% 100%',
            WebkitMaskSize: '100% 100%',
            maskRepeat: 'no-repeat',
            WebkitMaskRepeat: 'no-repeat',
          }}
        />
      )}
    </>
  );
};

const Mark = (props: {
  icon?: string;
  icon_state?: string;
  color?: string | null;
}) => {
  const { icon, icon_state, color } = props;
  return (
    <span style={markBoxStyle}>
      {icon && icon_state ? (
        <DmIcon
          icon={icon}
          icon_state={icon_state}
          width={`${ICON_SIZE}px`}
          height={`${ICON_SIZE}px`}
        />
      ) : (
        !!color && <CupMark color={color} />
      )}
    </span>
  );
};

const SubLabel = (props: { children: ReactNode }) => (
  <div style={{ ...softHintStyle, margin: '6px 0 2px' }}>{props.children}</div>
);

const usePickEntries = (catalog: Catalog | undefined) =>
  useMemo(() => {
    if (!catalog) {
      return [];
    }
    const entries: PickEntry[] = catalog.entries.map(
      ([id, name, slot, icon_state, color]) => ({
        id,
        name,
        lower: name.toLowerCase(),
        icon: slot ? catalog.icon_files[slot - 1] : undefined,
        icon_state: icon_state ?? undefined,
        color,
      }),
    );
    return entries.sort((a, b) => a.name.localeCompare(b.name));
  }, [catalog]);

const PickRow = (props: {
  action: string;
  onClick: () => void;
  children: ReactNode;
}) => (
  <button
    type="button"
    className="toc-link"
    style={{
      ...tocLinkStyle(false),
      display: 'flex',
      alignItems: 'center',
      gap: '8px',
      fontSize: FONT_BODY,
    }}
    onClick={props.onClick}
  >
    {props.children}
    <span style={{ ...softHintStyle, marginLeft: 'auto', flexShrink: 0 }}>
      {props.action}
    </span>
  </button>
);

const Picker = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState(data.columns[0]?.key);
  const [query, setQuery] = useState('');
  const [price, setPrice] = useState(0);
  const info = data.columns.find((c) => c.key === tab) || data.columns[0];
  const entries = usePickEntries(info ? data.catalogs?.[info.key] : undefined);
  if (!info) {
    return null;
  }

  const full = rowsFor(data, info.key).length >= info.cap;
  const typed = query.trim();
  const needle = typed.toLowerCase();
  const matches = needle
    ? entries.filter((entry) => entry.lower.includes(needle))
    : entries;
  const shown = matches.slice(0, data.picker_rows);

  const addWritten = () => {
    if (!typed || full) {
      return;
    }
    act('add_written', { column: info.key, text: typed, price });
    setQuery('');
  };

  return (
    <div>
      <div style={sectionHeaderStyle}>Add to the menu</div>
      <div style={tabBarStyle}>
        {data.columns.map((c) => (
          <div
            key={c.key}
            style={tabStyle(c.key === info.key)}
            onClick={() => setTab(c.key)}
          >
            {c.label} {rowsFor(data, c.key).length}/{c.cap}
          </div>
        ))}
      </div>

      <SubLabel>Add a pre-existing item, or write your own custom item</SubLabel>
      <input
        type="text"
        value={query}
        maxLength={data.line_len}
        placeholder={`Search ${info.label.toLowerCase()}...`}
        style={{ ...inkInputStyle, width: '100%', boxSizing: 'border-box' }}
        onChange={(e) => setQuery(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === 'Enter') {
            addWritten();
          }
        }}
      />

      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          margin: '6px 0',
        }}
      >
        <span style={softHintStyle}>Price:</span>
        <PriceInput value={price} onChange={setPrice} />
      </div>

      {full ? (
        <div style={emptyNoteStyle}>The {info.label} list is full.</div>
      ) : (
        <div
          style={{
            maxHeight: '380px',
            overflowY: 'auto',
            border: `1px solid ${INK_FAINT}`,
          }}
        >
          {!!typed && (
            <PickRow action="Write it" onClick={addWritten}>
              <span style={{ ...markBoxStyle, color: INK_SOFT }}>✎</span>
              <span style={ellipsisCellStyle}>“{typed}”</span>
            </PickRow>
          )}
          {shown.map((entry) => (
            <PickRow
              key={entry.id}
              action="Add"
              onClick={() =>
                act('add_linked', { column: info.key, id: entry.id, price })
              }
            >
              <Mark
                icon={entry.icon}
                icon_state={entry.icon_state}
                color={entry.color}
              />
              <span style={ellipsisCellStyle}>{entry.name}</span>
            </PickRow>
          ))}
          {matches.length === 0 && (
            <div style={{ padding: '6px 8px', color: INK_FAINT }}>
              Nothing by that name.
            </div>
          )}
          {matches.length > shown.length && (
            <div style={{ ...faintHintStyle, padding: '6px 8px' }}>
              Showing {shown.length} of {matches.length}. Search to narrow it
              down.
            </div>
          )}
        </div>
      )}
    </div>
  );
};

const WriterRow = (props: { row: Row; column: string }) => {
  const { act, data } = useBackend<Data>();
  const { row, column } = props;
  return (
    <div style={denseRowStyle} title={row.desc}>
      <Mark icon={row.icon} icon_state={row.icon_state} color={row.color} />
      <CommitInput
        value={row.name}
        maxLength={data.line_len}
        style={{ flex: 1, minWidth: 0 }}
        onCommit={(text) => act('rename', { column, uid: row.uid, text })}
      />
      <PriceInput
        value={row.price}
        onChange={(value) => act('set_price', { column, uid: row.uid, value })}
      />
      <button
        type="button"
        title="Strike it out"
        style={{ ...compactButtonStyle({}), width: `${REMOVE_WIDTH}px` }}
        onClick={() => act('remove', { column, uid: row.uid })}
      >
        ✕
      </button>
    </div>
  );
};

const WriterList = (props: { info: ColumnInfo }) => {
  const { data } = useBackend<Data>();
  const { key, label, cap } = props.info;
  const rows = rowsFor(data, key);
  return (
    <div>
      <div style={sectionHeaderStyle}>
        {label}
        <span style={{ ...faintHintStyle, float: 'right', fontWeight: 'normal' }}>
          {rows.length} / {cap}
        </span>
      </div>
      {rows.length === 0 ? (
        <div style={{ ...emptyNoteStyle, fontSize: FONT_SMALL }}>
          Nothing yet. Add some on the right!
        </div>
      ) : (
        <>
          <div
            style={{
              ...faintHintStyle,
              display: 'flex',
              gap: '6px',
              padding: '0 6px',
            }}
          >
            <span style={{ width: `${ICON_SIZE}px`, flexShrink: 0 }} />
            <span style={{ flex: 1 }}>Name</span>
            <span style={{ width: `${PRICE_WIDTH}px` }}>Price</span>
            <span style={{ width: `${REMOVE_WIDTH}px` }} />
          </div>
          {rows.map((row) => (
            <WriterRow key={row.uid} row={row} column={key} />
          ))}
        </>
      )}
    </div>
  );
};

const copyBoxStyle: CSSProperties = {
  ...inkInputStyle,
  width: '100%',
  boxSizing: 'border-box',
  resize: 'vertical',
  fontFamily: 'monospace',
  fontSize: FONT_SMALL,
};

const CopyPanel = (props: { canImport: boolean }) => {
  const { act, data } = useBackend<Data>();
  const { canImport } = props;
  const [mode, setMode] = useState<'' | 'out' | 'in'>('');
  const [pasted, setPasted] = useState('');
  const [confirming, setConfirming] = useState(false);
  const hasPaste = !!pasted.trim();
  const toggle = (next: 'out' | 'in') => {
    setMode(mode === next ? '' : next);
    setConfirming(false);
  };
  return (
    <div style={{ marginTop: '14px' }}>
      <div style={{ display: 'flex', gap: '8px' }}>
        <button
          type="button"
          style={compactButtonStyle({})}
          onClick={() => toggle('out')}
        >
          Export
        </button>
        {canImport && (
          <button
            type="button"
            style={compactButtonStyle({})}
            onClick={() => toggle('in')}
          >
            Import
          </button>
        )}
      </div>
      {mode === 'out' && (
        <>
          <SubLabel>Ctrl + A, and then Ctrl + C to copy this menu.</SubLabel>
          <textarea
            readOnly
            rows={8}
            value={data.export}
            style={copyBoxStyle}
            onFocus={(e) => e.currentTarget.select()}
          />
        </>
      )}
      {mode === 'in' && canImport && (
        <>
          <SubLabel>
            Paste a copied menu. It will replace everything currently on the menu.
          </SubLabel>
          <textarea
            rows={8}
            value={pasted}
            maxLength={data.import_len}
            style={copyBoxStyle}
            onChange={(e) => {
              setPasted(e.target.value);
              setConfirming(false);
            }}
          />
          <button
            type="button"
            disabled={!hasPaste}
            style={{
              ...compactButtonStyle({
                color: confirming ? SEAL_RED : undefined,
                disabled: !hasPaste,
              }),
              marginTop: '4px',
            }}
            onClick={() => {
              if (!confirming) {
                setConfirming(true);
                return;
              }
              act('import', { text: pasted });
              setConfirming(false);
            }}
          >
            {confirming ? 'Click again to replace this menu' : 'Replace this menu'}
          </button>
        </>
      )}
    </div>
  );
};

const SignatureLine = (props: { signature?: string | null }) =>
  props.signature ? (
    <div
      style={{
        textAlign: 'right',
        fontStyle: 'italic',
        color: INK_SOFT,
        marginTop: '10px',
      }}
    >
      This Bill of Fare was written by {props.signature}.
    </div>
  ) : null;

const SignaturePanel = () => {
  const { act, data } = useBackend<Data>();
  const [penOpen, setPenOpen] = useState(false);
  if (!data.claimed) {
    return <SubLabel>Writing on it signs it with your name.</SubLabel>;
  }
  if (!data.is_author) {
    return data.open_to_all ? (
      <SubLabel>Anyone may write on this.</SubLabel>
    ) : null;
  }
  const mode = data.signature_mode;
  const showPen = penOpen || mode === 'pen';
  const choices: { key: string; label: string }[] = [
    { key: 'name', label: data.author_name || 'My name' },
  ];
  if (data.author_job) {
    choices.push({ key: 'job', label: `the ${data.author_job}` });
  }
  return (
    <div style={{ margin: '6px 0' }}>
      <div
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          alignItems: 'center',
          gap: '6px',
        }}
      >
        <span style={softHintStyle}>Signed as:</span>
        {choices.map((choice) => (
          <div
            key={choice.key}
            style={tabStyle(!showPen && mode === choice.key)}
            onClick={() => {
              setPenOpen(false);
              act('set_signature', { mode: choice.key });
            }}
          >
            {choice.label}
          </div>
        ))}
        <div style={tabStyle(showPen)} onClick={() => setPenOpen(true)}>
          Another name
        </div>
        {showPen && (
          <CommitInput
            value={data.pen_name || ''}
            maxLength={data.pen_name_len}
            placeholder="Name to sign with"
            style={{ width: '180px' }}
            onCommit={(text) =>
              act('set_signature', { mode: 'pen', text })
            }
          />
        )}
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '6px',
          marginTop: '6px',
        }}
      >
        <div
          style={tabStyle(!!data.open_to_all)}
          onClick={() => act('set_open', { open: !data.open_to_all })}
        >
          Let anyone write on it
        </div>
        <span style={faintHintStyle}>
          {data.open_to_all
            ? 'Unsigned. Anyone with a feather can change it.'
            : `Readers see: written by ${data.signature}.`}
        </span>
      </div>
    </div>
  );
};

const WriterView = () => {
  const { act, data } = useBackend<Data>();
  return (
    <div style={{ display: 'flex', gap: '24px', alignItems: 'flex-start' }}>
      <div style={{ flex: 1, minWidth: 0 }}>
        <SubLabel>Title</SubLabel>
        <CommitInput
          value={data.title}
          maxLength={data.title_len}
          placeholder="Name here"
          style={{ ...titleStyle, width: '100%', display: 'block' }}
          onCommit={(text) => act('set_title', { text })}
        />
        <SignaturePanel />
        {data.columns.map((info) => (
          <WriterList key={info.key} info={info} />
        ))}
        <div style={sectionHeaderStyle}>Notes</div>
        <CommitTextArea
          value={data.notes}
          maxLength={data.notes_len}
          placeholder="Other notes"
          onCommit={(text) => act('set_notes', { text })}
        />
        <CopyPanel canImport />
      </div>
      <div
        style={{
          width: '360px',
          flexShrink: 0,
          position: 'sticky',
          top: 0,
        }}
      >
        <Picker />
      </div>
    </div>
  );
};

const ReaderRow = (props: { row: Row }) => {
  const { row } = props;
  return (
    <div
      title={row.desc}
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '6px',
        padding: '2px 0',
      }}
    >
      <Mark icon={row.icon} icon_state={row.icon_state} color={row.color} />
      <span style={{ ...ellipsisCellStyle, flex: '0 1 auto' }}>{row.name}</span>
      <span
        style={{
          flex: 1,
          minWidth: '16px',
          height: 0,
          borderBottom: `1px dotted ${INK_FAINT}`,
        }}
      />
      <PriceTag price={row.price} />
    </div>
  );
};

const ReaderColumn = (props: { info: ColumnInfo }) => {
  const { data } = useBackend<Data>();
  const { key, label } = props.info;
  const rows = rowsFor(data, key);
  if (rows.length === 0) {
    return null;
  }
  return (
    <div style={{ flex: '1 1 240px', minWidth: 0 }}>
      <div style={sectionHeaderStyle}>{label}</div>
      {rows.map((row) => (
        <ReaderRow key={row.uid} row={row} />
      ))}
    </div>
  );
};

const ReaderView = () => {
  const { data } = useBackend<Data>();
  const blank =
    !data.title &&
    !data.notes &&
    data.columns.every((info) => !rowsFor(data, info.key).length);
  if (blank) {
    return (
      <div style={{ ...emptyNoteStyle, textAlign: 'center' }}>Nothing here.</div>
    );
  }
  return (
    <>
      {!!data.foreign_hand && (
        <div
          style={{ ...emptyNoteStyle, textAlign: 'center', marginBottom: '6px' }}
        >
          This is written by someone else.
        </div>
      )}
      {!!data.title && <div style={titleStyle}>{data.title}</div>}
      <hr style={rulerStyle} />
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: '24px' }}>
        {data.columns.map((info) => (
          <ReaderColumn key={info.key} info={info} />
        ))}
      </div>
      {!!data.notes && (
        <>
          <hr style={rulerStyle} />
          <div
            style={{
              whiteSpace: 'pre-wrap',
              fontStyle: 'italic',
              color: INK_SOFT,
            }}
          >
            {data.notes}
          </div>
        </>
      )}
      <SignatureLine signature={data.signature} />
      <CopyPanel canImport={false} />
    </>
  );
};

export const BillOfFare = () => {
  const { data } = useBackend<Data>();
  const editing = !!data.can_edit;
  return (
    <Window
      title="Bill of Fare"
      width={editing ? 980 : 760}
      height={700}
      theme="parchment"
    >
      <Window.Content scrollable>
        <div style={pageStyle}>{editing ? <WriterView /> : <ReaderView />}</div>
      </Window.Content>
    </Window>
  );
};
