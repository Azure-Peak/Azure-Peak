export type ExaminePanelData = {
  // Identity
  character_name: string;
  headshot: string;
  obscured: boolean;
  // Descriptions
  flavor_text: string;
  ooc_notes: string;
  // Descriptions, but requiring manual input to see
  flavor_text_nsfw: string;
  ooc_notes_nsfw: string;
  img_gallery: string[];
  is_playing: boolean;
  has_song: boolean;
  is_vet: boolean;
  is_naked: boolean;
  examine_theme: string | null;
};
