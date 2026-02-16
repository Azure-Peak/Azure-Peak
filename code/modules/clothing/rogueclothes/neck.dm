/obj/item/clothing/neck/roguetown
	name = "necklace"
	desc = ""
	icon = 'icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/neck.dmi'
	bloody_icon_state = "bodyblood"
	experimental_inhand = FALSE
	alternate_worn_layer = NECK_LAYER
	var/overarmor

/obj/item/clothing/neck/roguetown/MiddleClick(mob/user, params)
	. = ..()
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear \the [src] over my armor" : "wear \the [src] under my armor"]."))
	if(overarmor)
		alternate_worn_layer = NECK_LAYER
	else
		alternate_worn_layer = UNDER_ARMOR_LAYER
	user.update_inv_neck()
	user.update_inv_cloak()
	user.update_inv_armor()
	user.update_inv_shirt()

/obj/item/clothing/neck/roguetown/coif
	name = "coif"
	desc = "A thin coif of cloth, favored by peasantry and highwaymen alike."
	icon_state = "coif"
	item_state = "coif"
	color = CLOTHING_BROWN
	flags_inv = HIDEEARS|HIDEHAIR
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	blocksound = SOFTHIT
	body_parts_covered = NECK|HAIR|EARS|HEAD
	armor = ARMOR_PADDED_BAD
	prevent_crits = PREVENT_CRITS_NONE
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	sewrepair = TRUE

/obj/item/clothing/neck/roguetown/coif/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Right click to adjust the coif's coverage. Certain coifs with multiple adjustments - like the heavy padded coif - might need to be right-clicked multiple times, in order to cycle back to its default state.")

/obj/item/clothing/neck/roguetown/coif/padded
	name = "padded coif"
	desc = "A gambeson's coif, hewn from cloth. It can either be worn beneath a helmet to cushion one's skull from punishment, or worn on its own to keep one's cheeks warm in more frigid climates."
	icon_state = "ccoif"
	item_state = "ccoif"
	color = "#ad977d"
	flags_inv = HIDEEARS|HIDEHAIR
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	blocksound = SOFTHIT
	body_parts_covered = NECK|HAIR|EARS|HEAD
	armor = ARMOR_PADDED //gambeson for head
	prevent_crits = PREVENT_CRITS_NONE
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	sewrepair = TRUE

/obj/item/clothing/neck/roguetown/coif/heavypadding
	name = "heavy padded coif"
	desc = "A padded gambeson's coif, bearing the distinct dorpel-styled stitchwork of its larger cousin. When layered properly, it can last through even the busiest of daes."
	icon_state = "fullpadded"
	item_state = "fullpadded"
	color = "#976E6B"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	blocksound = SOFTHIT
	body_parts_covered = NECK|MOUTH|NOSE|HAIR|EARS|HEAD
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER //padded gambeson durability
	armor = ARMOR_PADDED_GOOD //full padded gambeson basically
	prevent_crits = PREVENT_CRITS_MOST
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	sewrepair = TRUE

/obj/item/clothing/neck/roguetown/coif/heavypadding/ComponentInitialize()
	return

/obj/item/clothing/neck/roguetown/coif/heavypadding/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "fullpadded_down"
			flags_inv = HIDEEARS|HIDEHAIR
			body_parts_covered = NECK|HAIR|EARS|HEAD
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			adjustable = CADJUSTED_MORE
			if(toggle_icon_state)
				icon_state = "fullpadded_neck"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED_MORE)
			ResetAdjust(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_neck()
			H.update_inv_head()

/obj/item/clothing/neck/roguetown/coif/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, null, null, (UPD_HEAD|UPD_MASK|UPD_NECK))	//Soundless coif
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_HONORBOUND)

/obj/item/clothing/neck/roguetown/leather
	name = "hardened leather gorget"
	desc = "Sturdy. Durable. Will protect your neck from some good lumbering."
	icon_state = "lgorget"
	slot_flags = ITEM_SLOT_NECK
	blocksound = SOFTHIT
	body_parts_covered = NECK
	body_parts_inherent = NECK
	armor = ARMOR_LEATHER_GOOD
	sewrepair = TRUE
	sellprice = 10
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/neck/roguetown/chaincoif
	name = "chain coif"
	desc = "A maille-hood, fashioned from interlinked steel rings - a favorite amongst Psydonia's more noble-hearted errants. It offers superior coverage to gorgets and bevors, though it sacrifices some protection in return."
	icon_state = "chaincoif"
	item_state = "chaincoif"
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	flags_inv = HIDEEARS|HIDEHAIR
	armor = ARMOR_MAILLE
	max_integrity = ARMOR_INT_SIDE_STEEL
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	body_parts_covered = NECK|HAIR|EARS|HEAD
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	blocksound = CHAINHIT
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/neck/roguetown/chaincoif/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/chain_equip.ogg', null, (UPD_HEAD|UPD_MASK|UPD_NECK))	//Chain coif.
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/neck/roguetown/chaincoif/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Right click to adjust the coif's coverage. Certain coifs with multiple adjustments - like the full chain coif - might need to be right-clicked multiple times, in order to cycle back to its default state.")

