import { useState } from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type PowerData = {
  name: string;
  level: number;
  desc: string;
};

type CovenData = {
  name: string;
  desc: string;
  icon?: string;
  powers: PowerData[];
};

type TraitData = {
  name: string;
  desc: string;
};

type LordFormData = {
  name: string;
  desc: string;
};

type ClanData = {
  id: string;
  name: string;
  desc: string;
  curse: string;
  downside: string;
  bloodPreference: string;
  covens: CovenData[];
  icon?: string;
  tagline?: string;
  isCustom?: boolean | number;
  lordTitle: string;
  lordForm: LordFormData | null;
  lordTraits: TraitData[];
  clanTraits: TraitData[];
  vitaeBonus: number;
};

type VampireClanSelectionData = {
  clans: ClanData[];
  selectedClanId: string;
  pendingCustomName: string;
  defaultClanName: string;
  language?: string;
  i18nOverrides?: Record<string, string> | null;
};

const DEFAULT_W = 1100;
const DEFAULT_H = 760;

const capFirst = (s: string | undefined | null): string => {
  if (!s) return '';
  return s.charAt(0).toUpperCase() + s.slice(1);
};

const FALLBACK_LANG = 'en';

const TRANSLATIONS: Record<string, Record<string, string>> = {
  en: {
    title: 'Clan Selection',
    subtitle: 'Choose your vampire clan',
    flavorLine1: 'The Blood remembers.',
    flavorLine2: 'Choose your lineage.',
    expand: 'Expand',
    restore: 'Restore',
    expandTip: 'Expand window',
    restoreTip: 'Restore window',
    availableClans: 'Available Clans',
    clanName: 'Clan Name',
    customNamePlaceholder: 'Name your Caitiff bloodline...',
    customNameHint: 'Leave blank to be known simply as the "Custom Clan".',
    description: 'Description',
    curseDownside: 'Curse / Downside',
    bloodPreference: 'Blood Preference',
    lordOfClan: 'Lord of the Clan',
    lordHailedAs: 'Hailed as the',
    lordVitae: ', endowed with an extra +{vitae} vitae',
    lordOnlyBoons: 'Lord-only Boons',
    specialClanTraits: 'Special Clan Traits',
    disciplinesPowers: 'Disciplines & Powers',
    caitiffNoDisciplines: 'A Caitiff chooses their own disciplines later.',
    none: 'None.',
    unknown: 'Unknown',
    noPowersDocumented: 'No powers documented.',
    accept: 'Accept Clan',
    close: 'Close',
    warningDefault:
      'If no clan is chosen, Nosferatu will be assigned by default.',
  },
};

const resolveLang = (raw: string | undefined): string => {
  if (raw && TRANSLATIONS[raw]) {
    return raw;
  }
  return FALLBACK_LANG;
};

const makeT =
  (lang: string, overrides?: Record<string, string> | null) =>
  (key: string, vars?: Record<string, string | number>): string => {
    let value: string | undefined = overrides ? overrides[key] : undefined;
    if (value === undefined) {
      const dict = TRANSLATIONS[lang] || TRANSLATIONS[FALLBACK_LANG];
      value = dict[key];
    }
    if (value === undefined) {
      value = TRANSLATIONS[FALLBACK_LANG][key];
    }
    if (value === undefined) {
      return key;
    }
    if (vars) {
      for (const name of Object.keys(vars)) {
        value = value.replace(`{${name}}`, String(vars[name]));
      }
    }
    return value;
  };

const setVampireClanWindowSize = (expanded: boolean) => {
  if (typeof Byond === 'undefined' || !Byond?.winset) return;
  const scale = window.devicePixelRatio || 1;
  const screenWidth = Math.floor(window.screen.availWidth * scale);
  const screenHeight = Math.floor(window.screen.availHeight * scale);
  const width = expanded
    ? screenWidth
    : Math.min(DEFAULT_W, screenWidth);
  const height = expanded
    ? screenHeight
    : Math.min(DEFAULT_H, screenHeight);
  const x = expanded ? 0 : Math.max(Math.floor((screenWidth - width) / 2), 0);
  const y = expanded ? 0 : Math.max(Math.floor((screenHeight - height) / 2), 0);
  Byond.winset(Byond.windowId, {
    pos: `${x},${y}`,
    size: `${width}x${height}`,
  });
};

