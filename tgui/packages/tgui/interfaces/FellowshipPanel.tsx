import { useState } from 'react';
import { Button, Input, Section, Stack, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Member = {
  name: string;
  is_leader: BooleanLike;
  is_self: BooleanLike;
};

type OutgoingInvite = {
  name: string;
  expires_at: number;
};

type IncomingInvite = {
  fellowship_name: string;
  leader_name: string;
  member_count: number;
  max_members: number;
  expires_at: number;
  ref: string;
};

type FellowshipData = {
  user_name: string;
  in_fellowship: BooleanLike;
  max_members: number;
  server_time: number;
  // Not in fellowship
  pending_invites?: IncomingInvite[];
  // In fellowship
  fellowship_name?: string;
  is_leader?: BooleanLike;
  leader_name?: string | null;
  leader_present?: BooleanLike;
  members?: Member[];
  outgoing_invites?: OutgoingInvite[];
};

// world.time is in deciseconds.
const secondsLeft = (expires_at: number, server_time: number) =>
  Math.max(0, Math.ceil((expires_at - server_time) / 10));

export const FellowshipPanel = () => {
  const { data } = useBackend<FellowshipData>();
  return (
    <Window title="Fellowship" width={520} height={560}>
      <Window.Content>
        {data.in_fellowship ? <FellowshipView /> : <NoFellowshipView />}
      </Window.Content>
    </Window>
  );
};

const NoFellowshipView = () => {
  const { act, data } = useBackend<FellowshipData>();
  const [name, setName] = useState('');
  const invites = data.pending_invites || [];
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="Form a Fellowship">
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                placeholder="Fellowship name"
                value={name}
                onChange={(value) => setName(value)}
                maxLength={32}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="flag"
                disabled={name.trim().length < 3}
                onClick={() => act('create', { name: name.trim() })}
              >
                Found
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="Pending Invitations" fill scrollable>
          {invites.length === 0 ? (
            <i>You have no pending invitations.</i>
          ) : (
            <Table>
              {invites.map((inv) => (
                <Table.Row key={inv.ref}>
                  <Table.Cell>
                    <b>{inv.fellowship_name}</b>
                    <br />
                    <span style={{ opacity: 0.7 }}>
                      Led by {inv.leader_name} &middot; {inv.member_count}/
                      {inv.max_members} members &middot;{' '}
                      {secondsLeft(inv.expires_at, data.server_time)}s left
                    </span>
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      icon="check"
                      color="good"
                      onClick={() => act('accept_invite', { ref: inv.ref })}
                    >
                      Accept
                    </Button>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const FellowshipView = () => {
  const { act, data } = useBackend<FellowshipData>();
  const members = data.members || [];
  const outgoing = data.outgoing_invites || [];
  const isLeader = !!data.is_leader;
  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title={data.fellowship_name}>
          <Stack>
            <Stack.Item grow>
              {data.leader_present ? (
                <>Led by <b>{data.leader_name}</b></>
              ) : (
                <i>Leaderless (the founder is gone).</i>
              )}
              <br />
              <span style={{ opacity: 0.7 }}>
                {members.length} / {data.max_members} members
              </span>
            </Stack.Item>
            <Stack.Item>
              {isLeader ? (
                <Button
                  icon="ban"
                  color="bad"
                  onClick={() => act('disband')}
                >
                  Disband
                </Button>
              ) : (
                <Button
                  icon="sign-out-alt"
                  color="bad"
                  onClick={() => act('leave')}
                >
                  Leave
                </Button>
              )}
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="Members" fill scrollable>
          <Table>
            {members.map((m) => (
              <Table.Row key={m.name}>
                <Table.Cell>
                  {m.name}
                  {!!m.is_leader && ' (Leader)'}
                  {!!m.is_self && ' (You)'}
                </Table.Cell>
                <Table.Cell collapsing>
                  {isLeader && !m.is_self && !m.is_leader && (
                    <Button
                      icon="user-slash"
                      color="bad"
                      onClick={() => act('kick', { name: m.name })}
                    >
                      Kick
                    </Button>
                  )}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
      {isLeader && (
        <Stack.Item>
          <Section
            title="Invitations"
            buttons={
              <Button
                icon="user-plus"
                disabled={members.length >= (data.max_members || 6)}
                onClick={() => act('invite')}
              >
                Invite Nearby
              </Button>
            }
          >
            {outgoing.length === 0 ? (
              <i>No pending invitations.</i>
            ) : (
              <Table>
                {outgoing.map((inv) => (
                  <Table.Row key={inv.name}>
                    <Table.Cell>
                      {inv.name}
                      <span style={{ opacity: 0.6 }}>
                        {' '}
                        &middot; {secondsLeft(inv.expires_at, data.server_time)}s left
                      </span>
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <Button
                        icon="times"
                        onClick={() => act('rescind', { name: inv.name })}
                      >
                        Rescind
                      </Button>
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            )}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};