/obj/item/clothing/neck/roguetown/chaincoif/paalloy
	name = "ancient coif"
	desc = "Polished gilbranze rings, linked together to form a billowing hood. Let it not be a crown of thorns that saves this dying world, but a crown of progress; of fettered metal and stained bone, rejuvenated by Zizo's will to herald Her greatest works yet."
	icon_state = "achaincoif"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	name = "decrepit coif"
	desc = "Frayed bronze rings, linked together to form a billowing hood. Shrapnel peppers the linkage; arrowheads and speartips, brought along from a battlefield who's history - and legionnaires - have been lost to tyme."
	icon_state = "achaincoif"
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	color = "#bb9696"
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_CHAINMAIL
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	name = "chain mantle"
	desc = "A thicker and more durable piece of neck protection that also covers the mouth when pulled up."
	icon_state = "chainmantle"
	armor = ARMOR_MAILLE
	body_parts_covered = NECK|MOUTH
	slot_flags = ITEM_SLOT_NECK
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (NECK), null, null, 'sound/foley/equip/equip_armor_chain.ogg', null, (UPD_HEAD|UPD_MASK|UPD_NECK))	//Chain coif.
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/neck/roguetown/chaincoif/iron
	name = "iron chain coif"
	desc = "A maille-hood, fashioned from interlinked iron rings. Levymen oft-wear these atop a padded coif or beneath a kettle, depending on the nature of their rally; be it to defend their hearth-and-home from beastes or Bandits."
	icon_state = "ichaincoif"
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_SIDE_IRON

/obj/item/clothing/neck/roguetown/chaincoif/full
	name = "full chain coif"
	icon_state = "fchaincoif"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	resistance_flags = FIRE_PROOF
	body_parts_covered = NECK|MOUTH|NOSE|HAIR|EARS|HEAD
	adjustable = CAN_CADJUST

/obj/item/clothing/neck/roguetown/chaincoif/full/ComponentInitialize()
	return

/obj/item/clothing/neck/roguetown/chaincoif/full/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "chaincoif"
			flags_inv = HIDEEARS|HIDEHAIR
			body_parts_covered = NECK|HAIR|EARS|HEAD
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			adjustable = CADJUSTED_MORE
			if(toggle_icon_state)
				icon_state = "chaincoif_t"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_neck()
				H.update_inv_head()
		else if(adjustable == CADJUSTED_MORE)
			ResetAdjust(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_neck()
			H.update_inv_head()

/obj/item/clothing/neck/roguetown/chaincoif/full/black
	color = "#323232"

/obj/item/clothing/neck/roguetown/bevor
	name = "bevor"
	desc = "A steel neckguard, traditionally mounted to the collar of a cuirass. It restricts the head's motion, but ensures the absence of abuseable gaps."
	icon_state = "bevor"
	armor = ARMOR_PLATE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	max_integrity = ARMOR_INT_SIDE_STEEL
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK|MOUTH|NOSE
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	blocksound = PLATEHIT

/obj/item/clothing/neck/roguetown/bevor/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/items/visor.ogg', null, (UPD_HEAD|UPD_MASK|UPD_NECK)) // adjustable falling buffe for the bevor
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)

/obj/item/clothing/neck/roguetown/bevor/iron
	name = "iron bevor"
	desc = "An iron neckguard, traditionally mounted to the collar of a cuirass. It restricts the head's motion, but ensures the absence of abuseable gaps."
	icon_state = "ibevor"
	smeltresult = /obj/item/ingot/iron
	max_integrity = ARMOR_INT_SIDE_IRON
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/neck/roguetown/gorget
	name = "gorget"
	desc = "A series of iron plates designed to protect the neck, traditionally atop a jacket or cuirass. While it lacks a coif's coverage, it is more-than-capable of thwarting a dagger's viscous bite."
	icon_state = "gorget"
	armor = ARMOR_PLATE
	prevent_crits = PREVENT_CRITS_ALL
	smeltresult = /obj/item/ingot/iron
	anvilrepair = /datum/skill/craft/armorsmithing
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	max_integrity = ARMOR_INT_SIDE_IRON
	resistance_flags = FIRE_PROOF
	body_parts_inherent = NECK
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	blocksound = PLATEHIT

/obj/item/clothing/neck/roguetown/gorget/bronze
	name = "bronze neckguard"
	desc = "An interlinked veil of bronze plates, shielding the throat from terrible wounds since the dawn of tyme. Piercing blows may sunder the plate, but - as long as the alloy persists - so shall you."
	icon_state = "bronzegorget"
	armor = ARMOR_PLATE_BRONZE
	prevent_crits = PREVENT_CRITS_ALL
	smeltresult = /obj/item/ingot/bronze
	max_integrity = ARMOR_INT_SIDE_BRONZE

/obj/item/clothing/neck/roguetown/gorget/aalloy
	name = "decrepit gorget"
	desc = "Frayed bronze plates, shingled together to shroud the neck. Primitive scrapes line the flanks, yet the center seems to've been cored out by a spear's thrust."
	icon_state = "ancientgorget"
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	color = "#bb9696"
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_PLATE
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/neck/roguetown/gorget/copper
	name = "neck protector"
	icon_state = "copperneck"
	desc = "A curved disk of copper, rounded out to cradle one's neck; vulnerable, but far better than nothing at all."
	armor = ARMOR_PLATE_BAD
	smeltresult = /obj/item/ingot/copper

/obj/item/clothing/neck/roguetown/fencerguard
	name = "fencing guard"
	icon_state = "fencercollar"
	armor = ARMOR_PLATE
	smeltresult = /obj/item/ingot/steel
	anvilrepair = /datum/skill/craft/armorsmithing
	max_integrity = ARMOR_INT_SIDE_STEEL
	body_parts_inherent = NECK
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	blocksound = PLATEHIT
	allowed_race = NON_DWARVEN_RACE_TYPES
	detail_tag = "_detail"
	color = "#5058c1"
	detail_color = "#e98738"
	var/picked = FALSE

