import type { CSSProperties, ReactNode } from 'react';
import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  subTabBarStyle,
  subTabStyle,
} from '../common/parchment';
import type { ActiveOffer, Data, Order, RegionCaravanState } from './types';
import { formatMammon } from '../common/format';

type Namer = (id: string) => string;

const requestText = (o: Order, goodName: Namer) =>
  `${o.items
    .map(
      (it) =>
        `${it.needed} ${goodName(it.good_id)}${it.route === 'stockpile' ? ` (${it.have})` : ''}`,
    )
    .join(', ')} · ${formatMammon(o.payout)}m · ${o.days_left}d left`;

const offerText = (offer: ActiveOffer, goodName: Namer) =>
  `${offer.units} ${goodName(offer.good_id)} at ${formatMammon(offer.unit_price)}m · ${formatMammon(offer.total_price)}m`;

const tributeText = (state: RegionCaravanState | undefined, goodName: Namer) =>
  (state?.tribute ?? [])
    .map((t) => `${t.units} ${goodName(t.good_id)}`)
    .join(', ');

export const CaravansView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { data } = props;
  const routes = data.caravan_routes || [];
  const [routeId, setRouteId] = useState<string>(routes[0]?.id ?? '');
  const [requestRef, setRequestRef] = useState<string | null>(null);
  const [offerRef, setOfferRef] = useState<string | null>(null);
  const [tributeId, setTributeId] = useState<string | null>(null);

  const route = routes.find((r) => r.id === routeId) ?? routes[0];
  const { fleet, home, trips, return_minutes } = data.caravans;
  const goodName: Namer = (id) => data.good_catalog[id]?.name ?? id;
  const regionName: Namer = (id) => data.region_catalog[id]?.name ?? id;

  const selectedRequest = data.active_orders.find((o) => o.ref === requestRef);
  const selectedOffer = data.active_offers.find((o) => o.ref === offerRef);
  const nothing = !selectedRequest && !selectedOffer && !tributeId;
  const canSend = home > 0 && !nothing;

  const clear = () => {
    setRequestRef(null);
    setOfferRef(null);
    setTributeId(null);
  };

  const switchRoute = (id: string) => {
    setRouteId(id);
    clear();
  };

  const send = () => {
    if (!route || !canSend) return;
    act('send_caravan', {
      route: route.id,
      request: selectedRequest?.ref ?? '',
      offer: selectedOffer?.ref ?? '',
      tribute: tributeId ?? '',
    });
    clear();
  };

  return (
    <div>
      <div style={sectionHeaderStyle}>Caravans</div>
      <div style={{ color: INK_SOFT, fontSize: FONT_BODY, marginBottom: '6px' }}>
        {home} of {fleet} home &middot; {trips.length} en route, return in{' '}
        {return_minutes} {return_minutes === 1 ? 'minute' : 'minutes'}
      </div>
      <div style={subTabBarStyle}>
        {routes.map((r) => (
          <div
            key={r.id}
            style={subTabStyle(r.id === route?.id)}
            onClick={() => switchRoute(r.id)}
          >
            {r.name}
          </div>
        ))}
      </div>
      <div style={{ ...cardStyle, textAlign: 'center' }}>
        <div
          style={{
            display: 'inline-grid',
            gridTemplateColumns: 'auto auto',
            columnGap: '10px',
            rowGap: '2px',
            textAlign: 'left',
            fontSize: FONT_BODY,
          }}
        >
          <ManifestLine
            label="Request"
            value={
              selectedRequest &&
              `${regionName(selectedRequest.region_id)} · ${requestText(selectedRequest, goodName)}`
            }
          />
          <ManifestLine
            label="Offer"
            value={
              selectedOffer &&
              `${regionName(selectedOffer.region_id)} · ${offerText(selectedOffer, goodName)}`
            }
          />
          <ManifestLine
            label="Tribute"
            value={
              tributeId &&
              `${regionName(tributeId)} · ${tributeText(data.region_caravan[tributeId], goodName)}`
            }
          />
        </div>
        <div style={{ marginTop: '8px' }}>
          <button
            type="button"
            disabled={!canSend}
            onClick={send}
            title={home > 0 ? undefined : 'No caravans are ready.'}
            style={inkButtonStyle({ color: SEAL_GREEN, disabled: !canSend })}
          >
            Send caravan
          </button>
        </div>
      </div>
      {route?.subroutes.map((sub) => (
        <div key={sub.id} style={{ marginTop: '8px' }}>
          <div
            style={{
              color: INK_SOFT,
              fontWeight: 'bold',
              fontSize: FONT_BODY,
              borderBottom: `1px solid ${INK_FAINT}`,
              paddingBottom: '2px',
              marginBottom: '4px',
            }}
          >
            {sub.name}
          </div>
          {sub.region_ids.map((regionId) => (
            <RegionCard
              key={regionId}
              name={regionName(regionId)}
              state={data.region_caravan[regionId]}
              orders={data.active_orders.filter(
                (o) => o.region_id === regionId,
              )}
              offer={data.active_offers.find((o) => o.region_id === regionId)}
              goodName={goodName}
              requestRef={requestRef}
              offerRef={offerRef}
              tributeSelected={tributeId === regionId}
              onRequest={(ref) =>
                setRequestRef(requestRef === ref ? null : ref)
              }
              onOffer={(ref) => setOfferRef(offerRef === ref ? null : ref)}
              onTribute={() =>
                setTributeId(tributeId === regionId ? null : regionId)
              }
              onExtend={(ref) => act('extend_order', { ref })}
            />
          ))}
        </div>
      ))}
      {trips.length > 0 && (
        <>
          <div style={{ ...sectionHeaderStyle, marginTop: '12px' }}>
            En route
          </div>
          {trips.map((trip, i) => (
            <div
              key={i}
              style={{ fontSize: FONT_BODY, color: INK_SOFT, padding: '2px 6px' }}
            >
              {trip.route}:{' '}
              {[trip.request, trip.offer, trip.tribute && `${trip.tribute} tribute`]
                .filter(Boolean)
                .join(' · ')}
            </div>
          ))}
        </>
      )}
    </div>
  );
};

