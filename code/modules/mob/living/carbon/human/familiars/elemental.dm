/mob/living/carbon/human/species/familiar/elemental
	name = "Warden"
	desc = "One of the smaller elementals, this strange being is hard and unyielding as stone, yet malleable as clay when it needs to be."
	summoning_emote = "The ground begins to rumble as a pile of raw earth erupts, forming into the rough visage of a humanoid figure!"
	race = /datum/species/familiar/elemental
	icon_state = "warden"

	speak_emote = list ("rumbles", "grinds")
	tutorial_message = "As a denizen of the earthen depths, you are skilled at most forms of construction and repair. You can call forth stones from the earth, or shape yourself into tools and walls, including a staff tipped with a potent earthen gem; you may also shape earth into tools for your own use."
	inherent_spell = list(/datum/action/cooldown/spell/magicians_stone/elemental, /datum/action/cooldown/spell/earthen_forge, /datum/action/cooldown/spell/earthen_forge/wall, /datum/action/cooldown/spell/arcyne_forge/elementalt2)
	valid_healing_items = list(/obj/item/magic/elemental)
	planar_origin = "elemental"
	STACON = 8 // these guys are tankier
	voiceclips = list('sound/foley/stone_scrape.ogg')
	voice_desc = "rumbling"
	voice_desc_prefix = CUSTOM_PREFIX_HAS_A
	trait_desc = "earthen"
	trait_desc_prefix = CUSTOM_PREFIX_HAS_AN
	stature_desc = "warden"
	stature_desc_prefix = CUSTOM_PREFIX_HAS_A

/datum/species/familiar/elemental
	name = "Elemental"
	id = "elemental"
	origin = "The Depths"
	origin_default = /datum/virtue/origin/unselectable/elemental
	blood_color = "#5e1e0a" // rusty, brownish red = earthier

// so they can actually do repairs
/mob/living/carbon/human/species/familiar/elemental/Initialize(mapload)
	. = ..()
	src.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE)
	src.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE)
	src.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE)
	src.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE)
	src.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_EXPERT) // they can build stuff
	src.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_EXPERT)

/mob/living/carbon/human/species/familiar/elemental/is_aligned_leyline(obj/structure/leyline/ley)
	return istype(ley, /obj/structure/leyline/normal/coast)

/mob/living/carbon/human/species/familiar/elemental/pondstone_toad
	name = "Pondstone Toad"
	desc = "This damp, heavy toad pulses with unseen strength. Its skin is cool and lined with mineral veins."
	summoning_emote = "A deep thrum echoes beneath your feet, and a mossy toad pushes itself free from the earth, humming low."
	icon_state = "pondstone"
	speak_emote = list("croaks", "grumbles")
	voice_desc = "croaking"
	voice_desc_prefix = CUSTOM_PREFIX_HAS_A
	trait_desc = "earthen"
	trait_desc_prefix = CUSTOM_PREFIX_HAS_AN
	stature_desc = "amphibian"
	stature_desc_prefix = CUSTOM_PREFIX_HAS_AN

/mob/living/carbon/human/species/familiar/elemental/gravemoss_serpent
	name = "Gravemoss Serpent"
	desc = "Its scales are flecked with lichen and grave-dust. Wherever it passes, roots twitch faintly in the soil."
	summoning_emote = "The ground heaves faintly as a long, moss-veiled serpent uncoils from it."
	icon_state = "gravemoss"
	speak_emote = list("hisses", "mutters")
	voice_desc = "hissing"
	voice_desc_prefix = CUSTOM_PREFIX_HAS_A
	trait_desc = "earthen"
	trait_desc_prefix = CUSTOM_PREFIX_HAS_AN
	stature_desc = "serpent"
	stature_desc_prefix = CUSTOM_PREFIX_HAS_A

/mob/living/carbon/human/species/familiar/elemental/thornback_turtle
	name = "Thornback Turtle"
	desc = "It barely moves, but seems unshakable. Vines twist gently around its limbs."
	summoning_emote = "The ground gives a slow rumble. A turtle with a bark-like shell emerges from the soil."
	icon_state = "thornback"
	speak_emote = list("rumbles", "drawls")
	voice_desc = "pondrous"
	voice_desc_prefix = CUSTOM_PREFIX_HAS_A
	trait_desc = "vined"
	trait_desc_prefix = CUSTOM_PREFIX_HAS_A
	stature_desc = "tortoise"
	stature_desc_prefix = CUSTOM_PREFIX_HAS_A

/mob/living/carbon/human/species/familiar/elemental/brass_thrum
	name = "Brass Thrum"
	desc = "A mechanical spider-like creature of brass and whirring gears, its movements precise and accompanied by a faint, rhythmic hum."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_clock"
	summoning_emote = "A metallic clatter as a brass spider-like automaton unfolds itself."
	speak_emote = list("chitters", "whirs")
	voice_desc = "chittering"
	voice_desc_prefix = CUSTOM_PREFIX_HAS_A
	trait_desc = "mechanical"
	trait_desc_prefix = CUSTOM_PREFIX_HAS_A
	stature_desc = "spider"
	stature_desc_prefix = CUSTOM_PREFIX_HAS_A

/mob/living/carbon/human/species/familiar/elemental/gemspire_beetle
	name = "Gemspire Beetle"
	desc = "A four-legged, spider-like automaton adorned with crystalline spires, blending arcane energy with intricate clockwork."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_gem"
	summoning_emote = "A faint chime as a gem-encrusted mechanical beetle scuttles into view."
	speak_emote = "chimes"
	voice_desc = "chiming"
	voice_desc_prefix = CUSTOM_PREFIX_HAS_A
	trait_desc = "crystalline"
	trait_desc_prefix = CUSTOM_PREFIX_HAS_A
	stature_desc = "beetle"
	stature_desc_prefix = CUSTOM_PREFIX_HAS_A
