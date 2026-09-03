import { groupBy, sortBy } from 'es-toolkit';
import { LabeledGridList, PrefPopupGuard, TabCollapsible } from 'pm/components';
import {
  type ConstantData,
  type ConstantFaith,
  type ConstantPatron,
  useConstantPrefs,
} from 'pm/constant_data';
import type { Path } from 'pm/data';
import {
  type PopupData,
  registerPopup,
  useKeyscrollEffect,
  usePopupBackend,
} from 'pm/popups';
import { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

export type PopupPatronSelectData = {
  selected_patron: Path;
} & PopupData;

const PopupPatronSelect = (props) => {
  const [constantData] = useConstantPrefs();
  const { data } = usePopupBackend<PopupPatronSelectData>();
  const { popup_data_ready } = data;

  return (
    <PrefPopupGuard
      title="Selecting Patron"
      loadingScreenText="Patrons Loading..."
      width="80vw"
      height="80vh"
      dependencies={[constantData, popup_data_ready]}
    >
      <PopupPatronSelectInner constantData={constantData!} />
    </PrefPopupGuard>
  );
};

// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    PatronSelect: 'patron_select';
  }
}
registerPopup('PatronSelect', 'patron_select', PopupPatronSelect);

type EnhancedPatron = ConstantPatron & {
  type: Path;
};

type EnhancedFaith = ConstantFaith & {
  type: Path;
};

const getGodheadIcon = (patron: ConstantPatron) => {
  switch (patron.name) {
    case 'Psydon':
      return '\u16C9';
    case 'Astrata':
      return '\u16BC';
    case 'Zizo':
      return '\u16E3';
    default:
      return '?';
  }
};

