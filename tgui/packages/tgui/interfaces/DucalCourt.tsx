import { type CSSProperties, type ReactNode, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  NumberInput,
  Section,
  TextArea,
  Tooltip,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type StatusTone = 'good' | 'warning' | 'bad' | 'neutral';
type ViewId = 'overview' | 'commands' | 'succession' | 'laws';

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

type Texts = {
  window_title: string;
  subtitle: string;
  sections: {
    status: string;
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
};

type RealmColors = {
  primary: string;
  secondary: string;
  fallback: boolean;
};

type Data = {
  texts: Texts;
  realm_type: string;
  realm_colors: RealmColors;
  ruler: string | null;
  regent: string | null;
  viewer_status: string;
  status_cards: StatusCard[];
  rite: RiteData;
  main_actions: DucalAction[];
  tool_actions: DucalAction[];
  rite_actions: DucalAction[];
  law_count: number;
  decree_count: number;
};

const DEFAULT_WINDOW_WIDTH = 1180;
const DEFAULT_WINDOW_HEIGHT = 760;
const COMPACT_WINDOW_WIDTH = 620;
const COMPACT_WINDOW_HEIGHT = 390;

const GOVERNANCE_ACTIONS = [
  'revise_charter',
  'set_taxes',
  'declare_outlaw',
];

const QUICK_TOOL_ACTIONS = [
  'change_colors',
  'summon_crown',
  'summon_key',
  'restore_charter',
  'become_regent',
];
const COURT_WRIT_ACTIONS = ['make_announcement'];

const VIEW_ITEMS: Array<{
  id: ViewId;
  label: string;
  icon: string;
  desc: string;
}> = [
  {
    id: 'overview',
    label: 'Overview',
    icon: 'chess-rook',
    desc: 'Show the current court state without opening any command tools.',
  },
  {
    id: 'commands',
    label: 'Ducal Commands',
    icon: 'crown',
    desc: 'Open public writs, governance commands, and law/decree tools.',
  },
  {
    id: 'succession',
    label: 'Succession',
    icon: 'hourglass-half',
    desc: 'Review the active rite, claimants, supporters, and succession actions.',
  },
  {
    id: 'laws',
    label: 'Laws',
    icon: 'balance-scale',
    desc: 'Open the Set Laws menu directly.',
  },
];

const VOICE_COMMANDS = [
  'Make Announcement',
  'Revise Charter',
  'Make Decree',
  'Purge Decrees',
  'Set Laws',
  'Make Law',
  'Remove Law (number)',
  'Purge Laws',
  'Declare Outlaw',
  'Set Taxes',
  'Change Colors',
  'Become Regent',
  'Summon Crown / Summon Key',
  'I Ascend',
  'I Assent',
  'I Abdicate',
  'Stop Ascent',
];

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

const actionsById = (actions: DucalAction[], ids: string[]) =>
  ids
    .map((id) => actionById(actions, id))
    .filter((action): action is DucalAction => !!action);

const buildRealmStyle = (colors: RealmColors | undefined) =>
  ({
    '--ducal-primary': colors?.primary || '#007fff',
    '--ducal-secondary': colors?.secondary || '#ffffff',
  }) as CSSProperties;

const TooltipFrame = (props: {
  content?: string | null;
  inline?: boolean;
  children: ReactNode;
}) => {
  const { content, inline, children } = props;
  const body = (
    <span
      className={
        'DucalCourt__tooltipFrame' +
        (inline ? ' DucalCourt__tooltipFrame--inline' : '')
      }
    >
      {children}
    </span>
  );

  if (!content) {
    return body;
  }

  return (
    <Tooltip
      content={<span className="DucalCourt__tooltipContent">{content}</span>}
      position="bottom"
    >
      {body}
    </Tooltip>
  );
};

const ActionCard = (props: {
  action: DucalAction;
  compact?: boolean;
  onClick: (action: DucalAction) => void;
}) => {
  const { action, compact, onClick } = props;
  const tooltip = action.enabled ? action.desc : action.disabled_reason;

  return (
    <TooltipFrame content={tooltip || action.desc}>
      <Button
        className={
          'DucalCourt__action' +
          (compact ? ' DucalCourt__action--compact' : '')
        }
        disabled={!action.enabled}
        onClick={() => action.enabled && onClick(action)}
      >
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
      </Button>
    </TooltipFrame>
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

const ActionGroup = (props: {
  title: string;
  actions: DucalAction[];
  compact?: boolean;
  onAction: (action: DucalAction) => void;
}) => {
  const { title, actions, compact, onAction } = props;

  if (!actions.length) {
    return null;
  }

  return (
    <div className="DucalCourt__actionGroup">
      <div className="DucalCourt__actionGroupTitle">{title}</div>
      <div
        className={
          compact ? 'DucalCourt__toolGrid' : 'DucalCourt__actionGrid'
        }
      >
        {actions.map((action) => (
          <ActionCard
            key={action.id}
            action={action}
            compact={compact}
            onClick={onAction}
          />
        ))}
      </div>
    </div>
  );
};

const DucalDesk = (props: {
  texts: Texts;
  actions: DucalAction[];
  lawCount: number;
  mode?: 'all' | 'commands' | 'laws' | 'decrees';
}) => {
  const { act } = useBackend<Data>();
  const { texts, actions, lawCount, mode = 'all' } = props;
  const [text, setText] = useState('');
  const [lawNumber, setLawNumber] = useState(1);
  const trimmed = text.trim();
  const announcement = actionById(actions, 'make_announcement');
  const decree = actionById(actions, 'issue_decree');
  const law = actionById(actions, 'set_laws');
  const purgeLaws = actionById(actions, 'purge_laws') || law;
  const purgeDecrees = actionById(actions, 'purge_decrees');
  const canUseText = trimmed.length > 0;
  const showAnnouncements = mode === 'all';
  const showDecrees = mode !== 'laws';
  const showLaws = mode !== 'decrees';
  const showPurgeDecrees = mode === 'commands' || mode === 'decrees';

  const textTooltip = canUseText ? undefined : texts.composer.empty_text;
  const lawBlocked = law?.disabled_reason || undefined;
  const purgeLawBlocked = purgeLaws?.disabled_reason || lawBlocked;
  const purgeDecreeBlocked = purgeDecrees?.disabled_reason || undefined;
  const sectionTitle =
    mode === 'laws'
      ? 'Law Tools'
      : mode === 'decrees'
        ? 'Decree Tools'
        : mode === 'commands'
          ? 'Law and Decree Tools'
          : texts.sections.desk;

  return (
    <Section title={sectionTitle}>
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
            {showAnnouncements && (
              <TooltipFrame
                inline
                content={
                  announcement?.disabled_reason || textTooltip || announcement?.desc
                }
              >
                <Button
                  icon="bullhorn"
                  disabled={!announcement?.enabled || !canUseText}
                  onClick={() => act('publish_announcement', { text: trimmed })}
                >
                  {texts.composer.publish_announcement}
                </Button>
              </TooltipFrame>
            )}
            {showDecrees && (
              <TooltipFrame
                inline
                content={decree?.disabled_reason || textTooltip || decree?.desc}
              >
                <Button
                  icon="scroll"
                  disabled={!decree?.enabled || !canUseText}
                  onClick={() => act('publish_decree', { text: trimmed })}
                >
                  {texts.composer.publish_decree}
                </Button>
              </TooltipFrame>
            )}
            {showLaws && (
              <TooltipFrame
                inline
                content={lawBlocked || textTooltip || law?.desc}
              >
                <Button
                  icon="balance-scale"
                  disabled={!law?.enabled || !canUseText}
                  onClick={() => act('publish_law', { text: trimmed })}
                >
                  {texts.composer.publish_law}
                </Button>
              </TooltipFrame>
            )}
            {showPurgeDecrees && (
              <TooltipFrame
                inline
                content={purgeDecreeBlocked || purgeDecrees?.desc}
              >
                <Button
                  icon="eraser"
                  color="bad"
                  disabled={!purgeDecrees?.enabled}
                  onClick={() => act('purge_decrees')}
                >
                  Clear Decrees
                </Button>
              </TooltipFrame>
            )}
          </div>
          {showLaws && (
            <div className="DucalCourt__lawTools">
              <span>{texts.composer.law_number}</span>
              <NumberInput
                minValue={1}
                maxValue={Math.max(lawCount, 1)}
                value={lawNumber}
                step={1}
                onChange={(value: number) => setLawNumber(value)}
              />
              <TooltipFrame inline content={lawBlocked || law?.desc}>
                <Button
                  icon="times"
                  disabled={!law?.enabled || lawCount < 1}
                  onClick={() => act('remove_law', { law_number: lawNumber })}
                >
                  {texts.composer.remove_law}
                </Button>
              </TooltipFrame>
              <TooltipFrame inline content={purgeLawBlocked || purgeLaws?.desc}>
                <Button
                  icon="trash"
                  color="bad"
                  disabled={!purgeLaws?.enabled || lawCount < 1}
                  onClick={() => act('purge_laws')}
                >
                  {texts.composer.clear_laws}
                </Button>
              </TooltipFrame>
            </div>
          )}
        </div>
      </div>
    </Section>
  );
};

const CompactCourt = (props: {
  texts: Texts;
  rite: RiteData;
  statusCards: StatusCard[];
  onRestore: () => void;
}) => {
  const { texts, rite, statusCards, onRestore } = props;
  const compactCards = statusCards.filter((card) =>
    [
      'throne_status',
      'active_rite',
      'realm_stability',
      'current_ruler',
    ].includes(card.id),
  );

  return (
    <div className="DucalCourt__compactBody">
      <StatusGrid cards={compactCards} />
      <div className="DucalCourt__compactSummary">
        <div>
          <b>{texts.labels.rite_status}</b>
          <span>{rite.name}</span>
        </div>
        <div>
          <b>{texts.labels.time_remaining}</b>
          <span>{rite.time_remaining || texts.labels.none}</span>
        </div>
        <Box className="DucalCourt__riteStatus">{rite.status}</Box>
        <TooltipFrame content="Restore the full court layout with navigation and command panels.">
          <Button icon="expand" onClick={onRestore}>
            Restore Court
          </Button>
        </TooltipFrame>
      </div>
    </div>
  );
};

const OverviewPanel = (props: {
  texts: Texts;
  rite: RiteData;
  lawCount: number;
  decreeCount: number;
}) => {
  const { texts, rite, lawCount, decreeCount } = props;

  return (
    <Section title="Court Overview">
      <div className="DucalCourt__overviewFacts">
        <div className="DucalCourt__overviewFact">
          <b>{texts.labels.rite_status}</b>
          <span>{rite.name}</span>
        </div>
        <div className="DucalCourt__overviewFact">
          <b>{texts.labels.claimant}</b>
          <span>{rite.claimant || texts.labels.none}</span>
        </div>
        <div className="DucalCourt__overviewFact">
          <b>{texts.labels.contester}</b>
          <span>{rite.contester || texts.labels.none}</span>
        </div>
        <div className="DucalCourt__overviewFact">
          <b>{texts.labels.supporters}</b>
          <span>{rite.supporters}</span>
        </div>
        <div className="DucalCourt__overviewFact">
          <b>{texts.labels.time_remaining}</b>
          <span>{rite.time_remaining || texts.labels.none}</span>
        </div>
        <div className="DucalCourt__overviewFact">
          <b>Charter Ledger</b>
          <span>
            {lawCount} laws / {decreeCount} decrees
          </span>
        </div>
      </div>
      <Box className="DucalCourt__riteStatus">{rite.status}</Box>
    </Section>
  );
};

const LeftRail = (props: {
  activeView: ViewId;
  lawAction?: DucalAction;
  onAction: (action: DucalAction) => void;
  onView: (view: ViewId) => void;
}) => {
  const { activeView, lawAction, onAction, onView } = props;

  return (
    <aside className="DucalCourt__leftRail">
      <div className="DucalCourt__throneEmblem">
        <Icon name="chess-rook" />
      </div>
      <nav className="DucalCourt__nav">
        {VIEW_ITEMS.map((item) => {
          const opensSetLaws = item.id === 'laws';
          const tooltip = opensSetLaws
            ? lawAction?.disabled_reason || lawAction?.desc || item.desc
            : item.desc;

          return (
            <TooltipFrame key={item.id} content={tooltip}>
              <Button
                className={
                  'DucalCourt__navButton' +
                  (!opensSetLaws && activeView === item.id
                    ? ' DucalCourt__navButton--active'
                    : '')
                }
                disabled={opensSetLaws && !lawAction?.enabled}
                icon={item.icon}
                onClick={() =>
                  opensSetLaws && lawAction
                    ? onAction(lawAction)
                    : onView(item.id)
                }
              >
                {item.label}
              </Button>
            </TooltipFrame>
          );
        })}
      </nav>
    </aside>
  );
};

const RightRail = (props: {
  tools: DucalAction[];
  onAction: (action: DucalAction) => void;
}) => {
  const { tools, onAction } = props;

  return (
    <aside className="DucalCourt__rightRail">
      <Section title="Quick Tools">
        <div className="DucalCourt__quickTools">
          {tools.map((action) => (
            <ActionCard
              key={action.id}
              action={action}
              compact
              onClick={onAction}
            />
          ))}
        </div>
      </Section>
      <Section title="Voice Commands">
        <ul className="DucalCourt__voiceList">
          {VOICE_COMMANDS.map((command) => (
            <li key={command}>{command}</li>
          ))}
        </ul>
      </Section>
    </aside>
  );
};

const CourtCommands = (props: {
  texts: Texts;
  deskActions: DucalAction[];
  writActions: DucalAction[];
  governanceActions: DucalAction[];
  lawCount: number;
  onAction: (action: DucalAction) => void;
}) => {
  const {
    texts,
    deskActions,
    writActions,
    governanceActions,
    lawCount,
    onAction,
  } = props;

  return (
    <>
      <Section title="Ducal Commands">
        <div className="DucalCourt__actionGroups">
          <ActionGroup
            title="Public Writs"
            actions={writActions}
            onAction={onAction}
          />
          <ActionGroup
            title="Governance"
            actions={governanceActions}
            onAction={onAction}
          />
        </div>
      </Section>
      <DucalDesk
        texts={texts}
        actions={deskActions}
        lawCount={lawCount}
        mode="commands"
      />
    </>
  );
};

export const DucalCourt = () => {
  const { act, data } = useBackend<Data>();
  const [compact, setCompact] = useState(false);
  const [activeView, setActiveView] = useState<ViewId>('overview');
  const {
    texts,
    realm_type,
    realm_colors,
    ruler,
    regent,
    viewer_status,
    status_cards = [],
    rite,
    main_actions = [],
    tool_actions = [],
    rite_actions = [],
    law_count = 0,
    decree_count = 0,
  } = data;

  const handleAction = (action: DucalAction) => act(action.id);
  const realmStyle = buildRealmStyle(realm_colors);
  const allActions = [...main_actions, ...tool_actions];
  const writActions = actionsById(main_actions, COURT_WRIT_ACTIONS);
  const governanceActions = actionsById(main_actions, GOVERNANCE_ACTIONS);
  const quickToolActions = actionsById(tool_actions, QUICK_TOOL_ACTIONS);
  const setLawsAction = actionById(main_actions, 'set_laws');
  const windowWidth = compact ? COMPACT_WINDOW_WIDTH : DEFAULT_WINDOW_WIDTH;
  const windowHeight = compact ? COMPACT_WINDOW_HEIGHT : DEFAULT_WINDOW_HEIGHT;
  const commandPanel = (
    <CourtCommands
      texts={texts}
      deskActions={allActions}
      writActions={writActions}
      governanceActions={governanceActions}
      lawCount={law_count}
      onAction={handleAction}
    />
  );
  const successionPanel = (
    <SuccessionPanel
      texts={texts}
      rite={rite}
      actions={rite_actions}
      onAction={handleAction}
    />
  );
  const overviewPanel = (
    <OverviewPanel
      texts={texts}
      rite={rite}
      lawCount={law_count}
      decreeCount={decree_count}
    />
  );
  const activeContent = (() => {
    switch (activeView) {
      case 'commands':
        return commandPanel;
      case 'succession':
        return successionPanel;
      default:
        return overviewPanel;
    }
  })();
  const windowToggle = (
    <Button
      color="transparent"
      icon={compact ? 'expand' : 'window-minimize-o'}
      tooltip={
        compact
          ? 'Restore the court window.'
          : 'Collapse to a compact court summary.'
      }
      tooltipPosition="bottom"
      onClick={() => setCompact(!compact)}
    />
  );

  return (
    <Window
      width={windowWidth}
      height={windowHeight}
      title={texts.window_title}
      theme="parchment"
      buttons={windowToggle}
    >
      <Window.Content
        fitted
        className={'DucalCourt' + (compact ? ' DucalCourt--compact' : '')}
      >
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

          {compact ? (
            <CompactCourt
              texts={texts}
              rite={rite}
              statusCards={status_cards}
              onRestore={() => setCompact(false)}
            />
          ) : (
            <div className="DucalCourt__courtShell">
              <LeftRail
                activeView={activeView}
                lawAction={setLawsAction}
                onAction={handleAction}
                onView={setActiveView}
              />
              <main className="DucalCourt__centerPanel">
                <StatusGrid cards={status_cards} />
                <div className="DucalCourt__contentStack">
                  {activeContent}
                </div>
              </main>
              <RightRail tools={quickToolActions} onAction={handleAction} />
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
