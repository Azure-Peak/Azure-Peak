import type { CSSProperties, ReactNode } from 'react';
import { useEffect, useState } from 'react';

import { useBackend } from '../../backend';
import { formatMammon } from '../common/format';
import {
  ellipsisCellStyle,
  FONT_BODY,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  TITLE,
} from '../common/parchment';
import { MinutesLeft } from '../common/MinutesLeft';
import type {
  ActiveOffer,
  CaravanRoute,
  Data,
  OfferQuote,
  Order,
  RegionCaravanState,
  RequestQuote,
} from './types';

type Namer = (id: string) => string;

const GRID = '104px minmax(0, 1.6fr) minmax(0, 1fr) minmax(0, 0.95fr)';
const PETITION_PURPLE = '#a872c4';

const mammon = (n: number) => `${formatMammon(n)}m`;
const signed = (n: number) =>
  `${n >= 0 ? '+' : '-'}${formatMammon(Math.abs(n))}m`;
const signColor = (n: number) =>
  n > 0 ? SEAL_GREEN : n < 0 ? SEAL_RED : INK_SOFT;
const priceRange = (a: number, b: number, word: string) =>
  a === b ? mammon(a) : `${mammon(a)} ${word} ${mammon(b)}`;
const sum = <T,>(list: T[], pick: (t: T) => number) =>
  list.reduce((total, t) => total + pick(t), 0);

const requestParts = (o: Order, goodName: Namer) =>
  o.items.map(
    (it) =>
      `${it.needed} ${goodName(it.good_id)}${it.route === 'stockpile' ? ` (${it.have})` : ''}`,
  );

const requestMeta = (o: Order) =>
  `${formatMammon(o.payout)}m · ${o.days_left}d left`;

const offerLabel = (offer: ActiveOffer, goodName: Namer) =>
  `${offer.units} ${goodName(offer.good_id)}`;

const offerMeta = (offer: ActiveOffer) =>
  `at ${formatMammon(offer.unit_price)}m · ${formatMammon(offer.total_price)}m`;

const tributeParts = (state: RegionCaravanState | undefined, goodName: Namer) =>
  (state?.tribute ?? []).map((t) => `${t.units} ${goodName(t.good_id)}`);

const tributeText = (state: RegionCaravanState | undefined, goodName: Namer) =>
  tributeParts(state, goodName).join(', ');

const tributeShort = (state: RegionCaravanState | undefined) => {
  if (!state?.tribute?.length) return '-';
  if (state.blockaded) return 'Blockaded';
  return 'Sent today';
};

const labelStyle: CSSProperties = {
  flex: '0 0 auto',
  fontSize: FONT_SMALL,
  letterSpacing: '0.08em',
  textTransform: 'uppercase',
  color: INK_SOFT,
};

const cellStyle = (selected: boolean, disabled: boolean): CSSProperties => ({
  width: '100%',
  minWidth: 0,
  display: 'flex',
  flexWrap: 'wrap',
  alignItems: 'center',
  gap: '0 6px',
  padding: '1px 6px',
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  textAlign: 'left',
  borderRadius: '2px',
  cursor: disabled ? 'default' : 'pointer',
  color: INK,
  fontWeight: 'normal',
  background: selected ? 'var(--p-tab-active-bg)' : 'var(--p-card-bg)',
  border: `1px solid ${selected ? SEAL_AMBER : PARCHMENT_SHADOW}`,
  opacity: disabled ? 0.5 : 1,
});

const metaStyle: CSSProperties = {
  marginLeft: 'auto',
  flex: '0 0 auto',
  whiteSpace: 'nowrap',
  fontSize: FONT_SMALL,
  fontWeight: 'normal',
  color: INK_SOFT,
};

const Phrases = (props: { parts: string[] }) => (
  <span style={{ minWidth: 0, whiteSpace: 'normal' }}>
    {props.parts.map((part, i) => (
      <span key={i}>
        <span style={{ display: 'inline-block', maxWidth: '100%' }}>
          {part}
          {i < props.parts.length - 1 ? ',' : ''}
        </span>{' '}
      </span>
    ))}
  </span>
);

const tagStyle = (color: string): CSSProperties => ({
  flex: '0 0 auto',
  fontSize: FONT_SMALL,
  fontWeight: 'normal',
  letterSpacing: '0.04em',
  color,
});

