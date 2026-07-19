import { Box, LabeledList, NoticeBox, Section } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type AspectData = {
  name: string;
  desc: string;
  type: string;
  color: string;
  calibration_progress: number;
  calibration_required: number;
  // Trait-specific data
  liked_concepts?: string[];
  preferred_approaches_summary?: string;
  conflicting_traits?: string[];
  // Quirk-specific data
  conflicting_quirks?: string[];
  // Archetype-specific data
  possible_traits?: string[];
  possible_quirks?: string[];
  discharge_colors?: string[];
};

type Data = {
  filled: boolean;
  aspect_data?: AspectData;
};

export const HeartCanister = (props) => {
  const { data } = useBackend<Data>();
  const { filled = false, aspect_data } = data || {};

  const {
    name = 'N/A',
    desc = 'No description available',
    type = 'Unknown',
    color = '#ffffff',
    liked_concepts = [],
    preferred_approaches_summary = 'N/A',
    conflicting_traits = [],
    conflicting_quirks = [],
    // Archetype-specific defaults
    possible_traits = [],
    possible_quirks = [],
    discharge_colors = [],
  } = aspect_data || {};

  return (
    <Window width={450} height={400} title="Aspect Canister Examination">
      <Window.Content>
        {!filled && type === 'Unknown' ? (
          <NoticeBox>This canister is empty.</NoticeBox>
        ) : (
          <>
            <Section title="Aspect Details">
              <LabeledList>
                <LabeledList.Item label="Aspect Name" color="yellow">
                  <Box color={color}>{name}</Box>
                </LabeledList.Item>
                <LabeledList.Item label="Type">{type}</LabeledList.Item>
                <LabeledList.Item label="Description">{desc}</LabeledList.Item>
              </LabeledList>
            </Section>

            {/* --- Archetype-Specific Information --- */}
            {type === 'Archetype' && (
              <Section title="Archetype Specifics">
                <LabeledList>
                  <LabeledList.Item label="Possible Traits">
                    {possible_traits.length
                      ? possible_traits.join(', ')
                      : 'None'}
                  </LabeledList.Item>
                  <LabeledList.Item label="Possible Quirks">
                    {possible_quirks.length
                      ? possible_quirks.join(', ')
                      : 'None'}
                  </LabeledList.Item>
                  <LabeledList.Item label="Discharge Colors">
                    <Box>
                      {discharge_colors.length ? (
                        <Box>
                          {discharge_colors.map((dischargeColor, index) => (
                            <Box
                              key={index}
                              inline
                              style={{
                                width: '16px',
                                height: '16px',
                                backgroundColor: dischargeColor,
                                border: '1px solid #000',
                                margin: '2px',
                                display: 'inline-block',
                                verticalAlign: 'middle',
                              }}
                            />
                          ))}
                          <Box inline ml={1}>
                            ({discharge_colors.join(', ')})
                          </Box>
                        </Box>
                      ) : (
                        'None'
                      )}
                    </Box>
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            )}

            {/* --- Quirk-Specific Information --- */}
            {type === 'Quirk' && (
              <Section title="Quirk Specifics">
                <LabeledList>
                  <LabeledList.Item label="Conflicts">
                    {conflicting_quirks.length
                      ? conflicting_quirks.join(', ')
                      : 'None'}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            )}

            {/* --- Trait-Specific Information --- */}
            {type === 'Trait' && (
              <Section title="Trait Specifics">
                <LabeledList>
                  <LabeledList.Item label="Conflicts">
                    {conflicting_traits.length
                      ? conflicting_traits.join(', ')
                      : 'None'}
                  </LabeledList.Item>
                  <LabeledList.Item label="Liked Concepts">
                    {liked_concepts.length ? liked_concepts.join(', ') : 'None'}
                  </LabeledList.Item>
                  <LabeledList.Item label="Preferred Approaches">
                    {preferred_approaches_summary}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            )}
          </>
        )}
      </Window.Content>
    </Window>
  );
};
