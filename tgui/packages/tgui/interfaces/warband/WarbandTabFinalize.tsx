import { Button, Section, Stack } from 'tgui-core/components';

import { AspectType, ClassType, SubType, WarbandType } from './WarbandTypes';

type FinalizeTabProps = {
  selectedWarband: WarbandType | null;
  selectedSubtype: SubType | null;
  selectedAspects: AspectType[];
  selectedClass: ClassType | null;
  selectedSubclass: ClassType | null;
  finalize_disabled: boolean;
  pointCounter: number;
  act: (action: string, payload?: object) => void;
  canFinalize?: boolean;
  canInteract?: boolean;
  isWarlord?: boolean;
};

export const FinalizeTab = ({
  selectedWarband,
  selectedSubtype,
  selectedAspects,
  selectedClass,
  selectedSubclass,
  finalize_disabled,
  pointCounter,
  act,
  canFinalize = true,
  canInteract = true,
  isWarlord = false,
}: FinalizeTabProps) => {
  
  const disableReason = () => {
    if (!canInteract) {
      return isWarlord 
        ? "RETURN TO CLASSES TAB" 
        : "RETURN TO CLASSES TAB";
    }
    
    if (!canFinalize && !isWarlord) {
      return "AWAITING WARLORD TO FINALIZE WARBAND";
    }
    
    if (!finalize_disabled) return null;

    if (pointCounter < 0) {
      return "MUST HAVE 0 OR MORE ASPECT POINTS REMAINING";
    }
    if (!selectedWarband) {
      return "NO WARBAND SELECTED";
    }
    if (selectedWarband?.subtyperequired && !selectedSubtype) {
      return "WARBAND REQUIRES A SELECTED SUBTYPE";
    }
    if (!selectedClass) {
      return "NO CLASS SELECTED";
    }
    if (selectedWarband?.title === "MERCENARY COMPANY" && !selectedSubclass) {
      return "MERCENARY REQUIRES A SUBCLASS";
    }
    return null;
  };

  const getButtonText = () => {
    if (isWarlord) {
      return "FINALIZE WARBAND & SPAWN";
    }
    return "JOIN GAME";
  };

  const actuallyDisabled = !canInteract || finalize_disabled || !canFinalize;

  return (
    <Stack style={{ flex: 1, flexDirection: 'column', height: '100%' }}> 
      <Section title={<span style={{ color: '#7a2525ff' }}>FINAL SUMMARY</span>} scrollable fill style={{ flex: 1, height: '100%' }}>
        {selectedWarband && (
          <div style={{ marginBottom: '10px' }}>
            <h3 style={{ color: '#ae3636', margin: 0 }}>WARBAND</h3>
            <div style={{ paddingLeft: '20px', marginTop: '5px' }}>
              <strong style={{ color: '#ae3636', display: 'block' }}>{selectedWarband.title}</strong>
              <p style={{ margin: 0 }}>{selectedWarband.summary}</p>
            </div>
          </div>
        )}
        {selectedSubtype && (
          <div style={{ marginBottom: '10px' }}>
            <h3 style={{ color: '#ae3636', margin: 0 }}>SUBTYPE</h3>
            <div style={{ paddingLeft: '20px', marginTop: '5px' }}>
              <strong style={{ color: '#ae3636' }}>{selectedSubtype.title}</strong>
              <p style={{ margin: 0 }}>{selectedSubtype.summary}</p>
            </div>
          </div>
        )}
        {selectedAspects.length > 0 && (
          <div>
            <h3 style={{ color: '#ae3636' }}>ASPECTS</h3>
            <div style={{ paddingLeft: '20px' }}>
              <ul style={{ listStyleType: 'none', padding: 0, margin: 0 }}>
                {selectedAspects.map((aspect) => (
                  <li key={aspect.title} style={{ marginBottom: '10px' }}>
                    <strong style={{ color: '#ae3636' }}>{aspect.title}</strong>
                    <p style={{ margin: 0 }}>{aspect.summary}</p>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        )}
        {selectedClass && (
          <div>
            <h3 style={{ color: '#ae3636' }}>SELECTED CLASS</h3>
            <div style={{ paddingLeft: '20px' }}>
              <p style={{ color: '#ae3636', margin: 0 }}>{selectedClass.name}</p>
              <p style={{ margin: 0 }}>{selectedClass.desc}</p>
            </div>
          </div>
        )}
      </Section>

      <Section style={{ flex: 0.3 }}>
        <Stack direction="row" justify="center">
          {actuallyDisabled ? (
            <span
              style={{ 
                flex: 1, 
                color: '#ae3636', 
                fontSize: '15px', 
                padding: '25px', 
                display: 'flex',
                marginBottom: '110px',
                justifyContent: 'center', 
                alignItems: 'center',
              }}>
              {disableReason()}
            </span>
          ) : null}
          
          {isWarlord ? (
            <Button
              onClick={() => {
                const all_selections = {
                  warband: selectedWarband?.type,
                  subtype: selectedSubtype?.type,
                  aspects: selectedAspects?.map((aspect) => aspect.type),
                  class: selectedClass?.type,
                  subclass: selectedSubclass?.type,
                };
                act('create_warband', all_selections);
                act('interaction_sound');
              }}
              disabled={actuallyDisabled}
              style={{ 
                flex: 1, 
                fontSize: '25px', 
                padding: '25px', 
                display: 'flex',
                marginBottom: '110px',
                justifyContent: 'center', 
                alignItems: 'center',
              }}>
              {getButtonText()}
            </Button>
          ) : (
            <Button
              onClick={() => {
                const all_selections = {
                  warband: selectedWarband?.type,
                  subtype: selectedSubtype?.type,
                  aspects: selectedAspects?.map((aspect) => aspect.type),
                  class: selectedClass?.type,
                  subclass: selectedSubclass?.type,
                };
                act('create_character', all_selections);
                act('interaction_sound');
              }}
              disabled={actuallyDisabled}
              style={{ 
                flex: 1, 
                fontSize: '25px', 
                padding: '25px', 
                display: 'flex',
                marginBottom: '110px',
                justifyContent: 'center', 
                alignItems: 'center',
              }}>
              {getButtonText()}
            </Button>
          )}
        </Stack>
      </Section>
    </Stack>
  );
};