export const CaravansView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { data } = props;
  const routes = data.caravan_routes || [];
  const [requestRef, setRequestRef] = useState<string | null>(null);
  const [offerRef, setOfferRef] = useState<string | null>(null);
  const [tributeId, setTributeId] = useState<string | null>(null);
  const [fillByRef, setFillByRef] = useState<Record<string, boolean>>({});

  useEffect(() => {
    act('caravan_select', {
      request: requestRef ?? '',
      offer: offerRef ?? '',
      tribute: tributeId ?? '',
    });
  }, [requestRef, offerRef, tributeId]);

  const {
    fleet,
    home,
    rented,
    trips,
    return_seconds,
    remembered_left,
    remembered_minutes,
  } = data.caravans;
  const dawnTrips = trips.filter((trip) => trip.return_seconds === null);
  const goodName: Namer = (id) => data.good_catalog[id]?.name ?? id;
  const regionName: Namer = (id) => data.region_catalog[id]?.name ?? id;
  const sequestered = !!data.sequestration?.active;
  const sellOffer = !!data.caravan_sell?.offer && !sequestered;
  const sellTribute = !!data.caravan_sell?.tribute && !sequestered;
  const sequesteredNote = sequestered
    ? 'Trade controls are locked under sequestration.'
    : '';

  const routeOfRegion: Record<string, string> = {};
  for (const r of routes) {
    for (const sub of r.subroutes) {
      for (const id of sub.region_ids) routeOfRegion[id] = r.id;
    }
  }

  const shortageGoods = new Set(
    data.market_rows
      .filter((r) => r.event_tag === 'SHORTAGE')
      .map((r) => r.good_id),
  );

  const selectedRequest = data.active_orders.find((o) => o.ref === requestRef);
  const selectedOffer = data.active_offers.find((o) => o.ref === offerRef);
  const tributeState = tributeId ? data.region_caravan[tributeId] : undefined;
  const selectedTribute = tributeState && !tributeState.tribute_blocker ? tributeId : null;

  const pickedRegions = [
    selectedRequest?.region_id,
    selectedOffer?.region_id,
    selectedTribute,
  ].filter(Boolean) as string[];
  const lockRoute = pickedRegions.length ? routeOfRegion[pickedRegions[0]] : null;
  const lockRouteName = routes.find((r) => r.id === lockRoute)?.name ?? '';

  const requestQuote =
    selectedRequest && data.caravan_quote?.request?.ref === selectedRequest.ref
      ? data.caravan_quote.request
      : null;
  const offerQuote =
    selectedOffer && data.caravan_quote?.offer?.ref === selectedOffer.ref
      ? data.caravan_quote.offer
      : null;

  const reckon = requestQuote
    ? reckonRequest(requestQuote, !!fillByRef[requestQuote.ref], sequestered)
    : null;
  const offerNet = selectedOffer
    ? sellOffer && offerQuote && !offerQuote.market_closed
      ? offerQuote.sale_total - selectedOffer.total_price
      : -selectedOffer.total_price
    : 0;
  const tributeQuote =
    selectedTribute && data.caravan_quote?.tribute?.region_id === selectedTribute
      ? data.caravan_quote.tribute
      : null;
  const tributeResale =
    sellTribute && tributeQuote ? tributeQuote.sale_total : 0;

  const anyPick = !!(selectedRequest || selectedOffer || selectedTribute);
  const nothingToDeliver = !!reckon && reckon.delivered === 0;
  const canSend = anyPick && home > 0 && !nothingToDeliver;
  const projected = (reckon ? reckon.net : 0) + offerNet + tributeResale;

  const clear = () => {
    setRequestRef(null);
    setOfferRef(null);
    setTributeId(null);
  };

  const send = () => {
    if (!canSend || !lockRoute) return;
    act('send_caravan', {
      route: lockRoute,
      request: selectedRequest?.ref ?? '',
      offer: selectedOffer?.ref ?? '',
      tribute: selectedTribute ?? '',
      fill: reckon?.fillOn ? 1 : 0,
    });
    clear();
  };

  const sendNote =
    home <= 0
      ? 'No caravans are ready.'
      : nothingToDeliver
        ? 'Nothing to deliver'
        : lockRoute
          ? `on ${lockRouteName}`
          : `${home} of ${fleet} home`;

  return (
    <div>
      <div
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          alignItems: 'center',
          gap: '2px 10px',
          padding: '8px 0 6px',
          color: INK_SOFT,
        }}
      >
        <span style={{ display: 'inline-flex', gap: '3px' }}>
          {Array.from({ length: fleet }, (_, i) => (
            <span
              key={i}
              style={{
                display: 'block',
                width: '9px',
                height: '9px',
                borderRadius: '50%',
                border: `1px solid ${i >= home && i < home + rented ? INK_FAINT : SEAL_AMBER}`,
                background:
                  i < home
                    ? SEAL_AMBER
                    : i < home + rented
                      ? INK_FAINT
                      : 'transparent',
              }}
            />
          ))}
        </span>
        <span>
          {home} of {fleet} home &middot;{' '}
          {rented > 0 && <>{rented} rented &middot; </>}
          {trips.length} en route
          {dawnTrips.length > 0 && (
            <>
              , return in <MinutesLeft seconds={return_seconds} />
            </>
          )}
        </span>
        {trips.map((trip, i) => (
          <span key={i} style={{ fontSize: FONT_SMALL }}>
            &middot; <span style={{ color: INK }}>{trip.route}:</span>{' '}
            {[
              trip.request,
              trip.offer && `${trip.offer}${trip.sell_offer ? ' to Market' : ''}`,
              trip.tribute &&
                `${trip.tribute} tribute${trip.sell_tribute ? ' to Market' : ''}`,
            ]
              .filter(Boolean)
              .join(' · ')}
            {trip.return_seconds !== null && (
              <>
                , back in <MinutesLeft seconds={trip.return_seconds} />
              </>
            )}
          </span>
        ))}
        {remembered_left > 0 && (
          <span style={{ flexBasis: '100%' }}>
            <b>Remembered Caravans:</b> Your foresight means you have sent
            caravans out before the start of the week. {remembered_left} of them{' '}
            {remembered_left === 1 ? 'remains' : 'remain'} (they will return in{' '}
            {remembered_minutes} minutes).
          </span>
        )}
      </div>

      <div
        style={{
          display: 'grid',
          gridTemplateColumns: GRID,
          gap: '6px',
          paddingBottom: '3px',
          borderBottom: `1px solid ${INK_FAINT}`,
          ...labelStyle,
        }}
      >
        <span>Region</span>
        <span>Request</span>
        <span>Offer</span>
        <span>Tribute</span>
      </div>

      {routes.map((route) => (
        <RouteBlock
          key={route.id}
          route={route}
          data={data}
          locked={!!lockRoute && lockRoute !== route.id}
          loading={lockRoute === route.id}
          goodName={goodName}
          regionName={regionName}
          shortageGoods={shortageGoods}
          requestRef={requestRef}
          offerRef={offerRef}
          tributeId={selectedTribute}
          onRequest={(ref) => setRequestRef(requestRef === ref ? null : ref)}
          onOffer={(ref) => setOfferRef(offerRef === ref ? null : ref)}
          onTribute={(id) => setTributeId(selectedTribute === id ? null : id)}
        />
      ))}
      <div style={{ height: '10px' }} />

      <div
        style={{
          position: 'sticky',
          bottom: 0,
          zIndex: 1,
          margin: '0 -20px',
          padding: '8px 20px',
          background: PARCHMENT,
          borderTop: `1px solid ${INK_FAINT}`,
          boxShadow: '0 -4px 10px var(--p-card-shadow)',
          display: 'flex',
          flexDirection: 'column',
          gap: '8px',
        }}
      >
        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'minmax(0, 1.3fr) minmax(0, 1fr)',
            gap: '12px',
          }}
        >
          <RequestPanel
            order={selectedRequest}
            quote={requestQuote}
            reckon={reckon}
            sequestered={sequestered}
            goodName={goodName}
            regionName={regionName}
            onToggleFill={() =>
              selectedRequest &&
              setFillByRef({
                ...fillByRef,
                [selectedRequest.ref]: !fillByRef[selectedRequest.ref],
              })
            }
            onExtend={() =>
              selectedRequest && act('extend_order', { ref: selectedRequest.ref })
            }
          />
          <OfferPanel
            offer={selectedOffer}
            quote={offerQuote}
            net={offerNet}
            sell={sellOffer}
            lockNote={sequesteredNote}
            goodName={goodName}
            regionName={regionName}
            onToggleSell={() => act('caravan_sell_toggle', { kind: 'offer' })}
          />
        </div>
        <div
          style={{ display: 'flex', alignItems: 'center', gap: '12px', minWidth: 0 }}
        >
          <div
            style={{
              flex: '1 1 auto',
              minWidth: 0,
              display: 'flex',
              flexDirection: 'column',
              gap: '2px',
            }}
          >
            <div
              style={{ display: 'flex', alignItems: 'center', gap: '12px', minWidth: 0 }}
            >
              <span style={labelStyle}>Tribute</span>
              <span
                style={{
                  ...ellipsisCellStyle,
                  color: selectedTribute ? INK : INK_FAINT,
                }}
                title={
                  selectedTribute
                    ? tributeText(data.region_caravan[selectedTribute], goodName)
                    : undefined
                }
              >
                {selectedTribute
                  ? `${regionName(selectedTribute)} · ${tributeText(data.region_caravan[selectedTribute], goodName)}`
                  : 'None'}
              </span>
              {selectedTribute && (
                <FillToggle
                  on={sellTribute}
                  disabled={sequestered}
                  note={sequesteredNote}
                  label="Sell on arrival"
                  onToggle={() => act('caravan_sell_toggle', { kind: 'tribute' })}
                />
              )}
            </div>
            <div
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'flex-end',
                gap: '16px',
                minWidth: 0,
                whiteSpace: 'nowrap',
              }}
            >
              {selectedTribute && (
                <span style={{ color: INK_SOFT }}>
                  Tribute resale{' '}
                  {tributeResale > 0 ? (
                    <span style={{ color: SEAL_GREEN }}>
                      +{mammon(tributeResale)}
                    </span>
                  ) : (
                    <span style={{ color: INK_FAINT }}>-</span>
                  )}
                </span>
              )}
              <span style={{ color: INK_SOFT }}>
                Projected net{' '}
                <b style={{ color: anyPick ? signColor(projected) : INK_SOFT }}>
                  {anyPick ? signed(projected) : '-'}
                </b>
              </span>
            </div>
          </div>
          <button
            type="button"
            disabled={!anyPick}
            onClick={clear}
            style={{
              ...inkButtonStyle({ color: INK_SOFT, disabled: !anyPick }),
              flex: '0 0 auto',
              fontWeight: 'normal',
            }}
          >
            Clear
          </button>
          <button
            type="button"
            disabled={!canSend}
            onClick={send}
            style={{
              ...inkButtonStyle({ color: SEAL_GREEN, disabled: !canSend }),
              flex: '0 0 auto',
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              lineHeight: 1.25,
            }}
          >
            <span>Send caravan</span>
            <span
              style={{ fontSize: FONT_SMALL, fontWeight: 'normal', color: INK_SOFT }}
            >
              {sendNote}
            </span>
          </button>
        </div>
      </div>
    </div>
  );
};

