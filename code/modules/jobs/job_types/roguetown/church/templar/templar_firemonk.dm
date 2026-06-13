//design intent - not actually a mage, just a monk that's been enhanced by magic
//and uses arcyne momentum mechanics
//spells mostly rely on current stress for how potent they are - bad mood: negligible burn affliction, good mood: viable burn affliction
//inflicts burn on themselves & other templars around them for buffs.
//i swear grief potential'll wont be too bad cuz ill prob throw in a trait that reduces burn as well
//burn is a status effect that deals fire damage equal to its stack, then reduces said stack by 1/3rd. procs every five seconds
//the most burn someone should have in an actual fight is abt 28-35~

/datum/advclass/templar/firemonk
	name = "Iron Meihua"
	tutorial = "You're a transfer from a Lingyuese Ravoxian sect - bought out by the Azurean Church after your sect's master was forced to sell \
	the skills of some of his disciples out to Holy See due to pressure from the Kazengites in order to continue his teachings. \
	You employ both a mix of magical enhancements in the form of skin tatoos similar to the Ruma Clan, coupled with martial arts and Ravoxian miracles. \
	Your strategy focuses on striking enemies to charge up your tattoos, transforming the energy into strikes that burn (and buff) those around you."
	outfit = /datum/outfit/job/roguetown/templar/firemonk
	allowed_patrons = list(/datum/patron/divine/ravox)
	maximum_possible_slots = 1
	category_tags = list(CTAG_TEMPLAR)
	subclass_languages = list(/datum/language/grenzelhoftian, /datum/language/lingyuese)
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_CON = 1 //ripped straight from spellfist adv
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)

/datum/outfit/job/roguetown/templar/firemonk/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/psicross/undivided
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	backl = /obj/item/storage/backpack/rogue/satchel
	mask = /obj/item/clothing/head/roguetown/roguehood/ravox
	neck = /obj/item/clothing/neck/roguetown/psicross/ravox
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		)
	// Patron dagger + sheath in satchel
	var/patron_dagger = get_templar_patron_dagger(H)
	if(patron_dagger)
		backpack_contents += patron_dagger
		backpack_contents += /obj/item/rogueweapon/scabbard/sheath
	head = /obj/item/clothing/head/roguetown/headband/monk
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy/firemonk
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/storage/keyring/acolyte
	shoes = /obj/item/clothing/shoes/roguetown/boots/firemonk
	H.cmode_music = 'sound/music/cmode/church/combat_firemonk.ogg'

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = "unarmed"


//literally just a hardened leather coat - people can buy this shit round start from the tailor silver face w/o any real drawbacks.
//im trying 2 reduce the need 2 replace the class's unique shit, but im fine with kicking it back down to the normal shit if ppl r unhappy
// ! please remove these comments/tell me if this pr is merged so i can remove em - zera !
/obj/item/clothing/suit/roguetown/shirt/robe/monk/holy/firemonk
	name = "crimson cheongsam"
	desc = "A dress with gold detailing, long red sleeves, and a slit across the side."
	icon = 'icons/roguetown/clothing/special/meihua.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/meihua.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/meihua.dmi'
	icon_state = "meihua"
	body_parts_covered = COVERAGE_ALL_BUT_ARMFEET
	armor = ARMOR_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	slot_flags = ITEM_SLOT_ARMOR

/obj/item/clothing/shoes/roguetown/boots/firemonk
	name = "black shoes"
	desc = "Simple shoes. Cut down to expose the joints."
	icon = 'icons/roguetown/clothing/special/meihua.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/meihua.dmi'
	icon_state = "meihua_shoes"
