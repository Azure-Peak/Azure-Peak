import { useMemo, useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import { Window } from '../layouts';
import { MASK } from './warband/TreatyData';
import { useTreatyData } from './warband/TreatyData';
import { PartyDisplay } from './warband/TreatyDisplays';
import { PartySelector } from './warband/TreatyPartySelector';
import { ActiveTerm, DraftTerm } from './warband/TreatyTerms';
import { TermType } from './warband/TreatyTypes';


export const TreatyMenu = () => {
  const { data, act, party1, party2, activeTerms, availableTerms, factions, territories } = useTreatyData();
  const isExpert = !!data?.is_expert;

  const [draft, setDraft] = useState({ 
    term: null as TermType | null, 
    text: "", 
    number: null as number | null, 
    custom_name: "", 
    target: "", 
    receiver: "", 
    obj_target: "", 
    intermediateTarget: "", 
    index: null as number | null,
  });

  const updateDraft = (key: string, val: any) => setDraft(prev => ({ ...prev, [key]: val }));
  
  const resetDraft = () => setDraft({ 
    term: null, 
    text: "", 
    number: null, 
    custom_name: "", 
    target: "", 
    receiver: "", 
    obj_target: "", 
    intermediateTarget: "", 
    index: null,
  });

  const lists = useMemo(() => ({ 
    factions: factions.map(f => ({ 
      text: f.name, 
      value: f.name, 
      displayText: f.name, 
      icon: f.icon,
    })), 
    territories: territories.map(t => ({ 
      text: t.name, 
      value: t.name, 
      displayText: t.name,
    })), 
    factionObjs: factions,
  }), [factions, territories]);

  
  const isDraftValid = useMemo(() => {
    const { term, text, number, target, receiver, obj_target, custom_name } = draft;
    if (!term) return true;
    
    if (term.requires_text && (text.length < 5 || text.length > 2048)) return false;
    if (term.requires_number && (!number || number < 1)) return false;
    if (term.open_signatures && (!custom_name || custom_name.length < 3)) return false;
    if ((term.target_options ?? 0) > 0 && (term.target_options ?? 0) < 5 && !target) return false;
    if (term.target_options === 5 && (!target || !receiver || !obj_target || target === receiver)) return false;
    if ((term.target_options === 6 || term.target_options === 7) && (!target || !receiver || target === receiver)) return false;
    
    return true;
  }, [draft]);


  const actions = {
    select: (term: TermType, isEdit = false) => setDraft({ 
      term, 
      index: isEdit ? (term.index ?? null) : null, 
      text: term.text || "", 
      number: term.requires_number ? (term.number || 1) : null, 
      target: term.target || "", 
      receiver: term.receiver || "", 
      obj_target: term.obj_target || "", 
      custom_name: term.custom_name || term.name, 
      intermediateTarget: "",
    }),

    inscribe: (term: TermType) => {
      const payload: any = { 
        index: draft.index, 
        name: term.original_name || term.name,
      };
      
      if (term.requires_text) payload.text = draft.text;
      if (term.requires_number) payload.number = draft.number;
      
      if ((term.target_options ?? 0) > 0) {
        payload.target = draft.target;
        if (term.target_options === 5 || term.target_options === 6 || term.target_options === 7) {
          payload.receiver = draft.receiver;
          if (term.target_options === 5) payload.obj_target = draft.obj_target;
        }
      }
      
      if (term.open_signatures) payload.custom_name = draft.custom_name;
      
      act(draft.index !== null ? 'edit_term' : 'add_term', payload);
      resetDraft();
    },

    remove: () => { 
      if (draft.index !== null) {
        act('remove_term', { index: draft.index }); 
      }
      resetDraft(); 
    },

    cancel: resetDraft,

    sign: (term: TermType) => {
      if (term.index !== null) {
        act('sign_term', { index: term.index });
      }
    },
  };

  return (
    <Window theme="treaty" width={950} height={62}>
      <Window.Content>
        <Stack fill>
          <Stack.Item grow={1} basis={0} order={0}>
            <Stack vertical fill>
              <Stack.Item>
                <Section title="FIRST PARTY">
                  {isExpert ? (
                    <PartySelector 
                      act={act} 
                      party={party1} 
                      partyId={1} 
                      factions={factions} 
                      options={lists.factions} 
                      align="left" 
                      isExpert={isExpert} 
                    />
                  ) : (
                    <PartyDisplay party={party1} align="left" isExpert={isExpert} />
                  )}
                </Section>
              </Stack.Item>

              <Stack.Item grow={1}>
                <Section title="AVAILABLE TERMS" fill scrollable>
                  {isExpert ? (
                    availableTerms.map(term => {
                      const handleSelectTerm = () => actions.select(term);
                      return (
                        <Button 
                          key={term.name} 
                          fluid 
                          textAlign="left" 
                          mb={0.5} 
                          onClick={handleSelectTerm} 
                          disabled={!!draft.term} 
                          style={{ backgroundColor: '#1a1510', color: '#b1a390' }}
                        >
                          {term.name}
                        </Button>
                      );
                    })
                  ) : (
                    <Box color="label" p={1} textAlign="center">
                      You lack the wisdom to draft new terms.
                    </Box>
                  )}
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item grow={1} basis={0} order={1}>
            <Stack vertical fill>
              <Stack.Item grow={1}>
                <Section title="ACTIVE TERMS" textAlign="center" fill scrollable>
                  <Box mb={1} textAlign="center" color="label" fontSize="0.8em">
                    Limit: {activeTerms.length}/10
                  </Box>
                  <Stack vertical>
                    {activeTerms.length === 0 && (
                      <Box color="label" textAlign="Center">[NO ACTIVE TERMS]</Box>
                    )}
                    {activeTerms.map((term, index) => {
                      const handleDraftTerm = () => actions.select(term, true);
                      const handleSignTerm = () => actions.sign(term);
                      return (
                        <Box key={term.index || index}>
                          <Box textAlign="center" color="label" fontSize="0.9em" my={0.5}>
                            {index + 1}
                          </Box>
                          <ActiveTerm 
                            term={term} 
                            onDraft={handleDraftTerm} 
                            onSign={handleSignTerm} 
                            disabled={!!draft.term} 
                            isExpert={isExpert} 
                            factions={factions} 
                            territories={territories} 
                          />
                        </Box>
                      );
                    })}
                  </Stack>
                </Section>
              </Stack.Item>

              <Stack.Item>
                <Section title="DRAFT" textAlign="center" style={{ overflow: 'visible' }}>
                  {!isExpert && (
                    <Box color="label" textAlign="center" p={1}>{MASK}</Box>
                  )}
                  {isExpert && !draft.term && (
                    <Box color="label">Click an available or active term to draft it.</Box>
                  )}
                  {isExpert && draft.term && (
                    <DraftTerm 
                      term={draft.term} 
                      state={draft} 
                      updateState={updateDraft} 
                      actions={actions} 
                      isValid={isDraftValid} 
                      isEditing={draft.index !== null} 
                      lists={lists} 
                      factions={factions} 
                      territories={territories} 
                    />
                  )}
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item grow={1} basis={0} order={2}>
            <Section title="SECOND PARTY" textAlign="right">
              {isExpert ? (
                <PartySelector 
                  act={act} 
                  party={party2} 
                  partyId={2} 
                  factions={factions} 
                  options={lists.factions} 
                  align="right" 
                  isExpert={isExpert} 
                />
              ) : (
                <PartyDisplay party={party2} align="right" isExpert={isExpert} />
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
