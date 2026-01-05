/obj/item/clothing/under/roguetown/heavy_leather_pants
	name = "hardened leather trousers"
	desc = "Thick hide cut and sewn into a pair of very protective trousers. The dense leather can \
	turn away errant chops."
	gender = PLURAL
	icon_state = "roguepants"
	item_state = "roguepants"
	sewrepair = TRUE
	armor = ARMOR_LEATHER_GOOD
	sellprice = 18
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_LEG_HARDLEATHER
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_LIGHT
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/under/roguetown/heavy_leather_pants/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	name = "hardened leather shorts"
	desc = "A thick hide pair of shorts, favored by some for their ease of motion in spite of \
	being less protective than full trousers."
	icon_state = "rogueshorts"
	item_state = "rogueshorts"
	body_parts_covered = GROIN
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	name = "otavan leather trousers"
	desc = "padded leather armor made by Otavan tailors, its quality is remarkable."
	icon_state = "fencerpants"

/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	name = "fencing breeches"
	desc = "A pair of loose breeches with leather reinforcements on the waist and legs. Worn with a cup."
	icon_state = "fencingbreeches"
	detail_tag = "_detail"
	color = "#FFFFFF"
	detail_color = "#5E4440"
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic/Initialize()
	..()
	update_icon()

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	name = "grenzelhoftian paumpers"
	desc = "Padded pants for extra comfort and protection, adorned in vibrant colors."
	icon_state = "grenzelpants"
	item_state = "grenzelpants"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	detail_tag = "_detail"
	var/picked = FALSE
	armor_class = ARMOR_CLASS_LIGHT
	color = "#262927"
	detail_color = "#FFFFFF"
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Grenzelhoft colors") as anything in COLOR_MAP
		var/playerchoice = COLOR_MAP[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_pants()

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
	name = "cut-throat's pants"
	desc = "Foreign pants, with leather insewns."
	icon_state = "eastpants1"
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	name = "strange ripped pants"
	desc = "Weird pants typically worn by the destitute in Kazengun. Or, those looking to make a fashion statement."
	icon_state = "eastpants2"
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun //no, not 'eastpants3', silly!
	name = "gambeson trousers"
	desc = "A form of Kazengunite peasant's trousers. The fabric used in their manufacture is strong, and could probably turn away a few blows."
	icon_state = "baggypants"
	item_state = "baggypants"

/obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
	name = "silk tights"
	desc = "Form-fitting legwear. Almost too form-fitting."
	icon_state = "shadowpants"
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
	name = "bronze chain skirt"
	desc = "A knee-length maille skirt, made with hundreds of small bronze rings. It wards cuts against the thighs without slowing the feet."
	icon_state = "chain_skirt"
	item_state = "chain_skirt"
	color = "#f9d690"
	blocksound = CHAINHIT
	resistance_flags = FIRE_PROOF
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/bronze //Reskinned version of the Barbarian's heavy leather trousers. 1:1 functionality, but without the ability to sew-repair.
