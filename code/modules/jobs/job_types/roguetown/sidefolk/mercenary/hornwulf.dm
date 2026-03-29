// barbarian-like subclass with soft-nudist (no armor) and no Fast Reflexes,
// supposed to soak up damage with their con and skinarmor and chop shit up with class-exclusive axes
/datum/advclass/mercenary/hornwulf
	name = "Hornwulf"
	tutorial = "You belong to a spiritual and martial tradition originating in Hammerhold; through acts \
	of incredible heroism and grandeur, you aspire to ascend to one of the seven constellations of divinity \
	within the Host of the Ten Thousand. With only your body, your wits, and dwarf-forged steel in hand, \
	you will propel yourself into the annals of history! Later generations will marvel at your deeds \
	and give libations to shrines bearing your image! Embody the values of your patron to numinous \
	perfection, achieve phenomenal things by the light of providence, or elsewise die in the attempt!"
	allowed_races = list(
		/datum/species/dwarf,
		/datum/species/dwarf/mountain
		)
	outfit = /datum/outfit/job/roguetown/mercenary/hornwulf
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_RACIAL
	cmode_music = 'sound/music/combat_dwarf.ogg'
	extra_context = "The Hornwulfs worship only the deities sanctioned by the Celestial Empire by the time of \
	its fall." // Can't worship the Four, as Dwarves are presumably too old fashioned to worship such new gods.

	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_SHIRTLESS) //TRAIT_SHIRTLESS prevents equip on the head, armor and shirt slots and enables class-specific weapons
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 5,
		STATKEY_WIL = 2,
		STATKEY_INT = -3, // Brain dented in an accident involving 2 squirrels and a drunk zizite.
		STATKEY_SPD = -1,
		STATKEY_PER = -1
	)

	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN, // Butcher trolls
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, // Sew up the countless holes you will be receiving
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 12) // I'm sorry but you're not grabbing muscular and aiming chest with 12 speed 17 strength swift intent spam.

/datum/outfit/job/roguetown/mercenary/hornwulf
	allowed_patrons = NON_PSYDON_PATRONS

/datum/outfit/job/roguetown/mercenary/hornwulf/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		to_chat(H, span_warning("You are a Hornwulf, an aspirant to divinity within Hammerholdian \
		religion. By acts of incredible heroism you will achieve your place in the hero cults \
		of your homeland, or you will die in the attempt."))
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/axedance)
		armor = /obj/item/clothing/suit/roguetown/armor/regenerating/hornwulf
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
		backr = /obj/item/storage/backpack/rogue/satchel
		belt = /obj/item/storage/belt/rogue/leather/hornwulf
		beltr = /obj/item/storage/hip/headhook
		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife = 1,
			/obj/item/roguekey/mercenary = 1,
			/obj/item/rope/chain = 1,
			/obj/item/natural/head/troll = 1 // will spawn inside of the belt but I can't be bothered to make it spawn in the headhook
		)
		var/weapons = list("Hatchets", "Greataxe")
		var/weapon_choice = input("Choose your weapon", "How will you channel your rage?") as anything in weapons
		switch(weapon_choice)
			if("Greataxe")
				backl = /obj/item/rogueweapon/stoneaxe/battle/hornwulf
			if("Hatchets")
				backl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/hornwulf
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/hornwulf
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)

/obj/item/rogueweapon/stoneaxe/woodcut/steel/hornwulf
	name = "hornwulf's axe"
	desc = "It is by the strike of this axe, and the splendour of its wielder, that the Seven Godheads \
	will rumble with the introduction of an immortal hero."
	force = 26
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/axe/bash)
	gripped_intents = null
	icon_state = "slayer_axe"
	icon = 'icons/roguetown/weapons/axes32.dmi'
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_SWIFT
	thrown_bclass = BCLASS_CHOP
	throwforce = 30
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 35, "embedded_fall_chance" = 10)
	resistance_flags = FIRE_PROOF
	max_blade_int = 250
	minstr = 9
	wdefense = 4
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/stoneaxe/battle/hornwulf
	name = "hornwulf's greataxe"
	desc = "It is possible to become a component of divinity, but it is by no means easy. \
	This is the axe of a dwarven hero - on occassion, a grand player in the annals of history, \
	but more frequently do these figures burn before they reach the heavens."
	force = 20
	force_wielded = 34 // Slightly weaker than the double bladed greataxe, but the edge doesn't dull quickly.
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH)
	gripped_intents = list(/datum/intent/axe/cut/long, /datum/intent/axe/chop/long, SPEAR_BASH)
	icon_state = "slayer"
	icon = 'icons/roguetown/weapons/axes64.dmi'
	dropshrink = 0.6
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	equip_delay_self = 1.5 SECONDS
	unequip_delay_self = 1.5 SECONDS
	wlength = WLENGTH_NORMAL
	resistance_flags = FIRE_PROOF
	max_blade_int = 350
	minstr = 11
	wdefense = 4

