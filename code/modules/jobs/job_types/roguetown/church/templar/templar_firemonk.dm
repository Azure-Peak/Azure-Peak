//design intent - not actually a mage, just a monk that's been enhanced by magic
//and uses arcyne momentum mechanics
//spells mostly rely on empowerment for good burn application
//inflicts burn on other templars around them for buffs.
//i swear grief potential'll be negligible due 2 how its spread to other templars. promise
//burn is a status effect that deals fire damage equal to its stack, then reduces said stack by 1/3rd. procs every five seconds
//the most burn someone should have in an actual fight is abt 28-35~

/datum/advclass/templar/firemonk
	name = "Iron Meihua"
	tutorial = "You're a transfer from a Lingyuese Ravoxian sect - bought out by the Azurean Church after your sect's master was forced to sell \
	out his disciple's skills to the Holy See in order to ensure his temple's survival from economical struggles caused by Kazengite officials. \
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
	cloak = /obj/item/clothing/cloak/templar/ravox/firemonk
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
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

/obj/item/clothing/cloak/templar/ravox/firemonk
	name = "crimson cheongsam"
	desc = "A dress with gold detailing, long red sleeves, and a slit across the side."
	icon = 'icons/roguetown/clothing/special/meihua.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/meihua.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/meihua.dmi'
	icon_state = "meihua"
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK|ITEM_SLOT_MASK
	flags_inv = HIDECROTCH|HIDEBOOB


/obj/item/clothing/cloak/templar/ravox/firemonk/equipped(mob/living/user, slot)
	..()
	if(!HAS_TRAIT(user, TRAIT_CIVILIZEDBARBARIAN))	//Requires this cus it's a monk-only thing.
		return
	ADD_TRAIT(user, TRAIT_MONK_ROBE, TRAIT_GENERIC)
	to_chat(user, span_notice("With my vows to poverty and my vestments, I feel vigorous - empowered by my God!"))

/obj/item/clothing/cloak/templar/ravox/firemonk/dropped(mob/living/user)
	..()
	REMOVE_TRAIT(user, TRAIT_MONK_ROBE, TRAIT_GENERIC)
	to_chat(user, span_notice("I must lay down my robes and rest; even God's chosen must rest.."))


/obj/item/clothing/shoes/roguetown/boots/firemonk
	name = "black shoes"
	desc = "Simple shoes. Cut down to expose the joints."
	icon = 'icons/roguetown/clothing/special/meihua.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/meihua.dmi'
	icon_state = "meihua_shoes"
