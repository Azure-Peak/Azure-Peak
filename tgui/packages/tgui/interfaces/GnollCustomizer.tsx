import { Box, Button, LabeledList, Section } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type GenitalEntry = {
  id: string;
  enabled: 0 | 1;
};

type DescriptorEntry = {
  slot: string;
  name: string;
  value: string | null;
};

type Data = {
  name: string;
  pelt: string;
  genitals: GenitalEntry[];
  descriptors: DescriptorEntry[];
  flavortext_len: number;
  ooc_notes_len: number;
  nsfwflavortext_len: number;
  erpprefs_len: number;
  headshot: string | null;
  song_url: string | null;
  song_title: string | null;
  song_artist: string | null;
  img_gallery_len: number;
  nsfw_img_gallery_len: number;
  age_verified: 0 | 1;
};

const capitalize = (text: string) =>
  text.charAt(0).toUpperCase() + text.slice(1);

const TextRow = (props: {
  label: string;
  len: number;
  setAction: string;
  clearAction: string;
}) => {
  const { act } = useBackend<Data>();
  const { label, len, setAction, clearAction } = props;
  return (
    <LabeledList.Item
      label={label}
      buttons={
        <>
          <Button color="transparent" onClick={() => act(setAction)}>
            {len ? 'Change' : 'Set'}
          </Button>
          {!!len && (
            <Button
              color="transparent"
              textColor="bad"
              onClick={() => act(clearAction)}
            >
              Clear
            </Button>
          )}
        </>
      }
    >
      {len ? (
        `${len} characters`
      ) : (
        <Box as="span" color="label" italic>
          none set — nothing is shown
        </Box>
      )}
    </LabeledList.Item>
  );
};

export const GnollCustomizer = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Window
      width={460}
      height={640}
      theme="parchment"
      title="Gnoll Customization"
    >
      <Window.Content scrollable>
        <Box textAlign="center" bold mb={1}>
          Choose your form to spread terror in the name of the GORESTAR!!
        </Box>
        <Section title="Form">
          <LabeledList>
            <LabeledList.Item
              label="Name"
              buttons={
                <>
                  <Button color="transparent" onClick={() => act('set_name')}>
                    Set Custom
                  </Button>
                  <Button
                    color="transparent"
                    onClick={() => act('random_name')}
                  >
                    Random
                  </Button>
                </>
              }
            >
              {data.name}
            </LabeledList.Item>
            <LabeledList.Item label="Pelt Pattern">
              <Button color="transparent" onClick={() => act('choose_pelt')}>
                {data.pelt}
              </Button>
            </LabeledList.Item>
            {data.descriptors.map((descriptor) => (
              <LabeledList.Item key={descriptor.slot} label={descriptor.name}>
                <Button
                  color="transparent"
                  onClick={() =>
                    act('choose_descriptor', { slot: descriptor.slot })
                  }
                >
                  {descriptor.value || 'Choose'}
                </Button>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
        <Section title="Genitals">
          {data.genitals.map((genital) => (
            <Button.Checkbox
              key={genital.id}
              checked={!!genital.enabled}
              onClick={() =>
                act('toggle_genital', {
                  genital: genital.id,
                  toggle: genital.enabled ? 'disable' : 'enable',
                })
              }
            >
              {capitalize(genital.id)}
            </Button.Checkbox>
          ))}
        </Section>
        <Section title="Flavor & OOC">
          <LabeledList>
            <TextRow
              label="Flavor Text"
              len={data.flavortext_len}
              setAction="set_flavortext"
              clearAction="clear_flavortext"
            />
            <TextRow
              label="OOC Notes"
              len={data.ooc_notes_len}
              setAction="set_ooc_notes"
              clearAction="clear_ooc_notes"
            />
          </LabeledList>
        </Section>
        <Section title="ERP">
          {data.age_verified ? (
            <LabeledList>
              <TextRow
                label="NSFW Flavortext"
                len={data.nsfwflavortext_len}
                setAction="set_nsfwflavortext"
                clearAction="clear_nsfwflavortext"
              />
              <TextRow
                label="ERP Preferences"
                len={data.erpprefs_len}
                setAction="set_erpprefs"
                clearAction="clear_erpprefs"
              />
            </LabeledList>
          ) : (
            <Box color="label" italic>
              Age vetting is required to set NSFW flavortext and ERP
              preferences.
            </Box>
          )}
        </Section>
        <Section title="Media">
          {data.age_verified ? (
            <LabeledList>
              <LabeledList.Item
                label="Song"
                buttons={
                  <>
                    <Button
                      color="transparent"
                      onClick={() => act('set_song_url')}
                    >
                      URL
                    </Button>
                    <Button
                      color="transparent"
                      onClick={() => act('set_song_title')}
                    >
                      Title
                    </Button>
                    <Button
                      color="transparent"
                      onClick={() => act('set_song_artist')}
                    >
                      Artist
                    </Button>
                  </>
                }
              >
                {data.song_title || data.song_url ? (
                  <Box as="span" italic>
                    {data.song_title || 'Untitled'}
                    {data.song_artist ? ` by ${data.song_artist}` : ''}
                  </Box>
                ) : (
                  <Box as="span" color="label" italic>
                    none set
                  </Box>
                )}
              </LabeledList.Item>
              <LabeledList.Item
                label="Headshot"
                buttons={
                  <Button
                    color="transparent"
                    onClick={() => act('set_headshot')}
                  >
                    {data.headshot ? 'Change' : 'Set'}
                  </Button>
                }
              >
                {data.headshot ? (
                  <Box
                    as="img"
                    src={data.headshot}
                    width="96px"
                    height="96px"
                  />
                ) : (
                  <Box as="span" color="label" italic>
                    none set
                  </Box>
                )}
              </LabeledList.Item>
              <LabeledList.Item
                label="Gallery"
                buttons={
                  <>
                    <Button
                      color="transparent"
                      onClick={() => act('img_gallery_add')}
                    >
                      Add
                    </Button>
                    <Button
                      color="transparent"
                      textColor="bad"
                      onClick={() => act('img_gallery_clear')}
                    >
                      Clear
                    </Button>
                  </>
                }
              >
                {data.img_gallery_len}/6 images
              </LabeledList.Item>
              <LabeledList.Item
                label="NSFW Gallery"
                buttons={
                  <>
                    <Button
                      color="transparent"
                      onClick={() => act('nsfw_img_gallery_add')}
                    >
                      Add
                    </Button>
                    <Button
                      color="transparent"
                      textColor="bad"
                      onClick={() => act('nsfw_img_gallery_clear')}
                    >
                      Clear
                    </Button>
                  </>
                }
              >
                {data.nsfw_img_gallery_len}/6 images
              </LabeledList.Item>
            </LabeledList>
          ) : (
            <Box color="label" italic>
              Age vetting is required to set the song, headshot and galleries.
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
