import {
  Box,
  Button,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export type ForeignNation = {
  id: string;
  name: string;
  auto_discovered: BooleanLike;
  discovered: BooleanLike;
  cultural_goods_count: number;
  preferred_imports_count: number;
  preferred_exports_count: number;
};

export type TradeShip = {
  ship_id: string;
  nationality_id: string;
  ship_name: string;
  captain_name: string;
  ship_type: string;
  tonnage: number;
  expected_favor: number;
  dock_state: string;
  favor_earned: number;
};

export type ForeignTrade = {
  nations: ForeignNation[];
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
        <NationsSection foreignTrade={foreignTrade} act={act} />
      </Stack.Item>
      <Stack.Item>
        <ShipsSection foreignTrade={foreignTrade} act={act} />
      </Stack.Item>
    </Stack>
  );
};

const NationsSection = (props: {
  foreignTrade: ForeignTrade;
  act: ActFn;
}) => {
  const { foreignTrade, act } = props;
  return (
    <Section
      title="Foreign Trade - Nations"
      buttons={
        <Button.Confirm color="bad" onClick={() => act('clear_trade_ships')}>
          Clear All Ships
        </Button.Confirm>
      }
    >
      <Table>
        <Table.Row header>
          <Table.Cell>Nation</Table.Cell>
          <Table.Cell collapsing>Discovered?</Table.Cell>
          <Table.Cell collapsing>Cultural Goods</Table.Cell>
          <Table.Cell collapsing>Demands / Supplies</Table.Cell>
          <Table.Cell collapsing>&nbsp;</Table.Cell>
        </Table.Row>
        {foreignTrade.nations.map((n) => (
          <Table.Row key={n.id}>
            <Table.Cell>
              <b>{n.name}</b>
              <Box italic color="gray" fontSize="11px">
                {n.id}
              </Box>
            </Table.Cell>
            <Table.Cell collapsing>
              {n.discovered ? (
                <span style={{ color: '#5cb85c' }}>
                  {n.auto_discovered ? 'auto' : 'discovered'}
                </span>
              ) : (
                <span style={{ color: '#888' }}>hidden</span>
              )}
            </Table.Cell>
            <Table.Cell collapsing>{n.cultural_goods_count}</Table.Cell>
            <Table.Cell collapsing>
              {n.preferred_imports_count} / {n.preferred_exports_count}
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                onClick={() =>
                  act('spawn_trade_ship', { nationality_id: n.id })
                }
              >
                Spawn Ship
              </Button>
              {!n.discovered && (
                <Button
                  ml={1}
                  onClick={() =>
                    act('discover_nationality', {
                      nationality_id: n.id,
                    })
                  }
                >
                  Discover
                </Button>
              )}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const ShipsSection = (props: {
  foreignTrade: ForeignTrade;
  act: ActFn;
}) => {
  const { foreignTrade, act } = props;
  const ships = foreignTrade.ships ?? [];
  return (
    <Section
      title={`Foreign Trade - Ships (${ships.length})`}
      buttons={
        <Button onClick={() => act('reroll_trade_ships')}>
          Reroll Daily Pool
        </Button>
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
            <Table.Cell collapsing>Nationality</Table.Cell>
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
              <Table.Cell collapsing>{s.nationality_id}</Table.Cell>
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
