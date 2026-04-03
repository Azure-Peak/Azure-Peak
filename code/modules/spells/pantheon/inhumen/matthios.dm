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
	color = "#fce517" // we golden

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

#undef EQUALIZED_GLOW

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

/datum/action/cooldown/spell/freemans_tools
	button_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	button_icon_state = "lockpick"
	name = "Freeman's Tools"
	desc = "A simple prayer to the free-god that forms into an instrument for liberation."
	associated_skill = /datum/skill/magic/holy
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP
	charge_required = FALSE
	cooldown_time = 0
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/list/options = list(
		"Pouch of Bribery" = list(
			path = /obj/item/storage/belt/rogue/pouch/coins/matthios,
			m_cooldown = 60 SECONDS,
			m_rank = SKILL_LEVEL_EXPERT,
			lines = list("Coin begets coin!", "Matthios, grant me a sliver of thy wealth!", "Wealth through will, as He demands!")
		),
		"Pocket Sand" = list(
			path = /obj/item/impact_grenade/pocketsand,
			m_cooldown = 30 SECONDS,
			m_rank = SKILL_LEVEL_NOVICE,
			lines = list("Dust to blind thee!", "A handful of freedom!", "A gift for thee!")
		),
		"Gilded Lockpick" = list(
			path = /obj/item/melee/touch_attack/lesserknock/matthios,
			m_cooldown = 5 SECONDS,
			m_rank = SKILL_LEVEL_APPRENTICE,
			lines = list("#No locks shall bar the free.", "#Thine tool shall bring liberation.", "#Matthios, shatter my locks!")
		),
		"Gilded Dexterous Gloves" = list(
			path = /obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios,
			m_cooldown = 5 MINUTES,
			m_rank = SKILL_LEVEL_EXPERT,
			lines = list("Hands of trade, be swift.", "Let fingers dance for thy amusement.", "Dexterity bought in faith.")
		),
		"Gilded Muffled Boots" = list(
			path = /obj/item/clothing/shoes/roguetown/boots/muffle_matthios,
			m_cooldown = 5 MINUTES,
			m_rank = SKILL_LEVEL_JOURNEYMAN,
			lines = list("Steps unheard, as I walk in thy shadow.", "Silent as coin slipping, for thy hoard.", "No sound, no chain, no better wisdom, O' Lord.")
		)

	)

	var/list/item_cooldowns = list()

/datum/action/cooldown/spell/freemans_tools/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/skill = H.get_skill_level(associated_skill)

	var/list/valid = list()
	for(var/name in options)
		var/list/entry = options[name]
		if(!islist(entry))
			continue
		if(skill >= entry["m_rank"])
			valid[name] = entry

	if(!valid.len)
		return FALSE

	var/choice = tgui_input_list(H, "Choose your tool", "Freeman's Tools", valid)
	if(!choice)
		return FALSE

	var/list/entry = valid[choice]
	var/item_path = entry["path"]
	var/m_cd = entry["m_cooldown"]
	var/list/lines = entry["lines"]

	if(!item_path)
		return FALSE

	if(item_cooldowns[choice] && world.time < item_cooldowns[choice])
		to_chat(H, span_warning("[choice] is on cooldown for [round((item_cooldowns[choice] - world.time)/10, 1)] seconds."))
		return FALSE

	var/obj/item/I = new item_path(H.drop_location())
	if(!I)
		return FALSE

	H.put_in_hands(I)

	if(lines && lines.len)
		H.say(pick(lines))

	item_cooldowns[choice] = world.time + m_cd

	return TRUE

/obj/item/melee/touch_attack/lesserknock/matthios
	name = "Gilded Lockpick"
	desc = "A golden, glowing lockpick that appears to be held together by the truth of Matthios. To dispel it, simply use it on anything that isn't a door."
	catchphrase = null
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lockpick"
	color = "#eeff00" // we golden now, bij
	picklvl = 1.1 // 10% better than normal picks!
	max_integrity = 99
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF

