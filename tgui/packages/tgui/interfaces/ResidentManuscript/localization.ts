import { residentManuscriptEn } from './locales/en';

export type OwnerStatusKey = 'commoner' | 'noble';
export type VerificationResult = 'none' | 'unknown' | 'real' | 'fake';

export type DocumentProfileId =
  | 'resident'
  | 'guards'
  | 'church'
  | 'craftsmen'
  | 'commoner'
  | 'mercenary'
  | 'otava';

export type DocumentProfileTexts = {
  display_name: string;
  subtitle: string;
  description: string;
};

export type ResidentManuscriptTexts = {
  window_title: string;
  title: string;
  subtitle_prefix: string;
  description: string;
  profiles: Record<DocumentProfileId, DocumentProfileTexts>;
  labels: {
    owner: string;
    age: string;
    status: string;
    expires: string;
    issued: string;
    seals: string;
    verification: string;
    defects: string;
  };
  buttons: {
    save: string;
    inspect: string;
    stamp: string;
    claim: string;
    bind: string;
  };
  tooltips: {
    save: string;
    inspect: string;
    stamp: string;
    claim: string;
    bind: string;
  };
  placeholders: {
    owner: string;
    age: string;
  };
  owner_status_options: Record<OwnerStatusKey, string>;
  states: {
    owner: string;
    other: string;
    unbound: string;
    blank_hint: string;
    fake_edit_hint: string;
    seal_missing: string;
    empty: string;
    unknown: string;
    unclear_hand: string;
  };
  verification: Record<VerificationResult, string>;
  aria: {
    seal: string;
  };
  seals: Record<string, { title: string; stamper: string }>;
  defects: Record<string, string>;
  visual_hints: {
    heretical_marginalia_lines: string[];
    misaligned_initial: string;
  };
  validation_notes: Record<string, string>;
};

const residentManuscriptLocales: Record<string, ResidentManuscriptTexts> = {
  en: residentManuscriptEn,
};

export const getResidentManuscriptTexts = (
  language: string | null | undefined,
): ResidentManuscriptTexts => {
  if (!language) {
    return residentManuscriptEn;
  }

  return residentManuscriptLocales[language] || residentManuscriptEn;
};