/obj/item/clothing/neck/roguetown/fencerguard/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Otavan colors") as anything in COLOR_MAP
		var/playerchoice = COLOR_MAP[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_shirt()
			H.update_icon()

/obj/item/clothing/neck/roguetown/fencerguard/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/neck/roguetown/fencerguard/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/neck/roguetown/fencerguard/generic
	color = "#503630"
	detail_color = "#503630"

/obj/item/clothing/neck/roguetown/gorget/forlorncollar
	name = "forlorn collar"
	desc = "A old reminder."
	icon_state = "iwolfcollaralt"

/obj/item/clothing/neck/roguetown/gorget/steel
	name = "steel gorget"
	desc = "A series of steel plates designed to protect the neck, traditionally worn atop a jacket or cuirass. It bares a mammon-sized divet along its right flank; the certification of its 'proofedness' against a longbow's strike."
	smeltresult = /obj/item/ingot/steel
	max_integrity = ARMOR_INT_SIDE_STEEL
	icon_state = "sgorget"

/obj/item/clothing/neck/roguetown/gorget/gold
	name = "golden gorget"
	desc = "A series of resplendant golden plates designed to protect the neck, traditionally worn atop a jacket or cuirass. The holy sigil between its buckled halves promises to carry the flame of its wearer, no matter what strike's poised its way."
	icon_state = "goldgorget"
	armor_class = ARMOR_CLASS_HEAVY //Ceremonial. Heavy is the head that bares the burden.
	armor = ARMOR_GOLD //Renders its wearer completely invulnerable to damage. The caveat is, however..
	max_integrity = ARMOR_INT_SIDE_GOLD // ..is that it's extraordinarily fragile. To note, this is lower than even Decrepit-tier armor.
	anvilrepair = null
	smeltresult = /obj/item/ingot/gold
	smelt_bar_num = 1
	grid_height = 96
	grid_width = 96
	sellprice = 200
	unenchantable = TRUE

/obj/item/clothing/neck/roguetown/gorget/gold/king
	name = "royal golden gorget"
	max_integrity = ARMOR_INT_SIDE_GOLDPLUS // Doubled integrity.
	sellprice = 300
	unenchantable = TRUE

/obj/item/clothing/neck/roguetown/gorget/steel/kazengun
	name = "kazengunite gorget"
	desc = "A series of interlocking rings of metal set around the throat. Used by the kouken of Kazengun for precisely the same reason as the knights of Psydonia."
	icon_state = "kazengunneckguard"

/obj/item/clothing/neck/roguetown/gorget/paalloy
	name = "ancient gorget"
	desc = "Polished gilbranze plates, layered atop one-another to guard the neck. The spine; a sacred leyline between spirit and sinew. It must remain unsevered, lest Her blessings be lost."
	icon_state = "ancientgorget"
	max_integrity = ARMOR_INT_SIDE_STEEL
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/neck/roguetown/gorget/prisoner/Initialize()
	. = ..()
	name = "cursed collar"
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/roguetown/gorget/prisoner/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/neck/roguetown/gorget/cursed_collar
	name = "cursed collar"
	desc = "A metal collar that seems to radiate an ominous aura."
	icon_state = "cursed_collar"
	item_state = "cursed_collar"
	armor = ARMOR_CLOTHING
	smeltresult = /obj/item/ingot/iron
	anvilrepair = /datum/skill/craft/armorsmithing
	max_integrity = ARMOR_INT_SIDE_DECREPIT
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	prevent_crits = PREVENT_CRITS_NONE
	blocksound = PLATEHIT

/obj/item/clothing/neck/roguetown/psicross
	name = "psycross"
	desc = "'With every broken bone, I swore I lived!'"
	icon_state = "psycross"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	possible_item_intents = list(/datum/intent/use, /datum/intent/special/magicarc)
	sellprice = 10
	experimental_onhip = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	grid_width = 32
	grid_height = 32
	/// Used to see whether or not we display the wrist icon or the neck icon regardless.
	var/wrist_display = FALSE

/obj/item/clothing/neck/roguetown/psicross/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	..()

	if(slot == SLOT_WRISTS || (wrist_display && slot != SLOT_NECK))
		mob_overlay_icon = 'icons/roguetown/clothing/onmob/wrists.dmi'
		sleeved = 'icons/roguetown/clothing/onmob/wrists.dmi'
	else
		mob_overlay_icon = initial(mob_overlay_icon)
		sleeved = initial(sleeved)

	return TRUE

/obj/item/clothing/neck/roguetown/psicross/attack_right(mob/user)
	if(!ismob(loc))
		return ..()

	wrist_display = !wrist_display
	to_chat(user, span_info("You adjust \the [src] to [wrist_display ? "display on your wrists" : "display around your neck"]."))
	if(wrist_display)
		mob_overlay_icon = 'icons/roguetown/clothing/onmob/wrists.dmi'
		sleeved = 'icons/roguetown/clothing/onmob/wrists.dmi'
	else
		mob_overlay_icon = initial(mob_overlay_icon)
		sleeved = initial(sleeved)

	if(isliving(loc))
		var/mob/living/L = loc
		L.regenerate_clothes()
	return ..()

/obj/item/clothing/neck/roguetown/psicross/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Right click to adjust how your character visibly wears the amulet. Most amulets can cycle between being visibly worn on the neck, and being worn around the wrist.")
    . += span_info("Middle click to kneel in prayer. Praying generates Devotion, which can be used to cast most miracles.")
    . += span_info("By typing '*pray' into your chatbar, you can write a dedicated prayer to your character's patron. Dedicated prayers have a rare chance of being answered by higher powers.")
    . += span_info("Adjusting an amulet while wearing it in the ring slot allows you to visibly layer it over most sleeves and clothing.")

/obj/item/clothing/neck/roguetown/psicross/reform
	name = "reformist psycross"
	desc = "'It occured to me that our God had left us, but not our ability to endure hardship. We shall make something out of this world, I said, before we pass onto the next.'"
	sellprice = 0	//Heresy of the highest order. Unless...
	icon_state = "reformistcross"

/obj/item/clothing/neck/roguetown/psicross/aalloy
	name = "decrepit psicross"
	desc = "'A comet capable of rending all the enemies of humanity apart; oh, how graceful His power was! And His sacrifice, ever so noble! Yet now He slumbers, unaware of the fruits His efforts came to give. And He sighs. And He weeps.'"
	icon_state = "psycross_a"
	color = "#bb9696"
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_PLATE

/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
	name = "decrepit zcross"
	desc = "'Progress. Ascension. Destiny. A mandate, commanded by God, to be fufilled by Man. She called us forth from the edge of reality - and with Her dying breath, rasped out the final truth; the fire is gone, and the world will soon follow.'"
	icon_state = "zcross_a"
	color = "#bb9696"
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_PLATE
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/roguetown/psicross/inhumen/iron
	name = "inverted psycross"
	desc = "A symbol of progress from an era that had reason to believe in it."
	icon_state = "zcross_iron"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/roguetown/psicross/inhumen/bronze
	name = "bronze inverted psycross"
	desc = "'Look upon mine works, thee-mighty, and despair!'"
	icon_state = "zcross_b"
	resistance_flags = FIRE_PROOF
	sellprice = 25

/obj/item/clothing/neck/roguetown/psicross/inhumen/g
	name = "golden inverted psycross"
	desc = "'Doth thee wish to live deliciously? Mortality is but a shackle; and if you wish to break free from its steely grasp, all you need to do.. is put thine faith in me.'"
	icon_state = "zcross_g"
	resistance_flags = FIRE_PROOF
	sellprice = 100

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
	name = "amulet of Matthios"
	desc = "He was but one flame in the dark. Together, his flock shall outblaze the tyrant sun."
	icon_state = "matthios"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS|ITEM_SLOT_RING
	smeltresult = null

/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
	name = "amulet of Graggar"
	desc = "Blood leads only to glory, and violence begets divinity. Nothing less. Conquest is simply another name for victory."
	icon_state = "graggar"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS|ITEM_SLOT_RING
	smeltresult = null

/obj/item/clothing/neck/roguetown/psicross/undivided
	name = "amulet of Ten"
	desc = "The Ten eternal, strength in unity. Stalwart for centuries against the darkness."
	icon_state = "undivided"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS|ITEM_SLOT_RING

/obj/item/clothing/neck/roguetown/psicross/silver/undivided
	name = "silver amulet of Ten"
	desc = "Ward of silver, sigil of eternity; by the Ten, I command thee back to Hell!"
	icon_state = "undivided_s"
	sellprice = 50

/obj/item/clothing/neck/roguetown/psicross/astrata
	name = "amulet of Astrata"
	desc = "As sure as the sun rises, tomorrow will come."
	icon_state = "astrata"

/obj/item/clothing/neck/roguetown/psicross/silver/astrata
	name = "silver amulet of Astrata"
	desc = "Let no monster hold comfort in Her brother's shadow."
	icon_state = "astrata_s"
	sellprice = 50

/obj/item/clothing/neck/roguetown/psicross/astrata/g
	name = "golden amulet of Astrata"
	desc = "The sun's blinding glare, adorning the faithful and scorning the faithless."
	icon_state = "astrata_g"
	sellprice = 100

/obj/item/clothing/neck/roguetown/psicross/noc
	name = "amulet of Noc"
	desc = "There is always more to know, more to learn, more to be."
	icon_state = "noc"

/obj/item/clothing/neck/roguetown/psicross/silver/noc
	name = "blessed amulet of Noc"
	desc = "Within the Beyond, where dreams and daemons coalesce, lies the secret to all knowledge; both arcyne and aeternal. Under my ward, I shall guide thee forth to this pedestal."
	icon_state = "noc"
	sellprice = 50

/obj/item/clothing/neck/roguetown/psicross/abyssor
	name = "amulet of Abyssor"
	desc = "To fear the unknown is to turn away from the greatest mysteries of all."
	icon_state = "abyssor"
	salvage_result = /obj/item/pearl/blue
	salvage_amount = 1

/obj/item/clothing/neck/roguetown/psicross/dendor
	name = "amulet of Dendor"
	desc = "If you need something to worship, then worship life. Every last crawling bit of it."
	icon_state = "dendor"

/obj/item/clothing/neck/roguetown/psicross/necra
	name = "amulet of Necra"
	desc = "The certainty of death is a reminder to enjoy the time you have."
	icon_state = "necra"

/obj/item/clothing/neck/roguetown/psicross/silver/necra
	name = "silver amulet of Necra"
	desc = "Guide the lost, the forgotten, and the damned to their final resting place."
	icon_state = "necra_s"

/obj/item/clothing/neck/roguetown/psicross/pestra
	name = "amulet of Pestra"
	desc = "The healthy wear a crown only the sick can see."
	icon_state = "pestra"

/obj/item/clothing/neck/roguetown/psicross/ravox
	name = "amulet of Ravox"
	desc = "What are you fighting for?"
	icon_state = "ravox"

/obj/item/clothing/neck/roguetown/psicross/ravox/bronze
	name = "bronze amulet of Ravox"
	desc = "'YOU FIGHT WELL, RAVOX OF UR-SYON. YOUR CLEMENCY HATH BEEN EARNED. SURRENDER NOW, AND GRAGGAR SHALL-'</br>‎  </br>'No.' </br>‎  </br>'-WHAT? YOU'RE GOING TO THROW AWAY YOUR LYFE FOR A GOD THAT HAS NO LOVE FOR YOU?' </br>‎  </br>'One of us will.'"
	icon_state = "ravox_b"

/obj/item/clothing/neck/roguetown/psicross/malum
	name = "amulet of Malum"
	desc = "From the ashes, creation."
	icon_state = "malum"

/obj/item/clothing/neck/roguetown/psicross/eora
	name = "amulet of Eora"
	desc = "In a world full of horror and hardship, all we have is each other."
	icon_state = "eora"

/obj/item/clothing/neck/roguetown/psicross/xylix
	name = "amulet of Xylix"
	desc = "In lyfe a smile is sharper than any blade."
	icon_state = "xylix"
	toggle_icon_state = FALSE

/obj/item/clothing/neck/roguetown/psicross/xylix/examine(mob/user)
	. = ..()

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/human = user
	if(human.patron == GLOB.patronlist[/datum/patron/divine/xylix])
		. += span_notice("This is an amulet of Xylix! By shift-right clicking it, I can alter its shape to whatever befits my whim.")

/obj/item/clothing/neck/roguetown/psicross/xylix/ShiftRightClick(mob/user, params)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/human = user
	if(human.patron != GLOB.patronlist[/datum/patron/divine/xylix])
		return

	var/list/psycross_types = typesof(/obj/item/clothing/neck/roguetown/psicross)
	var/list/choices = list()
	for(var/type in psycross_types)
		var/obj/item/clothing/neck/roguetown/psicross/cross = type
		choices[initial(cross.name)] = type

	var/selected_cross = tgui_input_list(user, "Choose the Psycross you would like to disguise this one as.", "Psycross Selection", choices)
	if(!selected_cross)
		return

	var/obj/item/clothing/neck/roguetown/psicross/cross_type = choices[selected_cross]

	name = initial(cross_type.name)
	desc = initial(cross_type.desc)
	icon_state = initial(cross_type.icon_state)
	item_state = initial(cross_type.item_state)

	human.regenerate_clothes()

/obj/item/clothing/neck/roguetown/psicross/wood
	name = "wooden psycross"
	desc = "'A man with nothing can still have faith!'"
	icon_state = "psycross_w"
	item_state = "psycross_w"
	sellprice = 0
	salvage_result = /obj/item/grown/log/tree/stick
	salvage_amount = 1

/obj/item/clothing/neck/roguetown/psicross/bronze
	name = "bronze psycross"
	desc = "'Until my heart ceases beating, and until my vigil ends - I will bring you down with me!'"
	icon_state = "psycross_b"
	item_state = "psycross_b"
	sellprice = 25
	is_silver = TRUE

/obj/item/clothing/neck/roguetown/psicross/silver
	name = "silver psycross"
	desc = "'The horrors persist, but so do I!'"
	icon_state = "psycross_s"
	item_state = "psycross_s"
	sellprice = 50
	is_silver = TRUE

/obj/item/clothing/neck/roguetown/psicross/silver/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Silver amulets protect against most unholy curses, hexes, and other mind-altering spells.")

/obj/item/clothing/neck/roguetown/psicross/g
	name = "golden psycross"
	desc = "'Purity afloat, for paradise awaits!'"
	icon_state = "psycross_g"
	item_state = "psycross_g"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 100

/obj/item/clothing/neck/roguetown/psicross/pearl //put it as a psycross so it can be used for miracles
	name = "pearl amulet"
	icon_state = "pearlcross"
	desc = "An amulet made of white pearls, usually worn by fishers or sailors."
	sellprice = 80
	salvage_result = /obj/item/pearl
	salvage_amount = 3 // Pearls are easy to cut off from an amulet

/obj/item/clothing/neck/roguetown/psicross/bpearl
	name = "blue pearl amulet"
	icon_state = "bpearlcross"
	desc = "An amulet made of rare blue pearls, usually worn by priests and worshippers of Abyssor, or as lucky charms for captains of ships."
	sellprice = 220
	salvage_result = /obj/item/pearl/blue
	salvage_amount = 3 // Pearls are easy to cut off from an amulet

/obj/item/clothing/neck/roguetown/psicross/shell
	name = "oyster shell necklace"
	icon_state = "oyster_necklace"
	desc = "A necklace of strung-up sea shells, the calming noise they make when they clack together is reminiscent of a shellfish's claws. They remind you that while men no longer live in water, Abyssor will always remember our origins."
	sellprice = 25
	salvage_result = /obj/item/oystershell
	salvage_amount = 5

/obj/item/clothing/neck/roguetown/psicross/shell/bracelet
	name = "shell bracelet"
	icon_state = "oyster_bracelet"
	desc = "A beaded bracelet made from sea shells, their rough exterior and glossy interior reminding you that Abyssor's children hide the best gifts at the deepest spots beneath the waves."
	sellprice = 15
	slot_flags = ITEM_SLOT_WRISTS
	salvage_result = /obj/item/oystershell
	salvage_amount = 3

/obj/item/clothing/neck/roguetown/talkstone
	name = "talkstone"
	desc = "In moments of quiet it whispers softly, as though deciphering the silence itself."
	icon_state = "talkstone"
	item_state = "talkstone"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	allowed_race = CLOTHED_RACES_TYPES
	sellprice = 70
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/neck/roguetown/horus
	name = "amulet of appraisal"
	desc = "An amulet with a pristine eye embedded into it. Blind to everything, but to that which shines in gold."
	icon_state = "horus"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 80
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/neck/roguetown/horus/examine()
	. = ..()
	. += span_info("Click on a turf or an item to see how much it is worth. Avoid tables.")

/obj/item/clothing/neck/roguetown/horus/afterattack(atom/A, mob/user, params)
	. = ..()
	var/total_sellprice = 0
	if(isturf(A))
		for(var/obj/item/I in A.contents)
			total_sellprice += I.sellprice
		to_chat(user, span_notice("Everything on the ground is worth [total_sellprice] mammons."))
	else if(istype(A, /obj/item))
		var/obj/item/I = A
		total_sellprice += I.sellprice
		for(var/obj/item/item in I.contents)
			total_sellprice += item.sellprice
		to_chat(user, span_notice("The item and its contents is worth [total_sellprice] mammons."))

/obj/item/clothing/neck/roguetown/shalal
	name = "desert rider medal"
	desc = "Made out of the silver from the Ranesheni mercenaries' first pay. A tradition is kept between these hired blades: to give this one away to someone is to symbolize a debt in their favor - to be redeemed by any other mercenary in times of need."
	icon_state = "shalal"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS|ITEM_SLOT_RING		//Hey I guess you could pretend it is wrapped around your hand? Just keep it on, don't be a hoe.
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 30		// what if the economy crashes...........
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/neck/roguetown/ornateamulet
	name = "ornate amulet"
	desc = "A beautiful amulet made of solid gold."
	icon_state = "ornateamulet"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 100
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/neck/roguetown/ornateamulet/noble
	var/choicename = FALSE
	name = "heirloom amulet"
	desc = "An ornate amulet representing a prestigious noble house."
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_WRISTS|ITEM_SLOT_HIP
	sellprice = 10

/obj/item/clothing/neck/roguetown/ornateamulet/noble/attack_right(mob/user)
	if(choicename)
		return
	var/current_time = world.time
	var/namechoice = input(user, "Input a new name", "Rename Object")
	if(namechoice)
		name = namechoice
		choicename = TRUE
	else
		return
	if(world.time > (current_time + 30 SECONDS))
		return

/obj/item/clothing/neck/roguetown/skullamulet
	name = "skull amulet"
	desc = "Gold shaped into the form of a skull and strung into an amulet."
	icon_state = "skullamulet"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 100
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/neck/roguetown/psicross/naledi
	name = "naledian psy-bracelet"
	desc = "A peculiar icon of worship from a foreign land. Forming the three-progned Psydonite cross in a circular ring, this bracelet embodies the Naledian belief of Psydon's eternity."
	icon_state = "psybracelet"
	item_state = null

/obj/item/clothing/neck/roguetown/collar
	name = "collar"
	desc = "A band of leather which signifies bondage to another."
	icon_state = "collar"
	item_state = "collar"
	resistance_flags = FIRE_PROOF
	dropshrink = 0.5
	salvage_result = null

/obj/item/clothing/neck/roguetown/collar/forlorn
	name = "light forlorn collar"
	desc = "A old reminder. A lighter version often used more as a status symbol for slaves. Then and now."
	icon_state = "iwolfcollaralt"

/obj/item/clothing/neck/roguetown/collar/bell_collar
	name = "bell collar"
	desc = "A band of leather with a bell that protects the local zads from the local catfolk."
	icon_state = "bell_collar"

/obj/item/clothing/neck/roguetown/collar/bell_collar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_JINGLE_BELLS)