const PopupPatronSelectInner = (props: { constantData: ConstantData }) => {
  const { constantData } = props;
  const { data } = usePopupBackend<PopupPatronSelectData>();
  const { faiths, patrons } = constantData;
  const { selected_patron } = data;
  const [viewing, setViewing] = useState(selected_patron);

  // Transform { [type]: ConstantPatron } to { type: [type], ...ConstantPatron }
  const enhancedPatrons: EnhancedPatron[] = Object.entries(patrons).map(
    ([k, v]) => ({
      type: k,
      ...v,
    }),
  );
  // Transform { associated_faith: Path, ...enhancedPatron }[] to { [associated_faith]: ...enhancedPatron[] }
  const patronsByFaith = Object.fromEntries(
    Object.entries(groupBy(enhancedPatrons, (p) => p.associated_faith)).map(
      ([f, v]) => [
        f,
        sortBy(v, [
          // If they're the head of this faith, they go at the top
          (vS) => (faiths[f].godhead === vS.type ? 0 : 1),
          // otherwise sort alphabetically
          'name',
        ]),
      ],
    ),
  );
  // Transform { [associated_faith]: ...enhancedPatron } into [{ type: associated_faith, ...faiths[associated_faith] }, ...]
  const enhancedFaiths: EnhancedFaith[] = Object.keys(patronsByFaith).map(
    (f) => ({
      type: f,
      ...faiths[f],
    }),
  );
  // Finally, just for keyboard scrolling, get a flat list of patrons in the vertical layout order
  const flatPatronList = enhancedFaiths.flatMap((f) =>
    patronsByFaith[f.type].map((v) => v.type),
  );

  useKeyscrollEffect({
    list: flatPatronList,
    currentIndex: flatPatronList.indexOf(viewing),
    setter: (v) => setViewing(v),
  });

  useEffect(() => {
    document
      .getElementById(`PreferencesMenuPopupPatronSelectorTab_${viewing}`)
      ?.scrollIntoView({ behavior: 'smooth', block: 'center' });
  }, [viewing]);

  return (
    <Stack fill>
      <Stack.Item basis="25%">
        <Section fill scrollable>
          <Tabs vertical>
            {enhancedFaiths.map((faith) => (
              <TabCollapsible
                key={faith.type}
                title={faith.name}
                className={classes([
                  'PreferencesMenu__PatronSelection',
                  faith.name,
                ])}
                forceOpen={
                  patronsByFaith[faith.type].find((p) => p.type === viewing)
                    ? true
                    : undefined
                }
                startOpen={
                  // this is just polish, it makes it so that you can see
                  // the tab that opens by default
                  !!patronsByFaith[faith.type].find(
                    (p) => p.type === selected_patron,
                  )
                }
              >
                {patronsByFaith[faith.type].map((patron) => (
                  <Tabs.Tab
                    key={patron.name}
                    ml={2}
                    className={classes([
                      'PreferencesMenu__PatronSelection',
                      faith.name,
                    ])}
                    id={`PreferencesMenuPopupPatronSelectorTab_${patron.type}`}
                    leftSlot={
                      <Stack align="center" justify="center">
                        {faith.godhead === patron.type ? (
                          <Tooltip content="This patron is considered the head of their faith.">
                            <Stack.Item fontSize={1.2}>
                              {getGodheadIcon(patron)}
                            </Stack.Item>
                          </Tooltip>
                        ) : null}
                      </Stack>
                    }
                    rightSlot={
                      <Stack align="center" justify="center">
                        {selected_patron === patron.type ? (
                          <Stack.Item>
                            <Icon name="check" />
                          </Stack.Item>
                        ) : undefined}
                      </Stack>
                    }
                    selected={patron.type === viewing}
                    onClick={() => setViewing(patron.type)}
                  >
                    {patron.name}
                  </Tabs.Tab>
                ))}
              </TabCollapsible>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <RightPane
          faiths={enhancedFaiths}
          patrons={enhancedPatrons}
          selected_patron={selected_patron}
          viewing={viewing}
        />
      </Stack.Item>
    </Stack>
  );
};

const RightPane = (props: {
  faiths: EnhancedFaith[];
  patrons: EnhancedPatron[];
  selected_patron: Path;
  viewing: Path;
}) => {
  const { faiths, patrons, selected_patron, viewing } = props;
  const { act } = usePopupBackend();
  const patron = patrons.find((p) => p.type === viewing);
  if (!patron) {
    return (
      <Stack fill vertical justify="stretch">
        Invalid patron: {viewing}
      </Stack>
    );
  }
  const faith = faiths.find((f) => f.type === patron.associated_faith);
  if (!faith) {
    return (
      <Stack fill vertical justify="stretch">
        Invalid patron (no associated faith): {viewing}
      </Stack>
    );
  }
  const godhead = patrons.find((p) => p.type === faith.godhead);

  return (
    <Stack fill vertical justify="stretch">
      <Stack.Item maxHeight="40%">
        <Section
          scrollable
          title={faith.name}
          className={classes([
            'PreferencesMenu__Section',
            'PreferencesMenu__Section__MaxHeight',
            'PreferencesMenu__PatronSelection',
            faith.name,
          ])}
        >
          <LabeledGridList>
            <LabeledGridList.Item label="Head Patron">
              {godhead?.name || 'None'}
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Likely Worshippers">
              {faith.worshippers}
            </LabeledGridList.Item>
            <LabeledGridList.Item>
              <Box dangerouslySetInnerHTML={{ __html: faith.desc }} />
            </LabeledGridList.Item>
          </LabeledGridList>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          className={classes(['PreferencesMenu__PatronSelection', faith.name])}
          title={
            <Stack align="center">
              {faith.godhead === patron.type ? (
                <Tooltip content="This patron is considered the head of their faith.">
                  <Stack.Item fontSize={1.2}>
                    {getGodheadIcon(patron)}
                  </Stack.Item>
                </Tooltip>
              ) : undefined}
              <Stack.Item>{patron.name}</Stack.Item>
            </Stack>
          }
          buttons={
            <Stack>
              <Stack.Divider />
              <Stack.Item>
                <Button
                  disabled={selected_patron === patron.type}
                  onClick={() => act('set_patron', { patron: patron.type })}
                >
                  {selected_patron === patron.type ? 'Selected!' : 'Select'}
                </Button>
              </Stack.Item>
            </Stack>
          }
        >
          <LabeledGridList>
            <LabeledGridList.Item label="Domain">
              {patron.domain}
            </LabeledGridList.Item>
            <LabeledGridList.Item label="Likely Worshippers">
              {patron.worshippers}
            </LabeledGridList.Item>
            <LabeledGridList.Item>
              <Box dangerouslySetInnerHTML={{ __html: patron.desc }} />
            </LabeledGridList.Item>
          </LabeledGridList>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
