#define EQUALIZED_GLOW "equalizer glow"

// T0: Determine the net mammon value of target

/obj/effect/proc_holder/spell/invoked/appraise
	name = "Appraise"
	desc = "Tells you how many mammons someone has on them and in the meister."
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "appraise"
	miracle = TRUE
	devotion_cost = 5
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS

/obj/effect/proc_holder/spell/invoked/appraise/secular
	name = "Secular Appraise"
	range = 2
	associated_skill = /datum/skill/misc/reading // idk reading is like Accounting right
	miracle = FALSE
	devotion_cost = 0 //Merchants are not clerics

/obj/effect/proc_holder/spell/invoked/appraise/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_DECEIVING_MEEKNESS) && target != user)
			to_chat(user, "<font color='yellow'>I cannot tell...</font>")
			if(prob(50 + ((target.STAPER - 10) * 10)))
				to_chat(target, span_warning("A pair of prying eyes were laid on me..."))
			return
		var/mammonsonperson = get_mammons_in_atom(target)
		var/mammonsinbank = SStreasury.bank_accounts[target]
		var/totalvalue = mammonsinbank + mammonsonperson
		to_chat(user, ("<font color='yellow'>[target] has [mammonsonperson] mammons on them, [mammonsinbank] in their meister, for a total of [totalvalue] mammons.</font>"))

//T0: Summon a lockpick on demand
/datum/action/cooldown/spell/lesser_knock/miracle
	name = "Emancipate"
	desc = "A simple prayer to the free-god that forms into an instrument for lockpicking. Can be dispelled by using it on anything that isn't a locked/unlocked door."
	button_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	button_icon_state = "lockpick"
	invocations = list("Transact me your tools.", "Grant me tools of trade.")
	invocation_type = INVOCATION_WHISPER
	associated_skill = /datum/skill/magic/holy

//T0: Firebreath
/obj/effect/proc_holder/spell/invoked/matthios_firebreath // Shamelessly steals Wither's cool code / Originally from Racial Perk PR for drakians
	name = "Raze"
	desc = "Tap into the dragon aspect of your Lord, unleashing a wave of unholy fyre in front of you. Damage increases with Holy Skill"
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "breath"
	miracle = TRUE
	devotion_cost = 20
	releasedrain = 30
	chargedrain = 2
	chargetime = 1 SECONDS
	range = 3
	sound = 'sound/misc/bamf.ogg'
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "emote"
	invocations = list("sharply exhales, breathing out cloud of fyre.")
	chargedloop = /datum/looping_sound/invokefire
	recharge_time = 2 MINUTES
	associated_skill = /datum/skill/magic/holy
	var/delay = 12
	var/strike_delay = 2
	var/damage = 20

/obj/effect/proc_holder/spell/invoked/matthios_firebreath/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)

	if(T.z != user.z)
		revert_cast()
		return FALSE

	var/list/affected_turfs = getline(source_turf, T)
	affected_turfs -= source_turf // Remove caster's turf

	if(get_dist(source_turf, T) > range)
		to_chat(user, span_danger("Too far!"))
		revert_cast()
		return FALSE

	for(var/i = 1, i <= min(affected_turfs.len, range), i++) // Respect spell range
		var/turf/affected_turf = affected_turfs[i]
		if(!(affected_turf in view(source_turf)))
			continue
		var/tile_delay = strike_delay * (i - 1) + delay
		new /obj/effect/temp_visual/trap/firebreath(affected_turf, tile_delay)
		addtimer(CALLBACK(src, PROC_REF(ignite), affected_turf), tile_delay)
	return TRUE

/obj/effect/proc_holder/spell/invoked/matthios_firebreath/proc/ignite(turf/damage_turf)
	new /obj/effect/temp_visual/firebreath_actual(damage_turf)
	playsound(damage_turf, 'sound/magic/fireball.ogg', 50, TRUE)

	for(var/mob/living/L in damage_turf)
		if(L == usr)
			continue
		var/total_damage = (damage + (usr.get_skill_level(associated_skill, 15)))
		L.adjustFireLoss(total_damage) // Just straight damage, no firestacks or ignite
		to_chat(L, span_userdanger("You're scorched by flames!"))

	new /obj/effect/hotspot(damage_turf) // This is the actual scary part

