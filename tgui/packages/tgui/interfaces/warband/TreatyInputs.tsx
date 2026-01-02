import { useMemo } from 'react';
import { Box, Dropdown, Input, Stack } from 'tgui-core/components';

import { sanitize } from './TreatyData';
import { FactionType, TermType, TerritoryType } from './TreatyTypes';

// complex target inputs (options 5 through 7)
export const ComplexTargetInput = ({ 
  term, 
  state, 
  updateState, 
  lists, 
  factions, 
  territories,
}: {
  term: TermType;
  state: any;
  updateState: (key: string, val: any) => void;
  lists: any;
  factions: FactionType[];
  territories: TerritoryType[];
}) => {
  const { target_options: opts } = term;

  const availableTerritories = useMemo(() => {
    if (!state.target) return [];
    return territories
      .filter(t => t.faction_name === state.target)
      .map(t => ({ 
        text: t.name, 
        value: t.name, 
        displayText: t.name, 
        icon: factions.find(f => f.name === t.faction_name)?.icon,
      }));
  }, [state.target, territories, factions]);
  
  const handleTargetChange = (v: string) => {
    updateState('target', v);
    updateState('obj_target', '');
  };

  // OPTION 5: faction -> faction + territory selection
  if (opts === 5) {
    return (
      <Box mt={1}>
        <Stack vertical>
          <Stack.Item>
            <Box color="label" mb={0.5}>From (Source)</Box>
            <Dropdown 
              fluid 
              options={lists.factions.filter(f => f.value !== state.receiver)} 
              selected={state.target} 
              onSelected={handleTargetChange} 
              placeholder="Select Faction..." 
            />
          </Stack.Item>
          <Stack.Item>
            <Box color="label" mb={0.5}>To (Recipient)</Box>
            <Dropdown 
              fluid 
              options={lists.factions.filter(f => f.value !== state.target)} 
              selected={state.receiver} 
              onSelected={(v) => updateState('receiver', v)} 
              placeholder="Select Faction..." 
            />
          </Stack.Item>
          <Stack.Item>
            <Box color="label" mb={0.5}>Territory</Box>
            <Dropdown 
              fluid 
              options={availableTerritories} 
              selected={state.obj_target} 
              onSelected={(v) => updateState('obj_target', v)} 
              placeholder={state.target ? "Select Territory..." : "Select Source First"} 
              disabled={!state.target} 
            />
            {state.obj_target && (() => {
              const territory = territories.find(x => x.name === state.obj_target);
              const faction = factions.find(x => x.name === territory?.faction_name);
              return (
                <Box 
                  mt={1} 
                  p={1} 
                  textAlign="left" 
                  style={{ 
                    backgroundColor: 'rgba(0,0,0,0.3)', 
                    border: '1px solid #333', 
                    maxHeight: '120px', 
                    overflowY: 'auto',
                  }}
                >
                  <Stack align="center" mb={1}>
                    {faction?.icon && (
                      <Box className={faction.icon} style={{ transform: 'scale(1.2)' }} />
                    )}
                    <Box bold color="#e9ca9e" fontSize="1.1em" ml={faction?.icon ? 1 : 0}>
                      {territory?.name}
                    </Box>
                  </Stack>
                  <Box 
                    fontSize="0.9em" 
                    color="#b1a390" 
                    mb={1} 
                    style={{ whiteSpace: 'normal', wordBreak: 'break-word' }}
                  >
                    {territory?.desc || 'No description available.'}
                  </Box>
                  {territory?.prized_good && (
                    <Box fontSize="0.85em" color="average" bold mb={1}>
                      Prized Good: <span style={{ color: '#b1a390' }}>{territory.prized_good}</span>
                    </Box>
                  )}
                  {territory?.aspects && territory.aspects.length > 0 && (
                    <Box mt={1}>
                      <Box bold color="average" fontSize="0.8em" mb={0.5}>Aspects</Box>
                      {territory.aspects.map((aspect, idx) => (
                        <Box 
                          key={idx} 
                          mb={0.5} 
                          p={0.5} 
                          style={{ 
                            backgroundColor: 'rgba(255,255,255,0.05)', 
                            borderLeft: '2px solid #e9ca9e',
                          }}
                        >
                          <Box bold fontSize="0.8em" color="#e9ca9e">{aspect.name}</Box>
                          <Box 
                            fontSize="0.75em" 
                            color="#8b7355" 
                            style={{ whiteSpace: 'normal', wordBreak: 'break-word' }}
                          >
                            {aspect.desc}
                          </Box>
                        </Box>
                      ))}
                    </Box>
                  )}
                </Box>
              );
            })()}
          </Stack.Item>
        </Stack>
      </Box>
    );
  }

  // OPTION 6: open text w/two targets
  if (opts === 6) {
    return (
      <Box mt={1}>
        <Stack vertical>
          <Stack.Item>
            <Box color="label" mb={0.5}>Payer (Source)</Box>
            <Input 
              fluid 
              value={state.target} 
              onChange={(val) => updateState('target', val)} 
              placeholder="Enter Faction or Target Name..." 
            />
          </Stack.Item>
          <Stack.Item>
            <Box color="label" mb={0.5}>Recipient</Box>
            <Input 
              fluid 
              value={state.receiver} 
              onChange={(val) => updateState('receiver', val)} 
              placeholder="Enter Faction or Target Name..." 
            />
          </Stack.Item>
        </Stack>
      </Box>
    );
  }

  // OPTION 7: faction -> faction tribute
  if (opts === 7) {
    return (
      <Box mt={1}>
        <Stack vertical>
          <Stack.Item>
            <Box color="label" mb={0.5}>Payer (Source)</Box>
            <Dropdown 
              fluid 
              options={lists.factions.filter(f => f.value !== state.receiver)} 
              selected={state.target} 
              onSelected={(v) => updateState('target', v)} 
              placeholder="Select Faction..." 
            />
          </Stack.Item>
          <Stack.Item>
            <Box color="label" mb={0.5}>Recipient</Box>
            <Dropdown 
              fluid 
              options={lists.factions.filter(f => f.value !== state.target)} 
              selected={state.receiver} 
              onSelected={(v) => updateState('receiver', v)} 
              placeholder="Select Faction..." 
            />
          </Stack.Item>
        </Stack>
      </Box>
    );
  }
  
  return null;
};

