import { type ReactNode, useEffect, useState } from 'react';
import {
  Box,
  Button,
  ByondUi,
  Divider,
  Input,
  Modal,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type VirtueData = {
  name: string;
  picked: { name: string; index: number; has_tooltip: BooleanLike }[];
  can_pick_more: BooleanLike;
  next_cost: number;
  tri_cost: number;
};

type FlawData = {
  name: string;
  index: number;
  warning: BooleanLike;
};

type JobEntry = {
  title: string;
  name: string;
  divider: BooleanLike;
  tutorial: string;
  slots: number;
  rcp: number;
  has_info: BooleanLike;
  locked: string | null;
  lock_color: string | null;
  bancheck: BooleanLike;
  level?: string;
  level_color?: string;
  upper?: number;
  lower?: number;
};

type JobsData = {
  joblessrole: string;
  lastclass: string | null;
  job_change_locked: BooleanLike;
  list: JobEntry[];
};

type VillainRole = {
  name: string;
  key: string;
  state: 'toggle' | 'banned' | 'days';
  enabled: BooleanLike;
  days?: number;
};

type VillainsData = {
  banned_all: BooleanLike;
  roles: VillainRole[];
  storyteller: BooleanLike;
  lich_headshot: string | null;
  vampire_headshot: string | null;
  vampire_skin: string | null;
  vampire_eyes: string | null;
  vampire_hair: string | null;
  vampire_ears: string | null;
  qsr: BooleanLike;
  bounty_enabled: BooleanLike;
  bounty_poster: string;
  bounty_severity: string;
  bounty_severity_b: string;
  bounty_severity_v: string;
  bounty_crime: string;
};

type SettingsData = {
  tgui_theme: string;
  parchment_skin: string;
  statbrowser_theme: string;
  ambientocclusion: BooleanLike;
  windowflashing: BooleanLike;
  clientfps: number;
  auto_fit_viewport: BooleanLike;
  show_widescreen: BooleanLike;
  widescreen: string;
  schizo_voice: BooleanLike;
};

type OocData = {
  can_change_color: BooleanLike;
  ooccolor: string;
  is_admin: BooleanLike;
  adminhelp_sounds?: BooleanLike;
  prayer_sounds?: BooleanLike;
  announce_login?: BooleanLike;
  combohud_lighting?: BooleanLike;
  show_dead_chat?: BooleanLike;
  show_radio?: BooleanLike;
  show_prayers?: BooleanLike;
  asay_color_allowed?: BooleanLike;
  asaycolor?: string;
  deadmin_forced?: BooleanLike;
  deadmin_always?: BooleanLike;
  deadmin_antag_forced?: BooleanLike;
  deadmin_antag?: BooleanLike;
  deadmin_head_forced?: BooleanLike;
  deadmin_head?: BooleanLike;
};

type KeybindEntry = {
  name: string;
  full_name: string;
  keys: string[];
  can_add: BooleanLike;
  defaults: string;
};

type KeybindCategory = {
  name: string;
  binds: KeybindEntry[];
};

type Data = {
  pq: string;
  triumphs: number;
  triumph_buys_enabled: BooleanLike;
  age_verified: BooleanLike;
  appearance_banned: BooleanLike;
  name_banned: BooleanLike;
  species_invalid: BooleanLike;
  quirks_enabled: BooleanLike;
  quirks: string[];
  real_name: string;
  nickname: string;
  pronouns: string;
  titles_pref: string;
  clothes_pref: string;
  species_name: string;
  subspecies_name: string;
  origin: string;
  age: string;
  statpack: string;
  statpack_virtuous: BooleanLike;
  extra_language: string;
  has_race_bonus: BooleanLike;
  race_bonus: string;
  agender_species: BooleanLike;
  body_type: string;
  show_random_body: BooleanLike;
  random_gender: BooleanLike;
  random_gender_antag: BooleanLike;
  taur_allowed: BooleanLike;
  taur_name?: string;
  taur_color?: string;
  virtue: VirtueData | null;
  virtuetwo: VirtueData | null;
  charflaws: FlawData[];
  can_add_vice: BooleanLike;
  has_averse: BooleanLike;
  averse_faction: string;
  faith: string;
  patron: string;
  domhand: string;
  combat_music: string;
  dnr: BooleanLike;
  voice_type: string;
  voice_pack: string;
  voice_pitch: number;
  bark_name: string;
  bark_speed: number;
  bark_pitch: number;
  bark_variance: number;
  update_mutant_colors: BooleanLike;
  use_skintones: BooleanLike;
  skin_tone_wording: string;
  mutcolors: BooleanLike;
  mcolor: string;
  mcolor2: string;
  mcolor3: string;
  body_size: number;
  headshot: string | null;
  examine_theme: string;
  flavortext_short: BooleanLike;
  ooc_notes_short: BooleanLike;
  preview_map: string;
  is_guest: BooleanLike;
  is_new_player: BooleanLike;
  pregame?: BooleanLike;
  ready?: number;
  is_migrant?: BooleanLike;
  jobs: JobsData;
  villains: VillainsData;
  settings: SettingsData;
  ooc: OocData;
  keybinds: KeybindCategory[];
};

type TabName =
  | 'character'
  | 'flavor'
  | 'classes'
  | 'villains'
  | 'settings'
  | 'ooc'
  | 'keybinds';

const PLAYER_NOT_READY = 0;
const PLAYER_READY_TO_PLAY = 1;

/** Screen px per world px for the doll preview: fills the ~263px control with
 * the 64px-wide doll grid, scaled for high-DPI displays. */
const PREVIEW_ZOOM = Math.max(
  2,
  Math.floor((263 * (window.devicePixelRatio || 1)) / 64),
);

/** A labeled row whose value is a clickable link to the legacy input prompt. */
const PrefRow = (props: {
  label: string;
  value: string | number;
  pref: string;
  task?: string;
  color?: string;
  extra?: ReactNode;
}) => {
  const { act } = useBackend<Data>();
  const { label, value, pref, task = 'input', color, extra } = props;
  return (
    <Stack align="center">
      <Stack.Item width="105px" color="label">
        {label}
      </Stack.Item>
      <Stack.Item grow>
        <Button
          color="transparent"
          textColor={color}
          onClick={() => act('link', { preference: pref, task })}
        >
          {value}
        </Button>
        {extra}
      </Stack.Item>
    </Stack>
  );
};

/** A full-width transparent action button used in the Flavor & OOC groups. */
const LinkButton = (props: {
  pref: string;
  label: string;
  task?: string;
  bad?: boolean;
}) => {
  const { act } = useBackend<Data>();
  const { pref, label, task = 'input', bad } = props;
  return (
    <Box>
      <Button
        color="transparent"
        textColor={bad ? 'bad' : undefined}
        onClick={() => act('link', { preference: pref, task })}
      >
        {label}
      </Button>
    </Box>
  );
};

const Swatch = (props: { color: string }) => (
  <Box
    inline
    width="18px"
    height="11px"
    verticalAlign="middle"
    mr={1}
    style={{
      backgroundColor: `#${props.color}`,
      border: '1px solid #000',
    }}
  />
);

const VirtuePanel = (props: {
  virtue: VirtueData;
  pref: string;
  subPref: string;
}) => {
  const { act } = useBackend<Data>();
  const { virtue, pref, subPref } = props;
  return (
    <>
      <Box>
        <Button
          color="transparent"
          textColor="gold"
          bold
          onClick={() => act('link', { preference: pref, task: 'input' })}
        >
          {virtue.name}
        </Button>
        {virtue.tri_cost > 0 && (
          <Box inline color="label">
            ({virtue.tri_cost} TRI)
          </Box>
        )}
      </Box>
      {virtue.picked.map((choice) => (
        <Box key={choice.index} ml={1}>
          <Button
            color="transparent"
            italic
            onClick={() =>
              act('link', {
                preference: subPref,
                task: 'remove',
                index: choice.index,
              })
            }
          >
            {choice.name}
          </Button>
          {!!choice.has_tooltip && (
            <Button
              color="transparent"
              onClick={() =>
                act('link', {
                  preference: subPref,
                  task: 'tooltip',
                  tooltip: choice.name,
                })
              }
            >
              (?)
            </Button>
          )}
        </Box>
      ))}
      {!!virtue.can_pick_more && (
        <Box ml={1}>
          <Button
            color="transparent"
            textColor={virtue.next_cost <= 0 ? 'gold' : undefined}
            onClick={() => act('link', { preference: subPref, task: 'input' })}
          >
            + Pick Bonus
            {virtue.next_cost > 0 ? ` (${virtue.next_cost} TRI)` : ''}
          </Button>
        </Box>
      )}
    </>
  );
};

const ClassesTab = (props) => {
  const { act, data } = useBackend<Data>();
  const jobs = data.jobs;
  return (
    <Section
      fill
      scrollable
      title="Class Selection"
      buttons={
        <>
          {!!jobs.lastclass && (
            <Button
              color="gold"
              onClick={() =>
                act('link', { preference: 'job', task: 'triumphthing' })
              }
            >
              PLAY AS {jobs.lastclass} AGAIN
            </Button>
          )}
          <Button
            onClick={() => act('link', { preference: 'job', task: 'reset' })}
          >
            Reset
          </Button>
        </>
      }
    >
      <Box mb={1}>
        <Box inline color="label" mr={1}>
          If Role Unavailable:
        </Box>
        <Button
          color="purple"
          onClick={() => act('link', { preference: 'job', task: 'nojob' })}
        >
          {jobs.joblessrole}
        </Button>
        <Box inline color="label" ml={2} italic>
          Click a class to cycle its preference; right-click lowers it. Hover
          for details.
        </Box>
      </Box>
      <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '2px 12px' }}>
        {jobs.list.map((job) => (
          <div key={job.title} style={{ display: 'contents' }}>
            {!!job.divider && (
              <Box style={{ flexBasis: '100%' }}>
                <Divider />
              </Box>
            )}
            <Box width="300px">
              <Stack align="center">
                <Stack.Item grow>
                  <Button
                    color="transparent"
                    tooltip={`${job.tutorial || ''}\nSlots: ${job.slots}${job.rcp ? ` RCP: +${job.rcp}` : ''}`}
                    onClick={() =>
                      job.has_info
                        ? act('job_info', { title: job.title })
                        : undefined
                    }
                  >
                    {job.name}
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  {job.locked ? (
                    job.bancheck ? (
                      <Button
                        color="bad"
                        onClick={() => act('link', { bancheck: job.title })}
                      >
                        BANNED
                      </Button>
                    ) : (
                      <Box color={job.lock_color || 'grey'}>{job.locked}</Box>
                    )
                  ) : (
                    <Button
                      color="transparent"
                      textColor={job.level_color}
                      bold
                      disabled={!!jobs.job_change_locked}
                      onClick={() =>
                        act('link', {
                          preference: 'job',
                          task: 'setJobLevel',
                          level: job.upper,
                          text: job.title,
                        })
                      }
                      onContextMenu={(e) => {
                        e.preventDefault();
                        act('link', {
                          preference: 'job',
                          task: 'setJobLevel',
                          level: job.lower,
                          text: job.title,
                        });
                      }}
                    >
                      {job.level}
                    </Button>
                  )}
                </Stack.Item>
              </Stack>
            </Box>
          </div>
        ))}
      </Box>
    </Section>
  );
};

