import { useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  NoticeBox,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export type QuestRow = {
  ref: string;
  type: string;
  title: string;
  region: string | null;
  holder: string | null;
  giver: string | null;
  status: 'pool' | 'unclaimed' | 'active' | 'complete' | 'failed';
  progress: string;
  live_targets: number;
  timer_label: string | null;
  timer_seconds: number;
  is_kill: boolean;
};

type Data = {
  debug_mode: boolean;
  quests: QuestRow[];
  quest_types: string[];
  towner_types: string[];
  regions: string[];
  towner_tiers: string[];
  hoard_type: string;
};

export const STATUS_COLORS: Record<QuestRow['status'], string> = {
  pool: 'label',
  unclaimed: 'label',
  active: 'good',
  complete: 'average',
  failed: 'bad',
};

export const STATUS_LABELS: Record<QuestRow['status'], string> = {
  pool: 'on ledger',
  unclaimed: 'unclaimed',
  active: 'active',
  complete: 'complete',
  failed: 'failed',
};

const ANY_REGION = '';

export const formatSeconds = (seconds: number) =>
  `${Math.floor(seconds / 60)}:${String(seconds % 60).padStart(2, '0')}`;

export const QuestDebugPanel = () => {
  const { act, data } = useBackend<Data>();
  const {
    debug_mode,
    quests,
    quest_types,
    towner_types,
    regions,
    towner_tiers,
    hoard_type,
  } = data;
  const [issueType, setIssueType] = useState(quest_types[0] || '');
  const [issueRegion, setIssueRegion] = useState(ANY_REGION);
  const [issueTier, setIssueTier] = useState(towner_tiers[0] || '');
  const [statusFilter, setStatusFilter] = useState('open');

  const isTowner = towner_types.includes(issueType);
  const needsRegion = issueType === hoard_type;
  const shown = quests.filter((q) =>
    statusFilter === 'all'
      ? true
      : statusFilter === 'open'
        ? q.status !== 'complete' && q.status !== 'failed'
        : q.status === statusFilter,
  );

  return (
    <Window width={980} height={680}>
      <Window.Content scrollable>
        <Section
          title="Debug mode"
          buttons={
            <Button
              icon={debug_mode ? 'toggle-on' : 'toggle-off'}
              color={debug_mode ? 'bad' : 'default'}
              onClick={() => act('toggle_debug_mode')}
            >
              {debug_mode ? 'On' : 'Off'}
            </Button>
          }
        >
          {debug_mode ? (
            <NoticeBox danger>
              Fellowship size and self issue checks are off.
            </NoticeBox>
          ) : (
            <Box color="label">
              Remove the fellowship size and self issue checks.
            </Box>
          )}
        </Section>

        <Section title="Issue Contract">
          <Stack wrap align="center">
            <Stack.Item>
              <Dropdown
                width="15em"
                selected={issueType}
                options={quest_types}
                onSelected={(value) => setIssueType(value)}
              />
            </Stack.Item>
            <Stack.Item>
              <Dropdown
                width="13em"
                selected={issueRegion}
                options={[
                  {
                    value: ANY_REGION,
                    displayText: needsRegion ? 'Pick a region' : 'Any region',
                  },
                  ...regions.map((r) => ({ value: r, displayText: r })),
                ]}
                onSelected={(value) => setIssueRegion(value)}
                disabled={isTowner}
              />
            </Stack.Item>
            {isTowner && (
              <Stack.Item>
                <Dropdown
                  width="8em"
                  selected={issueTier}
                  options={towner_tiers}
                  onSelected={(value) => setIssueTier(value)}
                />
              </Stack.Item>
            )}
            <Stack.Item>
              <Button
                icon="hand-holding"
                disabled={needsRegion && !issueRegion}
                onClick={() =>
                  act('issue', {
                    type: issueType,
                    region: issueRegion,
                    tier: issueTier,
                    in_hand: true,
                  })
                }
              >
                In my hand
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="thumbtack"
                disabled={needsRegion}
                onClick={() =>
                  act('issue', {
                    type: issueType,
                    region: issueRegion,
                    tier: issueTier,
                    in_hand: false,
                  })
                }
              >
                Post on ledger
              </Button>
            </Stack.Item>
          </Stack>
          <Box color="label" mt={1}>
            No deposit. Towner contracts will make you the poster and pick a
            random region. Blockade Defense must be issued from the Ledger as a
            Steward instead.
          </Box>
        </Section>

        <Section
          title={`Contracts (${shown.length})`}
          buttons={
            <Dropdown
              width="9em"
              selected={statusFilter}
              options={[
                { value: 'open', displayText: 'Open' },
                { value: 'active', displayText: 'Active' },
                { value: 'pool', displayText: 'On the ledger' },
                { value: 'complete', displayText: 'Complete' },
                { value: 'failed', displayText: 'Failed' },
                { value: 'all', displayText: 'All' },
              ]}
              onSelected={(value) => setStatusFilter(value)}
            />
          }
        >
          {shown.length === 0 ? (
            <Box color="label">No contracts match this filter.</Box>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell>Contract</Table.Cell>
                <Table.Cell>Region</Table.Cell>
                <Table.Cell>Holder / poster</Table.Cell>
                <Table.Cell>Status</Table.Cell>
                <Table.Cell>Progress</Table.Cell>
                <Table.Cell>Timer</Table.Cell>
                <Table.Cell collapsing>Actions</Table.Cell>
              </Table.Row>
              {shown.map((q) => (
                <Table.Row key={q.ref} className="candystripe">
                  <Table.Cell>
                    <Box bold>{q.type}</Box>
                    <Box color="label">{q.title}</Box>
                  </Table.Cell>
                  <Table.Cell>{q.region || '-'}</Table.Cell>
                  <Table.Cell>
                    <Box>{q.holder || '-'}</Box>
                    {q.giver && <Box color="label">by {q.giver}</Box>}
                  </Table.Cell>
                  <Table.Cell color={STATUS_COLORS[q.status]}>
                    {STATUS_LABELS[q.status]}
                  </Table.Cell>
                  <Table.Cell>
                    {q.progress}
                    {q.is_kill && (
                      <Box color="label">{q.live_targets} alive</Box>
                    )}
                  </Table.Cell>
                  <Table.Cell>
                    {q.timer_label ? (
                      <>
                        <Box>{q.timer_label}</Box>
                        {q.timer_seconds > 0 && (
                          <Box color="label">
                            {formatSeconds(q.timer_seconds)}
                          </Box>
                        )}
                      </>
                    ) : (
                      '-'
                    )}
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Stack>
                      <Stack.Item>
                        <Button
                          icon="location-arrow"
                          tooltip="Teleport to the nearest target, parcel or landmark"
                          onClick={() => act('jump', { ref: q.ref })}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="skull"
                          tooltip="Kill every live target. Counts as kills."
                          disabled={!q.is_kill || q.live_targets === 0}
                          onClick={() => act('slay', { ref: q.ref })}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="forward"
                          tooltip="Fire the running timer now (hunt or wave timeout, end of intermission, blockade arrival)"
                          disabled={!q.timer_label}
                          onClick={() => act('skip_timer', { ref: q.ref })}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button.Confirm
                          icon="check"
                          tooltip="Force complete the contract. It must be turned in at the Ledger except for blockades."
                          disabled={
                            q.status === 'complete' || q.status === 'failed'
                          }
                          onClick={() => act('complete', { ref: q.ref })}
                        />
                      </Stack.Item>
                    </Stack>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
