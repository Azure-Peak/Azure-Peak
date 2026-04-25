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
  writBody,
} from './QuestScroll/shared';
import { UndeadWrit } from './QuestScroll/UndeadWrit';

type WritBodyProps = {
  data: QuestScrollData;
  realm: string;
  rulerTitle: string;
  reward: number;
  levyRate: number;
  levyExempt: boolean;
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
  const rewardProps = { reward, levyRate, levyExempt };
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
      <Window title="Contract Scroll" width={520} height={620} theme="parchment">
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
  const hasMarginalia =
    hasWhisper || showProgress || hasBlockadeTimer || !!data.blockade_armed;
  const hasSealBanners = !!(data.is_defense || data.levy_exempt);

  const isOutlawry =
    data.writ_type !== WRIT_TYPE_RECOVERY &&
    data.writ_type !== WRIT_TYPE_CARRIAGE;
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
              bearer={bearer}
              issuedBy={issuedBy}
              crimes={crimes}
              hasRecoveryAddendum={hasRecoveryAddendum}
            />
          </div>

          {hasMarginalia && (
            <Marginalia>
              {hasWhisper && (
                <WhisperLine
                  compass={data.compass_direction || ''}
                  zHint={data.z_hint}
                />
              )}
              {showProgress && (
                <ProgressLine
                  done={data.progress_current ?? 0}
                  total={data.progress_required ?? 1}
                  noun={data.faction_progress_noun || 'foes'}
                />
              )}
              {hasBlockadeTimer && (
                <BlockadeTimer
                  label={data.blockade_timer_label || ''}
                  seconds={data.blockade_timer_seconds ?? 0}
                />
              )}
              {!!data.blockade_armed && !data.blockade_timer_label && (
                <div style={marginaliaLine}>
                  <i>Travel to the blockade, waves descend on arrival.</i>
                </div>
              )}
            </Marginalia>
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
                  fontStyle: 'italic',
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
                  letterSpacing: '0.5px',
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
        </div>
      </Window.Content>
    </Window>
  );
};
