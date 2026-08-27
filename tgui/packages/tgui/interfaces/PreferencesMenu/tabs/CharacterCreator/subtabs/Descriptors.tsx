import { atomWithTguiStorage } from 'common/storage';
import { useAtom, useAtomValue } from 'jotai';
import { unwrap } from 'jotai/utils';
import { CollapsibleShared, LabeledGridList } from 'pm/components';
import { useConstantPrefs } from 'pm/constant_data';
import {
  SubtabDescriptorsDownstream,
  SubtabDescriptorsOtherInfoDownstream,
  SubtabDescriptorsOtherInfoListDownstream,
  SubtabDescriptorsTextDescriptionsDownstream,
} from 'pm/downstream/tabs/CharacterCreator/subtabs/Descriptors';
import { type ReactNode, useEffect, useState } from 'react';
import { useBackendStrict, useSharedState } from 'tgui/backend';
import { gameDataAtom } from 'tgui/events/store';
import { LoadingScreen } from 'tgui/interfaces/common/LoadingScreen';
import {
  Box,
  Button,
  Dropdown,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import type { AllPagesData, DescriptorData } from '../data';

export const SubtabDescriptors = (props) => {
  return (
    <Section
      fill
      scrollable
      className="PreferencesMenu__Section__NoChildPadding"
    >
      <Stack vertical>
        <Stack.Item>
          <Box className="PreferencesMenu__Grid PreferencesMenu__TwoColumn">
            <Box>
              <MechanicalDescriptions />
            </Box>
            <Box>
              <OtherInfo />
            </Box>
          </Box>
        </Stack.Item>
        <Stack.Item>
          <TextDescriptions />
        </Stack.Item>
        <SubtabDescriptorsDownstream />
      </Stack>
    </Section>
  );
};

const FormattingHelp = (props) => {
  return (
    <Box fontSize={1.1}>
      <Box fontSize={1.2}>
        Note: Previews only update on submit as BYOND must parse your text.
      </Box>
      <br />
      You can use backslash (\\) to escape special characters.
      <br /># text : Defines a header.
      <br />
      Ctrl-T: |text| : Centers the text.
      <br />
      Ctrl-B: **text** : Makes the text <b>bold</b>.<br />
      Ctrl-I: *text* : Makes the text <i>italic</i>.<br />
      Ctrl-6: ^text^ : Increases the{' '}
      <Box inline fontSize={1.2}>
        size
      </Box>{' '}
      of the text.
      <br />
      ((text)) : Decreases the{' '}
      <Box inline fontSize={0.8}>
        size
      </Box>{' '}
      of the text.
      <br />* item : An unordered list item.
      <br />
      --- : Adds a horizontal rule.
      <br />
      -=FFFFFFtext=- : Adds a specific{' '}
      <Box inline textColor="#FFF">
        colour
      </Box>{' '}
      to text.
    </Box>
  );
};

const MechanicalDescriptions = (props) => {
  const [constantData] = useConstantPrefs();
  const { act, data } = useBackendStrict<DescriptorData>();
  const { descriptors, descriptors_custom } = data;

  if (!constantData) {
    return (
      <Section fill title="Mechanical Descriptions">
        <LoadingScreen label="Loading descriptors..." />
      </Section>
    );
  }

  const { descriptors: constantDescriptors, descriptor_choices } = constantData;

  return (
    <Section fill title="Mechanical Descriptions">
      <LabeledGridList>
        {descriptors.map((desc) => {
          const descriptor_choice = descriptor_choices[desc.type];
          const options = descriptor_choice.descriptors.map((type) => ({
            displayText: constantDescriptors[type].name,
            value: type,
          }));

          return (
            <LabeledGridList.Item key={desc.type} label={desc.name}>
              <Dropdown
                displayText={constantDescriptors[desc.selected].name}
                options={options}
                selected={desc.selected}
                onSelected={(val) => {
                  act('set_descriptor', {
                    descriptor_choice: desc.type,
                    mob_descriptor: val,
                  });
                }}
              />
            </LabeledGridList.Item>
          );
        })}
      </LabeledGridList>
      <Box bold inline mt={1}>
        Custom descriptor rules:
      </Box>
      <Box inline mb={1}>
        No proper nouns. No immersion breaking words. No overtly sexual
        descriptors. Look at the pre-written descriptors for examples of what is
        acceptable. Capitalization is handled automatically.
      </Box>
      <LabeledGridList>
        {descriptors_custom.map((desc) => (
          <LabeledGridList.Item key={desc.index} label={desc.name}>
            <Stack>
              {desc.prefix_display !== null ? (
                <Stack.Item>
                  <Button
                    fluid
                    onClick={() =>
                      act('custom_descriptor_prefix', { index: desc.index })
                    }
                  >
                    {desc.prefix_display}
                  </Button>
                </Stack.Item>
              ) : null}
              <Stack.Item grow minWidth={0}>
                <Button
                  fluid
                  ellipsis
                  tooltip={desc.content || 'Unset'}
                  onClick={() =>
                    act('custom_descriptor_content', { index: desc.index })
                  }
                >
                  {desc.content || 'Unset'}
                </Button>
              </Stack.Item>
            </Stack>
          </LabeledGridList.Item>
        ))}
      </LabeledGridList>
      <Button fluid mt={1} mb={1} onClick={() => act('print_descriptor_setup')}>
        Print Descriptor Setup to Chat
      </Button>
    </Section>
  );
};

const OtherInfo = (props) => {
  const { act, data } = useBackendStrict<DescriptorData>();
  const {
    examine_theme,
    ooc_extra,
    song_artist,
    song_title,
    img_gallery,
    nsfw_img_gallery,
  } = data;

  return (
    <Section fill scrollable title="Other Info">
      <LabeledGridList>
        <LabeledGridList.Item label="Examine Theme">
          <Button onClick={() => act('examine_theme')} fluid>
            {examine_theme || 'Unset'}
          </Button>
        </LabeledGridList.Item>
        <LabeledGridList.Item label="Song">
          <Stack vertical>
            <Stack.Item>
              <Button
                ellipsis
                fluid
                tooltip={ooc_extra || 'No URL Set'}
                onClick={() => act('ooc_extra')}
              >
                {ooc_extra || 'No URL Set'}
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Stack align="center">
                <Stack.Item grow minWidth={0}>
                  <Button
                    ellipsis
                    fluid
                    tooltip={song_title || 'None'}
                    onClick={() => act('change_title')}
                  >
                    {song_title || 'None'}
                  </Button>{' '}
                </Stack.Item>
                <Stack.Item>by</Stack.Item>
                <Stack.Item grow minWidth={0}>
                  <Button
                    ellipsis
                    fluid
                    tooltip={song_artist || 'No One'}
                    onClick={() => act('change_artist')}
                  >
                    {song_artist || 'No One'}
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </LabeledGridList.Item>
        <ImageGalleryEdit
          label="Image Gallery"
          list={img_gallery}
          onAdd={() => {
            act('add_img_gallery');
          }}
          onClear={() => {
            act('clear_img_gallery');
          }}
          onSet={(i) => {
            act('set_img_gallery', { index: i });
          }}
        />
        <ImageGalleryEdit
          label="NSFW Gallery"
          list={nsfw_img_gallery}
          onAdd={() => {
            act('add_nsfw_img_gallery');
          }}
          onClear={() => {
            act('clear_nsfw_img_gallery');
          }}
          onSet={(i) => {
            act('set_nsfw_img_gallery', { index: i });
          }}
        />
        <SubtabDescriptorsOtherInfoListDownstream />
      </LabeledGridList>
      <SubtabDescriptorsOtherInfoDownstream />
    </Section>
  );
};

const ImageGalleryEdit = (props: {
  label: string;
  list: string[];
  onAdd: () => void;
  onClear: () => void;
  onSet: (i: number) => void;
}) => {
  const { label, list, onAdd, onClear, onSet } = props;

  return (
    <LabeledGridList.Item
      label={label}
      tooltip="Press enter in the textbox to submit. Empty entries will delete the entry."
    >
      <Stack vertical>
        {list.map((link, i) => (
          <Stack.Item key={i}>
            <Button ellipsis fluid tooltip={link} onClick={() => onSet(i + 1)}>
              {link}
            </Button>
          </Stack.Item>
        ))}
        {list.length < 3 ? (
          <Stack.Item ml={list.length === 0 ? 0 : 2}>
            <Button fluid onClick={onAdd}>
              Add Image
            </Button>
          </Stack.Item>
        ) : null}
        <Stack.Item>
          <Button fluid onClick={onClear}>
            Clear
          </Button>
        </Stack.Item>
      </Stack>
    </LabeledGridList.Item>
  );
};

const TextDescriptions = (props) => {
  const [constantData] = useConstantPrefs();
  const { act, data } = useBackendStrict<DescriptorData>();
  const {
    flavortext_cached,
    flavortext,
    erpprefs_cached,
    erpprefs,
    noble_gossip_cached,
    noble_gossip,
    nsfwflavortext_cached,
    nsfwflavortext,
    ooc_notes_cached,
    ooc_notes,
    rumour_cached,
    rumour,
  } = data;

  return (
    <Section
      title="Text Descriptions"
      buttons={
        <Button onClick={() => act('preview_examine')}>
          Preview Full Examine
        </Button>
      }
    >
      <Stack vertical mr={2}>
        <Stack.Item>
          <CollapsibleShared
            stateKey="formatting-help"
            transparent
            title="Formatting Help"
          >
            <FormattingHelp />
          </CollapsibleShared>
        </Stack.Item>
        <Stack.Item>
          <TextEditor
            name="Flavor Text"
            warning="Flavortext should not include nonphysical nonsensory attributes such as backstory or the character's internal thoughts."
            sharedStatePreview="preview_flavortext"
            maxLength={constantData?.MAX_NOTE_SIZE}
            requiredLength={constantData?.MINIMUM_FLAVOR_TEXT}
            value={flavortext || ''}
            preview={flavortext_cached}
            onSave={(value) =>
              act('save_markdown_text', { type: 'flavortext', value })
            }
          />
        </Stack.Item>
        <Stack.Item>
          <TextEditor
            name="OOC Notes"
            warning="OOC notes should be used for roleplay hooks and general information about your character."
            sharedStatePreview="preview_ooc_notes"
            maxLength={constantData?.MAX_NOTE_SIZE}
            requiredLength={constantData?.MINIMUM_OOC_NOTES}
            value={ooc_notes || ''}
            preview={ooc_notes_cached}
            onSave={(value) =>
              act('save_markdown_text', { type: 'ooc_notes', value })
            }
          />
        </Stack.Item>
        <Stack.Item>
          <TextEditor
            name="NSFW Flavor Text"
            warning="NSFW Flavortext can be used for setting things like body descriptions and other physical details that may be conisdered explicit."
            sharedStatePreview="preview_nsfwflavortext"
            maxLength={constantData?.MAX_NOTE_SIZE}
            value={nsfwflavortext || ''}
            preview={nsfwflavortext_cached}
            onSave={(value) =>
              act('save_markdown_text', { type: 'nsfwflavortext', value })
            }
          />
        </Stack.Item>
        <Stack.Item>
          <TextEditor
            name="ERP Preferences"
            warning="Erotic Roleplay preferences. If you put 'anything goes' or 'no limits' here, do not be surprised if people take you up on it."
            sharedStatePreview="preview_erpprefs"
            maxLength={constantData?.MAX_NOTE_SIZE}
            value={erpprefs || ''}
            preview={erpprefs_cached}
            onSave={(value) =>
              act('save_markdown_text', { type: 'erpprefs', value })
            }
          />
        </Stack.Item>
        <Stack.Divider mt={1} mb={1} />
        <Stack.Item textAlign="right">
          <Button onClick={() => act('rumour_preview')}>
            Preview Rumours & Noble Gossip in chat
          </Button>
        </Stack.Item>
        <Stack.Item>
          <TextEditor
            name="Rumours"
            warning={`Rumours are things others might know, or think they know about you, they don't necessarily have to be precise, or even true. But remember that they can provide a hint to another player on how to interact with, or even think about your character. Avoid explicit bodily descriptions, though rumors like "sleeps around a lot" are fine.`}
            sharedStatePreview="preview_rumour"
            maxLength={400}
            value={rumour || ''}
            preview={rumour_cached}
            onSave={(value) =>
              act('save_markdown_text', { type: 'rumour', value })
            }
          />
        </Stack.Item>
        <Stack.Item>
          <TextEditor
            name="Noble Gossip"
            warning={`Gossip is rumours spread around, and known only in Noble circles, only other well-born individuals are aware of it. Gossip, similarly to standard rumours does not need to be precise or true, but remember that it can provide hints and avenues for other Nobles to interact with, and judge your Character. Avoid explicit bodily descriptions, though rumors like "sleeps around a lot" are fine.`}
            sharedStatePreview="preview_gossip"
            maxLength={400}
            value={noble_gossip || ''}
            preview={noble_gossip_cached}
            onSave={(value) =>
              act('save_markdown_text', { type: 'noble_gossip', value })
            }
          />
        </Stack.Item>
        <SubtabDescriptorsTextDescriptionsDownstream />
      </Stack>
    </Section>
  );
};

// Index via `${sharedStatePreview}-${loaded_slot}`
const persistedEditsAtom = atomWithTguiStorage<Record<string, string>>(
  'pm-persisted-edits',
  {},
);
const unwrappedPersistedEditsAtom = unwrap(persistedEditsAtom);

const EDITOR_HEIGHT = 16;
const TextEditor = (props: {
  name: string;
  warning?: string;
  sharedStatePreview: string;
  onSave: (val: string) => void;
  maxLength?: number;
  requiredLength?: number;
  value: string;
  preview: TrustedHTML | null;
}) => {
  const {
    name,
    warning,
    sharedStatePreview,
    maxLength,
    requiredLength,
    value,
    preview,
  } = props;

  const [showPreview, setShowPreview] = useSharedState(
    sharedStatePreview,
    false,
  );

  const [expanded, setExpanded] = useState(false);

  // Persistent edits
  const [persistedEdits, setPersistedEdits] = useAtom(
    unwrappedPersistedEditsAtom,
  );

  // Input Handling
  const { data } = useBackendStrict<AllPagesData>();
  const { loaded_slot } = data;

  const persistedEditKey = `${sharedStatePreview}-${loaded_slot}`;

  const [input, setInput] = useState(value);

  const updateInput = (val: string) => {
    setInput(val);
    setPersistedEdits(async (v) => {
      const records = await v;
      records[persistedEditKey] = val;
      return records;
    });
  };

  useEffect(() => {
    if (persistedEdits?.[persistedEditKey]) {
      setInput(persistedEdits[persistedEditKey]);
    } else {
      setInput(value);
    }
  }, [loaded_slot, value, persistedEdits]);

  // Each time the user enters a character, persist it
  const onType = (val: string) => {
    updateInput(val);
  };

  // Reload handling
  // have to depend specifically on this to listen for data updates instead of
  // config updates
  const gameData = useAtomValue(gameDataAtom);
  const [reloading, setReloading] = useState(false);

  const onSave = () => {
    if (reloading) {
      return;
    }
    setReloading(true);
    props.onSave(input);
  };

  useEffect(() => {
    setReloading(false);
  }, [gameData]);

  const unsaved = value.trim() !== input.trim();

  let title: ReactNode = name;

  if (requiredLength && input.length < requiredLength) {
    title = (
      <Box inline>
        {title}{' '}
        <Box inline color="bad">
          {' '}
          (Too Short! {input.length}/{requiredLength})
        </Box>
      </Box>
    );
  }

  if (unsaved) {
    title = (
      <Box inline color="bad">
        {title} (Edited!)
      </Box>
    );
  }

  return (
    <CollapsibleShared
      title={title}
      stateKey={`collapse-${sharedStatePreview}`}
    >
      <Stack vertical>
        <Stack.Item>
          <Stack height={2} align="center">
            <Stack.Item grow className="Section__titleText">
              {title}
            </Stack.Item>
            <Stack.Item>
              <Button.Checkbox
                checked={showPreview}
                selected={showPreview}
                onClick={() => setShowPreview(!showPreview)}
              >
                Preview
              </Button.Checkbox>
            </Stack.Item>
            {unsaved ? (
              <>
                <Stack.Item>
                  <Button.Confirm
                    confirmIcon="triangle-exclamation"
                    confirmContent="Discard changes?"
                    icon="rotate-left"
                    tooltip="Reload editors from current game state."
                    onClick={() => updateInput(value)}
                  >
                    Undo
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    disabled={reloading}
                    icon={reloading ? 'rotate' : undefined}
                    iconSpin
                    onClick={onSave}
                  >
                    Submit
                  </Button>
                </Stack.Item>
              </>
            ) : null}
            <Stack.Item>
              <Button
                icon="expand"
                selected={expanded}
                tooltip="Expand Textbox"
                onClick={() => setExpanded((v) => !v)}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        {warning ? (
          <Stack.Item italic fontSize={0.9}>
            {warning}
          </Stack.Item>
        ) : null}
        <Stack.Item>
          <TextArea
            fluid
            maxLength={maxLength}
            height={EDITOR_HEIGHT * (expanded ? 3 : 1)}
            value={input}
            className={
              unsaved ? 'PreferencesMenu__TextEditor__Unsaved' : undefined
            }
            userMarkup={{ t: '|', b: '**', i: '*', '6': '^' }}
            onChange={onType}
          />
        </Stack.Item>
        {showPreview ? (
          <Stack.Item>
            <Section
              fill
              preserveWhitespace
              scrollable
              height={EDITOR_HEIGHT}
              ml={1}
              mr={1}
              title="Preview"
            >
              {preview ? (
                <div
                  // eslint-disable-next-line react/no-danger
                  dangerouslySetInnerHTML={{
                    __html: `<span className='Chat'>${preview}</span>`,
                  }}
                />
              ) : (
                <Box italic fontSize={0.8}>
                  Nothing to preview
                </Box>
              )}
            </Section>
          </Stack.Item>
        ) : null}
      </Stack>
    </CollapsibleShared>
  );
};