const ColorRow = (props: {
  label: string;
  color: string | null;
  pref: string;
  clearPref?: string;
}) => {
  const { act } = useBackend<Data>();
  const { label, color, pref, clearPref } = props;
  return (
    <Stack align="center">
      <Stack.Item width="140px" color="label">
        {label}
      </Stack.Item>
      <Stack.Item>
        {color !== null && color !== undefined ? (
          <>
            <Swatch color={color.replace('#', '')} />
            <Button
              color="transparent"
              onClick={() => act('link', { preference: pref, task: 'input' })}
            >
              Change
            </Button>
            {clearPref && (
              <Button
                color="transparent"
                onClick={() =>
                  act('link', { preference: clearPref, task: 'input' })
                }
              >
                clear
              </Button>
            )}
          </>
        ) : (
          <Button
            color="transparent"
            onClick={() => act('link', { preference: pref, task: 'input' })}
          >
            (C)
          </Button>
        )}
      </Stack.Item>
    </Stack>
  );
};

const VillainsTab = (props) => {
  const { act, data } = useBackend<Data>();
  const v = data.villains;
  if (v.banned_all) {
    return (
      <Section fill title="Special Roles">
        <Box color="bad" bold>
          I am banned from antagonist roles.
        </Box>
      </Section>
    );
  }
  return (
    <Stack fill>
      <Stack.Item grow basis={0}>
        <Section fill scrollable title="Special Roles">
          {v.roles.map((role) => (
            <Stack key={role.key} align="center">
              <Stack.Item grow color="label">
                {role.name}
              </Stack.Item>
              <Stack.Item>
                {role.state === 'banned' && (
                  <Button
                    color="bad"
                    onClick={() => act('link', { bancheck: role.key })}
                  >
                    BANNED
                  </Button>
                )}
                {role.state === 'days' && (
                  <Box color="bad">[IN {role.days} DAYS]</Box>
                )}
                {role.state === 'toggle' && (
                  <Button
                    selected={!!role.enabled}
                    onClick={() =>
                      act('link', {
                        preference: 'antag',
                        task: 'be_special',
                        be_special_type: role.key,
                      })
                    }
                  >
                    {role.enabled ? 'Enabled' : 'Disabled'}
                  </Button>
                )}
              </Stack.Item>
            </Stack>
          ))}
          <Divider />
          <Stack align="center">
            <Stack.Item grow color="label">
              Storyteller Events
            </Stack.Item>
            <Stack.Item>
              <Button
                selected={!!v.storyteller}
                onClick={() => act('link', { preference: 'storyteller' })}
              >
                {v.storyteller ? 'Enabled' : 'Disabled'}
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow basis={0}>
        <Stack fill vertical>
          <Stack.Item grow basis={0}>
            <Section fill scrollable title="Villain Appearance">
              <Stack align="center">
                <Stack.Item width="140px" color="label">
                  Gnoll Form
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="transparent"
                    onClick={() =>
                      act('link', { preference: 'gnoll_prefs', task: 'input' })
                    }
                  >
                    Customize
                  </Button>
                </Stack.Item>
              </Stack>
              <Stack align="center">
                <Stack.Item width="140px" color="label">
                  Lich Headshot
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="transparent"
                    onClick={() =>
                      act('link', {
                        preference: 'lich_headshot',
                        task: 'input',
                      })
                    }
                  >
                    {v.lich_headshot ? 'Change' : 'Set'}
                  </Button>
                </Stack.Item>
              </Stack>
              <Stack align="center">
                <Stack.Item width="140px" color="label">
                  Vampire Headshot
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="transparent"
                    onClick={() =>
                      act('link', {
                        preference: 'vampire_headshot',
                        task: 'input',
                      })
                    }
                  >
                    {v.vampire_headshot ? 'Change' : 'Set'}
                  </Button>
                </Stack.Item>
              </Stack>
              <ColorRow
                label="Vampire Skin"
                color={v.vampire_skin}
                pref="vampire_skin"
                clearPref="vampire_skin_clear"
              />
              <ColorRow
                label="Vampire Eyes"
                color={v.vampire_eyes}
                pref="vampire_eyes"
                clearPref="vampire_eyes_clear"
              />
              <ColorRow
                label="Vampire Hair"
                color={v.vampire_hair}
                pref="vampire_hair"
                clearPref="vampire_hair_clear"
              />
              <ColorRow
                label="Vampire Ears"
                color={v.vampire_ears}
                pref="vampire_ears"
                clearPref="vampire_ears_clear"
              />
              <Stack align="center">
                <Stack.Item width="140px" color="label">
                  Quicksilver Resistant
                </Stack.Item>
                <Stack.Item>
                  <Button
                    color="transparent"
                    onClick={() =>
                      act('link', { preference: 'qsr', task: 'input' })
                    }
                  >
                    {v.qsr ? 'Yes' : 'No'}
                  </Button>
                </Stack.Item>
              </Stack>
              <Box mt={1} color="label" italic>
                Antag appearances update when this window is refreshed.
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <Section fill scrollable title="Preset Bounty">
              <Stack align="center">
                <Stack.Item width="140px" color="label">
                  Preset Bounty
                </Stack.Item>
                <Stack.Item>
                  <Button
                    selected={!!v.bounty_enabled}
                    onClick={() =>
                      act('link', {
                        preference: 'preset_bounty_toggle',
                        task: 'input',
                      })
                    }
                  >
                    {v.bounty_enabled ? 'Enabled' : 'Disabled'}
                  </Button>
                </Stack.Item>
              </Stack>
              {!!v.bounty_enabled && (
                <>
                  <PrefRow
                    label="Bounty Poster"
                    value={v.bounty_poster}
                    pref="preset_bounty_poster_key"
                  />
                  <PrefRow
                    label="Severity"
                    value={v.bounty_severity}
                    pref="preset_bounty_severity_key"
                  />
                  <PrefRow
                    label="Severity (Bandit)"
                    value={v.bounty_severity_b}
                    pref="preset_bounty_severity_b_key"
                  />
                  <PrefRow
                    label="Severity (Vagabond)"
                    value={v.bounty_severity_v}
                    pref="preset_bounty_severity_v_key"
                  />
                  <PrefRow
                    label="Crime"
                    value={v.bounty_crime}
                    pref="preset_bounty_crime"
                  />
                </>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const SettingsTab = (props) => {
  const { act, data } = useBackend<Data>();
  const s = data.settings;
  return (
    <Stack fill>
      <Stack.Item grow basis={0}>
        <Section fill scrollable title="Display">
          <PrefRow
            label="TGUI Theme"
            value={s.tgui_theme}
            pref="tgui_theme"
            task=""
          />
          <PrefRow
            label="Parchment"
            value={s.parchment_skin}
            pref="parchment_skin"
            task=""
          />
          <PrefRow
            label="Panel Theme"
            value={s.statbrowser_theme}
            pref="statbrowser_theme"
            task=""
          />
          <PrefRow
            label="Ambient Occl."
            value={s.ambientocclusion ? 'Enabled' : 'Disabled'}
            pref="ambientocclusion"
            task=""
          />
          <PrefRow
            label="Win. Flashing"
            value={s.windowflashing ? 'Enabled' : 'Disabled'}
            pref="winflash"
            task=""
          />
          <PrefRow label="FPS" value={s.clientfps} pref="clientfps" />
          <PrefRow
            label="Fit Viewport"
            value={s.auto_fit_viewport ? 'Auto' : 'Manual'}
            pref="auto_fit_viewport"
            task=""
          />
          {!!s.show_widescreen && (
            <PrefRow
              label="Widescreen"
              value={s.widescreen}
              pref="widescreenpref"
              task=""
            />
          )}
        </Section>
      </Stack.Item>
      <Stack.Item grow basis={0}>
        <Section fill scrollable title="Other">
          <PrefRow
            label="Be Voice"
            value={s.schizo_voice ? 'Enabled' : 'Disabled'}
            pref="schizo_voice"
            task=""
          />
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const AdminToggle = (props: {
  label: string;
  value: BooleanLike | undefined;
  on: string;
  off: string;
  pref: string;
  forced?: BooleanLike;
}) => {
  const { act } = useBackend<Data>();
  const { label, value, on, off, pref, forced } = props;
  return (
    <Stack align="center">
      <Stack.Item width="160px" color="label">
        {label}
      </Stack.Item>
      <Stack.Item>
        {forced ? (
          <Box color="bad" bold>
            FORCED
          </Box>
        ) : (
          <Button
            color="transparent"
            onClick={() => act('link', { preference: pref })}
          >
            {value ? on : off}
          </Button>
        )}
      </Stack.Item>
    </Stack>
  );
};

const FlavorTab = (props) => {
  const { act, data } = useBackend<Data>();
  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          title="Flavor & OOC"
          buttons={
            <Button
              color="transparent"
              tooltip="Formatting help"
              onClick={() =>
                act('link', { preference: 'formathelp', task: 'input' })
              }
            >
              (?)
            </Button>
          }
        >
          <Stack>
            <Stack.Item grow basis={0}>
              <Box color="label" bold mb={0.5}>
                Description
              </Box>
              <LinkButton
                pref="flavortext"
                bad={!!data.flavortext_short}
                label={`Flavortext${data.flavortext_short ? ' (too short)' : ''}`}
              />
              <LinkButton
                pref="ooc_notes"
                bad={!!data.ooc_notes_short}
                label={`OOC Notes${data.ooc_notes_short ? ' (too short)' : ''}`}
              />
            </Stack.Item>
            <Stack.Item grow basis={0}>
              <Box color="label" bold mb={0.5}>
                Rumours & Gossip
              </Box>
              <LinkButton pref="rumour" label="Set Rumours" />
              <LinkButton pref="gossip" label="Set Noble Gossip" />
              <LinkButton pref="rumour_preview" label="Preview Rumours" />
              <LinkButton pref="ooc_preview" label="Preview Examine" />
            </Stack.Item>
            <Stack.Item grow basis={0}>
              <Box color="label" bold mb={0.5}>
                Media
              </Box>
              <LinkButton pref="headshot" label="Headshot" />
              <LinkButton pref="img_gallery" label="Add Gallery Image" />
              <LinkButton pref="ooc_extra" label="Character Song" />
            </Stack.Item>
            <Stack.Item grow basis={0}>
              <Box color="label" bold mb={0.5}>
                Display
              </Box>
              <LinkButton
                pref="examine_theme"
                label={`Examine Theme: ${data.examine_theme}`}
              />
              <LinkButton pref="change_title" label="Song Title" />
              <LinkButton pref="change_artist" label="Song Artist" />
              <LinkButton pref="clear_gallery" label="Clear Gallery" />
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      {/* ERP — NSFW settings kept apart from the SFW ones, and locked behind age verification */}
      <Stack.Item grow>
        <Section fill scrollable title="ERP">
          {data.age_verified ? (
            <Stack>
              <Stack.Item grow basis={0}>
                <Box color="label" bold mb={0.5}>
                  Description
                </Box>
                <LinkButton pref="nsfwflavortext" label="NSFW Flavortext" />
                <LinkButton pref="erpprefs" label="ERP Preferences" />
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Box color="label" bold mb={0.5}>
                  Media
                </Box>
                <LinkButton pref="nsfw_img_gallery" label="Add NSFW Image" />
                <LinkButton
                  pref="clear_nsfw_gallery"
                  label="Clear NSFW Gallery"
                />
              </Stack.Item>
              <Stack.Item grow basis={0} />
              <Stack.Item grow basis={0} />
            </Stack>
          ) : (
            <Box color="label" italic>
              Age verification is required to set NSFW flavortext, ERP
              preferences and the NSFW gallery.{' '}
              <Button
                color="transparent"
                onClick={() => act('link', { preference: 'agevet' })}
              >
                Get verified
              </Button>
            </Box>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const OocTab = (props) => {
  const { act, data } = useBackend<Data>();
  const o = data.ooc;
  return (
    <Stack fill>
      <Stack.Item grow basis={0}>
        <Section fill title="OOC Settings">
          {o.can_change_color ? (
            <Stack align="center">
              <Stack.Item width="160px" color="label">
                OOC Color
              </Stack.Item>
              <Stack.Item>
                <Swatch color={(o.ooccolor || '').replace('#', '')} />
                <Button
                  color="transparent"
                  onClick={() =>
                    act('link', { preference: 'ooccolor', task: 'input' })
                  }
                >
                  Change
                </Button>
              </Stack.Item>
            </Stack>
          ) : (
            <Box color="label" italic>
              No OOC settings available.
            </Box>
          )}
        </Section>
      </Stack.Item>
      {!!o.is_admin && (
        <Stack.Item grow basis={0}>
          <Section fill scrollable title="Admin Settings">
            <AdminToggle
              label="Adminhelp Sounds"
              value={o.adminhelp_sounds}
              on="Enabled"
              off="Disabled"
              pref="hear_adminhelps"
            />
            <AdminToggle
              label="Prayer Sounds"
              value={o.prayer_sounds}
              on="Enabled"
              off="Disabled"
              pref="hear_prayers"
            />
            <AdminToggle
              label="Announce Login"
              value={o.announce_login}
              on="Enabled"
              off="Disabled"
              pref="announce_login"
            />
            <AdminToggle
              label="Combo HUD Lighting"
              value={o.combohud_lighting}
              on="Full-bright"
              off="No Change"
              pref="combohud_lighting"
            />
            <Divider />
            <AdminToggle
              label="Dead Chat"
              value={o.show_dead_chat}
              on="Shown"
              off="Hidden"
              pref="toggle_dead_chat"
            />
            <AdminToggle
              label="Radio Messages"
              value={o.show_radio}
              on="Shown"
              off="Hidden"
              pref="toggle_radio_chatter"
            />
            <AdminToggle
              label="Prayers"
              value={o.show_prayers}
              on="Shown"
              off="Hidden"
              pref="toggle_prayers"
            />
            {!!o.asay_color_allowed && (
              <Stack align="center">
                <Stack.Item width="160px" color="label">
                  ASAY Color
                </Stack.Item>
                <Stack.Item>
                  <Swatch color={(o.asaycolor || '').replace('#', '')} />
                  <Button
                    color="transparent"
                    onClick={() =>
                      act('link', { preference: 'asaycolor', task: 'input' })
                    }
                  >
                    Change
                  </Button>
                </Stack.Item>
              </Stack>
            )}
            <Divider />
            <Box color="label" bold mb={0.5}>
              Deadmin While Playing
            </Box>
            <AdminToggle
              label="Always Deadmin"
              value={o.deadmin_always}
              on="Enabled"
              off="Disabled"
              pref="toggle_deadmin_always"
              forced={o.deadmin_forced}
            />
            {!o.deadmin_forced && !o.deadmin_always && (
              <>
                <AdminToggle
                  label="As Antag"
                  value={o.deadmin_antag}
                  on="Deadmin"
                  off="Keep Admin"
                  pref="toggle_deadmin_antag"
                  forced={o.deadmin_antag_forced}
                />
                <AdminToggle
                  label="As Command"
                  value={o.deadmin_head}
                  on="Deadmin"
                  off="Keep Admin"
                  pref="toggle_deadmin_head"
                  forced={o.deadmin_head_forced}
                />
              </>
            )}
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};

type CaptureTarget = {
  name: string;
  full_name: string;
  old_key: string;
};

const KeybindsTab = (props) => {
  const { act, data } = useBackend<Data>();
  const [search, setSearch] = useState('');
  const [capturing, setCapturing] = useState<CaptureTarget | null>(null);
  const query = search.toLowerCase();

  // In-window replacement for the legacy "capturekeypress" browser popup:
  // grab the next keyup and feed it to the same keybindings_set handler.
  useEffect(() => {
    if (!capturing) {
      return;
    }
    const handler = (e: KeyboardEvent) => {
      e.preventDefault();
      e.stopPropagation();
      const keyCode = e.keyCode;
      act('link', {
        preference: 'keybinds',
        task: 'keybindings_set',
        keybinding: capturing.name,
        old_key: capturing.old_key,
        clear_key: keyCode === 27 ? 1 : 0,
        key: e.key,
        alt: e.altKey ? 1 : 0,
        ctrl: e.ctrlKey ? 1 : 0,
        shift: e.shiftKey ? 1 : 0,
        numpad: keyCode > 95 && keyCode < 112 ? 1 : 0,
        key_code: keyCode,
      });
      setCapturing(null);
    };
    document.addEventListener('keyup', handler);
    return () => document.removeEventListener('keyup', handler);
  }, [capturing]);

  return (
    <Section
      fill
      scrollable
      title="Keybinds"
      buttons={
        <>
          <Input placeholder="Search..." value={search} onChange={setSearch} />
          <Button
            color="bad"
            onClick={() =>
              act('link', { preference: 'keybinds', task: 'keybindings_reset' })
            }
          >
            Reset to default
          </Button>
        </>
      }
    >
      {data.keybinds.map((category) => {
        const binds = category.binds.filter(
          (kb) => !query || kb.full_name.toLowerCase().includes(query),
        );
        if (!binds.length) {
          return null;
        }
        return (
          <Box key={category.name} mb={1}>
            <Box color="gold" bold mb={0.5}>
              {category.name}
            </Box>
            {binds.map((kb) => (
              <Stack key={kb.name} align="center">
                <Stack.Item width="220px" color="label">
                  {kb.full_name}
                </Stack.Item>
                <Stack.Item grow>
                  {kb.keys.length === 0 && (
                    <Button
                      color="transparent"
                      onClick={() =>
                        setCapturing({
                          name: kb.name,
                          full_name: kb.full_name,
                          old_key: 'Unbound',
                        })
                      }
                    >
                      Unbound
                    </Button>
                  )}
                  {kb.keys.map((key) => (
                    <Button
                      key={key}
                      onClick={() =>
                        setCapturing({
                          name: kb.name,
                          full_name: kb.full_name,
                          old_key: key,
                        })
                      }
                    >
                      {key}
                    </Button>
                  ))}
                  {!!kb.keys.length && !!kb.can_add && (
                    <Button
                      color="transparent"
                      onClick={() =>
                        setCapturing({
                          name: kb.name,
                          full_name: kb.full_name,
                          old_key: '',
                        })
                      }
                    >
                      + Add Secondary
                    </Button>
                  )}
                  {!!kb.defaults && (
                    <Box inline color="label" ml={1}>
                      Default: {kb.defaults}
                    </Box>
                  )}
                </Stack.Item>
              </Stack>
            ))}
          </Box>
        );
      })}
      {capturing && (
        <Modal textAlign="center">
          <Box bold mb={1}>
            Keybinding: {capturing.full_name}
          </Box>
          <Box>
            Press any key to change
            <br />
            Press ESC to clear
          </Box>
          <Button mt={1} onClick={() => setCapturing(null)}>
            Cancel
          </Button>
        </Modal>
      )}
    </Section>
  );
};

export const CharacterSheet = (props) => {
  const { act, data } = useBackend<Data>();
  const [tab, setTab] = useState<TabName>('character');

  // Populate the BYOND preview map once the control has mounted, and re-assert
  // the zoom via winset — the reliable post-creation channel for map params.
  useEffect(() => {
    act('refresh_preview');
    const timer = setTimeout(() => {
      Byond.winset(data.preview_map, {
        zoom: PREVIEW_ZOOM,
        'zoom-mode': 'distort',
      });
    }, 500);
    return () => clearTimeout(timer);
  }, []);

  return (
    <Window width={1280} height={720} theme="parchment" title="Character Sheet">
      <Window.Content>
        <Stack fill vertical>
          {/* Tab bar + header badges */}
          <Stack.Item>
            <Stack align="center">
              <Stack.Item>
                <Button
                  selected={tab === 'character'}
                  onClick={() => setTab('character')}
                >
                  Character
                </Button>
                <Button
                  selected={tab === 'flavor'}
                  onClick={() => setTab('flavor')}
                >
                  Flavor Text
                </Button>
                <Button
                  selected={tab === 'classes'}
                  onClick={() => setTab('classes')}
                >
                  Classes
                </Button>
                <Button
                  selected={tab === 'villains'}
                  onClick={() => setTab('villains')}
                >
                  Villains
                </Button>
                <Button
                  selected={tab === 'settings'}
                  onClick={() => setTab('settings')}
                >
                  Game Settings
                </Button>
                {(!!data.ooc.can_change_color || !!data.ooc.is_admin) && (
                  <Button
                    selected={tab === 'ooc'}
                    onClick={() => setTab('ooc')}
                  >
                    OOC
                  </Button>
                )}
                <Button
                  selected={tab === 'keybinds'}
                  onClick={() => setTab('keybinds')}
                >
                  Keybinds
                </Button>
              </Stack.Item>
              <Stack.Item grow textAlign="right">
                <Button
                  color="transparent"
                  onClick={() =>
                    act('link', { preference: 'playerquality', task: 'menu' })
                  }
                >
                  PQ: {data.pq}
                </Button>
                <Button
                  color="transparent"
                  onClick={() =>
                    act('link', { preference: 'triumphs', task: 'menu' })
                  }
                >
                  TRIUMPHS: {data.triumphs || 'None'}
                </Button>
                {!!data.triumph_buys_enabled && (
                  <Button
                    color="transparent"
                    textColor="gold"
                    onClick={() =>
                      act('link', { preference: 'triumph_buy_menu' })
                    }
                  >
                    Buy
                  </Button>
                )}
                <Button
                  color="transparent"
                  textColor={data.age_verified ? 'teal' : 'grey'}
                  onClick={() => act('link', { preference: 'agevet' })}
                >
                  VERIFIED: {data.age_verified ? 'YAE!' : 'NAE?'}
                </Button>
                <Button
                  color="transparent"
                  icon="window-restore"
                  tooltip="Switch back to the legacy preferences window"
                  onClick={() => act('open_legacy')}
                >
                  Legacy
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          {/* Action strip */}
          <Stack.Item>
            <Stack>
              <Stack.Item>
                <Button
                  color="gold"
                  onClick={() => act('link', { preference: 'changeslot' })}
                >
                  ⇄ Change Character
                </Button>
                {!!data.quirks_enabled && (
                  <Button
                    onClick={() =>
                      act('link', { preference: 'trait', task: 'menu' })
                    }
                  >
                    Quirks ({data.quirks.length})
                  </Button>
                )}
              </Stack.Item>
              <Stack.Item grow textAlign="right">
                <Button
                  color="transparent"
                  onClick={() =>
                    act('link', { preference: 'changelog', task: 'menu' })
                  }
                >
                  Changelog
                </Button>
                <Button
                  color="transparent"
                  onClick={() => act('link', { preference: 'lore_primer' })}
                >
                  Lore Primer
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          {/* Ban warnings */}
          {!!data.appearance_banned && (
            <Stack.Item>
              <Box color="bad" bold>
                Thou are banned from using custom names and appearances. Thy
                character will be randomised once thee joins the game.
              </Box>
            </Stack.Item>
          )}

          {/* Main body */}
          <Stack.Item grow>
            {tab === 'classes' && <ClassesTab />}
            {tab === 'villains' && <VillainsTab />}
            {tab === 'settings' && <SettingsTab />}
            {tab === 'ooc' && <OocTab />}
            {tab === 'keybinds' && <KeybindsTab />}
            {tab === 'flavor' && <FlavorTab />}
            {tab === 'character' && (
              <Stack fill>
                {/* Doll rail */}
                <Stack.Item width="280px">
                  <Stack fill vertical>
                    <Stack.Item>
                      {/* Measured geometry (probe: control 263px wide, canvas 15x15
                        = 480px). The doll grid is pixel-centered on the canvas;
                        zoom N renders each world px at N screen px with the
                        viewport centered on the canvas center, so zoom 4 fills
                        the 263px control with the 64px-wide doll grid. */}
                      <ByondUi
                        params={{
                          id: data.preview_map,
                          type: 'map',
                          'background-color': '#000000',
                          'zoom-mode': 'distort',
                          zoom: PREVIEW_ZOOM,
                        }}
                        style={{
                          width: '100%',
                          height: '360px',
                        }}
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Section
                        fill
                        scrollable
                        title={`Virtues${data.statpack_virtuous ? ' ✦' : ''}`}
                      >
                        {data.virtue && (
                          <VirtuePanel
                            virtue={data.virtue}
                            pref="virtue"
                            subPref="subvirtue"
                          />
                        )}
                        {!!data.statpack_virtuous && data.virtuetwo && (
                          <VirtuePanel
                            virtue={data.virtuetwo}
                            pref="virtuetwo"
                            subPref="subvirtue_two"
                          />
                        )}
                        <Box mt={1} color="label" bold>
                          Vices
                        </Box>
                        {data.charflaws.map((flaw) => (
                          <Box key={flaw.index}>
                            <Button
                              color="transparent"
                              textColor={flaw.warning ? 'bad' : undefined}
                              onClick={() =>
                                act('link', {
                                  preference: 'charflaw',
                                  task: 'remove',
                                  index: flaw.index,
                                })
                              }
                            >
                              {flaw.name}
                            </Button>
                            {!!flaw.warning && (
                              <Box inline color="bad">
                                (Requires Extra Vice!)
                              </Box>
                            )}
                          </Box>
                        ))}
                        {!!data.can_add_vice && (
                          <Button
                            color="transparent"
                            onClick={() =>
                              act('link', {
                                preference: 'charflaw',
                                task: 'input',
                              })
                            }
                          >
                            + Add Vice
                          </Button>
                        )}
                        {!!data.has_averse && (
                          <PrefRow
                            label="Loathed:"
                            value={data.averse_faction}
                            pref="charflaw_averse_choice"
                          />
                        )}
                      </Section>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>

                {/* Main columns */}
                <Stack.Item grow>
                  <Stack fill vertical>
                    <Stack.Item grow>
                      <Stack fill>
                        <Stack.Item grow basis={0}>
                          <Section fill scrollable title="Identity">
                            <PrefRow
                              label="Name"
                              value={
                                data.name_banned ? 'NAMEBANNED' : data.real_name
                              }
                              pref="name"
                              extra={
                                !data.name_banned && (
                                  <Button
                                    color="transparent"
                                    onClick={() =>
                                      act('link', {
                                        preference: 'name',
                                        task: 'random',
                                      })
                                    }
                                  >
                                    [R]
                                  </Button>
                                )
                              }
                            />
                            <PrefRow
                              label="Nickname"
                              value={data.nickname}
                              pref="nickname"
                            />
                            <PrefRow
                              label="Pronouns"
                              value={data.pronouns}
                              pref="pronouns"
                            />
                            <PrefRow
                              label="Titles"
                              value={data.titles_pref}
                              pref="titles"
                            />
                            <PrefRow
                              label="Clothing"
                              value={data.clothes_pref}
                              pref="clothespref"
                            />
                            <PrefRow
                              label="Race"
                              value={`${data.species_name}${data.species_invalid ? ' (!)' : ''}`}
                              pref="species"
                            />
                            <PrefRow
                              label="Subrace"
                              value={data.subspecies_name}
                              pref="subspecies"
                            />
                            <PrefRow
                              label="Origin"
                              value={data.origin}
                              pref="origin"
                              extra={
                                <Button
                                  color="transparent"
                                  onClick={() =>
                                    act('link', {
                                      preference: 'originhelp',
                                      task: 'input',
                                    })
                                  }
                                >
                                  ❖
                                </Button>
                              }
                            />
                            {!!data.has_race_bonus && (
                              <PrefRow
                                label="Race Bonus"
                                value={data.race_bonus}
                                pref="race_bonus_select"
                              />
                            )}
                            <PrefRow label="Age" value={data.age} pref="age" />
                            {!data.agender_species && (
                              <PrefRow
                                label="Body Type"
                                value={data.body_type}
                                pref="gender"
                                task=""
                              />
                            )}
                            {!!data.taur_allowed && (
                              <>
                                <PrefRow
                                  label="Taur Body"
                                  value={data.taur_name || 'None'}
                                  pref="taur_type"
                                />
                                <PrefRow
                                  label="Taur Color"
                                  value="Change"
                                  pref="taur_color"
                                  extra={
                                    <Swatch
                                      color={data.taur_color || 'FFFFFF'}
                                    />
                                  }
                                />
                              </>
                            )}
                            <PrefRow
                              label="Language"
                              value={data.extra_language}
                              pref="extra_language"
                            />
                            <PrefRow
                              label="Statpack"
                              value={data.statpack}
                              pref="statpack"
                            />
                            <PrefRow
                              label="Faith"
                              value={data.faith}
                              pref="faith"
                            />
                            <PrefRow
                              label="Patron"
                              value={data.patron}
                              pref="patron"
                            />
                            <PrefRow
                              label="Dominance"
                              value={data.domhand}
                              pref="domhand"
                              task=""
                            />
                            <PrefRow
                              label="Food Prefs"
                              value="Change"
                              pref="culinary"
                              task="menu"
                            />
                            <PrefRow
                              label="Combat Music"
                              value={data.combat_music}
                              pref="combat_music"
                            />
                            <PrefRow
                              label="Unrevivable"
                              value={data.dnr ? 'Yes' : 'No'}
                              pref="dnr"
                            />
                            <PrefRow
                              label="Familiar"
                              value="Preferences"
                              pref="familiar_prefs"
                            />
                            <PrefRow
                              label="Nick Color"
                              value="Change"
                              pref="highlight_color"
                            />
                          </Section>
                        </Stack.Item>

                        <Stack.Item grow basis={0}>
                          <Stack fill vertical>
                            <Stack.Item grow basis={0}>
                              <Section fill scrollable title="Body">
                                {!!data.use_skintones && (
                                  <PrefRow
                                    label={data.skin_tone_wording}
                                    value="Change"
                                    pref="s_tone"
                                  />
                                )}
                                {!!data.mutcolors && (
                                  <>
                                    <PrefRow
                                      label="Mutant #1"
                                      value="Change"
                                      pref="mutant_color"
                                      extra={<Swatch color={data.mcolor} />}
                                    />
                                    <PrefRow
                                      label="Mutant #2"
                                      value="Change"
                                      pref="mutant_color2"
                                      extra={<Swatch color={data.mcolor2} />}
                                    />
                                    <PrefRow
                                      label="Mutant #3"
                                      value="Change"
                                      pref="mutant_color3"
                                      extra={<Swatch color={data.mcolor3} />}
                                    />
                                  </>
                                )}
                                <PrefRow
                                  label="Features"
                                  value="Open Customizer"
                                  pref="customizers"
                                  task="menu"
                                />
                                <PrefRow
                                  label="Sprite Scale"
                                  value={`${data.body_size}%`}
                                  pref="body_size"
                                />
                                <PrefRow
                                  label="Markings"
                                  value="Change"
                                  pref="markings"
                                  task="menu"
                                />
                                <PrefRow
                                  label="Descriptors"
                                  value="Change"
                                  pref="descriptors"
                                  task="menu"
                                />
                                <PrefRow
                                  label="Color Sync"
                                  value={
                                    data.update_mutant_colors ? 'Yes' : 'No'
                                  }
                                  pref="update_mutant_colors"
                                />
                                <PrefRow
                                  label="Loadout"
                                  value="Open Menu"
                                  pref="open_loadout"
                                />
                              </Section>
                            </Stack.Item>
                            <Stack.Item grow basis={0}>
                              <Section fill scrollable title="Voice">
                                <PrefRow
                                  label="Identity"
                                  value={data.voice_type}
                                  pref="voicetype"
                                />
                                <PrefRow
                                  label="Pack"
                                  value={data.voice_pack}
                                  pref="voicepack"
                                  extra={
                                    data.voice_pack !== 'Default' && (
                                      <Button
                                        color="transparent"
                                        onClick={() =>
                                          act('link', {
                                            preference: 'voicepack_preview',
                                            task: 'input',
                                          })
                                        }
                                      >
                                        ▶
                                      </Button>
                                    )
                                  }
                                />
                                <PrefRow
                                  label="Color"
                                  value="Change"
                                  pref="voice"
                                />
                                <PrefRow
                                  label="Pitch"
                                  value={data.voice_pitch}
                                  pref="voice_pitch"
                                />
                                <PrefRow
                                  label="Bark"
                                  value={data.bark_name}
                                  pref="barksound"
                                />
                                <PrefRow
                                  label="Bark Speed"
                                  value={data.bark_speed}
                                  pref="barkspeed"
                                />
                                <PrefRow
                                  label="Bark Pitch"
                                  value={data.bark_pitch}
                                  pref="barkpitch"
                                />
                                <PrefRow
                                  label="Bark Vary"
                                  value={data.bark_variance}
                                  pref="barkvary"
                                />
                                <Button
                                  onClick={() =>
                                    act('link', {
                                      preference: 'barkpreview',
                                      task: 'input',
                                    })
                                  }
                                >
                                  ▶ Preview Bark
                                </Button>
                              </Section>
                            </Stack.Item>
                          </Stack>
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            )}
          </Stack.Item>

          {/* Footer */}
          <Stack.Item>
            <Stack align="center">
              <Stack.Item>
                {!data.is_guest && (
                  <>
                    <Button
                      color="gold"
                      onClick={() => act('link', { preference: 'save' })}
                    >
                      Save
                    </Button>
                    <Button onClick={() => act('link', { preference: 'load' })}>
                      Undo
                    </Button>
                  </>
                )}
              </Stack.Item>
              <Stack.Item grow textAlign="right">
                {!!data.is_new_player &&
                  (data.pregame ? (
                    <>
                      <Button
                        selected={data.ready === PLAYER_READY_TO_PLAY}
                        color="teal"
                        onClick={() =>
                          act('ready', { state: PLAYER_READY_TO_PLAY })
                        }
                      >
                        READY
                      </Button>
                      <Button
                        selected={data.ready === PLAYER_NOT_READY}
                        onClick={() =>
                          act('ready', { state: PLAYER_NOT_READY })
                        }
                      >
                        UNREADY
                      </Button>
                    </>
                  ) : (
                    <>
                      <Button
                        disabled={!!data.is_migrant}
                        color="teal"
                        onClick={() => act('late_join')}
                      >
                        JOINLATE
                      </Button>
                      <Button
                        onClick={() => act('link', { preference: 'migrants' })}
                      >
                        MIGRATION
                      </Button>
                      <Button
                        onClick={() => act('link', { preference: 'manifest' })}
                      >
                        ACTORS
                      </Button>
                      <Button
                        onClick={() => act('link', { preference: 'observe' })}
                      >
                        VOYEUR
                      </Button>
                    </>
                  ))}
                {!!data.is_guest && (
                  <Button
                    onClick={() => act('link', { preference: 'finished' })}
                  >
                    DONE
                  </Button>
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
