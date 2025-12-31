/obj/item/clothing/suit/roguetown/armor/leather
	name = "leather armor"
	desc = "Flexible cowhide armor. Lightweight, better than nothing."
	icon_state = "roguearmor"
	body_parts_covered = COVERAGE_TORSO
	armor = ARMOR_LEATHER
	prevent_crits = PREVENT_CRITS_NONE
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	nodismemsleeves = TRUE
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE
	sellprice = 20
	armor_class = ARMOR_CLASS_LIGHT
	salvage_result = /obj/item/natural/hide/cured
	chunkcolor = "#7e5d17"

/obj/item/clothing/suit/roguetown/armor/leather/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket
	name = "winter jacket"
	desc = "The most elegant of furs and vivid of royal dyes combined together into a most classy jacket."
	icon_state = "winterjacket"
	detail_tag = "_detail"
	color = CLOTHING_WHITE
	detail_color = CLOTHING_BLACK

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket/lordcolor(primary,secondary)
	detail_color = primary
	update_icon()

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket/Initialize()
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	else
		GLOB.lordcolor += src

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	name = "artificer jacket"
	icon_state = "artijacket"
	desc = "A thick leather jacket adorned with fur and cog decals. The height of Heartfelt fashion."

/obj/item/clothing/suit/roguetown/armor/leather/cuirass
	name = "leather cuirass"
	desc = "A cuirass made of leather."
	icon_state = "leather"
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	color = "#7D6653"

/obj/item/clothing/suit/roguetown/armor/leather/hide
	name = "hide armor"
	desc = "A light armor of wildbeast hide. Far more durable than leather."
	icon_state = "hidearmor"
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM

/obj/item/clothing/suit/roguetown/armor/leather/studded/warden
	name = "forester's armor"
	desc = "A hardened leather harness with a large pauldron worn over a maille coat, associated with the Azurian wardens."
	icon = 'icons/roguetown/clothing/special/warden.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden.dmi'
	icon_state = "forestleather"

/obj/item/clothing/suit/roguetown/armor/leather/studded/warden/upgraded
	name = "forester's brigandine"
	desc = "A hardened leather harness with a large pauldron worn over a tasseted brigandine, imbued with Dendor's essence."
	icon_state = "forestbrig"
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 50
	equip_delay_self = 50
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/leather/studded
	name = "studded leather armor"
	desc = "Studded leather is the most durable of all hides and leathers and about as light."
	icon_state = "studleather"
	item_state = "studleather"
	blocksound = SOFTHIT
	armor = ARMOR_LEATHER_STUDDED
	prevent_crits = PREVENT_CRITS_MOST
	nodismemsleeves = TRUE
	body_parts_covered = COVERAGE_TORSO
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	smeltresult = /obj/item/ingot/iron
	sellprice = 25
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/suit/roguetown/armor/leather/studded/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist
	name = "cuir-bouilli armor"
	desc = "Treated, water-boiled and composite-layered leather armor of fine Otavan make."
	icon_state = "cuirbouilli"
	item_state = "cuirbouilli"

/obj/item/clothing/suit/roguetown/armor/leather/heavy
	name = "hardened leather armor"
	desc = "A heavy steerhide jerkin with enough body to stand on its own. It forms a stiff, protective mantle \
	for its wearer, shielding from blows and weather alike."
	icon_state = "roguearmor_belt"
	item_state = "roguearmor_belt"
	armor = ARMOR_LEATHER_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	prevent_crits = PREVENT_CRITS_MOST
	sellprice = 20
	color = "#7D6653"

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	name = "hardened leather coat"
	desc = "A heavy steerhide jerkin that reaches past the hips and better protects the vitals."
	icon_state = "roguearmor_coat"
	item_state = "roguearmor_coat"
	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	armor = ARMOR_LEATHER_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 25
	color = "#7D6653"

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor
	name = "confessional coat"
	desc = "A sturdy raincoat draped atop of a tightly-fastened boiled leather cuirass. Saint Astratan youths often fashion little pieces of memorabilia and stitch it on the inner pockets of the coat to remind the confessors that their cause is virtuous, and that they mustn't lose sight of what matters."
	icon_state = "confessorcoat"
	item_state = "confessorcoat"
	body_parts_covered = COVERAGE_FULL
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	armor = ARMOR_LEATHER_STUDDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE	

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen
	name = "megarmach scale coat"
	desc = "A set of lightweight armor fashioned from the scales of the Ranesheni \'megarmach\', an armored reptilian creacher that ambushes prey by the riverside, and drags them deep into Abyssor's domain."
	icon_state = "pangolin"
	item_state = "pangolin"

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/steppe
	name = "fur-woven hatanga coat"
	desc = "A finely woven hatagna coat, replacing much of its scaled armor with fine furs and reinforced padding for lighter rides."
	icon_state = "hatangafur"
	item_state = "hatangafur"

