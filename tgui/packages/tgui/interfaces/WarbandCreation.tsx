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
    user_role, 
    act, 
    warbandList, 
    subtypeList, 
    aspectList, 
    classList, 
    storytellersList, 
    nobleList, 
    alliesList,
    creation_stage,
    warlord_spawned,
    is_warlord,
    time_remaining,
    timer_active,
  } = useWarbandData();
  
  const {
    selectedWarband,
    selectedSubtype,
    selectedAspects,
    selectedClass,
    selectedSubclass,
    pointCounter,
    handleWarbandSelect,
    handleSubtypeSelect,
    handleAspectSelect,
    handleClassSelect,
    handleSubclassSelect,
  } = useWarbandSelection();
  
  const { filteredWarbands, filteredSubtypes, filteredAspects, availableClasses, filteredGruntClasses } = useWarbandFilters(
    user_role,
    selectedWarband,
    selectedSubtype,
    warbandList,
    subtypeList,
    aspectList,
    classList,
    storytellersList
  );

  const [activeTab, setActiveTab] = useState('creation');

  const stage1_complete = !!(
    selectedWarband &&
    pointCounter >= 0 &&
    (!selectedWarband?.subtyperequired || selectedSubtype)
  );

  const finalize_disabled =
    pointCounter < 0 ||
    !selectedWarband ||
    !selectedClass ||
    (selectedWarband?.subtyperequired && !selectedSubtype) ||
    (selectedWarband?.title === "MERCENARY COMPANY" && !selectedSubclass);

  const pointsColor = pointCounter > 0 ? '#2ee62eff' : (pointCounter < 0 ? '#FF0000' : '#4b504bff');

  const canFinalize = is_warlord || warlord_spawned;
  
  const isTabStageFocus = (tab: string) => {
    if (warlord_spawned) return true;
    if (tab === 'world') return creation_stage === 1;
    if (tab === 'creation') return creation_stage === 1;
    if (tab === 'classes' || tab === 'goforth') return creation_stage >= 2;
    return false;
  };
  
  const canInteractCreation = creation_stage === 1 || warlord_spawned;
  const canInteractClasses = creation_stage >= 2 || warlord_spawned;
  const canInteractFinalize = creation_stage >= 2 || warlord_spawned;

  const getStageMessage = () => {
    if (!is_warlord && creation_stage === 1) {
      return "STAGE 1: THE WARLORD MUST SELECT A WARBAND";
    }
    if (!is_warlord && creation_stage === 2 && !warlord_spawned) {
      return "STAGE 2: CHOOSE A CLASS | WAIT FOR THE WARLORD TO FINALIZE THE WARBAND";
    }
    if (is_warlord && creation_stage === 1) {
      return "STAGE 1: SELECT A WARBAND";
    }
    if (is_warlord && creation_stage === 2 && !warlord_spawned) {
      return "STAGE 2: CHOOSE A CLASS | FINALIZE";
    }
    if (warlord_spawned) {
      return "JOIN AT WILL";
    }
    return "";
  };

  // Format time remaining as MM:SS
  const formatTime = (deciseconds: number) => {
    const totalSeconds = Math.floor(deciseconds / 10);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
  };

  // Determine timer color based on remaining time
  const getTimerColor = () => {
    if (!timer_active) return '#4b504bff';
    const minutes = Math.floor(time_remaining / 600);
    if (minutes <= 5) return '#FF0000';
    if (minutes <= 10) return '#FFA500';
    return '#2ee62eff';
  };

  return (
    <Window theme="azure_default" width={1000} height={700}>
      <Window.Content style={{
        background: 'linear-gradient(to left, #000000 0%, #1d0505ff 100%)',
      }}>
        <style>{sectionHeaderStyle}</style>
        <Stack>
          <div style={{ position: 'relative', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
            {activeTab === 'creation' && (
              <div style={{
                width: 0,
                height: 0,
                borderLeft: '6px solid transparent',
                borderRight: '6px solid transparent',
                borderTop: '6px solid #682222ff',
                marginBottom: '2px',
              }} />
            )}
            <Button 
              onClick={() => activeTab !== 'creation' && setActiveTab('creation')} 
              style={{ 
                opacity: isTabStageFocus('creation') ? 0.95 : 0.45,
                backgroundColor: activeTab === 'creation' ? '#682222ff' : undefined,
                cursor: activeTab === 'creation' ? 'default' : 'pointer',
              }}
            >
              {'SELECT WARBAND'}
            </Button>
          </div>
          <div style={{ position: 'relative', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
            {activeTab === 'world' && (
              <div style={{
                width: 0,
                height: 0,
                borderLeft: '6px solid transparent',
                borderRight: '6px solid transparent',
                borderTop: '6px solid #682222ff',
                marginBottom: '2px',
              }} />
            )}
            <Button 
              onClick={() => activeTab !== 'world' && setActiveTab('world')}
              style={{ 
                opacity: isTabStageFocus('world') ? 0.95 : 0.45,
                backgroundColor: activeTab === 'world' ? '#682222ff' : undefined,
                cursor: activeTab === 'world' ? 'default' : 'pointer',
              }}
            >
              BEHOLD AZURIA
            </Button>
          </div>
          <div style={{ position: 'relative', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
            {activeTab === 'classes' && (
              <div style={{
                width: 0,
                height: 0,
                borderLeft: '6px solid transparent',
                borderRight: '6px solid transparent',
                borderTop: '6px solid #682222ff',
                marginBottom: '2px',
              }} />
            )}
            <Button 
              onClick={() => activeTab !== 'classes' && setActiveTab('classes')}
              style={{ 
                opacity: isTabStageFocus('classes') ? 0.95 : 0.45,
                backgroundColor: activeTab === 'classes' ? '#682222ff' : undefined,
                cursor: activeTab === 'classes' ? 'default' : 'pointer',
              }}
            >
              {'CLASS'}
            </Button>
          </div>
          <div style={{ position: 'relative', display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
            {activeTab === 'goforth' && (
              <div style={{
                width: 0,
                height: 0,
                borderLeft: '6px solid transparent',
                borderRight: '6px solid transparent',
                borderTop: '6px solid #682222ff',
                marginBottom: '2px',
              }} />
            )}
            <Button 
              onClick={() => activeTab !== 'goforth' && setActiveTab('goforth')}
              style={{ 
                opacity: isTabStageFocus('goforth') ? 0.95 : 0.45,
                backgroundColor: activeTab === 'goforth' ? '#682222ff' : undefined,
                cursor: activeTab === 'goforth' ? 'default' : 'pointer',
              }}
            >
              FINALIZE
            </Button>
          </div>
          <div style={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'flex-start',
            gap: '4px',
          }}>
            <span style={{
              height: '20px',
              alignItems: 'flex-start',
              paddingBottom: '2px',
            }}>
              AVAILABLE ASPECT POINTS: <span style={{ color: pointsColor }}>{pointCounter}</span>
            </span>
            <span style={{
              height: '20px',
              alignItems: 'flex-start',
              paddingTop: '2px',
              visibility: timer_active ? 'visible' : 'hidden',
            }}>
              TIME REMAINING: <span style={{ color: getTimerColor() }}>{formatTime(time_remaining)}</span>
            </span>
          </div>
        </Stack>

        <div style={{ 
          background: 'linear-gradient(to left, #000000 0%, #3c0d0d 100%)',
          borderBottom: '2px solid #160303',
        }}>
          <div style={{ 
            padding: '15px', 
            color: 'white',
            textAlign: 'center',
            fontWeight: 'bold',
          }}>
            {getStageMessage()}
          </div>
        </div>

        {activeTab === 'creation' && (
          <CreationTab
            filteredWarbands={filteredWarbands}
            filteredSubtypes={filteredSubtypes}
            filteredAspects={filteredAspects}
            selectedWarband={selectedWarband}
            selectedSubtype={selectedSubtype}
            selectedAspects={selectedAspects}
            handleWarbandSelect={handleWarbandSelect}
            handleSubtypeSelect={handleSubtypeSelect}
            handleAspectSelect={handleAspectSelect}
            act={act}
            locked={!canInteractCreation}
            stage1Complete={stage1_complete}
            isStage1={creation_stage === 1}
            isWarlord={is_warlord}
          />
        )}
        {activeTab === 'classes' && (
          <ClassesTab
            selectedWarband={selectedWarband}
            selectedClass={selectedClass}
            selectedSubclass={selectedSubclass}
            availableClasses={availableClasses}
            filteredGruntClasses={filteredGruntClasses}
            handleClassSelect={handleClassSelect}
            handleSubclassSelect={handleSubclassSelect}
            act={act}
            canModify={canInteractClasses}
          />
        )}
        {activeTab === 'world' && (
          <WorldTab
            nobleList={nobleList}
            alliesList={alliesList}
            act={act}
          />
        )}
        {activeTab === 'goforth' && (
          <FinalizeTab
            selectedWarband={selectedWarband}
            selectedSubtype={selectedSubtype}
            selectedAspects={selectedAspects}
            selectedClass={selectedClass}
            selectedSubclass={selectedSubclass}
            finalize_disabled={finalize_disabled}
            pointCounter={pointCounter}
            act={act}
            canFinalize={canFinalize}
            canInteract={canInteractFinalize}
            isWarlord={is_warlord}
          />
        )}
      </Window.Content>
    </Window>
  );
};