/obj/effect/temp_visual/trap/firebreath
	icon = 'icons/effects/effects.dmi'
	icon_state = "impact_bullet"
	duration = 10 SECONDS
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/firebreath_actual
	icon = 'icons/effects/fire.dmi'
	icon_state = "2"
	light_outer_range = 2
	light_color = "#FF6A00"
	duration = 1 SECONDS

//T0, Matthiosite thievery boon
/obj/effect/proc_holder/spell/self/matthios_muffle
	name = "Muffle"
	desc = "Bargain for a pair of boots to help you avoid detection of those who would wish harm upon you."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "muffle"
	miracle = TRUE
	associated_skill = /datum/skill/magic/holy
	recharge_time = 45 MINUTES //To avoid spamming this.
	releasedrain = 40
	devotion_cost = 40

/obj/effect/proc_holder/spell/self/matthios_muffle/cast(mob/living/user)
	var/turf/T = get_turf(user)
	if(!isclosedturf(T))
		new /obj/item/clothing/shoes/roguetown/boots/muffle_matthios(T)
		return TRUE

	to_chat(user, span_warning("The targeted location is blocked. His gift cannot be invoked."))
	revert_cast()
	return FALSE

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios //I guess in case someone wants to make generic muffled boots? Change it to muffle/matthios if you do
	name = "gilded leather boots"
	desc = "Those who bear His fyre often cower in its shadow."
	icon_state = "matthiosboots"
	sewrepair = TRUE
	armor = ARMOR_LEATHER

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_SHOES && HAS_TRAIT(user, TRAIT_FREEMAN))
		to_chat(user, span_info("Like Him, I slink into the shadows."))
		ADD_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthiosboon")
		ADD_TRAIT(user, TRAIT_LIGHT_STEP, "matthiosboon")

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.shoes == src)
		to_chat(user, span_info("Once again, I am under Her gaze."))
		REMOVE_TRAIT(user, TRAIT_SILENT_FOOTSTEPS, "matthiosboon")
		REMOVE_TRAIT(user, TRAIT_LIGHT_STEP, "matthiosboon")

// T1 - Take value of item in hand, apply that as healing. Destroys item.

/obj/effect/proc_holder/spell/invoked/matthios_transact
	name = "Transact"
	desc = "Sacrifice an item in your hand, applying a heal over time to yourself with strenght depending on its value."
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "transact"
	miracle = TRUE
	devotion_cost = 20
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 1
	ignore_los = TRUE // this is basically a /self spell but it needs invoking procs
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocations = list("I offer thee myne gift!", "Blessings upon thine humble servant!", "Grant me thine fyre my lord!", "A transaction for myne lyfe!")
	invocation_type = "shout"//So someone might actually figures out you are supposed to be valid using this.
	sound = 'sound/effects/hood_ignite.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS


