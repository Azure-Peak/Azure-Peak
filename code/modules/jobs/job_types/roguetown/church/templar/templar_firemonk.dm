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
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)

/datum/outfit/job/roguetown/templar/firemonk
	var/sidearm_selected

/datum/outfit/job/roguetown/templar/firemonk/Topic(href, href_list)
	. = ..()
	if(href_list["sidearm"])
		sidearm_selected = href_list["sidearm"]

/datum/outfit/job/roguetown/templar/firemonk/pre_equip(mob/living/carbon/human/H)
	..()
	backl = /obj/item/storage/backpack/rogue/satchel/short //genuinely looks like dogass with the normal satchel
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
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy/firemonk
	belt = /obj/item/storage/belt/rogue/leather/suspenders
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/storage/keyring/acolyte
	shoes = /obj/item/clothing/shoes/roguetown/boots/firemonk
	H.cmode_music = 'sound/music/cmode/church/combat_firemonk.ogg'

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.set_chant("unarmed")

	// ! see below comment !
	// i dont mind debating whenever or not they should get t1 or t2. i just think that the t1 ravox stuff is genuinely useless
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2, start_maxed = TRUE)


	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/coordinated_assault)
		H.mind.AddSpell(new /datum/action/cooldown/spell/fervid_emotions)
		H.mind.AddSpell(new /datum/action/cooldown/spell/fiery_waltz)
		H.mind.AddSpell(new /datum/action/cooldown/spell/iron_mountain)

/datum/outfit/job/roguetown/templar/firemonk/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Discipline - Unarmed","Arbiter","Knuckledusters")

	var/weapon_choice = input(H,"Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Discipline - Unarmed")
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/bandages/pugilist(H))
		if("Arbiter")
			H.put_in_hands(new /obj/item/rogueweapon/katar/ravox(H))
		if("Knuckledusters")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/knuckles(H))

	var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves
	var/technique_choice = input(H,"Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques
	switch(technique_choice)
		if("Dropkick - Pushback + Extra Damage")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
		if("Chokeslam - Stamina Damage")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
		if("Stunner - Dazed Debuff")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
		if("Headbutt - Vulnerable Debuff")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)

//literally just a hardened leather coat - people can buy this shit round start from the tailor silver face w/o any real drawbacks.
//im trying 2 reduce the desire 2 replace the class's unique shit, but im fine with kicking it back down to the normal shit if ppl r unhappy
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
