import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Dashboard = {
  discretionary: number;
  burgher_pledge: number;
  total_bank: number;
  avg_balance: number;
  held_accounts: number;
  under_50m: number;
  in_advance: number;
  in_arrears: number;
  debtor_count: number;
  loans_outstanding: number;
  loan_exposure: number;
  rural_tax_total: number;
  noble_income_total: number;
  tax_rates: Record<string, number>;
  poll_tax_rates: Record<string, number>;
};

type PlayerRow = {
  ref: string;
  name: string;
  job: string;
  category: string | null;
  category_name: string;
  rate: number;
  raw_rate: number;
  exempt: BooleanLike;
  advance: number;
  owed: number;
  overdue: number;
  balance: number;
  on_person: number;
  has_loan: BooleanLike;
  is_debtor: BooleanLike;
};

type Filter = {
  category: string;
  status: string;
  search: string;
};

type FilterOptions = {
  categories: string[];
  statuses: string[];
};

type Charter = {
  id: string;
  name: string;
  active: BooleanLike;
  cooldown_remaining: number;
};

type Blockade = {
  region_id: string;
  region_name: string;
  threat_region: string;
  faction_name: string;
  day_started: number;
  has_active_scroll: BooleanLike;
  ref: string;
};

type Assembly = {
  session_number?: number;
  alderman_name?: string | null;
  alderman_ckey?: string | null;
  history_count?: number;
  censured_count?: number;
  trade_cap?: number;
  trade_remaining?: number;
  defense_cap?: number;
  defense_remaining?: number;
};

type Data = {
  dashboard: Dashboard;
  filter: Filter;
  filter_options: FilterOptions;
  players: PlayerRow[];
  selected: PlayerRow | null;
  day: number;
  charters: Charter[];
  simulated_player_scalar: number;
  effective_player_count: number;
  live_player_count: number;
  blockades: Blockade[];
  assembly: Assembly;
};

const STATUS_LABELS: Record<string, string> = {
  all: 'All',
  arrears: 'In Arrears',
  advance: 'In Advance',
  debtor: 'Debtor',
  low_balance: 'Low Balance (<50m)',
  exempt: 'Charter-Exempt',
};

const CATEGORY_LABELS: Record<string, string> = {
  all: 'All Categories',
  poll_noble: 'Noble',
  poll_clergy: 'Clergy',
  poll_inquisition: 'Inquisition',
  poll_courtier: 'Courtier',
  poll_garrison: 'Garrison',
  poll_guilds: 'Guilds',
  poll_merchant: 'Merchant',
  poll_burgher: 'Burgher',
  poll_adventurer: 'Adventurer',
  poll_mercenary: 'Mercenary',
  poll_peasant: 'Peasant',
};