/obj/effect/proc_holder/spell/invoked/matthios_transact/cast(list/targets, mob/living/user)
	. = ..()
	var/obj/item/held_item = user.get_active_held_item()
	if(!held_item)
		to_chat(user, span_info("I need something of value to make a transaction..."))
		return
	var/helditemvalue = held_item.get_real_price()
	if(!helditemvalue)
		to_chat(user, span_info("This has no value, It will be of no use in such a transaction."))
		return
	if(helditemvalue<10)
		to_chat(user, span_info("This has little value, It will be of no use in such a transaction."))
		return
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		user.visible_message(span_notice("The transaction is made! [target] is bathed in a golden light!"))
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/datum/status_effect/buff/healing/heal_effect = C.apply_status_effect(/datum/status_effect/buff/healing)
			if(heal_effect)
				heal_effect.healing_on_tick = helditemvalue / 2
			playsound(user, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
			if(istype(held_item, /obj/item/rogueweapon))
				to_chat(user, "<font color='yellow'>[held_item] melts at its very fabric turning it into a heap of scrap. My transaction is accepted.</font>")
				held_item.obj_break(TRUE)
				held_item.sellprice = 1
			else
				to_chat(user, "<font color='yellow'>[held_item] is engulfed in unholy flame and dissipates into ash. My transaction is accepted.</font>")
				qdel(held_item)
		else
			target.adjustBruteLoss(helditemvalue/2)
			target.adjustFireLoss(helditemvalue/2)
			playsound(user, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
			if(istype(held_item, /obj/item/rogueweapon))
				to_chat(user, "<font color='yellow'>[held_item] melts at its very fabric turning it into a heap of scrap. My transaction is accepted.</font>")
				held_item.obj_break(TRUE)
				held_item.sellprice = 1
			else
				to_chat(user, "<font color='yellow'>[held_item] is engulfed in unholy flame and dissipates into ash. My transaction is accepted.</font>")
				qdel(held_item)
		return TRUE
	revert_cast()
	return FALSE

// T2 We're going to debuff a targets stats = to the difference between us and them in total stats.

/obj/effect/proc_holder/spell/invoked/matthios_equalize
	name = "Equalize"
	desc = "Create equality, with a thumb on the scales, with your target. Siphon strength, speed, and constitution from them."
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "equalize"
	clothes_req = FALSE
	miracle = TRUE
	devotion_cost = 50
	associated_skill = /datum/skill/magic/holy
	chargedloop = /datum/looping_sound/invokeascendant
	sound = 'sound/magic/swap.ogg'
	chargedrain = 0
	chargetime = 5 SECONDS
	releasedrain = 60
	no_early_release = TRUE
	antimagic_allowed = TRUE
	movement_interrupt = FALSE
	recharge_time = 6 MINUTES
	range = 4

/obj/effect/proc_holder/spell/invoked/matthios_equalize/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/target = targets[1]
		if(user == target)
			to_chat(user,"<font color='yellow'>I cannot equalize myself, what am I trying to achieve?</font>")
			revert_cast()
			return
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] resists EQUALITY!"))
			return TRUE
		if(HAS_TRAIT(target, TRAIT_NOBLE))
			target.apply_status_effect(/datum/status_effect/debuff/equalizedebuff_noble)
			user.apply_status_effect(/datum/status_effect/buff/equalizebuff)//Same buff but they get punished harder
			return TRUE
		else
			target.apply_status_effect(/datum/status_effect/debuff/equalizedebuff)
			user.apply_status_effect(/datum/status_effect/buff/equalizebuff)
			return TRUE
	revert_cast()
	return FALSE


 // buff
/datum/status_effect/buff/equalizebuff
	id = "equalize"
	alert_type = /atom/movable/screen/alert/status_effect/buff/equalized
	effectedstats = list(STATKEY_STR = 2, STATKEY_SPD = 2, STATKEY_LCK = 3)
	duration = 3 MINUTES
	var/outline_colour = "#FFD700"


/atom/movable/screen/alert/status_effect/buff/equalized
	name = "Equalized"
	desc = "I've stolen my opponent's fyre."
	icon_state = "equalize_buff"

/datum/status_effect/buff/equalizebuff/on_apply()
	. = ..()
	owner.add_filter(EQUALIZED_GLOW, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))

/datum/status_effect/buff/equalizebuff/on_remove()
	. = ..()
	owner.remove_filter(EQUALIZED_GLOW)
	to_chat(owner, "<font color='yellow'>The link wears off, and the stolen fyre returns to them.</font>")


 // debuff
