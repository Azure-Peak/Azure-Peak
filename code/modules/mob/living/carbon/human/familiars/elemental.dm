/mob/living/carbon/human/species/familiar/elemental
	name = "Warden"
	desc = "One of the smaller elementals, this strange being is hard and unyielding as stone, yet malleable as clay when it needs to be."
	summoning_emote = "The ground begins to rumble as a pile of raw earth erupts, forming into the rough visage of a humanoid figure!"
	race = /datum/species/familiar/elemental
	icon_state = "warden"

	speak_emote = list ("rumbles", "grinds")
	inherent_spell = list(/datum/action/cooldown/spell/magicians_stone/elemental)
	t1_spell = list(/datum/action/cooldown/spell/earthen_forge, /datum/action/cooldown/spell/earthen_forge/wall)
	t2_spell = list(/datum/action/cooldown/spell/arcyne_forge/elementalt2)
	valid_healing_items = list(/obj/item/magic/elemental)
	tierup_messages = list(
		span_info("You can now shape your earthen form into tools and weapons, including those capable of repairing equipment."),
		span_info("You can now use the ground itself to shape tools and weapons, instead of using your own body.")
	)
	planar_origin = "elemental"
	STACON = 8 // these guys are tankier
	voiceclips = list('sound/foley/stone_scrape.ogg')

/datum/species/familiar/elemental
	name = "Elemental"
	id = "elemental"
	origin = "The Depths"
	origin_default = /datum/virtue/origin/familiar/elemental

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
	speak_emote = list("croaks low", "grumbles")

/mob/living/carbon/human/species/familiar/elemental/gravemoss_serpent
	name = "Gravemoss Serpent"
	desc = "Its scales are flecked with lichen and grave-dust. Wherever it passes, roots twitch faintly in the soil."
	summoning_emote = "The ground heaves faintly as a long, moss-veiled serpent uncoils from it."
	icon_state = "gravemoss"
	speak_emote = list("hisses low", "mutters")

/mob/living/carbon/human/species/familiar/elemental/thornback_turtle
	name = "Thornback Turtle"
	desc = "It barely moves, but seems unshakable. Vines twist gently around its limbs."
	summoning_emote = "The ground gives a slow rumble. A turtle with a bark-like shell emerges from the soil."
	icon_state = "thornback"
	speak_emote = list("rumbles", "speaks slowly")

/mob/living/carbon/human/species/familiar/elemental/brass_thrum
	name = "Brass Thrum"
	desc = "A mechanical spider-like creature of brass and whirring gears, its movements precise and accompanied by a faint, rhythmic hum."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_clock"
	summoning_emote = "A metallic clatter as a brass spider-like automaton unfolds itself."
	speak_emote = list("chitters", "whirs")

/mob/living/carbon/human/species/familiar/elemental/gemspire_beetle
	name = "Gemspire Beetle"
	desc = "A four-legged, spider-like automaton adorned with crystalline spires, blending arcane energy with intricate clockwork."
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_gem"
	summoning_emote = "A faint chime as a gem-encrusted mechanical beetle scuttles into view."
	speak_emote = "chimes"
