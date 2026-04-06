import { useEffect } from 'react';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type NoticeArgs = Record<string, string | number>;

type NoticeData = {
  key: string;
  type: string;
  args?: NoticeArgs;
} | null;

type OptionEntry = {
  id: string | number;
  selected: boolean;
  minimum_tier?: number;
  maximum_tier?: number;
};

type DraftSummary = {
  title?: string;
  description?: string;
  type_id?: string | null;
  group_id?: string | null;
  tier_value?: number | null;
};

type PreviewEntry = {
  id: string;
  name: string;
  risk: number;
  spawn_weight: number;
  group_min: number;
  group_max: number;
  icon_class?: string;
};

type Data = {
  spritesheet_css?: string;
  role_label: string;
  active_contract_count: number;
  contract_limit: number;
  can_consult_contracts: boolean;
  consult_block_reason_key?: string | null;
  can_take_contract: boolean;
  can_claim_compass: boolean;
  can_turn_in_contract: boolean;
  can_abandon_contract: boolean;
  can_print_contracts: boolean;
  compass_action_key: string;
  group_options: OptionEntry[];
  type_options: OptionEntry[];
  tier_options: OptionEntry[];
  draft_summary: DraftSummary;
  preview_title_key: string;
  preview_entries: PreviewEntry[];
  preview_message_key?: string | null;
  preview_hidden_count: number;
  notice: NoticeData;
};

export type ContractLedgerLocale = {
  windowTitle: string;
  labels: {
    contractLimit: string;
    currentRole: string;
    availableActions: string;
    contractDraft: string;
    group: string;
    type: string;
    threat: string;
    draft: string;
    none: string;
    notSelected: string;
    risk: string;
    spawnWeight: string;
    compass: string;
    consultContracts: string;
    turnInContract: string;
    abandonContract: string;
    printIssuedContracts: string;
    getContract: string;
  };
  contractGroups: Record<string, string>;
  contractTypes: Record<string, string>;
  contractDescriptions: Record<string, string>;
  tierLabels: Record<number, string>;
  resolveText: (key?: string | null, args?: NoticeArgs) => string;
  formatTierBand: (minimumTier: number, maximumTier: number) => string;
  formatDraftTitle: (contractType: string) => string;
  formatPreviewGroup: (groupMin: number, groupMax: number) => string;
  noContractSelectedTitle: string;
  noContractSelectedDescription: string;
  hiddenTargets: (count: number) => string;
};

const noticeColor = (type?: string) => {
  switch (type) {
    case 'warning':
      return 'average';
    case 'success':
      return 'good';
    case 'bad':
    case 'danger':
      return 'bad';
    default:
      return 'default';
  }
};

const getTierLabel = (
  locale: ContractLedgerLocale,
  tier?: number | string | null,
) => {
  if (!tier) {
    return locale.labels.notSelected;
  }
  return locale.tierLabels[Number(tier)] || `Tier ${tier}`;
};

const getGroupLabel = (
  locale: ContractLedgerLocale,
  groupId?: string | null,
) => {
  if (!groupId) {
    return locale.labels.none;
  }
  return locale.contractGroups[groupId] || groupId;
};

const getTypeLabel = (
  locale: ContractLedgerLocale,
  typeId?: string | null,
) => {
  if (!typeId) {
    return '';
  }
  return locale.contractTypes[typeId] || typeId;
};

const getDraftTitle = (
  locale: ContractLedgerLocale,
  draftSummary: DraftSummary,
) => {
  if (!draftSummary.type_id) {
    return draftSummary.title || locale.noContractSelectedTitle;
  }
  return locale.formatDraftTitle(getTypeLabel(locale, draftSummary.type_id));
};

const getDraftDescription = (
  locale: ContractLedgerLocale,
  draftSummary: DraftSummary,
) => {
  if (!draftSummary.type_id) {
    return draftSummary.description || locale.noContractSelectedDescription;
  }
  return (
    locale.contractDescriptions[draftSummary.type_id] ||
    draftSummary.description ||
    ''
  );
};

