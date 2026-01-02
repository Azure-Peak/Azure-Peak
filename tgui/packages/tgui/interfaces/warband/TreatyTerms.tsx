import { useMemo, useState } from 'react';
import { Box, Button, Input, NumberInput, Stack, TextArea } from 'tgui-core/components';

import { MASK, sanitize } from './TreatyData';
import { TerritoryDetailsDisplay, WrapBox } from './TreatyDisplays';
import { ComplexTargetInput, TargetInput } from './TreatyInputs';
import { SignatureDisplay } from './TreatySignatures';
import { FactionType, TermType, TerritoryType } from './TreatyTypes';

// active terms
export const ActiveTerm = ({ 
  term, 
  onDraft, 
  onSign, 
  disabled, 
  isExpert, 
  factions, 
  territories,
}: { 
  term: TermType;
  onDraft: () => void;
  onSign: () => void;
  disabled: boolean;
  isExpert: boolean;
  factions: FactionType[];
  territories: TerritoryType[];
}) => {
  const [showOpts, setShowOpts] = useState(false);
  
  const signatures = term.signatures || [];
  const minSigs = term.minimum_signatures || 0;
  const isUnsigned = !term.open_signatures && signatures.length < minSigs;
  const signedSet = new Set(signatures.map(n => n.toLowerCase()));
  
  const isCede = term.target_options === 5;
  const isMammon = term.target_options === 6 || term.target_options === 7;

  const termIconClass = useMemo(() => {
    if (isCede && term.obj_target) {
      const territory = territories.find(x => x.name === term.obj_target);
      if (territory?.faction_name) {
        return factions.find(f => f.name === territory.faction_name)?.icon;
      }
    }
    return null;
  }, [term.obj_target, factions, territories, isCede]);

  const territoryDetails = useMemo(() => {
    if (isCede && term.obj_target) {
      return territories.find(t => t.name === term.obj_target);
    }
    return null;
  }, [isCede, term.obj_target, territories]);

  const handleToggleOptions = () => setShowOpts(!showOpts);
  
  const handleDraftClick = (e: React.MouseEvent) => {
    e.stopPropagation();
    onDraft();
    setShowOpts(false);
  };
  
  const handleSignClick = (e: React.MouseEvent) => {
    e.stopPropagation();
    onSign();
    setShowOpts(false);
  };

  return (
    <Button 
      fluid 
      textAlign="left" 
      className="Section" 
      p={1} 
      onClick={handleToggleOptions} 
      disabled={disabled} 
      style={{ 
        backgroundColor: 'rgba(14, 10, 10, 0.5)', 
        flexDirection: 'column', 
        height: 'auto', 
        minWidth: 0, 
        position: 'relative', 
        marginLeft: '8px',
      }}
    >
      {termIconClass && (
        <Box 
          className={termIconClass} 
          position="absolute" 
          top="4px" 
          right="4px" 
          style={{ transform: isCede ? 'scale(1.2)' : 'scale(0.8)' }} 
        />
      )}

      <Box width="100%">
        <Box 
          bold 
          color="#e9ca9e" 
          style={{ 
            overflowWrap: 'break-word', 
            whiteSpace: 'normal', 
            paddingRight: termIconClass ? '32px' : '0',
          }}
        >
          {term.name}
        </Box>
        <Box 
          mt={0.5} 
          fontSize="0.9em" 
          color="#b1a390" 
          style={{ overflowWrap: 'break-word', whiteSpace: 'normal' }}
        >
          {term.desc}
        </Box>

        {term.text && (
          <Box 
            mt={0.5} 
            p={1} 
            style={{ 
              backgroundColor: 'rgba(0,0,0,0.3)', 
              whiteSpace: 'pre-wrap', 
              maxHeight: '150px', 
              overflowY: 'auto', 
              wordBreak: 'break-word',
            }}
          >
            {isExpert ? term.text : MASK}
          </Box>
        )}

        {!!term.requires_number && (term.number ?? 0) > 0 && (
          <Box mt={0.5} color="label" bold>
            {term.name.toLowerCase().includes('abolish') ? 'Law Number' : 'Value'}: {isExpert ? term.number : MASK}
          </Box>
        )}

        {isCede && (
          <>
            <Box mt={0.5} color="average" style={{ width: '100%' }}>
              <WrapBox label="Source" value={isExpert ? term.target : MASK} />
              <WrapBox label="Recipient" value={isExpert ? term.receiver : MASK} />
              <WrapBox label="Territory" value={isExpert ? term.obj_target : MASK} />
            </Box>
            {isExpert && territoryDetails && (
              <TerritoryDetailsDisplay territory={territoryDetails} factions={factions} />
            )}
          </>
        )}

        {isMammon && (
          <Box mt={0.5} color="average" style={{ width: '100%' }}>
            <WrapBox label="Payer" value={isExpert ? term.target : MASK} />
            <WrapBox label="Recipient" value={isExpert ? term.receiver : MASK} />
          </Box>
        )}
  
        {!isCede && !isMammon && (term.target_options ?? 0) > 0 && term.target && (
          <Box 
            mt={0.5} 
            color="average" 
            bold 
            style={{ overflowWrap: 'break-word', whiteSpace: 'normal' }}
          >
            Target: {isExpert ? term.target : MASK}
          </Box>
        )}

        <SignatureDisplay 
          term={term} 
          signatures={signatures} 
          minSigs={minSigs} 
          isUnsigned={isUnsigned} 
          signedSet={signedSet} 
          factions={factions} 
          territories={territories} 
        />

        <Box mt={1} bold color={term.signed ? 'good' : 'bad'}>
          {term.signed 
            ? 'SIGNED' 
            : (term.open_signatures && signatures.length > 0 ? 'PARTIALLY SIGNED' : 'NOT SIGNED')
          }
        </Box>
      </Box>

      {showOpts && (
        <Stack mt={0.5} width="100%">
          <Stack.Item>
            <Button 
              fluid 
              icon="pen" 
              color="average" 
              disabled={!isExpert} 
              onClick={handleDraftClick}
            >
              DRAFT
            </Button>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Button 
              fluid 
              icon="check" 
              color="good" 
              onClick={handleSignClick} 
              disabled={term.signed}
            >
              {term.signed ? 'SIGNED' : 'SIGN'}
            </Button>
          </Stack.Item>
        </Stack>
      )}
    </Button>
  );
};

