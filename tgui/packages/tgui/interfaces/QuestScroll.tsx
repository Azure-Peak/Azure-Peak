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
import { OreVeinWrit } from './QuestScroll/OreVeinWrit';
import { RecoveryWrit } from './QuestScroll/RecoveryWrit';
import {
  COMMISSION_SEAL,
  EXEMPT_SEAL,
  SealBannerView,
} from './QuestScroll/Seals';
import type { QuestScrollData } from './QuestScroll/shared';
import {
  completionStamp,
  divider,
  FACTION_CAT_BEAST,
  FACTION_CAT_DROW,
  FACTION_CAT_GOBLINOID,
  FACTION_CAT_GRONN,
  FACTION_CAT_UNDEAD,
  failedStamp,
  marginaliaLine,
  parchment,
  titleHint,
  WRIT_TYPE_CARRIAGE,
  WRIT_TYPE_RECOVERY,
  WRIT_TYPE_TOWNER_VEIN,
  writBody,
} from './QuestScroll/shared';
import { UndeadWrit } from './QuestScroll/UndeadWrit';

type MarginaliaSectionProps = {
  data: QuestScrollData;
  showProgress: boolean;
  hasWhisper: boolean;
  hasBlockadeTimer: boolean;
  hasHuntTimer: boolean;
  hasCaravanTimer: boolean;
  hasCaravanAwaitingArrival: boolean;
  hasOreveinTimer: boolean;
  hasOreveinAwaitingArrival: boolean;
};

