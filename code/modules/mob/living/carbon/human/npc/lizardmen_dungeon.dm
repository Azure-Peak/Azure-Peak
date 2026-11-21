GLOBAL_LIST_INIT(psyvault_aggro, world.file2list("strings/rt/psyvaultaggrolines.txt"))
//These guys are intended to be no joke, if they are getting stomped something is wrong
//Intended difficulty [HARD]
/mob/living/carbon/human/species/lizardfolk/psy_vault_guard
	race = /datum/species/lizardfolk
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_PSY_VAULT_GUARD)
	ambushable = FALSE
	cmode = 1
	setparrytime = 20
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL)

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/ambush



/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/Initialize(mapload)
	. = ..()
	gender = pick(MALE, FEMALE)
	set_species(/datum/species/lizardfolk)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	transform = transform.Scale(1.25, 1.25)
	transform = transform.Translate(0, 0.25 * 16)
	update_transform()

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.psyvault_aggro, TRUE)
	//This Stuff handles their parts
	var/obj/item/organ/tail/lizard/tail = src.getorganslot(ORGAN_SLOT_TAIL)
	var/obj/item/organ/snout/lizard/psy_vault_guard/snout = src.getorganslot(ORGAN_SLOT_SNOUT)
	var/obj/item/organ/ears/psy_vault_guard/ears = src.getorganslot(ORGAN_SLOT_EARS)
	if(tail)
		tail.Remove(src,1)
		QDEL_NULL(tail)
	tail = new /obj/item/organ/tail/lizard
	tail.Insert(src)
	if(snout)
		snout.Remove(src,1)
		QDEL_NULL(snout)
	snout = new /obj/item/organ/snout/lizard/psy_vault_guard
	snout.Insert(src)
	if(ears)
		ears.Remove(src,1)
		QDEL_NULL(ears)
	ears = new /obj/item/organ/ears/psy_vault_guard
	ears.Insert(src)
	//This Stuff handles their parts
	job = "Zardman Jailer"
	real_name = "Zardman Jailer"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BIGGUY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard)
	patron = /datum/patron/old_god
	update_hair()
	update_body()
	update_overlays()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = HEAD_BOUNTY_LIZARDMAN
	random_voice_NPC()
	random_eye_color_NPC()
	src.regenerate_icons() //Fixes the weird body but lets check performance first


/datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard/pre_equip(mob/living/carbon/human/H)
	..()
	//Body Stufff
	H.skin_tone = "e9d298"
	//purity afloat
	H.grant_language(/datum/language/otavan)
	ADD_TRAIT(H, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
	//Clothing Stuff
	if(prob(20))
		cloak = /obj/item/clothing/cloak/absolutionistrobe/black
	//Head Gear
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	armor = /obj/item/clothing/suit/roguetown/armor/vestments_padded //ENDVRE
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	//Lower Gear
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt

/datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard/proc/add_random_psy_vault_guard_mask(mob/living/carbon/human/H)
	var/add_random_psy_vault_guard_mask = rand(1,5)
	switch(add_random_psy_vault_guard_mask)
		if(1)
			mask = /obj/item/clothing/mask/rogue/facemask/psydonmask
		if(2)
			mask = /obj/item/clothing/mask/rogue/sack/psy
		if(3)
			head = /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns
		if(4)
			head = /obj/item/clothing/head/roguetown/roguehood/psydon

/datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard/proc/add_random_psy_vault_guard_psycross(mob/living/carbon/human/H)
	var/add_random_psy_vault_guard_psycross = rand(1,5)
	switch(add_random_psy_vault_guard_psycross)
		if(1)
			wrists = /obj/item/clothing/neck/roguetown/psicross/aalloy
		if(2)
			wrists = /obj/item/clothing/neck/roguetown/psicross/wood
		if(3)
			wrists = /obj/item/clothing/neck/roguetown/psicross/silver
		if(4)
			wrists = /obj/item/clothing/neck/roguetown/psicross
		if(5)
			wrists = /obj/item/clothing/wrists/roguetown/bracers/psythorns

/datum/npc_loadout/kit/zizo_cantrip_arc_bolt
	traits = list(TRAIT_WARLOCK) //to use w/ weapon
	spells = list(/datum/action/cooldown/spell/projectile/arc_bolt)
