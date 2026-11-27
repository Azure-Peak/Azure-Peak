import { Fragment, type ReactNode, useMemo, useState } from 'react';
import {
  Box,
  Button,
  Divider,
  Icon,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { sanitizeText } from '../sanitize';

type StatValue = {
  stat: string;
  value: number;
};

type VirtueEntry = {
  name: string;
  source: string;
  is_origin: BooleanLike;
  choices: string[];
  skills: { name: string; amount: number }[];
  triumphs: number;
};

type NamedEntry = {
  name: string;
  desc?: string;
};

type StatRow = {
  stat: string;
  current: number;
  statpack: number;
  race: number;
  job: number;
  virtues: number;
  effects: number;
  other: number;
};

type SkillRow = {
  name: string;
  level: number;
  level_name: string;
  job: number;
  virtues: number;
  other: number;
};

type TraitRow = {
  name: string;
  desc?: string;
  sources: string[];
};

type EffectRow = {
  name: string;
  desc?: string;
  remaining: number;
  stats: StatValue[];
};

type Data = {
  name: string;
  ckey?: string;
  job?: string;
  advjob?: string;
  patron?: string;
  species?: string;
  age?: string;
  statpack?: { name: string; rolls: StatValue[]; wiped: BooleanLike } | null;
  virtues: VirtueEntry[];
  quirks: NamedEntry[];
  vices: NamedEntry[];
  stats: StatRow[];
  skills: SkillRow[];
  traits: TraitRow[];
  effects: EffectRow[];
};

type TabKey = 'build' | 'stats' | 'skills' | 'traits' | 'effects';

type Column = {
  content: ReactNode;
  width: string;
  color?: string;
};

const TABS: { key: TabKey; label: string }[] = [
  { key: 'build', label: 'Build' },
  { key: 'stats', label: 'Stats' },
  { key: 'skills', label: 'Skills' },
  { key: 'traits', label: 'Traits' },
  { key: 'effects', label: 'Effects' },
];

const HEADER_DIVIDER = '1px solid rgba(255, 255, 255, 0.25)';
const ROW_DIVIDER = '1px solid rgba(255, 255, 255, 0.08)';
const HEADER_CELL = { borderBottom: HEADER_DIVIDER };
const BODY_CELL = { borderBottom: ROW_DIVIDER };

const OTHER_STAT_TOOLTIP =
  'Everything starts at 10. Other covers age, admin edits and anything else not listed.';
const OTHER_SKILL_TOOLTIP =
  'Training during the round, admin edits and anything else not listed.';

function signed(value: number) {
  return value > 0 ? `+${value}` : `${value}`;
}

function statLabel(stat: string) {
  return stat.slice(0, 3).toUpperCase();
}

function formatRemaining(seconds: number) {
  if (seconds < 0) {
    return 'Permanent';
  }
  const minutes = Math.floor(seconds / 60);
  return minutes ? `${minutes}m ${seconds % 60}s` : `${seconds}s`;
}

function Html(props: { text?: string }) {
  if (!props.text) {
    return null;
  }
  return (
    <Box
      as="span"
      color="label"
      dangerouslySetInnerHTML={{ __html: sanitizeText(props.text) }}
    />
  );
}

function StatDeltas(props: { values: StatValue[] }) {
  const shown = props.values.filter((entry) => entry.value);
  return (
    <>
      {shown.map((entry, index) => (
        <Fragment key={entry.stat}>
          {index > 0 && ', '}
          <Box as="span" color={entry.value > 0 ? 'good' : 'bad'}>
            {`${signed(entry.value)} ${statLabel(entry.stat)}`}
          </Box>
        </Fragment>
      ))}
    </>
  );
}

function ColumnItems(props: { columns?: Column[] }) {
  return (
    <>
      {props.columns?.map((column, index) => (
        <Stack.Item
          key={index}
          width={column.width}
          color={column.color}
          textAlign="right"
        >
          {column.content}
        </Stack.Item>
      ))}
    </>
  );
}

function RowHeader(props: { title: string; columns?: Column[] }) {
  return (
    <Stack
      align="baseline"
      pb={0.5}
      color="label"
      bold
      style={{ borderBottom: HEADER_DIVIDER }}
    >
      <Stack.Item width="1em" />
      <Stack.Item grow>{props.title}</Stack.Item>
      <ColumnItems columns={props.columns} />
    </Stack>
  );
}

function ExpandableRow(props: {
  title: ReactNode;
  sub?: ReactNode;
  desc?: string;
  columns?: Column[];
  forceOpen?: boolean;
}) {
  const { title, sub, desc, columns, forceOpen } = props;
  const [open, setOpen] = useState(false);
  const expandable = !!desc;
  const expanded = expandable && (forceOpen || open);

  return (
    <Box py={0.5} style={{ borderBottom: ROW_DIVIDER }}>
      <Stack
        align="baseline"
        onClick={expandable ? () => setOpen(!open) : undefined}
        style={expandable ? { cursor: 'pointer' } : undefined}
      >
        <Stack.Item width="1em" color="label">
          {expandable && (
            <Icon name={expanded ? 'chevron-down' : 'chevron-right'} />
          )}
        </Stack.Item>
        <Stack.Item grow>
          <Box bold>{title}</Box>
          {sub}
        </Stack.Item>
        <ColumnItems columns={columns} />
      </Stack>
      {expanded && (
        <Box ml="1.5em" mt={0.25}>
          <Html text={desc} />
        </Box>
      )}
    </Box>
  );
}

function DeltaCell(props: { value: number }) {
  const { value } = props;
  return (
    <Table.Cell
      collapsing
      textAlign="center"
      style={BODY_CELL}
      color={value > 0 ? 'good' : value < 0 ? 'bad' : 'label'}
    >
      {value ? signed(value) : '-'}
    </Table.Cell>
  );
}

function HeaderCell(props: { children: ReactNode; grow?: boolean }) {
  return (
    <Table.Cell
      collapsing={!props.grow}
      textAlign={props.grow ? undefined : 'center'}
      style={HEADER_CELL}
    >
      {props.children}
    </Table.Cell>
  );
}

function HintLabel(props: { label: string; tooltip: string }) {
  return (
    <Tooltip content={props.tooltip}>
      <Box inline style={{ borderBottom: '1px dotted' }}>
        {props.label}
      </Box>
    </Tooltip>
  );
}

function HeaderLine(props: { data: Data; onRefresh: () => void }) {
  const { data, onRefresh } = props;
  const job =
    data.advjob && data.advjob !== data.job
      ? `${data.job} / ${data.advjob}`
      : data.job;
  const entries: [string, string | undefined][] = [
    ['Ckey', data.ckey],
    ['Job', job],
    ['Race', data.species],
    ['Age', data.age],
    ['Patron', data.patron],
  ];

  return (
    <Stack align="center">
      <Stack.Item grow>
        {entries
          .filter(([, value]) => !!value)
          .map(([label, value]) => (
            <Box key={label} inline mr={1.5}>
              <Box as="span" color="label">
                {label}:
              </Box>{' '}
              {value}
            </Box>
          ))}
      </Stack.Item>
      <Stack.Item>
        <Button icon="sync-alt" tooltip="Refresh" onClick={onRefresh} />
      </Stack.Item>
    </Stack>
  );
}

function BuildTab(props: { data: Data }) {
  const { statpack, virtues, quirks, vices } = props.data;
  const triumphsSpent = virtues.reduce(
    (total, virtue) => total + virtue.triumphs,
    0,
  );
  const hasRolls = !!statpack?.rolls.some((entry) => entry.value);

  return (
    <>
      <Section title="Statpack">
        {statpack ? (
          <Box>
            <Box as="span" bold>
              {statpack.name}
            </Box>
            {hasRolls && (
              <>
                {': '}
                <StatDeltas values={statpack.rolls} />
              </>
            )}
            {!!statpack.wiped && (
              <Box as="span" color="label">
                {' '}
                (wiped by a class stat reset)
              </Box>
            )}
          </Box>
        ) : (
          <Box color="label">No statpack recorded.</Box>
        )}
      </Section>
      <Section
        title="Virtues"
        buttons={
          !!triumphsSpent && (
            <Box color="average">{triumphsSpent} triumphs spent</Box>
          )
        }
      >
        {virtues.length ? (
          <>
            <RowHeader
              title="Virtue"
              columns={[{ content: 'Source', width: '6em' }]}
            />
            {virtues.map((virtue, index) => (
              <ExpandableRow
                key={`${virtue.name}-${index}`}
                title={
                  <>
                    {virtue.name}
                    {!!virtue.is_origin && (
                      <Box as="span" color="label" bold={false}>
                        {' '}
                        (origin)
                      </Box>
                    )}
                  </>
                }
                sub={<VirtueDetails virtue={virtue} />}
                columns={[
                  { content: virtue.source, width: '6em', color: 'label' },
                ]}
              />
            ))}
          </>
        ) : (
          <Box color="label">No virtues recorded.</Box>
        )}
      </Section>
      <Section title="Quirks">
        <NamedRows entries={quirks} empty="No quirks." />
      </Section>
      <Section title="Vices">
        <NamedRows entries={vices} empty="No vices." />
      </Section>
    </>
  );
}

function VirtueDetails(props: { virtue: VirtueEntry }) {
  const { virtue } = props;
  const parts = [
    virtue.choices.length ? `Picked: ${virtue.choices.join(', ')}` : '',
    virtue.skills.length
      ? virtue.skills
          .map((skill) => `${signed(skill.amount)} ${skill.name}`)
          .join(', ')
      : '',
    virtue.triumphs ? `${virtue.triumphs} triumphs` : '',
  ].filter(Boolean);

  if (!parts.length) {
    return null;
  }
  return <Box color="label">{parts.join(' · ')}</Box>;
}

function NamedRows(props: { entries: NamedEntry[]; empty: string }) {
  const { entries, empty } = props;
  if (!entries.length) {
    return <Box color="label">{empty}</Box>;
  }
  return (
    <>
      {entries.map((entry, index) => (
        <ExpandableRow
          key={`${entry.name}-${index}`}
          title={entry.name}
          desc={entry.desc}
        />
      ))}
    </>
  );
}

function StatsTab(props: { stats: StatRow[] }) {
  return (
    <Section>
      <Table>
        <Table.Row header>
          <HeaderCell grow>Stat</HeaderCell>
          <HeaderCell>Now</HeaderCell>
          <HeaderCell>Statpack</HeaderCell>
          <HeaderCell>Race</HeaderCell>
          <HeaderCell>Job</HeaderCell>
          <HeaderCell>Virtues</HeaderCell>
          <HeaderCell>Buffs</HeaderCell>
          <HeaderCell>
            <HintLabel label="Other" tooltip={OTHER_STAT_TOOLTIP} />
          </HeaderCell>
        </Table.Row>
        {props.stats.map((row) => (
          <Table.Row key={row.stat}>
            <Table.Cell style={BODY_CELL}>{statLabel(row.stat)}</Table.Cell>
            <Table.Cell collapsing textAlign="center" bold style={BODY_CELL}>
              {row.current}
            </Table.Cell>
            <DeltaCell value={row.statpack} />
            <DeltaCell value={row.race} />
            <DeltaCell value={row.job} />
            <DeltaCell value={row.virtues} />
            <DeltaCell value={row.effects} />
            <DeltaCell value={row.other} />
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
}

function SkillsTab(props: { skills: SkillRow[] }) {
  const sorted = useMemo(
    () =>
      [...props.skills].sort(
        (a, b) => b.level - a.level || a.name.localeCompare(b.name),
      ),
    [props.skills],
  );

  if (!sorted.length) {
    return <NoticeBox>No skills.</NoticeBox>;
  }

  return (
    <Section>
      <Table>
        <Table.Row header>
          <HeaderCell grow>Skill</HeaderCell>
          <HeaderCell>Level</HeaderCell>
          <HeaderCell>Job</HeaderCell>
          <HeaderCell>Virtues</HeaderCell>
          <HeaderCell>
            <HintLabel label="Other" tooltip={OTHER_SKILL_TOOLTIP} />
          </HeaderCell>
        </Table.Row>
        {sorted.map((skill) => (
          <Table.Row key={skill.name}>
            <Table.Cell style={BODY_CELL}>{skill.name}</Table.Cell>
            <Table.Cell collapsing style={BODY_CELL} pr={1}>
              {skill.level_name}
            </Table.Cell>
            <DeltaCell value={skill.job} />
            <DeltaCell value={skill.virtues} />
            <DeltaCell value={skill.other} />
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
}

function TraitsTab(props: { traits: TraitRow[] }) {
  const [query, setQuery] = useState('');
  const [expandAll, setExpandAll] = useState(false);
  const normalized = query.trim().toLowerCase();
  const filtered = useMemo(
    () =>
      [...props.traits]
        .sort((a, b) => a.name.localeCompare(b.name))
        .filter(
          (trait) =>
            !normalized ||
            trait.name.toLowerCase().includes(normalized) ||
            trait.sources.some((source) =>
              source.toLowerCase().includes(normalized),
            ),
        ),
    [props.traits, normalized],
  );

  return (
    <Section>
      <Stack mb={0.5}>
        <Stack.Item grow>
          <Input
            fluid
            placeholder="Search traits or sources..."
            value={query}
            onChange={setQuery}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            icon={expandAll ? 'compress' : 'expand'}
            selected={expandAll}
            onClick={() => setExpandAll(!expandAll)}
          >
            {expandAll ? 'Collapse all' : 'Expand all'}
          </Button>
        </Stack.Item>
      </Stack>
      {filtered.length ? (
        <>
          <RowHeader
            title="Trait"
            columns={[{ content: 'Source', width: '9em' }]}
          />
          {filtered.map((trait) => (
            <ExpandableRow
              key={trait.name}
              title={trait.name}
              desc={trait.desc}
              forceOpen={expandAll}
              columns={[
                {
                  content: trait.sources.join(', '),
                  width: '9em',
                  color: 'average',
                },
              ]}
            />
          ))}
        </>
      ) : (
        <NoticeBox>No traits match.</NoticeBox>
      )}
    </Section>
  );
}

function EffectsTab(props: { effects: EffectRow[] }) {
  if (!props.effects.length) {
    return <NoticeBox>No active effects.</NoticeBox>;
  }

  return (
    <Section>
      <RowHeader
        title="Effect"
        columns={[
          { content: 'Stats', width: '8em' },
          { content: 'Time left', width: '6em' },
        ]}
      />
      {props.effects.map((effect, index) => (
        <ExpandableRow
          key={`${effect.name}-${index}`}
          title={effect.name}
          desc={effect.desc}
          columns={[
            { content: <StatDeltas values={effect.stats} />, width: '8em' },
            {
              content: formatRemaining(effect.remaining),
              width: '6em',
              color: 'label',
            },
          ]}
        />
      ))}
    </Section>
  );
}

export const CharacterPanel = () => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState<TabKey>('build');

  return (
    <Window title={`Character: ${data.name}`} width={620} height={640}>
      <Window.Content scrollable>
        <HeaderLine data={data} onRefresh={() => act('refresh')} />
        <Divider />
        <Tabs>
          {TABS.map((entry) => (
            <Tabs.Tab
              key={entry.key}
              selected={tab === entry.key}
              onClick={() => setTab(entry.key)}
            >
              {entry.label}
            </Tabs.Tab>
          ))}
        </Tabs>
        {tab === 'build' && <BuildTab data={data} />}
        {tab === 'stats' && <StatsTab stats={data.stats || []} />}
        {tab === 'skills' && <SkillsTab skills={data.skills || []} />}
        {tab === 'traits' && <TraitsTab traits={data.traits || []} />}
        {tab === 'effects' && <EffectsTab effects={data.effects || []} />}
      </Window.Content>
    </Window>
  );
};
