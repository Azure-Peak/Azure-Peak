import React from 'react';
import {
  Button,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
type Curse = {
  name: string;
  path: string;
  cost: number;
  min_tier: number;
};

type Boon = {
  id: string;
  victim_name: string;
  name: string;
  points: number;
  transmutable: boolean;
  selected: boolean;
};

type Victim = {
  name: string;
  boons: Boon[];
};

type Data = {
  victims: Victim[];
  curse_options: Curse[];
  total_points: number;
  hag_tier: number;
  selected_curse_path: string | null;
};

export const HagTransmutation = (props) => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = React.useState(0);
  const { victims, curse_options, total_points, selected_curse_path } = data;
  const selectedCurse = curse_options.find(c => c.path === selected_curse_path);
  const canCommit = !!selectedCurse && total_points >= selectedCurse.cost;

  return (
    <Window width={500} height={600} title="Rite of Transmutation">
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab selected={tab === 0} onClick={() => setTab(0)}>Liquidate Debt</Tabs.Tab>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>Impose Blight</Tabs.Tab>
        </Tabs>

        {tab === 0 && (
          <Section title="Active Pacts">
            {victims.map(victim => (
              <Section key={victim.name} title={victim.name}>
                <Stack vertical>
                  {victim.boons.map(boon => (
                    <Button 
                      key={boon.id + victim.name} 
                      disabled={!boon.transmutable}
                      selected={boon.selected} 
                      onClick={() => act('toggle_boon', { id: boon.id, victim_name: victim.name })}
                    >
                      {boon.name} {boon.transmutable ? `(${boon.points} pts)` : "(Active Curse)"}
                    </Button>
                  ))}
                </Stack>
              </Section>
            ))}
          </Section>
        )}

        {tab === 1 && (
          <Section title="Available Curses">
            {curse_options.map(curse => (
              <Button 
                key={curse.path} 
                fluid 
                selected={selected_curse_path === curse.path} 
                onClick={() => act('select_curse', { path: curse.path })}
              >
                {curse.name} (Cost: {curse.cost} pts)
              </Button>
            ))}
          </Section>
        )}

        <Section title="Finalize">
          <Button 
            fluid 
            color="bad" 
            disabled={!canCommit}
            onClick={() => act('commit_transmutation')}
          >
            {selectedCurse && total_points < selectedCurse.cost 
              ? `Need ${selectedCurse.cost - total_points} more pts` 
              : `Seal the Pact (${total_points} pts)`}
          </Button>
        </Section>
      </Window.Content>
    </Window>
  );
};