/obj/item/clothing/neck/roguetown/collar/feldcollar
	name = "feldcollar"
	desc = "A sturdy collar made of leather, commonly worn by field workers."
	icon_state = "feldcollar"
	item_state = "feldcollar"
	resistance_flags = FIRE_PROOF
	dropshrink = 0.5
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_MASK
	body_parts_covered = NECK|FACE

/obj/item/clothing/neck/roguetown/collar/surgcollar
	name = "surgcollar"
	desc = "A specialized collar designed for medical practitioners, with reinforced padding."
	icon_state = "surgcollar"
	item_state = "surgcollar"
	resistance_flags = FIRE_PROOF
	dropshrink = 0.5
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_MASK
	body_parts_covered = NECK|FACE

////////////////////////
// Triumph Exclusive! //
////////////////////////

//Purchasable via Triumphs. Blacklisted from the Stockpile and fitted with a reduced saleprice.
/obj/item/clothing/neck/roguetown/ornateamulet/noble/triumph
	name = "ornate amulet"
	desc = "An opulent, golden necklace. When it catches the candelight, it offers a warped yet unmarred reflection of its wearer's guise."
	sellprice = 33

/obj/item/clothing/neck/roguetown/psicross/g/triumph
	name = "ornate golden psycross"
	desc = "'It does not matter, whether He is lyving or gone. His greatest creation still persists; the very world that our feet tread 'pon, now. That, alone, makes everything worth fighting for.'"
	sellprice = 55