/obj/item/melee/touch_attack/lesserknock/attack_self()
	qdel(src)

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios
	name = "gilded fingerless gloves"
	desc = "Those who grasp at Fyre, are bount to be burned."
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fce517" // we golden

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_HANDS && HAS_TRAIT(user, TRAIT_FREEMAN))
		to_chat(user, span_info("Like Him, my hands ready to grasp the impossible."))
		ADD_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthiosboon")

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.gloves == src)
		to_chat(user, span_info("Once again, these hands are supplicant."))
		REMOVE_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthiosboon")

/obj/item/roguecoin/gold/matthios
	name = "zenar"
	desc = "A gold coin bearing the symbol of the Taurus and the pre-kingdom psycross. These were in the best condition of the provincial gold mints, the rest were melted down."
	sellprice = 0 // honk, though knowing these powergamers, the meme won't last forever, worst case this skill's worth is to create free pouches :'(

/obj/item/roguecoin/gold/matthios/examine(mob/user)
	. = ..()
	if(prob(30)) // this may be remove based on how much people troll with it, but for now
		if(HAS_TRAIT(user, TRAIT_SEEPRICES))
			. += span_warning("Is this true...?")
		else if(HAS_TRAIT(user, TRAIT_SEEPRICES_SHITTY))
			. += span_warning("Is this TRVE??")

/obj/item/roguecoin/gold/matthios/pile/Initialize()
	. = ..()
	set_quantity(rand(4,19))

/obj/item/storage/belt/rogue/pouch/coins/matthios
	name = "pouch"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt."
	preload = TRUE

/obj/item/storage/belt/rogue/pouch/coins/matthios/get_types_to_preload()
	var/list/to_preload = list()
	to_preload += /obj/item/roguecoin/gold/matthios/pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/matthios/PopulateContents()
	. = ..()

	for(var/i in 1 to 4)
		var/obj/item/roguecoin/gold/matthios/pile/H = SSwardrobe.provide_type(/obj/item/roguecoin/gold/matthios/pile, loc)
		if(istype(H))
			H.set_quantity(20) // full stacks
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				SSwardrobe.recycle_object(H)
				break

/obj/item/impact_grenade/pocketsand
	name = "pocket sand"
	desc = "A fistful of fine, irritating sand. Guaranteed to be clawing at the eyes of the unwise."
	icon_state = "clod1"
	icon = 'icons/roguetown/items/natural.dmi'

/obj/item/impact_grenade/pocketsand/explodes()
	STOP_PROCESSING(SSfastprocess, src)
	var/turf/T = get_turf(src)
	if(T)
		for(var/mob/living/target in range(1, T))
			if(!target.mind || istype(target, /mob/living/simple_animal))
				target.adjustBruteLoss(5)
				target.Stun(5)
			if(iscarbon(target))
				target.Stun(1 SECONDS)
				target.blur_eyes(5)
				target.adjust_blurriness(10)
				target.blind_eyes(1)
			target.visible_message(
				span_warning("[target] is blasted with a cloud of sand!"),
				span_warning("Sand gets into my eyes! I can't see!")
			)
			target.emote("pain")
			target.apply_status_effect(/datum/status_effect/debuff/clickcd, 3 SECONDS)
		qdel(src)

#define MAMMON_FILTER "mammon_glow"

/datum/action/cooldown/spell/mammonite
	name = "Mammonite"
	desc = "Invoke Matthios's name and invest 50 to 200 mammon of your own hoard into your next strike. The power of your offering mirrors the wealth spent, drawing even from your bank. Every coin fuels your glory.<br><br>(Deals 2x damage to NPCs.)"
	button_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	button_icon_state = "mammonite"
	spell_color = "#d4af37"
	glow_intensity = GLOW_INTENSITY_MEDIUM
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_NONE
	primary_resource_cost = 0
	invocation_type = "shout"
	charge_required = FALSE
	cooldown_time = 45 SECONDS
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	var/min_mammon = 50
	var/max_mammon = 200

