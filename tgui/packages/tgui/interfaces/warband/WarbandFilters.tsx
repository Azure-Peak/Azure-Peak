  // the backend should be providing every possible warband, aspect and class
  // then it gets put through this Filter

  // for a storyteller-locked warband to pass the filter and appear as a possible choice, its required storyteller needs to be present in the manager's "storyinfluences" variable
  // it will need to be present an amount of times equal to the warband's "rarity"
  
  // available subtypes and aspects are determined by:
  // the rarity filter, if applicable
  // the currently selected warband

  // available classes are determined by all of the above + the user's role

  // btw 'subclasses' aren't actually real. anything filtered into the subclass section is explicitly snowflake code for the mercenary warbands

import { useMemo } from 'react';

import { AspectType, ClassType, StorytellerType, SubType, WarbandType } from './WarbandTypes';

const rarityFilter = (band: any, storytellersList: StorytellerType[]): boolean => {
  if (band.storyinfluence) {
    const matchCount = storytellersList.filter(storyteller => storyteller.type === band.storyinfluence).length;
    return matchCount >= band.rarity;
  }
  return true;
};

export const useWarbandFilters = (
  user_role: string | undefined,
  selectedWarband: WarbandType | null,
  selectedSubtype: SubType | null,
  warbandList: WarbandType[],
  subtypeList: SubType[],
  aspectList: AspectType[],
  classList: ClassType[],
  storytellersList: StorytellerType[]
) => {

  const filteredWarbands = useMemo(() => {
    return warbandList.filter(warband => rarityFilter(warband, storytellersList));
  }, [warbandList, storytellersList]);

  const filteredSubtypes = useMemo(() => {
    if (!selectedWarband) {
      return [];
    }
    return subtypeList.filter(subtype => {
      const isWarbandCompatible = selectedWarband.subtypes?.[0]?.includes(subtype.type);
      return isWarbandCompatible && rarityFilter(subtype, storytellersList);
    });
  }, [selectedWarband, subtypeList, storytellersList]);

  const filteredAspects = useMemo(() => {
    if (!selectedWarband) {
      return [];
    }
    const allowedAspectTypes = new Set(selectedWarband.aspects);
    if (selectedSubtype) {
      if (Array.isArray(selectedSubtype.aspects)) {
        selectedSubtype.aspects.forEach(aspectType => allowedAspectTypes.add(aspectType));
      }
    }
    return aspectList.filter(aspect => {
      const isTypeAllowed = allowedAspectTypes.has(aspect.type);
      return isTypeAllowed && rarityFilter(aspect, storytellersList);
    });
  }, [selectedWarband, selectedSubtype, aspectList, storytellersList]);

  const filteredClasses = useMemo(() => {
    if (!selectedWarband) {
      return { warlord: [], lieutenant: [], grunt: [] };
    }

    const filteredRarity = classList.filter(classe => rarityFilter(classe, storytellersList));

    const warbandWarlordClasses = selectedWarband.warlordclasses || [];
    const warbandLieuClasses = selectedWarband.lieuclasses || [];
    const warbandGruntClasses = selectedWarband.gruntclasses || [];

    const subtypeWarlordClasses = selectedSubtype?.warlordclasses || [];
    const subtypeLieuClasses = selectedSubtype?.lieuclasses || [];
    const subtypeGruntClasses = selectedSubtype?.gruntclasses || [];

    const isMercenaryCompany = selectedWarband.title === 'MERCENARY COMPANY';
    
    const combinedWarlordClasses = isMercenaryCompany 
      ? new Set([...warbandWarlordClasses]) 
      : new Set([...warbandWarlordClasses, ...subtypeWarlordClasses]);
    
    const combinedLieuClasses = isMercenaryCompany 
      ? new Set([...warbandLieuClasses]) 
      : new Set([...warbandLieuClasses, ...subtypeLieuClasses]);
    
    const combinedGruntClasses = isMercenaryCompany 
      ? new Set([...warbandGruntClasses]) 
      : new Set([...warbandGruntClasses, ...subtypeGruntClasses]);

    const warlordClasses = filteredRarity.filter(classe => combinedWarlordClasses.has(classe.type));
    const lieuClasses = filteredRarity.filter(classe => combinedLieuClasses.has(classe.type));
    const gruntClasses = filteredRarity.filter(classe => combinedGruntClasses.has(classe.type));

    return { warlord: warlordClasses, lieutenant: lieuClasses, grunt: gruntClasses };
  }, [selectedWarband, selectedSubtype, classList, storytellersList]);


  const availableClasses = useMemo(() => {
    if (!user_role) return [];
    if (user_role === 'Warlord') return filteredClasses.warlord;
    if (user_role === 'Lieutenant' || user_role === 'Aspirant Lieutenant') return filteredClasses.lieutenant;
    if (user_role === 'Grunt') {
      if (selectedWarband?.title === 'MERCENARY COMPANY') {
        return filteredClasses.grunt.filter(classe => classe.alt_name === 'Mercenary');
      } else {
        return filteredClasses.grunt; 
      }
    }
    return [];
  }, [user_role, filteredClasses, selectedWarband]);

  const filteredSubclasses = useMemo(() => {
    if (selectedWarband?.title !== 'MERCENARY COMPANY' || !selectedSubtype) {
      return [];
    }
    
    // filter out the base classes
    const baseWarlordClass = '/datum/advclass/warband/mercenary/warlord/captain';
    const baseLieuClasses = [
      '/datum/advclass/warband/mercenary/lieutenant/vanguard',
      '/datum/advclass/warband/mercenary/lieutenant/tactician',
      '/datum/advclass/warband/mercenary/lieutenant/skirmisher',
    ];
    const baseGruntClass = '/datum/advclass/warband/mercenary/grunt/merc';
    

    const filteredRarity = classList.filter(classe => rarityFilter(classe, storytellersList));
    
    if (user_role === 'Warlord') {
      const warlordSubclasses = filteredRarity.filter(classe => 
        selectedSubtype.warlordclasses?.includes(classe.type) && 
        classe.type !== baseWarlordClass
      );
      
      if (warlordSubclasses.length === 0) {
        return filteredRarity.filter(classe => 
          selectedSubtype.gruntclasses?.includes(classe.type) &&
          classe.type !== baseGruntClass
        );
      }
      return warlordSubclasses;
    }
    
    if (user_role === 'Lieutenant' || user_role === 'Aspirant Lieutenant') {
      const lieutenantSubclasses = filteredRarity.filter(classe => 
        selectedSubtype.lieuclasses?.includes(classe.type) &&
        !baseLieuClasses.includes(classe.type)
      );
      
      if (lieutenantSubclasses.length === 0) {
        return filteredRarity.filter(classe => 
          selectedSubtype.gruntclasses?.includes(classe.type) &&
          classe.type !== baseGruntClass
        );
      }
      return lieutenantSubclasses;
    }
    
    if (user_role === 'Grunt') {
      return filteredRarity.filter(classe => 
        selectedSubtype.gruntclasses?.includes(classe.type) &&
        classe.type !== baseGruntClass
      );
    }
    
    return [];
  }, [selectedWarband, selectedSubtype, user_role, classList, storytellersList]);

  return {
    filteredWarbands,
    filteredSubtypes,
    filteredAspects,
    availableClasses,
    filteredGruntClasses: filteredClasses.grunt,
    filteredSubclasses,
  };
};