/obj/item/clothing/neck/roguetown/psicross/inhumen/g/triumph
	name = "ornate inverted psycross"
	desc = "'Meet your lord, and know your place. Let progress be my chariot, and let my hands be the vessel that rips paradise free from its heavenly grasp. Let Psydonia's carcass not spell the death of Man, but the birth of Gods.'"
	sellprice = 66

/obj/item/clothing/neck/roguetown/psicross/astrata/g/triumph
	name = "ornate amulet of Astrata"
	desc = "Her command is absolute, and Her tyranny is unmarrable. Reclaim this world, child of mine, from those who'd seek to destroy it."
	icon_state = "astrata_g"
	sellprice = 77

//

/obj/item/clothing/neck/roguetown/luckcharm
	name = "luck charm"
	desc = "A cabbit's foot necklace. Some say it brings good luck. It only feels more lucky when it's worn around the neck."
	icon_state = "luckcharm"
	sellprice = 15
	possible_item_intents = list(/datum/intent/use, /datum/intent/special/magicarc)
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	grid_width = 32
	grid_height = 32
	var/goodluckactivated = FALSE
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 1

/obj/item/clothing/neck/roguetown/luckcharm/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		user.change_stat(STATKEY_LCK, 1) //how much luck stat it gives when equipped
		goodluckactivated = TRUE
	return