const MarginaliaSection = (props: MarginaliaSectionProps) => {
  const {
    data,
    showProgress,
    hasWhisper,
    hasBlockadeTimer,
    hasHuntTimer,
    hasCaravanTimer,
    hasCaravanAwaitingArrival,
    hasOreveinTimer,
    hasOreveinAwaitingArrival,
  } = props;
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
              data.fetch_item ? `${data.fetch_item}s` : 'goods of the realm'
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
      {hasCaravanAwaitingArrival && (
        <div style={marginaliaLine}>
          <i>Reach the wreck to start the 20-minute clock.</i>
        </div>
      )}
      {hasCaravanTimer && (
        <>
          <BlockadeTimer
            label="Trail goes cold in"
            seconds={data.caravan_expiry_seconds ?? 0}
          />
          <div style={marginaliaLine}>
            <i>The strongbox stays buried until the smith reaches the wreck.</i>
          </div>
        </>
      )}
      {!!data.caravan_parcel_spawned && !data.complete && (
        <div style={marginaliaLine}>
          <i>
            The smith has reached the wreck. The strongbox is yours to recover.
          </i>
        </div>
      )}
      {!!data.caravan_expired && (
        <div style={marginaliaLine}>
          <b>The trail has gone cold. The wreck is lost.</b>
        </div>
      )}
      {hasOreveinAwaitingArrival && (
        <div style={marginaliaLine}>
          <i>
            Reach the strike to make the earth erupt. The miner must be at your
            side.
          </i>
        </div>
      )}
      {hasOreveinTimer && (
        <>
          <BlockadeTimer
            label="Vein closes in"
            seconds={data.orevein_expiry_seconds ?? 0}
          />
          {(data.orevein_clusters_total ?? 0) > 0 && (
            <div style={marginaliaLine}>
              <i>
                {data.orevein_clusters_remaining ?? 0} of{' '}
                {data.orevein_clusters_total ?? 0} clusters remain.
              </i>
            </div>
          )}
        </>
      )}
      {!!data.orevein_expired && (
        <div style={marginaliaLine}>
          <b>The vein has closed. The earth has reclaimed her own.</b>
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

const WritBody = (props: WritBodyProps) => {
  const {
    data,
    realm,
    rulerTitle,
    reward,
    levyRate,
    levyExempt,
    guildCutRate,
    bearer,
    issuedBy,
    crimes,
    hasRecoveryAddendum,
  } = props;
  const sealProps = {
    rulerTitle,
    issuedBy,
    issuedOn: data.issued_on,
    bearer,
  };
  const factionGroupProps = {
    groupWord: data.faction_group_word,
    namePlural: data.faction_name_plural,
  };
  const namedProps = {
    named: data.named_target,
    ringleader: data.band_leader,
  };
  const rewardProps = { reward, levyRate, levyExempt, guildCutRate };
  const recoveryProps = {
    hasRecoveryAddendum,
    recoveryShipment: data.recovery_shipment,
    recoveryDestination: data.delivery_destination,
    recoveryCircumstance: data.circumstance,
  };

  if (data.writ_type === WRIT_TYPE_RECOVERY) {
    return (
      <RecoveryWrit
        realm={realm}
        circumstance={data.circumstance}
        pickupRegion={data.pickup_region}
        fetchItem={data.fetch_item}
        fetchCount={data.fetch_count}
        {...rewardProps}
        {...sealProps}
      />
    );
  }
  if (data.writ_type === WRIT_TYPE_CARRIAGE) {
    return (
      <CarriageWrit
        realm={realm}
        circumstance={data.circumstance}
        pickupRegion={data.pickup_region}
        destination={data.delivery_destination}
        deliveryItem={data.delivery_item}
        {...rewardProps}
        {...sealProps}
      />
    );
  }
  if (data.writ_type === WRIT_TYPE_TOWNER_VEIN) {
    return (
      <OreVeinWrit
        pickupRegion={data.pickup_region}
        {...rewardProps}
        {...sealProps}
      />
    );
  }
  switch (data.faction_category) {
    case FACTION_CAT_BEAST:
      return (
        <BeastWrit
          nameSingular={data.faction_name_singular}
          realm={realm}
          crimes={crimes}
          {...rewardProps}
          {...sealProps}
          {...recoveryProps}
        />
      );
    case FACTION_CAT_UNDEAD:
      return (
        <UndeadWrit
          realm={realm}
          {...factionGroupProps}
          {...rewardProps}
          {...sealProps}
          {...recoveryProps}
        />
      );
    case FACTION_CAT_GOBLINOID:
      return (
        <GoblinoidWrit
          realm={realm}
          {...factionGroupProps}
          {...rewardProps}
          {...sealProps}
          {...recoveryProps}
        />
      );
    case FACTION_CAT_GRONN:
      return (
        <GronnWrit
          realm={realm}
          crimes={crimes}
          {...namedProps}
          {...factionGroupProps}
          {...rewardProps}
          {...sealProps}
          {...recoveryProps}
        />
      );
    case FACTION_CAT_DROW:
      return (
        <DrowWrit
          realm={realm}
          crimes={crimes}
          {...namedProps}
          {...factionGroupProps}
          {...rewardProps}
          {...sealProps}
          {...recoveryProps}
        />
      );
    default:
      return (
        <HumanoidWrit
          realm={realm}
          {...namedProps}
          {...factionGroupProps}
          crimes={crimes}
          sacralInvoked={!!data.sacral_invoked}
          oathBreach={!!data.oath_breach}
          condemnation={data.condemnation || undefined}
          {...recoveryProps}
          {...rewardProps}
          {...sealProps}
        />
      );
  }
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
  const hasCaravanTimer =
    (data.caravan_expiry_seconds ?? 0) > 0 && !data.caravan_parcel_spawned;
  const hasCaravanAwaitingArrival =
    data.caravan_bearer_arrived !== undefined &&
    !data.caravan_bearer_arrived &&
    !data.caravan_expired &&
    !data.caravan_parcel_spawned;
  const hasCaravanStatus =
    !!data.caravan_parcel_spawned || !!data.caravan_expired;
  const hasOreveinTimer =
    (data.orevein_expiry_seconds ?? 0) > 0 &&
    !!data.orevein_clusters_spawned &&
    !data.orevein_expired;
  const hasOreveinAwaitingArrival =
    data.orevein_bearer_arrived !== undefined &&
    !data.orevein_clusters_spawned &&
    !data.orevein_expired;
  const hasOreveinStatus = !!data.orevein_expired;
  const hasMarginalia =
    hasWhisper ||
    showProgress ||
    hasBlockadeTimer ||
    hasHuntTimer ||
    !!data.blockade_armed ||
    hasCaravanTimer ||
    hasCaravanStatus ||
    hasCaravanAwaitingArrival ||
    hasOreveinTimer ||
    hasOreveinAwaitingArrival ||
    hasOreveinStatus;
  const hasSealBanners = !!(data.is_defense || data.levy_exempt);

  const isOutlawry =
    data.writ_type !== WRIT_TYPE_RECOVERY &&
    data.writ_type !== WRIT_TYPE_CARRIAGE &&
    data.writ_type !== WRIT_TYPE_TOWNER_VEIN;
  // BOG_DESERTER falls through to the humanoid renderer. Its distinction is
  // force_oath_breach set composer-side, which makes the corruption-of-blood clause
  // always render under the licence-to-slay.
  const hasRecoveryAddendum = isOutlawry && !!data.recovery_shipment;

  return (
    <Window title="Contract Scroll" width={520} height={680} theme="parchment">
      <Window.Content scrollable>
        <div style={parchment}>
          {data.title && <div style={titleHint}>{data.title}</div>}

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
              hasCaravanTimer={hasCaravanTimer}
              hasCaravanAwaitingArrival={hasCaravanAwaitingArrival}
              hasOreveinTimer={hasOreveinTimer}
              hasOreveinAwaitingArrival={hasOreveinAwaitingArrival}
            />
          )}

          {data.complete ? (
            <>
              <hr style={divider} />
              <div style={completionStamp}>THIS WORK IS DONE</div>
              <div style={{ textAlign: 'center', marginTop: '6px' }}>
                Return this writ to the Contract Ledger to claim the bounty.
              </div>
              <div
                style={{
                  textAlign: 'center',
                  fontSize: '0.9em',
                  marginTop: '4px',
                  color: 'hsl(30, 35%, 40%)',
                }}
              >
                Place it on the marked area or put it on the ledger.
              </div>
            </>
          ) : data.blockade_failed ? (
            <>
              <hr style={divider} />
              <div style={failedStamp}>
                THE BLOCKADE HELD, THIS WRIT HAS LAPSED
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
                By Royal Seal and Ducal Prerogative, the bearer of this writ is
                held exempt from the Crown&apos;s Levy upon its reward.
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
              {!!data.is_defense && <SealBannerView seal={COMMISSION_SEAL} />}
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
