import { useBackend } from '../../backend';
import { Data } from './WarbandTypes';

export const useWarbandData = () => {
  const { data, act } = useBackend<Data>();
  const user_role = data?.user_role;
  const finalized_status = data?.finalized_status;
  const backend_warband = data?.backend_warband || [];
  const backend_subtype = data?.backend_subtype || [];
  const backend_aspects = data?.backend_aspects || [];

  const creation_stage = data?.creation_stage || 1;
  const warlord_spawned = data?.warlord_spawned || false;
  const is_warlord = data?.is_warlord || false;
  
  const time_remaining = data?.time_remaining || 0;
  const timer_active = data?.timer_active || false;

  const warbandList = finalized_status ? backend_warband : (data?.warbands || []);
  const subtypeList = finalized_status ? backend_subtype : (data?.subtypes || []);
  const aspectList = finalized_status ? backend_aspects : (data?.aspects || []);
  const classList = data?.classes || [];
  const storytellersList = data?.backendstorytellers || [];

  const nobleList = data?.nobles || [];
  const alliesList = data?.allies || [];

  // casus belli
  const allTerms = data?.all_terms || [];
  const casusBelliProposals = data?.casus_belli_proposals || [];
  const userProposal = data?.user_proposal ?? null;
  const userVote = data?.user_vote ?? null;
  const userVoteConfirmed = data?.user_vote_confirmed || false;
  const warlordSelectedProposal = data?.warlord_selected_proposal ?? null;
  const warlordCasusBelli = data?.warlord_casus_belli ?? null;
  const factions = data?.backend_factions || [];
  const territories = data?.backend_territories || [];

  return {
    user_role,
    act,
    warbandList,
    subtypeList,
    aspectList,
    classList,
    storytellersList,
    alliesList,
    nobleList,
    backend_warband,
    creation_stage,
    warlord_spawned,
    is_warlord,
    time_remaining,
    timer_active,
    allTerms,
    casusBelliProposals,
    userProposal,
    userVote,
    userVoteConfirmed,
    warlordSelectedProposal,
    warlordCasusBelli,
    factions,
    territories,
  };
};
