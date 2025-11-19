import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Divider, Input, Section, Stack } from 'tgui-core/components';

import { ActionButton } from './sexcon/ActionButton';
import { ProgressBars } from './sexcon/ProgressBars';
import type { SexAction, SexSessionData } from './sexcon/types';

export const SexSession = () => {
  const { act, data } = useBackend<SexSessionData>();
  const [searchText, setSearchText] = useState('');
  const [arousalInput, setArousalInput] = useState('');

  // Color mapping for speed and force (matching old sexcon)
  const speedColors = ['#eac8de', '#e9a8d1', '#f05ee1', '#d146f5'];
  const forceColors = ['#eac8de', '#e9a8d1', '#f05ee1', '#d146f5'];

  // Split actions into two columns
  const filteredActions = data.actions.filter((action) =>
    action.name.toLowerCase().includes(searchText.toLowerCase())
  );

  const leftColumn: SexAction[] = [];
  const rightColumn: SexAction[] = [];
  filteredActions.forEach((action, index) => {
    if (index % 2 === 0) {
      leftColumn.push(action);
    } else {
      rightColumn.push(action);
    }
  });
  
  const onClickActionButton = (actionType: string) => {
    if(data.current_action === actionType) {
      act('stop_action');
      return;
    }
    act('start_action', { action_type: actionType });
  };

  return (
    <Window title="Sate Desires" width={500} height={600}>
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Box textAlign="center" bold fontSize="1.1em">
              {data.title}
            </Box>
            {data.session_name && data.session_name !== 'Private Session' && (
              <Box textAlign="center" color="label" fontSize="0.9em">
                {data.session_name}
              </Box>
            )}
          </Stack.Item>

          <Stack.Item>
            <ProgressBars
              arousal={data.arousal}
            />
          </Stack.Item>
          <Divider />
          <Stack.Item>
            <Section>
              <Stack vertical>
                <Stack.Item>
                  <Box textAlign="center">
                    <Button
                      inline
                      compact
                      onClick={() => act('set_speed', { value: Math.max(1, data.speed - 1) })}
                    >
                      &lt;
                    </Button>
                    {' '}
                    <Box
                      as="span"
                      bold
                      style={{
                        color: speedColors[data.speed - 1],
                        display: 'inline-block',
                        minWidth: '110px',
                        textAlign: 'center',
                      }}
                    >
                      {data.speed_names[data.speed - 1]}
                    </Box>
                    {' '}
                    <Button
                      inline
                      compact
                      onClick={() => act('set_speed', { value: Math.min(4, data.speed + 1) })}
                    >
                      &gt;
                    </Button>
                    {` -- | -- `}
                    <Button
                      inline
                      compact
                      onClick={() => act('set_force', { value: Math.max(1, data.force - 1) })}
                    >
                      &lt;
                    </Button>
                    {' '}
                    <Box
                      as="span"
                      bold
                      style={{
                        color: forceColors[data.force - 1],
                        display: 'inline-block',
                        minWidth: '90px',
                        textAlign: 'center',
                      }}
                    >
                      {data.force_names[data.force - 1]}
                    </Box>
                    {' '}
                    <Button
                      inline
                      compact
                      onClick={() => act('set_force', { value: Math.min(4, data.force + 1) })}
                    >
                      &gt;
                    </Button>
                  </Box>
                </Stack.Item>

                {/* Finish Condition */}
                <Stack.Item>
                  <Box textAlign="center">
                    <Button
                      inline
                      compact
                      color="transparent"
                      onClick={() => act('toggle_finished')}
                    >
                      {data.do_until_finished ? "UNTIL I'M FINISHED" : 'UNTIL I STOP'}
                    </Button>
                    {!!data.has_knotted_penis && (
                      <>
                        {' | '}
                        <Button
                          inline
                          compact
                          color="transparent"
                          onClick={() => act('toggle_knot')}
                        >
                          <Box
                            as="span"
                            bold
                            style={{ color: data.do_knot_action ? '#d146f5' : '#eac8de' }}
                          >
                            {data.do_knot_action ? 'USING KNOT' : 'TOGGLE KNOT'}
                          </Box>
                        </Button>
                      </>
                    )}
                  </Box>
                </Stack.Item>

                {/* Arousal Controls */}
                <Stack.Item>
                  <Box textAlign="center">
                    <Input
                      placeholder="Set arousal..."
                      value={arousalInput}
                      onChange={setArousalInput}
                      width="120px"
                      onEnter={() => {
                        const amount = parseInt(arousalInput, 10);
                        if (!isNaN(amount)) {
                          act('set_arousal_value', { amount });
                          setArousalInput('');
                        }
                      }}
                    />
                    {' '}
                    <Button
                      inline
                      compact
                      color="transparent"
                      onClick={() => {
                        const amount = parseInt(arousalInput, 10);
                        if (!isNaN(amount)) {
                          act('set_arousal_value', { amount });
                          setArousalInput('');
                        }
                      }}
                    >
                      SET
                    </Button>
                    {' | '}
                    <Button
                      inline
                      compact
                      color="transparent"
                      onClick={() => act('freeze_arousal')}
                    >
                      {data.frozen ? 'UNFREEZE' : 'FREEZE'}
                    </Button>
                    {' | '}
                    <Button
                      inline
                      compact
                      color="transparent"
                      disabled={!data.current_action}
                      onClick={() => act('stop_action')}
                    >
                      STOP
                    </Button>
                  </Box>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Divider />
          {/* Search */}
          <Stack.Item>
            <Box textAlign="center" italic color="label">
              Doing unto {data.title.replace('Interacting with ', '').replace('...', '')}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Input
              fluid
              placeholder="Search for an interaction..."
              value={searchText}
              onChange={setSearchText}
            />
          </Stack.Item>

          {/* Two-Column Action Grid */}
          <Stack.Item grow>
            <Section fill scrollable>
              <Stack fill>
                {/* Left Column */}
                <Stack.Item basis="50%">
                  <Stack vertical>
                    {leftColumn.map((action) => {
                      const isCurrentAction = data.current_action === action.type;
                      const isAvailable = data.can_perform.includes(action.type);

                      return (
                        <Stack.Item key={action.type}>
                          <Box textAlign="center">
                            <ActionButton
                              action={action}
                              isCurrentAction={isCurrentAction}
                              isAvailable={isAvailable}
                              onClick={() => onClickActionButton(action.type)}
                            />
                          </Box>
                        </Stack.Item>
                      );
                    })}
                  </Stack>
                </Stack.Item>

                {/* Right Column */}
                <Stack.Item basis="50%">
                  <Stack vertical>
                    {rightColumn.map((action) => {
                      const isCurrentAction = data.current_action === action.type;
                      const isAvailable = data.can_perform.includes(action.type);

                      return (
                        <Stack.Item key={action.type}>
                          <Box textAlign="center">
                            <ActionButton
                              action={action}
                              isCurrentAction={isCurrentAction}
                              isAvailable={isAvailable}
                              onClick={() => onClickActionButton(action.type)}
                            />
                          </Box>
                        </Stack.Item>
                      );
                    })}
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
