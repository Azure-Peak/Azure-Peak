/datum/outfit/job/roguetown/assassin/assassin_disguise
	name = "Naked"
	// EVERY assassin outfit needs a SHEATHE and a SHORT SATCHEL. if you ADD ARM ARMOR OR A BACKR SLOT, REPLACE THESE!!!
	wrists = /obj/item/rogueweapon/scabbard/sheath
	backr = /obj/item/storage/backpack/rogue/satchel/short
	var/extra_info
	can_be_admin_equipped = FALSE // use other jobs in 90% of instances


/datum/outfit/job/roguetown/assassin/assassin_disguise/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	// Some disguises may get a little extra if they have Cool Lore or some shit. IDFK. Why not. 
	if(extra_info)
		to_chat(H, span_info(extra_info))

// default "loud" option.
/datum/outfit/job/roguetown/assassin/assassin_disguise/assassin
	name = "Assassin"
	mask = /obj/item/clothing/mask/rogue/sack
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	cloak = /obj/item/clothing/cloak/poncho/evil
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/barbarian
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	can_be_admin_equipped = TRUE // actual unique equipment. the rest arent.

/datum/outfit/job/roguetown/assassin/assassin_disguise/beggar
	name = "Beggar"
	// outfit handled in pre equip as it requires prob()

// this is basically just copied from the actual beggar.dm. should work.
/datum/outfit/job/roguetown/assassin/assassin_disguise/beggar/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()

	if(prob(20))
		head = /obj/item/clothing/head/roguetown/knitcap
	if(prob(5))
		H.put_in_hands(new /obj/item/reagent_containers/powder/moondust)
	if(prob(10))
		beltl = /obj/item/clothing/mask/cigarette/rollie/cannabis
	if(prob(10))
		cloak = /obj/item/clothing/cloak/raincloak/brown
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		armor = null
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
