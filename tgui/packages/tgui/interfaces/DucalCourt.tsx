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

type ActionText = {
  label: string;
  desc: string;
};

type StatusCardText = {
  label: string;
  values?: Record<string, string>;
  details?: Record<string, string>;
};

export type DucalCourtTexts = {
  window_title: string;
  subtitle: string;
  sections: {
    status: string;
    main: string;
    tools: string;
    succession: string;
    desk: string;
    overview: string;
    commands: string;
    public_writs: string;
    governance: string;
    law_tools: string;
    decree_tools: string;
    law_decree_tools: string;
    quick_tools: string;
    voice_commands: string;
  };
  composer: {
    placeholder: string;
    publish_announcement: string;
    publish_decree: string;
    publish_law: string;
    law_number: string;
    remove_law: string;
    clear_laws: string;
    clear_decrees: string;
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
    charter_ledger: string;
    laws: string;
    decrees: string;
  };
  compact: {
    collapse_tooltip: string;
    restore_tooltip: string;
    restore_button: string;
  };
  viewer_statuses: Record<string, string>;
  views: Record<ViewId, ActionText>;
  actions: Record<string, ActionText>;
  requirements: Record<string, string>;
  disabled_reasons: Record<string, string>;
  status_cards: Record<string, StatusCardText>;
  rite_names: Record<string, string>;
  rite_statuses: Record<string, string>;
  rite_steps: string[];
  voice_command_descriptions: Record<string, string>;
};

type RealmColors = {
  primary: string;
  secondary: string;
  fallback: boolean;
};