const ManifestLine = (props: {
  label: string;
  value: string | null | undefined | false;
}) => (
  <>
    <span style={{ color: INK_FAINT, textAlign: 'right' }}>{props.label}</span>
    <span style={{ color: props.value ? INK : INK_FAINT }}>
      {props.value || 'None'}
    </span>
  </>
);

const RegionCard = (props: {
  name: string;
  state: RegionCaravanState | undefined;
  orders: Order[];
  offer: ActiveOffer | undefined;
  goodName: Namer;
  requestRef: string | null;
  offerRef: string | null;
  tributeSelected: boolean;
  onRequest: (ref: string) => void;
  onOffer: (ref: string) => void;
  onTribute: () => void;
  onExtend: (ref: string) => void;
}) => {
  const { data } = useBackend<Data>();
  const { name, state, orders, offer, goodName } = props;
  const blockaded = !!state?.blockaded;
  const tributeBlocker = state?.tribute_blocker ?? '';
  const payouts = data.quality_payouts || [];
  const qualityTooltip = [
    'Payout by quality:',
    ...payouts.map((q) => `  ${q.label} ${q.pct}%`),
  ].join('\n');
  return (
    <div
      style={{
        ...cardStyle,
        borderLeft: `4px solid ${blockaded ? SEAL_RED : PARCHMENT_SHADOW}`,
      }}
    >
      <div style={{ marginBottom: '4px' }}>
        <span style={{ fontWeight: 'bold', fontSize: FONT_BODY }}>{name}</span>
        {blockaded && <span style={badgeStyle(SEAL_RED)}>BLOCKADED</span>}
      </div>
      {orders.map((o) => (
        <ChoiceRow key={o.ref} label="Request">
          <PickButton
            selected={props.requestRef === o.ref}
            disabled={blockaded}
            title={o.has_warehouse ? qualityTooltip : undefined}
            onClick={() => props.onRequest(o.ref)}
          >
            {requestText(o, goodName)}
          </PickButton>
          {!!o.has_warehouse && (
            <span style={badgeStyle(SEAL_BLUE)}>WAREHOUSE</span>
          )}
          {!!o.petitioned && (
            <span style={badgeStyle('#a872c4')}>PETITIONED</span>
          )}
          <ZadButton
            order={o}
            cost={data.order_extend_cost}
            isOfficial={!!data.petition?.is_steward_role}
            onExtend={() => props.onExtend(o.ref)}
          />
        </ChoiceRow>
      ))}
      {offer && (
        <ChoiceRow label="Offer">
          <PickButton
            selected={props.offerRef === offer.ref}
            disabled={blockaded}
            onClick={() => props.onOffer(offer.ref)}
          >
            {offerText(offer, goodName)}
          </PickButton>
        </ChoiceRow>
      )}
      <ChoiceRow label="Tribute">
        <PickButton
          selected={props.tributeSelected}
          disabled={!!tributeBlocker}
          onClick={props.onTribute}
        >
          {tributeBlocker || tributeText(state, goodName)}
        </PickButton>
      </ChoiceRow>
    </div>
  );
};

const ChoiceRow = (props: { label: string; children: ReactNode }) => (
  <div
    style={{
      display: 'flex',
      flexWrap: 'wrap',
      alignItems: 'center',
      gap: '6px',
      marginBottom: '4px',
      fontSize: FONT_BODY,
    }}
  >
    <span style={{ color: INK_FAINT, flex: '0 0 60px' }}>{props.label}</span>
    {props.children}
  </div>
);

const pickButtonStyle = (
  selected: boolean,
  disabled: boolean,
): CSSProperties => ({
  ...inkButtonStyle({ color: selected ? SEAL_GREEN : INK, disabled }),
  fontWeight: selected ? 'bold' : 'normal',
  textAlign: 'left',
  ...(selected ? { background: 'rgba(200,170,100,0.35)' } : {}),
});

const PickButton = (props: {
  selected: boolean;
  disabled?: boolean;
  title?: string;
  onClick: () => void;
  children: ReactNode;
}) => (
  <button
    type="button"
    disabled={props.disabled}
    title={props.title}
    onClick={props.onClick}
    style={pickButtonStyle(props.selected, !!props.disabled)}
  >
    {props.children}
  </button>
);

const ZadButton = (props: {
  order: Order;
  cost: number;
  isOfficial: boolean;
  onExtend: () => void;
}) => {
  const { order, cost, isOfficial } = props;
  const blocker = !isOfficial
    ? 'Only Crown officials can send a zad.'
    : order.extend_blocker;
  return (
    <button
      type="button"
      disabled={!!blocker}
      onClick={props.onExtend}
      title={blocker || 'Send a zad to extend the request by one dae.'}
      style={inkButtonStyle({ color: SEAL_AMBER, disabled: !!blocker })}
    >
      Send a zad - {cost}p
    </button>
  );
};
