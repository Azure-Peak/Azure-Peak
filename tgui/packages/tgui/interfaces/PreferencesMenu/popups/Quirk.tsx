import { PrefPopupGuard, QuirkDetails } from 'pm/components';
import {
  type ConstantData,
  type ConstantQuirk,
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
 * @see {@link ConstantData.quirks}
 */
type PopupQuirkData = {
  slot_names: string[];
  quirks: Path[];
  quirk_availability: QuirkAvailability[];
} & PopupData;

type QuirkAvailability = {
  path: Path;
  unavailable: string | null; // Reason it's not available or null if it is
};

export type PopupQuirkContext = {
  id: number;
};

const PopupQuirkSelector = () => {
  const [constantData] = useConstantPrefs();
  const [context] = usePopupContext<PopupQuirkContext>();
  const { data } = usePopupBackend<PopupQuirkData>();
  const { popup_data_ready, slot_names } = data;

  return (
    <PrefPopupGuard
      title={`Selecting ${context && slot_names ? slot_names[context.id - 1] : '(name loading...)'}`}
      loadingScreenText="Quirks Loading..."
      width="80vw"
      height="80vh"
      dependencies={[constantData, context, popup_data_ready]}
    >
      <PopupQuirkSelectorInner
        constantData={constantData!}
        context={context!}
      />
    </PrefPopupGuard>
  );
};

// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    Quirk: 'quirk';
  }
  interface PopupContextRegistry {
    Quirk: PopupQuirkContext;
  }
}
registerPopup('Quirk', 'quirk', PopupQuirkSelector);

// Main content
const PopupQuirkSelectorInner = (props: {
  constantData: ConstantData;
  context: PopupQuirkContext;
}) => {
  const { constantData, context } = props;
  const { data } = usePopupBackend<PopupQuirkData>();
  const { quirks: constantQuirks } = constantData;
  const { slot_names, quirks, quirk_availability } = data;
  const [viewing, setViewing] = useState('');

  const quirks_to_show = quirk_availability
    .map((quirk) => ({
      constantQuirk: constantQuirks[quirk.path],
      quirk: quirk,
    }))
    .sort((a, b) => a.constantQuirk.name.localeCompare(b.constantQuirk.name));
  const { query, setQuery, results } = useFuzzySearch({
    getSearchString: (s) => s.constantQuirk.name,
    searchArray: quirks_to_show,
  });

  useKeyscrollEffect({
    list: quirks_to_show,
    currentIndex: quirks_to_show.findIndex((q) => q.quirk.path === viewing),
    setter: (q) => {
      setViewing(q.quirk.path);
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
                {(query.length ? results : quirks_to_show).map(
                  ({ constantQuirk, quirk }) => {
                    return (
                      <QuirkTab
                        key={quirk.path}
                        context={context}
                        slot_names={slot_names}
                        constantQuirk={constantQuirk}
                        quirk={quirk}
                        viewing={viewing}
                        setViewing={setViewing}
                        quirks={quirks}
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
        {constantQuirks[viewing] ? (
          <QuirkDetailsView
            context={context}
            slot_names={slot_names}
            path={viewing}
            constantQuirk={constantQuirks[viewing]}
            quirk={quirks_to_show.find((q) => q.quirk.path === viewing)!.quirk}
            quirks={quirks}
          />
        ) : (
          <Section fill title="Not Selected">
            Select a quirk from the left pane.
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};

// Gives us data about whether or not this quirk is available
const isQuirkAvailable = (
  context: PopupQuirkContext,
  quirk: QuirkAvailability,
  quirks: Path[],
) => {
  const disabledData = {
    disabled: false,
    icon: 'x',
    color: 'bad',
    reason: '',
  };

  // gotta do +1 to translate into BYONDism
  const selectedInAnySlot = quirks.indexOf(quirk.path) + 1;
  const selectedInThisSlot = selectedInAnySlot === context.id;

  if (quirk.unavailable) {
    if (
      quirk.unavailable !== 'Can only be applied in a greater quirk slot.' ||
      context.id === 1
    ) {
      // If it's marked unavailable by the server, disable.
      disabledData.disabled = true;
      disabledData.reason = quirk.unavailable;
    }
  }

  if (selectedInThisSlot) {
    disabledData.color = 'good';
    disabledData.reason = 'This quirk is already selected in this slot.';
    disabledData.disabled = true;
    disabledData.icon = 'check';
  } else if (selectedInAnySlot) {
    disabledData.color = 'average';
    disabledData.reason = `This quirk is already selected in another slot.`;
    disabledData.disabled = true;
    disabledData.icon = 'check';
  }

  return disabledData;
};

const QuirkTab = (props: {
  context: PopupQuirkContext;
  slot_names: string[];
  constantQuirk: ConstantQuirk;
  quirk: QuirkAvailability;
  viewing: Path;
  setViewing: React.Dispatch<React.SetStateAction<Path>>;
  quirks: Path[];
}) => {
  const {
    context,
    slot_names,
    constantQuirk,
    quirk,
    viewing,
    setViewing,
    quirks,
  } = props;
  const { act } = usePopupBackend();
  const disabledData = isQuirkAvailable(context, quirk, quirks);

  return (
    <Tabs.Tab
      key={quirk.path}
      ml={1}
      id={`PreferencesMenuPopupVirtueSelectorTab_${quirk.path}`}
      selected={viewing === quirk.path}
      onClick={() => setViewing(quirk.path)}
      textColor={disabledData.reason ? disabledData.color : undefined}
      icon={constantQuirk.icon || ''}
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
                act('select_quirk', {
                  id: context.id,
                  quirk: quirk.path,
                });
              }}
            />
          )}
        </Box>
      }
    >
      {constantQuirk.name}
    </Tabs.Tab>
  );
};

type QuirkDetailsViewProps = {
  context: PopupQuirkContext;
  slot_names: string[];
  path: Path;
  constantQuirk: ConstantQuirk;
  quirk: QuirkAvailability;
  quirks: Path[];
};

const QuirkDetailsView = (props: QuirkDetailsViewProps) => {
  const { context, path, constantQuirk, quirk, quirks } = props;
  const { act } = usePopupBackend();
  const disabledData = isQuirkAvailable(context, quirk, quirks);

  return (
    <Section
      fill
      scrollable
      title={
        <Stack align="center">
          <Stack.Item>
            <Icon name={constantQuirk.icon || ''} />
          </Stack.Item>
          <Stack.Item grow>{constantQuirk.name}</Stack.Item>
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
              act('select_quirk', { id: context!.id, quirk: path });
            }}
          >
            Select this Quirk
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
      <QuirkDetails quirk={constantQuirk} />
    </Section>
  );
};
