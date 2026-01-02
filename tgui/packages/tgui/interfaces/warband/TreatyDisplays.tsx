import { Box, Button, Stack } from 'tgui-core/components';

import { MASK } from './TreatyData';
import { FactionType, TerritoryType } from './TreatyTypes';

// displays a faction's info card in the party section
export const PartyDisplay = ({ 
  party, 
  align = 'left', 
  isExpert,
}: { 
  party: FactionType | null | undefined;
  align?: 'left' | 'right';
  isExpert?: boolean;
}) => {
  if (!party) {
    return (
      <Box 
        color="label" 
        textAlign="center" 
        py={2} 
        style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', minHeight: '150px' }}
      >
        {isExpert ? "[CLICK TO SELECT PARTY]" : MASK}
      </Box>
    );
  }

  return (
    <Box position="relative" style={{ overflow: 'visible', height: '150px' }}>
      <Box 
        position="relative" 
        textAlign={align} 
        style={{ zIndex: 1, height: '100%', display: 'flex', flexDirection: 'column' }}
      >
        <Box bold>{party.name}</Box>
        <Box bold color="gold" fontSize="0.9em" mb={0.5}>
          Wealth: {party.vault}
        </Box>
        <Box 
          fontSize="0.9em" 
          color="#b1a390" 
          backgroundColor="#181612" 
          p={1.5} 
          style={{ 
            overflowWrap: 'break-word', 
            whiteSpace: 'normal', 
            flexGrow: 1, 
            overflowY: 'auto', 
            border: '1px solid #333',
          }}
        >
          {party.desc}
        </Box>
      </Box>
    </Box>
  );
};


export const WrapBox = ({ label, value }: { label: string; value: string | undefined }) => (
  <Box>
    {label}: <span style={{ color: '#fff', overflowWrap: 'break-word', wordBreak: 'break-word', whiteSpace: 'normal' }}>{value ?? ''}</span>
  </Box>
);

// displays a territory's info card
export const TerritoryDetailsDisplay = ({ 
  territory, 
  factions,
}: { 
  territory: TerritoryType;
  factions: FactionType[];
}) => {
  const faction = factions.find(x => x.name === territory.faction_name);
  
  return (
    <Box mt={1} p={1} style={{ backgroundColor: 'rgba(0,0,0,0.25)', border: '1px solid #444' }}>
      <Box 
        fontSize="0.85em" 
        color="#b1a390" 
        mb={0.5} 
        style={{ whiteSpace: 'normal', wordBreak: 'break-word' }}
      >
        {territory.desc}
      </Box>

      {territory.prized_good && (
        <Box mt={0.5} fontSize="0.85em" color="average" bold>
          Prized Good: <span style={{ color: '#b1a390' }}>{territory.prized_good}</span>
        </Box>
      )}

      {territory.aspects && territory.aspects.length > 0 && (
        <Box mt={0.5}>
          <Box bold color="average" fontSize="0.8em" mb={0.3}>Aspects</Box>
          <Stack wrap style={{ gap: '4px' }}>
            {territory.aspects.map((aspect, idx) => (
              <Button 
                key={idx}
                tooltip={aspect.desc}
                style={{ 
                  backgroundColor: 'rgba(233, 202, 158, 0.1)', 
                  border: '1px solid #e9ca9e',
                  padding: '2px 6px',
                  borderRadius: '3px',
                  fontSize: '0.75em',
                  color: '#e9ca9e',
                  minHeight: 'auto',
                  height: 'auto',
                }}
              >
                {aspect.name}
              </Button>
            ))}
          </Stack>
        </Box>
      )}
    </Box>
  );
};
