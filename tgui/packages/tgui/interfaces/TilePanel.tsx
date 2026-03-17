import type React from 'react';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Icon, Input, NoticeBox } from 'tgui-core/components';

type TileAtom = {
  name: string;
  ref: string;
  img64?: string | null;
  is_turf?: boolean;
};

type Data = {
  has_target: boolean;
  name?: string;
  atoms?: TileAtom[];
};

const TRUNCATE_LENGTH = 20;
const DRAG_THRESHOLD_PX = 6;

const truncate20 = (s: string) => {
  if (!s) return '';
  return s.length > TRUNCATE_LENGTH
    ? `${s.slice(0, TRUNCATE_LENGTH - 1)}…`
    : s;
};

type DragState = {
  active: boolean;
  started: boolean;
  srcRef: string | null;
  button: number;
  shift: number;
  ctrl: number;
  alt: number;
  startX: number;
  startY: number;
  pointerId: number | null;
};

const defaultDrag: DragState = {
  active: false,
  started: false,
  srcRef: null,
  button: 0,
  shift: 0,
  ctrl: 0,
  alt: 0,
  startX: 0,
  startY: 0,
  pointerId: null,
};

export const TilePanel = () => {
  const { act, data } = useBackend<Data>();
  const [query, setQuery] = useState('');

  const atoms = data.atoms || [];
  const turfAtom = useMemo(() => atoms.find((a) => a.is_turf), [atoms]);
  const otherAtoms = useMemo(() => atoms.filter((a) => !a.is_turf), [atoms]);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return otherAtoms;
    return otherAtoms.filter((a) => (a.name || '').toLowerCase().includes(q));
  }, [otherAtoms, query]);

  const title = data.has_target ? (data.name || 'Tile') : 'Tile Panel';

  const dragRef = useRef<DragState>({ ...defaultDrag });

  const refocusMap = useCallback(() => {
    try {
      (window as any).Byond?.command?.('tgui_refocus_map');
    } catch {}
  }, []);

  const isTextTarget = (el: Element | null) => {
    if (!el) return false;
    const ht = el as HTMLElement;
    const tag = el.tagName?.toLowerCase();
    if (tag === 'input' || tag === 'textarea' || tag === 'select') return true;
    if (ht.isContentEditable) return true;
    return !!el.closest?.('input, textarea, select, [contenteditable="true"]');
  };

  useEffect(() => {
    queueMicrotask(refocusMap);
  }, [refocusMap]);

  const sendInteract = (atomRef: string, e: React.MouseEvent) => {
    if (e.button === 2) e.preventDefault();

    act('interact', {
      ref: atomRef,
      button: e.button,
      shift: e.shiftKey ? 1 : 0,
      ctrl: e.ctrlKey ? 1 : 0,
      alt: e.altKey ? 1 : 0,
    });

    queueMicrotask(refocusMap);
  };

  const getOverRefFromPoint = (clientX: number, clientY: number) => {
    const el = document.elementFromPoint(clientX, clientY) as HTMLElement | null;
    const card = el?.closest?.('[data-atom-ref]') as HTMLElement | null;
    const ref = card?.dataset?.atomRef;
    return ref || null;
  };

  const sendDrop = (srcRef: string, overRef: string, d: DragState) => {
    act('drop', {
      src: srcRef,
      over: overRef,
      button: d.button,
      shift: d.shift,
      ctrl: d.ctrl,
      alt: d.alt,
      'icon-x': 16,
      'icon-y': 16,
    });

    queueMicrotask(refocusMap);
  };

  const maybeRefocusFromPanelPointer = (target: Element | null) => {
    if (isTextTarget(target)) return;
    if (dragRef.current.active) return;
    queueMicrotask(refocusMap);
  };

  const renderCard = (a: TileAtom) => (
    <div
      key={a.ref}
      data-atom-ref={a.ref}
      role="button"
      tabIndex={0}
      onContextMenu={(e) => e.preventDefault()}
      onPointerDown={(e) => {
        if ((e as any).button === 2) e.preventDefault();

        const btn = (e as any).button ?? 0;
        const shift = e.shiftKey ? 1 : 0;
        const ctrl = e.ctrlKey ? 1 : 0;
        const alt = e.altKey ? 1 : 0;

        dragRef.current = {
          active: true,
          started: false,
          srcRef: a.ref,
          button: btn,
          shift,
          ctrl,
          alt,
          startX: e.clientX,
          startY: e.clientY,
          pointerId: e.pointerId,
        };

        try {
          (e.currentTarget as any).setPointerCapture?.(e.pointerId);
        } catch {}
      }}
      onPointerMove={(e) => {
        const d = dragRef.current;
        if (!d.active || d.pointerId !== e.pointerId || !d.srcRef) return;

        const dx = Math.abs(e.clientX - d.startX);
        const dy = Math.abs(e.clientY - d.startY);

        if (!d.started && (dx > DRAG_THRESHOLD_PX || dy > DRAG_THRESHOLD_PX)) {
          d.started = true;
        }
      }}
      onPointerUp={(e) => {
        const d = dragRef.current;
        if (!d.active || d.pointerId !== e.pointerId) return;

        const srcRef = d.srcRef;
        const started = d.started;

        dragRef.current = { ...defaultDrag };

        try {
          (e.currentTarget as any).releasePointerCapture?.(e.pointerId);
        } catch {}

        if (!srcRef) return;

        if (!started) {
          sendInteract(srcRef, e as unknown as React.MouseEvent);
          return;
        }

        const overRef = getOverRefFromPoint(e.clientX, e.clientY);
        if (!overRef) return;

        sendDrop(srcRef, overRef, d);
      }}
      onPointerCancel={() => {
        dragRef.current = { ...defaultDrag };
      }}
      style={{
        width: '86px',
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        padding: '6px',
        border: '1px solid rgba(255,255,255,0.12)',
        borderRadius: '4px',
        background: 'rgba(0,0,0,0.15)',
        cursor: 'pointer',
        userSelect: 'none',
        touchAction: 'none',
      }}
      title={a.name}
    >
      <div
        style={{
          width: '64px',
          height: '64px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        {a.img64 ? (
          <img
            src={`data:image/png;base64,${a.img64}`}
            style={{
              maxWidth: '64px',
              maxHeight: '64px',
              imageRendering: 'pixelated',
              pointerEvents: 'none',
            }}
          />
        ) : (
          <Icon name="cube" />
        )}
      </div>

      <div
        style={{
          marginTop: '6px',
          width: '100%',
          textAlign: 'center',
          fontSize: '11px',
          lineHeight: '12px',
          overflow: 'hidden',
          whiteSpace: 'nowrap',
          textOverflow: 'ellipsis',
        }}
      >
        {truncate20(a.name)}
      </div>
    </div>
  );

  return (
    <Window width={300} height={400} title={title}>
      <Window.Content>
        <div
          style={{
            height: '100%',
            display: 'flex',
            flexDirection: 'column',
            minHeight: 0,
          }}
          onPointerDown={(e) => maybeRefocusFromPanelPointer(e.target as Element)}
          onPointerUp={(e) => maybeRefocusFromPanelPointer(e.target as Element)}
        >
          {!data.has_target ? (
            <NoticeBox>No turf selected.</NoticeBox>
          ) : (
            <>
              <div style={{ flex: '0 0 auto' }}>
                <Input
                  fluid
                  placeholder="Search..."
                  value={query}
                  onChange={setQuery}
                />
              </div>

              <div
                style={{
                  marginTop: '6px',
                  flex: '1 1 auto',
                  minHeight: 0,
                  overflowY: 'auto',
                  overflowX: 'hidden',
                  display: 'flex',
                  flexWrap: 'wrap',
                  alignContent: 'flex-start',
                  gap: '8px',
                  padding: '6px',
                  WebkitOverflowScrolling: 'touch',
                }}
              >
                {turfAtom && renderCard(turfAtom)}
                {filtered.length === 0 ? (
                  <NoticeBox>Nothing to show.</NoticeBox>
                ) : (
                  filtered.map((a) => renderCard(a))
                )}
              </div>
            </>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};

export default TilePanel;