type Reckoning = {
  need: number;
  fillUnits: number;
  canFill: boolean;
  fillOn: boolean;
  delivered: number;
  payout: number;
  cost: number;
  net: number;
  toggleNote: string;
};

const reckonRequest = (
  quote: RequestQuote,
  wantFill: boolean,
  sequestered: boolean,
): Reckoning => {
  const stockItems = quote.items.filter((i) => i.route === 'stockpile');
  const fillUnits = sum(stockItems, (i) => i.fill_units);
  const fillCost = sum(stockItems, (i) => i.fill_cost);
  const fillPayout = sum(stockItems, (i) => i.fill_units * i.unit_pay);
  const canFill = !sequestered && fillUnits > 0;
  const fillOn = canFill && wantFill;
  const delivered = quote.load_units + (fillOn ? fillUnits : 0);
  const payout = quote.load_payout + (fillOn ? fillPayout : 0);
  const cost = fillOn ? fillCost : 0;
  let toggleNote = '';
  if (sequestered) {
    toggleNote = 'Locked under sequestration.';
  } else if (!fillUnits) {
    if (stockItems.every((i) => i.have >= i.needed)) {
      toggleNote = 'Enough in royal stock.';
    } else if (stockItems.every((i) => i.market_closed)) {
      toggleNote = 'The market is closed.';
    } else {
      toggleNote = 'The Market is sold out.';
    }
  }
  return {
    need: sum(quote.items, (i) => i.needed),
    fillUnits,
    canFill,
    fillOn,
    delivered,
    payout,
    cost,
    net: payout - cost,
    toggleNote,
  };
};

