import { type CSSProperties, useEffect, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  NumberInput,
  Section,
  TextArea,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type StatusTone = 'good' | 'warning' | 'bad' | 'neutral';

type StatusCard = {
  id: string;
  label: string;
  value: string;
  detail: string;
  tone: StatusTone;
};

type DucalAction = {
  id: string;
  label: string;
  desc: string;
  requirements: string[];
  enabled: boolean;
  disabled_reason: string | null;
};

type Callout = {
  text: string;
  tone: StatusTone;
};

type RiteData = {
  active: boolean;
  name: string;
  stage: 'none' | 'gathering' | 'contesting' | 'resolution';
  stage_label: string;
  status: string;
  claimant: string | null;
  contester: string | null;
  supporters: number;
  time_remaining: string | null;
};

type MapPoint = {
  id: string;
  label: string;
  x: number;
  y: number;
  type: string;
};

type MapLegend = {
  label: string;
  class_name: string;
};

type Texts = {
  window_title: string;
  subtitle: string;
  sections: {
    status: string;
    map: string;
    main: string;
    tools: string;
    succession: string;
    desk: string;
  };
  composer: {
    placeholder: string;
    publish_announcement: string;
    publish_decree: string;
    publish_law: string;
    law_number: string;
    remove_law: string;
    clear_laws: string;
    empty_text: string;
  };
  labels: {
    ruler: string;
    regent: string;
    claimant: string;
    contester: string;
    supporters: string;
    time_remaining: string;
    rite_status: string;
    no_regent: string;
    none: string;
    viewer: string;
    requirements: string;
  };
  rite_steps: string[];
  map_legend: MapLegend[];
  map_points: MapPoint[];
};

type RealmColors = {
  primary: string;
  secondary: string;
  fallback: boolean;
};

type Data = {
  texts: Texts;
  realm_name: string;
  realm_type: string;
  realm_colors: RealmColors;
  ruler: string | null;
  regent: string | null;
  viewer_status: string;
  status_cards: StatusCard[];
  callouts: Callout[];
  rite: RiteData;
  main_actions: DucalAction[];
  tool_actions: DucalAction[];
  rite_actions: DucalAction[];
  law_count: number;
  decree_count: number;
};

const MIN_WINDOW_WIDTH = 640;
const MIN_WINDOW_HEIGHT = 520;
const WINDOW_MARGIN = 28;

const ACTION_ICONS: Record<string, string> = {
  make_announcement: 'bullhorn',
  revise_charter: 'feather-alt',
  issue_decree: 'scroll',
  set_laws: 'balance-scale',
  set_taxes: 'coins',
  declare_outlaw: 'user-slash',
  change_colors: 'palette',
  summon_crown: 'crown',
  summon_key: 'key',
  restore_charter: 'book',
  purge_laws: 'trash',
  purge_decrees: 'eraser',
  become_regent: 'chess-king',
  ascend: 'crown',
  assent: 'handshake',
  abdicate: 'sign-out-alt',
  stop_ascent: 'hand-paper',
};

const STATUS_ICONS: Record<string, string> = {
  throne_status: 'chess-rook',
  crown_required: 'crown',
  active_rite: 'hourglass-half',
  realm_stability: 'shield-alt',
  current_ruler: 'user-tie',
};

const getStageIndex = (stage: RiteData['stage']) => {
  if (stage === 'gathering') return 0;
  if (stage === 'contesting') return 1;
  if (stage === 'resolution') return 2;
  return -1;
};

const actionById = (actions: DucalAction[], id: string) =>
  actions.find((action) => action.id === id);

const buildRealmStyle = (colors: RealmColors | undefined) =>
  ({
    '--ducal-primary': colors?.primary || '#007fff',
    '--ducal-secondary': colors?.secondary || '#ffffff',
  }) as CSSProperties;

const getDucalWindowSize = () => {
  const screenWidth = window.screen?.availWidth || window.innerWidth || 1280;
  const screenHeight = window.screen?.availHeight || window.innerHeight || 900;

  return {
    width: Math.max(MIN_WINDOW_WIDTH, screenWidth - WINDOW_MARGIN),
    height: Math.max(MIN_WINDOW_HEIGHT, screenHeight - WINDOW_MARGIN),
  };
};

const useDucalWindowSize = () => {
  const [size, setSize] = useState(getDucalWindowSize);

  useEffect(() => {
    const updateSize = () => setSize(getDucalWindowSize());

    window.addEventListener('resize', updateSize);

    return () => {
      window.removeEventListener('resize', updateSize);
    };
  }, []);

  return size;
};

const ActionCard = (props: {
  action: DucalAction;
  compact?: boolean;
  onClick: (action: DucalAction) => void;
}) => {
  const { action, compact, onClick } = props;
  const tooltip = action.enabled ? action.desc : action.disabled_reason;

  return (
    <Button
      className={
        'DucalCourt__action' +
        (compact ? ' DucalCourt__action--compact' : '')
      }
      disabled={!action.enabled}
      tooltip={tooltip || undefined}
      onClick={() => action.enabled && onClick(action)}
    >
      <span className="DucalCourt__actionPin" />
      <span className="DucalCourt__actionIcon">
        <Icon name={ACTION_ICONS[action.id] || 'circle'} />
      </span>
      <span className="DucalCourt__actionBody">
        <span className="DucalCourt__actionTitle">{action.label}</span>
        {!compact && (
          <span className="DucalCourt__actionDesc">{action.desc}</span>
        )}
        <span className="DucalCourt__badges">
          {action.requirements.map((requirement) => (
            <span className="DucalCourt__badge" key={requirement}>
              {requirement}
            </span>
          ))}
        </span>
      </span>
      <span className="DucalCourt__actionSeal" />
    </Button>
  );
};

const StatusGrid = (props: { cards: StatusCard[] }) => (
  <div className="DucalCourt__statusGrid">
    {props.cards.map((card) => (
      <div
        key={card.id}
        className={`DucalCourt__statusCard DucalCourt__statusCard--${card.tone}`}
      >
        <div className="DucalCourt__statusIcon">
          <Icon name={STATUS_ICONS[card.id] || 'circle'} />
        </div>
        <div className="DucalCourt__statusBody">
          <div className="DucalCourt__statusLabel">{card.label}</div>
          <div className="DucalCourt__statusValue">{card.value}</div>
          <div className="DucalCourt__statusDetail">{card.detail}</div>
        </div>
      </div>
    ))}
  </div>
);

const WarMap = (props: {
  texts: Texts;
  callouts: Callout[];
  realmName: string;
}) => {
  const { texts, callouts, realmName } = props;

  return (
    <Section title={texts.sections.map}>
      <div className="DucalCourt__map">
        <div className="DucalCourt__mapSea" />
        <div className="DucalCourt__mapLand" />
        <div className="DucalCourt__mapCompass">
          <Icon name="location-arrow" />
        </div>
        <div className="DucalCourt__mapToken DucalCourt__mapToken--crown">
          <Icon name="crown" />
        </div>
        <div className="DucalCourt__mapToken DucalCourt__mapToken--guard">
          <Icon name="shield-alt" />
        </div>
        <div className="DucalCourt__mapToken DucalCourt__mapToken--seal">
          <Icon name="certificate" />
        </div>
        <div className="DucalCourt__mapRidge DucalCourt__mapRidge--north" />
        <div className="DucalCourt__mapRidge DucalCourt__mapRidge--south" />
        <div className="DucalCourt__mapRoad DucalCourt__mapRoad--main" />
        <div className="DucalCourt__mapRoad DucalCourt__mapRoad--west" />
        <div className="DucalCourt__mapRiver" />
        {texts.map_points.map((point) => (
          <div
            key={point.id}
            className={`DucalCourt__mapPoint DucalCourt__mapPoint--${point.type}`}
            style={{ left: `${point.x}%`, top: `${point.y}%` }}
          >
            <span>{point.label}</span>
          </div>
        ))}
        <div className="DucalCourt__mapTitle">{realmName}</div>
        <div className="DucalCourt__mapCallouts">
          {callouts.map((callout) => (
            <div
              key={callout.text}
              className={`DucalCourt__callout DucalCourt__callout--${callout.tone}`}
            >
              {callout.text}
            </div>
          ))}
        </div>
        <div className="DucalCourt__mapLegend">
          {texts.map_legend.map((entry) => (
            <span key={entry.label}>
              <i className={`DucalCourt__legendKey DucalCourt__legendKey--${entry.class_name}`} />
              {entry.label}
            </span>
          ))}
        </div>
      </div>
    </Section>
  );
};

const SuccessionPanel = (props: {
  texts: Texts;
  rite: RiteData;
  actions: DucalAction[];
  onAction: (action: DucalAction) => void;
}) => {
  const { texts, rite, actions, onAction } = props;
  const activeStep = getStageIndex(rite.stage);

  return (
    <Section title={texts.sections.succession}>
      <div className="DucalCourt__riteName">{rite.name}</div>
      <div className="DucalCourt__stepper">
        {texts.rite_steps.map((step, index) => (
          <div
            key={step}
            className={
              'DucalCourt__step' +
              (index <= activeStep ? ' DucalCourt__step--active' : '')
            }
          >
            <span>{index + 1}</span>
            {step}
          </div>
        ))}
      </div>
      <div className="DucalCourt__riteFacts">
        <div>
          <b>{texts.labels.claimant}</b>
          <span>{rite.claimant || texts.labels.none}</span>
        </div>
        <div>
          <b>{texts.labels.contester}</b>
          <span>{rite.contester || texts.labels.none}</span>
        </div>
        <div>
          <b>{texts.labels.supporters}</b>
          <span>{rite.supporters}</span>
        </div>
        <div>
          <b>{texts.labels.time_remaining}</b>
          <span>{rite.time_remaining || texts.labels.none}</span>
        </div>
      </div>
      <Box className="DucalCourt__riteStatus">{rite.status}</Box>
      <div className="DucalCourt__riteActionGrid">
        {actions.map((action) => (
          <ActionCard
            key={action.id}
            action={action}
            compact
            onClick={onAction}
          />
        ))}
      </div>
    </Section>
  );
};

const DucalDesk = (props: {
  texts: Texts;
  actions: DucalAction[];
  lawCount: number;
}) => {
  const { act } = useBackend<Data>();
  const { texts, actions, lawCount } = props;
  const [text, setText] = useState('');
  const [lawNumber, setLawNumber] = useState(1);
  const trimmed = text.trim();
  const announcement = actionById(actions, 'make_announcement');
  const decree = actionById(actions, 'issue_decree');
  const law = actionById(actions, 'set_laws');
  const canUseText = trimmed.length > 0;

  const textTooltip = canUseText ? undefined : texts.composer.empty_text;
  const lawBlocked = law?.disabled_reason || undefined;

  return (
    <Section title={texts.sections.desk}>
      <div className="DucalCourt__desk">
        <TextArea
          fluid
          height="46px"
          maxLength={500}
          placeholder={texts.composer.placeholder}
          value={text}
          onChange={(value: string) => setText(value)}
          dontUseTabForIndent
        />
        <div className="DucalCourt__deskFooter">
          <div className="DucalCourt__deskButtons">
            <Button
              icon="bullhorn"
              disabled={!announcement?.enabled || !canUseText}
              tooltip={
                announcement?.disabled_reason || textTooltip || announcement?.desc
              }
              onClick={() => act('publish_announcement', { text: trimmed })}
            >
              {texts.composer.publish_announcement}
            </Button>
            <Button
              icon="scroll"
              disabled={!decree?.enabled || !canUseText}
              tooltip={decree?.disabled_reason || textTooltip || decree?.desc}
              onClick={() => act('publish_decree', { text: trimmed })}
            >
              {texts.composer.publish_decree}
            </Button>
            <Button
              icon="balance-scale"
              disabled={!law?.enabled || !canUseText}
              tooltip={lawBlocked || textTooltip || law?.desc}
              onClick={() => act('publish_law', { text: trimmed })}
            >
              {texts.composer.publish_law}
            </Button>
          </div>
          <div className="DucalCourt__lawTools">
            <span>{texts.composer.law_number}</span>
            <NumberInput
              minValue={1}
              maxValue={Math.max(lawCount, 1)}
              value={lawNumber}
              step={1}
              onChange={(value: number) => setLawNumber(value)}
            />
            <Button
              icon="times"
              disabled={!law?.enabled || lawCount < 1}
              tooltip={lawBlocked}
              onClick={() => act('remove_law', { law_number: lawNumber })}
            >
              {texts.composer.remove_law}
            </Button>
            <Button
              icon="trash"
              color="bad"
              disabled={!law?.enabled || lawCount < 1}
              tooltip={lawBlocked}
              onClick={() => act('purge_laws')}
            >
              {texts.composer.clear_laws}
            </Button>
          </div>
        </div>
      </div>
    </Section>
  );
};

export const DucalCourt = () => {
  const { act, data } = useBackend<Data>();
  const {
    texts,
    realm_name,
    realm_type,
    realm_colors,
    ruler,
    regent,
    viewer_status,
    status_cards = [],
    callouts = [],
    rite,
    main_actions = [],
    tool_actions = [],
    rite_actions = [],
    law_count = 0,
  } = data;

  const handleAction = (action: DucalAction) => act(action.id);
  const windowSize = useDucalWindowSize();
  const realmStyle = buildRealmStyle(realm_colors);

  return (
    <Window
      width={windowSize.width}
      height={windowSize.height}
      title={texts.window_title}
      theme="parchment"
    >
      <Window.Content fitted className="DucalCourt">
        <div className="DucalCourt__board" style={realmStyle}>
          <div className="DucalCourt__titleRow">
            <div className="DucalCourt__standard DucalCourt__standard--left">
              <Icon name="crown" />
            </div>
            <div className="DucalCourt__standard DucalCourt__standard--right">
              <Icon name="chess-rook" />
            </div>
            <div>
              <div className="DucalCourt__eyebrow">{realm_type}</div>
              <div className="DucalCourt__title">{texts.window_title}</div>
              <div className="DucalCourt__subtitle">{texts.subtitle}</div>
            </div>
            <div className="DucalCourt__rulerBlock">
              <div>
                <b>{texts.labels.ruler}</b>
                <span>{ruler || texts.labels.none}</span>
              </div>
              <div>
                <b>{texts.labels.regent}</b>
                <span>{regent || texts.labels.no_regent}</span>
              </div>
              <div>
                <b>{texts.labels.viewer}</b>
                <span>{viewer_status}</span>
              </div>
            </div>
          </div>

          <StatusGrid cards={status_cards} />

          <div className="DucalCourt__layout">
            <div className="DucalCourt__mainColumn">
              <WarMap
                texts={texts}
                callouts={callouts}
                realmName={realm_name}
              />
              <Section title={texts.sections.main}>
                <div className="DucalCourt__actionGrid">
                  {main_actions.map((action) => (
                    <ActionCard
                      key={action.id}
                      action={action}
                      onClick={handleAction}
                    />
                  ))}
                </div>
              </Section>
              <DucalDesk
                texts={texts}
                actions={main_actions}
                lawCount={law_count}
              />
            </div>

            <div className="DucalCourt__sideColumn">
              <SuccessionPanel
                texts={texts}
                rite={rite}
                actions={rite_actions}
                onAction={handleAction}
              />
              <Section title={texts.sections.tools}>
                <div className="DucalCourt__toolGrid">
                  {tool_actions.map((action) => (
                    <ActionCard
                      key={action.id}
                      action={action}
                      compact
                      onClick={handleAction}
                    />
                  ))}
                </div>
              </Section>
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