/obj/item/clothing/neck/roguetown/luckcharm/dropped(mob/living/carbon/human/user)
	. = ..()
	if(goodluckactivated == TRUE)
		user.change_stat(STATKEY_LCK, -1) //how much luck stat taken away when unequipped
		goodluckactivated = FALSE
	return

/obj/item/clothing/neck/roguetown/skullamulet/gemerald
	name = "gemerald skull amulet"
	desc = "A massive gemerald, meticulously chiseled into a skull and affixed to a chain. </br>'You're mocking me, aren't you?'"
	slot_flags = ITEM_SLOT_NECK
	icon_state = "skullamulet"
	//dropshrink = 0.75
	color = "#00FF00"
	resistance_flags = FIRE_PROOF
	sellprice = 222
	smeltresult = /obj/item/roguegem/green
	anvilrepair = /datum/skill/craft/armorsmithing
	var/luckyskull = FALSE

/obj/item/clothing/neck/roguetown/skullamulet/gemerald/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_BUFF, "alpha" = 200, "size" = 1))

/obj/item/clothing/neck/roguetown/skullamulet/gemerald/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		user.change_stat(STATKEY_LCK, 2)
		luckyskull = TRUE
	return

/obj/item/clothing/neck/roguetown/skullamulet/gemerald/dropped(mob/living/carbon/human/user)
	. = ..()
	if(luckyskull == TRUE)
		user.change_stat(STATKEY_LCK, -2)
		luckyskull = FALSE
	return