const TargetPreviewIcon = (props: { entry: PreviewEntry }) => {
  const { entry } = props;

  if (entry.icon_class) {
    return <Box className={entry.icon_class} />;
  }

  return <Icon name="question" size={2.5} color="gray" />;
};

const TargetPreviewCard = (props: {
  entry: PreviewEntry;
  locale: ContractLedgerLocale;
}) => {
  const { entry, locale } = props;

  return (
    <Box
      key={entry.id}
      p={1}
      style={{
        border: '1px solid rgba(255, 255, 255, 0.15)',
        borderRadius: '4px',
        background: 'rgba(0, 0, 0, 0.2)',
      }}
    >
      <Stack align="center">
        <Stack.Item>
          <Box
            width="68px"
            height="68px"
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              border: '1px solid rgba(255, 255, 255, 0.12)',
              background: 'rgba(255, 255, 255, 0.03)',
            }}
          >
            <TargetPreviewIcon entry={entry} />
          </Box>
        </Stack.Item>
        <Stack.Item grow>
          <Box bold>{entry.name}</Box>
          <Box color="label">
            {locale.labels.risk} {entry.risk}
          </Box>
          <Box color="label">
            {locale.formatPreviewGroup(entry.group_min, entry.group_max)}
          </Box>
          <Box color="label">
            {locale.labels.spawnWeight} {entry.spawn_weight}
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const SelectRow = (props: {
  title: string;
  action: string;
  paramKey: string;
  options: OptionEntry[];
  disabled?: boolean;
  renderLabel: (option: OptionEntry) => string;
}) => {
  const { act } = useBackend<Data>();
  const { title, action, paramKey, options, disabled, renderLabel } = props;

  return (
    <Box mb={1.5}>
      <Box mb={0.5} bold>
        {title}
      </Box>
      <Box
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          gap: '0.4rem',
        }}
      >
        {options.map((option) => (
          <Button
            key={String(option.id)}
            selected={option.selected}
            disabled={disabled}
            onClick={() => act(action, { [paramKey]: option.id })}
          >
            {renderLabel(option)}
          </Button>
        ))}
      </Box>
    </Box>
  );
};

