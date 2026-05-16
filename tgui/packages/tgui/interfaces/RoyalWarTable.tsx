import { type CSSProperties, useEffect, useRef, useState } from 'react';
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

type RoyalAction = {
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
  main_actions: RoyalAction[];
  tool_actions: RoyalAction[];
  rite_actions: RoyalAction[];
  law_count: number;
  decree_count: number;
};

const BASE_WIDTH = 1180;
const BASE_HEIGHT = 760;

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

const actionById = (actions: RoyalAction[], id: string) =>
  actions.find((action) => action.id === id);

const buildRealmStyle = (colors: RealmColors | undefined) =>
  ({
    '--royal-primary': colors?.primary || '#007fff',
    '--royal-secondary': colors?.secondary || '#ffffff',
  }) as CSSProperties;

const useFitScale = () => {
  const frameRef = useRef<HTMLDivElement>(null);
  const [scale, setScale] = useState(1);

  useEffect(() => {
    const frame = frameRef.current;
    if (!frame) {
      return;
    }

    const updateScale = () => {
      const rect = frame.getBoundingClientRect();
      if (!rect.width || !rect.height) {
        return;
      }
      const nextScale = Math.min(
        rect.width / BASE_WIDTH,
        rect.height / BASE_HEIGHT,
      );
      setScale(Math.max(0.1, nextScale));
    };

    updateScale();
    const resizeObserver =
      typeof ResizeObserver !== 'undefined'
        ? new ResizeObserver(updateScale)
        : null;
    resizeObserver?.observe(frame);
    window.addEventListener('resize', updateScale);

    return () => {
      resizeObserver?.disconnect();
      window.removeEventListener('resize', updateScale);
    };
  }, []);

  return { frameRef, scale };
};

const ActionCard = (props: {
  action: RoyalAction;
  compact?: boolean;
  onClick: (action: RoyalAction) => void;
}) => {
  const { action, compact, onClick } = props;
  const tooltip = action.enabled ? action.desc : action.disabled_reason;

  return (
    <Button
      className={
        'RoyalWarTable__action' +
        (compact ? ' RoyalWarTable__action--compact' : '')
      }
      disabled={!action.enabled}
      tooltip={tooltip || undefined}
      onClick={() => action.enabled && onClick(action)}
    >
      <span className="RoyalWarTable__actionPin" />
      <span className="RoyalWarTable__actionIcon">
        <Icon name={ACTION_ICONS[action.id] || 'circle'} />
      </span>
      <span className="RoyalWarTable__actionBody">
        <span className="RoyalWarTable__actionTitle">{action.label}</span>
        {!compact && (
          <span className="RoyalWarTable__actionDesc">{action.desc}</span>
        )}
        <span className="RoyalWarTable__badges">
          {action.requirements.map((requirement) => (
            <span className="RoyalWarTable__badge" key={requirement}>
              {requirement}
            </span>
          ))}
        </span>
      </span>
      <span className="RoyalWarTable__actionSeal" />
    </Button>
  );
};

