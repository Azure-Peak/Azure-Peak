import { useState } from 'react';
import {
  Box,
  Button,
  Divider,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

import { backendSuspendStart, globalStore, useBackend } from '../backend';
import { Window } from '../layouts';

type Project = {
  ref: string;
  name: string;
  description: string;
  mechanics: string;
  cost: number;
  paid: number;
  remaining: number;
  progress: number;
  isLordOnly: boolean;
  accessText: string;
  canContribute: boolean;
  maxContribution: number;
  maxBloodCost: number;
  contributorsText: string;
  contributionText: string;
};

type AvailableProject = {
  type_path: string;
  name: string;
  description: string;
  mechanics: string;
  cost: number;
  isLordOnly: boolean;
  accessText: string;
  accessSeal: string;
  canStart: boolean;
  lockedReason: string;
};

type CrucibleData = {
  bloodLevel: number;
  maxBlood: number;
  committedVitae: number;
  isLord: boolean;
  isVampire: boolean;
  canDepositBlood: boolean;
  maxCupDeposit: number;
  activeProjects: Project[];
  availableProjects: AvailableProject[];
  personalServantProject?: AvailableProject | null;
  language?: string;
  i18nOverrides?: Record<string, string> | null;
};

type Translator = (key: string, vars?: Record<string, string | number>) => string;

const FALLBACK_LANG = 'en';

const TRANSLATIONS: Record<string, Record<string, string>> = {
  en: {
    windowTitle: 'Crimson Crucible',
    headerTitle: 'CRIMSON CRUCIBLE',
    roleLord: 'Right of Dominion',
    roleVampire: 'Right of Sacrifice',
    roleMortal: 'Living sacrifice',
    expand: 'Expand',
    restore: 'Restore',
    expandTip: 'Expand window to screen',
    restoreTip: 'Restore default window size',
    close: 'Close',
    closeTip: 'Close window',
    bloodInCup: 'Blood in cup: {current} / {max}',
    committed: 'Committed: {n} vitae',
    pourBlood: 'Pour blood',
    giveBlood: 'Give blood',
    availableToPour: 'Available to pour: {n} vitae',
    activeRituals: 'Active Rituals',
    newRituals: 'New Rituals',
    emptyActive: 'The crucible is silent. No ritual has begun.',
    mortalNote:
      "The crucible accepts blood into the cup. Only the Methuselah can direct it into rituals.",
    nonLordNote:
      'Only the Methuselah can begin or direct rituals. Other vampires may fill the cup and answer one weak servant call.',
    noRituals: 'No rituals are available.',
    direct: 'Direct',
    contribute: 'Contribute',
    cancel: 'Cancel',
    required: 'Required: {n} vitae',
    collected: 'Collected: {n} vitae',
    remaining: 'Remaining: {n} vitae',
    contributors: 'Contributors:',
    description: 'Description',
    mechanics: 'Mechanics',
    cost: 'Cost: {n} vitae',
    start: 'Start',
    noContributors: 'No one yet',
    contributionDirect: 'Can direct up to {n} vitae; the cup is spent first',
    contributionVitae: 'Can contribute up to {n} vitae',
    contributionBlood: 'Will sacrifice {vitae} vitae and {blood} blood',
  },
};

const localizeText = (text: string, t: Translator): string => {
  if (!text) return text;
  return t(text);
};

const localizeContributors = (text: string, t: Translator): string => {
  if (!text) return text;
  if (text === 'No one yet') return t('noContributors');
  return text;
};

const localizeContribution = (text: string, t: Translator): string => {
  if (!text) return text;
  let m: RegExpMatchArray | null;
  if (
    (m = text.match(/^Can direct up to (\d+) vitae; the cup is spent first$/))
  ) {
    return t('contributionDirect', { n: m[1] });
  }
  if ((m = text.match(/^Can contribute up to (\d+) vitae$/))) {
    return t('contributionVitae', { n: m[1] });
  }
  if ((m = text.match(/^Will sacrifice (\d+) vitae and (\d+) blood$/))) {
    return t('contributionBlood', { vitae: m[1], blood: m[2] });
  }
  return localizeText(text, t);
};

const localizeActiveProject = (p: Project, t: Translator): Project => {
  const next: Project = { ...p };
  next.name = localizeText(p.name, t);
  next.description = localizeText(p.description, t);
  next.mechanics = localizeText(p.mechanics, t);
  next.accessText = localizeText(p.accessText, t);
  next.contributorsText = localizeContributors(p.contributorsText, t);
  next.contributionText = localizeContribution(p.contributionText, t);
  return next;
};

const localizeAvailableProject = (
  p: AvailableProject,
  t: Translator,
): AvailableProject => {
  const next: AvailableProject = { ...p };
  next.name = localizeText(p.name, t);
  next.description = localizeText(p.description, t);
  next.mechanics = localizeText(p.mechanics, t);
  next.accessText = localizeText(p.accessText, t);
  next.lockedReason = localizeText(p.lockedReason, t);
  return next;
};

const resolveLang = (raw: string | undefined): string => {
  return raw || FALLBACK_LANG;
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

const formatVitae = (value: number) =>
  Math.round(value || 0).toLocaleString('en-US');

const formatPercent = (value: number) =>
  `${Number(value || 0).toLocaleString('en-US', {
    maximumFractionDigits: 1,
  })}%`;

const clampRatio = (value: number) => Math.max(0, Math.min(1, value || 0));

const defaultWindowWidth = 1680;
const defaultWindowHeight = 920;

const setCrucibleWindowSize = (expanded: boolean) => {
  const scale = window.devicePixelRatio || 1;
  const screenWidth = Math.floor(window.screen.availWidth * scale);
  const screenHeight = Math.floor(window.screen.availHeight * scale);
  const width = expanded
    ? screenWidth
    : Math.min(defaultWindowWidth, screenWidth);
  const height = expanded
    ? screenHeight
    : Math.min(defaultWindowHeight, screenHeight);
  const x = expanded ? 0 : Math.max(Math.floor((screenWidth - width) / 2), 0);
  const y = expanded ? 0 : Math.max(Math.floor((screenHeight - height) / 2), 0);

  Byond.winset(Byond.windowId, {
    pos: `${x},${y}`,
    size: `${width}x${height}`,
  });
};

const closeCrucibleWindow = () => {
  globalStore.dispatch(backendSuspendStart());
};

const shellStyle = {
  background:
    'linear-gradient(180deg, rgba(24, 3, 5, 0.95), rgba(8, 7, 7, 0.98))',
  display: 'grid',
  gap: '8px',
  gridTemplateRows: '136px minmax(0, 1fr)',
  height: '100%',
  minHeight: 0,
};

const frameStyle = {
  background:
    'linear-gradient(135deg, rgba(45, 5, 8, 0.95), rgba(12, 10, 10, 0.96))',
  border: '1px solid #5b1b1f',
  borderRadius: '6px',
  boxShadow: 'inset 0 0 18px rgba(0, 0, 0, 0.55)',
};

const headerGridStyle = {
  ...frameStyle,
  alignItems: 'center',
  display: 'grid',
  gap: '16px',
  gridTemplateColumns: '210px minmax(320px, 1fr) minmax(280px, 340px)',
  padding: '14px',
};

const sealControlStyle = {
  alignItems: 'center',
  display: 'grid',
  gap: '10px',
  gridTemplateColumns: '64px minmax(118px, 1fr)',
};

const windowControlStackStyle = {
  display: 'grid',
  gap: '6px',
};

const windowControlButtonStyle = {
  border: '1px solid rgba(232, 208, 160, 0.5)',
  boxShadow: '0 0 10px rgba(216, 32, 52, 0.2)',
  fontWeight: 700,
};

const contentGridStyle = {
  display: 'grid',
  gap: '8px',
  gridTemplateColumns: 'minmax(660px, 2.25fr) minmax(460px, 1fr)',
  height: '100%',
  minHeight: 0,
};

const parchmentStyle = {
  background: 'linear-gradient(180deg, #c9b98d, #a99461)',
  border: '1px solid #1f1614',
  borderRadius: '6px',
  color: '#17110f',
  boxShadow: 'inset 0 0 12px rgba(255, 246, 190, 0.22)',
};

const activeCardStyle = {
  ...parchmentStyle,
  minWidth: 0,
  padding: '10px',
};

const availableCardStyle = {
  ...parchmentStyle,
  display: 'grid',
  gap: '8px',
  minWidth: 0,
  padding: '10px',
};

const sealStyle = {
  width: '52px',
  height: '52px',
  borderRadius: '6px',
  border: '1px solid #572126',
  background: 'radial-gradient(circle at 50% 35%, #611820, #18090b 74%)',
  color: '#d8c7a0',
  textAlign: 'center' as const,
  lineHeight: '52px',
  fontWeight: 700,
  fontSize: '21px',
  textShadow: '0 0 8px #d82034',
};

const labelStyle = {
  color: '#3a2723',
  fontSize: '11px',
  fontWeight: 700,
  textTransform: 'uppercase' as const,
};

const descriptionBlockStyle = {
  borderTop: '1px solid rgba(74, 52, 35, 0.35)',
  paddingTop: '7px',
};

const copyStyle = {
  color: '#2f211e',
  lineHeight: 1.35,
  overflowWrap: 'break-word' as const,
};

const mechanicsBlockStyle = {
  background:
    'linear-gradient(90deg, rgba(112, 64, 184, 0.2), rgba(112, 64, 184, 0.06))',
  borderLeft: '4px solid #7040b8',
  marginTop: '8px',
  padding: '7px 9px 7px 10px',
};

const mechanicsLabelStyle = {
  ...labelStyle,
  color: '#5b239b',
};

const mechanicsStyle = {
  color: '#7040b8',
  fontStyle: 'normal',
  fontWeight: 400,
  lineHeight: 1.35,
  overflowWrap: 'break-word' as const,
  whiteSpace: 'pre-line' as const,
};

export const CrimsonCrucible = () => {
  const { act, data } = useBackend<CrucibleData>();
  const [windowExpanded, setWindowExpanded] = useState(false);
  const {
    bloodLevel = 0,
    maxBlood = 20000,
    committedVitae = 0,
    isLord = false,
    isVampire = false,
    canDepositBlood = false,
    maxCupDeposit = 0,
    activeProjects = [],
    availableProjects = [],
    personalServantProject = null,
  } = data;
  const isLordUser = !!isLord;
  const isVampireUser = !!isVampire;
  const canDeposit = !!canDepositBlood;
  const lang = resolveLang(data.language);
  const t = makeT(lang, data.i18nOverrides);
  const localizedActiveProjects = activeProjects.map((p) =>
    localizeActiveProject(p, t),
  );
  const localizedAvailableProjects = availableProjects.map((p) =>
    localizeAvailableProject(p, t),
  );
  const localizedPersonalServantProject = personalServantProject
    ? localizeAvailableProject(personalServantProject, t)
    : null;
  const hasLordProjects =
    isVampireUser && isLordUser && localizedAvailableProjects.length > 0;
  const hasPersonalServantProject =
    isVampireUser && !!localizedPersonalServantProject;
  const showLordEmptyState =
    isVampireUser &&
    isLordUser &&
    !hasLordProjects &&
    !hasPersonalServantProject;
  const bloodRatio = clampRatio(bloodLevel / Math.max(maxBlood, 1));
  const roleText = isVampireUser
    ? isLordUser
      ? t('roleLord')
      : t('roleVampire')
    : t('roleMortal');
  const toggleWindowSize = () => {
    const nextExpanded = !windowExpanded;
    setCrucibleWindowSize(nextExpanded);
    setWindowExpanded(nextExpanded);
  };

  return (
    <Window
      title={t('windowTitle')}
      width={defaultWindowWidth}
      height={defaultWindowHeight}
      theme="dark"
    >
      <Window.Content fitted>
        <Box p={1} style={shellStyle}>
          <Box style={headerGridStyle}>
            <Box style={sealControlStyle}>
              <Box style={sealStyle}>V</Box>
              <Box style={windowControlStackStyle}>
                <Button
                  fluid
                  color="gold"
                  icon={windowExpanded ? 'compress' : 'expand'}
                  tooltip={windowExpanded ? t('restoreTip') : t('expandTip')}
                  tooltipPosition="right"
                  onClick={toggleWindowSize}
                  style={windowControlButtonStyle}
                >
                  {windowExpanded ? t('restore') : t('expand')}
                </Button>
                <Button
                  fluid
                  color="red"
                  icon="times"
                  tooltip={t('closeTip')}
                  tooltipPosition="right"
                  onClick={closeCrucibleWindow}
                  style={windowControlButtonStyle}
                >
                  {t('close')}
                </Button>
              </Box>
            </Box>
            <Box>
              <Box
                bold
                fontSize={1.65}
                color="#e0c090"
                textAlign="center"
                style={{ letterSpacing: '0' }}
              >
                {t('headerTitle')}
              </Box>
              <Box color="#c8878d" textAlign="center" mt={0.3}>
                {roleText}
              </Box>
            </Box>
            <Box>
              <Box color="#e8d0a0" mb={0.4}>
                {t('bloodInCup', {
                  current: formatVitae(bloodLevel),
                  max: formatVitae(maxBlood),
                })}
              </Box>
              <ProgressBar
                value={bloodRatio}
                ranges={{
                  good: [0.66, Infinity],
                  average: [0.25, 0.66],
                  bad: [-Infinity, 0.25],
                }}
              />
              <Box color="#b99b7c" mt={0.4}>
                {t('committed', { n: formatVitae(committedVitae) })}
              </Box>
              <Button
                fluid
                color="red"
                mt={0.6}
                disabled={!canDeposit}
                onClick={() => act('deposit_blood')}
              >
                {isVampireUser ? t('pourBlood') : t('giveBlood')}
              </Button>
              <Box color="#b99b7c" mt={0.4} fontSize={0.9}>
                {t('availableToPour', { n: formatVitae(maxCupDeposit) })}
              </Box>
            </Box>
          </Box>
          <Box style={contentGridStyle}>
            <Section title={t('activeRituals')} fill scrollable>
              {localizedActiveProjects.length ? (
                localizedActiveProjects.map((project, index) => (
                  <ActiveProjectCard
                    key={project.ref}
                    index={index}
                    isLord={isLordUser}
                    project={project}
                    onContribute={() => act('contribute', { ref: project.ref })}
                    onCancel={() => act('cancel_project', { ref: project.ref })}
                    t={t}
                  />
                ))
              ) : (
                <EmptyState text={t('emptyActive')} />
              )}
            </Section>
            <Section title={t('newRituals')} fill scrollable>
              {!isVampireUser ? (
                <Box color="#c7a97a" italic mb={1}>
                  {t('mortalNote')}
                </Box>
              ) : !isLordUser ? (
                <Box color="#c7a97a" italic mb={1}>
                  {t('nonLordNote')}
                </Box>
              ) : null}
              {hasLordProjects &&
                localizedAvailableProjects.map((project) => (
                  <AvailableProjectCard
                    key={project.type_path}
                    project={project}
                    onStart={() =>
                      act('start_project', { type_path: project.type_path })
                    }
                    t={t}
                  />
                ))}
              {hasPersonalServantProject && localizedPersonalServantProject && (
                <AvailableProjectCard
                  key={localizedPersonalServantProject.type_path}
                  project={localizedPersonalServantProject}
                  onStart={() => act('summon_weak_servant')}
                  t={t}
                />
              )}
              {showLordEmptyState ? (
                <EmptyState text={t('noRituals')} />
              ) : null}
            </Section>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};

type ProjectCopyProps = {
  description: string;
  mechanics?: string;
  t: Translator;
};

const ProjectCopy = (props: ProjectCopyProps) => {
  const { description, mechanics, t } = props;

  return (
    <Box mt={0.7}>
      <Box style={descriptionBlockStyle}>
        <Box style={labelStyle}>{t('description')}</Box>
        <Box mt={0.2} style={copyStyle}>
          {description}
        </Box>
      </Box>
      {!!mechanics && (
        <Box style={mechanicsBlockStyle}>
          <Box style={mechanicsLabelStyle}>{t('mechanics')}</Box>
          <Box mt={0.2} style={mechanicsStyle}>
            {mechanics}
          </Box>
        </Box>
      )}
    </Box>
  );
};

type ActiveProjectCardProps = {
  index: number;
  isLord: boolean;
  project: Project;
  onContribute: () => void;
  onCancel: () => void;
  t: Translator;
};

const ActiveProjectCard = (props: ActiveProjectCardProps) => {
  const { index, isLord, project, onContribute, onCancel, t } = props;
  const ratio = clampRatio(project.paid / Math.max(project.cost, 1));

  return (
    <Box mb={1} style={activeCardStyle}>
      <Stack align="start">
        <Stack.Item>
          <Box style={sealStyle}>{index + 1}</Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box bold fontSize={1.08}>
            {project.name} {project.accessText}
          </Box>
          <ProjectCopy
            description={project.description}
            mechanics={project.mechanics}
            t={t}
          />
        </Stack.Item>
        {isLord && (
          <Stack.Item width="128px">
            <Button
              fluid
              color="red"
              disabled={!project.canContribute}
              onClick={onContribute}
            >
              {t('direct')}
            </Button>
            <Button fluid color="bad" mt={0.5} onClick={onCancel}>
              {t('cancel')}
            </Button>
          </Stack.Item>
        )}
      </Stack>
      <Divider />
      <Stack>
        <Stack.Item grow>
          <Box>{t('required', { n: formatVitae(project.cost) })}</Box>
          <Box>{t('collected', { n: formatVitae(project.paid) })}</Box>
          <Box>{t('remaining', { n: formatVitae(project.remaining) })}</Box>
        </Stack.Item>
      </Stack>
      <Box mt={0.8}>
        <ProgressBar value={ratio} color="red">
          {formatPercent(project.progress)}
        </ProgressBar>
      </Box>
      <Box color="#563f37" mt={0.5} fontSize={0.9}>
        {t('contributors')} {project.contributorsText}
      </Box>
      {project.canContribute && (
        <Box color="#563f37" mt={0.3} fontSize={0.9}>
          {project.contributionText}
        </Box>
      )}
    </Box>
  );
};

type AvailableProjectCardProps = {
  project: AvailableProject;
  onStart: () => void;
  t: Translator;
};

const AvailableProjectCard = (props: AvailableProjectCardProps) => {
  const { project, onStart, t } = props;

  return (
    <Box mb={1} style={availableCardStyle}>
      <Stack align="center">
        <Stack.Item>
          <Box style={sealStyle}>{project.accessSeal}</Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box bold fontSize={1.08}>
            {project.name} {project.accessText}
          </Box>
        </Stack.Item>
      </Stack>
      <ProjectCopy
        description={project.description}
        mechanics={project.mechanics}
        t={t}
      />
      <Stack align="center" mt={0.3}>
        <Stack.Item grow>
          <Box color="#563f37">
            {t('cost', { n: formatVitae(project.cost) })}
          </Box>
          {!project.canStart && (
            <Box color="#6c1f25" mt={0.4} fontSize={0.9}>
              {project.lockedReason}
            </Box>
          )}
        </Stack.Item>
        <Stack.Item width="112px">
          <Button
            fluid
            color="red"
            disabled={!project.canStart}
            onClick={onStart}
          >
            {t('start')}
          </Button>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const EmptyState = ({ text }: { text: string }) => (
  <Box
    italic
    textAlign="center"
    color="#b99b7c"
    p={2}
    style={{
      border: '1px dashed #5b1b1f',
      borderRadius: '6px',
      background: 'rgba(24, 6, 7, 0.45)',
    }}
  >
    {text}
  </Box>
);
