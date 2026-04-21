import {
  Box,
  Button,
  Section,
  Stack,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Decree = {
  id: string;
  name: string;
  year: number;
  flavor: string;
};

type DecreeState = {
  id: string;
  active: BooleanLike;
  cooldown_left: number;
};

type Data = {
  decrees: Decree[];
  states: DecreeState[];
  revoke_used_today: BooleanLike;
  restore_used_today: BooleanLike;
};

const formatCooldown = (seconds: number): string => {
  if (seconds <= 0) return '';
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  if (m > 0) return `${m}m ${s}s`;
  return `${s}s`;
};

export const DecreeSetter = () => {
  const { act, data } = useBackend<Data>();
  const stateById = Object.fromEntries(
    (data.states ?? []).map((s) => [s.id, s]),
  );
  const revokeUsed = !!data.revoke_used_today;
  const restoreUsed = !!data.restore_used_today;

  return (
    <Window width={560} height={640}>
      <Window.Content scrollable>
        <Stack vertical>
          {(revokeUsed || restoreUsed) && (
            <Stack.Item>
              <Box italic color="average">
                {revokeUsed && 'A revocation has been proclaimed today. '}
                {restoreUsed && 'A restoration has been proclaimed today. '}
                Further proclamations of that kind must await the dawn.
              </Box>
            </Stack.Item>
          )}
          {data.decrees?.map((d) => {
            const s = stateById[d.id];
            const active = !!s?.active;
            const cooldownLeft = s?.cooldown_left ?? 0;
            const onCooldown = cooldownLeft > 0;
            const slotUsed = active ? revokeUsed : restoreUsed;
            const disabled = onCooldown || slotUsed;
            const tooltip = onCooldown
              ? `On cooldown: ${formatCooldown(cooldownLeft)}`
              : slotUsed
                ? active
                  ? 'A revocation has already been proclaimed today.'
                  : 'A restoration has already been proclaimed today.'
                : active
                  ? 'Suspend this decree'
                  : 'Restore this decree';
            return (
              <Stack.Item key={d.id}>
                <Section
                  title={`${d.name} of ${d.year}`}
                  buttons={
                    <Button.Confirm
                      color={active ? 'bad' : 'good'}
                      disabled={disabled}
                      tooltip={tooltip}
                      onClick={() => act('toggle', { id: d.id })}
                    >
                      {active ? 'Suspend' : 'Restore'}
                    </Button.Confirm>
                  }
                >
                  <Box italic color={active ? 'good' : 'bad'} mb={1}>
                    {active ? 'In force' : 'Suspended'}
                    {onCooldown && ` — cooldown ${formatCooldown(cooldownLeft)}`}
                  </Box>
                  <Box preserveWhitespace>{d.flavor}</Box>
                </Section>
              </Stack.Item>
            );
          })}
        </Stack>
      </Window.Content>
    </Window>
  );
};
