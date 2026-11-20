import {
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
  price?: number;
  prices?: Record<string, number>;
  linked: boolean;
  icon?: string;
  icon_state?: string;
  desc?: string;
  color?: string;
};

type VesselPrices = Record<string, number | null>;

type ColumnInfo = {
  key: string;
  label: string;
  cap: number;
  catalog: string;
  vessels: boolean | number;
};

type Vessel = {
  key: string;
  label: string;
  capacity: number;
  icon: string;
  icon_state: string;
  fill_icon: string;
  fill_state: string;
  fill_under: boolean | number;
  top_state?: string;
};

type FoodEntry = [number, string, number, string];

type DrinkEntry = [number, string, string | null];

type Catalogs = {
  icon_files: string[];
  food: FoodEntry[];
  drink: DrinkEntry[];
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
  vessels: Vessel[];
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
  catalogs?: Catalogs;
};

const ICON_SIZE = 32;
const SWATCH_SIZE = 12;
const PRICE_WIDTH = 40;
const VESSEL_CELL_WIDTH = 104;
const REMOVE_WIDTH = 28;

const iconUrl = (icon: string, state: string) => {
  const ref = Byond.iconRefMap?.[icon];
  return ref ? `${ref}?state=${state}&dir=2&movement=false&frame=1` : '';
};

const isOffered = (prices: VesselPrices | undefined, key: string) =>
  typeof prices?.[key] === 'number';

const offeredVessels = (vessels: Vessel[], prices?: VesselPrices) =>
  vessels.filter((vessel) => isOffered(prices, vessel.key));

const initialVesselPrices = (vessels: Vessel[]) => {
  const prices: VesselPrices = {};
  vessels.forEach((vessel, index) => {
    prices[vessel.key] = index === 0 ? 0 : null;
  });
  return prices;
};

const offeredPrices = (prices: VesselPrices) => {
  const offered: Record<string, number> = {};
  for (const key of Object.keys(prices)) {
    const value = prices[key];
    if (typeof value === 'number') {
      offered[key] = value;
    }
  }
  return offered;
};

const capacityNote = (vessels: Vessel[]) =>
  vessels.map((vessel) => `${vessel.label}: ${vessel.capacity} drams`).join(' · ');

const toggleChipStyle = (on: boolean): CSSProperties => ({
  ...tabStyle(on),
  display: 'flex',
  alignItems: 'center',
  gap: '2px',
  padding: '0 6px 0 0',
});

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

const SpriteLayer = (props: { icon: string; state: string }) => (
  <DmIcon
    icon={props.icon}
    icon_state={props.state}
    width={`${ICON_SIZE}px`}
    height={`${ICON_SIZE}px`}
    style={layerStyle}
  />
);

const FillLayer = (props: { url: string; color: string }) => (
  <span
    style={{
      ...layerStyle,
      backgroundColor: props.color,
      maskImage: `url("${props.url}")`,
      WebkitMaskImage: `url("${props.url}")`,
      maskSize: '100% 100%',
      WebkitMaskSize: '100% 100%',
      maskRepeat: 'no-repeat',
      WebkitMaskRepeat: 'no-repeat',
    }}
  />
);

const VesselMark = (props: { vessel: Vessel; color?: string | null }) => {
  const { vessel, color } = props;
  const url = color ? iconUrl(vessel.fill_icon, vessel.fill_state) : '';
  const fill = !!url && !!color && <FillLayer url={url} color={color} />;
  return (
    <span style={markBoxStyle}>
      {!!vessel.fill_under && fill}
      <SpriteLayer icon={vessel.icon} state={vessel.icon_state} />
      {!vessel.fill_under && fill}
      {!!vessel.top_state && (
        <SpriteLayer icon={vessel.icon} state={vessel.top_state} />
      )}
    </span>
  );
};

