import { Button, Section, Stack } from 'tgui-core/components';

import { ClassType, WarbandType } from './WarbandTypes';

type ClassesTabProps = {
  selectedWarband: WarbandType | null;
  selectedClass: ClassType | null;
  selectedSubclass: ClassType | null;
  availableClasses: ClassType[];
  filteredSubclasses: ClassType[];
  handleClassSelect: (classe: ClassType) => void;
  handleSubclassSelect: (subclass: ClassType) => void;
  act: (action: string) => void;
  canModify?: boolean;
};

export const ClassesTab = ({
  selectedWarband,
  selectedClass,
  selectedSubclass,
  availableClasses,
  filteredSubclasses,
  handleClassSelect,
  handleSubclassSelect,
  act,
  canModify = true,
}: ClassesTabProps) => {
  return (
    <Stack vertical fill>
      <Stack row-Reverse style={{ flex: 1 }}>
        <Section 
          title={<span style={{ color: '#7a2525ff' }}>AVAILABLE CLASSES</span>} 
          scrollable 
          fill 
          style={{ flex: 1, minWidth: '5px' }}
        >
          {selectedWarband && availableClasses.length > 0 ? (
            <Stack vertical>
              {availableClasses.map((classe) => {
                const isSelected = selectedClass?.name === classe.name;
                return (
                  <Button
                    key={classe.name}
                    onClick={() => {
                      if (!canModify) return;
                      handleClassSelect(classe);
                      act('interaction_sound');
                    }}
                    disabled={!canModify}
                    style={{ 
                      backgroundColor: isSelected ? '#7a2525ff' : undefined, 
                      whiteSpace: 'normal', 
                      textAlign: 'left',
                    }}>
                    <Stack vertical>
                      <span style={{ fontSize: '14px' }}>{classe.name || classe.alt_name}</span>
                      <span style={{ fontSize: '12px', color: '#ccc' }}>{classe.desc}</span>
                    </Stack>
                  </Button>
                );
              })}
            </Stack>
          ) : (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
              <p style={{ color: '#7a2525ff' }}>NO CLASSES AVAILABLE</p>
            </div>
          )}
        </Section>
        
        <Section 
          title={<span style={{ color: '#7a2525ff' }}>AVAILABLE SUBCLASSES</span>} 
          scrollable 
          fill 
          style={{ flex: 1 }}
        >
          {selectedWarband?.title === "MERCENARY COMPANY" && filteredSubclasses.length > 0 ? (
            <Stack vertical>
              {filteredSubclasses.map((subclass) => {
                const isSelected = selectedSubclass?.alt_name === subclass.alt_name;
                return (
                  <Button
                    key={subclass.alt_name}
                    onClick={() => {
                      if (!canModify) return;
                      handleSubclassSelect(subclass);
                      act('interaction_sound');
                    }}
                    disabled={!canModify}
                    style={{ 
                      backgroundColor: isSelected ? '#7a2525ff' : undefined, 
                      whiteSpace: 'normal', 
                      textAlign: 'left',
                    }}>
                    <Stack vertical>
                      <span style={{ fontSize: '14px' }}>{subclass.name || subclass.alt_name}</span>
                      <span style={{ fontSize: '12px', color: '#ccc' }}>{subclass.desc}</span>
                    </Stack>
                  </Button>
                );
              })}
            </Stack>
          ) : (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
              <p style={{ color: '#7a2525ff' }}>
                {selectedWarband?.title === "MERCENARY COMPANY" 
                  ? 'NO SUBCLASSES AVAILABLE' 
                  : 'UNAVAILABLE | MERCENARY ONLY'}
              </p>
            </div>
          )}
        </Section>
      </Stack>
      
      <Section style={{ flex: 0.3 }}>
        <Stack direction="row" justify="center">
          <Button
            onClick={() => {
              if (!canModify) return;
              act('swap_character_slot');
              act('interaction_sound');
            }}
            disabled={!canModify}
            style={{ 
              fontSize: '25px', 
              padding: '25px',
              flex: 1, 
              display: 'flex', 
              marginBottom: '110px',
              justifyContent: 'center', 
              alignItems: 'center',
            }}>
            CHANGE CHARACTER SLOT
          </Button>
          <Button
            onClick={() => {
              if (!canModify) return;
              act('edit_character');
              act('interaction_sound');
            }}
            disabled={!canModify}
            style={{ 
              fontSize: '25px', 
              padding: '25px', 
              flex: 1, 
              display: 'flex',
              marginBottom: '110px',
              justifyContent: 'center', 
              alignItems: 'center',
            }}>
            EDIT APPEARANCE
          </Button>
        </Stack>
      </Section>
    </Stack>
  );
};