export const VampireClanSelection = () => {
  const { act, data } = useBackend<VampireClanSelectionData>();
  const [expandedCovens, setExpandedCovens] = useState<Set<string>>(new Set());
  const [customName, setCustomName] = useState(data.pendingCustomName || '');
  const [windowExpanded, setWindowExpanded] = useState(false);

  const lang = resolveLang(data.language);
  const t = makeT(lang, data.i18nOverrides);

  const selectedClan =
    data.clans.find((clan) => clan.id === data.selectedClanId) || data.clans[0];
  const isCustom = !!selectedClan?.isCustom;

  const toggleCoven = (covenName: string) => {
    setExpandedCovens((prev) => {
      const next = new Set(prev);
      if (next.has(covenName)) {
        next.delete(covenName);
      } else {
        next.add(covenName);
      }
      return next;
    });
  };

  const onCustomNameChange = (value: string) => {
    setCustomName(value);
    act('set_custom_name', { name: value });
  };

  const toggleWindow = () => {
    const nextExpanded = !windowExpanded;
    setVampireClanWindowSize(nextExpanded);
    setWindowExpanded(nextExpanded);
  };

  return (
    <Window width={DEFAULT_W} height={DEFAULT_H} theme="generic">
      <Window.Content className="VampireClanSelection" fitted>
        <Box className="VampireClanSelection__shell">
          <Box className="VampireClanSelection__header">
            <Box className="VampireClanSelection__crest">
              <Box className="VampireClanSelection__crestInner">
                <Icon name="gem" />
              </Box>
            </Box>
            <Box className="VampireClanSelection__titleBlock">
              <Box className="VampireClanSelection__title">{t('title')}</Box>
              <Box className="VampireClanSelection__subtitle">
                {t('subtitle')}
              </Box>
            </Box>
            <Box className="VampireClanSelection__windowControls">
              <Button
                color="transparent"
                icon={windowExpanded ? 'compress' : 'expand'}
                tooltip={windowExpanded ? t('restoreTip') : t('expandTip')}
                tooltipPosition="left"
                onClick={toggleWindow}
                className="VampireClanSelection__windowButton"
              >
                {windowExpanded ? t('restore') : t('expand')}
              </Button>
            </Box>
            <Box className="VampireClanSelection__flavor">
              {t('flavorLine1')}
              <br />
              {t('flavorLine2')}
            </Box>
          </Box>

          <Box className="VampireClanSelection__body">
            <Box className="VampireClanSelection__leftPanel">
              <Section title={t('availableClans')} fill scrollable>
                <Stack vertical>
                  {data.clans.map((clan, index) => {
                    const selected = clan.id === selectedClan?.id;
                    return (
                      <Stack.Item key={clan.id}>
                        <Button
                          fluid
                          className={
                            selected
                              ? 'VampireClanSelection__clanCard VampireClanSelection__clanCard--selected'
                              : 'VampireClanSelection__clanCard'
                          }
                          onClick={() =>
                            act('select_clan', { clan_id: clan.id })
                          }
                        >
                          <Stack align="center">
                            <Stack.Item>
                              <Box className="VampireClanSelection__number">
                                {index + 1}
                              </Box>
                            </Stack.Item>
                            <Stack.Item>
                              <Box
                                className={
                                  clan.isCustom
                                    ? 'VampireClanSelection__cardSigil VampireClanSelection__cardSigil--custom'
                                    : 'VampireClanSelection__cardSigil'
                                }
                              >
                                <Icon
                                  name={clan.isCustom ? 'question' : 'gem'}
                                />
                              </Box>
                            </Stack.Item>
                            <Stack.Item grow>
                              <Box className="VampireClanSelection__clanName">
                                {clan.name}
                              </Box>
                              <Box className="VampireClanSelection__tagline">
                                {clan.tagline}
                              </Box>
                            </Stack.Item>
                          </Stack>
                        </Button>
                      </Stack.Item>
                    );
                  })}
                </Stack>
              </Section>
            </Box>

            <Box className="VampireClanSelection__rightPanel">
              <Section fill scrollable>
                {selectedClan ? (
                  <Box className="VampireClanSelection__details">
                    <Box className="VampireClanSelection__selectedName">
                      {selectedClan.name}
                    </Box>
                    <Box className="VampireClanSelection__divider" />

                    {isCustom ? (
                      <Box className="VampireClanSelection__infoBlock">
                        <Box className="VampireClanSelection__infoTitle">
                          <Icon
                            name="pen"
                            className="VampireClanSelection__infoIcon"
                          />
                          {t('clanName')}
                        </Box>
                        <Input
                          fluid
                          className="VampireClanSelection__customNameInput"
                          placeholder={t('customNamePlaceholder')}
                          value={customName}
                          onChange={onCustomNameChange}
                          maxLength={42}
                        />
                        <Box
                          className="VampireClanSelection__infoText"
                          mt={0.5}
                        >
                          {t('customNameHint')}
                        </Box>
                      </Box>
                    ) : null}

                    <InfoBlock
                      title={t('description')}
                      icon="book"
                      text={capFirst(selectedClan.desc)}
                      fallback={t('unknown')}
                    />
                    <InfoBlock
                      title={t('curseDownside')}
                      icon="skull"
                      text={capFirst(
                        selectedClan.downside || selectedClan.curse,
                      )}
                      fallback={t('unknown')}
                    />
                    <InfoBlock
                      title={t('bloodPreference')}
                      icon="tint"
                      text={capFirst(selectedClan.bloodPreference)}
                      fallback={t('unknown')}
                    />

                    <LordBlock clan={selectedClan} t={t} />

                    <ClanTraitsBlock traits={selectedClan.clanTraits} t={t} />

                    <Box className="VampireClanSelection__infoBlock">
                      <Box className="VampireClanSelection__infoTitle">
                        <Icon
                          name="fire"
                          className="VampireClanSelection__infoIcon"
                        />
                        {t('disciplinesPowers')}
                      </Box>
                      {selectedClan.covens && selectedClan.covens.length > 0 ? (
                        <Stack vertical>
                          {selectedClan.covens.map((coven) => (
                            <Stack.Item key={coven.name}>
                              <CovenCard
                                coven={coven}
                                expanded={expandedCovens.has(coven.name)}
                                onToggle={() => toggleCoven(coven.name)}
                                t={t}
                              />
                            </Stack.Item>
                          ))}
                        </Stack>
                      ) : (
                        <Box className="VampireClanSelection__infoText">
                          {isCustom ? t('caitiffNoDisciplines') : t('none')}
                        </Box>
                      )}
                    </Box>
                  </Box>
                ) : null}
              </Section>
            </Box>
          </Box>

          <Box className="VampireClanSelection__footer">
            <Box className="VampireClanSelection__warning">
              {t('warningDefault')}
            </Box>
            <Stack align="center">
              <Stack.Item grow />
              <Stack.Item>
                <Button
                  color="red"
                  icon="check"
                  onClick={() => act('accept_clan')}
                  className="VampireClanSelection__footerAccept"
                >
                  {t('accept')}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="transparent"
                  icon="times"
                  onClick={() => act('close')}
                  className="VampireClanSelection__footerClose"
                >
                  {t('close')}
                </Button>
              </Stack.Item>
            </Stack>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};

type Translator = ReturnType<typeof makeT>;

const InfoBlock = (props: {
  title: string;
  icon: string;
  text?: string;
  fallback?: string;
}) => (
  <Box className="VampireClanSelection__infoBlock">
    <Box className="VampireClanSelection__infoTitle">
      <Icon
        name={props.icon}
        className="VampireClanSelection__infoIcon"
      />
      {props.title}
    </Box>
    <Box className="VampireClanSelection__infoText">
      {props.text || props.fallback || ''}
    </Box>
  </Box>
);

const LordBlock = (props: { clan: ClanData; t: Translator }) => {
  const { clan, t } = props;
  const hasForm = !!clan.lordForm;
  const hasTraits = clan.lordTraits && clan.lordTraits.length > 0;
  const hasVitae = !!clan.vitaeBonus;
  if (!hasForm && !hasTraits && !hasVitae && !clan.isCustom) {
    return null;
  }
  return (
    <Box className="VampireClanSelection__infoBlock">
      <Box className="VampireClanSelection__infoTitle">
        <Icon name="crown" className="VampireClanSelection__infoIcon" />
        {t('lordOfClan')}
      </Box>
      <Box className="VampireClanSelection__lordTitleLine">
        {t('lordHailedAs')} <b>{clan.lordTitle || 'Lord'}</b>
        {hasVitae ? t('lordVitae', { vitae: clan.vitaeBonus }) : null}.
      </Box>

      {hasForm ? (
        <Box className="VampireClanSelection__lordFormCard">
          <Box className="VampireClanSelection__lordFormTitle">
            <Icon name="dragon" className="VampireClanSelection__formIcon" />
            {clan.lordForm!.name}
          </Box>
          <Box className="VampireClanSelection__lordFormDesc">
            {clan.lordForm!.desc}
          </Box>
        </Box>
      ) : null}

      {hasTraits ? (
        <Box className="VampireClanSelection__traitList">
          <Box className="VampireClanSelection__traitListLabel">
            {t('lordOnlyBoons')}
          </Box>
          {clan.lordTraits.map((trait) => (
            <TraitRow key={`lord-${trait.name}`} trait={trait} />
          ))}
        </Box>
      ) : null}
    </Box>
  );
};

const ClanTraitsBlock = (props: { traits: TraitData[]; t: Translator }) => {
  const { traits, t } = props;
  if (!traits || traits.length === 0) {
    return null;
  }
  return (
    <Box className="VampireClanSelection__infoBlock">
      <Box className="VampireClanSelection__infoTitle">
        <Icon name="star" className="VampireClanSelection__infoIcon" />
        {t('specialClanTraits')}
      </Box>
      <Box className="VampireClanSelection__traitList">
        {traits.map((trait) => (
          <TraitRow key={`clan-${trait.name}`} trait={trait} />
        ))}
      </Box>
    </Box>
  );
};

const TraitRow = (props: { trait: TraitData }) => (
  <Box className="VampireClanSelection__traitRow">
    <Box className="VampireClanSelection__traitName">{props.trait.name}</Box>
    <Box className="VampireClanSelection__traitDesc">{props.trait.desc}</Box>
  </Box>
);

const CovenCard = (props: {
  coven: CovenData;
  expanded: boolean;
  onToggle: () => void;
  t: Translator;
}) => {
  const { coven, expanded, onToggle, t } = props;
  return (
    <Box className="VampireClanSelection__covenCard">
      <Button
        fluid
        className="VampireClanSelection__covenHeader"
        onClick={onToggle}
      >
        <Stack align="center">
          <Stack.Item>
            <Box className="VampireClanSelection__covenChevron">
              <Icon name={expanded ? 'chevron-down' : 'chevron-right'} />
            </Box>
          </Stack.Item>
          <Stack.Item grow>
            <Box className="VampireClanSelection__covenName">{coven.name}</Box>
            <Box className="VampireClanSelection__covenDesc">
              {capFirst(coven.desc)}
            </Box>
          </Stack.Item>
        </Stack>
      </Button>
      {expanded ? (
        <Box className="VampireClanSelection__powerList">
          {coven.powers && coven.powers.length > 0 ? (
            coven.powers.map((power) => (
              <Box
                key={`${coven.name}-${power.level}-${power.name}`}
                className="VampireClanSelection__powerItem"
              >
                <Box className="VampireClanSelection__powerLevel">
                  {power.level}
                </Box>
                <Box className="VampireClanSelection__powerBody">
                  <Box className="VampireClanSelection__powerName">
                    {power.name}
                  </Box>
                  <Box className="VampireClanSelection__powerDesc">
                    {capFirst(power.desc)}
                  </Box>
                </Box>
              </Box>
            ))
          ) : (
            <Box className="VampireClanSelection__infoText">
              {t('noPowersDocumented')}
            </Box>
          )}
        </Box>
      ) : null}
    </Box>
  );
};
