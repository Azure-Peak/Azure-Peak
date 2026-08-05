import { Box, Button, Section, Stack, Table } from 'tgui-core/components';

export type ForeignRealm = {
  id: string;
  name: string;
  cultural_goods_count: number;
  bulk_demand_count: number;
  bulk_supply_count: number;
};

export type TradeShip = {
  ship_id: string;
  realm_id: string;
  ship_name: string;
  captain_name: string;
  ship_type: string;
  tonnage: number;
  expected_favor: number;
  dock_state: string;
  favor_earned: number;
};

export type ForeignTrade = {
  realms: ForeignRealm[];
  ships?: TradeShip[];
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

export const ForeignTradeView = (props: {
  foreignTrade: ForeignTrade;
  act: ActFn;
}) => {
  const { foreignTrade, act } = props;
  return (
    <Stack vertical>
      <Stack.Item>
        <RealmsSection foreignTrade={foreignTrade} act={act} />
      </Stack.Item>
      <Stack.Item>
        <ShipsSection foreignTrade={foreignTrade} act={act} />
      </Stack.Item>
    </Stack>
  );
};

const RealmsSection = (props: { foreignTrade: ForeignTrade; act: ActFn }) => {
  const { foreignTrade, act } = props;
  return (
    <Section
      title="Foreign Trade - Realms"
      buttons={
        <Button.Confirm color="bad" onClick={() => act('clear_trade_ships')}>
          Clear All Ships
        </Button.Confirm>
      }
    >
      <Table>
        <Table.Row header>
          <Table.Cell>Realm</Table.Cell>
          <Table.Cell collapsing>Cultural Goods</Table.Cell>
          <Table.Cell collapsing>Demands / Supplies</Table.Cell>
          <Table.Cell collapsing>&nbsp;</Table.Cell>
        </Table.Row>
        {foreignTrade.realms.map((r) => (
          <Table.Row key={r.id}>
            <Table.Cell>
              <b>{r.name}</b>
              <Box italic color="gray" fontSize="11px">
                {r.id}
              </Box>
            </Table.Cell>
            <Table.Cell collapsing>{r.cultural_goods_count}</Table.Cell>
            <Table.Cell collapsing>
              {r.bulk_demand_count} / {r.bulk_supply_count}
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                onClick={() => act('spawn_trade_ship', { realm_id: r.id })}
              >
                Spawn Ship
              </Button>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const ShipsSection = (props: { foreignTrade: ForeignTrade; act: ActFn }) => {
  const { foreignTrade, act } = props;
  const ships = foreignTrade.ships ?? [];
  return (
    <Section
      title={`Foreign Trade - Ships (${ships.length})`}
      buttons={
        <>
          <Button onClick={() => act('regen_hails')}>Regen Hails</Button>
          <Button ml={1} onClick={() => act('force_auto_hail')}>
            Force Auto-Hail
          </Button>
          <Button ml={1} onClick={() => act('reroll_trade_ships')}>
            Reroll Daily Pool
          </Button>
        </>
      }
    >
      {ships.length === 0 ? (
        <Box italic color="gray">
          No ships generated. Use the Spawn Ship buttons above.
        </Box>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell>Ship</Table.Cell>
            <Table.Cell>Captain</Table.Cell>
            <Table.Cell collapsing>Realm</Table.Cell>
            <Table.Cell collapsing>Type</Table.Cell>
            <Table.Cell collapsing>Tonnage</Table.Cell>
            <Table.Cell collapsing>State</Table.Cell>
            <Table.Cell collapsing>Expected Favor</Table.Cell>
            <Table.Cell collapsing>Earned</Table.Cell>
          </Table.Row>
          {ships.map((s) => (
            <Table.Row key={s.ship_id}>
              <Table.Cell>{s.ship_name}</Table.Cell>
              <Table.Cell>{s.captain_name}</Table.Cell>
              <Table.Cell collapsing>{s.realm_id}</Table.Cell>
              <Table.Cell collapsing>{s.ship_type}</Table.Cell>
              <Table.Cell collapsing>{s.tonnage}t</Table.Cell>
              <Table.Cell collapsing>{s.dock_state}</Table.Cell>
              <Table.Cell collapsing>{s.expected_favor}</Table.Cell>
              <Table.Cell collapsing>{s.favor_earned}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
};
