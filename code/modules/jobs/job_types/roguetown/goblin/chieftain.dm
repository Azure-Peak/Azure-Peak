
/datum/job/roguetown/goblinking
	title = "Goblin King"
	flag = GOBLINKING
	department_flag = GOBLIN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(SPEC_ID_GOBLINP)
	allowed_patrons = list(/datum/patron/inhumen/graggar)
	tutorial = "Goblin King is a fatty lazy pig who wishes to do nothing but eat apple pies and fart while sitting on his stone throne."
	whitelist_req = FALSE
	outfit = /datum/outfit/job/roguetown/goblinking

	display_order = JDO_GOBLINKING
	min_pq = 2
	max_pq = null

/datum/outfit/job/roguetown/goblinking/pre_equip(mob/living/carbon/human/H)
	..()
	H.verbs |= /mob/living/carbon/human/proc/goblinannouncement
	//H.verbs |= /mob/living/carbon/human/proc/goblinopenslot
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltr = /obj/item/storage/belt/rogue/pouch/coins/rich
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	head = /obj/item/clothing/head/roguetown/crown/surplus
	cloak = /obj/item/clothing/cloak/heartfelt
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_CON, 6)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_SPD, -2)

/mob/living/carbon/human/proc/goblinannouncement()
	set name = "Announcement"
	set category = "Goblin King"
	if(stat)
		return
	var/inputty = input("Make an announcement", "ROGUETOWN") as text|null
	if(inputty)
		if(!istype(get_area(src), /area/rogue/indoors/shelter/mountains/decap))
			to_chat(src, span_warning("I need to do this from the Goblin Kingdom."))
			return FALSE
		priority_announce("[inputty]", title = "The Goblin King Squeals", sound = 'sound/misc/dun.ogg', sender = src)


