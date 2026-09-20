import { PrefPopupGuard, VirtueDetails } from 'pm/components';
import {
  type ConstantData,
  type ConstantVirtue,
  useConstantPrefs,
} from 'pm/constant_data';
import type { Path } from 'pm/data';
import {
  type PopupData,
  registerPopup,
  useKeyscrollEffect,
  usePopupBackend,
  usePopupContext,
} from 'pm/popups';
import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { useFuzzySearch } from 'tgui-core/fuzzysearch';

/**
 * @see {@link ConstantData.virtues}
 */
type PopupVirtueData = {
  slot_names: string[];
  virtues: Path[];
  virtue_availability: VirtueAvailability[];
} & PopupData;

type VirtueAvailability = {
  path: Path;
  unavailable: string | null; // Reason it's not available or null if it is
};

export type PopupVirtueContext = {
  id: number;
};

const PopupVirtueSelector = () => {
  const [constantData] = useConstantPrefs();
  const [context] = usePopupContext<PopupVirtueContext>();
  const { data } = usePopupBackend<PopupVirtueData>();
  const { popup_data_ready, slot_names } = data;

  return (
    <PrefPopupGuard
      title={`Selecting ${context && slot_names ? slot_names[context.id - 1] : '(name loading...)'}`}
      loadingScreenText="Virtues Loading..."
      width="80vw"
      height="80vh"
      dependencies={[constantData, context, popup_data_ready]}
    >
      <PopupVirtueSelectorInner
        constantData={constantData!}
        context={context!}
      />
    </PrefPopupGuard>
  );
};

// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    Virtue: 'virtue';
  }
  interface PopupContextRegistry {
    Virtue: PopupVirtueContext;
  }
}
registerPopup('Virtue', 'virtue', PopupVirtueSelector);