/datum/status_effect/debuff/equalizedebuff
	id = "equalize"
	alert_type = /atom/movable/screen/alert/status_effect/buff/equalized
	effectedstats = list(STATKEY_STR = -2, STATKEY_SPD = -2, STATKEY_LCK = -3)
	duration = 3 MINUTES
	var/outline_colour = "#FFD700"

/atom/movable/screen/alert/status_effect/debuff/equalized
	name = "Equalized"
	desc = "My fire has been stolen from me!"
	icon_state = "equalize_debuff"

/datum/status_effect/debuff/equalizedebuff/on_apply()
	. = ..()
	owner.add_filter(EQUALIZED_GLOW, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))

/datum/status_effect/debuff/equalizedebuff/on_remove()
	. = ..()
	owner.remove_filter(EQUALIZED_GLOW)
	to_chat(owner, "<font color='yellow'>My fire returns!</font>")

 // debuff - noble
/datum/status_effect/debuff/equalizedebuff_noble
	id = "equalize"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/equalized_noble
	effectedstats = list(STATKEY_STR = -3, STATKEY_SPD = -3, , STATKEY_LCK = -6)
	duration = 3 MINUTES
	var/outline_colour = "#FFD700"

/atom/movable/screen/alert/status_effect/debuff/equalized_noble
	name = "Equalized"
	desc = "My fire has been stolen from me!"
	icon_state = "equalize_debuff"

/datum/status_effect/debuff/equalizedebuff_noble/on_apply()
	. = ..()
	owner.add_filter(EQUALIZED_GLOW, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 200, "size" = 1))

/datum/status_effect/debuff/equalizedebuff_noble/on_remove()
	. = ..()
	owner.remove_filter(EQUALIZED_GLOW)
	to_chat(owner, "<font color='yellow'>My fire returns!</font>")


/obj/effect/proc_holder/spell/invoked/barter
	name = "Barter"
	desc = "Offer the targeted item to your patron, in exchange for a sum of mammon, scaling with my expertise in holy skill. The capricious nature of Matthios makes this a poor value exchange, all in all."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "barter"
	miracle = TRUE
	devotion_cost = 20
	associated_skill = /datum/skill/magic/holy
	chargedloop = /datum/looping_sound/invokeascendant
	chargedrain = 0
	chargetime = 1 SECONDS
	releasedrain = 30
	no_early_release = TRUE
	antimagic_allowed = FALSE
	movement_interrupt = TRUE
	recharge_time = 35 SECONDS
	range = 1
	//This is an EXPLICIT list of paths that we CAN Barter. We do not istype() here, it's a .type == .type check.
	var/static/list/barter_whitelist = list(
		/obj/item/clothing/ring,
		/obj/item/clothing/ring/gold,
		/obj/item/clothing/ring/blacksteel,
		/obj/item/clothing/ring/coral,
		/obj/item/clothing/ring/opal,
		/obj/item/clothing/ring/jade,
		/obj/item/clothing/ring/aalloy,
		/obj/item/clothing/ring/amber,
		/obj/item/clothing/ring/band,
		/obj/item/clothing/ring/bronze,
		/obj/item/clothing/ring/diamond,
		/obj/item/clothing/ring/diamonds,
		/obj/item/clothing/ring/diamondbs,
		/obj/item/clothing/ring/dragon_ring,
		/obj/item/clothing/ring/emerald,
		/obj/item/clothing/ring/emeraldbs,
		/obj/item/clothing/ring/emeralds,
		/obj/item/clothing/ring/signet,
		/obj/item/clothing/ring/signet/silver,
	)

