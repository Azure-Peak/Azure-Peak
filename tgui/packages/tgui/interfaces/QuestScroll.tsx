import type { ReactNode } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { BeastWrit } from './QuestScroll/BeastWrit';
import { CarriageWrit } from './QuestScroll/CarriageWrit';
import { DrowWrit } from './QuestScroll/DrowWrit';
import { GoblinoidWrit } from './QuestScroll/GoblinoidWrit';
import { GronnWrit } from './QuestScroll/GronnWrit';
import { HumanoidWrit } from './QuestScroll/HumanoidWrit';
import {
  BlockadeTimer,
  Marginalia,
  ProgressLine,
  RetrievalProgressLine,
  WhisperLine,
} from './QuestScroll/Marginalia';
import { RecoveryWrit } from './QuestScroll/RecoveryWrit';
import {
  COMMISSION_SEAL,
  EXEMPT_SEAL,
  SealBannerView,
} from './QuestScroll/Seals';
import type { QuestScrollData } from './QuestScroll/shared';
import {
  bountyHeader,
  completionStamp,
  divider,
  FACTION_CAT_BEAST,
  FACTION_CAT_DROW,
  FACTION_CAT_GOBLINOID,
  FACTION_CAT_GRONN,
  FACTION_CAT_UNDEAD,
  failedStamp,
  marginaliaLabel,
  marginaliaLine,
  netReward,
  parchment,
  titleHint,
  WRIT_TYPE_CARRIAGE,
  WRIT_TYPE_RECOVERY,
  WRIT_TYPE_TOWNER,
  writBody,
} from './QuestScroll/shared';
import { TownerWrit } from './QuestScroll/TownerWrit';
import { UndeadWrit } from './QuestScroll/UndeadWrit';

const BountyHeader = (props: {
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
}) => {
  const { reward, levyRate, levyExempt, guildCutRate } = props;
  const net = netReward(reward, levyRate, levyExempt, guildCutRate);
  return (
    <div style={bountyHeader}>
      <span style={marginaliaLabel}>Bounty as it now stands:</span>
      <b>{reward} mammon</b>
      {net !== reward && <span>({net} in hand after deductions)</span>}
    </div>
  );
};

type MarginaliaSectionProps = {
  data: QuestScrollData;
  showProgress: boolean;
  hasWhisper: boolean;
  hasBlockadeTimer: boolean;
  hasHuntTimer: boolean;
};

const MarginaliaSection = (props: MarginaliaSectionProps) => {
  const { data, showProgress, hasWhisper, hasBlockadeTimer, hasHuntTimer } =
    props;
  return (
    <Marginalia>
      {hasWhisper && (
        <WhisperLine
          compass={data.compass_direction || ''}
          zHint={data.z_hint}
        />
      )}
      {showProgress &&
        (data.writ_type === WRIT_TYPE_RECOVERY ? (
          <RetrievalProgressLine
            done={data.progress_current ?? 0}
            total={data.progress_required ?? 1}
            noun={
              data.fetch_item_plural || data.fetch_item || 'goods of the realm'
            }
          />
        ) : (
          <ProgressLine
            done={data.progress_current ?? 0}
            total={data.progress_required ?? 1}
            noun={data.faction_progress_noun || 'foes'}
          />
        ))}
      {hasBlockadeTimer && (
        <BlockadeTimer
          label={data.blockade_timer_label || ''}
          seconds={data.blockade_timer_seconds ?? 0}
        />
      )}
      {hasHuntTimer && (
        <BlockadeTimer
          label={data.hunt_timer_label || ''}
          seconds={data.hunt_timer_seconds ?? 0}
        />
      )}
      {!!data.blockade_armed && !data.blockade_timer_label && (
        <div style={marginaliaLine}>
          <i>Travel to the blockade, waves descend on arrival.</i>
        </div>
      )}
      {!!data.is_towner && !data.complete && (
        <div style={marginaliaLine}>
          <i>
            Only {data.issued_by || 'the poster'} can open what you recover -
            Carry it back to them or put it into the nearest HERMES to complete the contract.
          </i>
        </div>
      )}
    </Marginalia>
  );
};

type WritBodyProps = {
  data: QuestScrollData;
  realm: string;
  rulerTitle: string;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
  guildCutRate: number;
  bearer?: string;
  issuedBy?: string;
  crimes: string[];
  hasRecoveryAddendum: boolean;
};

type WritRenderer = (props: WritBodyProps) => ReactNode;

const sealPropsOf = (props: WritBodyProps) => ({
  rulerTitle: props.rulerTitle,
  issuedBy: props.issuedBy,
  issuedOn: props.data.issued_on,
  bearer: props.bearer,
});