// Main content
const PopupVirtueSelectorInner = (props: {
  constantData: ConstantData;
  context: PopupVirtueContext;
}) => {
  const { constantData, context } = props;
  const { data } = usePopupBackend<PopupVirtueData>();
  const { virtues: constantVirtues } = constantData;
  const { slot_names, virtues, virtue_availability } = data;
  const [viewing, setViewing] = useState('');

  const virtues_to_show = virtue_availability
    .map((v) => ({
      constantVirtue: constantVirtues[v.path],
      virtue: v,
    }))
    .sort((a, b) => a.constantVirtue.name.localeCompare(b.constantVirtue.name));
  const { query, setQuery, results } = useFuzzySearch({
    getSearchString: (s) => s.constantVirtue.name,
    searchArray: virtues_to_show,
  });

  useKeyscrollEffect({
    list: virtues_to_show,
    currentIndex: virtues_to_show.findIndex((v) => v.virtue.path === viewing),
    setter: (v) => {
      setViewing(v.virtue.path);
    },
  });

  useEffect(() => {
    document
      .getElementById(`PreferencesMenuPopupVirtueSelectorTab_${viewing}`)
      ?.scrollIntoView({ behavior: 'smooth', block: 'center' });
  }, [viewing]);

  return (
    <Stack fill>
      <Stack.Item basis="35%">
        <Stack fill vertical>
          <Stack.Item>
            <Input
              fluid
              mt={0.5}
              ml={0.5}
              placeholder="Search..."
              style={{ border: 'none' }}
              onChange={setQuery}
              value={query}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              <Tabs vertical>
                {(query.length ? results : virtues_to_show).map(
                  ({ constantVirtue, virtue }) => {
                    return (
                      <VirtueTab
                        key={virtue.path}
                        context={context}
                        slot_names={slot_names}
                        constantVirtue={constantVirtue}
                        virtue={virtue}
                        viewing={viewing}
                        setViewing={setViewing}
                        virtues={virtues}
                      />
                    );
                  },
                )}
              </Tabs>
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item grow>
        {constantVirtues[viewing] ? (
          <VirtueDetailsView
            context={context}
            slot_names={slot_names}
            path={viewing}
            constantVirtue={constantVirtues[viewing]}
            virtue={
              virtues_to_show.find((v) => v.virtue.path === viewing)!.virtue
            }
            virtues={virtues}
          />
        ) : (
          <Section fill title="Not Selected">
            Select a virtue from the left pane.
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};

// Gives us data about whether or not this virtue is available
const isVirtueAvailable = (
  context: PopupVirtueContext,
  slot_names: string[],
  virtue: VirtueAvailability,
  constantVirtue: ConstantVirtue,
  virtues: Path[],
) => {
  const disabledData = {
    disabled: false,
    icon: 'x',
    color: 'bad',
    reason: '',
  };

  // gotta do +1 to translate into BYONDism
  const selectedInAnySlot = virtues.indexOf(virtue.path) + 1;
  const selectedInThisSlot = selectedInAnySlot === context.id;

  if (virtue.unavailable) {
    // If it's marked unavailable by the server, disable.
    disabledData.disabled = true;
    disabledData.reason = virtue.unavailable;
  } else if (constantVirtue.stackable && selectedInThisSlot) {
    // If it's a stackable virtue and it's already selected in our slot, disable.
    disabledData.disabled = true;
    disabledData.color = 'good';
    disabledData.icon = 'check';
    disabledData.reason = 'This virtue is already selected in this slot.';
  } else if (!constantVirtue.stackable && selectedInAnySlot !== 0) {
    // If it not a stackable virtue and it's already selected in any slot, disable.
    disabledData.disabled = true;
    // If it is our slot, do a different color.
    if (selectedInThisSlot) {
      disabledData.color = 'good';
      disabledData.reason = 'This virtue is already selected in this slot.';
    } else {
      disabledData.color = 'average';
      disabledData.reason = `This virtue is already selected for "${slot_names[selectedInAnySlot - 1]}" and is not stackable.`;
    }
    disabledData.icon = 'check';
  } else if (constantVirtue.stackable && selectedInAnySlot !== 0) {
    // We want to tell the caller about this case even though it doesn't disable anything.
    disabledData.color = 'label';
    disabledData.icon = 'check';
    disabledData.reason = `This virtue is already selected for "${slot_names[selectedInAnySlot - 1]}", but it is stackable.`;
  }

  return disabledData;
};

const VirtueTab = (props: {
  context: PopupVirtueContext;
  slot_names: string[];
  constantVirtue: ConstantVirtue;
  virtue: VirtueAvailability;
  viewing: Path;
  setViewing: React.Dispatch<React.SetStateAction<Path>>;
  virtues: Path[];
}) => {
  const {
    context,
    slot_names,
    constantVirtue,
    virtue,
    viewing,
    setViewing,
    virtues,
  } = props;
  const { act } = usePopupBackend();
  const disabledData = isVirtueAvailable(
    context,
    slot_names,
    virtue,
    constantVirtue,
    virtues,
  );

  return (
    <Tabs.Tab
      key={virtue.path}
      ml={1}
      id={`PreferencesMenuPopupVirtueSelectorTab_${virtue.path}`}
      selected={viewing === virtue.path}
      onClick={() => setViewing(virtue.path)}
      textColor={disabledData.reason ? disabledData.color : undefined}
      icon={constantVirtue.icon || ''}
      rightSlot={
        <Box width={2}>
          {disabledData.disabled ? (
            <Icon name={disabledData.icon} color={disabledData.color} />
          ) : (
            <Button
              color="transparent"
              icon={disabledData.reason ? disabledData.icon : 'plus'}
              tooltip="Quick Add"
              onClick={(e: React.MouseEvent) => {
                e.stopPropagation();
                act('select_virtue', {
                  id: context.id,
                  virtue: virtue.path,
                });
              }}
            />
          )}
        </Box>
      }
    >
      {constantVirtue.name}
    </Tabs.Tab>
  );
};

type VirtueDetailsViewProps = {
  context: PopupVirtueContext;
  slot_names: string[];
  path: Path;
  constantVirtue: ConstantVirtue;
  virtue: VirtueAvailability;
  virtues: Path[];
};

const VirtueDetailsView = (props: VirtueDetailsViewProps) => {
  const { context, slot_names, path, constantVirtue, virtue, virtues } = props;
  const { act } = usePopupBackend();
  const disabledData = isVirtueAvailable(
    context,
    slot_names,
    virtue,
    constantVirtue,
    virtues,
  );

  return (
    <Section
      fill
      scrollable
      title={
        <Stack align="center">
          <Stack.Item>
            <Icon name={constantVirtue.icon || ''} />
          </Stack.Item>
          <Stack.Item grow>{constantVirtue.name}</Stack.Item>
        </Stack>
      }
      buttons={
        <Stack>
          <Stack.Divider />
          <Button
            disabled={disabledData.disabled}
            // we just wanna force the button not to be transparent,
            // actual color is not important
            color="justNotTransparent"
            onClick={() => {
              act('select_virtue', { id: context!.id, virtue: path });
            }}
          >
            Select this Virtue
          </Button>
        </Stack>
      }
    >
      {/* We check .reason instead of .disabled to show when it's selected in another slot */}
      {disabledData.reason ? (
        <Box fontSize={1.1} color={disabledData.color}>
          {disabledData.reason}
        </Box>
      ) : null}
      <VirtueDetails virtue={constantVirtue} />
    </Section>
  );
};