const Mark = (props: {
  kind: string;
  icon?: string;
  icon_state?: string;
  color?: string | null;
  vessel?: Vessel;
}) => {
  const { kind, icon, icon_state, color, vessel } = props;
  if (vessel) {
    return <VesselMark vessel={vessel} color={color} />;
  }
  if (kind === 'drink') {
    return (
      <span style={markBoxStyle}>
        <span
          style={{
            width: `${SWATCH_SIZE}px`,
            height: `${SWATCH_SIZE}px`,
            background: color || 'transparent',
            border: color ? `1px solid ${INK_FAINT}` : 'none',
            borderRadius: '2px',
          }}
        />
      </span>
    );
  }
  return (
    <span style={markBoxStyle}>
      {!!icon && !!icon_state && <SpriteLayer icon={icon} state={icon_state} />}
    </span>
  );
};

const SubLabel = (props: { children: ReactNode }) => (
  <div style={{ color: INK_SOFT, fontSize: FONT_SMALL, margin: '6px 0 2px' }}>
    {props.children}
  </div>
);

const usePickEntries = (catalogs: Catalogs | undefined, kind: string) =>
  useMemo(() => {
    if (!catalogs) {
      return [];
    }
    const entries: PickEntry[] =
      kind === 'drink'
        ? catalogs.drink.map(([id, name, color]) => ({
            id,
            name,
            lower: name.toLowerCase(),
            color,
          }))
        : catalogs.food.map(([id, name, slot, icon_state]) => ({
            id,
            name,
            lower: name.toLowerCase(),
            icon: catalogs.icon_files[slot - 1],
            icon_state,
          }));
    return entries.sort((a, b) => a.name.localeCompare(b.name));
  }, [catalogs, kind]);

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
    <span
      style={{
        marginLeft: 'auto',
        flexShrink: 0,
        color: INK_SOFT,
        fontSize: FONT_SMALL,
      }}
    >
      {props.action}
    </span>
  </button>
);

const Picker = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState(data.columns[0]?.key);
  const [query, setQuery] = useState('');
  const [price, setPrice] = useState(0);
  const [vesselPrices, setVesselPrices] = useState<VesselPrices>(() =>
    initialVesselPrices(data.vessels),
  );
  const info = data.columns.find((c) => c.key === tab) || data.columns[0];
  const entries = usePickEntries(data.catalogs, info?.catalog || '');
  if (!info) {
    return null;
  }

  const usesVessels = !!info.vessels;
  const previewVessel = usesVessels
    ? offeredVessels(data.vessels, vesselPrices)[0]
    : undefined;
  const pricing = usesVessels
    ? { prices: offeredPrices(vesselPrices) }
    : { price };
  const toggleVessel = (key: string) => {
    const on = isOffered(vesselPrices, key);
    if (on && offeredVessels(data.vessels, vesselPrices).length <= 1) {
      return;
    }
    setVesselPrices({ ...vesselPrices, [key]: on ? null : 0 });
  };
  const count = (data.rows[info.key] || []).length;
  const full = count >= info.cap;
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
    act('add_written', { column: info.key, text: typed, ...pricing });
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
            {c.label} {(data.rows[c.key] || []).length}/{c.cap}
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
          flexWrap: 'wrap',
          alignItems: 'center',
          gap: '8px',
          margin: '6px 0',
        }}
      >
        {usesVessels ? (
          <>
            <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>
              Sold by the:
            </span>
            {data.vessels.map((v) => {
              const on = isOffered(vesselPrices, v.key);
              return (
                <div
                  key={v.key}
                  style={{ display: 'flex', alignItems: 'center', gap: '4px' }}
                >
                  <div
                    style={toggleChipStyle(on)}
                    onClick={() => toggleVessel(v.key)}
                  >
                    <VesselMark vessel={v} />
                    {v.label}
                  </div>
                  {on && (
                    <NumberInput
                      step={1}
                      minValue={0}
                      maxValue={data.max_price}
                      unit="m"
                      width={`${PRICE_WIDTH}px`}
                      value={vesselPrices[v.key] ?? 0}
                      onChange={(value: number) =>
                        setVesselPrices({ ...vesselPrices, [v.key]: value })
                      }
                    />
                  )}
                </div>
              );
            })}
          </>
        ) : (
          <>
            <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>
              Price:
            </span>
            <NumberInput
              step={1}
              minValue={0}
              maxValue={data.max_price}
              unit="m"
              width={`${PRICE_WIDTH}px`}
              value={price}
              onChange={(value: number) => setPrice(value)}
            />
          </>
        )}
      </div>
      {usesVessels && (
        <div
          style={{ color: INK_FAINT, fontSize: FONT_SMALL, marginBottom: '6px' }}
        >
          {capacityNote(data.vessels)}
        </div>
      )}

      {full ? (
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
          The {info.label} list is full.
        </div>
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
                act('add_linked', { column: info.key, id: entry.id, ...pricing })
              }
            >
              <Mark
                kind={info.catalog}
                icon={entry.icon}
                icon_state={entry.icon_state}
                color={entry.color}
                vessel={previewVessel}
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
            <div
              style={{
                padding: '6px 8px',
                color: INK_FAINT,
                fontSize: FONT_SMALL,
              }}
            >
              Showing {shown.length} of {matches.length}. Search to narrow it
              down.
            </div>
          )}
        </div>
      )}
    </div>
  );
};

