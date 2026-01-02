import { useEffect, useState } from 'react';

import { useBackend } from '../../backend';
import { AspectType, ClassType, Data, SubType, WarbandType } from './WarbandTypes';


// selections & the point reductions that follow
// also clears selected aspects & classes after a new selection, unless they're compatible with the new selection

export const useWarbandSelection = () => {
  const { data } = useBackend<Data>();
  const finalized_status = data?.finalized_status;
  const backend_warband = data?.backend_warband?.[0] || null;
  const backend_subtype = data?.backend_subtype?.[0] || null;
  const backend_aspects = data?.backend_aspects || [];

  const [selectedWarband, setSelectedWarband] = useState<WarbandType | null>(null);
  const [selectedSubtype, setSelectedSubtype] = useState<SubType | null>(null);
  const [selectedAspects, setSelectedAspects] = useState<AspectType[]>([]);
  const [selectedClass, setSelectedClass] = useState<ClassType | null>(null);
  const [selectedSubclass, setSelectedSubclass] = useState<ClassType | null>(null);
  const [pointCounter, setPointCounter] = useState(0);

  const [lockedWarband, setLockedWarband] = useState<WarbandType | null>(null);
  const [lockedSubtype, setLockedSubtype] = useState<SubType | null>(null);
  const [lockedAspects, setLockedAspects] = useState<AspectType[]>([]);
 
  useEffect(() => {
    const creation_stage = data?.creation_stage || 1;
    const shouldLoadBackend = finalized_status || creation_stage >= 2;
    
    if (shouldLoadBackend) {
      if (backend_warband) {
        setSelectedWarband(backend_warband);
        if (finalized_status) {
          setLockedWarband(backend_warband);
        }
      }
      if (backend_subtype) {
        setSelectedSubtype(backend_subtype);
        if (finalized_status) {
          setLockedSubtype(backend_subtype);
        }
      }
      if (backend_aspects.length > 0) {
        setSelectedAspects(backend_aspects);
        if (finalized_status) {
          setLockedAspects(backend_aspects);
        }
      }
    }
  }, [finalized_status, backend_warband, backend_subtype, backend_aspects, data?.creation_stage]);

  // aspect points
  useEffect(() => {
    let totalPoints = 0;
    if (selectedWarband) { totalPoints += selectedWarband.points; }
    if (selectedSubtype) { totalPoints += selectedSubtype.points; }
    if (selectedAspects.length > 0) { totalPoints += selectedAspects.reduce((sum, aspect) => sum + aspect.points, 0); }
    setPointCounter(totalPoints);
  }, [selectedWarband, selectedSubtype, selectedAspects, selectedSubclass]);


  // selection
  const handleWarbandSelect = (warband: WarbandType) => {
    if (lockedWarband) { return; }
    if (selectedWarband?.title === warband.title) { return; }
    const isSubtypeCompatible = selectedSubtype && warband.subtypes?.[0]?.includes(selectedSubtype.type);
    const compatibleAspects = selectedAspects.filter(aspect => warband.aspects.includes(aspect.type));
    setSelectedWarband(warband);
    setSelectedSubtype(isSubtypeCompatible ? selectedSubtype : null);
    setSelectedAspects(compatibleAspects);
    setSelectedClass(null);
    setSelectedSubclass(null);
  };

  const handleSubtypeSelect = (subtype: SubType) => {
    if (lockedSubtype) { return; }
    setSelectedSubtype(subtype);
    const compatibleAspects = selectedAspects.filter(aspect => subtype.aspects.includes(aspect.type));
    setSelectedAspects(compatibleAspects);
    setSelectedClass(null);
    setSelectedSubclass(null);
  };

  const handleAspectSelect = (aspect: AspectType) => {
    const isLocked = lockedAspects.some(a => a.title === aspect.title);
    setSelectedAspects(prevAspects => {
      const isSelected = prevAspects.some(a => a.title === aspect.title);
      if (isLocked && isSelected) {
        return prevAspects;
      }
      if (isSelected) {
        return prevAspects.filter(a => a.title !== aspect.title);
      } else {
        const hasConflict = prevAspects.some(a => // we don't want two aspects of the same class being selected (I.E: two map aspects)
          a.class !== null &&
          aspect.class !== null &&
          a.class === aspect.class
        );

        if (hasConflict) {
          return prevAspects;
        }
        return [...prevAspects, aspect];
      }
    });
    setSelectedClass(null);
    setSelectedSubclass(null);
  };

  const handleClassSelect = (classe: ClassType) => {
    setSelectedClass(prevClass => {
      if (prevClass?.name === classe.name) {
        return null;
      }
      return classe;
    });
    setSelectedSubclass(null);
  };

  const handleSubclassSelect = (subclass: ClassType) => {
    setSelectedSubclass(prevSubclass => {
      if (prevSubclass?.alt_name === subclass.alt_name) {
        return null;
      }
      return subclass;
    });
  };

  return {
    selectedWarband,
    selectedSubtype,
    selectedAspects,
    selectedClass,
    selectedSubclass,
    pointCounter,
    lockedWarband,
    lockedSubtype,
    lockedAspects,
    handleWarbandSelect,
    handleSubtypeSelect,
    handleAspectSelect,
    handleClassSelect,
    handleSubclassSelect,
  };
};