const RouteBlock = (props: {
  route: CaravanRoute;
  data: Data;
  locked: boolean;
  loading: boolean;
  goodName: Namer;
  regionName: Namer;
  shortageGoods: Set<string>;
  requestRef: string | null;
  offerRef: string | null;
  tributeId: string | null;
  onRequest: (ref: string) => void;
  onOffer: (ref: string) => void;
  onTribute: (id: string) => void;
}) => {
  const { act } = useBackend<Data>();
  const { route, data, locked, loading, goodName, regionName } = props;
  const raidedSubroutes = route.subroutes.filter(
    (sub) => data.caravan_escorts?.[sub.id],
  );
  const blockadedCount = route.subroutes.reduce(
    (n, sub) =>
      n + sub.region_ids.filter((id) => data.region_caravan[id]?.blockaded).length,
    0,
  );
  const payouts = data.quality_payouts || [];
  const qualityTooltip = [
    'Payout by quality:',
    ...payouts.map((q) => `  ${q.label} ${q.pct}%`),
  ].join('\n');

  return (
    <div style={{ opacity: locked ? 0.5 : 1 }}>
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          gap: '8px',
          padding: '7px 0 2px',
        }}
      >
        <b style={{ color: TITLE }}>{route.name}</b>
        <span style={{ fontSize: FONT_SMALL, color: INK_SOFT }}>
          {route.subroutes.map((s) => s.name).join(' · ')}
        </span>
        {blockadedCount > 0 && (
          <span style={{ fontSize: FONT_SMALL, color: SEAL_RED }}>
            {blockadedCount} blockaded
          </span>
        )}
        <span
          style={{
            marginLeft: 'auto',
            fontSize: FONT_SMALL,
            color: loading ? SEAL_AMBER : INK_SOFT,
          }}
        >
          {loading ? 'Loading' : ''}
        </span>
      </div>
      {raidedSubroutes.length > 0 && (
        <div
          style={{
            display: 'flex',
            flexWrap: 'wrap',
            alignItems: 'center',
            gap: '6px',
            padding: '0 0 4px',
          }}
        >
          {raidedSubroutes.map((sub) => {
            const escort = data.caravan_escorts[sub.id];
            if (escort.escorted) {
              return (
                <span key={sub.id} style={tagStyle(SEAL_GREEN)}>
                  {sub.name} escorted until dawn
                </span>
              );
            }
            return (
              <button
                key={sub.id}
                type="button"
                disabled={!!escort.blocker}
                title={escort.blocker || undefined}
                onClick={() => act('buy_escort', { subroute: sub.id })}
                style={inkButtonStyle({
                  color: SEAL_RED,
                  disabled: !!escort.blocker,
                })}
              >
                Escort {sub.name} - {mammon(escort.fee)}
              </button>
            );
          })}
        </div>
      )}
      {route.subroutes.map((sub) =>
        sub.region_ids.map((regionId, i) => {
          const state = data.region_caravan[regionId];
          const blockaded = !!state?.blockaded;
          const orders = data.active_orders.filter(
            (o) => o.region_id === regionId,
          );
          const offer = data.active_offers.find((o) => o.region_id === regionId);
          const tributeBlocker = state?.tribute_blocker ?? '';
          const cellDisabled = (blockaded && !state?.escorted) || locked;
          return (
            <div
              key={regionId}
              style={{
                display: 'grid',
                gridTemplateColumns: GRID,
                gap: '6px',
                alignItems: 'start',
                padding: '2px 0',
                borderTop: `1px ${i === 0 ? 'solid' : 'dashed'} ${PARCHMENT_SHADOW}`,
              }}
            >
              <span
                title={blockaded ? 'Blockaded' : undefined}
                style={{
                  padding: '2px 0',
                  fontWeight: 'bold',
                  color: blockaded ? SEAL_RED : INK,
                }}
              >
                {regionName(regionId)}
              </span>

              <div
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  gap: '2px',
                  minWidth: 0,
                }}
              >
                {orders.map((o) => (
                  <button
                    key={o.ref}
                    type="button"
                    disabled={cellDisabled}
                    title={o.has_warehouse ? qualityTooltip : undefined}
                    onClick={() => props.onRequest(o.ref)}
                    style={cellStyle(props.requestRef === o.ref, cellDisabled)}
                  >
                    <Phrases parts={requestParts(o, goodName)} />
                    {o.items.some((it) => props.shortageGoods.has(it.good_id)) && (
                      <span style={tagStyle(SEAL_RED)}>SHORTAGE</span>
                    )}
                    {!!o.has_warehouse && (
                      <span style={tagStyle(SEAL_BLUE)}>WAREHOUSE</span>
                    )}
                    {!!o.crafted && (
                      <span style={tagStyle(SEAL_AMBER)}>CRAFTED ONLY</span>
                    )}
                    {!!o.petitioned && (
                      <span style={tagStyle(PETITION_PURPLE)}>PETITIONED</span>
                    )}
                    {!!o.halved && <span style={tagStyle(SEAL_RED)}>HALF</span>}
                    <span style={metaStyle}>{requestMeta(o)}</span>
                  </button>
                ))}
                {!orders.length && <Empty />}
              </div>

              <div style={{ minWidth: 0 }}>
                {offer ? (
                  <button
                    type="button"
                    disabled={cellDisabled}
                    onClick={() => props.onOffer(offer.ref)}
                    style={cellStyle(props.offerRef === offer.ref, cellDisabled)}
                  >
                    <Phrases parts={[offerLabel(offer, goodName)]} />
                    {!!offer.halved && (
                      <span style={tagStyle(SEAL_RED)}>HALF</span>
                    )}
                    <span style={metaStyle}>{offerMeta(offer)}</span>
                  </button>
                ) : (
                  <Empty />
                )}
              </div>

              <div style={{ minWidth: 0 }}>
                {tributeBlocker ? (
                  <span
                    title={tributeBlocker}
                    style={{
                      display: 'block',
                      padding: '2px 6px',
                      fontSize: FONT_SMALL,
                      fontStyle: 'italic',
                      color: INK_FAINT,
                    }}
                  >
                    {tributeShort(state)}
                  </span>
                ) : (
                  <button
                    type="button"
                    disabled={locked}
                    onClick={() => props.onTribute(regionId)}
                    style={cellStyle(props.tributeId === regionId, locked)}
                  >
                    <Phrases parts={tributeParts(state, goodName)} />
                  </button>
                )}
              </div>

            </div>
          );
        }),
      )}
    </div>
  );
};