/datum/action/cooldown/spell/mammonite/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/H = owner

	if(!(H in SStreasury.bank_accounts))
		SStreasury.bank_accounts[H] = 0

	var/bank = SStreasury.bank_accounts[H]
	var/onhand = get_mammons_in_atom(H)
	var/total = bank + onhand

	if(total < min_mammon)
		if(feedback)
			to_chat(H, span_warning("I lack the wealth to invoke Matthios' favor..."))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/mammonite/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(H.has_status_effect(/datum/status_effect/buff/mammonite))
		to_chat(H, span_warning("Matthios' truth already lays claim to my next strike."))
		return FALSE

	if(!(H in SStreasury.bank_accounts))
		SStreasury.bank_accounts[H] = 0

	var/bank = SStreasury.bank_accounts[H]
	var/onhand = get_mammons_in_atom(H)
	var/total = bank + onhand

	if(total < min_mammon)
		to_chat(H, span_warning("I lack the wealth to invoke Matthios' favor..."))
		return FALSE

	var/mammon_used = clamp(total, min_mammon, max_mammon)

	var/list/invocations = list(
		"Gold to glory, Matthios guide my hand!",
		"Wealth be spent, and power be gained!",
		"My hoard bleeds for strength, in His name!",
		"Matthios! A king's ransom for a single blow!",
	)
	H.say(pick(invocations), forced = invocation_type)

	var/remaining = mammon_used

	var/from_inventory = 0
	var/from_bank = 0

	var/drained_onhand = min(onhand, remaining)
	if(drained_onhand > 0)
		from_inventory = remove_mammons_from_atom(H, drained_onhand)
		remaining -= from_inventory

	if(remaining > 0)
		from_bank = min(remaining, SStreasury.bank_accounts[H])
		SStreasury.bank_accounts[H] = max(0, SStreasury.bank_accounts[H] - from_bank)
		SStreasury.log_to_steward("-[from_bank] suddenly disappeared. Is this true?")
		remaining -= from_bank

	var/datum/status_effect/buff/mammonite/E = H.apply_status_effect(/datum/status_effect/buff/mammonite)
	if(E)
		E.bonus_damage = round(mammon_used * 1.5) // jakk here

	var/source_text = ""

	if(from_inventory > 0 && from_bank > 0)
		source_text = "MATTHIOS claims [from_inventory] from my possessions, [from_bank] from their wretched Treasury!"
	else if(from_inventory > 0)
		source_text = "MATTHIOS, claim [from_inventory] from my possessions!"
	else if(from_bank > 0)
		source_text = "MATTHIOS, [from_bank] from their wretched Treasury!"

	H.visible_message(
		span_danger("[H]'s weapon gleams with a greedy golden light!"),
		span_notice("I invest [mammon_used] mammon into my next strike. ([source_text])")
	)

	playsound(get_turf(H), 'sound/magic/antimagic.ogg', 60, TRUE)

	return TRUE

/proc/remove_mammons_from_atom(atom/A, amount)
	if(!A || amount <= 0)
		return 0

	var/remaining = amount
	var/list/coins = list()

	collect_coins_recursive(A, coins)

	coins = sortTim(coins, /proc/cmp_coin_value_desc)

	for(var/obj/item/roguecoin/C in coins)
		if(remaining <= 0)
			break

		if(QDELETED(C))
			continue

		var/value_per = C.sellprice
		if(value_per <= 0)
			continue

		var/max_value = value_per * C.quantity

		if(max_value <= remaining)
			remaining -= max_value
			qdel(C)
		else
			var/coins_to_remove = ceil(remaining / value_per)
			coins_to_remove = min(coins_to_remove, C.quantity)

			C.set_quantity(C.quantity - coins_to_remove)

			if(C.quantity <= 0)
				qdel(C)

			remaining = 0

	return amount - remaining

/proc/collect_coins_recursive(atom/A, list/out)
	for(var/atom/movable/AM in A.contents)
		if(istype(AM, /obj/item/roguecoin))
			out += AM
		if(AM.contents && length(AM.contents))
			collect_coins_recursive(AM, out)

/proc/cmp_coin_value_desc(obj/item/roguecoin/A, obj/item/roguecoin/B)
	return B.sellprice - A.sellprice

/atom/movable/screen/alert/status_effect/buff/mammonite
	name = "Mammonite Strike"
	desc = "My next strike is empowered by wealth."
	icon_state = "buff"

