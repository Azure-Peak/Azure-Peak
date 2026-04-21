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
  burgher_bond: number;
  total_bank: number;
  avg_balance: number;
  held_accounts: number;
  under_50m: number;
  in_grace: number;
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
  grace: number;
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

type Data = {
  dashboard: Dashboard;
  filter: Filter;
  filter_options: FilterOptions;
  players: PlayerRow[];
  selected: PlayerRow | null;
  day: number;
  charters: Charter[];
};

const STATUS_LABELS: Record<string, string> = {
  all: 'All',
  arrears: 'In Arrears',
  grace: 'In Grace',
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
  const { dashboard, filter, filter_options, players, selected, day, charters } = data;

  const [searchDraft, setSearchDraft] = useState(filter.search);
  const [mintAmount, setMintAmount] = useState(100);
  const [burnAmount, setBurnAmount] = useState(100);
  const [bulkGraceDays, setBulkGraceDays] = useState(1);
  const [playerGraceDays, setPlayerGraceDays] = useState(1);
  const [playerMintAmount, setPlayerMintAmount] = useState(50);

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
                    <LabeledList.Item label="Burgher Bond">
                      {dashboard.burgher_bond}
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
                    <LabeledList.Item label="In Grace">
                      {dashboard.in_grace}
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
                  <Button.Confirm onClick={() => act('fire_bond_tick')}>
                    Fire Bond Tick
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
                  <Button.Confirm onClick={() => act('fire_savings_goal')}>
                    Award Savings Goals (test)
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
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
                      <Table.Cell>Coin</Table.Cell>
                      <Table.Cell>Grace</Table.Cell>
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
                        <Table.Cell>{p.on_person}m</Table.Cell>
                        <Table.Cell>{p.grace}</Table.Cell>
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
                        value={bulkGraceDays}
                        onChange={(v: number) => setBulkGraceDays(v)}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button.Confirm
                        onClick={() =>
                          act('bulk_add_grace', { days: bulkGraceDays })
                        }
                      >
                        Bulk: +{bulkGraceDays} grace days to all filtered
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
                  <LabeledList.Item label="Grace Days">
                    {selected.grace}
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

                <Stack mt={1} align="center">
                  <Stack.Item>Grace days:</Stack.Item>
                  <Stack.Item>
                    <NumberInput
                      step={1}
                      minValue={1}
                      maxValue={999}
                      value={playerGraceDays}
                      onChange={(v: number) => setPlayerGraceDays(v)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_add_grace', {
                          ref: selected.ref,
                          days: playerGraceDays,
                        })
                      }
                    >
                      Add
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('player_remove_grace', {
                          ref: selected.ref,
                          days: playerGraceDays,
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
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