const Empty = () => (
  <span style={{ display: 'block', padding: '1px 6px', color: INK_FAINT }}>
    -
  </span>
);

const panelStyle = (active: boolean): CSSProperties => ({
  minWidth: 0,
  minHeight: '96px',
  boxSizing: 'border-box',
  padding: '6px 10px',
  border: `1px solid ${active ? SEAL_AMBER : PARCHMENT_SHADOW}`,
  background: active ? 'var(--p-card-bg)' : 'transparent',
  display: 'flex',
  flexDirection: 'column',
  gap: '3px',
  overflow: 'hidden',
});

const rowStyle: CSSProperties = {
  display: 'flex',
  alignItems: 'center',
  gap: '8px',
  minWidth: 0,
};

const lineStyle: CSSProperties = {
  ...ellipsisCellStyle,
  flex: '0 0 auto',
  fontSize: FONT_SMALL,
  color: INK_SOFT,
};

const PanelHead = (props: {
  label: string;
  title?: string;
  terms?: string;
  tag?: ReactNode;
}) => (
  <div style={{ display: 'flex', alignItems: 'baseline', gap: '8px', minWidth: 0 }}>
    <span style={labelStyle}>{props.label}</span>
    {props.title && (
      <b style={ellipsisCellStyle} title={props.title}>
        {props.title}
      </b>
    )}
    {props.tag}
    {props.terms && (
      <span
        style={{
          flex: '0 0 auto',
          fontSize: FONT_SMALL,
          color: INK_SOFT,
          whiteSpace: 'nowrap',
        }}
      >
        {props.terms}
      </span>
    )}
  </div>
);