/obj/effect/proc_holder/spell/invoked/barter/cast(list/targets, mob/user)
	. = ..()
	if(!istype(targets[1], /obj/item))
		revert_cast()
		to_chat(user, span_warning("This is not a suitable item to Barter with."))
		return FALSE
	var/obj/item/I = targets[1]
	if(I.sellprice < 2 || isnull(I.sellprice))
		revert_cast()
		to_chat(user, span_warning("This thing is worthless."))
		return FALSE
	if(I.GetComponent(/datum/component/martyrweapon))
		to_chat(user, span_danger("My divine energies recoil from the relic! It resists!"))
		return TRUE	//why did you try this? Go on full CD, bad.
	if(I.toggle_state)	//-some- reskinned triumph kit weapons / -some- donor weapons, active martyr weapon
		revert_cast()
		to_chat(user, span_warning("This thing has been glamoured or changed -- its value is too unclear."))
		return FALSE
	if(I.GetComponent(/datum/component/holster))
		var/datum/component/holster/SC = I.GetComponent(/datum/component/holster)
		if(SC.sheathed)
			revert_cast()
			to_chat(user, span_warning("I should empty it, first."))
			return FALSE
	if((istype(I, /obj/item/rogueweapon) || istype(I, /obj/item/clothing)))
		if(!(I.type in barter_whitelist))
			revert_cast()
			to_chat(user, span_warning("Weapons and clothing do not appease my Patron, He is not lacking in fashion."))
			return FALSE

	var/delay = 1 SECONDS
	delay += round((I.sellprice / 50) SECONDS)
	if(I.Adjacent(user))
		if(do_after(user, delay))
			if(I.Adjacent(user))	//We make sure it didnt' get yoinked after the delay.
				var/ratio = 0.4 + ((user.get_skill_level(associated_skill)) * 0.05)
				var/mammonreward = round(I.sellprice * ratio)
				var/turf/T = get_turf(I)
				new /obj/effect/temp_visual/barter_fx(T)
				addtimer(CALLBACK(src, PROC_REF(process_barter), mammonreward, user, T), 0.3 SECONDS)	//fluffy delay to make it sync up with the barter_fx.
				if(I.GetComponent(/datum/component/storage))
					var/datum/component/storage/ST = I.GetComponent(/datum/component/storage)
					if(!ST.do_quick_empty(T))
						revert_cast()
						return FALSE
				qdel(I)

/obj/effect/proc_holder/spell/invoked/barter/proc/process_barter(mammon, mob/user, turf/target_turf)
	playsound(target_turf, 'sound/effects/matth_barter.ogg', 100, TRUE)
	budget2change(mammon, user, putinhands = FALSE, custom_turf = target_turf)

//T3 COUNT WEALTH, HURT TARGET/APPLY EFFECTS BASED ON AMOUNT OF WEALTH. AT 500+, OLD STYLE CHURNS THE TARGET.

/obj/effect/proc_holder/spell/invoked/matthios_churn
	name = "Churn Wealthy"
	desc = "Attacks the target by weight of their greed, dealing increased damage and effects depending on how wealthy they are."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "churnwealthy"
	miracle = TRUE
	devotion_cost = 100 //Big commitment
	associated_skill = /datum/skill/magic/holy
	chargedloop = /datum/looping_sound/invokeascendant
	chargedrain = 0
	chargetime = 5 SECONDS
	releasedrain = 90
	no_early_release = TRUE
	antimagic_allowed = TRUE
	movement_interrupt = FALSE
	recharge_time = 5 MINUTES //This probably should not be on low cooldown
	range = 4

