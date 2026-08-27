import {
  CollapsibleShared,
  ColorButton,
  ensureColorHash,
  LabeledGridList,
} from 'pm/components';
import { SubtabAppearanceDownstream } from 'pm/downstream/tabs/CharacterCreator/subtabs/Appearance';
import { usePopupId } from 'pm/popups';
import { ReactSortable } from 'react-sortablejs';
import { useBackendStrict } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import type { AppearanceData, Marking } from '../data';
import { FeatureChoice } from './Appearance/FeatureChoice';

export const SubtabAppearance = (props) => {
  return (
    <Section
      fill
      scrollable
      className="PreferencesMenu__Section__NoChildPadding"
    >
      <Stack vertical>
        {Object.entries(TABS).map(([name, { Content, icon }]) => (
          <Stack.Item key={name}>
            <CollapsibleShared
              stateKey={`charactercreator-appearance-collapsible-${name}`}
              title={
                <Stack inlineFlex>
                  <Stack.Item width={1} textAlign="center">
                    <Icon name={icon} />
                  </Stack.Item>
                  <Stack.Item>{name}</Stack.Item>
                </Stack>
              }
            >
              <Content />
            </CollapsibleShared>
          </Stack.Item>
        ))}
        <SubtabAppearanceDownstream />
      </Stack>
    </Section>
  );
};

const SubtabAppearanceCardBody = (props) => {
  const { act, data } = useBackendStrict<AppearanceData>();
  const {
    allowed_taur_types,
    body_size,
    body_type,
    mcolor,
    mcolor2,
    mcolor3,
    skin_tone_wording,
    taur_color,
    taur_name,
    update_mutant_colors,
    use_mutcolor,
    use_skintones,
  } = data;
  const [, setPopupId] = usePopupId();

  return (
    <Section>
      <LabeledGridList>
        <LabeledGridList.Item label="Body Type">
          <Button fluid onClick={() => act('bodytype')}>
            {body_type}
          </Button>
        </LabeledGridList.Item>
        {use_skintones ? (
          <LabeledGridList.Item label={skin_tone_wording}>
            <SkinToneSelection />
          </LabeledGridList.Item>
        ) : null}
        <LabeledGridList.Item label="Update Features on change">
          <Button.Checkbox
            fluid
            checked={update_mutant_colors}
            selected={update_mutant_colors}
            onClick={() => act('update_mutant_colors')}
          >
            {update_mutant_colors
              ? 'Features/Markings will be reset to mutant color on change.'
              : 'Features/Markings will NOT be reset on change.'}
          </Button.Checkbox>
        </LabeledGridList.Item>
        {use_mutcolor ? (
          <>
            <LabeledGridList.Item
              label="Mutant Color #1"
              verticalAlign="middle"
            >
              <ColorButton
                backgroundColor={mcolor}
                tooltip={ensureColorHash(mcolor)}
                onClick={() => act('mutant_color')}
              />
            </LabeledGridList.Item>
            <LabeledGridList.Item
              label="Mutant Color #2"
              verticalAlign="middle"
            >
              <ColorButton
                backgroundColor={mcolor2}
                tooltip={ensureColorHash(mcolor2)}
                onClick={() => act('mutant_color2')}
              />
            </LabeledGridList.Item>
            <LabeledGridList.Item
              label="Mutant Color #3"
              verticalAlign="middle"
            >
              <ColorButton
                backgroundColor={mcolor3}
                tooltip={ensureColorHash(mcolor3)}
                onClick={() => act('mutant_color3')}
              />
            </LabeledGridList.Item>
          </>
        ) : null}
        <LabeledGridList.Item label="Sprite Scale">
          <Button onClick={() => act('body_size')}>{body_size}%</Button>
        </LabeledGridList.Item>
        {allowed_taur_types.length ? (
          <LabeledGridList.Item label="Taur Body Type">
            <Stack>
              <Stack.Item grow>
                <Button
                  fluid
                  icon="bars"
                  onClick={() => setPopupId('TaurType')}
                >
                  {taur_name || 'None'}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <ColorButton
                  backgroundColor={taur_color}
                  tooltip={`Taur Color: ${ensureColorHash(taur_color)}`}
                  onClick={() => act('taur_color')}
                />
              </Stack.Item>
            </Stack>
          </LabeledGridList.Item>
        ) : null}
      </LabeledGridList>
    </Section>
  );
};

const SkinToneSelection = (props) => {
  const { act, data } = useBackendStrict<AppearanceData>();
  const { available_skin_tones, skin_tone } = data;

  const options = Object.entries(available_skin_tones).map(([k, v]) => {
    const color = ensureColorHash(v);
    return {
      displayText: (
        <Stack>
          <Stack.Item grow>{k}</Stack.Item>
          <Tooltip content={color}>
            <Stack.Item
              style={{
                border: '1px solid #fff',
                outline: '1px solid var(--color-border)',
                backgroundColor: color,
                color,
              }}
              width={4}
            >
              <Icon name="square" />
            </Stack.Item>
          </Tooltip>
        </Stack>
      ),
      value: k,
      // we just use this to find our selected option, otherwise we don't care
      extra: v,
    };
  });

  const selected = options.find((v) => v.extra === skin_tone);

  return (
    <Box fontSize={1.2}>
      <Dropdown
        displayText={selected?.value}
        selected={selected?.value}
        options={options}
        onSelected={(val) => {
          act('set_skin_tone', { skin_tone: val });
        }}
      />
    </Box>
  );
};