// draft terms
export const DraftTerm = ({ 
  term, 
  state, 
  updateState, 
  actions, 
  isValid, 
  isEditing, 
  lists, 
  factions, 
  territories, 
}: {
  term: TermType;
  state: any;
  updateState: (key: string, val: any) => void;
  actions: any;
  isValid: boolean;
  isEditing: boolean;
  lists: any;
  factions: FactionType[];
  territories: TerritoryType[];
}) => {
  const handleInscribe = () => actions.inscribe(term);
  const handleCancel = () => actions.cancel();
  const handleRemove = () => actions.remove();
  
  return (
    <Box>
      {term.open_signatures ? (
        <Input 
          fluid 
          bold 
          value={state.custom_name} 
          onChange={(v) => updateState('custom_name', sanitize(v, 'text'))} 
          placeholder="Enter Term Title..." 
          mb={0.5} 
        />
      ) : (
        <Box bold color="#e9ca9e">{term.name}</Box>
      )}
      <Box mt={0.5} fontSize="0.9em">{term.desc}</Box>

      <TargetInput 
        term={term} 
        state={state} 
        updateState={updateState} 
        lists={lists} 
        factions={factions} 
        territories={territories} 
      />
      <ComplexTargetInput 
        term={term} 
        state={state} 
        updateState={updateState} 
        lists={lists} 
        factions={factions} 
        territories={territories} 
      />

      {!!term.requires_text && (
        <TextArea 
          fluid 
          mt={1} 
          height="100px" 
          placeholder="Enter details (5-2048 chars)" 
          value={state.text} 
          onChange={(v) => updateState('text', sanitize(v, 'text'))} 
        />
      )}

      {!!term.requires_number && (
        <NumberInput 
          fluid 
          mt={1} 
          value={state.number} 
          onChange={(v) => updateState('number', v)} 
          minValue={1} 
          step={1} 
          maxValue={term.name.includes("Tax") ? 100 : term.name === "Mammon" ? 20000 : 999999} 
        />
      )}

      <Stack mt={1}>
        <Stack.Item grow={1}>
          <Button 
            fluid 
            color={isEditing ? 'average' : 'good'} 
            icon="pen" 
            onClick={handleInscribe} 
            disabled={!isValid}
          >
            {isEditing ? 'UPDATE' : 'INSCRIBE'}
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

      {isEditing && (
        <Button 
          fluid 
          color="danger" 
          icon="trash" 
          mt={1} 
          onClick={handleRemove}
        >
          REMOVE TERM
        </Button>
      )}
    </Box>
  );
};