/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket
	name = "hardened leather jacket"
	desc = "A heavy leather jacket that covers the arms and protects the vitals."
	icon_state = "leatherjacketo"
	item_state = "leatherjacketo"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	armor = ARMOR_LEATHER_GOOD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 25

/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
	name = "fencing jacket"
	desc = "A light, flexible button-up leather jacket that will keep your vitals out of harm's way."
	icon_state = "freijacket"
	item_state = "freijacket"
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM
	detail_tag = "_detail"
	color = "#5E4440"
	detail_color = "#c08955"

/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter/Initialize()
	..()
	update_icon()

/obj/item/clothing/suit/roguetown/armor/leather/trophyfur
	name = "treated trophy fur robes"
	desc = "A heavy set of hardened robes, lined with fur. The leather is composed of several creatures that were notably difficult to fell by arrow. A proof or rangership among many."
	icon_state = "hatanga"
	item_state = "hatanga"
	armor = list("blunt" = 90, "slash" = 30, "stab" = 40, "piercing" = 60, "fire" = 0, "acid" = 0)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 100

/obj/item/clothing/suit/roguetown/armor/leather/bikini
	name = "leather corslet"
	desc = "Flexible cowhide armor. Lightweight, better than nothing. Trimmed to protect the heart and hips."
	body_parts_covered = CHEST|GROIN
	icon_state = "leatherkini"
	item_state = "leatherkini"
	allowed_sex = list(FEMALE, MALE)
	allowed_race = CLOTHED_RACES_TYPES
	color = "#7D6653"

/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini
	name = "studded leather corslet"
	desc = "Studded leather is the most durable of all hides and leathers and about as light. Trimmed to protect the heart and hips."
	body_parts_covered = CHEST|GROIN
	icon_state = "studleatherkini"
	item_state = "studleatherkini"
	allowed_sex = list(MALE, FEMALE)
	allowed_race = CLOTHED_RACES_TYPES

/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini
	name = "hide corslet"
	desc = "A light armor of wildbeast hide. Far more durable than leather. Trimmed to protect the heart and hips."
	body_parts_covered = CHEST|GROIN
	icon_state = "hidearmorkini"
	item_state = "hidearmorkini"
	allowed_sex = list(MALE, FEMALE)
	allowed_race = CLOTHED_RACES_TYPES

/obj/item/clothing/suit/roguetown/armor/leather/vest
	name = "leather vest"
	desc = "A leather vest. Not very protective, but fashionable."
	icon_state = "vest"
	item_state = "vest"
	color = "#514339"
	armor = ARMOR_CLOTHING
	prevent_crits = list(BCLASS_CUT)
	blocksound = SOFTHIT
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	blade_dulling = DULLING_BASHCHOP
	body_parts_covered = COVERAGE_TORSO
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	sleevetype = null
	sleeved = null
	armor_class = ARMOR_CLASS_LIGHT

/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor
	name = "sea jacket"
	desc = "A sailor's garb."
	icon_state = "sailorvest"
	color = null
	slot_flags = ITEM_SLOT_ARMOR
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	sleevetype = "shirt"
	sewrepair = TRUE

/obj/item/clothing/suit/roguetown/armor/leather/vest/white
	color = CLOTHING_WHITE

/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/nightman
	name = "silk jacket"
	desc = "A soft and comfortable jacket."
	icon_state = "nightman"
	sleeved = 'icons/roguetown/clothing/onmob/armor.dmi'
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES


/obj/item/clothing/suit/roguetown/armor/leather/vest/hand
	name = "hand's vest"
	desc = "A soft vest of finest fabric."
	icon_state = "handcoat"
	color = null
	allowed_sex = list(MALE, FEMALE)
	allowed_race = NON_DWARVEN_RACE_TYPES
