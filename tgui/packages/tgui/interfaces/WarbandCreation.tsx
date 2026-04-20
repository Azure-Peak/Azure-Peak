import { useState } from 'react';
import { Button, Stack } from 'tgui-core/components';

import { Window } from '../layouts';
import { useWarbandData } from './warband/WarbandData';
import { useWarbandFilters } from './warband/WarbandFilters';
import { useWarbandSelection } from './warband/WarbandSelection';
import { ClassesTab } from './warband/WarbandTabClasses';
import { CreationTab } from './warband/WarbandTabCreation';
import { FinalizeTab } from './warband/WarbandTabFinalize';
import { WorldTab } from './warband/WarbandTabWorld';

const sectionHeaderStyle = `
  .Section__title {
    border-bottom: 2px solid;
    border-image: linear-gradient(to left, #000000 0%, #682222ff 100%) 1 !important;
  }
`;

export const WarbandCreation = () => {
  const { 
    user_role, act,
    warbandList, subtypeList, aspectList, classList, storytellersList,
    nobleList, alliesList,
    creation_stage, warlord_spawned, is_warlord,
    time_remaining, timer_active,
    allTerms, casusBelliProposals,
    userProposal, userVote, userVoteConfirmed,
    warlordSelectedProposal, warlordCasusBelli,
    factions, territories,
    backend_warband,
  } = useWarbandData();

  const {
    selectedWarband, selectedSubtype, selectedAspects,
    selectedClass, selectedSubclass, pointCounter,
    handleWarbandSelect, handleSubtypeSelect, handleAspectSelect,
    handleClassSelect, handleSubclassSelect,
  } = useWarbandSelection();
  
  const { filteredWarbands, filteredSubtypes, filteredAspects, availableClasses, filteredSubclasses } = useWarbandFilters(
    user_role, selectedWarband, selectedSubtype,
    warbandList, subtypeList, aspectList, classList, storytellersList
  );

  const [activeTab, setActiveTab] = useState('creation');
  const lockedWarbandType = (creation_stage >= 2 ? backend_warband?.[0]?.type : null) ?? null;

  const stage1_complete = !!(
    selectedWarband &&
    pointCounter >= 0 &&
    (!selectedWarband?.subtyperequired || selectedSubtype)
  );

  const finalize_disabled =
    pointCounter < 0 || !selectedWarband || !selectedClass ||
    (selectedWarband?.subtyperequired && !selectedSubtype) ||
    (selectedWarband?.title === "MERCENARY COMPANY" && !selectedSubclass);

  const pointsColor = pointCounter > 0 ? '#2ee62eff' : (pointCounter < 0 ? '#FF0000' : '#4b504bff');
  const canFinalize = is_warlord || warlord_spawned;

  const canInteractCreation = creation_stage === 1;
  const canInteractCasusBelli = creation_stage === 2;
  const canInteractClasses = creation_stage >= 3 || warlord_spawned;
  const canInteractFinalize = creation_stage >= 3 || warlord_spawned;

  const isTabStageFocus = (tab: string) => {
    if (warlord_spawned) return true;
    if (tab === 'creation') return creation_stage === 1;
    if (tab === 'world') return creation_stage === 2;
    if (tab === 'classes' || tab === 'goforth') return creation_stage >= 3;
    return false;
  };

  const getStageMessage = () => {
    if (warlord_spawned) return "JOIN AT WILL";
    if (!is_warlord && creation_stage === 1) return "STAGE 1: THE WARLORD MUST SELECT A WARBAND";
    if (!is_warlord && creation_stage === 2) return "STAGE 2: PROPOSE A CASUS BELLI";
    if (!is_warlord && creation_stage === 3 && !warlord_spawned) return "STAGE 3: CHOOSE A CLASS | WAIT FOR THE WARLORD TO FINALIZE THE WARBAND";
    if (is_warlord && creation_stage === 1) return "STAGE 1: SELECT A WARBAND";
    if (is_warlord && creation_stage === 2) return "STAGE 2: SELECT A CASUS BELLI TO ADVANCE";
    if (is_warlord && creation_stage === 3 && !warlord_spawned) return "STAGE 3: CHOOSE A CLASS | FINALIZE";
    return "";
  };

  const formatTime = (deciseconds: number) => {
    const totalSeconds = Math.floor(deciseconds / 10);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
  };

  const getTimerColor = () => {
    if (!timer_active) return '#4b504bff';
    const minutes = Math.floor(time_remaining / 600);
    if (minutes <= 5) return '#FF0000';
    if (minutes <= 10) return '#FFA500';
    return '#2ee62eff';
  };

  const makeTabBtn = (tabKey: string, label: string) => (
    <div style={{ position: 'relative' }}>
      {activeTab === tabKey && (
        <div style={{
          position: 'absolute', top: '2px', left: '50%', transform: 'translateX(-50%)',
          width: 0, height: 0,
          borderLeft: '6px solid transparent', borderRight: '6px solid transparent',
          borderTop: '6px solid white', zIndex: 10,
        }} />
      )}
      <Button
        onClick={() => activeTab !== tabKey && setActiveTab(tabKey)}
        style={{
          opacity: isTabStageFocus(tabKey) ? 0.95 : 0.45,
          backgroundColor: activeTab === tabKey ? '#682222ff' : undefined,
          cursor: activeTab === tabKey ? 'default' : 'pointer',
          height: '60px', width: '140px',
          display: 'flex', alignItems: 'flex-start', justifyContent: 'center',
          paddingTop: '8px', margin: 0,
        }}
      >
        {label}
      </Button>
    </div>
  );

  return (
    <Window theme="azure_default" width={1380} height={710}>
      <Window.Content style={{ background: 'linear-gradient(to left, #000000 0%, #1d0505ff 100%)' }}>
        <style>{sectionHeaderStyle}</style>
        <Stack style={{ gap: 0, marginBottom: '8px' }}>
          {makeTabBtn('creation', 'SELECT WARBAND')}
          {makeTabBtn('world', 'CASUS BELLI')}
          {makeTabBtn('classes', 'CLASS')}
          {makeTabBtn('goforth', 'FINALIZE')}
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-start', gap: '4px', marginLeft: '12px' }}>
            <span style={{ height: '20px', paddingBottom: '2px' }}>
              AVAILABLE ASPECT POINTS: <span style={{ color: pointsColor }}>{pointCounter}</span>
            </span>
            <span style={{ height: '20px', paddingTop: '2px', paddingBottom: '8px', visibility: timer_active ? 'visible' : 'hidden' }}>
              TIME REMAINING: <span style={{ color: getTimerColor() }}>{formatTime(time_remaining)}</span>
            </span>
          </div>
        </Stack>

        <div style={{ background: 'linear-gradient(to left, #000000 0%, #3c0d0d 100%)', borderBottom: '2px solid #160303', marginBottom: '4px' }}>
          <div style={{ padding: '15px', color: 'white', textAlign: 'center', fontWeight: 'bold' }}>
            {getStageMessage()}
          </div>
        </div>

        {activeTab === 'creation' && (
          <CreationTab
            filteredWarbands={filteredWarbands} filteredSubtypes={filteredSubtypes}
            filteredAspects={filteredAspects} selectedWarband={selectedWarband}
            selectedSubtype={selectedSubtype} selectedAspects={selectedAspects}
            handleWarbandSelect={handleWarbandSelect} handleSubtypeSelect={handleSubtypeSelect}
            handleAspectSelect={handleAspectSelect} act={act}
            locked={!canInteractCreation} stage1Complete={stage1_complete}
            isStage1={creation_stage === 1} isWarlord={is_warlord} pointCounter={pointCounter}
          />
        )}
        {activeTab === 'classes' && (
          <ClassesTab
            selectedWarband={selectedWarband} selectedClass={selectedClass}
            selectedSubclass={selectedSubclass} availableClasses={availableClasses}
            filteredSubclasses={filteredSubclasses} handleClassSelect={handleClassSelect}
            handleSubclassSelect={handleSubclassSelect} act={act} canModify={canInteractClasses}
          />
        )}
        {activeTab === 'world' && (
          <WorldTab
            nobleList={nobleList} alliesList={alliesList} act={act}
            proposals={casusBelliProposals} availableTerms={allTerms}
            userProposal={userProposal} userVote={userVote} userVoteConfirmed={userVoteConfirmed}
            warlordSelectedProposal={warlordSelectedProposal}
            warlordCasusBelli={warlordCasusBelli}
            isWarlord={is_warlord} locked={!canInteractCasusBelli}
            factions={factions ?? []} territories={territories ?? []}
            lockedWarbandType={lockedWarbandType}
          />
        )}
        {activeTab === 'goforth' && (
          <FinalizeTab
            selectedWarband={selectedWarband} selectedSubtype={selectedSubtype}
            selectedAspects={selectedAspects} selectedClass={selectedClass}
            selectedSubclass={selectedSubclass} finalize_disabled={finalize_disabled}
            pointCounter={pointCounter} act={act} canFinalize={canFinalize}
            canInteract={canInteractFinalize} isWarlord={is_warlord}
          />
        )}
      </Window.Content>
    </Window>
  );
};
