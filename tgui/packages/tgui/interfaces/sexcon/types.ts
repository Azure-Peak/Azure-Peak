export interface SexAction {
  name: string;
  type: string;
  description: string;
  requires_grab: boolean;
}

export interface Participant {
  name: string;
  ref: string;
}

export interface SexSessionData {
  // Static data
  actions: SexAction[];
  speed_names: string[];
  force_names: string[];
  has_penis: boolean;
  has_knotted_penis: boolean;

  // Dynamic data
  title: string;
  character_info: string;
  current_action: string | null;
  speed: number;
  force: number;
  manual_arousal: number;
  do_until_finished: boolean;
  do_knot_action: boolean;

  // Arousal tracking
  arousal: number;
  pleasure: number;
  pain: number;
  frozen: boolean;

  // Which actions can be performed
  can_perform: string[];

  // Session info
  session_name: string;
  participants: Participant[];
}