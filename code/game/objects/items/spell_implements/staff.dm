/obj/item/rogueweapon/woodstaff/implement
	base_implement_name = "lesser staff"
	name = "lesser staff"
	desc = "A mage's staff fitted with a lesser focus-gem. The gem captures excess energy dissipated into the air when a spell is cast, giving a fraction of it back to the wielder."
	icon = 'icons/obj/items/staffs.dmi'
	icon_state = "topazstaff"
	implement_tier = IMPLEMENT_TIER_LESSER
	implement_refund = IMPLEMENT_REFUND_LESSER
	resistance_flags = FIRE_PROOF
	// Mage 3 ran an experiment with having staff have higher force to encourage them to engage in melee but it shifted too much power away to the point that mage melee was becoming a viable, if not expected DPS contributor, thus skewing mage power balance. So, to make it a finisher tool, we are gonna increase the clickCD such that it doesn't become a decent DPS machine, and that upgrading staff improves your melee prowess for FINISHER. TO do this, we make their bash have no extra integrity modifier. The intention is that it is used to tap someone after magic finish their armor off.
	possible_item_intents = list(/datum/intent/spear/bash/staff/onehand)
	gripped_intents = list(/datum/intent/spear/bash/staff, /datum/intent/mace/smash/wood)
	force = 10
	force_wielded = 20
	wdefense = 5
	wdefense_wbonus = 5 // 80% vs one-skill-up matchup. 60% vs two-skill-up matchup. (Rare)
	max_integrity = 200
	special = /datum/special_intent/quarterstaff_sweep
	sellprice = 12
	implement_upgradable = TRUE
	var/gem_socketable = TRUE
	var/obj/item/socketed_gem

/obj/item/rogueweapon/woodstaff/implement/proc/gem_icon_state_for(obj/item/gem)
	var/static/list/gem_icon_states = list(
		/obj/item/roguegem/yellow = "topazstaff",
		/obj/item/roguegem/amethyst = "amethyststaff",
		/obj/item/roguegem/green = "emeraldstaff",
		/obj/item/roguegem/ruby = "rubystaff",
		/obj/item/roguegem/blue = "quartzstaff",
		/obj/item/roguegem/violet = "sapphirestaff",
		/obj/item/roguegem/diamond = "diamondstaff",
		/obj/item/riddleofsteel = "riddlestaff",
	)
	for(var/gem_type in gem_icon_states)
		if(istype(gem, gem_type))
			return gem_icon_states[gem_type]

/obj/item/rogueweapon/woodstaff/implement/proc/can_socket_gem()
	if(!gem_socketable)
		return FALSE
	return initial(icon_state) in list("topazstaff", "amethyststaff", "emeraldstaff", "rubystaff", "quartzstaff", "sapphirestaff", "diamondstaff", "riddlestaff")

/obj/item/rogueweapon/woodstaff/implement/attackby(obj/item/I, mob/living/user, params)
	if(!istype(I, /obj/item/roguegem) && !istype(I, /obj/item/riddleofsteel))
		return ..()
	if(!can_socket_gem())
		to_chat(user, span_warning("[src] won't take a gem!"))
		return TRUE
	var/new_state = gem_icon_state_for(I)
	if(!new_state)
		to_chat(user, span_warning("[I] doesn't seem to fit [src]."))
		return TRUE
	if(!user.transferItemToLoc(I, src))
		return TRUE
	var/obj/item/old_gem = socketed_gem
	socketed_gem = I
	if(old_gem)
		old_gem.forceMove(drop_location())
		user.put_in_hands(old_gem)
	set_gem_icon(new_state, user)
	to_chat(user, span_notice("I set [I] into [src][old_gem ? ", prying [old_gem] loose" : ""]."))
	return TRUE

/obj/item/rogueweapon/woodstaff/implement/rmb_self(mob/user, keybind = FALSE)
	if(!socketed_gem || keybind || user.cmode)
		return ..()
	var/obj/item/old_gem = socketed_gem
	socketed_gem = null
	old_gem.forceMove(drop_location())
	user.put_in_hands(old_gem)
	set_gem_icon(initial(icon_state), user)
	to_chat(user, span_notice("I pry [old_gem] out of [src]."))

/obj/item/rogueweapon/woodstaff/implement/proc/set_gem_icon(new_state, mob/user)
	override_state = (new_state == initial(icon_state)) ? null : new_state
	icon_state = new_state
	update_transform()
	update_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
		M.update_inv_back()