export const ContractLedgerView = (props: {
  locale: ContractLedgerLocale;
}) => {
  const { locale } = props;
  const { act, data } = useBackend<Data>();
  const {
    role_label,
    active_contract_count,
    contract_limit,
    can_consult_contracts,
    consult_block_reason_key,
    can_take_contract,
    can_claim_compass,
    can_turn_in_contract,
    can_abandon_contract,
    can_print_contracts,
    compass_action_key,
    group_options,
    type_options,
    tier_options,
    draft_summary,
    preview_title_key,
    preview_entries,
    preview_message_key,
    preview_hidden_count,
    notice,
  } = data;

  // Dynamically load spritesheet CSS for preview icons
  useEffect(() => {
    const cssUrl = data.spritesheet_css;
    if (!cssUrl) {
      return;
    }
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = cssUrl;
    document.head.appendChild(link);
    return () => {
      document.head.removeChild(link);
    };
  }, [data.spritesheet_css]);

  const previewTitle = locale.resolveText(preview_title_key);
  const previewMessage = locale.resolveText(preview_message_key);
  const noticeText = notice && locale.resolveText(notice.key, notice.args);
  const consultBlockReason = locale.resolveText(consult_block_reason_key);
  const compassTooltip = locale.resolveText(compass_action_key);

  return (
    <Window
      title={locale.windowTitle}
      width={1040}
      height={700}
    >
      <Window.Content scrollable>
        <Section>
          <Stack align="center">
            <Stack.Item grow>
              <Stack align="center">
                <Stack.Item grow>
                  <Box bold>{locale.labels.contractLimit}</Box>
                  <Box color="label">
                    {active_contract_count} / {contract_limit}
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="compass"
                    disabled={!can_claim_compass}
                    tooltip={compassTooltip}
                    onClick={() => act('getcompass')}
                  >
                    {locale.labels.compass}
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item grow>
              <Box textAlign="right">
                <Box bold>{locale.labels.currentRole}</Box>
                <Box color="label">{role_label}</Box>
              </Box>
            </Stack.Item>
          </Stack>
        </Section>

        {!!notice && !!noticeText && (
          <Section>
            <NoticeBox color={noticeColor(notice.type)}>{noticeText}</NoticeBox>
          </Section>
        )}

        <Stack>
          <Stack.Item basis="42%">
            <Section title={locale.labels.availableActions}>
              <Stack vertical>
                <Stack.Item>
                  <Button fluid onClick={() => act('consultcontracts')}>
                    {locale.labels.consultContracts}
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    disabled={!can_turn_in_contract}
                    onClick={() => act('turnincontract')}
                  >
                    {locale.labels.turnInContract}
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    color="bad"
                    disabled={!can_abandon_contract}
                    onClick={() => act('abandoncontract')}
                  >
                    {locale.labels.abandonContract}
                  </Button>
                </Stack.Item>
                {!!can_print_contracts && (
                  <Stack.Item>
                    <Button fluid onClick={() => act('printcontracts')}>
                      {locale.labels.printIssuedContracts}
                    </Button>
                  </Stack.Item>
                )}
              </Stack>
            </Section>

            <Section title={locale.labels.contractDraft}>
              {!can_consult_contracts && !!consultBlockReason && (
                <NoticeBox color="average">{consultBlockReason}</NoticeBox>
              )}

              <SelectRow
                title={locale.labels.group}
                action="select_group"
                paramKey="group"
                options={group_options}
                disabled={!can_consult_contracts}
                renderLabel={(option) => getGroupLabel(locale, String(option.id))}
              />

              <SelectRow
                title={locale.labels.type}
                action="select_type"
                paramKey="contract_type"
                options={type_options}
                disabled={!can_consult_contracts}
                renderLabel={(option) => {
                  const contractType = getTypeLabel(locale, String(option.id));
                  if (!option.minimum_tier || !option.maximum_tier) {
                    return contractType;
                  }
                  return `${contractType} (${locale.formatTierBand(option.minimum_tier, option.maximum_tier)})`;
                }}
              />

              <SelectRow
                title={locale.labels.threat}
                action="select_tier"
                paramKey="tier"
                options={tier_options}
                disabled={!can_consult_contracts}
                renderLabel={(option) => getTierLabel(locale, Number(option.id))}
              />

              <LabeledList>
                <LabeledList.Item label={locale.labels.draft}>
                  {getDraftTitle(locale, draft_summary)}
                </LabeledList.Item>
                <LabeledList.Item label={locale.labels.group}>
                  {getGroupLabel(locale, draft_summary.group_id)}
                </LabeledList.Item>
                <LabeledList.Item label={locale.labels.threat}>
                  {draft_summary.tier_value
                    ? getTierLabel(locale, draft_summary.tier_value)
                    : locale.labels.notSelected}
                </LabeledList.Item>
              </LabeledList>

              <Box mt={1} color="label">
                {getDraftDescription(locale, draft_summary)}
              </Box>

              <Box mt={1.5}>
                <Button
                  fluid
                  color="good"
                  disabled={!can_take_contract}
                  onClick={() => act('takecontract')}
                >
                  {locale.labels.getContract}
                </Button>
              </Box>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section title={previewTitle} fill>
              {!!previewMessage && <NoticeBox>{previewMessage}</NoticeBox>}

              {!previewMessage && (
                <Box
                  style={{
                    display: 'grid',
                    gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
                    gap: '0.5rem',
                  }}
                >
                  {preview_entries.map((entry) => (
                    <TargetPreviewCard
                      key={entry.id}
                      entry={entry}
                      locale={locale}
                    />
                  ))}
                </Box>
              )}

              {!previewMessage && preview_hidden_count > 0 && (
                <Box mt={1} color="label">
                  {locale.hiddenTargets(preview_hidden_count)}
                </Box>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