//

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle/matthios
	name = "gilded chain mantle"
	desc = "The world is yours, as they say - yet, why doth the Gods still led us astray?"
	color = "#ffc960"

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle/matthios/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "ARMOR")

//

/obj/item/clothing/neck/roguetown/bevor/zizo
	name = "avantyne bevor"
	desc = "The edge of reality, though unknown to many, favors Her acolytes above all else. This avantyne neckguard wards off the unenlightened's flailing."
	color = "#c1b18d"
	chunkcolor = "#363030"
	material_category = ARMOR_MAT_PLATE

/obj/item/clothing/neck/roguetown/bevor/zizo/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")

//

/obj/item/clothing/neck/roguetown/gorget/steel/graggar
	name = "vicious gorget"
	desc = "Curled plate, cradling the neck. Once, they were chains - now, they've allowed you to break free."
	color = "#ddc0a7"

/obj/item/clothing/neck/roguetown/gorget/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")

//

/obj/item/clothing/neck/roguetown/psicross/malum/secret
	name = "beriddled amulet"
	desc = "A familiar necklace, blisteringly hot to the touch. Yet, as warm as it gets, the metal does not sear my flesh. </br>It whispers with divine inspiration; should I dare don it?"
	icon_state = "malum"
	sellprice = 333
	edelay_type = 1
	equip_delay_self = 33
	smeltresult = /obj/item/riddleofsteel
	equip_delay_self = 3 SECONDS
	unequip_delay_self = 3 SECONDS
	inv_storage_delay = 1 SECONDS
	var/active_item

/obj/item/clothing/neck/roguetown/psicross/malum/secret/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_ARCANE, "alpha" = 200, "size" = 1))

/obj/item/clothing/neck/roguetown/psicross/malum/secret/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		active_item = TRUE
		to_chat(user, span_hypnophrase("..the warmth flows through my veins, yet I do not burn; in fact, my mind feels clearer than ever before.. </br>  </br>..glowing runes race past my eyes, gradually deciphering into the forge's greatest secrets..  </br>  </br>'BLACKSTEEL AND GOLD, SAFFIRA AND BLORTZ - BOUND WITH A PSICROSS O' SILVER, TO FOSTER THE DRAGON'S FURY.'  </br>  </br>'FOUR ENCHANTED RINGS, BOUND IN SILVER. A GEMERALD, ONYX, AMYTHORTZ, RONTZ - OMNIPOTENT, TOGETHER.'  </br>  </br>'A SILVER CATALYST, A BERSERKER'S GREATSWORD ANOINTED WITH GNOLL-BLOOD - MERGED WITH AN ANCIENT GREATSWORD OF GILBRANZE, THE REMAINS OF A DRACONIC RING AND WEEPING PSICROSS, AND WHAT LIES WITHIN THIS AMULET: TO SLAY THE ULTIMATE EVYLLE.'"))
		user.change_stat(STATKEY_INT, 3)
		user.change_stat(STATKEY_LCK, 3)
		user.change_stat(STATKEY_WIL, 3)
		user.change_stat(STATKEY_STR, -3)
		ADD_TRAIT(user, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_FORGEBLESSED, TRAIT_GENERIC)
	return

/obj/item/clothing/neck/roguetown/psicross/malum/secret/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_monkeyhive("..the runes morph into indiscernable smudges, before fading into the world once more. For just a moment, you forget that the heat's blistering within your palm..  </br>  </br>..perhaps, this would better fit in the smoldering heat of a forge.."))
		user.change_stat(STATKEY_INT, -3)
		user.change_stat(STATKEY_LCK, -3)
		user.change_stat(STATKEY_WIL, -3)
		user.change_stat(STATKEY_STR, 3)
		REMOVE_TRAIT(user, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_FORGEBLESSED, TRAIT_GENERIC)
		active_item = FALSE
	return

//

/obj/item/clothing/neck/roguetown/psicross/weeping
	name = "weeping psicross"
	desc = "'Let His name be naught but forgot'n.' </br>The alloy is familiar, but unmentionable. Blood oozes from cracks within the psicross; ensnared in a perpetual state of half-coagulation. A deathly chill tugs your neck, and your cheeks feel wet - are those tears?"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_WRISTS
	icon_state = "psicrossblood"
	max_integrity = 666
	edelay_type = 1
	equip_delay_self = 66
	smeltresult = /obj/item/ingot/weeping
	sellprice = 666
	equip_delay_self = 3 SECONDS
	unequip_delay_self = 7 SECONDS 
	inv_storage_delay = 3 SECONDS
	var/active_item

/obj/item/clothing/neck/roguetown/psicross/weeping/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 200, "size" = 1))

