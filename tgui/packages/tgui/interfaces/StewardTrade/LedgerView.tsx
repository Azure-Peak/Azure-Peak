import { useEffect, useState } from 'react';
import { Input } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  denseRowStyle,
  ellipsisCellStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  sectionHeaderStyle,
  subTabBarStyle,
  subTabStyle,
} from '../common/parchment';
import {
  BalanceSheetPanel,
  GeneralLedgerPanel,
  IncomeStatementPanel,
  SubsidiaryPanel,
  TrialBalancePanel,
} from './LedgerReports';
import type { Data, LedgerEntry, LedgerView as LedgerViewName } from './types';

const VIEWS: { id: LedgerViewName; label: string }[] = [
  { id: 'journal', label: 'Journal' },
  { id: 'ledger', label: 'Ledger' },
  { id: 'trial', label: 'Trial Balance' },
  { id: 'income', label: 'Income' },
  { id: 'balance', label: 'Balance Sheet' },
  { id: 'subsidiary', label: 'Subsidiary' },
];

const signFor = (entry: LedgerEntry): { color: string; prefix: string } => {
  switch (entry.kind) {
    case 'mint':
      return { color: SEAL_GREEN, prefix: '+' };
    case 'burn':
      return { color: SEAL_RED, prefix: '-' };
    default:
      return { color: INK, prefix: '' };
  }
};

const partyFor = (entry: LedgerEntry): string => {
  switch (entry.kind) {
    case 'mint':
      return entry.to;
    case 'burn':
      return entry.from;
    case 'transfer':
      return `${entry.from} → ${entry.to}`;
    case 'accrual':
    case 'writeoff':
      return entry.kind;
    default:
      return `${entry.from} → ${entry.to}`;
  }
};

const LedgerRow = (props: { entry: LedgerEntry }) => {
  const { entry } = props;
  const { color, prefix } = signFor(entry);
  const legs = entry.legs || [];
  return (
    <div style={{ borderBottom: `1px dashed ${INK_FAINT}` }}>
      <div style={{ ...denseRowStyle, borderBottom: 'none' }}>
        <div style={{ flexShrink: 0, width: '36px', color: INK_FAINT }}>
          {entry.no ? `#${entry.no}` : ''}
        </div>
        <div style={{ ...ellipsisCellStyle, color: INK }}>
          {partyFor(entry)}
        </div>
        <div style={{ ...ellipsisCellStyle, flex: 2, color: INK_SOFT }}>
          {entry.reason}
          {entry.count > 1 && ` (x${entry.count})`}
        </div>
        <div
          style={{
            flexShrink: 0,
            color,
            fontWeight: 'bold',
            whiteSpace: 'nowrap',
          }}
        >
          {prefix}
          {entry.amount}m
        </div>
      </div>
      {!!entry.actor && (
        <div
          style={{
            padding: '0 6px 1px 42px',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK_FAINT,
            fontStyle: 'italic',
          }}
        >
          by {entry.actor}
        </div>
      )}
      {legs.map((leg, i) => (
        <div
          key={i}
          style={{
            display: 'flex',
            gap: '6px',
            padding: '0 6px 1px 42px',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK_SOFT,
          }}
        >
          <div style={{ ...ellipsisCellStyle, paddingLeft: leg.cr ? '18px' : 0 }}>
            {leg.cr ? 'To ' : 'Dr '}
            {leg.account}
          </div>
          <div style={{ flexShrink: 0, width: '64px', textAlign: 'right' }}>
            {leg.dr ? leg.dr : ''}
          </div>
          <div style={{ flexShrink: 0, width: '64px', textAlign: 'right' }}>
            {leg.cr ? leg.cr : ''}
          </div>
        </div>
      ))}
    </div>
  );
};

export const LedgerView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const page = props.data.ledger_page;

  const [draft, setDraft] = useState('');
  const [touched, setTouched] = useState(false);

  useEffect(() => {
    if (!touched) return;
    const id = setTimeout(() => {
      act('ledger_filter', { filter: draft });
    }, 250);
    return () => clearTimeout(id);
  }, [draft, touched, act]);

  const onSearch = (value: string) => {
    setTouched(true);
    setDraft(value);
  };

  if (!page) {
    return (
      <div style={{ color: INK_SOFT, fontStyle: 'italic', padding: '12px 0' }}>
        Opening the ledger...
      </div>
    );
  }

  const view = page.view || 'journal';

  const tabs = (
    <div style={subTabBarStyle}>
      {VIEWS.map((v) => (
        <button
          key={v.id}
          type="button"
          style={subTabStyle(view === v.id)}
          onClick={() => act('ledger_view', { view: v.id })}
        >
          {v.label}
        </button>
      ))}
      <button
        type="button"
        style={inkButtonStyle({ color: SEAL_AMBER })}
        onClick={() => act('ledger_refresh')}
      >
        Refresh
      </button>
    </div>
  );

  if (view !== 'journal') {
    return (
      <div>
        {tabs}
        {view === 'ledger' && (
          <GeneralLedgerPanel chart={page.chart} account={page.account_ledger} />
        )}
        {view === 'trial' && (
          <TrialBalancePanel
            trial={page.trial_balance}
            recon={page.reconciliation}
          />
        )}
        {view === 'income' && (
          <IncomeStatementPanel stmt={page.income_statement} />
        )}
        {view === 'balance' && <BalanceSheetPanel sheet={page.balance_sheet} />}
        {view === 'subsidiary' && <SubsidiaryPanel sub={page.subsidiary} />}
      </div>
    );
  }

  const entries = page.entries || [];
  const pageNum = page.page || 1;
  const hasMore = !!page.has_more;
  const canPrev = pageNum > 1;

  return (
    <div>
      {tabs}
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          margin: '8px 0',
        }}
      >
        <span
          style={{
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK_SOFT,
          }}
        >
          Search:
        </span>
        <Input
          value={draft}
          onChange={onSearch}
          placeholder="Account name or reason..."
          width="240px"
        />
        {!!draft && (
          <button
            type="button"
            style={inkButtonStyle()}
            onClick={() => onSearch('')}
          >
            Clear
          </button>
        )}
      </div>

      <div style={sectionHeaderStyle}>General Journal</div>

      <div style={{ height: '540px', overflowY: 'auto' }}>
        {entries.length === 0 ? (
          <div
            style={{ color: INK_SOFT, fontStyle: 'italic', padding: '8px 0' }}
          >
            {page.filtered
              ? 'No ledger entries match that search.'
              : 'The ledger is empty.'}
          </div>
        ) : (
          entries.map((entry, i) => <LedgerRow key={i} entry={entry} />)
        )}
      </div>

      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          marginTop: '10px',
        }}
      >
        <button
          type="button"
          style={inkButtonStyle({ disabled: !canPrev })}
          disabled={!canPrev}
          onClick={() => canPrev && act('ledger_page', { page: pageNum - 1 })}
        >
          &lsaquo; Newer
        </button>
        <span style={{ color: INK_FAINT, fontSize: FONT_BODY }}>
          Page {pageNum} &middot; {page.shown} shown
        </span>
        <button
          type="button"
          style={inkButtonStyle({ disabled: !hasMore })}
          disabled={!hasMore}
          onClick={() => hasMore && act('ledger_page', { page: pageNum + 1 })}
        >
          Older &rsaquo;
        </button>
      </div>
    </div>
  );
};