/datum/status_effect/buff/mammonite
	id = "mammonite"
	alert_type = /atom/movable/screen/alert/status_effect/buff/mammonite
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/bonus_damage = 0

/datum/status_effect/buff/mammonite/on_apply()
	. = ..()

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))

	owner.add_filter(MAMMON_FILTER, 2, list(
		"type" = "outline",
		"color" = "#d4af37",
		"alpha" = 175,
		"size" = 2
	))

/datum/status_effect/buff/mammonite/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_HUMAN_MELEE_UNARMED_ATTACK))
	owner.remove_filter(MAMMON_FILTER)
	. = ..()

/datum/status_effect/buff/mammonite/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(source != owner || !isliving(target) || target.stat == DEAD)
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_attack), target, weapon)
	return COMPONENT_ITEM_NO_ATTACK

/datum/status_effect/buff/mammonite/proc/on_unarmed_attack(mob/living/source, atom/target, proximity) 
	SIGNAL_HANDLER 
	if(!isliving(target) || target == owner) 
		return 
	var/mob/living/L = target 
	if(L.stat == DEAD) 
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_attack), L, null)
	return COMPONENT_HAND_NO_ATTACK

/datum/status_effect/buff/mammonite/proc/resolve_attack(mob/living/target, obj/item/weapon)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target))
		return
	var/damage = calculate_damage()
	var/npc_mult = (!target.mind) ? 2 : 1

	arcyne_strike(
		owner,
		target,
		weapon,
		damage,
		owner.zone_selected,
		BCLASS_SMASH,
		0,
		"Mammonite",
		FALSE,
		FALSE,
		FALSE,
		BRUTE,
		npc_mult,
		1
	)
	owner.visible_message(
		span_danger("[owner]'s strike crashes down with the weight of greed!"),
		span_notice("My investment pays off in full!")
	)
	mammon_coin_burst(get_turf(target))
	playsound(get_turf(target), 'sound/combat/hits/burn (2).ogg', 60, TRUE)

	consume()

/datum/status_effect/buff/mammonite/proc/calculate_damage()
	return bonus_damage

/datum/status_effect/buff/mammonite/proc/consume()
	if(owner)
		playsound(get_turf(owner), 'sound/magic/antimagic.ogg', 20, TRUE)
		playsound(get_turf(owner), 'sound/misc/coininsert.ogg', 40, TRUE)
		playsound(get_turf(owner), 'sound/effects/matth_barter.ogg', 40, TRUE)
		owner.remove_status_effect(/datum/status_effect/buff/mammonite)

/proc/mammon_coin_burst(turf/T)
	if(!T)
		return
	for(var/i = 3 to 8)
		var/obj/effect/temp_visual/coinburst/C = new(T)
		C.pixel_x = rand(-8, 8)
		C.pixel_y = rand(-8, 8)

/obj/effect/temp_visual/coinburst
	icon = 'icons/roguetown/items/valuable.dmi'
	icon_state = "g1"
	layer = ABOVE_MOB_LAYER
	duration = 6

/obj/effect/temp_visual/coinburst/Initialize()
	. = ..()

	var/matrix/M = matrix()
	M.Scale(0.25, 0.25) // 25% size

	transform = M

	animate(src,
		pixel_x = pixel_x + rand(-16,16),
		pixel_y = pixel_y + rand(8,20),
		alpha = 0,
		time = duration,
		easing = EASE_OUT
	)

#define SKULDUGGERY_FILTER "skulduggery"

/obj/effect/proc_holder/spell/self/skulduggery
	name = "Skulduggery"
	desc = "Tap into the boundless prowess and cunning of the Free God, granting you a fleeting moment of foresight to stay one step ahead of your foes.<br><br><i>They say that He once personally guided the infamous 'Grand Liege', Cobra, in the 'Liberation of 1513'.</i>"
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "liberate"
	recharge_time = 5 MINUTES
	invocations = list("Free God, I walk in your shadow!","...Neck chop, backstab...","Double time, Matthios!","Remember the Large Liege!","...Apply pressure, palm strike...","The Matthiosans Sans Frontieres still lyves!","...Punch, punch, kick...","For Cobra and the Free God!")
	invocation_type = "shout"
	sound = 'sound/magic/haste.ogg'
	releasedrain = 15
	miracle = TRUE
	devotion_cost = 40
	antimagic_allowed = FALSE
	range = 0

	var/static/list/purged_effects = list(
		/datum/status_effect/incapacitating/immobilized,
		/datum/status_effect/incapacitating/knockdown
	)