// simple target input
export const TargetInput = ({ 
  term, 
  state, 
  updateState, 
  lists, 
  factions, 
  territories,
}: {
  term: TermType;
  state: any;
  updateState: (key: string, val: any) => void;
  lists: any;
  factions: FactionType[];
  territories: TerritoryType[];
}) => {
  const { target_options: opts } = term;
  
  if (!opts || opts >= 5) return null;
  
  const availableTerritoriesForOpt2 = useMemo(() => {
    if (opts !== 2 || !state.intermediateTarget) return [];
    return territories
      .filter(t => t.faction_name === state.intermediateTarget)
      .map(t => ({ 
        text: t.name, 
        value: t.name, 
        displayText: t.name,
        icon: factions.find(f => f.name === t.faction_name)?.icon,
      }));
  }, [opts, state.intermediateTarget, territories, factions]);
  
  const handleIntermediateTargetChange = (v: string) => {
    updateState('intermediateTarget', v);
    updateState('target', '');
  };
  
  // OPTION 1: name input
  if (opts === 1) {
    return (
      <Input 
        fluid 
        mt={1} 
        value={state.target} 
        onChange={(val) => updateState('target', sanitize(val, 'name'))} 
        placeholder="Enter Target Name..." 
      />
    );
  }
  
  // OPTION 2: select a faction's territory
  if (opts === 2) {
    return (
      <Box mt={1}>
        <Stack vertical>
          <Stack.Item>
            <Box color="label" mb={0.5}>Select Faction</Box>
            <Dropdown 
              fluid 
              options={lists.factions} 
              selected={state.intermediateTarget} 
              onSelected={handleIntermediateTargetChange} 
              placeholder="Select Faction..." 
            />
          </Stack.Item>
          <Stack.Item>
            <Box color="label" mb={0.5}>Select Territory</Box>
            <Dropdown 
              fluid 
              options={availableTerritoriesForOpt2} 
              selected={state.target} 
              onSelected={(v) => updateState('target', v)} 
              placeholder={state.intermediateTarget ? "Select Territory..." : "Select Faction First"} 
              disabled={!state.intermediateTarget} 
            />
          </Stack.Item>
        </Stack>
      </Box>
    );
  }
  
  // Option 3: select a single faction
  if (opts === 3) {
    return (
      <Dropdown 
        fluid 
        mt={1} 
        options={lists.factions} 
        selected={state.target} 
        onSelected={(val) => updateState('target', val)} 
        placeholder="Select Faction..." 
      />
    );
  }
  
  return null;
};