const rewardPropsOf = (props: WritBodyProps) => ({
  reward: props.reward,
  levyRate: props.levyRate,
  levyExempt: props.levyExempt,
  guildCutRate: props.guildCutRate,
});

const factionGroupPropsOf = (props: WritBodyProps) => ({
  groupWord: props.data.faction_group_word,
  namePlural: props.data.faction_name_plural,
});

const namedPropsOf = (props: WritBodyProps) => ({
  named: props.data.named_target,
  ringleader: props.data.band_leader,
});

const recoveryPropsOf = (props: WritBodyProps) => ({
  hasRecoveryAddendum: props.hasRecoveryAddendum,
  recoveryShipment: props.data.recovery_shipment,
  recoveryDestination: props.data.delivery_destination,
  recoveryCircumstance: props.data.circumstance,
});

const WRIT_TYPE_RENDERERS: Record<string, WritRenderer> = {
  [WRIT_TYPE_RECOVERY]: (props) => (
    <RecoveryWrit
      realm={props.realm}
      circumstance={props.data.circumstance}
      pickupRegion={props.data.pickup_region}
      fetchItem={props.data.fetch_item}
      fetchItemPlural={props.data.fetch_item_plural}
      fetchCount={props.data.fetch_count}
      {...rewardPropsOf(props)}
      {...sealPropsOf(props)}
    />
  ),
  [WRIT_TYPE_CARRIAGE]: (props) => (
    <CarriageWrit
      realm={props.realm}
      circumstance={props.data.circumstance}
      pickupRegion={props.data.pickup_region}
      destination={props.data.delivery_destination}
      deliveryItem={props.data.delivery_item}
      {...rewardPropsOf(props)}
      {...sealPropsOf(props)}
    />
  ),
  [WRIT_TYPE_TOWNER]: (props) => (
    <TownerWrit
      intro={props.data.towner_intro}
      sealNote={props.data.towner_seal_note}
      {...rewardPropsOf(props)}
      {...sealPropsOf(props)}
    />
  ),
};

const FACTION_WRIT_RENDERERS: Record<string, WritRenderer> = {
  [FACTION_CAT_BEAST]: (props) => (
    <BeastWrit
      nameSingular={props.data.faction_name_singular}
      realm={props.realm}
      crimes={props.crimes}
      {...rewardPropsOf(props)}
      {...sealPropsOf(props)}
      {...recoveryPropsOf(props)}
    />
  ),
  [FACTION_CAT_UNDEAD]: (props) => (
    <UndeadWrit
      realm={props.realm}
      {...factionGroupPropsOf(props)}
      {...rewardPropsOf(props)}
      {...sealPropsOf(props)}
      {...recoveryPropsOf(props)}
    />
  ),
  [FACTION_CAT_GOBLINOID]: (props) => (
    <GoblinoidWrit
      realm={props.realm}
      {...factionGroupPropsOf(props)}
      {...rewardPropsOf(props)}
      {...sealPropsOf(props)}
      {...recoveryPropsOf(props)}
    />
  ),
  [FACTION_CAT_GRONN]: (props) => (
    <GronnWrit
      realm={props.realm}
      crimes={props.crimes}
      {...namedPropsOf(props)}
      {...factionGroupPropsOf(props)}
      {...rewardPropsOf(props)}
      {...sealPropsOf(props)}
      {...recoveryPropsOf(props)}
    />
  ),
  [FACTION_CAT_DROW]: (props) => (
    <DrowWrit
      realm={props.realm}
      crimes={props.crimes}
      {...namedPropsOf(props)}
      {...factionGroupPropsOf(props)}
      {...rewardPropsOf(props)}
      {...sealPropsOf(props)}
      {...recoveryPropsOf(props)}
    />
  ),
};

const renderHumanoidWrit: WritRenderer = (props) => (
  <HumanoidWrit
    realm={props.realm}
    {...namedPropsOf(props)}
    {...factionGroupPropsOf(props)}
    crimes={props.crimes}
    sacralInvoked={!!props.data.sacral_invoked}
    oathBreach={!!props.data.oath_breach}
    condemnation={props.data.condemnation || undefined}
    {...recoveryPropsOf(props)}
    {...rewardPropsOf(props)}
    {...sealPropsOf(props)}
  />
);

const WritBody = (props: WritBodyProps) => {
  const render =
    WRIT_TYPE_RENDERERS[props.data.writ_type || ''] ||
    FACTION_WRIT_RENDERERS[props.data.faction_category || ''] ||
    renderHumanoidWrit;
  return <>{render(props)}</>;
};

