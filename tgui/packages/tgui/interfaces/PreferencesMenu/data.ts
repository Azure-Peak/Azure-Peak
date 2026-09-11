import type { BooleanLike } from 'tgui-core/react';

export type Path = string;
export type Color = string; // Color, may or may not include #

export type AllPagesData = {
  current_tab: number;
};

export type GameSettingsData = {
  tgui_theme: string;
  parchment_skin: string;
  statbrowser_theme: string;
  tgui_lock: BooleanLike;
  ambientocclusion: BooleanLike;
  windowflashing: BooleanLike;
  clientfps: number;
  auto_fit_viewport: BooleanLike;
  schizo_voice: BooleanLike;
  no_storyteller_events: BooleanLike;
  verbose_character_creator: BooleanLike;
  antags: Antag[];
  admin_prefs: AdminPrefData | null; // null indicates not an admin
};

export type Antag = {
  key: string; // remember to capitalize for display!
  banned: BooleanLike;
  days_remaining: number | null; // null indicates unlocked
  enabled: BooleanLike;
};

export type AdminPrefData = {
  sound_adminhelp: BooleanLike;
  sound_prayers: BooleanLike;
  announce_login: BooleanLike;
  combohud_lighting: BooleanLike;
  show_dsay: BooleanLike;
  show_prayer: BooleanLike;
  allow_asaycolor: BooleanLike;
  asaycolor: Color;
  auto_deadmin_players: BooleanLike;
  deadmin_player: BooleanLike;
  auto_deadmin_antagonists: BooleanLike;
  deadmin_antagonist: BooleanLike;
  auto_deadmin_heads: BooleanLike;
  deadmin_head: BooleanLike;
};

export type KeybindsPageData = {
  keybindings: KeyBind[];
};

export type KeyBind = {
  full_name: string;
  name: string;
  default_keys: string[] | null; // empty or null indicates no defaults;
  user_binds: string[] | null; // empty or null indicates unbound;
};
