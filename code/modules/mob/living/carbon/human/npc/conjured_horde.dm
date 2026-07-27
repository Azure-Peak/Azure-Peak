/mob/living/carbon/human/species/dwarf/gnome/conjured_horde
	ai_controller = /datum/ai_controller/human_npc/melee
	d_intent = INTENT_PARRY
	faction = list(FACTION_NEUTRAL)
	dodgetime = 25
	var/loadout = "twinblade"
	var/arcane_scale = 3
	var/gear_tier = 1
	var/datum/weakref/summoner_ref

/mob/living/carbon/human/species/dwarf/gnome/conjured_horde/Initialize()
	. = ..()
	set_species(/datum/species/dwarf/gnome)
	gender = pick(MALE, FEMALE)
	dna.species.random_character(src)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/dwarf/gnome/conjured_horde/Destroy()
	release_conjured_gear()
	return ..()

/mob/living/carbon/human/species/dwarf/gnome/conjured_horde/after_creation()
	..()
	name = "phantasmal gnome"
	real_name = "phantasmal gnome"
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUSTABLE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUST_DELETE_GEAR, TRAIT_GENERIC)
	var/mob/living/master = summoner_ref?.resolve()
	if(master)
		if(master.mind && master.mind.current)
			master = master.mind.current
		summoner = master.real_name
		faction = list("[master.real_name]_faction")
		apply_fellowship_faction(master, src)
	equipOutfit(new /datum/outfit/job/roguetown/conjured_gnome)
	for(var/obj/item/gear in (get_equipped_items() + held_items))
		ADD_TRAIT(gear, TRAIT_NODROP, TRAIT_GENERIC)
	def_intent_change(INTENT_PARRY)
	dna.species.handle_body(src)
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()
	update_hair()
	update_body()
	regenerate_icons()

/datum/outfit/job/roguetown/conjured_gnome/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/tier = 1
	var/loadout = "twinblade"
	if(istype(H, /mob/living/carbon/human/species/dwarf/gnome/conjured_horde))
		var/mob/living/carbon/human/species/dwarf/gnome/conjured_horde/G = H
		tier = G.gear_tier
		loadout = G.loadout
	H.STASTR = 8 + tier
	H.STACON = 4 + tier
	H.STAWIL = 4 + tier
	H.STAPER = 7
	var/skill = clamp(tier * 2, 2, 4)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/axes, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, skill, TRUE)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/brown
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	pants = /obj/item/clothing/under/roguetown/trou
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	head = /obj/item/clothing/head/roguetown/helmet/coppercap
	neck = null
	l_hand = null
	switch(loadout)
		if("legionnaire")
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, skill, TRUE)
			r_hand = /obj/item/rogueweapon/sword/short/ashort
			l_hand = /obj/item/rogueweapon/shield/wood
		if("sling")
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, skill, TRUE)
			r_hand = null
			wrists = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			neck = /obj/item/quiver/sling/stone
			H.STACON -= 1
			H.STAWIL -= 1
			H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
		if("flail")
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, skill, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, skill, TRUE)
			r_hand = /obj/item/rogueweapon/flail/aflail
			l_hand = /obj/item/rogueweapon/shield/wood
		if("spear")
			r_hand = /obj/item/rogueweapon/spear/stone
		if("bow")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, skill, TRUE)
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
			backl = /obj/item/quiver/conjured_stone
			H.STACON -= 1
			H.STAWIL -= 1
			H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
		else
			r_hand = /obj/item/rogueweapon/sword/stone
			l_hand = /obj/item/rogueweapon/sword/stone
			ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)

/datum/outfit/job/roguetown/conjured_gnome/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	var/obj/item/clothing/head/helm = H.head
	if(!istype(helm))
		return
	var/obj/item/clothing/head/roguetown/wizhat/hat = new /obj/item/clothing/head/roguetown/wizhat/red(H)
	if(!SEND_SIGNAL(helm, COMSIG_TRY_STORAGE_INSERT, hat, null, TRUE, TRUE))
		qdel(hat)