const Projection = (props: {
  parts: { label: string; amount: string; color: string; bold?: boolean }[];
}) => (
  <div
    style={{
      display: 'flex',
      alignItems: 'center',
      gap: '0 6px',
      minWidth: 0,
      overflow: 'hidden',
      fontSize: FONT_SMALL,
      marginTop: 'auto',
    }}
  >
    {props.parts.map((p, i) => (
      <span key={p.label} style={{ whiteSpace: 'nowrap' }}>
        {i > 0 && <span style={{ color: INK_FAINT }}>&middot; </span>}
        <span style={{ color: INK_SOFT }}>{p.label}</span>{' '}
        <span style={{ color: p.color, fontWeight: p.bold ? 'bold' : 'normal' }}>
          {p.amount}
        </span>
      </span>
    ))}
  </div>
);

const RequestPanel = (props: {
  order: Order | undefined;
  quote: RequestQuote | null;
  reckon: Reckoning | null;
  sequestered: boolean;
  goodName: Namer;
  regionName: Namer;
  onToggleFill: () => void;
  onExtend: () => void;
}) => {
  const { data } = useBackend<Data>();
  const { order, quote, reckon, goodName } = props;
  if (!order) {
    return (
      <div style={panelStyle(false)}>
        <PanelHead label="Request" />
        <span style={{ color: INK_FAINT }}>None</span>
      </div>
    );
  }
  const single = order.items.length === 1 ? order.items[0] : null;
  const title = single
    ? `${props.regionName(order.region_id)} · up to ${single.needed} ${goodName(single.good_id)}`
    : `${props.regionName(order.region_id)} · ${order.items.length} goods`;
  const terms = single
    ? `${formatMammon(single.unit_pay)}m each · ${order.days_left}d left`
    : `${formatMammon(order.payout)}m · ${order.days_left}d left`;
  const zadBlocker = !data.is_steward_role
    ? 'Only Crown officials can send a zad.'
    : order.extend_blocker;
  const zad = (
    <button
      type="button"
      disabled={!!zadBlocker}
      onClick={props.onExtend}
      title={zadBlocker || 'Send a zad to extend the request by one dae.'}
      style={{
        ...inkButtonStyle({ color: SEAL_AMBER, disabled: !!zadBlocker }),
        flex: '0 0 auto',
        padding: '0 8px',
        fontSize: FONT_SMALL,
        fontWeight: 'normal',
        lineHeight: 1.3,
        whiteSpace: 'nowrap',
      }}
    >
      Extend request - {data.order_extend_cost}p
    </button>
  );

  if (!quote || !reckon) {
    return (
      <div style={panelStyle(true)}>
        <PanelHead label="Request" title={title} terms={terms} />
        <div style={rowStyle}>
          <span style={{ ...ellipsisCellStyle, color: INK_FAINT }}>...</span>
          {zad}
        </div>
      </div>
    );
  }

  const stockLines = quote.items.map((it) => {
    const prefix = single ? '' : `${it.needed} ${goodName(it.good_id)}: `;
    if (it.route === 'warehouse') {
      return order.crafted
        ? `${prefix}Crafted pieces on the warehouse dock: ${it.loaded}`
        : `${prefix}On the warehouse dock: ${it.loaded}`;
    }
    const market = it.market_closed
      ? 'closed'
      : it.market_left > 0
        ? `${it.market_left} left at ${priceRange(it.ask_first, it.ask_last, 'to')} each`
        : 'sold out';
    return `${prefix}Royal stock ${it.have} · Market ${market}`;
  });
  const hasStockpile = quote.items.some((it) => it.route === 'stockpile');
  const outcome =
    reckon.delivered === 0
      ? 'You have none of the goods for this order.'
      : `${reckon.delivered} of ${reckon.need} loaded${
          reckon.delivered < reckon.need
            ? ` · ${reckon.need - reckon.delivered} remaining`
            : ''
        }`;

  return (
    <div style={panelStyle(true)}>
      <PanelHead label="Request" title={title} terms={terms} />
      {stockLines.map((line, i) => (
        <div key={i} style={rowStyle}>
          <span
            style={{
              ...ellipsisCellStyle,
              fontSize: FONT_SMALL,
              color: INK_SOFT,
            }}
            title={line}
          >
            {line}
          </span>
          {i === 0 && zad}
        </div>
      ))}
      <div style={{ ...rowStyle, gap: '10px' }}>
        {hasStockpile && (
          <FillToggle
            on={reckon.fillOn}
            disabled={!reckon.canFill}
            note={reckon.toggleNote}
            label="Fill partial from Market"
            onToggle={props.onToggleFill}
          />
        )}
        <span
          style={{
            ...ellipsisCellStyle,
            fontSize: FONT_SMALL,
            color: reckon.delivered === 0 ? SEAL_RED : INK_SOFT,
          }}
        >
          {outcome}
        </span>
      </div>
      <Projection
        parts={[
          {
            label: `Payout (${reckon.delivered})`,
            amount: reckon.payout > 0 ? `+${mammon(reckon.payout)}` : '0m',
            color: reckon.payout > 0 ? SEAL_GREEN : INK_SOFT,
          },
          {
            label: reckon.fillOn ? `Market (${reckon.fillUnits})` : 'Market',
            amount: reckon.cost ? `-${mammon(reckon.cost)}` : '-',
            color: reckon.cost ? SEAL_RED : INK_SOFT,
          },
          {
            label: 'Net',
            amount: signed(reckon.net),
            color: signColor(reckon.net),
            bold: true,
          },
        ]}
      />
    </div>
  );
};