const VesselPriceCell = (props: {
  row: Row;
  column: string;
  vessel: Vessel;
}) => {
  const { act, data } = useBackend<Data>();
  const { row, column, vessel } = props;
  const on = isOffered(row.prices, vessel.key);
  return (
    <div
      style={{
        width: `${VESSEL_CELL_WIDTH}px`,
        display: 'flex',
        alignItems: 'center',
        gap: '4px',
        flexShrink: 0,
      }}
    >
      <div
        style={{ ...tabStyle(on), padding: '1px 6px', fontSize: FONT_SMALL }}
        title={`${vessel.label}: ${vessel.capacity} drams`}
        onClick={() =>
          act('set_price', {
            column,
            uid: row.uid,
            vessel: vessel.key,
            value: on ? null : 0,
          })
        }
      >
        {vessel.label}
      </div>
      {on ? (
        <NumberInput
          step={1}
          minValue={0}
          maxValue={data.max_price}
          unit="m"
          width={`${PRICE_WIDTH}px`}
          value={row.prices?.[vessel.key] ?? 0}
          onChange={(value: number) =>
            act('set_price', {
              column,
              uid: row.uid,
              vessel: vessel.key,
              value,
            })
          }
        />
      ) : (
        <span style={{ color: INK_FAINT }}>—</span>
      )}
    </div>
  );
};