type Data = {
  language?: string;
  locale?: string;
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

export const DUCAL_COURT_TEXTS: DucalCourtTexts = {
  window_title: 'Ducal Court',
  subtitle: 'Hold court from the throne of Azure Peak',
  sections: {
    status: 'Court Status',
    main: 'Court Business',
    tools: 'Ducal Tools',
    succession: 'Succession and Usurpation',
    desk: 'Court Scribe Desk',
    overview: 'Court Overview',
    commands: 'Ducal Commands',
    public_writs: 'Public Writs',
    governance: 'Governance',
    law_tools: 'Law Tools',
    decree_tools: 'Decree Tools',
    law_decree_tools: 'Law and Decree Tools',
    quick_tools: 'Quick Tools',
    voice_commands: 'Voice Commands',
  },
  composer: {
    placeholder: 'Draft an announcement, decree, or new law...',
    publish_announcement: 'Publish Announcement',
    publish_decree: 'Issue Decree',
    publish_law: 'Add Law',
    law_number: 'Law #',
    remove_law: 'Remove Law',
    clear_laws: 'Clear All Laws',
    clear_decrees: 'Clear Decrees',
    empty_text: 'Write text before publishing.',
  },
  labels: {
    ruler: 'Current Ruler',
    regent: 'Regent',
    claimant: 'Claimant',
    contester: 'Contester',
    supporters: 'Supporters',
    time_remaining: 'Time Remaining',
    rite_status: 'Rite Status',
    no_regent: 'None',
    none: 'None',
    viewer: 'Your Standing',
    requirements: 'Requirements',
    charter_ledger: 'Charter Ledger',
    laws: 'laws',
    decrees: 'decrees',
  },
  compact: {
    collapse_tooltip: 'Collapse to a compact court summary.',
    restore_tooltip:
      'Restore the full court layout with navigation and command panels.',
    restore_button: 'Restore Court',
  },
  viewer_statuses: {
    'Ducal Authority': 'Ducal Authority',
    'Crown Bearer': 'Crown Bearer',
    Subject: 'Subject',
    Observer: 'Observer',
  },
  views: {
    overview: {
      label: 'Overview',
      desc: 'Show the current court state without opening any command tools.',
    },
    commands: {
      label: 'Ducal Commands',
      desc: 'Open public writs, governance commands, and law/decree tools.',
    },
    succession: {
      label: 'Succession',
      desc: 'Review the active rite, claimants, supporters, and succession actions.',
    },
    laws: {
      label: 'Laws',
      desc: 'Open the Set Laws menu directly.',
    },
  },
  actions: {
    make_announcement: {
      label: 'Make Announcement',
      desc: 'Broadcast a realm-wide message.',
    },
    revise_charter: {
      label: 'Revise Charter',
      desc: 'Open the charter ledger.',
    },
    issue_decree: {
      label: 'Issue Decree',
      desc: 'Proclaim a ducal decree.',
    },
    set_laws: {
      label: 'Set Laws',
      desc: 'Rewrite the laws of the land.',
    },
    set_taxes: {
      label: 'Set Taxes',
      desc: 'Adjust levies and poll taxes.',
    },
    declare_outlaw: {
      label: 'Declare Outlaw',
      desc: 'Outlaw or pardon a named subject.',
    },
    change_colors: {
      label: 'Change Colors',
      desc: 'Change the ducal colors.',
    },
    summon_crown: {
      label: 'Summon Crown',
      desc: 'Retrieve the crown if law permits.',
    },
    summon_key: {
      label: 'Summon Key',
      desc: 'Retrieve the ducal key.',
    },
    restore_charter: {
      label: 'Restore Charter',
      desc: 'Open charters to restore suspended writs.',
    },
    purge_laws: {
      label: 'Purge Laws',
      desc: 'Remove every current law.',
    },
    purge_decrees: {
      label: 'Purge Decrees',
      desc: 'Remove every decree.',
    },
    become_regent: {
      label: 'Become Regent',
      desc: 'Claim regency when the ruler is absent.',
    },
    ascend: {
      label: 'I Ascend',
      desc: 'Invoke a rite of succession.',
    },
    assent: {
      label: 'I Assent',
      desc: 'Support an active claim near the throne.',
    },
    abdicate: {
      label: 'I Abdicate',
      desc: 'Yield the throne and skip to contestation.',
    },
    stop_ascent: {
      label: 'Stop Ascent',
      desc: 'Sit on the throne to halt succession.',
    },
  },
  requirements: {
    Crown: 'Crown',
    'Broadcast Ready': 'Broadcast Ready',
    'Ruler/Regent': 'Ruler/Regent',
    'Ruling Office': 'Ruling Office',
    Throat: 'Throat',
    'Noble Blood': 'Noble Blood',
    'Regency Office': 'Regency Office',
    'Eligible Rite': 'Eligible Rite',
    'Active Gathering': 'Active Gathering',
    'Near Throne': 'Near Throne',
    Contesting: 'Contesting',
    Seated: 'Seated',
  },
  disabled_reasons: {
    'Only a living subject may use the ducal court.':
      'Only a living subject may use the ducal court.',
    'Requires the crown.': 'Requires the crown.',
    'Another ducal announcement is not ready yet.':
      'Another ducal announcement is not ready yet.',
    'The Throat is still gathering strength.':
      'The Throat is still gathering strength.',
    'Ruler or regent only.': 'Ruler or regent only.',
    'Declaring an outlaw currently requires the ruling office.':
      'Declaring an outlaw currently requires the ruling office.',
    'There is no throne to claim.': 'There is no throne to claim.',
    'A rite of succession is already underway.':
      'A rite of succession is already underway.',
    'There is no ruler to usurp.': 'There is no ruler to usurp.',
    'You already hold the throne.': 'You already hold the throne.',
    "The realm's fate is already sealed.":
      "The realm's fate is already sealed.",
    'No rites of succession are available to you.':
      'No rites of succession are available to you.',
    'No active succession needs assent.':
      'No active succession needs assent.',
    'Assent is only accepted during gathering.':
      'Assent is only accepted during gathering.',
    'Stand near the throne to assent.': 'Stand near the throne to assent.',
    'No active claim can receive abdication.':
      'No active claim can receive abdication.',
    'The rite is already being contested.':
      'The rite is already being contested.',
    'Only the ruler or regent may abdicate.':
      'Only the ruler or regent may abdicate.',
    'Stand near the throne to abdicate.':
      'Stand near the throne to abdicate.',
    'No active ascent can be halted.': 'No active ascent can be halted.',
    'Stop Ascent is used during contesting.':
      'Stop Ascent is used during contesting.',
    'Someone is already contesting from the throne.':
      'Someone is already contesting from the throne.',
    'Sit on the throne to halt succession.':
      'Sit on the throne to halt succession.',
    'The true lord is already present in the realm.':
      'The true lord is already present in the realm.',
    'Requires noble blood.': 'Requires noble blood.',
    'Your office cannot bear the Crown as regent.':
      'Your office cannot bear the Crown as regent.',
    'A regent has already been declared today.':
      'A regent has already been declared today.',
    'You are already the regent.': 'You are already the regent.',
    'Unknown ducal court action.': 'Unknown ducal court action.',
  },
  status_cards: {
    throne_status: {
      label: 'Throne Status',
      values: {
        Occupied: 'Occupied',
        Empty: 'Empty',
      },
      details: {
        'No one is seated.': 'No one is seated.',
      },
    },
    crown_required: {
      label: 'Crown Authority',
      values: {
        'Crown Worn': 'Crown Worn',
        'Crown Missing': 'Crown Missing',
      },
      details: {
        'Ducal commands are unlocked by the crown.':
          'Ducal commands are unlocked by the crown.',
        'Most commands require the crown.': 'Most commands require the crown.',
      },
    },
    active_rite: {
      label: 'Active Rite',
      values: {
        None: 'None',
        Gathering: 'Gathering',
        Contesting: 'Contesting',
        'Contesting - Paused': 'Contesting - Paused',
        Resolution: 'Resolution',
      },
      details: {
        None: 'None',
      },
    },
    realm_stability: {
      label: 'Realm Stability',
      values: {
        Stable: 'Stable',
        'Claim Gathering': 'Claim Gathering',
        Contested: 'Contested',
        'Rebel Victory Ready': 'Rebel Victory Ready',
        'Rebel Pressure': 'Rebel Pressure',
      },
      details: {
        'Rebel pressure: {progress}': 'Rebel pressure: {progress}',
      },
    },
    current_ruler: {
      label: 'Current Ruler',
      values: {
        None: 'None',
      },
      details: {
        'No active regent.': 'No active regent.',
        'Regent: {name}': 'Regent: {name}',
      },
    },
  },
  rite_names: {
    None: 'None',
    'Usurpation Rite': 'Usurpation Rite',
    'Rite of Solar Succession': 'Rite of Solar Succession',
    'Rite of Lunar Ascension': 'Rite of Lunar Ascension',
    'Rite of Martial Supercession': 'Rite of Martial Supercession',
    'Rite of Golden Accord': 'Rite of Golden Accord',
    'Rite of Sacred Supercession': 'Rite of Sacred Supercession',
    'Rite of Progressive Dominion': 'Rite of Progressive Dominion',
    'Rite of Popular Acclaim': 'Rite of Popular Acclaim',
    'Rite of Psydonian Tribunal': 'Rite of Psydonian Tribunal',
  },
  rite_statuses: {
    'No active succession.': 'No active succession.',
    'A claim is active.': 'A claim is active.',
  },
  rite_steps: ['Gathering', 'Contesting', 'Resolution'],
  voice_command_descriptions: {
    'Make Announcement': 'Broadcast a realm-wide message.',
    'Revise Charter': 'Open the charter ledger.',
    'Make Decree': 'Proclaim a ducal decree.',
    'Purge Decrees': 'Remove every decree.',
    'Set Laws': 'Open the full law editor.',
    'Make Law': 'Add one law by spoken command.',
    'Remove Law (number)': 'Remove a specific numbered law.',
    'Purge Laws': 'Remove every current law.',
    'Declare Outlaw': 'Outlaw or pardon a named subject.',
    'Set Taxes': 'Adjust levies and poll taxes.',
    'Change Colors': "Change the duchy's colors.",
    'Become Regent': 'Claim regency when the ruler is absent.',
    'Summon Crown / Summon Key': 'Retrieve the ducal items.',
    'I Ascend': 'Invoke a rite of succession.',
    'I Assent': 'Support an active claim near the throne.',
    'I Abdicate': 'Yield the throne and skip to contestation.',
    'Stop Ascent': 'Sit on the throne to halt succession.',
  },
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
  icon: string;
}> = [
  {
    id: 'overview',
    icon: 'chess-rook',
  },
  {
    id: 'commands',
    icon: 'crown',
  },
  {
    id: 'succession',
    icon: 'hourglass-half',
  },
  {
    id: 'laws',
    icon: 'balance-scale',
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

const translateKnown = (
  map: Record<string, string> | undefined,
  value?: string | null,
) => {
  if (!value) {
    return value;
  }
  return map?.[value] || value;
};

const translatePattern = (
  map: Record<string, string> | undefined,
  value?: string | null,
) => {
  if (!value) {
    return value;
  }
  const direct = map?.[value];
  if (direct) {
    return direct;
  }
  const rebelPressure = value.match(/^Rebel pressure: (.+)$/);
  if (rebelPressure && map?.['Rebel pressure: {progress}']) {
    return map['Rebel pressure: {progress}'].replace(
      '{progress}',
      rebelPressure[1],
    );
  }
  const regent = value.match(/^Regent: (.+)$/);
  if (regent && map?.['Regent: {name}']) {
    return map['Regent: {name}'].replace('{name}', regent[1]);
  }
  return value;
};

const getActionText = (texts: DucalCourtTexts, action?: DucalAction | null) => {
  if (!action) {
    return null;
  }
  return {
    label: texts.actions[action.id]?.label || action.label,
    desc: texts.actions[action.id]?.desc || action.desc,
    disabledReason: translateKnown(
      texts.disabled_reasons,
      action.disabled_reason,
    ),
  };
};

const getRequirementText = (texts: DucalCourtTexts, requirement: string) =>
  texts.requirements[requirement] || requirement;

const getStatusCardText = (texts: DucalCourtTexts, card: StatusCard) => {
  const cardTexts = texts.status_cards[card.id];
  const detail =
    card.id === 'active_rite'
      ? translateKnown(texts.rite_names, card.detail)
      : translatePattern(cardTexts?.details, card.detail);
  return {
    label: cardTexts?.label || card.label,
    value: translateKnown(cardTexts?.values, card.value) || card.value,
    detail: detail || card.detail,
  };
};

const getRiteName = (texts: DucalCourtTexts, name?: string | null) =>
  translateKnown(texts.rite_names, name) || texts.labels.none;

const getRiteStatus = (texts: DucalCourtTexts, status?: string | null) =>
  translateKnown(texts.rite_statuses, status) || status || texts.labels.none;

const getViewerStatus = (texts: DucalCourtTexts, status?: string | null) =>
  translateKnown(texts.viewer_statuses, status) || texts.labels.none;

const getVoiceCommandDescription = (
  texts: DucalCourtTexts,
  command: string,
) =>
  texts.voice_command_descriptions[command] ||
  DUCAL_COURT_TEXTS.voice_command_descriptions[command];

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
  texts: DucalCourtTexts;
  action: DucalAction;
  compact?: boolean;
  onClick: (action: DucalAction) => void;
}) => {
  const { texts, action, compact, onClick } = props;
  const actionText = getActionText(texts, action)!;
  const tooltip = action.enabled ? actionText.desc : actionText.disabledReason;

  return (
    <TooltipFrame content={tooltip || actionText.desc}>
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
          <span className="DucalCourt__actionTitle">{actionText.label}</span>
          {!compact && (
            <span className="DucalCourt__actionDesc">{actionText.desc}</span>
          )}
          <span className="DucalCourt__badges">
            {action.requirements.map((requirement) => (
              <span className="DucalCourt__badge" key={requirement}>
                {getRequirementText(texts, requirement)}
              </span>
            ))}
          </span>
        </span>
      </Button>
    </TooltipFrame>
  );
};

const StatusGrid = (props: {
  texts: DucalCourtTexts;
  cards: StatusCard[];
}) => (
  <div className="DucalCourt__statusGrid">
    {props.cards.map((card) => {
      const cardText = getStatusCardText(props.texts, card);

      return (
        <div
          key={card.id}
          className={`DucalCourt__statusCard DucalCourt__statusCard--${card.tone}`}
        >
          <div className="DucalCourt__statusIcon">
            <Icon name={STATUS_ICONS[card.id] || 'circle'} />
          </div>
          <div className="DucalCourt__statusBody">
            <div className="DucalCourt__statusLabel">{cardText.label}</div>
            <div className="DucalCourt__statusValue">{cardText.value}</div>
            <div className="DucalCourt__statusDetail">{cardText.detail}</div>
          </div>
        </div>
      );
    })}
  </div>
);

const SuccessionPanel = (props: {
  texts: DucalCourtTexts;
  rite: RiteData;
  actions: DucalAction[];
  onAction: (action: DucalAction) => void;
}) => {
  const { texts, rite, actions, onAction } = props;
  const activeStep = getStageIndex(rite.stage);

  return (
    <Section title={texts.sections.succession}>
      <div className="DucalCourt__riteName">{getRiteName(texts, rite.name)}</div>
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
      <Box className="DucalCourt__riteStatus">
        {getRiteStatus(texts, rite.status)}
      </Box>
      <div className="DucalCourt__riteActionGrid">
        {actions.map((action) => (
          <ActionCard
            key={action.id}
            texts={texts}
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
  texts: DucalCourtTexts;
  title: string;
  actions: DucalAction[];
  compact?: boolean;
  onAction: (action: DucalAction) => void;
}) => {
  const { texts, title, actions, compact, onAction } = props;

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
            texts={texts}
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
  texts: DucalCourtTexts;
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
  const announcementText = getActionText(texts, announcement);
  const decreeText = getActionText(texts, decree);
  const lawText = getActionText(texts, law);
  const purgeLawsText = getActionText(texts, purgeLaws);
  const purgeDecreesText = getActionText(texts, purgeDecrees);
  const canUseText = trimmed.length > 0;
  const showAnnouncements = mode === 'all';
  const showDecrees = mode !== 'laws';
  const showLaws = mode !== 'decrees';
  const showPurgeDecrees = mode === 'commands' || mode === 'decrees';

  const textTooltip = canUseText ? undefined : texts.composer.empty_text;
  const lawBlocked = lawText?.disabledReason || undefined;
  const purgeLawBlocked = purgeLawsText?.disabledReason || lawBlocked;
  const purgeDecreeBlocked = purgeDecreesText?.disabledReason || undefined;
  const sectionTitle =
    mode === 'laws'
      ? texts.sections.law_tools
      : mode === 'decrees'
        ? texts.sections.decree_tools
        : mode === 'commands'
          ? texts.sections.law_decree_tools
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
                  announcementText?.disabledReason ||
                  textTooltip ||
                  announcementText?.desc
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
                content={
                  decreeText?.disabledReason || textTooltip || decreeText?.desc
                }
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
                content={lawBlocked || textTooltip || lawText?.desc}
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
                content={purgeDecreeBlocked || purgeDecreesText?.desc}
              >
                <Button
                  icon="eraser"
                  color="bad"
                  disabled={!purgeDecrees?.enabled}
                  onClick={() => act('purge_decrees')}
                >
                  {texts.composer.clear_decrees}
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
              <TooltipFrame inline content={lawBlocked || lawText?.desc}>
                <Button
                  icon="times"
                  disabled={!law?.enabled || lawCount < 1}
                  onClick={() => act('remove_law', { law_number: lawNumber })}
                >
                  {texts.composer.remove_law}
                </Button>
              </TooltipFrame>
              <TooltipFrame inline content={purgeLawBlocked || purgeLawsText?.desc}>
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
  texts: DucalCourtTexts;
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
      <StatusGrid texts={texts} cards={compactCards} />
      <div className="DucalCourt__compactSummary">
        <div>
          <b>{texts.labels.rite_status}</b>
          <span>{getRiteName(texts, rite.name)}</span>
        </div>
        <div>
          <b>{texts.labels.time_remaining}</b>
          <span>{rite.time_remaining || texts.labels.none}</span>
        </div>
        <Box className="DucalCourt__riteStatus">
          {getRiteStatus(texts, rite.status)}
        </Box>
        <TooltipFrame content={texts.compact.restore_tooltip}>
          <Button icon="expand" onClick={onRestore}>
            {texts.compact.restore_button}
          </Button>
        </TooltipFrame>
      </div>
    </div>
  );
};

const OverviewPanel = (props: {
  texts: DucalCourtTexts;
  rite: RiteData;
  lawCount: number;
  decreeCount: number;
}) => {
  const { texts, rite, lawCount, decreeCount } = props;

  return (
    <Section title={texts.sections.overview}>
      <div className="DucalCourt__overviewFacts">
        <div className="DucalCourt__overviewFact">
          <b>{texts.labels.rite_status}</b>
          <span>{getRiteName(texts, rite.name)}</span>
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
          <b>{texts.labels.charter_ledger}</b>
          <span>
            {lawCount} {texts.labels.laws} / {decreeCount}{' '}
            {texts.labels.decrees}
          </span>
        </div>
      </div>
      <Box className="DucalCourt__riteStatus">
        {getRiteStatus(texts, rite.status)}
      </Box>
    </Section>
  );
};

const LeftRail = (props: {
  texts: DucalCourtTexts;
  activeView: ViewId;
  lawAction?: DucalAction;
  onAction: (action: DucalAction) => void;
  onView: (view: ViewId) => void;
}) => {
  const { texts, activeView, lawAction, onAction, onView } = props;
  const lawActionText = getActionText(texts, lawAction);

  return (
    <aside className="DucalCourt__leftRail">
      <div className="DucalCourt__throneEmblem">
        <Icon name="chess-rook" />
      </div>
      <nav className="DucalCourt__nav">
        {VIEW_ITEMS.map((item) => {
          const viewText = texts.views[item.id];
          const opensSetLaws = item.id === 'laws';
          const tooltip = opensSetLaws
            ? lawActionText?.disabledReason || lawActionText?.desc || viewText.desc
            : viewText.desc;

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
                {viewText.label}
              </Button>
            </TooltipFrame>
          );
        })}
      </nav>
    </aside>
  );
};

const RightRail = (props: {
  texts: DucalCourtTexts;
  tools: DucalAction[];
  onAction: (action: DucalAction) => void;
}) => {
  const { texts, tools, onAction } = props;

  return (
    <aside className="DucalCourt__rightRail">
      <Section title={texts.sections.quick_tools}>
        <div className="DucalCourt__quickTools">
          {tools.map((action) => (
            <ActionCard
              key={action.id}
              texts={texts}
              action={action}
              compact
              onClick={onAction}
            />
          ))}
        </div>
      </Section>
      <Section title={texts.sections.voice_commands}>
        <ul className="DucalCourt__voiceList">
          {VOICE_COMMANDS.map((command) => (
            <li key={command}>
              <span className="DucalCourt__voiceCommand">{command}</span>
              <span className="DucalCourt__voiceDesc">
                {getVoiceCommandDescription(texts, command)}
              </span>
            </li>
          ))}
        </ul>
      </Section>
    </aside>
  );
};

const CourtCommands = (props: {
  texts: DucalCourtTexts;
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
      <Section title={texts.sections.commands}>
        <div className="DucalCourt__actionGroups">
          <ActionGroup
            texts={texts}
            title={texts.sections.public_writs}
            actions={writActions}
            onAction={onAction}
          />
          <ActionGroup
            texts={texts}
            title={texts.sections.governance}
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

type DucalCourtViewProps = {
  texts: DucalCourtTexts;
};

export const DucalCourtView = (props: DucalCourtViewProps) => {
  const { texts } = props;
  const { act, data } = useBackend<Data>();
  const [compact, setCompact] = useState(false);
  const [activeView, setActiveView] = useState<ViewId>('overview');
  const {
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
        compact ? texts.compact.restore_tooltip : texts.compact.collapse_tooltip
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
                <span>{getViewerStatus(texts, viewer_status)}</span>
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
                texts={texts}
                activeView={activeView}
                lawAction={setLawsAction}
                onAction={handleAction}
                onView={setActiveView}
              />
              <main className="DucalCourt__centerPanel">
                <StatusGrid texts={texts} cards={status_cards} />
                <div className="DucalCourt__contentStack">
                  {activeContent}
                </div>
              </main>
              <RightRail
                texts={texts}
                tools={quickToolActions}
                onAction={handleAction}
              />
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};

export const DucalCourt = () => <DucalCourtView texts={DUCAL_COURT_TEXTS} />;