const FillToggle = (props: {
  on: boolean;
  disabled: boolean;
  note: string;
  label: string;
  onToggle: () => void;
}) => (
  <button
    type="button"
    role="switch"
    aria-checked={props.on}
    disabled={props.disabled}
    onClick={props.onToggle}
    title={props.note || undefined}
    style={{
      flex: '0 0 auto',
      display: 'inline-flex',
      alignItems: 'center',
      gap: '7px',
      padding: 0,
      fontFamily: SERIF,
      fontSize: FONT_BODY,
      color: props.disabled ? INK_FAINT : INK,
      background: 'transparent',
      border: 'none',
      cursor: props.disabled ? 'default' : 'pointer',
    }}
  >
    <span
      style={{
        position: 'relative',
        display: 'inline-block',
        width: '28px',
        height: '14px',
        borderRadius: '7px',
        background: props.on ? 'rgba(106,149,96,0.35)' : 'transparent',
        border: `1px solid ${props.on ? SEAL_GREEN : INK_FAINT}`,
      }}
    >
      <span
        style={{
          position: 'absolute',
          top: '1px',
          left: props.on ? '15px' : '1px',
          width: '10px',
          height: '10px',
          borderRadius: '50%',
          background: props.on ? SEAL_GREEN : INK_FAINT,
        }}
      />
    </span>
    {props.label}
  </button>
);