/obj/effect/proc_holder/spell/invoked/matthios_churn/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/mob/living/carbon/human/target = targets[1]

		if(user.z != target.z) //Stopping no-interaction snipes
			to_chat(user, "<font color='yellow'>The Free-God compels me to face [target] on level ground before I transact.</font>")
			revert_cast()
			return
		if(user == target)
			to_chat(user,"<font color='yellow'>Why would I want to Churn MYSELF? I am not that insane.</font>")
			revert_cast()
			return
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] resists the weight of their greed!"))
			return TRUE
		var/mammonsonperson = get_mammons_in_atom(target)
		var/mammonsinbank = SStreasury.bank_accounts[target]
		var/totalvalue = mammonsinbank + mammonsonperson
		if(HAS_TRAIT(target, TRAIT_NOBLE))
			totalvalue += 101 // We're ALWAYS going to do a medium level smite minimum to nobles.
		if(HAS_TRAIT(target, TRAIT_FREEMAN))
			totalvalue -= 50 // We do little bit less damage to other Matthiosites
		switch(totalvalue)
			if(0 to 10)
				to_chat(user, "<font color='yellow'>[target] one has no wealth to hold against them.</font>")
				revert_cast()
				return FALSE
			if(11 to 30)
				user.emote("waves their hand in front of them.")
				target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
				target.adjustFireLoss(30)
				playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			if(31 to 60)
				user.emote("waves their hand in front of them.")
				target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
				target.adjustFireLoss(60)
				playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			if(61 to 100)
				user.emote("waves their hand in front of them.")
				target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
				target.adjustFireLoss(80)
				target.Stun(20)
				playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			if(101 to 200)
				user.emote("makes an obscene gesture towards [target]!") 	//if wizards can flip you the bird to set you on fire, matthios can, too.
				target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth tearing at my soul!"))
				target.adjustFireLoss(100)
				target.adjust_fire_stacks(7, /datum/status_effect/fire_handler/fire_stacks/divine)
				target.Stun(20)
				target.ignite_mob()
				playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			if(201 to 500)
				user.emote("makes an obscene gesture towards [target]!")
				target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth tearing at my soul!"))
				target.adjustFireLoss(120)
				target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
				target.ignite_mob()
				target.Stun(40)
				playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
			if(500 to 2500)
				target.visible_message(span_danger("[target] is smited with holy light!"), span_userdanger("I feel the weight of my wealth rend my soul apart!"))
				user.emote("makes an obscene gesture towards [target] and screams at the top of their lungs!")
				target.Stun(60)
				target.emote("agony")
				target.adjustFireLoss(140)
				target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
				target.ignite_mob()
				playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
				explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			if(2501 to 9999999) //THE POWER OF MY STAND: 'EXPLODE AND DIE INSTANTLY'
				target.visible_message(span_danger("[target]'s skin begins to SLOUGH AND BURN HORRIFICALLY, glowing like molten metal!"), span_userdanger("MY LIMBS BURN IN AGONY..."))
				user.emote("makes an obscene gesture towards [target] and screams at the top of their lungs! An ear-splitting drone fills the air!")
				target.Stun(80)
				target.emote("agony")
				target.adjustFireLoss(50)
				target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
				target.ignite_mob()
				playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
				explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
				sleep(80)

				target.visible_message(span_danger("[target]'s limbs REND into coin and gem!"), span_userdanger("WEALTH. POWER. THE FINAL SIGHT UPON MYNE EYE IS A DRAGON'S MAW TEARING ME IN TWAIN. MY ENTRAILS ARE OF GOLD AND SILVER."))  		//this one's actually pretty good. i like this
				playsound(user, 'sound/magic/churn.ogg', 100, TRUE)
				playsound(user, 'sound/magic/whiteflame.ogg', 100, TRUE)
				explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
				new /obj/item/roguecoin/silver/pile(target.loc)
				new /obj/item/roguecoin/gold/pile(target.loc)
				new /obj/item/roguegem/random(target.loc)
				new /obj/item/roguegem/random(target.loc)

				var/list/possible_limbs = list()
				for(var/zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
					var/obj/item/bodypart/limb = target.get_bodypart(zone)
					if(limb)
						possible_limbs += limb
					var/limbs_to_gib = min(rand(1, 4), possible_limbs.len)
					for(var/i in 1 to limbs_to_gib)
						var/obj/item/bodypart/selected_limb = pick(possible_limbs)
						possible_limbs -= selected_limb
						if(selected_limb?.drop_limb())
							var/turf/limb_turf = get_turf(selected_limb) || get_turf(target) || target.drop_location()
							if(limb_turf)
								new /obj/effect/decal/cleanable/blood/gibs/limb(limb_turf)

				target.death()
		return TRUE


#undef EQUALIZED_GLOW
