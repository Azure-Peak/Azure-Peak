import { type ReactNode, useState } from 'react';
import { Button, Input } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  getResidentManuscriptTexts,
  type OwnerStatusKey,
  type VerificationResult,
} from './ResidentManuscript/localization';

type OwnerData = {
  name: string | null;
  age: string | number | null;
  class: string | null;
  status: OwnerStatusKey | null;
  status_key: OwnerStatusKey;
};

type SealData = {
  key: string;
  label: string;
  stamped: BooleanLike;
  stamper: string;
  visible: BooleanLike;
  suspicious: BooleanLike;
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

type ResidentManuscriptData = {
  language: string | null;
  owner: OwnerData;
  issued_place: string | null;
  expiry_date: string | null;
  is_bound: BooleanLike;
  is_fake: BooleanLike;
  is_blank: BooleanLike;
  is_owner: BooleanLike;
  seals: SealData[];
  verification: VerificationData;
  permissions: PermissionsData;
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
    seals = [],
    verification,
    permissions,
  } = data;

  const texts = getResidentManuscriptTexts(language);
  const ownerStatusKey: OwnerStatusKey =
    owner.status_key === 'noble' ? 'noble' : 'commoner';
  const [ownerName, setOwnerName] = useState(owner.name ?? '');
  const [ownerAge, setOwnerAge] = useState(String(owner.age ?? ''));
  const [ownerClass, setOwnerClass] = useState(owner.class ?? '');
  const [ownerStatus, setOwnerStatus] = useState<OwnerStatusKey>(
    ownerStatusKey,
  );

  const canEdit = !!permissions.can_edit;
  const defectNotes = (verification.defect_note_keys ?? []).map(
    (key) => texts.defects[key] || key,
  );
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

  return (
    <Window width={760} height={860} title={texts.window_title} theme="grimoire">
      <Window.Content scrollable>
        <div className="ResidentManuscript">
          <div className="ResidentManuscript__sheet">
            <header className="ResidentManuscript__header">
              <div className="ResidentManuscript__subtitle">
                {texts.subtitle_prefix}
              </div>
              <div className="ResidentManuscript__title">{texts.title}</div>
            </header>

            <div className="ResidentManuscript__bodyText">
              {texts.description}
            </div>

            <section className="ResidentManuscript__fields">
              <ManuscriptField label={texts.labels.owner}>
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
              </ManuscriptField>

              <ManuscriptField label={texts.labels.age}>
                {canEdit ? (
                  <Input
                    fluid
                    placeholder={texts.placeholders.age}
                    value={ownerAge}
                    onChange={setOwnerAge}
                  />
                ) : (
                  displayValue(owner.age, texts.states.empty)
                )}
              </ManuscriptField>

              <ManuscriptField label={texts.labels.class}>
                {canEdit ? (
                  <Input
                    fluid
                    placeholder={texts.placeholders.class}
                    value={ownerClass}
                    onChange={setOwnerClass}
                  />
                ) : (
                  displayValue(owner.class, texts.states.empty)
                )}
              </ManuscriptField>

              <ManuscriptField label={texts.labels.status}>
                {canEdit ? (
                  <div className="ResidentManuscript__statusButtons">
                    <Button
                      selected={ownerStatus === 'commoner'}
                      onClick={() => setOwnerStatus('commoner')}
                    >
                      {texts.owner_status_options.commoner}
                    </Button>
                    <Button
                      selected={ownerStatus === 'noble'}
                      onClick={() => setOwnerStatus('noble')}
                    >
                      {texts.owner_status_options.noble}
                    </Button>
                  </div>
                ) : (
                  displayValue(ownerStatusLabel, texts.states.empty)
                )}
              </ManuscriptField>

              <ManuscriptField label={texts.labels.issued}>
                {displayValue(issued_place, texts.states.empty)}
              </ManuscriptField>

              <ManuscriptField label={texts.labels.expires}>
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
                    <div
                      className={
                        seal.stamped
                          ? 'ResidentManuscript__seal ResidentManuscript__seal--stamped'
                          : 'ResidentManuscript__seal'
                      }
                      key={seal.key}
                      aria-label={`${texts.aria.seal}: ${seal.label}`}
                    >
                      <div className="ResidentManuscript__sealName">
                        {seal.label}
                      </div>
                      <div className="ResidentManuscript__sealMark">
                        {seal.stamped
                          ? displayValue(seal.stamper, texts.states.unknown)
                          : texts.states.seal_missing}
                      </div>
                    </div>
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
                      owner_class: ownerClass,
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
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};

type ManuscriptFieldProps = {
  label: string;
  children: ReactNode;
};

const ManuscriptField = (props: ManuscriptFieldProps) => {
  const { label, children } = props;

  return (
    <div className="ResidentManuscript__field">
      <div className="ResidentManuscript__fieldLabel">{label}</div>
      <div className="ResidentManuscript__fieldValue">{children}</div>
    </div>
  );
};