/obj/item/rogueweapon/woodstaff/implement/examine(mob/user)
	. = ..()
	if(implement_refund)
		. += span_notice("When held while casting, this implement leaves behind Residual Focus, returning [round(implement_refund * 100)]% of the spell's resource cost as energy over 20 seconds.")
	if(socketed_gem)
		. += span_info("[socketed_gem] is set into it. Right-click it in hand to pry the gem loose.")
	else if(can_socket_gem())
		. += span_info("Gems are cosmetic on a staff.")

/obj/item/rogueweapon/woodstaff/implement/obj_destruction(damage_flag)
	if(socketed_gem)
		socketed_gem.forceMove(drop_location())
		socketed_gem = null
	return ..()

/obj/item/rogueweapon/woodstaff/implement/Exited(atom/movable/gone, atom/newLoc)
	. = ..()
	if(gone == socketed_gem)
		socketed_gem = null

/obj/item/rogueweapon/woodstaff/implement/implement_tier_type(tier)
	switch(tier)
		if(IMPLEMENT_TIER_LESSER)
			return /obj/item/rogueweapon/woodstaff/implement
		if(IMPLEMENT_TIER_GREATER)
			return /obj/item/rogueweapon/woodstaff/implement/greater
		if(IMPLEMENT_TIER_GRAND)
			return /obj/item/rogueweapon/woodstaff/implement/grand

/obj/item/rogueweapon/woodstaff/implement/transfer_implement_state(obj/item/rogueweapon/morphed, mob/user)
	. = ..()
	if(!socketed_gem)
		return
	var/obj/item/gem = socketed_gem
	socketed_gem = null
	gem.forceMove(get_turf(user))
	user?.put_in_hands(gem)

/obj/item/rogueweapon/woodstaff/implement/amethyst
	icon_state = "amethyststaff"

/obj/item/rogueweapon/woodstaff/implement/greater
	base_implement_name = "greater staff"
	name = "greater staff"
	desc = "A mage's staff crowned with a quality focus-gem. The gem captures excess energy dissipated into the air when a spell is cast, giving a generous share of it back to the wielder."
	icon_state = "emeraldstaff"
	implement_tier = IMPLEMENT_TIER_GREATER
	implement_refund = IMPLEMENT_REFUND_GREATER
	force_wielded = 22
	max_integrity = 250
	sellprice = 25

/obj/item/rogueweapon/woodstaff/implement/greater/ruby
	icon_state = "rubystaff"

/obj/item/rogueweapon/woodstaff/implement/greater/quartz
	icon_state = "quartzstaff"

/obj/item/rogueweapon/woodstaff/implement/greater/sapphire
	icon_state = "sapphirestaff"

/obj/item/rogueweapon/woodstaff/implement/grand
	base_implement_name = "grand staff"
	name = "grand staff"
	desc = "A masterwork staff set with a gem of extraordinary quality. The gem captures excess energy dissipated into the air when a spell is cast, giving most of it back to the wielder - arcyne economy refined to an art."
	icon_state = "diamondstaff"
	implement_tier = IMPLEMENT_TIER_GRAND
	implement_refund = IMPLEMENT_REFUND_GRAND
	force_wielded = 25
	max_integrity = 280
	sellprice = 50

/obj/item/rogueweapon/woodstaff/implement/grand/riddle
	icon_state = "riddlestaff"


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
	possible_item_intents = list(/datum/intent/spear/bash/staff/onehand, /datum/intent/magos_electrocute)
	gripped_intents = list(/datum/intent/spear/bash/staff, /datum/intent/mace/smash/wood/ranged, /datum/intent/magos_electrocute)
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
	desc = "A fine wood staff reinforced with blacksteel rivets and furnishings, carried by War-Magos who graduated from the Celestial Academy of Magos. Perched atop it is a beautiful alchemical Dorpel. Its focus can be improved further with a runic tincture."
	icon_state = "blacksteelstaff"

/obj/item/rogueweapon/woodstaff/implement/grand/naledi
	base_implement_name = "naledian warstaff"
	name = "naledian warstaff"
	desc = "A staff carrying the crescent moon of Psydon's knowledge, as well as the black and gold insignia of the war scholars."
	icon_state = "naledistaff"

/obj/item/rogueweapon/woodstaff/implement/grand/naledi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -9,"sy" = 5,"nx" = 9,"ny" = 5,"wx" = -4,"wy" = 4,"ex" = 4,"ey" = 4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 8,"sy" = 0,"nx" = -1,"ny" = 0,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
