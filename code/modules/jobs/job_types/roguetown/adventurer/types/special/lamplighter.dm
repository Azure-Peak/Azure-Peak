/datum/job/roguetown/lamplighter
	title = "Lamplighter"
	vice_restrictions = list()
	virtue_restrictions = list(/datum/virtue/combat/magical_potential, /datum/virtue/combat/devotee)
	flag = LAMPLIGHTER
	department_flag = WANDERERS
	faction = "Station"
	total_positions = 3
	spawn_positions = 3

	tutorial = "A seasoned member of the Roadsmans guild, you dedicate your life to keeping the roads and their wanderers safe from the various evils that go bump in the night no matter their allegiance or faith.."

	display_order = JDO_LAMPLIGHTER
	selection_color = JCOLOR_WANDERER
	show_in_credits = TRUE
	min_pq = 5
	max_pq = null

	advclass_cat_rolls = list(CTAG_LAMPLIGHTER = 20)
	PQ_boost_divider = 10

	announce_latejoin = FALSE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE

	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'

	job_subclasses = list(
		/datum/advclass/lampwarden,
		/datum/advclass/lampwicker,
	)

/datum/advclass/lampwarden
	name = "Lampwarden"
	tutorial = "Bastion to the Dark, you are a scared traveler's protector against the horrors of our realm. Be their guard and guide through these godless nites."
	outfit = /datum/outfit/job/roguetown/lampwarden
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	category_tags = list(CTAG_LAMPLIGHTER)
	traits_applied = list(TRAIT_OUTDOORSMAN)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/lampwarden/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a member of the Roadsman's guild. The Roadsman's guild is a neutral party in all affairs, their only concern is the safety of the roads and their wanderers."))
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/cauterize)
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/firestrike)
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/firespin)
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/oil_spill)
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/burn_it_down)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/survival/lampwarden)
	head = /obj/item/clothing/head/roguetown/inqhat/lamplighter/warden
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle/lamplighter
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/lamplighter/warden
	mask = /obj/item/clothing/mask/rogue/lamplighter
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/dark
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
						/obj/item/rogueweapon/huntingknife = 1)

/datum/advclass/lampwicker
	name = "Lampwicker"
	tutorial = "Salvation in the Light, you've saved many a tired and dying traveler under the protection of the Lampwardens. Be the comforting warmth through these godless nites."
	outfit = /datum/outfit/job/roguetown/lampwicker
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	category_tags = list(CTAG_LAMPLIGHTER)
	traits_applied = list(TRAIT_WOODSMAN)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_PER = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/lampwicker/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a member of the Roadsman's guild. The Roadsman's guild is a neutral party in all affairs, their only concern is the safety of the roads and their wanderers."))
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/scare_beast)
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/sooth_the_soul)
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/bulwark_of_oil)
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/smoke_food)
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/anoint_foe)
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/wicklight)
	H.mind.AddSpell(new /datum/action/cooldown/spell/lamplighter/provide_beacon)
	H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/survival/lampstaff)
	head = /obj/item/clothing/head/roguetown/inqhat/lamplighter
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle/lamplighter
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/lamplighter
	mask = /obj/item/clothing/mask/rogue/lamplighter/beaked
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/dark
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
						/obj/item/rogueweapon/huntingknife = 1)

// SPECIAL STAFF :SPARKLES:

/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter
	name = "lamplighter's staff"
	possible_item_intents = list(/datum/intent/spear/bash, /datum/intent/use)
	icon_state = "ironlamp"
	light_system = MOVABLE_LIGHT
	light_outer_range = 15
	light_power = 2
	light_color = "#e66b45"

/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/attack_right(mob/user)
	var/turf/target_turf = get_step(user,user.dir)
	if(target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		to_chat(user, span_danger("I can't plant the staff here!"))
		return NONE
	if(isopenturf(target_turf))
		deploy_lampstaff(user, target_turf)
		return TRUE
	return NONE

/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/get_mechanics_examine(mob/user)
	. += span_info("Right-Click the lampstaff to plant it into the floor, where it will function as a campfire.")
	. += span_info("I can <b>use</b> the lampstaff to light things as if it were a regular lamptern.")

/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if (!proximity)
		return
	if ((user.used_intent.type == /datum/intent/use))
		A.spark_act()

/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter/proc/deploy_lampstaff(mob/user, atom/location)
	to_chat(user, "<span class='notice'>You plant the staff down.</span>")
	new /obj/machinery/light/rogue/campfire/lamplighter(location)
	qdel(src)

/obj/machinery/light/rogue/campfire/lamplighter
	name = "lamplighter's staff"
	icon = 'icons/roguetown/misc/lighting64.dmi'
	icon_state = "ironlamp1"
	base_state = "ironlamp"
	bulb_colour = "#e66b45"
	on = TRUE
	fueluse = -1
	cookonme = FALSE
	max_integrity = 300
	density = 1

/obj/machinery/light/rogue/campfire/lamplighter/attack_right(mob/user)
	if(..())
		return TRUE
	user.visible_message(span_notice("[user] retrieves [src]."), span_notice("You pick up [src]."))
	new /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter(drop_location())
	qdel(src)
	return TRUE

/obj/machinery/light/rogue/campfire/lamplighter/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("I can right click the lampstaff to pull it off the floor.")

/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden
	name = "lampwarden's staff"
	possible_item_intents = list(/datum/intent/spear/bash, /datum/intent/use)
	icon_state = "wardlamp"
	light_system = MOVABLE_LIGHT
	light_outer_range = 15
	light_power = 2
	light_color = "#e66b45"

/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden/attack_right(mob/user)
	var/turf/target_turf = get_step(user,user.dir)
	if(target_turf.is_blocked_turf(TRUE) || (locate(/mob/living) in target_turf))
		to_chat(user, span_danger("I can't plant the staff here!"))
		return NONE
	if(isopenturf(target_turf))
		deploy_lampstaff(user, target_turf)
		return TRUE
	return NONE

/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden/get_mechanics_examine(mob/user)
	. += span_info("Right-click the lampstaff to plant it into the floor, where it will function as a campfire.")
	. += span_info("I can <b>use</b> the lampstaff to light things as if it were a regular lamptern.")

/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden/afterattack(atom/movable/A, mob/user, proximity)
	. = ..()
	if (!proximity)
		return
	if ((user.used_intent.type == /datum/intent/use))
		A.spark_act()

/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden/proc/deploy_lampstaff(mob/user, atom/location)
	to_chat(user, "<span class='notice'>You plant the staff down.</span>")
	new /obj/machinery/light/rogue/campfire/lampwarden(location)
	qdel(src)

/obj/machinery/light/rogue/campfire/lampwarden
	name = "lampwarden's staff"
	icon = 'icons/roguetown/misc/lighting64.dmi'
	icon_state = "wardlamp1"
	base_state = "wardlamp"
	bulb_colour = "#e66b45"
	on = TRUE
	fueluse = -1
	cookonme = FALSE
	max_integrity = 300
	density = 1

/obj/machinery/light/rogue/campfire/lampwarden/attack_right(mob/user)
	if(..())
		return TRUE
	user.visible_message(span_notice("[user] retrieves [src]."), span_notice("You pick up [src]."))
	new /obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden(drop_location())
	qdel(src)
	return TRUE

/obj/machinery/light/rogue/campfire/lampwarden/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("I can right click the lampstaff to pull it off the floor.")