export const EconomicPanel = () => {
  const { act, data } = useBackend<Data>();
  const {
    dashboard,
    filter,
    filter_options,
    players,
    selected,
    day,
    charters,
    simulated_player_scalar,
    effective_player_count,
    live_player_count,
    blockades,
    assembly,
  } = data;

  const [searchDraft, setSearchDraft] = useState(filter.search);
  const [mintAmount, setMintAmount] = useState(100);
  const [burnAmount, setBurnAmount] = useState(100);
  const [bulkAdvanceDays, setBulkAdvanceDays] = useState(1);
  const [playerAdvanceDays, setPlayerAdvanceDays] = useState(1);
  const [playerMintAmount, setPlayerMintAmount] = useState(50);
  const [simPop, setSimPop] = useState(simulated_player_scalar);
  const [assemblyTradeCap, setAssemblyTradeCap] = useState(300);
  const [assemblyDefenseCap, setAssemblyDefenseCap] = useState(500);

  const applyFilter = (overrides: Partial<Filter> = {}) => {
    act('set_filter', {
      category: overrides.category ?? filter.category,
      status: overrides.status ?? filter.status,
      search: overrides.search ?? searchDraft,
    });
  };

  return (
    <Window width={1080} height={780}>
      <Window.Content scrollable>
        <Stack vertical>
          <Stack.Item>
            <Section title={`Dashboard  -  Day ${day}`}>
              <Stack>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="Crown's Purse">
                      {dashboard.discretionary}m
                    </LabeledList.Item>
                    <LabeledList.Item label="Burgher Pledge">
                      {dashboard.burgher_pledge}
                    </LabeledList.Item>
                    <LabeledList.Item label="Total Bank Coin">
                      {dashboard.total_bank}m over {dashboard.held_accounts} accounts
                    </LabeledList.Item>
                    <LabeledList.Item label="Avg Balance">
                      {dashboard.avg_balance}m
                    </LabeledList.Item>
                    <LabeledList.Item label="Under 50m">
                      {dashboard.under_50m}
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="In Advance">
                      {dashboard.in_advance}
                    </LabeledList.Item>
                    <LabeledList.Item label="In Arrears">
                      {dashboard.in_arrears}
                    </LabeledList.Item>
                    <LabeledList.Item label="Debtors">
                      {dashboard.debtor_count}
                    </LabeledList.Item>
                    <LabeledList.Item label="Loans Outstanding">
                      {dashboard.loans_outstanding} ({dashboard.loan_exposure}m exposure)
                    </LabeledList.Item>
                    <LabeledList.Item label="Rural Tax YTD">
                      {dashboard.rural_tax_total}m
                    </LabeledList.Item>
                    <LabeledList.Item label="Noble Income YTD">
                      {dashboard.noble_income_total}m
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Tick Actions">
              <Stack wrap>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('advance_day')}>
                    Advance Day
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_poll_tick')}>
                    Fire Poll Tick
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_loan_tick')}>
                    Fire Loan Tick
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_pledge_tick')}>
                    Fire Pledge Tick
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_estate_incomes')}>
                    Distribute Estates
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_payroll')}>
                    Fire Payroll
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_economy_tick')}>
                    Fire Economy Tick
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Simulated Population (economy pop scaling)">
              <Box mb={1} color="label">
                Live active players: <b>{live_player_count}</b>.
                Effective count used by economy pop scaling:{' '}
                <b>{effective_player_count}</b>
                {simulated_player_scalar > 0 ? ' (admin override)' : ' (live)'}.
                Set 0 to use the live count.
              </Box>
              <Stack align="center">
                <Stack.Item>Simulated:</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={1}
                    minValue={0}
                    maxValue={500}
                    value={simPop}
                    onChange={(v: number) => setSimPop(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    onClick={() =>
                      act('set_simulated_population', { amount: simPop })
                    }
                  >
                    Apply
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    onClick={() => {
                      setSimPop(0);
                      act('set_simulated_population', { amount: 0 });
                    }}
                  >
                    Clear override
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title={`Blockades (${blockades.length} active)`}>
              <Stack wrap mb={1}>
                <Stack.Item>
                  <Button.Confirm onClick={() => act('fire_blockade_roll')}>
                    Fire Blockade Roll
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
              {blockades.length === 0 ? (
                <Box italic color="gray">
                  No blockades active. Trade roads run clear.
                </Box>
              ) : (
                <Table>
                  <Table.Row header>
                    <Table.Cell>Region</Table.Cell>
                    <Table.Cell>Threat</Table.Cell>
                    <Table.Cell>Faction</Table.Cell>
                    <Table.Cell>Day</Table.Cell>
                    <Table.Cell>Writ?</Table.Cell>
                    <Table.Cell>&nbsp;</Table.Cell>
                  </Table.Row>
                  {blockades.map((b) => (
                    <Table.Row key={b.ref}>
                      <Table.Cell>{b.region_name}</Table.Cell>
                      <Table.Cell>{b.threat_region}</Table.Cell>
                      <Table.Cell>{b.faction_name}</Table.Cell>
                      <Table.Cell>D{b.day_started}</Table.Cell>
                      <Table.Cell>{b.has_active_scroll ? 'yes' : '-'}</Table.Cell>
                      <Table.Cell>
                        <Button.Confirm
                          color="bad"
                          onClick={() =>
                            act('clear_blockade', { ref: b.ref })
                          }
                        >
                          Force Clear
                        </Button.Confirm>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section
              title={`City Assembly  -  Session #${assembly.session_number || 0}`}
            >
              <Stack>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="Alderman">
                      {assembly.alderman_name || '(vacant)'}
                    </LabeledList.Item>
                    <LabeledList.Item label="Trade Warrant">
                      {assembly.trade_remaining ?? 0}m / {assembly.trade_cap ?? 0}m
                    </LabeledList.Item>
                    <LabeledList.Item label="Defense Warrant">
                      {assembly.defense_remaining ?? 0}p / {assembly.defense_cap ?? 0}p
                    </LabeledList.Item>
                    <LabeledList.Item label="Censured">
                      {assembly.censured_count ?? 0}
                    </LabeledList.Item>
                    <LabeledList.Item label="Sessions Resolved">
                      {assembly.history_count ?? 0}
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item grow>
                  <Stack vertical>
                    <Stack.Item>
                      <Button.Confirm
                        onClick={() => act('assembly_resolve')}
                      >
                        Resolve Now (silent)
                      </Button.Confirm>
                      <Button.Confirm
                        ml={1}
                        onClick={() => act('assembly_resolve_skip_quorum')}
                      >
                        Resolve, Skip Quorum
                      </Button.Confirm>
                      <Button.Confirm
                        ml={1}
                        onClick={() => act('assembly_divine_complete')}
                      >
                        Divine Intervention
                      </Button.Confirm>
                    </Stack.Item>
                    <Stack.Item>
                      <Button onClick={() => act('assembly_refresh_warrant')}>
                        Refresh Warrant
                      </Button>
                      <Button.Confirm
                        ml={1}
                        color="bad"
                        onClick={() => act('assembly_drain_warrant')}
                      >
                        Drain Warrant
                      </Button.Confirm>
                    </Stack.Item>
                    {assembly.alderman_ckey ? (
                      <Stack.Item>
                        <Button.Confirm
                          color="bad"
                          onClick={() => act('assembly_demote_alderman')}
                        >
                          Demote Alderman
                        </Button.Confirm>
                      </Stack.Item>
                    ) : null}
                  </Stack>
                </Stack.Item>
              </Stack>
              <Stack align="center" mt={1}>
                <Stack.Item>Trade cap:</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={50}
                    minValue={0}
                    maxValue={10000}
                    value={assemblyTradeCap}
                    onChange={(v: number) => setAssemblyTradeCap(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    onClick={() =>
                      act('assembly_set_trade_cap', { amount: assemblyTradeCap })
                    }
                  >
                    Set
                  </Button>
                </Stack.Item>
                <Stack.Item>Defense cap:</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={50}
                    minValue={0}
                    maxValue={10000}
                    value={assemblyDefenseCap}
                    onChange={(v: number) => setAssemblyDefenseCap(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    onClick={() =>
                      act('assembly_set_defense_cap', { amount: assemblyDefenseCap })
                    }
                  >
                    Set
                  </Button>
                </Stack.Item>
              </Stack>
              <Box italic color="gray" mt={1}>
                To promote or censure a specific player, select them in the player
                list below and use the Alderman buttons in the detail pane.
              </Box>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Crown's Purse Mint / Burn">
              <Stack align="center">
                <Stack.Item>Mint:</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={10}
                    minValue={1}
                    maxValue={100000}
                    value={mintAmount}
                    onChange={(v: number) => setMintAmount(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    onClick={() => act('mint_discretionary', { amount: mintAmount })}
                  >
                    Mint
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item ml={3}>Burn:</Stack.Item>
                <Stack.Item>
                  <NumberInput
                    step={10}
                    minValue={1}
                    maxValue={100000}
                    value={burnAmount}
                    onChange={(v: number) => setBurnAmount(v)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    onClick={() => act('burn_discretionary', { amount: burnAmount })}
                  >
                    Burn
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Charters">
              <Stack vertical>
                {charters.map((c) => (
                  <Stack.Item key={c.id}>
                    <Button.Confirm
                      fluid
                      color={c.active ? 'good' : 'bad'}
                      onClick={() => act('toggle_charter', { decree_id: c.id })}
                    >
                      {c.name}: {c.active ? 'ACTIVE' : 'SUSPENDED'}
                    </Button.Confirm>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Filter">
              <Stack align="center" wrap>
                <Stack.Item>Category:</Stack.Item>
                {filter_options.categories.map((cat) => (
                  <Stack.Item key={cat}>
                    <Button
                      selected={filter.category === cat}
                      onClick={() => applyFilter({ category: cat })}
                    >
                      {CATEGORY_LABELS[cat] || cat}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
              <Stack align="center" mt={1} wrap>
                <Stack.Item>Status:</Stack.Item>
                {filter_options.statuses.map((s) => (
                  <Stack.Item key={s}>
                    <Button
                      selected={filter.status === s}
                      onClick={() => applyFilter({ status: s })}
                    >
                      {STATUS_LABELS[s] || s}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
              <Stack align="center" mt={1}>
                <Stack.Item>Search:</Stack.Item>
                <Stack.Item grow>
                  <Input
                    fluid
                    value={searchDraft}
                    onChange={(v: string) => setSearchDraft(v)}
                    placeholder="Substring match on name..."
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => applyFilter({ search: searchDraft })}>
                    Apply
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    onClick={() => {
                      setSearchDraft('');
                      act('set_filter', { category: 'all', status: 'all', search: '' });
                    }}
                  >
                    Clear
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title={`Players (${players.length} matching filter)`}>
              {players.length === 0 ? (
                <Box italic color="gray">
                  No players match the current filter. Widen the filter or select
                  a category/status above.
                </Box>
              ) : (
                <>
                  <Table>
                    <Table.Row header>
                      <Table.Cell>Name</Table.Cell>
                      <Table.Cell>Job</Table.Cell>
                      <Table.Cell>Category</Table.Cell>
                      <Table.Cell>Rate</Table.Cell>
                      <Table.Cell>Balance</Table.Cell>
                      <Table.Cell>Advance</Table.Cell>
                      <Table.Cell>Owed</Table.Cell>
                      <Table.Cell>Overdue</Table.Cell>
                      <Table.Cell>Flags</Table.Cell>
                      <Table.Cell>&nbsp;</Table.Cell>
                    </Table.Row>
                    {players.map((p) => {
                      const isSelected = selected && selected.ref === p.ref;
                      return (
                      <Table.Row key={p.ref}>
                        <Table.Cell>
                          {isSelected ? <b>{'> '}{p.name}</b> : p.name}
                        </Table.Cell>
                        <Table.Cell>{p.job}</Table.Cell>
                        <Table.Cell>{p.category_name}</Table.Cell>
                        <Table.Cell>
                          {p.rate}m{p.raw_rate !== p.rate ? ` (raw ${p.raw_rate}m)` : ''}
                        </Table.Cell>
                        <Table.Cell>{p.balance}m</Table.Cell>
                        <Table.Cell>{p.advance}</Table.Cell>
                        <Table.Cell>{p.owed}m</Table.Cell>
                        <Table.Cell>{p.overdue}</Table.Cell>
                        <Table.Cell>
                          {p.exempt ? 'E ' : ''}
                          {p.is_debtor ? 'D ' : ''}
                          {p.has_loan ? 'L ' : ''}
                        </Table.Cell>
                        <Table.Cell>
                          <Button onClick={() => act('select', { ref: p.ref })}>
                            Select
                          </Button>
                        </Table.Cell>
                      </Table.Row>
                      );
                    })}
                  </Table>

                  <Stack mt={1} wrap>
                    <Stack.Item>
                      <Button.Confirm
                        color="bad"
                        onClick={() => act('bulk_clear_debt')}
                      >
                        Bulk: Clear debt for all {players.length} filtered
                      </Button.Confirm>
                    </Stack.Item>
                    <Stack.Item>
                      <NumberInput
                        step={1}
                        minValue={1}
                        maxValue={30}
                        value={bulkAdvanceDays}
                        onChange={(v: number) => setBulkAdvanceDays(v)}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button.Confirm
                        onClick={() =>
                          act('bulk_add_advance', { days: bulkAdvanceDays })
                        }
                      >
                        Bulk: +{bulkAdvanceDays} advance days to all filtered
                      </Button.Confirm>
                    </Stack.Item>
                  </Stack>
                </>
              )}
            </Section>
          </Stack.Item>

          {selected && (
            <Stack.Item>
              <Section
                title={`Detail: ${selected.name} (${selected.job})`}
                buttons={
                  <Button onClick={() => act('clear_selection')}>Close</Button>
                }
              >
                <LabeledList>
                  <LabeledList.Item label="Category">
                    {selected.category_name}
                  </LabeledList.Item>
                  <LabeledList.Item label="Effective Rate">
                    {selected.rate}m / day
                    {selected.raw_rate !== selected.rate
                      ? ` (raw ${selected.raw_rate}m, modified by charter/cap)`
                      : ''}
                  </LabeledList.Item>
                  <LabeledList.Item label="Charter-Exempt">
                    {selected.exempt ? 'Yes' : 'No'}
                  </LabeledList.Item>
                  <LabeledList.Item label="Account Balance">
                    {selected.balance}m
                  </LabeledList.Item>
                  <LabeledList.Item label="On-Person Coin">
                    {selected.on_person}m
                  </LabeledList.Item>
                  <LabeledList.Item label="Advance Days">
                    {selected.advance}
                  </LabeledList.Item>
                  <LabeledList.Item label="Arrears">
                    {selected.owed}m over {selected.overdue} day(s)
                  </LabeledList.Item>
                  <LabeledList.Item label="Debtor Flag">
                    {selected.is_debtor ? 'YES' : 'no'}
                  </LabeledList.Item>
                  <LabeledList.Item label="Active Loan">
                    {selected.has_loan ? 'Yes' : 'No'}
                  </LabeledList.Item>
                </LabeledList>

                <Stack mt={1} wrap>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_clear_debt', { ref: selected.ref })
                      }
                    >
                      Clear poll-tax arrears
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_toggle_debtor', { ref: selected.ref })
                      }
                    >
                      Toggle TRAIT_DEBTOR
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>

                <Stack mt={1} wrap>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('assembly_promote_alderman', { ref: selected.ref })
                      }
                    >
                      Appoint Alderman
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      color="bad"
                      onClick={() =>
                        act('assembly_censure', { ref: selected.ref })
                      }
                    >
                      Censure
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('assembly_clear_censure', { ref: selected.ref })
                      }
                    >
                      Clear Censure
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>

                <Stack mt={1} align="center">
                  <Stack.Item>Advance days:</Stack.Item>
                  <Stack.Item>
                    <NumberInput
                      step={1}
                      minValue={1}
                      maxValue={999}
                      value={playerAdvanceDays}
                      onChange={(v: number) => setPlayerAdvanceDays(v)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_add_advance', {
                          ref: selected.ref,
                          days: playerAdvanceDays,
                        })
                      }
                    >
                      Add
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_remove_advance', {
                          ref: selected.ref,
                          days: playerAdvanceDays,
                        })
                      }
                    >
                      Remove
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>

                <Stack mt={1} align="center">
                  <Stack.Item>Mint / Burn to account:</Stack.Item>
                  <Stack.Item>
                    <NumberInput
                      step={10}
                      minValue={1}
                      maxValue={10000}
                      value={playerMintAmount}
                      onChange={(v: number) => setPlayerMintAmount(v)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_mint_account', {
                          ref: selected.ref,
                          amount: playerMintAmount,
                        })
                      }
                    >
                      Mint
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      color="bad"
                      onClick={() =>
                        act('player_burn_account', {
                          ref: selected.ref,
                          amount: playerMintAmount,
                        })
                      }
                    >
                      Burn
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>

                <Stack mt={1} align="center">
                  <Stack.Item>Indebted flaw:</Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_fire_indebted', { ref: selected.ref })
                      }
                      tooltip="Forces an immediate alimony tick on the selected player. Requires the Indebted flaw."
                    >
                      Fire Indebted Tick
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