/obj/effect/proc_holder/spell/self/skulduggery/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user
	H.emote("laugh")
	if(H.resting)
		H.set_resting(FALSE, FALSE)

	for(var/effect in purged_effects)
		H.remove_status_effect(effect)

	H.apply_status_effect(/datum/status_effect/buff/skulduggery)

	var/is_grabbed = FALSE

	if(length(H.grabbedby))
		for(var/obj/item/grabbing/G in H.grabbedby)
			var/mob/living/grabber = G.loc
			if(grabber && grabber != H)
				is_grabbed = TRUE
				qdel(G)

				grabber.Knockdown(2 SECONDS)
				grabber.OffBalance(2 SECONDS)
				grabber.adjustBruteLoss(5)

				grabber.visible_message(
					span_warning("[H] twists free from [grabber]'s grasp!"),
					span_danger("[H] slips free and throws me off-balance!"))

				playsound(grabber, 'sound/combat/riposte.ogg', 100, TRUE)

	if(H.pulling)
		var/mob/living/L = H.pulling
		H.stop_pulling()

		if(isliving(L))
			is_grabbed = TRUE

			L.Knockdown(1.5 SECONDS)
			L.OffBalance(2 SECONDS)

			L.visible_message(
				span_warning("[H] tears free from [L]'s hold!"),
				span_danger("[H] breaks free from my grip!"))

			playsound(L, 'sound/combat/riposte.ogg', 100, TRUE)

	if(is_grabbed)
		H.visible_message(
			span_warning("[H] twists free with a sudden close-quarters maneuver!"),
			span_notice("I break free and seize the initiative."))

		playsound(H, 'sound/combat/riposte.ogg', 100, TRUE)

	else
		H.visible_message(
			span_notice("[H] blurs, moving with uncanny foresight and dexterity."),
			span_notice("I remember the basics of S.K.D..."))

	return TRUE

/atom/movable/screen/alert/status_effect/buff/skulduggery
	name = "Skulduggery"
	desc = "Remembering the basics of S.K.D.! You're now always one step ahead."
	icon_state = "buff"
	alert_group = ALERT_BUFF

/datum/status_effect/buff/skulduggery
	id = "skulduggery"
	alert_type = /atom/movable/screen/alert/status_effect/buff/skulduggery
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 1 SECONDS // This will be sextended by Tempo or Equalize
	var/afterimage_active = FALSE
	var/outline_colour = "#ffeb7a"
	var/CQC_stacks = 0
	var/CQC_max = 6 // adjust this value if things are happening too fast or too long!
	var/maneuver_level = 0
	var/pressure = 0
	var/is_ready = FALSE

/datum/status_effect/buff/skulduggery/tick()
	. = ..()
	if(!owner) 
		return
	// Check for any active Tempo or Equalized buffs
	if(owner.stat != CONSCIOUS || owner.has_status_effect(STATUS_EFFECT_KNOCKDOWN))
		owner.remove_status_effect(/datum/status_effect/buff/skulduggery)
		return

	if(owner.has_status_effect(/datum/status_effect/buff/tempo_one) || owner.has_status_effect(/datum/status_effect/buff/tempo_two) || owner.has_status_effect(/datum/status_effect/buff/tempo_three) || owner.has_status_effect(/datum/status_effect/buff/equalizebuff))
		owner.apply_status_effect(/datum/status_effect/buff/skulduggery)
		return

	if((pressure < maneuver_level) && (maneuver_level < 10))
		pressure = maneuver_level
		owner.apply_status_effect(/datum/status_effect/buff/skulduggery)

