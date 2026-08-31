import { PrefPopupGuard } from 'pm/components';
import { type ConstantData, useConstantPrefs } from 'pm/constant_data';
import type { Path } from 'pm/data';
import { type PopupData, registerPopup, usePopupBackend } from 'pm/popups';
import { Box, Image, ImageButton, Stack } from 'tgui-core/components';
/**
 * Character Selection
 */
export type PopupTaurTypeData = {
  available: Path[];
  taur_type: Path;
} & PopupData;

const PopupTaurType = (props) => {
  const [constantData] = useConstantPrefs();
  const { data } = usePopupBackend<PopupTaurTypeData>();
  const { popup_data_ready } = data;

  return (
    <PrefPopupGuard
      title="Selecting Taur"
      loadingScreenText="Taurs Loading..."
      width="80vw"
      height="80vh"
      dependencies={[constantData, popup_data_ready]}
    >
      <PopupTaurTypeInner constantData={constantData!} />
    </PrefPopupGuard>
  );
};

// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    TaurType: 'taurtype';
  }
}
registerPopup('TaurType', 'taurtype', PopupTaurType);

export const PopupTaurTypeInner = (props: { constantData: ConstantData }) => {
  const { constantData } = props;
  const { act, data } = usePopupBackend<PopupTaurTypeData>();
  const { taur_types } = constantData;
  const { taur_type, available } = data;

  return (
    <Stack fill vertical m={2}>
      <Stack.Item>
        {/* this is weird because we want to make it look like the other
        popups */}
        <ImageButton
          fluid
          fallbackIcon="none"
          imageSize={0}
          selected={taur_type === null}
          onClick={() => {
            act('taur_type', { taur_type: null });
          }}
        >
          <Stack align="center" justify="space-around">
            <Stack.Item>
              <Box width={'128px'} height={'64px'} />
            </Stack.Item>
            <Stack.Item grow fontSize={1.2} textAlign="center">
              None
            </Stack.Item>
            <Stack.Item>
              <Box width={'128px'} height={'64px'} />
            </Stack.Item>
          </Stack>
        </ImageButton>
      </Stack.Item>
      {available.map((type) => {
        const taur = taur_types[type];
        return (
          <Stack.Item key={type}>
            <ImageButton
              fluid
              fallbackIcon="none"
              imageSize={0}
              selected={type === taur_type}
              onClick={() => {
                act('taur_type', { taur_type: type });
              }}
            >
              <Stack align="center" justify="space-around">
                <Stack.Item>
                  <Image
                    src={`${taur.icon}?state=${taur.taur_icon_state}&dir=2&movement=0&frame=0`}
                    width={'128px'}
                    height={'64px'}
                  />
                </Stack.Item>
                <Stack.Item grow fontSize={1.2} textAlign="center">
                  {taur.name}
                </Stack.Item>
                <Stack.Item>
                  <Image
                    src={`${taur.icon}?state=${taur.taur_icon_state}&dir=8&movement=0&frame=0`}
                    width={'128px'}
                    height={'64px'}
                  />
                </Stack.Item>
              </Stack>
            </ImageButton>
          </Stack.Item>
        );
      })}
    </Stack>
  );
};
