import { type CSSProperties, type ReactNode, useState } from 'react';
import { Button, Input } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  type DocumentProfileId,
  type DocumentProfileTexts,
  getResidentManuscriptTexts,
  type OwnerStatusKey,
  type ResidentManuscriptTexts,
  type VerificationResult,
} from './ResidentManuscript/localization';

type OwnerData = {
  name: string | null;
  age: string | number | null;
  status: OwnerStatusKey | null;
  status_key: OwnerStatusKey;
};

type OwnerAgeKey = 'Adult' | 'Middle-Aged' | 'Old';

type SealData = {
  key: string;
  label: string;
  stamped: BooleanLike;
  stamper: string;
  visible: BooleanLike;
  suspicious: BooleanLike;
  priority: number;
  dominant: BooleanLike;
};

type VerificationData = {
  done: BooleanLike;
  result: VerificationResult;
  note_key: string | null;
  defect_note_key: string | null;
  defect_note_keys: string[];
};

type PermissionsData = {
  can_edit: BooleanLike;
  can_stamp: BooleanLike;
  can_inspect: BooleanLike;
  can_claim: BooleanLike;
  can_bind: BooleanLike;
  stamp_key: string | null;
};

type ProfileData = {
  id: DocumentProfileId | string | null;
  paper_color: string | null;
  ink_color: string | null;
  accent_color: string | null;
  seal_color: string | null;
};

type ResidentManuscriptData = {
  language: string | null;
  owner: OwnerData;
  issued_place: string | null;
  expiry_date: string | null;
  is_bound: BooleanLike;
  is_fake: BooleanLike;
  is_blank: BooleanLike;
  is_owner: BooleanLike;
  profile?: ProfileData;
  seals: SealData[];
  dominant_seal: SealData | null;
  verification: VerificationData;
  permissions: PermissionsData;
};

type ThemeStyle = CSSProperties & {
  '--rm-paper'?: string;
  '--rm-ink'?: string;
  '--rm-accent'?: string;
  '--rm-seal'?: string;
};

const PROFILE_FALLBACK: DocumentProfileId = 'resident';
const OWNER_AGE_OPTIONS: OwnerAgeKey[] = ['Adult', 'Middle-Aged', 'Old'];

const resolveProfileId = (
  profile: ProfileData | undefined,
  texts: ResidentManuscriptTexts,
): DocumentProfileId => {
  const candidate = (profile?.id as DocumentProfileId) ?? PROFILE_FALLBACK;
  return candidate in texts.profiles ? candidate : PROFILE_FALLBACK;
};

const resolveProfileTexts = (
  texts: ResidentManuscriptTexts,
  id: DocumentProfileId,
): DocumentProfileTexts =>
  texts.profiles[id] ?? texts.profiles[PROFILE_FALLBACK];

const buildThemeStyle = (profile: ProfileData | undefined): ThemeStyle => {
  const style: ThemeStyle = {};
  if (profile?.paper_color) {
    style['--rm-paper'] = profile.paper_color;
  }
  if (profile?.ink_color) {
    style['--rm-ink'] = profile.ink_color;
  }
  if (profile?.accent_color) {
    style['--rm-accent'] = profile.accent_color;
  }
  if (profile?.seal_color) {
    style['--rm-seal'] = profile.seal_color;
  }
  return style;
};

const displayValue = (
  value: string | number | null | undefined,
  emptyText: string,
): string => {
  if (value === null || value === undefined || value === '') {
    return emptyText;
  }
  return String(value);
};

const classes = (...classNames: Array<string | false | null | undefined>) =>
  classNames.filter(Boolean).join(' ');

const hasDefect = (defectKeys: string[], defectKey: string): boolean =>
  defectKeys.includes(defectKey);

const toOwnerAgeKey = (
  value: string | number | null | undefined,
): OwnerAgeKey | null => {
  if (value === null || value === undefined) {
    return null;
  }
  const text = String(value);
  return OWNER_AGE_OPTIONS.includes(text as OwnerAgeKey)
    ? (text as OwnerAgeKey)
    : null;
};