/datum/status_effect/buff/skulduggery/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_weapon_attack))
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))
	ADD_TRAIT(owner, TRAIT_DODGEEXPERT, "skulduggery")
	ADD_TRAIT(owner, TRAIT_GRABIMMUNE, "skulduggery")

	var/holyskill = owner.get_skill_level(/datum/skill/magic/holy)
	duration = (10 SECONDS) + (holyskill * 3 SECONDS)

	CQC_stacks = 0
	maneuver_level = 0

	owner.add_filter(SKULDUGGERY_FILTER, 2, list(
		"type" = "outline",
		"color" = outline_colour,
		"alpha" = 55,
		"size" = 1
	))

	owner.AddComponent(/datum/component/after_image)
	afterimage_active = TRUE

/datum/status_effect/buff/skulduggery/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK)
	REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, "skulduggery")
	REMOVE_TRAIT(owner, TRAIT_GRABIMMUNE, "skulduggery")

	if(afterimage_active)
		var/datum/component/after_image/A = owner.GetComponent(/datum/component/after_image)
		if(A)
			qdel(A)

	afterimage_active = FALSE

	owner.remove_filter(SKULDUGGERY_FILTER)

/datum/status_effect/buff/skulduggery/proc/on_weapon_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(source != owner || !isliving(target) || target.stat == DEAD)
		return
	
	build_stack(target)
	if(prob(50)) // sometimes weapons let you build it faster, to encourage the 1h weapon usage
		build_stack(target)
	var/back_dir = turn(target.dir, 180)
	if(get_dir(target, owner) != back_dir)
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_weapon_backstab), target, weapon)
	return COMPONENT_ITEM_NO_DEFENSE //only ignore defenses on back!!!

/datum/status_effect/buff/skulduggery/proc/on_unarmed_attack(mob/living/source, atom/target, proximity)
	SIGNAL_HANDLER
	if(source != owner || !isliving(target))
		return

	var/mob/living/L = target

	build_stack(L)

	var/back_dir = turn(L.dir, 180)
	if(get_dir(L, owner) != back_dir)
		return // the following is only on back!!
	ADD_TRAIT(owner, TRAIT_EMPOWERED_UNARMED, "trve!")
	INVOKE_ASYNC(src, PROC_REF(resolve_fist_backstab), L)

/datum/status_effect/buff/skulduggery/proc/build_stack(mob/living/target)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target))
		return

	var/mob/living/H = owner
	var/obj/item/I = H.get_active_held_item()
	var/is_unarmed = !I
	var/is_cqc = is_unarmed || is_cqc_weapon(I)
	var/is_punching = H.used_intent.type == INTENT_HARM

	if((is_unarmed && is_punching) || is_cqc)
		if(CQC_stacks >= CQC_max)
			CQC_stacks = 0
			maneuver_level++
			INVOKE_ASYNC(src, PROC_REF(resolve_CQC_maneuver), target)
			return
		if(is_unarmed && is_punching)
			CQC_stacks += 2
		else
			CQC_stacks += 1

	else
		if(CQC_stacks >= CQC_max)
			is_ready = TRUE
			H.balloon_alert_to_viewers("SKD Ready!" , "SKD ready!", y_offset = 10)
			return
		CQC_stacks += 1

	if(CQC_stacks > CQC_max)
		CQC_stacks = CQC_max
		return

/datum/status_effect/buff/skulduggery/proc/is_cqc_weapon(obj/item/I)
	if(!I)
		return FALSE

	return istype(I, /obj/item/rogueweapon/woodstaff/quarterstaff) || istype(I, /obj/item/rogueweapon/huntingknife/idagger)	|| istype(I, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow)

