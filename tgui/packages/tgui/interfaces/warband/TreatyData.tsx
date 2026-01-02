import { useBackend } from '../../backend';
import { Data } from './TreatyTypes';

export const MASK = "???"; // if someone doesn't have the Law Expert trait, we obscure text with the mask

export const sanitize = (val: string, type: 'name' | 'text') => 
  val.replace(type === 'name' ? /[^\p{L} ',-]/gu : /[^\p{L}0-9 '.,?!-]/gu, '');


export const useTreatyData = () => {
  const { data, act } = useBackend<Data>();

  const party1 = data?.firstparty;
  const party2 = data?.secondparty;
  const activeTerms = data?.terms || [];
  const availableTerms = data?.all_terms || [];
  const factions = data?.backend_factions || [];

  const territories = data?.backend_territories ||[];

  return {
    act,
    data,
    party1,
    party2,
    activeTerms,
    availableTerms,
    factions,
    territories,
  };
};

