import { LabeledListLikeTooltip, PrefPopupGuard } from 'pm/components';
import { type ConstantData, useConstantPrefs } from 'pm/constant_data';
import { type PopupData, registerPopup, usePopupBackend } from 'pm/popups';
import {
  Button,
  Icon,
  ImageButton,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { useFuzzySearch } from 'tgui-core/fuzzysearch';
/**
 * Character Selection
 */
export type PopupCombatMusicData = {
  combat_music: string | null;
} & PopupData;

const PopupCombatMusic = (props) => {
  const [constantData] = useConstantPrefs();
  const { data } = usePopupBackend<PopupCombatMusicData>();
  const { popup_data_ready } = data;

  return (
    <PrefPopupGuard
      title="Selecting Combat Music"
      disableScroll
      loadingScreenText="Combat Music Loading..."
      width="90vw"
      height="80vh"
      dependencies={[popup_data_ready, constantData]}
    >
      <PopupCombatMusicInner constantData={constantData!} />
    </PrefPopupGuard>
  );
};
// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    CombatMusic: 'combat_music';
  }
}
registerPopup('CombatMusic', 'combat_music', PopupCombatMusic);

const PopupCombatMusicInner = (props: { constantData: ConstantData }) => {
  const { constantData } = props;
  const { combat_music: constant_combat_music } = constantData;
  const { act, data } = usePopupBackend<PopupCombatMusicData>();
  const { combat_music } = data;

  const tracks = Object.values(constant_combat_music);
  const { query, setQuery, results } = useFuzzySearch({
    getSearchString: (s) => s.name + s.credits,
    searchArray: tracks,
  });

  return (
    <Stack fill vertical p={2}>
      <Stack.Item>
        <Input
          fluid
          placeholder="Search..."
          onChange={(v) => setQuery(v)}
          value={query}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical>
            {(query.length ? results : tracks).map((music) => (
              <Stack.Item key={music.name} height={6}>
                {/* Card / Preview Button split */}
                <Stack fill align="center">
                  {/* Card */}
                  <Stack.Item grow height="100%" minWidth={0}>
                    <ImageButton
                      fluid
                      imageSize={0}
                      className="PreferencesMenu__Button__FillContents"
                      selected={combat_music === music.name}
                      onClick={() =>
                        act('set_combat_music', { combat_music: music.type })
                      }
                    >
                      {/* Vertical Name + Credits / Description split */}
                      <Stack fill vertical align="space-between">
                        {/* Name + Credits */}
                        <Stack.Item grow>
                          {/* Name / Credits split */}
                          <Stack fill>
                            {/* Name */}
                            <Stack.Item
                              basis="25%"
                              fontSize={1.2}
                              textAlign="left"
                            >
                              {music.shortname ? (
                                music.name !== music.shortname ? (
                                  <LabeledListLikeTooltip tooltip={music.name}>
                                    {music.shortname}
                                  </LabeledListLikeTooltip>
                                ) : (
                                  music.shortname
                                )
                              ) : (
                                music.name
                              )}
                            </Stack.Item>
                            {/* Credits */}
                            <Stack.Item
                              grow
                              textAlign="right"
                              style={{ textWrap: 'wrap' }}
                            >
                              {music.credits || 'No credits specified'}
                            </Stack.Item>
                          </Stack>
                        </Stack.Item>
                        {/* Description */}
                        <Stack.Item textAlign="left">{music.desc}</Stack.Item>
                      </Stack>
                    </ImageButton>
                  </Stack.Item>
                  {/* Preview Button */}
                  <Stack.Item height="100%">
                    <Button
                      fluid
                      color="transparent"
                      className="PreferencesMenu__Button__FillContents"
                      tooltip="Preview this track in the chat audio player. It will keep playing outside of this menu!"
                      verticalAlign="middle"
                      onClick={() =>
                        act('preview_combat_music', {
                          combat_music: music.type,
                        })
                      }
                    >
                      <Stack align="center" justify="center" fill>
                        <Stack.Item>
                          <Icon size={2} name="volume-up" />
                        </Stack.Item>
                      </Stack>
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