const WriterRow = (props: {
  row: Row;
  column: string;
  kind: string;
  usesVessels: boolean;
}) => {
  const { act, data } = useBackend<Data>();
  const { row, column, kind, usesVessels } = props;
  const vessel = usesVessels
    ? offeredVessels(data.vessels, row.prices)[0]
    : undefined;
  return (
    <div style={denseRowStyle} title={row.desc}>
      <Mark
        kind={kind}
        icon={row.icon}
        icon_state={row.icon_state}
        color={row.color}
        vessel={vessel}
      />
      <CommitInput
        value={row.name}
        maxLength={data.line_len}
        style={{ flex: 1, minWidth: 0 }}
        onCommit={(text) => act('rename', { column, uid: row.uid, text })}
      />
      {usesVessels ? (
        data.vessels.map((v) => (
          <VesselPriceCell key={v.key} row={row} column={column} vessel={v} />
        ))
      ) : (
        <NumberInput
          step={1}
          minValue={0}
          maxValue={data.max_price}
          unit="m"
          width={`${PRICE_WIDTH}px`}
          value={row.price ?? 0}
          onChange={(value: number) =>
            act('set_price', { column, uid: row.uid, value })
          }
        />
      )}
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
  const { key, label, cap, catalog: kind } = props.info;
  const usesVessels = !!props.info.vessels;
  const rows = data.rows[key] || [];
  return (
    <div>
      <div style={sectionHeaderStyle}>
        {label}
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
      </div>
      {rows.length === 0 ? (
        <div
          style={{
            color: INK_FAINT,
            fontStyle: 'italic',
            fontSize: FONT_SMALL,
          }}
        >
          Nothing yet. Add some on the right!
        </div>
      ) : (
        <>
          <div
            style={{
              display: 'flex',
              gap: '6px',
              padding: '0 6px',
              color: INK_FAINT,
              fontSize: FONT_SMALL,
            }}
          >
            <span style={{ width: `${ICON_SIZE}px`, flexShrink: 0 }} />
            <span style={{ flex: 1 }}>Name</span>
            <span
              style={{
                width: usesVessels
                  ? `${data.vessels.length * (VESSEL_CELL_WIDTH + 6) - 6}px`
                  : `${PRICE_WIDTH}px`,
              }}
            >
              {usesVessels ? 'Price, click a vessel to sell it' : 'Price'}
            </span>
            <span style={{ width: `${REMOVE_WIDTH}px` }} />
          </div>
          {rows.map((row) => (
            <WriterRow
              key={row.uid}
              row={row}
              column={key}
              kind={kind}
              usesVessels={usesVessels}
            />
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
        <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>
          Signed as:
        </span>
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
        <span style={{ color: INK_FAINT, fontSize: FONT_SMALL }}>
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

const ReaderRow = (props: { row: Row; kind: string; vessels?: Vessel[] }) => {
  const { row, kind, vessels } = props;
  const offered = vessels ? offeredVessels(vessels, row.prices) : [];
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
      <Mark
        kind={kind}
        icon={row.icon}
        icon_state={row.icon_state}
        color={row.color}
        vessel={offered[0]}
      />
      <span style={{ ...ellipsisCellStyle, flex: '0 1 auto' }}>{row.name}</span>
      <span
        style={{
          flex: 1,
          minWidth: '16px',
          height: 0,
          borderBottom: `1px dotted ${INK_FAINT}`,
        }}
      />
      {vessels ? (
        <span style={{ display: 'flex', gap: '10px', flexShrink: 0 }}>
          {offered.map((v) => (
            <span
              key={v.key}
              style={{ display: 'flex', alignItems: 'baseline', gap: '4px' }}
            >
              <span style={{ color: INK_SOFT, fontSize: FONT_SMALL }}>
                {v.label}
              </span>
              <PriceTag price={row.prices?.[v.key] ?? 0} />
            </span>
          ))}
        </span>
      ) : (
        <PriceTag price={row.price ?? 0} />
      )}
    </div>
  );
};

const ReaderColumn = (props: { info: ColumnInfo }) => {
  const { data } = useBackend<Data>();
  const { key, label, catalog: kind } = props.info;
  const usesVessels = !!props.info.vessels;
  const rows = data.rows[key] || [];
  if (rows.length === 0) {
    return null;
  }
  return (
    <div style={{ flex: '1 1 240px', minWidth: 0 }}>
      <div style={sectionHeaderStyle}>{label}</div>
      {rows.map((row) => (
        <ReaderRow
          key={row.uid}
          row={row}
          kind={kind}
          vessels={usesVessels ? data.vessels : undefined}
        />
      ))}
    </div>
  );
};

const ReaderView = () => {
  const { data } = useBackend<Data>();
  const blank =
    !data.title &&
    !data.notes &&
    data.columns.every((info) => !data.rows[info.key]?.length);
  if (blank) {
    return (
      <div
        style={{ textAlign: 'center', color: INK_FAINT, fontStyle: 'italic' }}
      >
        Nothing here.
      </div>
    );
  }
  return (
    <>
      {!!data.foreign_hand && (
        <div
          style={{
            textAlign: 'center',
            color: INK_FAINT,
            fontStyle: 'italic',
            marginBottom: '6px',
          }}
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
