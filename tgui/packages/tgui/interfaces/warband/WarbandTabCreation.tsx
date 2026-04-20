import { Button, Section, Stack } from 'tgui-core/components';

import { AspectType, SubType, WarbandType } from './WarbandTypes';

type CreationTabProps = {
  filteredWarbands: WarbandType[];
  filteredSubtypes: SubType[];
  filteredAspects: AspectType[];
  selectedWarband: WarbandType | null;
  selectedSubtype: SubType | null;
  selectedAspects: AspectType[];
  handleWarbandSelect: (warband: WarbandType) => void;
  handleSubtypeSelect: (subtype: SubType) => void;
  handleAspectSelect: (aspect: AspectType) => void;
  act: (action: string, payload?: object) => void;
  locked?: boolean;
  stage1Complete?: boolean;
  isStage1?: boolean;
  isWarlord?: boolean;
  pointCounter?: number;
};

export const CreationTab = ({
  filteredWarbands,
  filteredSubtypes,
  filteredAspects,
  selectedWarband,
  selectedSubtype,
  selectedAspects,
  handleWarbandSelect,
  handleSubtypeSelect,
  handleAspectSelect,
  act,
  locked = false,
  stage1Complete = false,
  isStage1 = true,
  isWarlord = false,
  pointCounter = 0,
}: CreationTabProps) => {

  const getAspectColor = (points: number) => {
    if (points < 0) return '#3c0d0d';
    if (points > 0) return '#722b5d';
    return undefined;
  };

  const disableReason = () => {
    if (stage1Complete) return null;
    if (pointCounter < 0) return "MUST HAVE 0 OR MORE ASPECT POINTS";
    if (!selectedWarband) return "SELECT A WARBAND";
    if (selectedWarband?.subtyperequired && !selectedSubtype) return "THIS WARBAND REQUIRES A SUBTYPE";
    return null;
  };

  const canAdvance = stage1Complete;

  return (
    <Stack style={{ flex: 1, flexDirection: 'column', height: '100%' }}>
      <Stack direction="row" style={{ flex: 1, minHeight: 0 }}>
        <Section
          title={<span style={{ color: '#7a2525ff' }}>AVAILABLE WARBANDS</span>}
          scrollable fill
          style={{ flex: 1, minWidth: '280px' }}
        >
          {filteredWarbands.length > 0 ? (
            <Stack vertical>
              {filteredWarbands.map((warband) => (
                <Button
                  key={warband.title}
                  onClick={() => {
                    if (locked) return;
                    act('interaction_sound');
                    handleWarbandSelect(warband);
                  }}
                  disabled={locked || selectedWarband?.title === warband.title}
                  style={{ backgroundColor: selectedWarband?.title === warband.title ? '#7a2525ff' : undefined }}
                >
                  {warband.title}
                </Button>
              ))}
            </Stack>
          ) : (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
              <p>NO WARBANDS AVAILABLE.</p>
            </div>
          )}
        </Section>

        <Section
          title={<span style={{ color: '#7a2525ff' }}>SUBTYPE</span>}
          scrollable fill
          style={{ flex: 1, minWidth: '280px' }}
        >
          {selectedWarband && filteredSubtypes.length > 0 ? (
            <Stack vertical>
              {filteredSubtypes.map((subtype) => (
                <Button
                  key={subtype.title}
                  onClick={() => {
                    if (locked) return;
                    handleSubtypeSelect(subtype);
                    act('interaction_sound');
                  }}
                  disabled={locked}
                  tooltip={subtype.summary}
                  style={{ backgroundColor: selectedSubtype?.type === subtype.type ? '#7a2525ff' : undefined }}
                >
                  {subtype.title}
                </Button>
              ))}
            </Stack>
          ) : (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
              <p style={{ color: '#7a2525ff' }}>{selectedWarband ? 'NO SUBTYPES AVAILABLE' : 'SELECT A WARBAND'}</p>
            </div>
          )}
        </Section>

        <Section
          title={<span style={{ color: '#7a2525ff' }}>ASPECTS</span>}
          scrollable fill
          style={{ flex: 1, minWidth: '280px' }}
        >
          {selectedWarband && filteredAspects.length > 0 ? (
            <Stack vertical>
              {filteredAspects.map((aspect) => {
                const isSelected = selectedAspects.some((s) => s.title === aspect.title);
                return (
                  <Button
                    key={aspect.title}
                    onClick={() => {
                      if (locked) return;
                      handleAspectSelect(aspect);
                      act('interaction_sound');
                    }}
                    disabled={locked}
                    style={{
                      backgroundColor: isSelected ? '#7a2525ff' : getAspectColor(aspect.points),
                      height: 'auto',
                      padding: '12px 16px',
                      whiteSpace: 'normal',
                      textAlign: 'left',
                    }}
                  >
                    <div style={{ fontWeight: 'bold' }}>{aspect.title}</div>
                    <p style={{ margin: 0, fontSize: '15px' }}>{aspect.summary}</p>
                  </Button>
                );
              })}
            </Stack>
          ) : (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
              <p style={{ color: '#7a2525ff' }}>{selectedWarband ? 'NO ASPECTS AVAILABLE' : 'SELECT A WARBAND'}</p>
            </div>
          )}
        </Section>
      </Stack>

      <Section
        title={<span style={{ color: '#7a2525ff' }}>{selectedWarband?.title || 'No Warband Selected'}</span>}
        style={{ flexShrink: 0, maxHeight: '200px', minHeight: '200px', overflowY: 'scroll' }}
      >
        {selectedWarband ? (
          <Stack vertical style={{ display: 'flex', flexDirection: 'column', textAlign: 'center' }}>
            <p>{selectedWarband.summary}</p>
            <p style={{ color: '#7a2525ff', marginBottom: '0' }}><i>{selectedSubtype?.quote}</i></p>
            <p style={{ color: '#582424ff', marginTop: '0' }}><b>{selectedSubtype?.quote_followup}</b></p>
          </Stack>
        ) : (
          <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
            <p style={{ color: '#7a2525ff' }}>SELECT A WARBAND</p>
          </div>
        )}
      </Section>

      {isStage1 && isWarlord ? (
        <Section style={{ flex: 0, flexBasis: 'auto' }}>
          <Stack direction="row" justify="center">
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
              }}
            >
              {disableReason()}
            </span>
            <Button
              onClick={() => {
                const stage1_selections = {
                  warband: selectedWarband?.type,
                  subtype: selectedSubtype?.type,
                  aspects: selectedAspects?.map((aspect) => aspect.type),
                };
                act('advance_stage', stage1_selections);
                act('interaction_sound');
              }}
              disabled={!canAdvance}
              style={{
                flex: 1,
                fontSize: '25px',
                padding: '25px',
                marginBottom: '110px',
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
              }}
            >
              CONFIRM WARBAND
            </Button>
          </Stack>
        </Section>
      ) : (
        <div style={{ height: '110px' }} />
      )}
    </Stack>
  );
};
