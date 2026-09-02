import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Box,
  Button,
  Icon,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { round } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';

import { TegakiAnimation } from './common/TegakiAnimation';

type Data = {
  server_name: string;
  ticker_state: TickerState;
  ready: number;
  migrant: BooleanLike;
  active_character: string | null;

  time_remaining: number;
  ready_count: number;
  ready_jobs: Job[];
};

enum TickerState {
  Startup = 0,
  Pregame = 1,
  SettingUp = 2,
  Playing = 3,
  Finished = 4,
}

type Job = {
  name: string;
  length: number;
  players: string | null;
};

export const NewPlayerPanel = (props) => {
  const { data } = useBackend<Data>();
  const { ticker_state } = data;

  let calculatedHeight;
  switch (ticker_state) {
    case TickerState.Startup:
    case TickerState.Pregame:
      calculatedHeight = 600;
      break;
    case TickerState.SettingUp:
    case TickerState.Playing:
    case TickerState.Finished:
      calculatedHeight = 400;
      break;
  }

  return (
    <Window
      canClose={false}
      width={400}
      height={calculatedHeight}
      theme="parchment"
    >
      <Window.Content>
        <Stack vertical fill height="96%" m={1}>
          <Stack.Item>
            <WelcomeAnimation />
          </Stack.Item>
          <NewPlayerButtons />
          {[TickerState.Startup, TickerState.Pregame].includes(ticker_state) ? (
            <PreGame />
          ) : null}
          {ticker_state === TickerState.SettingUp ? <SettingUpGame /> : null}
          {ticker_state === TickerState.Playing ? <ActiveGame /> : null}
          {ticker_state === TickerState.Finished ? <FinishedGame /> : null}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const WelcomeAnimation = (props) => {
  const { data } = useBackend<Data>();
  const { server_name } = data;

  return (
    <Box mt={1}>
      <TegakiAnimation
        height={4}
        time={{ mode: 'uncontrolled', speed: 10, loop: false }}
        style={{ fontSize: 30, textAlign: 'center' }}
      >
        Welcome To {toTitleCase(server_name)}
      </TegakiAnimation>
    </Box>
  );
};

const NewPlayerButtons = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <>
      <Stack.Item>
        <Button onClick={() => act('show_preferences')} fluid icon="user">
          Character Setup
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button onClick={() => act('show_options')} fluid icon="cog">
          Game Options
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button onClick={() => act('show_keybinds')} fluid icon="keyboard">
          Keybindings
        </Button>
      </Stack.Item>
    </>
  );
};

const PreGame = (props) => {
  const { act, data } = useBackend<Data>();
  const { time_remaining, ready, ready_count, ready_jobs } = data;

  return (
    <>
      <Stack.Item>
        <Section title="Pre-Game Lobby">
          <Stack align="center" justify="space-between">
            <Stack.Item minWidth={0}>
              <Stack vertical>
                {data.active_character ? (
                  <Stack.Item overflowX="hidden">
                    Playing As: {data.active_character}
                  </Stack.Item>
                ) : null}
                <Stack.Item>
                  Time to start:{' '}
                  {time_remaining > 0 ? (
                    <AnimatedNumber
                      value={round(time_remaining / 10, 0)}
                      format={(val) => `${val.toFixed(0)}s`}
                    />
                  ) : time_remaining === -10 ? (
                    'DELAYED'
                  ) : (
                    'SOON'
                  )}
                </Stack.Item>
                <Stack.Item>Total players ready: {ready_count}</Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack vertical align="center">
                <Stack.Item>
                  <Button.Checkbox
                    checked={!!ready}
                    selected={!!ready}
                    onClick={() => act('ready')}
                  >
                    {ready ? 'Ready' : 'Not Ready'}
                  </Button.Checkbox>
                </Stack.Item>
                <Stack.Item>
                  <Tooltip content="Ready up for 20 mammons in a stashed pouch, full hydration, a great meal buff and +1 triumph!">
                    {ready ? (
                      <Box color="good">Ready Bonus! (?)</Box>
                    ) : (
                      <Box color="bad">No Bonus (?)</Box>
                    )}
                  </Tooltip>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="Classes" fill scrollable>
          <Stack vertical>
            {ready_jobs.map((job) => (
              <Stack.Item key={job.name}>
                <b>{job.name}</b> ({job.length})
                {job.players ? ` - ${job.players}` : null}
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </>
  );
};

const ActiveGame = (props) => {
  const { act, data } = useBackend<Data>();
  const { migrant } = data;

  return (
    <Stack.Item>
      <Section title="Late Join">
        <Stack vertical>
          <Stack.Item>
            <Button
              onClick={() => act('late_join')}
              disabled={migrant}
              tooltip={migrant ? 'You are in the migrant queue.' : null}
              fluid
              ellipsis
              icon="door-open"
            >
              {data.active_character
                ? `Join Late (Playing As: ${data.active_character})`
                : 'Join Late'}
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button onClick={() => act('migrants')} fluid icon="caravan">
              Migration
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button onClick={() => act('manifest')} fluid icon="users">
              Actors
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button onClick={() => act('observe')} fluid icon="eye">
              Voyeur
            </Button>
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};

const SettingUpGame = (props) => {
  return (
    <Stack.Item grow>
      <Section fill>
        <Stack vertical fill align="center" justify="center">
          <Stack.Item fontSize={1.4} bold mb={2}>
            Round Is Starting...
          </Stack.Item>
          <Stack.Item>
            <Icon size={2} name="clock" spin />
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};

const FinishedGame = (props) => {
  return (
    <Stack.Item grow>
      <Section fill>
        <Stack vertical fill align="center" justify="center">
          <Stack.Item fontSize={1.4} bold mb={2}>
            WEEKS END
          </Stack.Item>
          <Stack.Item>
            <Icon size={2} name="clock" spin />
          </Stack.Item>
          <Stack.Item mt={2}>Thanks For Playing!</Stack.Item>
          <Stack.Item fontSize={0.8}>The server will restart soon.</Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};
