GLOBAL_LIST_INIT(familiar_types, list(
				"Sprite" = /mob/living/simple_animal/pet/familiar/fae,
				"Hellhound" = /mob/living/simple_animal/pet/familiar/infernal,
				"Warden" = /mob/living/simple_animal/pet/familiar/elemental,
				"Void Drakeling" = /mob/living/simple_animal/pet/familiar/void,
				"Pondstone Toad" = /mob/living/simple_animal/pet/familiar/elemental/pondstone_toad,
				"Mist Lynx" = /mob/living/simple_animal/pet/familiar/fae/mist_lynx,
				"Rune Rat" = /mob/living/simple_animal/pet/familiar/fae/rune_rat,
				"Vaporroot Wisp" = /mob/living/simple_animal/pet/familiar/fae/vaporroot_wisp,
				"Ashcoiler" = /mob/living/simple_animal/pet/familiar/infernal/ashcoiler,
				"Glimmer Hare" = /mob/living/simple_animal/pet/familiar/fae/glimmer_hare,
				"Hollow Antlerling" = /mob/living/simple_animal/pet/familiar/fae/hollow_antlerling,
				"Gravemoss Serpent" = /mob/living/simple_animal/pet/familiar/elemental/gravemoss_serpent,
				"Starfield Zad" = /mob/living/simple_animal/pet/familiar/fae/starfield_crow,
				"Emberdrake" = /mob/living/simple_animal/pet/familiar/infernal/emberdrake,
				"Ripplefox" = /mob/living/simple_animal/pet/familiar/fae/ripplefox,
				"Whisper Stoat" = /mob/living/simple_animal/pet/familiar/fae/whisper_stoat,
				"Thornback Turtle" = /mob/living/simple_animal/pet/familiar/elemental/thornback_turtle
))

GLOBAL_LIST_INIT(familiar_display_names, list(
    			/mob/living/simple_animal/pet/familiar/fae = "Sprite",
				/mob/living/simple_animal/pet/familiar/infernal = "Hellhound",
				/mob/living/simple_animal/pet/familiar/elemental = "Warden",
				/mob/living/simple_animal/pet/familiar/void = "Void Drakeling",
				/mob/living/simple_animal/pet/familiar/elemental/pondstone_toad = "Pondstone Toad",
				/mob/living/simple_animal/pet/familiar/fae/mist_lynx = "Mist Lynx",
				/mob/living/simple_animal/pet/familiar/fae/rune_rat = "Rune Rat",
				/mob/living/simple_animal/pet/familiar/fae/vaporroot_wisp = "Vaporroot Wisp",
				/mob/living/simple_animal/pet/familiar/infernal/ashcoiler = "Ashcoiler",
				/mob/living/simple_animal/pet/familiar/fae/glimmer_hare = "Glimmer Hare",
				/mob/living/simple_animal/pet/familiar/fae/hollow_antlerling = "Hollow Antlerling",
				/mob/living/simple_animal/pet/familiar/elemental/gravemoss_serpent = "Gravemoss Serpent",
				/mob/living/simple_animal/pet/familiar/fae/starfield_crow = "Starfield Zad",
				/mob/living/simple_animal/pet/familiar/infernal/emberdrake = "Emberdrake",
				/mob/living/simple_animal/pet/familiar/fae/ripplefox = "Ripplefox",
				/mob/living/simple_animal/pet/familiar/fae/whisper_stoat = "Whisper Stoat",
				/mob/living/simple_animal/pet/familiar/elemental/thornback_turtle = "Thornback Turtle"
))

GLOBAL_LIST_INIT(familiar_lore_blurbs, list(
    /mob/living/simple_animal/pet/familiar/elemental/pondstone_toad = "Pondstone Toads are ancient, patient creatures, said to carry the wisdom of the marshes. They are calm, resilient, and often serve as silent observers.",
    /mob/living/simple_animal/pet/familiar/fae/mist_lynx = "Mist Lynxes are elusive and mysterious, moving unseen through fog and shadow. They are clever, perceptive, and fiercely loyal to those they trust.",
    /mob/living/simple_animal/pet/familiar/fae/rune_rat = "Rune Rats are quick-witted and curious, always seeking knowledge. They are drawn to secrets and the written word, leaving trails of glowing runes wherever they go.",
    /mob/living/simple_animal/pet/familiar/fae/vaporroot_wisp = "Vaporroot Wisps are gentle spirits of mist and healing. They drift quietly, bringing calm and comfort to those around them.",
    /mob/living/simple_animal/pet/familiar/infernal/ashcoiler = "Ashcoilers are serpents born of long-forgotten hearth fires and latent magic. Patient and enduring, their presence brings resilience.",
    /mob/living/simple_animal/pet/familiar/fae/glimmer_hare = "Glimmer Hares are quick and elusive, their bodies shimmering with light. They are symbols of luck and agility, always a step ahead of danger.",
    /mob/living/simple_animal/pet/familiar/fae/hollow_antlerling = "Hollow Antlerlings are gentle forest spirits, symbols of luck and renewal. They are playful, curious, and bring fortune to their companions.",
    /mob/living/simple_animal/pet/familiar/elemental/gravemoss_serpent = "Gravemoss Serpents are ancient guardians of the earth, their scales flecked with lichen and grave-dust. They are wise, patient, and deeply connected to the cycle of life and death.",
    /mob/living/simple_animal/pet/familiar/fae/starfield_crow = "Starfield Crows are mysterious and intelligent, their feathers shimmering with constellations. They are omens of fate and keepers of secrets.",
    /mob/living/simple_animal/pet/familiar/infernal/emberdrake = "Emberdrakes are tiny dragons of warmth and memory. Their presence stirs old stories and brings comfort in the darkest nights.",
    /mob/living/simple_animal/pet/familiar/fae/ripplefox = "Ripplefoxes are tricksters and guides, flickering at the edge of sight. They are masters of illusion and always seem to know more than they let on.",
    /mob/living/simple_animal/pet/familiar/fae/whisper_stoat = "Whisper Stoats are subtle and insightful, listening to thoughts and secrets. They are trusted confidants and clever companions.",
    /mob/living/simple_animal/pet/familiar/elemental/thornback_turtle = "Thornback Turtles are sturdy guardians, embodying endurance and protection. They are slow to anger but steadfast in defense of their friends.",
	/mob/living/simple_animal/pet/familiar/void = "Void Drakelings are creatures of arcyne hubris, created by tearing a fragment of draconic power from the void. They are voracious, dangerous, and terribly intelligent."
))

GLOBAL_LIST_INIT(fae_familiars, list(
	"Sprite","Mist Lynx","Rune Rat","Vaporroot Wisp","Glimmer Hare","Hollow Antlerling","Ripplefox","Whisper Stoat","Starfield Zad"
))

GLOBAL_LIST_INIT(infernal_familiars, list(
	"Hellhound","Ashcoiler","Emberdrake"
))

GLOBAL_LIST_INIT(elemental_familiars, list(
	"Warden","Pondstone Toad","Gravemoss Serpent","Thornback Turtle"
))