/datum/status_effect/buff/skulduggery/proc/resolve_CQC_maneuver(mob/living/target)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target))
		return

	var/mob/living/carbon/human/HT = target
	var/mob/living/carbon/human/HU = owner
	var/fatiguemod = 4

	if(ishuman(HT))
		var/targetac = HT.highest_ac_worn()
		switch(targetac)
			if(ARMOR_CLASS_NONE)
				fatiguemod = 5
			if(ARMOR_CLASS_LIGHT, ARMOR_CLASS_MEDIUM)
				fatiguemod = 4
			if(ARMOR_CLASS_HEAVY)
				fatiguemod = 3

	if(HT.has_status_effect(/datum/status_effect/buff/clash/limbguard))
		HT.bad_guard()
	playsound(HU, 'sound/combat/ground_smash_start.ogg', 100, TRUE)
	switch(maneuver_level)
		if(1)
			HT.Immobilize(0.5 SECONDS)
			HU.do_attack_animation(HT, ATTACK_EFFECT_PUNCH, null, item_animation_override = ATTACK_ANIMATION_THRUST)
			HT.Slowdown(3)
			HT.stamina_add(HT.max_stamina / fatiguemod)
			HT.apply_status_effect(/datum/status_effect/incapacitating/off_balanced, 3 SECONDS)
			HT.emote("huh")
			HU.changeNext_move(0.1 SECONDS, override = TRUE)
			HU.visible_message(
				span_warning("[HU] slips inside [HT]'s guard, disrupting their footing!"),
				span_notice("I step inside [HT]'s guard, breaking their rhythm."))
			HT.visible_message(
				span_warning("[HT] stumbles as [HU] disrupts their stance!"),
				span_danger("My footing falters-- they're inside my guard!"))
			playsound(HT, 'sound/combat/hits/punch/punch (1).ogg', 80, TRUE)
			HU.balloon_alert_to_viewers(message = "SKD!! (1)", self_message = "SKD!! (1)", y_offset = 10)
		if(2)
			HT.OffBalance(2 SECONDS)
			HU.do_attack_animation(HT, ATTACK_EFFECT_SMASH, null, item_animation_override = ATTACK_ANIMATION_BONK)
			HT.Immobilize(1.5 SECONDS)
			HT.Slowdown(4)
			HT.stamina_add(HT.max_stamina / fatiguemod)
			HU.visible_message(
				span_warning("[HU] overwhelms [HT]'s footing, forcing them off-balance!"),
				span_notice("Their balance is collapsing."))
			HT.visible_message(
				span_warning("[HT] reels as [HU] batters their footing!"),
				span_danger("My balance is breaking!"))
			HT.emote("gasp")
			playsound(HT, 'sound/combat/riposte.ogg', 90, TRUE)
			playsound(HT, 'sound/combat/hits/punch/punch (1).ogg', 80, TRUE)
			HU.balloon_alert_to_viewers(message = "SKD!! (2)", self_message = "SKD!! (2)", y_offset = 10)
		if(3)
			HT.Knockdown(2 SECONDS)
			HT.OffBalance(3 SECONDS)
			HU.do_attack_animation(HT, ATTACK_EFFECT_KICK, null, item_animation_override = ATTACK_ANIMATION_SWIPE)
			HT.apply_status_effect(/datum/status_effect/debuff/exposed, 5 SECONDS)
			HT.stamina_add(HT.max_stamina / fatiguemod)
			HU.visible_message(
				span_danger("[HU] sweeps [HT]'s footing and tears open their defenses!"),
				span_notice("Their guard is open!"))
			HT.visible_message(
				span_danger("[HT] is swept off their footing by [HU]!"),
				span_danger("My guard is broken!"))
			HT.emote("pain")
			playsound(HT, 'sound/combat/hits/punch/punch (2).ogg', 100, TRUE)
			HU.balloon_alert_to_viewers(message = "SKD!! (3)", self_message = "SKD!! (3)", y_offset = 10)
		if(4)
			HT.Stun(2 SECONDS)
			HT.Knockdown(3 SECONDS)
			HT.OffBalance(4 SECONDS)
			HT.apply_status_effect(/datum/status_effect/debuff/exposed, 8 SECONDS)
			HU.visible_message(
				span_danger("[HU] dismantles [HT] with a devastating close-quarters maneuver!"),
				span_notice("Total control. Their defense collapses."))

			HT.visible_message(
				span_danger("[HT] is completely dismantled by [HU]'s close-quarters maneuver!"),
				span_danger("I can't recover-- they've taken control!"))

			HT.emote("pain")
			playsound(HT, 'sound/combat/riposte.ogg', 100, TRUE)
			playsound(HT, 'sound/combat/hits/punch/punch (3).ogg', 100, TRUE)
			HT.adjustBruteLoss(10)
			HU.do_attack_animation(HT, ATTACK_EFFECT_SMASH, null)
			sleep(2)
			playsound(HT, 'sound/combat/hits/punch/punch (1).ogg', 100, TRUE)
			HT.adjustBruteLoss(10)
			HU.do_attack_animation(HT, ATTACK_EFFECT_KICK, null)
			sleep(3)
			playsound(HT, 'sound/combat/hits/punch/punch (2).ogg', 100, TRUE)
			HT.adjustBruteLoss(10)
			HU.do_attack_animation(HT, ATTACK_EFFECT_PUNCH, null)
			HT.emote("pain")
			HU.balloon_alert_to_viewers(message = "SKD!! (Max)", self_message = "SKD!! (Max)", y_offset = 10)
		if(5 to INFINITY)
			HU.balloon_alert_to_viewers(message = "SKD!! (Consecutive)", self_message = "SKD!! (Consecutive)", y_offset = 10)
			HT.emote("pain")
			HU.visible_message(
				span_danger("[HU] overwhelms [HT] with a barrage of consecutive close-quarters maneuvers!"),
				span_notice("Keep the pressure! They'll fold soon."))
			playsound(HT, 'sound/combat/riposte.ogg', 100, TRUE)
			playsound(HT, 'sound/combat/hits/punch/punch (3).ogg', 100, TRUE)
			HU.do_attack_animation(HT, ATTACK_EFFECT_PUNCH, null)
			HT.adjustBruteLoss(5)
			HT.stamina_add(HT.max_stamina / 4)
			sleep(3)
			playsound(HT, 'sound/combat/hits/punch/punch (1).ogg', 100, TRUE)
			HU.do_attack_animation(HT, ATTACK_EFFECT_PUNCH, null)
			HT.adjustBruteLoss(5)
			sleep(3)
			playsound(HT, 'sound/combat/hits/punch/punch (2).ogg', 100, TRUE)
			HU.do_attack_animation(HT, ATTACK_EFFECT_KICK, null)
			HT.adjustBruteLoss(5)	

	if(HT.pulling)
		HT.stop_pulling()

		HU.visible_message(
			span_warning("[HU] twists free from [HT]'s grasp!"),
			span_notice("I break free."))

		HT.visible_message(
			span_warning("[HT]'s grip is broken by [HU]!"),
			span_danger("My grip is broken!"))

		HU.OffBalance(1 SECONDS)
		HT.OffBalance(2 SECONDS)

		playsound(HU, 'sound/combat/riposte.ogg', 100, TRUE)
		HU.balloon_alert_to_viewers(message = "SKD!! (Grab)", self_message = "SKD!! (Grab)")

	is_ready = FALSE