const StatusGrid = (props: { cards: StatusCard[] }) => (
  <div className="RoyalWarTable__statusGrid">
    {props.cards.map((card) => (
      <div
        key={card.id}
        className={`RoyalWarTable__statusCard RoyalWarTable__statusCard--${card.tone}`}
      >
        <div className="RoyalWarTable__statusIcon">
          <Icon name={STATUS_ICONS[card.id] || 'circle'} />
        </div>
        <div className="RoyalWarTable__statusBody">
          <div className="RoyalWarTable__statusLabel">{card.label}</div>
          <div className="RoyalWarTable__statusValue">{card.value}</div>
          <div className="RoyalWarTable__statusDetail">{card.detail}</div>
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
      <div className="RoyalWarTable__map">
        <div className="RoyalWarTable__mapSea" />
        <div className="RoyalWarTable__mapLand" />
        <div className="RoyalWarTable__mapCompass">
          <Icon name="location-arrow" />
        </div>
        <div className="RoyalWarTable__mapToken RoyalWarTable__mapToken--crown">
          <Icon name="crown" />
        </div>
        <div className="RoyalWarTable__mapToken RoyalWarTable__mapToken--guard">
          <Icon name="shield-alt" />
        </div>
        <div className="RoyalWarTable__mapToken RoyalWarTable__mapToken--seal">
          <Icon name="certificate" />
        </div>
        <div className="RoyalWarTable__mapRidge RoyalWarTable__mapRidge--north" />
        <div className="RoyalWarTable__mapRidge RoyalWarTable__mapRidge--south" />
        <div className="RoyalWarTable__mapRoad RoyalWarTable__mapRoad--main" />
        <div className="RoyalWarTable__mapRoad RoyalWarTable__mapRoad--west" />
        <div className="RoyalWarTable__mapRiver" />
        {texts.map_points.map((point) => (
          <div
            key={point.id}
            className={`RoyalWarTable__mapPoint RoyalWarTable__mapPoint--${point.type}`}
            style={{ left: `${point.x}%`, top: `${point.y}%` }}
          >
            <span>{point.label}</span>
          </div>
        ))}
        <div className="RoyalWarTable__mapTitle">{realmName}</div>
        <div className="RoyalWarTable__mapCallouts">
          {callouts.map((callout) => (
            <div
              key={callout.text}
              className={`RoyalWarTable__callout RoyalWarTable__callout--${callout.tone}`}
            >
              {callout.text}
            </div>
          ))}
        </div>
        <div className="RoyalWarTable__mapLegend">
          {texts.map_legend.map((entry) => (
            <span key={entry.label}>
              <i className={`RoyalWarTable__legendKey RoyalWarTable__legendKey--${entry.class_name}`} />
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
  actions: RoyalAction[];
  onAction: (action: RoyalAction) => void;
}) => {
  const { texts, rite, actions, onAction } = props;
  const activeStep = getStageIndex(rite.stage);

  return (
    <Section title={texts.sections.succession}>
      <div className="RoyalWarTable__riteName">{rite.name}</div>
      <div className="RoyalWarTable__stepper">
        {texts.rite_steps.map((step, index) => (
          <div
            key={step}
            className={
              'RoyalWarTable__step' +
              (index <= activeStep ? ' RoyalWarTable__step--active' : '')
            }
          >
            <span>{index + 1}</span>
            {step}
          </div>
        ))}
      </div>
      <div className="RoyalWarTable__riteFacts">
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
      <Box className="RoyalWarTable__riteStatus">{rite.status}</Box>
      <div className="RoyalWarTable__riteActionGrid">
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

const RoyalDesk = (props: {
  texts: Texts;
  actions: RoyalAction[];
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
      <div className="RoyalWarTable__desk">
        <TextArea
          fluid
          height="46px"
          maxLength={500}
          placeholder={texts.composer.placeholder}
          value={text}
          onChange={(value: string) => setText(value)}
          dontUseTabForIndent
        />
        <div className="RoyalWarTable__deskFooter">
          <div className="RoyalWarTable__deskButtons">
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
          <div className="RoyalWarTable__lawTools">
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

export const RoyalWarTable = () => {
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

  const handleAction = (action: RoyalAction) => act(action.id);
  const { frameRef, scale } = useFitScale();
  const realmStyle = buildRealmStyle(realm_colors);
  const boardStyle = {
    ...realmStyle,
    transform: `translate(-50%, -50%) scale(${scale})`,
  } as CSSProperties;

  return (
    <Window
      width={BASE_WIDTH}
      height={BASE_HEIGHT + 32}
      title={texts.window_title}
      theme="parchment"
    >
      <Window.Content fitted className="RoyalWarTable">
        <div className="RoyalWarTable__scaleFrame" ref={frameRef}>
          <div className="RoyalWarTable__board" style={boardStyle}>
            <div className="RoyalWarTable__titleRow">
              <div className="RoyalWarTable__standard RoyalWarTable__standard--left">
                <Icon name="crown" />
              </div>
              <div className="RoyalWarTable__standard RoyalWarTable__standard--right">
                <Icon name="chess-rook" />
              </div>
              <div>
                <div className="RoyalWarTable__eyebrow">{realm_type}</div>
                <div className="RoyalWarTable__title">{texts.window_title}</div>
                <div className="RoyalWarTable__subtitle">{texts.subtitle}</div>
              </div>
              <div className="RoyalWarTable__rulerBlock">
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

            <div className="RoyalWarTable__layout">
              <div className="RoyalWarTable__mainColumn">
                <WarMap
                  texts={texts}
                  callouts={callouts}
                  realmName={realm_name}
                />
                <Section title={texts.sections.main}>
                  <div className="RoyalWarTable__actionGrid">
                    {main_actions.map((action) => (
                      <ActionCard
                        key={action.id}
                        action={action}
                        onClick={handleAction}
                      />
                    ))}
                  </div>
                </Section>
                <RoyalDesk
                  texts={texts}
                  actions={main_actions}
                  lawCount={law_count}
                />
              </div>

              <div className="RoyalWarTable__sideColumn">
                <SuccessionPanel
                  texts={texts}
                  rite={rite}
                  actions={rite_actions}
                  onAction={handleAction}
                />
                <Section title={texts.sections.tools}>
                  <div className="RoyalWarTable__toolGrid">
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
        </div>
      </Window.Content>
    </Window>
  );
};