const OfferPanel = (props: {
  offer: ActiveOffer | undefined;
  quote: OfferQuote | null;
  net: number;
  sell: boolean;
  lockNote: string;
  goodName: Namer;
  regionName: Namer;
  onToggleSell: () => void;
}) => {
  const { offer, quote } = props;
  if (!offer) {
    return (
      <div style={panelStyle(false)}>
        <PanelHead label="Offer" />
        <span style={{ color: INK_FAINT }}>None</span>
      </div>
    );
  }
  const title = `${props.regionName(offer.region_id)} · ${offerLabel(offer, props.goodName)}`;
  const terms = `at ${formatMammon(offer.unit_price)}m · ${formatMammon(offer.total_price)}m at send`;
  if (!quote) {
    return (
      <div style={panelStyle(true)}>
        <PanelHead label="Offer" title={title} terms={terms} />
        <span style={{ color: INK_FAINT }}>...</span>
      </div>
    );
  }
  const average = Math.round((quote.sale_total / offer.units) * 10) / 10;
  const resaleLine = quote.market_closed
    ? 'The market is closed.'
    : `Market pays about ${mammon(average)} each`;
  const bidHover = quote.market_closed
    ? undefined
    : `Market bid ${priceRange(quote.bid_first, quote.bid_last, 'falling to')}${
        quote.bid_first !== quote.bid_last ? ' as the stock fills' : ' each'
      }`;
  const selling = props.sell && !quote.market_closed;
  const parts = !selling
    ? [
        {
          label: 'Cost',
          amount: `-${mammon(offer.total_price)}`,
          color: SEAL_RED,
        },
      ]
    : [
        {
          label: `Sale (${offer.units})`,
          amount: `+${mammon(quote.sale_total)}`,
          color: SEAL_GREEN,
        },
        {
          label: 'Cost',
          amount: `-${mammon(offer.total_price)}`,
          color: SEAL_RED,
        },
        {
          label: 'Net',
          amount: signed(props.net),
          color: signColor(props.net),
          bold: true,
        },
      ];
  return (
    <div style={panelStyle(true)}>
      <PanelHead label="Offer" title={title} terms={terms} />
      <span style={lineStyle} title={bidHover}>
        {resaleLine}
      </span>
      <div style={rowStyle}>
        <FillToggle
          on={selling}
          disabled={!!quote.market_closed || !!props.lockNote}
          note={quote.market_closed ? 'The market is closed.' : props.lockNote}
          label="Sell on arrival"
          onToggle={props.onToggleSell}
        />
      </div>
      <Projection parts={parts} />
    </div>
  );
};
