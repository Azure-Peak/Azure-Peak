import { useEffect, useState } from 'react';
import { Box, Button, Dropdown, Stack } from 'tgui-core/components';

import { PartyDisplay } from './TreatyDisplays';
import { FactionType } from './TreatyTypes';

export const PartySelector = ({ 
  act, 
  party, 
  partyId, 
  factions, 
  options, 
  align, 
  isExpert,
}: {
  act: (action: string, params: any) => void;
  party: FactionType | null | undefined;
  partyId: number;
  factions: FactionType[];
  options: any[];
  align: 'left' | 'right';
  isExpert: boolean;
}) => {
  const [isEditing, setIsEditing] = useState(false);
  const [selection, setSelection] = useState<FactionType | null>(party ?? null);
  const isRight = align === 'right';
  
  useEffect(() => { 
    if (!isEditing) setSelection(party ?? null); 
  }, [party, isEditing]);
  
  const handleEditClick = () => {
    setSelection(party ?? null);
    setIsEditing(true);
  };
  
  const handleLockIn = () => {
    if (selection) {
      act('set_party', { name: selection.name, party_id: partyId });
    }
    setIsEditing(false);
  };
  
  const handleCancel = () => {
    setSelection(party ?? null);
    setIsEditing(false);
  };
  
  return (
    <Box 
      className="Section" 
      p={1} 
      style={{ backgroundColor: 'rgba(0,0,0,0.4)', position: 'relative' }}
    >
      {party?.icon && (
        <Box 
          className={party.icon} 
          position="absolute" 
          top="0" 
          right={isRight ? undefined : "0"} 
          left={isRight ? "0" : undefined} 
          style={{ zIndex: 2, transform: 'scale(1)', margin: '4px' }} 
        />
      )}

      {!isEditing ? (
        <Button 
          fluid 
          style={{ 
            background: 'transparent', 
            color: 'inherit', 
            padding: 0, 
            height: 'auto', 
            textAlign: align, 
            boxShadow: 'none',
          }} 
          onClick={handleEditClick}
        >
          <PartyDisplay party={party} align={align} isExpert={isExpert} />
        </Button>
      ) : (
        <>
          <PartyDisplay party={selection} align={align} isExpert={isExpert} />
          <Dropdown 
            fluid 
            mt={1} 
            placeholder="SELECT A PARTY" 
            options={options} 
            selected={selection?.name} 
            onSelected={(v) => setSelection(factions.find(f => f.name === v) || null)} 
          />
          <Stack mt={1}>
            <Stack.Item grow={1}>
              <Button 
                fluid 
                color="good" 
                icon="check" 
                onClick={handleLockIn} 
                disabled={!selection || selection?.name === party?.name}
              >
                LOCK IN
              </Button>
            </Stack.Item>
            <Stack.Item grow={1}>
              <Button 
                fluid 
                color="bad" 
                icon="times" 
                onClick={handleCancel}
              >
                CANCEL
              </Button>
            </Stack.Item>
          </Stack>
        </>
      )}
    </Box>
  );
};
