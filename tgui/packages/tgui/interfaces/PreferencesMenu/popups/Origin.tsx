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
} from 'pm/popups';
import { useState } from 'react';
import { Button, Icon, Section, Stack, Tabs } from 'tgui-core/components';

/**
 * remember that origins are virtues and are therefore in {@link ConstantData.virtues}
 */
export type OriginPopupData = {
  virtue_origin: string;
  available_origins: Path[];
} & PopupData;

const PopupOriginSelector = (props) => {
  const [constantData] = useConstantPrefs();
  const { data } = usePopupBackend<OriginPopupData>();
  const { available_origins, popup_data_ready } = data;

  return (
    <PrefPopupGuard
      title="Selecting Origin"
      loadingScreenText="Origins Loading..."
      width="80vw"
      height="80vh"
      dependencies={[constantData, available_origins, popup_data_ready]}
    >
      <PopupOriginSelectorInner constantData={constantData!} />
    </PrefPopupGuard>
  );
};

// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    Origin: 'origin';
  }
}
registerPopup('Origin', 'origin', PopupOriginSelector);

const PopupOriginSelectorInner = (props: { constantData: ConstantData }) => {
  const { constantData } = props;
  const { data } = usePopupBackend<OriginPopupData>();
  const { virtues } = constantData;
  const { available_origins, virtue_origin } = data;

  available_origins.sort();

  const defaultPanel =
    Object.entries(virtues).find(([k, v]) => v.name === virtue_origin)?.[0] ||
    available_origins[0];
  const [viewing, setViewing] = useState(defaultPanel);

  available_origins.sort((a, b) =>
    virtues[a].name.localeCompare(virtues[b].name),
  );

  useKeyscrollEffect({
    list: available_origins,
    currentIndex: available_origins.indexOf(viewing),
    setter: (val) => setViewing(val),
  });

  return (
    <Stack fill>
      <Stack.Item>
        <Tabs vertical mt={0}>
          {available_origins.map((origin) => {
            const virt = virtues[origin];
            if (!virt) {
              return null;
            }

            return (
              <Tabs.Tab
                key={origin}
                ml={1}
                selected={viewing === origin}
                onClick={() => setViewing(origin)}
                leftSlot={virt.name}
                rightSlot={
                  virt.name === virtue_origin ? (
                    <Icon name="check" />
                  ) : (
                    // unnamed icon has the same size as a regular icon
                    // but no actual font image
                    <Icon name="" />
                  )
                }
              />
            );
          })}
        </Tabs>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item grow>
        {virtues[viewing] ? (
          <OriginDetails
            origin={viewing}
            virtue={virtues[viewing]}
            selected={virtues[viewing].name === virtue_origin}
          />
        ) : (
          <Section fill title="Not Selected">
            Select an origin from the left pane.
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};

type OriginDetailsProps = {
  origin: Path;
  virtue: ConstantVirtue;
  selected: boolean;
};

const OriginDetails = (props: OriginDetailsProps) => {
  const { origin, virtue, selected } = props;
  const { act } = usePopupBackend();

  return (
    <Section
      fill
      scrollable
      title={virtue.name}
      buttons={
        <Stack>
          <Stack.Divider />
          <Button
            disabled={selected}
            // we just wanna force the button not to be transparent,
            // actual color is not important
            color="justNotTransparent"
            onClick={() => act('select_origin', { origin })}
          >
            {selected ? 'Already Selected' : 'Select This Origin'}
          </Button>
        </Stack>
      }
    >
      <VirtueDetails virtue={virtue} />
    </Section>
  );
};
