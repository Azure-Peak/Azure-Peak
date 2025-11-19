// LIGHT ARMORS

/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn
	name = "gronnic ravager helm"
	desc = "A helmet of hardened leather with a carved animal skull to appear similar to a human, A unique design of The Empty North. \
			The visage is said in Iskarn to scare the spirits of those defeated in the battle field \
			and prevent Necra or The Moose from allowing them to haunt."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnleatherhelm"
	item_state = "gronnleatherhelm"
	block2add = null
	body_parts_covered = HEAD|HAIR|EARS|EYES|NOSE
	worn_x_dimension = 32
	worn_y_dimension = 32


/obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
	name = "gronnic ravager mantle"
	desc = "A carefully created mantle of bone and hardened leather. It offers superior protection against the threats of the wild while remaining light, \
			A popular design in Iskarn is to adorn a shoulder with a wolf pelt and skull. So that a great beast is always with you."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnleatherarmor"
	item_state = "gronnleatherarmor"
	armor = ARMOR_GRONN_LIGHT

/obj/item/clothing/under/roguetown/trou/leather/gronn
	name = "gronnic fur pants"
	desc = "A pair of hardened leather pants with bone reinforcements along the legs, \
			A wild design that offers superior protection against blunt and slashing. The attack of beasts."
	icon_state = "gronnleatherpants"
	item_state = "gronnleatherpants"
	armor = ARMOR_GRONN_LIGHT
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH)
	max_integrity = ARMOR_INT_LEG_HARDLEATHER
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	
/obj/item/clothing/gloves/roguetown/angle/gronn
	name = "gronnic fur-lined leather gloves"
	desc = "Thick, padded gloves made for the harshest of climates, and wildest of beasts encountered in the untamed lands."
	icon_state = "gronnleathergloves"
	item_state = "gronnleathergloves"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	color = "#ffffff"

