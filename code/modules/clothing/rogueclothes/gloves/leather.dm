// Because no one fucking know about inheritance in this bleak codebase.
/obj/item/clothing/gloves/roguetown/leather
	name = "leather gloves"
	desc = "Gloves made out of sturdy leather. Barely offer any protection, but are better than nothing."
	icon_state = "leather_gloves"
	armor = ARMOR_LEATHER
	prevent_crits = PREVENT_CRITS_NONE
	max_integrity = ARMOR_INT_SIDE_LEATHER
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	unarmed_bonus = 1.1
	color = "#66584c"
	salvage_result = null // Recipe makes 2 so we cannot make this salvageable

/obj/item/clothing/gloves/roguetown/leather/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/gloves/roguetown/leather/black
	color = CLOTHING_BLACK

/obj/item/clothing/gloves/roguetown/fingerless
	name = "fingerless gloves"
	desc = "Cloth gloves to absorb palm sweat while leaving the fingers free for fine manipulation."
	icon_state = "fingerless_gloves"
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
	name = "fingerless gloves"
	desc = "Cloth gloves to absorb palm sweat while leaving the fingers free for fine manipulation."
	icon_state = "shadowgloves"
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	name = "fingerless gloves"
	desc = "Cloth gloves to absorb palm sweat while leaving the fingers free for fine manipulation."
	icon_state = "shadowgloves"
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/gloves/roguetown/fingerless_leather
	name = "fingerless leather gloves"
	desc = "A pair of protective gloves favored by lockshimmers, laborers, and smokers for maintaining \
	manual dexterity over regular gloves."
	icon_state = "roguegloves"
	armor = ARMOR_LEATHER_GOOD
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_CLOTH
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/otavan
	name = "otavan leather gloves"
	desc = "A pair of heavy Otavan leather gloves, commonly used by fencers, renowned for their quality."
	icon_state = "fencergloves"
	item_state = "fencergloves"
	armor = ARMOR_MAILLE
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	allowed_race = NON_DWARVEN_RACE_TYPES

/obj/item/clothing/gloves/roguetown/otavan/inqgloves
	name = "inquisitorial leather gloves"
	desc = "Masterworked leather gloves, reinforced with a light weave of maille. Hanging from the left glove's cuff is a small rosary necklace; a warm reminder that even the Inquisitors are beholden to His authority."
	icon_state = "inqgloves"
	item_state = "inqgloves"
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/gloves/roguetown/otavan/psygloves
	name = "psydonic leather gloves"
	desc = "Thick leather mittens, stitched and cuffed to guard His children's palms from perforation."
	armor = ARMOR_LEATHER_GOOD
	icon_state = "psydongloves"
	item_state = "psydongloves"
	salvage_result = /obj/item/natural/hide/cured	
	allowed_race = ALL_RACES_TYPES

// Eastern gloves
/obj/item/clothing/gloves/roguetown/eastgloves1
	name = "black gloves"
	desc = "Sleek gloves typically used by swordsmen."
	icon_state = "eastgloves1"
	item_state = "eastgloves1"
	armor = ARMOR_LEATHER
	prevent_crits = PREVENT_CRITS_NONE
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE

/obj/item/clothing/gloves/roguetown/eastgloves2
	name = "stylish gloves"
	desc = "Unusual gloves worn by foreign gangs."
	icon_state = "eastgloves2"
	item_state = "eastgloves2"
	armor = ARMOR_LEATHER
	prevent_crits = PREVENT_CRITS_NONE
	resistance_flags = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