const SubtabAppearanceCardFeatures = (props) => {
  const { act, data } = useBackendStrict<AppearanceData>();
  const { customizers } = data;

  return (
    <Section>
      <Box className="PreferencesMenu__Grid PreferencesMenu__Features">
        {customizers.map((c) => (
          <Section
            key={c.name}
            title={c.name}
            buttons={
              <Button.Checkbox
                inline
                checked={!c.disabled}
                selected={!c.disabled}
                style={
                  c.allows_disabling
                    ? undefined
                    : {
                        visibility: 'hidden',
                      }
                }
                onClick={() =>
                  act('change_customizer', {
                    customizer: c.type,
                    customizer_task: 'toggle_missing',
                  })
                }
              />
            }
          >
            {c.disabled ? (
              <Box>Disabled</Box>
            ) : (
              <FeatureChoice customizer={c} />
            )}
          </Section>
        ))}
      </Box>
    </Section>
  );
};

// Markings
const SubtabAppearanceCardMarkings = (props) => {
  const { act, data } = useBackendStrict<AppearanceData>();
  const { marking_zones } = data;
  const [, setPopupId] = usePopupId();

  return (
    <Section>
      <Stack vertical>
        <Stack.Item>
          <Stack justify="right">
            <Stack.Item>
              <Button onClick={() => act('marking_use_preset')}>Presets</Button>
            </Stack.Item>
            <Stack.Item>
              <Button onClick={() => act('marking_reset_all_colors')}>
                Reset Colors
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Box className="PreferencesMenu__Grid PreferencesMenu__Markings">
            {marking_zones.map((zone) => (
              <Section
                key={zone.zone}
                title={zone.name}
                style={{ overflow: 'hidden' }}
                buttons={
                  <Button
                    disabled={!zone.may_add}
                    icon="bars"
                    onClick={() =>
                      setPopupId('MarkingSelect', { zone: zone.zone })
                    }
                  >
                    Add
                  </Button>
                }
              >
                {zone.markings ? (
                  <ReactSortable
                    list={zone.markings.map((m) => ({ id: m.key, ...m }))}
                    setList={(list) => {
                      // Only update on order change
                      if (
                        list.map((v) => v.id).join('') !==
                        zone.markings?.map((m) => m.key).join('')
                      ) {
                        // Reshape it into the correct format
                        // We have [{ key: "Nose", color: "#FF0000" }, { key: "Eyeliner", color: "#FF0000" }]
                        // We need { "Nose": "FF0000", "Eyeliner": "FF0000" }
                        const new_zone = list.reduce(
                          (obj, item) =>
                            Object.assign(obj, {
                              [item.key]: item.color.substring(1),
                            }),
                          {},
                        );
                        act('reorder_zone', {
                          zone: zone.zone,
                          new_zone,
                        });
                      }
                    }}
                  >
                    {zone.markings.map((marking) => (
                      <MarkingItem
                        key={marking.key}
                        marking={marking}
                        zone={zone.zone}
                      />
                    ))}
                  </ReactSortable>
                ) : (
                  <Stack.Item italic>No markings selected.</Stack.Item>
                )}
              </Section>
            ))}
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const MarkingItem = ({ marking, zone }: { marking: Marking; zone: string }) => {
  const { act } = useBackendStrict();

  return (
    <Stack align="center" mb={1}>
      <Stack.Item>
        <Icon name="grip-vertical" />
      </Stack.Item>
      <Stack.Item grow minWidth={0}>
        <Button
          ellipsis
          fluid
          tooltip={marking.key}
          onClick={() =>
            act('change_marking', {
              key: zone,
              name: marking.key,
            })
          }
        >
          {marking.key}
        </Button>
      </Stack.Item>
      <Stack.Item>
        <ColorButton
          backgroundColor={marking.color}
          tooltip={ensureColorHash(marking.color)}
          onClick={() =>
            act('marking_change_color', {
              key: zone,
              name: marking.key,
            })
          }
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          inline
          onClick={() =>
            act('marking_reset_color', {
              key: zone,
              name: marking.key,
            })
          }
        >
          R
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          fluid
          icon="x"
          inline
          onClick={() =>
            act('remove_marking', {
              key: zone,
              name: marking.key,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};

const TABS = {
  Body: { Content: SubtabAppearanceCardBody, icon: 'person' },
  Features: { Content: SubtabAppearanceCardFeatures, icon: 'eye' },
  Markings: { Content: SubtabAppearanceCardMarkings, icon: 'marker' },
};
