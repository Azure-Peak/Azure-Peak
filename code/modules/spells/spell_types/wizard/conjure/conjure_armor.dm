/obj/effect/proc_holder/spell/self/conjure_armor
	name = "Conjure Fateweaver"
	desc = "Conjure a fate weaver, a full-body protecting ring that breaks easily. Cannot be summoned if wearing anything heavier than light armor.\n\
	The ring lasts until it is broken, a new one is summoned, or the spell is forgotten."
	overlay_state = "conjure_armor"
	sound = list('sound/magic/whiteflame.ogg')

	releasedrain = 50
	chargedrain = 1
	chargetime = 3 SECONDS
	no_early_release = TRUE
	recharge_time = 90 SECONDS

	warnie = "spellwarning"
	no_early_release = TRUE
	antimagic_allowed = FALSE
	charging_slowdown = 3
	cost = 2
	spell_tier = 2

	invocations = list("Cladum Fati!") //destiny's defeat!
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM


	var/objtoequip = /obj/item/clothing/ring/fate_weaver
	var/slottoequip = SLOT_RING
	var/obj/item/clothing/conjured_armor = null
	var/checkspot = "ring"
	var/cooldown_on_dissipate = TRUE
	var/summondelay = 0


/obj/effect/proc_holder/spell/self/conjure_armor/proc/start_delayed_recharge()
	if(charge_counter < recharge_time)
		return
	charge_counter = 0
	last_process_time = world.time
	START_PROCESSING(SSfastprocess, src)
	if(action)
		action.UpdateButtonIcon()


/obj/effect/proc_holder/spell/self/conjure_armor/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/human/H = user
	var/targetac = H.highest_ac_worn()
	if(targetac > 1)
		to_chat(user, span_warning("I must be wearing lighter armor!"))
		revert_cast()
		return FALSE
	if(user.get_num_arms() <= 0)
		to_chat(user, span_warning("I don't have any usable hands!"))
		revert_cast()
		return FALSE
	switch(checkspot)
		if("ring")
			if(user.get_num_arms() <= 0)
				to_chat(user, span_warning("I don't have any usable hands!"))
				revert_cast()
				return FALSE
			if(H.wear_ring)
				to_chat(user, span_warning("My ring finger must be free!"))
				revert_cast()
				return FALSE
		if("armor")
			if(H.wear_armor)
				to_chat(user, span_warning("I cannot wear this while wearing armor over my chest!"))
				revert_cast()
				return FALSE

	if(summondelay)
		if(!do_after(user, summondelay, target = user))
			revert_cast()
			return FALSE

	user.visible_message("[user]'s existence briefly jitters, conjuring protection from doomed fates!")
	var/item = objtoequip
	conjured_armor = new item(user)
	user.equip_to_slot_or_del(conjured_armor, slottoequip)
	if(!QDELETED(conjured_armor))
		conjured_armor.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE)
		if(cooldown_on_dissipate)
			if(istype(conjured_armor, /obj/item/clothing/ring/fate_weaver))
				var/obj/item/clothing/ring/fate_weaver/ring = conjured_armor
				ring.linked_conjure_spell = src
			if(istype(conjured_armor, /obj/item/clothing/suit/roguetown/crystalhide))
				var/obj/item/clothing/suit/roguetown/crystalhide/armor = conjured_armor
				armor.linked_conjure_spell = src
			if(istype(conjured_armor, /obj/item/clothing/suit/roguetown/dragonhide))
				var/obj/item/clothing/suit/roguetown/dragonhide/armor = conjured_armor
				armor.linked_conjure_spell = src
			charge_counter = recharge_time
			STOP_PROCESSING(SSfastprocess, src)
			if(action)
				action.UpdateButtonIcon()
	return TRUE

/obj/effect/proc_holder/spell/self/conjure_armor/miracle
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/self/conjure_armor/Destroy()
	if(src.conjured_armor)
		conjured_armor.visible_message(span_warning("The [conjured_armor]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(conjured_armor)
	return ..()
