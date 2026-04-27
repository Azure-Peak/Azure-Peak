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

type LedgerEntry = {
  kind: string;
  from: string;
  to: string;
  amount: number;
  currency: string | null;
  reason: string | null;
  time_label: string;
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

type SuspendedCharter = {
  id: string;
  name: string;
};

type DailyPayrollRow = {
  job: string;
  amount: number;
  headcount: number;
  suspended_count: number;
  row_total: number;
};

type Bankruptcy = {
  state: number;
  state_label: string;
  debt: number;
  bankruptcy_count: number;
  concession_picks: number;
  operating_floor: number;
  arrears_loan_floor: number;
  recovery_reset: number;
  autoexport_override: number;
  suspended_charters: SuspendedCharter[];
  atc_loan_min: number;
  atc_loan_max: number;
  atc_loan_closed_day: number;
  atc_loan_available: BooleanLike;
  atc_loan_blocker: string;
  atc_loan_arrears_consumed: BooleanLike;
  atc_loans_drawn: number;
  daily_payroll: DailyPayrollRow[];
  daily_payroll_total: number;
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
  bankruptcy: Bankruptcy;
  ledger: LedgerEntry[];
  ledger_total: number;
  ledger_cap: number;
  ledger_full_minted: number;
  ledger_full_burned: number;
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
    bankruptcy,
    ledger,
    ledger_total,
    ledger_cap,
    ledger_full_minted,
    ledger_full_burned,
  } = data;

  const [searchDraft, setSearchDraft] = useState(filter.search);
  const [ledgerKind, setLedgerKind] = useState<
    'all' | 'mint' | 'burn' | 'transfer'
  >('all');
  const [ledgerFund, setLedgerFund] = useState('');
  const [ledgerReason, setLedgerReason] = useState('');
  const [ledgerGroup, setLedgerGroup] = useState(false);
  const [ledgerPage, setLedgerPage] = useState(0);
  const LEDGER_PAGE_SIZE = 50;
  const filteredLedger = ledger.filter((e) => {
    if (ledgerKind !== 'all' && e.kind !== ledgerKind) return false;
    if (ledgerFund) {
      const needle = ledgerFund.toLowerCase();
      if (
        !e.from.toLowerCase().includes(needle) &&
        !e.to.toLowerCase().includes(needle)
      ) {
        return false;
      }
    }
    if (ledgerReason) {
      const needle = ledgerReason.toLowerCase();
      if (!(e.reason || '').toLowerCase().includes(needle)) return false;
    }
    return true;
  });
  const ledgerWindowTotals = filteredLedger.reduce(
    (acc, e) => {
      if (e.kind === 'mint') acc.minted += e.amount;
      else if (e.kind === 'burn') acc.burned += e.amount;
      return acc;
    },
    { minted: 0, burned: 0 },
  );
  type DisplayRow = LedgerEntry & { count: number };
  const displayRows: DisplayRow[] = (() => {
    if (!ledgerGroup) {
      return filteredLedger.map((e) => ({ ...e, count: 1 }));
    }
    const groups = new Map<string, DisplayRow>();
    for (const e of filteredLedger) {
      const key = `${e.kind}|${e.from}|${e.to}|${e.reason || ''}`;
      const existing = groups.get(key);
      if (existing) {
        existing.amount += e.amount;
        existing.count += 1;
      } else {
        groups.set(key, { ...e, count: 1 });
      }
    }
    return Array.from(groups.values());
  })();
  const totalPages = Math.max(
    1,
    Math.ceil(displayRows.length / LEDGER_PAGE_SIZE),
  );
  const safePage = Math.min(Math.max(0, ledgerPage), totalPages - 1);
  const pageRows = displayRows.slice(
    safePage * LEDGER_PAGE_SIZE,
    (safePage + 1) * LEDGER_PAGE_SIZE,
  );
  const setLedgerKindAndReset = (
    k: 'all' | 'mint' | 'burn' | 'transfer',
  ) => {
    setLedgerKind(k);
    setLedgerPage(0);
  };
  const setLedgerFundAndReset = (v: string) => {
    setLedgerFund(v);
    setLedgerPage(0);
  };
  const setLedgerReasonAndReset = (v: string) => {
    setLedgerReason(v);
    setLedgerPage(0);
  };
  const toggleLedgerGroup = () => {
    setLedgerGroup(!ledgerGroup);
    setLedgerPage(0);
  };
  const clearLedgerFilters = () => {
    setLedgerKind('all');
    setLedgerFund('');
    setLedgerReason('');
    setLedgerGroup(false);
    setLedgerPage(0);
  };
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

  const stateColor =
    bankruptcy.state === 2
      ? '#c0392b'
      : bankruptcy.state === 1
        ? '#e07b39'
        : '#5cb85c';
  const [atcLoanAmount, setAtcLoanAmount] = useState(bankruptcy.atc_loan_min);

  return (
    <Window width={1080} height={780}>
      <Window.Content scrollable>
        <Stack vertical>
          <Stack.Item>
            <Section
              title={
                <span>
                  Solvency &mdash;{' '}
                  <span style={{ color: stateColor }}>
                    {bankruptcy.state_label}
                  </span>
                </span>
              }
            >
              <Stack>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="State">
                      <b style={{ color: stateColor }}>
                        {bankruptcy.state_label}
                      </b>
                    </LabeledList.Item>
                    <LabeledList.Item label="Outstanding Debt">
                      <b style={{ color: stateColor }}>
                        {bankruptcy.debt}m
                      </b>
                    </LabeledList.Item>
                    <LabeledList.Item label="Bankruptcies This Round">
                      {bankruptcy.bankruptcy_count}
                    </LabeledList.Item>
                    {bankruptcy.concession_picks > 0 && (
                      <LabeledList.Item label="Concession Picks Remaining">
                        <b style={{ color: '#5cb85c' }}>
                          {bankruptcy.concession_picks}
                        </b>
                      </LabeledList.Item>
                    )}
                  </LabeledList>
                </Stack.Item>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="Arrears Loan Floor">
                      {bankruptcy.arrears_loan_floor}m
                    </LabeledList.Item>
                    <LabeledList.Item label="Sequestration Floor">
                      {bankruptcy.operating_floor}m
                    </LabeledList.Item>
                    <LabeledList.Item label="Recovery Reset">
                      {bankruptcy.recovery_reset}m
                    </LabeledList.Item>
                    <LabeledList.Item label="Sequestration Auto-Export">
                      {bankruptcy.autoexport_override}%
                    </LabeledList.Item>
                    <LabeledList.Item label="ATC Loans This Round">
                      {bankruptcy.atc_loans_drawn}
                      {!!bankruptcy.atc_loan_arrears_consumed && (
                        <span style={{ color: '#e07b39', marginLeft: '6px' }}>
                          - arrears grace forfeit
                        </span>
                      )}
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
              </Stack>
              <Box mt={1} mb={1}>
                <Stack align="center">
                  <Stack.Item>
                    <b>ATC Emergency Loan:</b>
                  </Stack.Item>
                  <Stack.Item>
                    <NumberInput
                      value={atcLoanAmount}
                      minValue={bankruptcy.atc_loan_min}
                      maxValue={bankruptcy.atc_loan_max}
                      step={50}
                      stepPixelSize={4}
                      width="80px"
                      onChange={(v: number) => setAtcLoanAmount(v)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      disabled={!bankruptcy.atc_loan_available}
                      tooltip={
                        bankruptcy.atc_loan_available
                          ? `Borrow ${atcLoanAmount}m from the ATC. Consumes the arrears grace.`
                          : `Loan unavailable: ${bankruptcy.atc_loan_blocker}`
                      }
                      onClick={() =>
                        act('take_atc_loan', { amount: atcLoanAmount })
                      }
                    >
                      Draw Loan
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item color="gray" italic>
                    {bankruptcy.atc_loan_min}-{bankruptcy.atc_loan_max}m. Closes
                    on Day {bankruptcy.atc_loan_closed_day}.
                  </Stack.Item>
                </Stack>
              </Box>
              <Stack mt={1} wrap>
                <Stack.Item>
                  <Button.Confirm
                    disabled={bankruptcy.state !== 0}
                    onClick={() => act('force_arrears')}
                  >
                    Force Arrears
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    disabled={bankruptcy.state === 2}
                    onClick={() => act('force_bankruptcy')}
                  >
                    Force Bankruptcy
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    disabled={bankruptcy.state === 0}
                    onClick={() => act('force_recovery')}
                  >
                    Force Recovery
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
              {bankruptcy.daily_payroll.length > 0 && (
                <Box mt={1}>
                  <Box mb={1}>
                    <b>Daily Payroll</b> -{' '}
                    {bankruptcy.state === 2 ? (
                      <span style={{ color: '#c0392b', fontWeight: 'bold' }}>
                        SUSPENDED (sequestration)
                      </span>
                    ) : (
                      <span style={{ color: '#888' }}>
                        {bankruptcy.daily_payroll_total}m total / dawn
                      </span>
                    )}
                  </Box>
                  <Table>
                    <Table.Row header>
                      <Table.Cell>Job</Table.Cell>
                      <Table.Cell collapsing>Wage</Table.Cell>
                      <Table.Cell collapsing>Heads</Table.Cell>
                      <Table.Cell collapsing>Suspended</Table.Cell>
                      <Table.Cell collapsing>Pays</Table.Cell>
                    </Table.Row>
                    {bankruptcy.daily_payroll.map((row) => {
                      const sequestered = bankruptcy.state === 2;
                      const allSuspended =
                        sequestered ||
                        (row.headcount > 0 &&
                          row.suspended_count >= row.headcount);
                      return (
                        <Table.Row
                          key={row.job}
                          style={{
                            opacity: allSuspended ? 0.55 : 1,
                            textDecoration: allSuspended
                              ? 'line-through'
                              : undefined,
                          }}
                        >
                          <Table.Cell>{row.job}</Table.Cell>
                          <Table.Cell collapsing>{row.amount}m</Table.Cell>
                          <Table.Cell collapsing>{row.headcount}</Table.Cell>
                          <Table.Cell collapsing>
                            {row.suspended_count > 0 && (
                              <span style={{ color: '#e07b39' }}>
                                {row.suspended_count}
                              </span>
                            )}
                          </Table.Cell>
                          <Table.Cell collapsing>
                            {sequestered ? (
                              <span
                                style={{
                                  color: '#c0392b',
                                  fontVariant: 'small-caps',
                                  fontWeight: 'bold',
                                  letterSpacing: '1px',
                                }}
                              >
                                suspended
                              </span>
                            ) : (
                              `${row.row_total}m`
                            )}
                          </Table.Cell>
                        </Table.Row>
                      );
                    })}
                  </Table>
                </Box>
              )}
              {bankruptcy.suspended_charters.length > 0 && (
                <Box mt={1}>
                  <Box italic color="gray" mb={1}>
                    Suspended by Sequestration (
                    {bankruptcy.concession_picks} concession pick
                    {bankruptcy.concession_picks === 1 ? '' : 's'} remaining):
                  </Box>
                  <Stack wrap>
                    {bankruptcy.suspended_charters.map((c) => (
                      <Stack.Item key={c.id}>
                        <Button
                          disabled={bankruptcy.concession_picks <= 0}
                          tooltip={
                            bankruptcy.concession_picks <= 0
                              ? 'No concession picks remaining'
                              : `Restore ${c.name} without cooldown`
                          }
                          onClick={() =>
                            act('concession_restore', { decree_id: c.id })
                          }
                        >
                          Restore: {c.name}
                        </Button>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Box>
              )}
            </Section>
          </Stack.Item>

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
            <Section
              title={`Treasury Ledger  -  ${ledger_total} entries this round`}
            >
              <Stack mb={1}>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="Round Inflow (mint)">
                      <b style={{ color: '#5cb85c' }}>{ledger_full_minted}m</b>
                    </LabeledList.Item>
                    <LabeledList.Item label="Round Outflow (burn)">
                      <b style={{ color: '#e07b39' }}>{ledger_full_burned}m</b>
                    </LabeledList.Item>
                    <LabeledList.Item label="Round Net">
                      <b>{ledger_full_minted - ledger_full_burned}m</b>
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Item grow>
                  <LabeledList>
                    <LabeledList.Item label="Filtered Inflow">
                      <b style={{ color: '#5cb85c' }}>
                        {ledgerWindowTotals.minted}m
                      </b>
                    </LabeledList.Item>
                    <LabeledList.Item label="Filtered Outflow">
                      <b style={{ color: '#e07b39' }}>
                        {ledgerWindowTotals.burned}m
                      </b>
                    </LabeledList.Item>
                    <LabeledList.Item label="Filtered Net">
                      <b>
                        {ledgerWindowTotals.minted - ledgerWindowTotals.burned}m
                      </b>
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
              </Stack>
              <Stack align="center" wrap mb={1}>
                <Stack.Item>Kind:</Stack.Item>
                {(['all', 'mint', 'burn', 'transfer'] as const).map((k) => (
                  <Stack.Item key={k}>
                    <Button
                      selected={ledgerKind === k}
                      onClick={() => setLedgerKindAndReset(k)}
                    >
                      {k}
                    </Button>
                  </Stack.Item>
                ))}
                <Stack.Item ml={2}>Fund:</Stack.Item>
                <Stack.Item>
                  <Input
                    value={ledgerFund}
                    onChange={(v: string) => setLedgerFundAndReset(v)}
                    placeholder="e.g. Crown's Purse"
                  />
                </Stack.Item>
                <Stack.Item ml={2}>Reason:</Stack.Item>
                <Stack.Item grow>
                  <Input
                    fluid
                    value={ledgerReason}
                    onChange={(v: string) => setLedgerReasonAndReset(v)}
                    placeholder="e.g. Standing Order, Manual Import, Payroll"
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    selected={ledgerGroup}
                    tooltip="Collapse rows that share kind, source, destination, and reason."
                    onClick={toggleLedgerGroup}
                  >
                    Group similar
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={clearLedgerFilters}>Clear</Button>
                </Stack.Item>
              </Stack>
              {ledger_total > ledger_cap && (
                <Box italic color="gray" mb={1}>
                  Showing the most recent {ledger_cap} of {ledger_total} entries.
                  Aggregations above cover the full round.
                </Box>
              )}
              {pageRows.length === 0 ? (
                <Box italic color="gray">
                  No entries match the current filter.
                </Box>
              ) : (
                <>
                  <Table>
                    <Table.Row header>
                      <Table.Cell>Time</Table.Cell>
                      <Table.Cell>Kind</Table.Cell>
                      <Table.Cell>From</Table.Cell>
                      <Table.Cell>To</Table.Cell>
                      <Table.Cell>Amount</Table.Cell>
                      {ledgerGroup && <Table.Cell>Count</Table.Cell>}
                      <Table.Cell>Reason</Table.Cell>
                    </Table.Row>
                    {pageRows.map((e, idx) => (
                      <Table.Row key={safePage * LEDGER_PAGE_SIZE + idx}>
                        <Table.Cell>{e.time_label}</Table.Cell>
                        <Table.Cell>
                          <span
                            style={{
                              color:
                                e.kind === 'mint'
                                  ? '#5cb85c'
                                  : e.kind === 'burn'
                                    ? '#e07b39'
                                    : undefined,
                            }}
                          >
                            {e.kind}
                          </span>
                        </Table.Cell>
                        <Table.Cell>{e.from}</Table.Cell>
                        <Table.Cell>{e.to}</Table.Cell>
                        <Table.Cell>
                          {e.amount}
                          {e.currency ? e.currency.charAt(0) : ''}
                        </Table.Cell>
                        {ledgerGroup && (
                          <Table.Cell>
                            {e.count > 1 ? `×${e.count}` : ''}
                          </Table.Cell>
                        )}
                        <Table.Cell>{e.reason || ''}</Table.Cell>
                      </Table.Row>
                    ))}
                  </Table>
                  <Stack align="center" mt={1}>
                    <Stack.Item grow>
                      <Box italic color="gray">
                        Page {safePage + 1} / {totalPages} -{' '}
                        {displayRows.length}{' '}
                        {ledgerGroup ? 'groups' : 'rows'}
                        {ledgerGroup
                          ? ` (from ${filteredLedger.length} entries)`
                          : ''}
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="angle-double-left"
                        disabled={safePage === 0}
                        onClick={() => setLedgerPage(0)}
                        tooltip="First page"
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="chevron-left"
                        disabled={safePage === 0}
                        onClick={() => setLedgerPage(safePage - 1)}
                      >
                        Prev
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="chevron-right"
                        disabled={safePage >= totalPages - 1}
                        onClick={() => setLedgerPage(safePage + 1)}
                      >
                        Next
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="angle-double-right"
                        disabled={safePage >= totalPages - 1}
                        onClick={() => setLedgerPage(totalPages - 1)}
                        tooltip="Last page"
                      />
                    </Stack.Item>
                  </Stack>
                </>
              )}
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