/obj/item/clothing/neck/roguetown/psicross/weeping/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_NECK)
		active_item = TRUE
		to_chat(user, span_red("As you don the psicross, the chains tighten like a vice around your neck!  </br>  </br>You're overcome with a sense of terrible anguish - all of humenity's suffering, thrust upon your very spirit!  </br>  </br>Your chest grows cold, yet your blood boils hotter than magma! Psydonia's villains may be brutal and merciless, but you will be WORSE!  </br>  </br>You've gone BERSERK!"))
		user.change_stat(STATKEY_STR, 3)
		user.change_stat(STATKEY_CON, 3)
		user.change_stat(STATKEY_WIL, 3)
		user.change_stat(STATKEY_INT, -3)
		ADD_TRAIT(user, TRAIT_PSYCHOSIS, TRAIT_GENERIC) //Imitates the fact that you are, in fact, going bonkers.
		ADD_TRAIT(user, TRAIT_NOCSHADES, TRAIT_GENERIC) //Roughly ~30% reduced vision with a sharp red overlay. Provides night vision in the visible tiles.
		ADD_TRAIT(user, TRAIT_DNR, TRAIT_GENERIC) //If you die while the necklace's on, that's it. Technically saveable if someone knows to remove the necklace, before attempting resurrection.
		ADD_TRAIT(user, TRAIT_STRONGKICK, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	return

/obj/item/clothing/neck/roguetown/psicross/weeping/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_monkeyhive("..and at once, the mania subsides. A familiar warmth creeps back into your chest. Though your mind is clear, the thought lingers; was it truly just a malaise, or something more? </br>  </br>..perhaps, this would better fit in the smoldering heat of a forge.."))
		user.change_stat(STATKEY_STR, -3)
		user.change_stat(STATKEY_CON, -3)
		user.change_stat(STATKEY_WIL, -3)
		user.change_stat(STATKEY_INT, 3)
		REMOVE_TRAIT(user, TRAIT_PSYCHOSIS, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_NOCSHADES, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_DNR, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_STRONGKICK, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
		active_item = FALSE
	return

/obj/item/clothing/neck/roguetown/carved
	name = "carved amulet"
	desc = "You shouldn't be seeing this."
	icon_state = "psycross_w"
	item_state = "psycross_w"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 0
	salvage_result = null
	smeltresult = null

/obj/item/clothing/neck/roguetown/carved/jadeamulet
	name = "jade amulet"
	desc = "An amulet carved from jade."
	icon_state = "amulet_jade"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 60

/obj/item/clothing/neck/roguetown/carved/turqamulet
	name = "cerulite amulet"
	desc = "An amulet carved from cerulite."
	icon_state = "amulet_turq"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 85

/obj/item/clothing/neck/roguetown/carved/onyxaamulet
	name = "onyxa amulet"
	desc = "An amulet carved from onyxa."
	icon_state = "amulet_onyxa"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 40

/obj/item/clothing/neck/roguetown/carved/coralamulet
	name = "heartstone amulet"
	desc = "An amulet carved from heartstone."
	icon_state = "amulet_coral"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 70

/obj/item/clothing/neck/roguetown/carved/amberamulet
	name = "amber amulet"
	desc = "An amulet carved from amber."
	icon_state = "amulet_amber"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 60

/obj/item/clothing/neck/roguetown/carved/opalamulet
	name = "opal amulet"
	desc = "An amulet carved from opal."
	icon_state = "amulet_opal"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 90

/obj/item/clothing/neck/roguetown/carved/roseamulet
	name = "rosestone amulet"
	desc = "An amulet carved from rosestone."
	icon_state = "amulet_rose"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 25

/obj/item/clothing/neck/roguetown/carved/shellamulet
	name = "shell amulet"
	desc = "An amulet carved from shells."
	icon_state = "amulet_shell"
	slot_flags = ITEM_SLOT_NECK
	sellprice = 25

/obj/item/clothing/neck/roguetown/collar/prisoner
	name = "castifico collar"
	icon_state = "castifico_collar"
	item_state = "castifico_collar"
	desc = "A metal collar that seals around the neck, making it impossible to remove. It seems to be enchanted with some kind of vile magic..."
	var/active_item
	var/bounty_amount
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NONE //it's not armor

/obj/item/clothing/neck/roguetown/collar/prisoner/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("This cursed collar enforces pacifism and blocks spellcasting.")
	. += span_info("It will automatically release after a period of penance (5-20 minutes based on bounty amount).")
	. += span_info("It can only be removed early by a LIBERTAS machine.")

/obj/item/clothing/neck/roguetown/collar/prisoner/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/roguetown/collar/prisoner/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "castificocollar")
	REMOVE_TRAIT(user, TRAIT_SPELLCOCKBLOCK, "castificocollar")
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/neck/roguetown/collar/prisoner/proc/timerup(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_PACIFISM, "castificocollar")
	REMOVE_TRAIT(user, TRAIT_SPELLCOCKBLOCK, "castificocollar")
	visible_message(span_warning("The castifico collar opens with a click, falling off of [user]'s neck and clambering apart on the ground, their penance complete."))
	say("YOUR PENANCE IS COMPLETE.")
	for(var/name in GLOB.outlawed_players)
		if(user.real_name == name)
			GLOB.outlawed_players -= user.real_name
			priority_announce("[user.real_name] has completed their penance. Justice has been served in the eyes of Ravox.", "PENANCE", 'sound/misc/bell.ogg')
	playsound(src.loc, pick('sound/items/pickgood1.ogg','sound/items/pickgood2.ogg'), 5, TRUE)
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/neck/roguetown/collar/prisoner/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_NECK)
		active_item = TRUE
		to_chat(user, span_warning("This accursed collar pacifies me!"))
		ADD_TRAIT(user, TRAIT_PACIFISM, "castificocollar")
		ADD_TRAIT(user, TRAIT_SPELLCOCKBLOCK, "castificocollar")
		if(HAS_TRAIT(user, TRAIT_RITUALIST))
			user.apply_status_effect(/datum/status_effect/debuff/ritesexpended)
		var/timer = 5 MINUTES //Base timer is 5 minutes, additional time added per bounty amount

		if(bounty_amount >= 10)
			var/additional_time = bounty_amount * 0.1 // 10 mammon = 1 minute
			additional_time = round(additional_time)
			timer += additional_time MINUTES
			timer = clamp(timer, 0 MINUTES, 20 MINUTES)

		var/timer_minutes = timer / 600

		addtimer(CALLBACK(src, PROC_REF(timerup), user), timer)
		say("YOUR PENANCE WILL BE COMPLETE IN [timer_minutes] MINUTES.")
	return

