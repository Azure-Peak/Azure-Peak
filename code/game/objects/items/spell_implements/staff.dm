/obj/item/rogueweapon/woodstaff/implement
	base_implement_name = "lesser staff"
	name = "lesser staff"
	desc = "A mage's staff fitted with a lesser focus-gem. The gem captures excess energy dissipated into the air when a spell is cast, giving a fraction of it back to the wielder."
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "topazstaff"
	implement_tier = IMPLEMENT_TIER_LESSER
	implement_refund = IMPLEMENT_REFUND_LESSER
	resistance_flags = FIRE_PROOF
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(SPEAR_BASH, /datum/intent/mace/smash/wood)
	max_integrity = 150
	sellprice = 34

/obj/item/rogueweapon/woodstaff/implement/greater
	base_implement_name = "greater staff"
	name = "greater staff"
	desc = "A mage's staff crowned with a quality focus-gem. The gem captures excess energy dissipated into the air when a spell is cast, giving a generous share of it back to the wielder."
	icon_state = "emeraldstaff"
	implement_tier = IMPLEMENT_TIER_GREATER
	implement_refund = IMPLEMENT_REFUND_GREATER
	max_integrity = 200
	sellprice = 42

/obj/item/rogueweapon/woodstaff/implement/grand
	base_implement_name = "grand staff"
	name = "grand staff"
	desc = "A masterwork staff set with a gem of extraordinary quality. The gem captures excess energy dissipated into the air when a spell is cast, giving most of it back to the wielder - arcyne economy refined to an art."
	icon_state = "diamondstaff"
	implement_tier = IMPLEMENT_TIER_GRAND
	implement_refund = IMPLEMENT_REFUND_GRAND
	max_integrity = 250
	sellprice = 121

/obj/item/rogueweapon/woodstaff/implement/examine(mob/user)
	. = ..()
	if(implement_refund)
		. += span_notice("When held while casting, this implement leaves behind Residual Focus, returning [round(implement_refund * 100)]% of the spell's resource cost as energy over 20 seconds.")


/datum/intent/magos_electrocute
	name = "shock associate"
	blade_class = null
	icon_state = "inuse"
	tranged = TRUE
	noaa = TRUE

/obj/item/rogueweapon/woodstaff/implement/grand/magos
	base_implement_name = null
	name = "\improper Staff of the Court Magos"
	icon_state = "courtstaff"
	possible_item_intents = list(SPEAR_BASH, /datum/intent/magos_electrocute)
	gripped_intents = list(SPEAR_BASH, /datum/intent/mace/smash/wood, /datum/intent/magos_electrocute)
	COOLDOWN_DECLARE(magosstaff)

/obj/item/rogueweapon/woodstaff/implement/grand/magos/afterattack(atom/target, mob/user, flag)
	. = ..()
	if(get_dist(user, target) > 7)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(ishuman(user))
		var/mob/living/carbon/human/HU = user
		if(HU.job != "Court Magician")
			to_chat(user, span_danger("The staff doesn't obey me."))
			return
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H == HU)
				return
			if(!COOLDOWN_FINISHED(src, magosstaff))
				to_chat(user, span_danger("The [src] is not ready yet! [round(COOLDOWN_TIMELEFT(src, magosstaff) / 10, 1)] seconds left!"))
				return
			if(H.anti_magic_check())
				to_chat(user, span_danger("Their magic protection has interrupted my cast!"))
				return
			if(H.job != "Magicians Associate")
				to_chat(user, span_danger("The target must one of my associates!"))
				return
			if(istype(user.used_intent, /datum/intent/magos_electrocute))
				HU.visible_message(span_warning("[HU] electrocutes [H] with the [src]."))
				user.Beam(target,icon_state="lightning[rand(1,12)]",time=5)
				H.electrocute_act(5, src)
				COOLDOWN_START(src, magosstaff, 20 SECONDS)
				to_chat(H, span_danger("I'm electrocuted by the Court Magos!"))
				return

/obj/item/rogueweapon/woodstaff/implement/greater/blacksteel
	base_implement_name = "blacksteel staff"
	name = "blacksteel staff"
	desc = "A fine wood staff that is reinforced with blacksteel rivets and furnishings often used by War-Magos that have graduated from the Celestial Academy of Magos. Perched atop it is a less efficient though equally beautiful alchemical Dorpel. Perhaps it could be enhanced with a better Dorpel?"
	icon_state = "blacksteelstaff"
	max_integrity = 250

/obj/item/rogueweapon/woodstaff/implement/grand/blacksteel
	base_implement_name = "refined blacksteel staff"
	name = "refined blacksteel staff"
	desc = "A fine wood staff that is reinforced with blacksteel rivets and furnishings often used by War-Magos that have graduated from the Celestial Academy of Magos. Perched atop it is a beautiful Dorpel that shimmers with magical energies."
	icon_state = "blacksteelstaff"
	max_integrity = 300

/obj/item/rogueweapon/woodstaff/implement/grand/naledi
	base_implement_name = "naledian warstaff"
	name = "naledian warstaff"
	desc = "A staff carrying the crescent moon of Psydon's knowledge, as well as the black and gold insignia of the war scholars."
	icon_state = "naledistaff"
	possible_item_intents = list(SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/bash/ranged, /datum/intent/mace/smash/wood/ranged)
	force = 18
	force_wielded = 22
	max_integrity = 300
	resistance_flags = FIRE_PROOF
	sellprice = 40

/obj/item/rogueweapon/woodstaff/implement/grand/naledi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -9,"sy" = 5,"nx" = 9,"ny" = 5,"wx" = -4,"wy" = 4,"ex" = 4,"ey" = 4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 8,"sy" = 0,"nx" = -1,"ny" = 0,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