/obj/item/rogueweapon/stoneaxe/battle/hornwulf/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.4,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
	return ..()

/obj/item/clothing/suit/roguetown/armor/regenerating/hornwulf // a bit of natural armor to offset the nudism and shitty dodge. not too hard to break but will slowly repair itself
	name = "rough skin"
	desc = "'YER'LL HAVE 'TAH HIT HARDER THAN THAT!'"
	icon_state = null
	armor = ARMOR_MAILLE
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	body_parts_covered = COVERAGE_NEARLY_FULL
	body_parts_inherent = COVERAGE_NEARLY_FULL
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_race = list(
		/datum/species/dwarf,
		/datum/species/dwarf/mountain
		)
	surgery_cover = FALSE 
	max_integrity = 135
	sewrepair = FALSE
	repairmsg_begin = "The thick skin cover starts to bulge and repair tears"
	repairmsg_continue = "More of the tears on the skin close up"
	repairmsg_stop = "A firm blow undoes some of the fresh skin you've grown!"
	repairmsg_end = "Your skin looks just as shiny as ever, like it might stop the blow of a fully grown troll once more."

	interrupt_damount = 25
	repair_time = 35 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/hornwulf/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/regenerating/hornwulf/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/regenerating/hornwulf/obj_destruction()
	visible_message(span_bloody("The dwarf flinches from the blow!"), vision_distance = 3) // visual que for breaking

/obj/effect/proc_holder/spell/self/axedance
	name = "Dance of the Axes" // rage button. gives maniac traits, some stats and removes the user's ability to dodge and parry. dunks stamina on expiration
	desc = "You channel your divine rage and turn into an unstoppable juggernaut of steel. You will not defend \
	yourself from attacks while it lasts."
	overlay_state = "axedance"
	antimagic_allowed = TRUE
	recharge_time = 3 MINUTES
	ignore_cockblock = TRUE
	invocations = list("WITNESS ME!!!")
	invocation_type = "shout"
	sound = 'sound/magic/axedance.ogg'

/obj/effect/proc_holder/spell/self/axedance/cast(mob/living/user)
	user.apply_status_effect(/datum/status_effect/buff/axedance)
	return TRUE

#define AXEDANCE_FILTER "axedance_red"

/atom/movable/screen/alert/status_effect/buff/axedance
	name = "Dance of the Axes"
	desc = span_bloody("I AM AN AVATAR OF DIVINE MIGHT")
	icon_state = "buff"

/datum/status_effect/buff/axedance
	var/outline_colour = "#EB4445"
	id = "axedance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/axedance
	duration = 30 SECONDS // should be enough to balance it out
	effectedstats = list("speed" = 3, "strength" = 3)

/datum/status_effect/buff/axedance/on_apply()
	. = ..()
	var/filter = owner.get_filter(AXEDANCE_FILTER)
	if (!filter)
		owner.add_filter(AXEDANCE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("I AM AN AVATAR OF DIVINE MIGHT!"))
	ADD_TRAIT(owner, TRAIT_HARDDISMEMBER, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_INFINITE_STAMINA, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_NODEF, STATUS_EFFECT_TRAIT)
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, STATUS_EFFECT_TRAIT)

/datum/status_effect/buff/axedance/on_remove()
	. = ..()
	to_chat(owner, span_warning("My rage subsides. I feel exhausted."))
	owner.remove_filter(AXEDANCE_FILTER)
	REMOVE_TRAIT(owner, TRAIT_HARDDISMEMBER, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_INFINITE_STAMINA, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_BLOODLOSS_IMMUNE, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NODEF, STATUS_EFFECT_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, STATUS_EFFECT_TRAIT)
	owner.apply_status_effect(/datum/status_effect/debuff/axe_exhaustion)
	owner.stamina = 400

#undef AXEDANCE_FILTER

/atom/movable/screen/alert/status_effect/debuff/axe_exhaustion
	name = "Hornwulf Exhaustion"
	desc = "My body is recovering from my axedance"
	icon_state = "debuff"

/datum/status_effect/debuff/axe_exhaustion
	var/outline_colour = "#EB4445"
	id = "axe_axhaustion"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/axe_exhaustion
	duration = 8 SECONDS // actually let people get away from him after the rage.
	effectedstats = list("speed" = -5)

/obj/item/storage/belt/rogue/leather/hornwulf
	name = "rugged dwarven belt"
	desc = "The golden beard of the face plate doubles as a codpiece."
	icon_state = "slayer"
	item_state = "slayer"
	sellprice = 50
	detail_tag = "_belt"
	sewrepair = FALSE