const ownerAgeLabel = (
  value: string | number | null | undefined,
  texts: ResidentManuscriptTexts,
): string => {
  const key = toOwnerAgeKey(value);
  if (key) {
    return texts.owner_age_options[key] || key;
  }
  return displayValue(value, texts.states.empty);
};

const getSealTitle = (
  seal: SealData,
  texts: ResidentManuscriptTexts,
): string => texts.seals[seal.key]?.title || seal.label || seal.key;

const getSealStamper = (
  seal: SealData,
  texts: ResidentManuscriptTexts,
): string => {
  if (seal.suspicious) {
    return texts.states.unclear_hand;
  }
  return texts.seals[seal.key]?.stamper || seal.stamper || seal.key;
};

const getSealMark = (
  seal: SealData,
  texts: ResidentManuscriptTexts,
): string => {
  const title = getSealTitle(seal, texts);
  return title.trim().slice(0, 1) || seal.key.trim().slice(0, 1);
};

export const ResidentManuscript = () => {
  const { act, data } = useBackend<ResidentManuscriptData>();
  const {
    language,
    owner,
    issued_place,
    expiry_date,
    is_bound,
    is_blank,
    is_owner,
    profile,
    seals = [],
    verification,
    permissions,
  } = data;

  const texts = getResidentManuscriptTexts(language);
  const profileId = resolveProfileId(profile, texts);
  const profileTexts = resolveProfileTexts(texts, profileId);
  const themeStyle = buildThemeStyle(profile);
  const profileClassName = `ResidentManuscript--profile-${profileId}`;
  const ownerStatusKey: OwnerStatusKey = owner.status_key;
  const [ownerName, setOwnerName] = useState(owner.name ?? '');
  const [ownerAge, setOwnerAge] = useState<OwnerAgeKey>(
    toOwnerAgeKey(owner.age) || 'Adult',
  );
  const [ownerStatus, setOwnerStatus] = useState<OwnerStatusKey>(
    ownerStatusKey,
  );

  const canEdit = !!permissions.can_edit;
  const defectKeys = verification.defect_note_keys ?? [];
  const defectNotes = defectKeys.map((key) => texts.defects[key] || key);
  const validationNote = verification.note_key
    ? texts.validation_notes[verification.note_key]
    : '';
  const verificationText =
    validationNote ||
    texts.verification[verification.result] ||
    texts.verification.none;
  const ownerStatusLabel =
    texts.owner_status_options[ownerStatusKey] ||
    texts.owner_status_options.commoner;
  const sheetClassName = classes(
    'ResidentManuscript__sheet',
    defectKeys.length > 0 && 'ResidentManuscript__sheet--defective',
    ...defectKeys.map((key) => `ResidentManuscript__sheet--${key}`),
  );

  return (
    <Window
      width={820}
      height={760}
      title={profileTexts.display_name || texts.window_title}
      theme="grimoire"
    >
      <Window.Content className="ResidentManuscriptWindow" scrollable>
        <div
          className={classes('ResidentManuscript', profileClassName)}
          style={themeStyle}
        >
          <div className={sheetClassName}>
            <DefectOverlay defectKeys={defectKeys} texts={texts} />
            <DocumentOrnament position="top" />
            <main className="ResidentManuscript__body">
              <header className="ResidentManuscript__header">
                <DocumentCrest profileId={profileId} />
                <div className="ResidentManuscript__titleBlock">
                  <div className="ResidentManuscript__pretitle">
                    {profileTexts.subtitle}
                  </div>
                  <div className="ResidentManuscript__title">
                    {profileTexts.display_name}
                  </div>
                  <div className="ResidentManuscript__subtitle">
                    {texts.subtitle_prefix}
                  </div>
                </div>
              </header>

              <div className="ResidentManuscript__divider" />

              <section className="ResidentManuscript__recipientBlock">
                <div className="ResidentManuscript__fieldLabel">
                  {texts.labels.owner}
                </div>
                <div
                  className={classes(
                    'ResidentManuscript__recipient',
                    hasDefect(defectKeys, 'owner_wobble') &&
                      'ResidentManuscript__recipient--ownerWobble',
                  )}
                >
                  {canEdit ? (
                    <Input
                      fluid
                      placeholder={texts.placeholders.owner}
                      value={ownerName}
                      onChange={setOwnerName}
                    />
                  ) : (
                    displayValue(owner.name, texts.states.empty)
                  )}
                </div>
              </section>

              <div className="ResidentManuscript__bodyText">
                {profileTexts.description}
              </div>

              <section className="ResidentManuscript__fields">
                <ManuscriptField label={texts.labels.age}>
                  {canEdit ? (
                    <div className="ResidentManuscript__choiceButtons">
                      {OWNER_AGE_OPTIONS.map((key) => (
                        <Button
                          key={key}
                          selected={ownerAge === key}
                          onClick={() => setOwnerAge(key)}
                        >
                          {texts.owner_age_options[key] || key}
                        </Button>
                      ))}
                    </div>
                  ) : (
                    ownerAgeLabel(owner.age, texts)
                  )}
                </ManuscriptField>

                <ManuscriptField label={texts.labels.status}>
                  {canEdit ? (
                    <div className="ResidentManuscript__choiceButtons">
                      {(
                        Object.keys(
                          texts.owner_status_options,
                        ) as OwnerStatusKey[]
                      ).map((key) => (
                        <Button
                          key={key}
                          selected={ownerStatus === key}
                          onClick={() => setOwnerStatus(key)}
                        >
                          {texts.owner_status_options[key]}
                        </Button>
                      ))}
                    </div>
                  ) : (
                    displayValue(ownerStatusLabel, texts.states.empty)
                  )}
                </ManuscriptField>

                <ManuscriptField label={texts.labels.issued}>
                  {displayValue(issued_place, texts.states.empty)}
                </ManuscriptField>

                <ManuscriptField
                  label={texts.labels.expires}
                  className={
                    hasDefect(defectKeys, 'corrected_date')
                      ? 'ResidentManuscript__field--correctedDate'
                      : undefined
                  }
                >
                  {displayValue(expiry_date, texts.states.empty)}
                </ManuscriptField>
              </section>

              <div className="ResidentManuscript__notice">
                {!is_bound
                  ? texts.states.unbound
                  : is_owner
                    ? texts.states.owner
                    : texts.states.other}
              </div>

              {!!is_blank && (
                <div className="ResidentManuscript__note">
                  {texts.states.blank_hint}
                </div>
              )}

              {canEdit && (
                <div className="ResidentManuscript__note">
                  {texts.states.fake_edit_hint}
                </div>
              )}

              <section className="ResidentManuscript__sealSection">
                <div className="ResidentManuscript__sectionTitle">
                  {texts.labels.seals}
                </div>
                <div className="ResidentManuscript__seals">
                  {seals
                    .filter((seal) => !!seal.visible)
                    .map((seal) => (
                      <ResidentManuscriptSeal
                        defectKeys={defectKeys}
                        key={seal.key}
                        seal={seal}
                        texts={texts}
                      />
                    ))}
                </div>
              </section>

              <section className="ResidentManuscript__verification">
                <div className="ResidentManuscript__sectionTitle">
                  {texts.labels.verification}
                </div>
                <div
                  className={`ResidentManuscript__verificationText ResidentManuscript__verificationText--${verification.result}`}
                >
                  {verificationText}
                </div>
                {verification.result === 'fake' && defectNotes.length > 0 && (
                  <div className="ResidentManuscript__defects">
                    <div className="ResidentManuscript__defectTitle">
                      {texts.labels.defects}
                    </div>
                    {defectNotes.map((note) => (
                      <div className="ResidentManuscript__defect" key={note}>
                        {note}
                      </div>
                    ))}
                  </div>
                )}
              </section>

              <div className="ResidentManuscript__actions">
                {canEdit && (
                  <Button
                    icon="save"
                    tooltip={texts.tooltips.save}
                    onClick={() =>
                      act('save_fake', {
                        owner_name: ownerName,
                        owner_age: ownerAge,
                        owner_status_key: ownerStatus,
                      })
                    }
                  >
                    {texts.buttons.save}
                  </Button>
                )}

                {!!permissions.can_bind && (
                  <Button
                    icon="signature"
                    tooltip={texts.tooltips.bind}
                    onClick={() => act('bind')}
                  >
                    {texts.buttons.bind}
                  </Button>
                )}

                {!!permissions.can_stamp && (
                  <Button
                    icon="stamp"
                    tooltip={texts.tooltips.stamp}
                    onClick={() => act('stamp')}
                  >
                    {texts.buttons.stamp}
                  </Button>
                )}

                {!!permissions.can_inspect && (
                  <Button
                    icon="search"
                    tooltip={texts.tooltips.inspect}
                    onClick={() => act('inspect')}
                  >
                    {texts.buttons.inspect}
                  </Button>
                )}

                {!!permissions.can_claim && (
                  <Button
                    icon="key"
                    tooltip={texts.tooltips.claim}
                    onClick={() => act('claim_residence')}
                  >
                    {texts.buttons.claim}
                  </Button>
                )}
              </div>
            </main>
            <DocumentOrnament position="bottom" />
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};

type ManuscriptFieldProps = {
  label: string;
  children: ReactNode;
  className?: string;
};

type DocumentOrnamentProps = {
  position: 'top' | 'bottom';
};

const DocumentOrnament = (props: DocumentOrnamentProps) => {
  const { position } = props;

  return (
    <div
      className={classes(
        'ResidentManuscript__ornament',
        `ResidentManuscript__ornament--${position}`,
      )}
      aria-hidden="true"
    >
      <svg viewBox="0 0 760 78" preserveAspectRatio="none">
        <path
          className="ResidentManuscript__ornamentGold"
          d="M30 40 C84 9 147 9 201 39 C244 63 287 63 330 39 C352 27 369 19 380 14 C391 19 408 27 430 39 C473 63 516 63 559 39 C613 9 676 9 730 40"
          fill="none"
        />
        <path
          className="ResidentManuscript__ornamentBlue"
          d="M38 52 C86 24 139 24 187 50 M573 50 C621 24 674 24 722 52"
          fill="none"
        />
        <path
          className="ResidentManuscript__ornamentBlue"
          d="M238 42 C281 16 329 16 372 42 M388 42 C431 16 479 16 522 42"
          fill="none"
        />
        <path
          className="ResidentManuscript__ornamentGold"
          d="M380 9 L390 33 L416 34 L395 49 L402 73 L380 58 L358 73 L365 49 L344 34 L370 33 Z"
        />
      </svg>
    </div>
  );
};

type DocumentCrestProps = {
  profileId: DocumentProfileId;
};

const PROFILE_EMBLEMS: Record<DocumentProfileId, ReactNode> = {
  resident: (
    <>
      <path
        className="ResidentManuscript__crestRay"
        d="M48 28 L54 46 L72 46 L57 56 L62 74 L48 64 L34 74 L39 56 L24 46 L42 46 Z"
      />
      <rect
        className="ResidentManuscript__crestEmblem"
        x="32"
        y="76"
        width="32"
        height="6"
      />
      <circle className="ResidentManuscript__crestGem" cx="34" cy="32" r="3" />
      <circle className="ResidentManuscript__crestGem" cx="48" cy="22" r="3.5" />
      <circle className="ResidentManuscript__crestGem" cx="62" cy="32" r="3" />
    </>
  ),
  guards: (
    <>
      <path
        className="ResidentManuscript__crestEmblem"
        d="M48 24 L52 30 L52 78 L48 84 L44 78 L44 30 Z"
      />
      <path
        className="ResidentManuscript__crestEmblem"
        d="M30 36 L66 36 L66 42 L30 42 Z"
      />
      <path
        className="ResidentManuscript__crestQuarter"
        d="M22 56 L48 70 L74 56"
        fill="none"
      />
      <circle className="ResidentManuscript__crestGem" cx="48" cy="34" r="3" />
    </>
  ),
  church: (
    <>
      <circle
        className="ResidentManuscript__crestEmblem"
        cx="48"
        cy="56"
        r="14"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M48 24 L51 38 L45 38 Z M48 88 L51 74 L45 74 Z M16 56 L30 53 L30 59 Z M80 56 L66 53 L66 59 Z M26 34 L36 42 L32 46 Z M70 34 L60 42 L64 46 Z M26 78 L36 70 L32 66 Z M70 78 L60 70 L64 66 Z"
      />
      <circle className="ResidentManuscript__crestGem" cx="48" cy="56" r="5" />
    </>
  ),
  craftsmen: (
    <>
      <path
        className="ResidentManuscript__crestEmblem"
        d="M22 78 L74 78 L74 72 L62 68 L34 68 L22 72 Z"
      />
      <rect
        className="ResidentManuscript__crestEmblem"
        x="30"
        y="58"
        width="36"
        height="10"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M40 22 L60 22 L60 32 L52 38 L52 56 L44 56 L44 38 L40 32 Z"
      />
      <circle className="ResidentManuscript__crestGem" cx="48" cy="48" r="3" />
    </>
  ),
  merchant: (
    <>
      <path
        className="ResidentManuscript__crestEmblem"
        d="M22 64 Q24 48 36 42 Q40 32 46 30 L56 28 Q62 30 66 36 Q72 40 74 50 L74 60 Q72 70 60 72 L28 72 Q22 70 22 64 Z"
      />
      <path
        className="ResidentManuscript__crestEmblem"
        d="M44 30 L42 22 L48 26 Z"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M70 38 L74 30 M68 44 L74 46"
        fill="none"
      />
      <circle className="ResidentManuscript__crestGem" cx="62" cy="44" r="2" />
    </>
  ),
  mages: (
    <>
      <path
        className="ResidentManuscript__crestRay"
        d="M48 22 L54 42 L74 42 L58 54 L64 74 L48 62 L32 74 L38 54 L22 42 L42 42 Z"
      />
      <ellipse
        className="ResidentManuscript__crestEmblem"
        cx="48"
        cy="50"
        rx="11"
        ry="6"
      />
      <circle className="ResidentManuscript__crestGem" cx="48" cy="50" r="3" />
    </>
  ),
  inn: (
    <>
      <path
        className="ResidentManuscript__crestEmblem"
        d="M30 36 L60 36 L62 70 Q62 76 56 76 L34 76 Q28 76 28 70 Z"
      />
      <path
        className="ResidentManuscript__crestQuarter"
        d="M62 44 Q72 44 72 56 Q72 68 62 68"
        fill="none"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M30 36 Q34 28 38 32 Q42 26 46 32 Q50 26 54 32 Q58 28 60 36"
        fill="none"
      />
      <circle className="ResidentManuscript__crestGem" cx="44" cy="56" r="2.5" />
    </>
  ),
  bathhouse: (
    <>
      <path
        className="ResidentManuscript__crestEmblem"
        d="M48 22 Q56 38 56 50 Q56 64 48 70 Q40 64 40 50 Q40 38 48 22 Z"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M28 40 Q24 56 36 66 Q42 62 42 50 Q40 44 28 40 Z"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M68 40 Q72 56 60 66 Q54 62 54 50 Q56 44 68 40 Z"
      />
      <circle className="ResidentManuscript__crestGem" cx="48" cy="50" r="3" />
    </>
  ),
  commoner: (
    <>
      <path
        className="ResidentManuscript__crestEmblem"
        d="M48 26 L48 80"
        fill="none"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M48 28 Q42 32 42 38 Q44 34 48 34 Q52 34 54 38 Q54 32 48 28 Z"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M48 40 Q40 44 38 52 Q42 48 48 48 Q54 48 58 52 Q56 44 48 40 Z"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M48 52 Q38 56 34 66 Q40 62 48 62 Q56 62 62 66 Q58 56 48 52 Z"
      />
      <circle className="ResidentManuscript__crestGem" cx="48" cy="76" r="3" />
    </>
  ),
  mercenary: (
    <>
      <path
        className="ResidentManuscript__crestEmblem"
        d="M30 30 L48 18 L66 30 L66 50 L60 64 L72 76 L48 70 L24 76 L36 64 L30 50 Z"
      />
      <path
        className="ResidentManuscript__crestQuarter"
        d="M40 38 L42 42 L40 46 Z M56 38 L54 42 L56 46 Z"
        fill="none"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M44 54 L48 60 L52 54 L51 60 L45 60 Z"
      />
      <circle className="ResidentManuscript__crestGem" cx="42" cy="42" r="1.5" />
      <circle className="ResidentManuscript__crestGem" cx="54" cy="42" r="1.5" />
    </>
  ),
  otava: (
    <>
      <path
        className="ResidentManuscript__crestEmblem"
        d="M28 56 L36 78 L60 78 L68 56 L66 44 L30 44 Z"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M48 18 Q56 30 50 40 Q44 32 48 18 Z"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M40 24 Q46 34 42 42 Q38 34 40 24 Z"
      />
      <path
        className="ResidentManuscript__crestRay"
        d="M56 24 Q54 34 56 42 Q60 34 56 24 Z"
      />
      <circle className="ResidentManuscript__crestGem" cx="48" cy="62" r="3" />
    </>
  ),
};

const DocumentCrest = (props: DocumentCrestProps) => {
  const { profileId } = props;
  const emblem = PROFILE_EMBLEMS[profileId] ?? PROFILE_EMBLEMS.resident;

  return (
    <svg
      className={classes(
        'ResidentManuscript__crest',
        `ResidentManuscript__crest--${profileId}`,
      )}
      aria-hidden="true"
      viewBox="0 0 96 112"
    >
      <path
        className="ResidentManuscript__crestShield"
        d="M48 8 L82 20 V52 C82 76 67 94 48 104 C29 94 14 76 14 52 V20 Z"
      />
      {emblem}
    </svg>
  );
};

const ManuscriptField = (props: ManuscriptFieldProps) => {
  const { label, children, className } = props;

  return (
    <div className={classes('ResidentManuscript__field', className)}>
      <div className="ResidentManuscript__fieldLabel">{label}</div>
      <div className="ResidentManuscript__fieldValue">{children}</div>
    </div>
  );
};

type ResidentManuscriptSealProps = {
  defectKeys: string[];
  seal: SealData;
  texts: ResidentManuscriptTexts;
};

const ResidentManuscriptSeal = (props: ResidentManuscriptSealProps) => {
  const { defectKeys, seal, texts } = props;
  const sealClassName = classes(
    'ResidentManuscript__seal',
    !!seal.stamped && 'ResidentManuscript__seal--stamped',
    !!seal.dominant && 'ResidentManuscript__seal--dominant',
    !!seal.suspicious && 'ResidentManuscript__seal--suspicious',
    hasDefect(defectKeys, 'seal_smudge') &&
      'ResidentManuscript__seal--smudged',
    hasDefect(defectKeys, 'reheated_wax') &&
      'ResidentManuscript__seal--reheated',
    hasDefect(defectKeys, 'uncertain_hand') &&
      'ResidentManuscript__seal--uncertain',
  );

  const sealTitle = getSealTitle(seal, texts);
  const sealStamper = getSealStamper(seal, texts);

  return (
    <div
      className={sealClassName}
      aria-label={`${texts.aria.seal}: ${sealTitle}`}
    >
      <div className="ResidentManuscript__sealName">{sealTitle}</div>
      {seal.stamped ? (
        <>
          <div
            className={classes(
              'ResidentManuscript__waxSeal',
              seal.key === 'ruler' && 'ResidentManuscript__waxSeal--royal',
            )}
          >
            <span className="ResidentManuscript__waxSealMark">
              {getSealMark(seal, texts)}
            </span>
            {seal.key === 'ruler' && (
              <svg
                className="ResidentManuscript__waxSealCrown"
                aria-hidden="true"
                viewBox="0 0 80 80"
              >
                <g
                  fill="#f3c164"
                  stroke="#5c0c0c"
                  strokeLinejoin="round"
                  strokeWidth="2"
                >
                  <path d="M22 48 L25 28 L34 40 L40 24 L47 40 L56 28 L59 48 Z" />
                  <path d="M24 51 H58 V57 H24 Z" />
                  <circle cx="25" cy="27" r="3" />
                  <circle cx="40" cy="23" r="3" />
                  <circle cx="56" cy="27" r="3" />
                </g>
              </svg>
            )}
          </div>
          <div className="ResidentManuscript__sealMark">
            {displayValue(sealStamper, texts.states.unknown)}
          </div>
        </>
      ) : (
        <div className="ResidentManuscript__sealMissing">
          {texts.states.seal_missing}
        </div>
      )}
    </div>
  );
};

type DefectOverlayProps = {
  defectKeys: string[];
  texts: ResidentManuscriptTexts;
};

const FRESH_PRICKING_OFFSETS = [0, 18, 36, 54, 72, 90, 108, 126, 144];
const RETHREADED_CORD_OFFSETS = [18, 46, 74];

const DefectOverlay = (props: DefectOverlayProps) => {
  const { defectKeys, texts } = props;

  if (!defectKeys.length) {
    return null;
  }

  return (
    <div className="ResidentManuscript__defectOverlay" aria-hidden="true">
      {hasDefect(defectKeys, 'ink_blot') && (
        <div className="ResidentManuscript__visualDefect ResidentManuscript__visualDefect--inkBlot" />
      )}
      {hasDefect(defectKeys, 'stale_smell') && (
        <div className="ResidentManuscript__visualDefect ResidentManuscript__visualDefect--staleSmell" />
      )}
      {hasDefect(defectKeys, 'blue_halo') && (
        <div className="ResidentManuscript__visualDefect ResidentManuscript__visualDefect--blueHalo" />
      )}
      {hasDefect(defectKeys, 'ragged_edge') && (
        <svg
          className="ResidentManuscript__visualDefect ResidentManuscript__visualDefect--raggedEdge"
          viewBox="0 0 18 600"
          preserveAspectRatio="none"
        >
          <path
            d="M13 0 L7 38 L15 72 L5 111 L13 153 L6 196 L16 234 L7 279 L14 322 L5 366 L12 410 L6 454 L15 498 L7 548 L13 600"
            fill="none"
            stroke="rgba(138, 26, 26, 0.72)"
            strokeLinecap="round"
            strokeWidth="2.2"
          />
        </svg>
      )}
      {hasDefect(defectKeys, 'misaligned_initial') && (
        <div className="ResidentManuscript__visualDefect ResidentManuscript__visualDefect--misalignedInitial">
          {texts.visual_hints.misaligned_initial}
        </div>
      )}
      {hasDefect(defectKeys, 'fresh_pricking') && (
        <div className="ResidentManuscript__visualDefect ResidentManuscript__visualDefect--freshPricking">
          <div className="ResidentManuscript__freshPrickingLine ResidentManuscript__freshPrickingLine--top" />
          <div className="ResidentManuscript__freshPrickingLine ResidentManuscript__freshPrickingLine--bottom" />
          {FRESH_PRICKING_OFFSETS.map((left) => (
            <span key={left} style={{ left: `${left}px` }} />
          ))}
        </div>
      )}
      {hasDefect(defectKeys, 'cut_gilding') && (
        <svg
          className="ResidentManuscript__visualDefect ResidentManuscript__visualDefect--cutGilding"
          viewBox="0 0 700 28"
          preserveAspectRatio="none"
        >
          <path
            d="M12 17 L72 17 L86 7 L102 18 L190 18 L207 9 L223 19 L366 19 L382 8 L397 18 L520 18 L538 9 L554 19 L686 19"
            fill="none"
            stroke="rgba(124, 94, 26, 0.74)"
            strokeLinecap="round"
            strokeWidth="2.4"
          />
          <path
            d="M86 7 L92 21 M207 9 L213 22 M382 8 L389 22 M538 9 L545 22"
            fill="none"
            stroke="rgba(138, 26, 26, 0.58)"
            strokeLinecap="round"
            strokeWidth="1.5"
          />
        </svg>
      )}
      {hasDefect(defectKeys, 'rethreaded_cord') && (
        <div className="ResidentManuscript__visualDefect ResidentManuscript__visualDefect--rethreadedCord">
          <div className="ResidentManuscript__rethreadedCordLine" />
          {RETHREADED_CORD_OFFSETS.map((left) => (
            <span key={left} style={{ left: `${left}px` }} />
          ))}
        </div>
      )}
      {hasDefect(defectKeys, 'heretical_marginalia') && (
        <div className="ResidentManuscript__visualDefect ResidentManuscript__visualDefect--hereticalMarginalia">
          {texts.visual_hints.heretical_marginalia_lines.map((line) => (
            <div key={line}>{line}</div>
          ))}
        </div>
      )}
    </div>
  );
};