/datum/status_effect/buff/skulduggery/proc/resolve_weapon_backstab(mob/living/target, obj/item/weapon)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target))
		return
	var/damage = weapon.force * 2
	arcyne_strike(
		owner,
		target,
		weapon,
		damage,
		owner.zone_selected,
		FALSE,
		100,
		"Backstab",
		FALSE,
		TRUE,
		FALSE,
		BRUTE,
		1,
		1
	)

	target.visible_message(
		span_danger("[owner] slips behind [target] and attacks with ruthless precision!")
	)
	owner.balloon_alert_to_viewers(message = "Backstab!!", self_message = "Backstab!!")
	playsound(owner, 'sound/combat/newstuck.ogg', 100, TRUE)

/datum/status_effect/buff/skulduggery/proc/resolve_fist_backstab(mob/living/target)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target))
		return
	REMOVE_TRAIT(owner, TRAIT_EMPOWERED_UNARMED, "trve!")
	arcyne_strike(
		owner,
		target,
		null,
		25,
		BODY_ZONE_PRECISE_NECK,
		BCLASS_SMASH,
		100,
		"Neck Chop",
		FALSE,
		TRUE,
		FALSE,
		BRUTE,
		1,
		1
	)

	target.visible_message(
		span_danger("[owner] slips behind [target] and delivers a precise neck chop!")
	)
	owner.balloon_alert_to_viewers(message = "Backstab!!", self_message = "Backstab!!")
	playsound(owner, 'sound/combat/hits/punch/punch (1).ogg', 100, TRUE)

#undef SKULDUGGERY_FILTER