/obj/item/clothing/gloves/roguetown/angle/gronnfur
	name = "gronnic fur-lined bone gloves"
	desc = "A pair of hardened leather gloves with a bone reinforcement across the wrist\
			and the back of the hand offering superior protection against\
			the claws of beasts and the claw of nature and plant common for gatherers."
	icon_state = "gronnfurgloves"
	item_state = "gronnfurgloves"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	unarmed_bonus = 1.25
	max_integrity = 250
	color = "#ffffff"

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	name = "moose hood"
	desc = "A deceptively strong hood of hide with a pair of large heavy antlers. It is the reward of the fourth trial of the Iskarn Shamans, To slay a Grinning moose in the final hunt alone and fashion a hood from it's head."
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/gronn.dmi'
	icon_state = "gronnfurhood"
	item_state = "gronnfurhood"
	bloody_icon = 'icons/effects/blood64.dmi'
	armor = ARMOR_LEATHER_GOOD
	flags_inv = HIDEEARS|HIDEFACE
	worn_x_dimension = 32
	worn_y_dimension = 48
	sellprice = 10
	prevent_crits = list(BCLASS_BLUNT, BCLASS_TWIST)
	anvilrepair = null
	smeltresult = null
	sewrepair = TRUE
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_HELMET_HARDLEATHER
	salvage_result = /obj/item/natural/hide/cured
	var/on = FALSE
	var/lux_consumed = FALSE
	var/lux_color = LIGHT_COLOR_CYAN
	adjustable = CAN_CADJUST
	light_color = LIGHT_COLOR_ORANGE
	light_system = MOVABLE_LIGHT
	light_outer_range = 3
	light_power = 1
	toggle_icon_state = TRUE

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.remove_status_effect(/datum/status_effect/debuff/lost_shaman_hood)
		H.remove_stress(/datum/stressevent/shamanhoodlost)

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/dropped(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.merctype == 1) //Atgervi
			H.apply_status_effect(/datum/status_effect/debuff/lost_shaman_hood)
			H.add_stress(/datum/stressevent/shamanhoodlost)

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/Initialize(mapload)
	. = ..()
	set_light_on(FALSE)

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/MiddleClick(mob/user)
	if(.)
		return
	if(adjustable == CADJUSTED)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	toggle_helmet_light(user)
	to_chat(user, span_info("I spark [src] [on ? "on" : "off"]."))

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/proc/toggle_helmet_light(mob/living/user)
	on = !on
	set_light_on(on)
	if(on)
		playsound(loc, 'sound/effects/hood_ignite.ogg', 100, TRUE)
		do_sparks(2, FALSE, user)
	else
		playsound(loc, 'sound/misc/toggle_lamp.ogg', 100)
	update_icon()

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/update_icon()
	if(adjustable == CADJUSTED)
		..()
		return
	if(on)
		icon_state = "gronnfurhood_lit[lux_consumed ? "3" : "2"]"
		item_state = "gronnfurhood_lit[lux_consumed ? "3" : "2"]"
	else
		icon_state = "gronnfurhood"
		item_state = "gronnfurhood"
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_head()
	..()

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/lux))
		if(adjustable == CADJUSTED)
			to_chat(user, span_warning("The hood must be up for this to work!"))
			return
		if(lux_consumed)
			to_chat(user, span_warning("It has already been infused."))
			return
		to_chat(user, span_warning("I infuse the hood with the soul energies!"))
		lux_consumed = TRUE
		set_light_range_power_color(6, 2, lux_color) //The light is doubled
		if(!on)
			toggle_helmet_light(user)
		else
			update_icon()
		qdel(I)
	. = ..()
	

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			playsound(src, 'sound/foley/equip/rummaging-03.ogg', 50, TRUE)
			if(on)
				toggle_helmet_light(user)
			if(toggle_icon_state)
				icon_state = "gronnfurhood_down"
				item_state = "gronnfurhood_down"
			adjustable = CADJUSTED
			flags_inv = null
			body_parts_covered = null
		else if(adjustable == CADJUSTED)
			playsound(src, 'sound/foley/equip/cloak (3).ogg', 50, TRUE)
			ResetAdjust(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_neck()
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/leather/shaman_hood/ResetAdjust(mob/user)
	. = ..()
	if(on)
		set_light_on(FALSE)
	update_icon()


// MEDIUM ARMOR -- Iron reskins

/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel
	name = "gronnic ownel helmet"
	desc = "A full helmet that protects the eyes and head well, \
			The slits decorated with a harsh gold dye are said to in Gronn to give those the ability to see keenly like a bird."
	icon_state = "gronnhelm"
	item_state = "gronnhelm"

/obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	name = "gronn byrine hauberk"
	desc = "A chain shirt of Gronnic design with a leather coat layered over \
			offering additional protection and superior movement. Often used by sea raiders."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnchain"
	item_state = "gronnchain"
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/gloves/roguetown/chain/gronn
	name = "gronn byrine gloves"
	desc = "A pair of leather gloves with chain to protects the wrists and back of the hand."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnchaingloves"
	item_state = "gronnchaingloves"

/obj/item/clothing/under/roguetown/splintlegs/iron/gronn
	name = "gronn byrine chausses"
	desc = "A pair of chain pants with a leather subligar for both protection and comfort."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnchainpants"
	item_state = "gronnchainpants"


// HEAVY ARMOR -- ditto

/obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn
	name = "gronn norsii horned helmet"
	desc = "A horned Iron helmet, A clear design of Gronn. \
		Styled after the appearance of invading knights of legend from the northern empty, \
		A time before their was snow. Brutal and plain."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/gronn.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	icon_state = "gronnplatehelm"
	item_state = "gronnplatehelm"
	emote_environment = 3
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	block2add = FOV_BEHIND
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 1
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/suit/roguetown/armor/plate/iron/gronn
	name = "gronn norsii iron plate"
	desc = "Iron chestplate adorned with tassets and roundels, \
			Those of Gronn oft never used plate but when the northmen come in plate, \
			It is said to be a sight to shake armies."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnplate"
	item_state = "gronnplate"
	boobed = FALSE
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/gloves/roguetown/plate/iron/gronn
	name = "gronn norsii iron gauntlets"
	desc = "Iron gauntlets, Simple and protective in design.. A single punch leaves a nasty mark."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnplategloves"
	item_state = "gronnplategloves"

/obj/item/clothing/under/roguetown/platelegs/iron/gronn
	name = "gronn norsii iron chausses"
	desc = "Iron Chausses with an added set of leather for comfort and padding, The knees are adorned with a skull like shape and that of the moon."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnplatepants"
	item_state = "gronnplatepants"

/obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn
	name = "gronn norsii iron boots"
	desc = "Iron boots, Tied with leather strapping. \
			Protective, A Gronnic legend tells of a great warrior who fought for aeons until a \
			hero speared him in the foot. Many follow this example by protecting their feet heavily."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnplateboots"
	item_state = "gronnplateboots"