export const QuestScroll = () => {
  const { data } = useBackend<QuestScrollData>();

  if (data.empty) {
    return (
      <Window
        title="Contract Scroll"
        width={520}
        height={620}
        theme="parchment"
      >
        <Window.Content scrollable>
          <div style={parchment}>
            <div style={{ textAlign: 'center', fontStyle: 'italic' }}>
              This scroll bears no active contract.
            </div>
          </div>
        </Window.Content>
      </Window>
    );
  }

  const realm = data.realm_name || 'the realm';
  const levyRate = data.levy_rate ?? 0;
  const levyExempt = !!data.levy_exempt;
  const guildCutRate = data.guild_cut_rate ?? 0;
  const rulerTitle = data.ruler_title || 'Duke';
  const reward = data.reward ?? 0;
  const bearer = data.issued_to || undefined;
  const issuedBy = data.issued_by || undefined;
  const crimes = data.crimes || [];
  const showProgress =
    !!data.progress_required &&
    data.progress_required > 1 &&
    typeof data.progress_current === 'number' &&
    !data.complete;
  const hasWhisper = !!data.compass_direction;
  const hasBlockadeTimer =
    !!data.blockade_timer_label && (data.blockade_timer_seconds ?? 0) > 0;
  const hasHuntTimer =
    !!data.hunt_timer_label && (data.hunt_timer_seconds ?? 0) > 0;
  const hasTownerSeal = !!data.is_towner && !data.complete;
  const hasMarginalia =
    hasWhisper ||
    showProgress ||
    hasBlockadeTimer ||
    hasHuntTimer ||
    !!data.blockade_armed ||
    hasTownerSeal;
  const hasSealBanners = !!(data.shows_commission_seal || data.levy_exempt);

  const isOutlawry = !WRIT_TYPE_RENDERERS[data.writ_type || ''];
  const hasRecoveryAddendum = isOutlawry && !!data.recovery_shipment;

  return (
    <Window title="Contract Scroll" width={520} height={680} theme="parchment">
      <Window.Content scrollable>
        <div style={parchment}>
          {data.title && <div style={titleHint}>{data.title}</div>}

          {!!bearer && (
            <BountyHeader
              reward={reward}
              levyRate={levyRate}
              levyExempt={levyExempt}
              guildCutRate={guildCutRate}
            />
          )}

          <div style={writBody}>
            <WritBody
              data={data}
              realm={realm}
              rulerTitle={rulerTitle}
              reward={reward}
              levyRate={levyRate}
              levyExempt={levyExempt}
              guildCutRate={guildCutRate}
              bearer={bearer}
              issuedBy={issuedBy}
              crimes={crimes}
              hasRecoveryAddendum={hasRecoveryAddendum}
            />
          </div>

          {hasMarginalia && (
            <MarginaliaSection
              data={data}
              showProgress={showProgress}
              hasWhisper={hasWhisper}
              hasBlockadeTimer={hasBlockadeTimer}
              hasHuntTimer={hasHuntTimer}
            />
          )}

          {data.complete ? (
            <>
              <hr style={divider} />
              <div style={completionStamp}>THIS WORK IS DONE</div>
              <div style={{ textAlign: 'center', marginTop: '6px' }}>
                Return this scroll to the Contract Ledger to claim your reward.
              </div>
            </>
          ) : data.blockade_failed ? (
            <>
              <hr style={divider} />
              <div style={failedStamp}>
                THE BLOCKADE HELD. THIS WRIT HAS LAPSED
              </div>
            </>
          ) : null}

          {!!data.levy_exempt && (
            <>
              <hr style={divider} />
              <div
                style={{
                  textAlign: 'center',
                  fontStyle: 'italic',
                  color: 'hsl(130, 45%, 28%)',
                  fontSize: '0.92em',
                }}
              >
                By seal of the {rulerTitle}, the holder of this writ is exempt
                from the Crown&apos;s Levy on its reward.
              </div>
            </>
          )}

          {hasSealBanners && (
            <div
              style={{
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'flex-start',
                gap: '4px',
                marginTop: '18px',
              }}
            >
              {!!data.shows_commission_seal && (
                <SealBannerView seal={COMMISSION_SEAL} />
              )}
              {!!data.levy_exempt && <SealBannerView seal={EXEMPT_SEAL} />}
            </div>
          )}

          {!!data.target_region && (
            <div
              style={{
                textAlign: 'center',
                fontStyle: 'italic',
                fontSize: '0.88em',
                color: 'hsl(30, 35%, 40%)',
                marginTop: '14px',
              }}
            >
              The matter lies within {data.target_region}.
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
