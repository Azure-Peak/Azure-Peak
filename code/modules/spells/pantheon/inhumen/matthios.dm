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

/obj/item/clothing/mask/rogue/spectacles/matthios
	name = "gilded spectacles"
	desc = "A drakkyne's eyes are oft blindsided by greed, yet such vision does hold some merit."
	armor = ARMOR_LEATHER
	color = "#faf5cb" // we golden
	aura_color = "#fffb00"

/obj/item/clothing/mask/rogue/spectacles/matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(obj_broken)
		return
	if(slot == SLOT_WEAR_MASK)
		if(HAS_TRAIT(user, TRAIT_FREEMAN))
			if(!user.has_status_effect(/datum/status_effect/buff/matthios_vision))
				to_chat(user, span_info("Gold gleams where truth once hid."))
				user.apply_status_effect(/datum/status_effect/buff/matthios_vision)
		else
			to_chat(user, span_warning("You look ridiculous and stupid. You are an amateur and a fool!"))

/obj/item/clothing/mask/rogue/spectacles/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user.get_item_by_slot(SLOT_WEAR_MASK) == src)
		to_chat(user, span_info("The gleam fades from my sight."))
		user.remove_status_effect(/datum/status_effect/buff/matthios_vision)

/atom/movable/screen/alert/status_effect/buff/matthios_vision
	name = "Gilded True Sight"
	desc = "Through Him, all is seen, and no locks shall bar me. Whether that it should be... is another matter."
	icon_state = "darkvision"

/datum/status_effect/buff/matthios_vision
	id = "matthios_vision"
	alert_type = /atom/movable/screen/alert/status_effect/buff/matthios_vision
	duration = -1
	tick_interval = 30 SECONDS

/datum/status_effect/buff/matthios_vision/on_apply(mob/living/new_owner)
	. = ..()
	to_chat(owner, span_warning("The world sharpens. Nothing hides from His gaze, now yours."))
	ADD_TRAIT(owner, TRAIT_GILDED_SIGHT, "matthiosboon")
	ADD_TRAIT(owner, TRAIT_PSYCHOSIS, "matthiosboon")
	owner.update_sight()

/datum/status_effect/buff/matthios_vision/on_remove()
	. = ..()
	to_chat(owner, span_warning("The truth fades. Darkness returns, but so does peace."))
	REMOVE_TRAIT(owner, TRAIT_GILDED_SIGHT, "matthiosboon")
	REMOVE_TRAIT(owner, TRAIT_PSYCHOSIS, "matthiosboon")
	owner.update_sight()

/datum/status_effect/buff/matthios_vision/tick()
	. = ..()
	var/mob/living/carbon/crazymofo = owner
	crazymofo.adjustFireLoss(25)
	if(crazymofo.hallucination < 200)
		crazymofo.hallucination += rand(1,50)
		to_chat(crazymofo, span_warning(pick("Is this TRVE??","DAFUQ?","I am NOT meant to see this.","What... WHAT is this?","This doesn't make SENSE.","I don't UNDERSTAND.","Why does it LOOK like that?","Something is WRONG here.","I can't make SENSE of this.","This isn't RIGHT.","What am I looking at?","None of THIS adds up.","I shouldn't be SEEING this.","This feels... INCORRECT.","Why is everything like this?","I CAN'T process this.","This ISN'T how it should be.","I don't get it.","What is happening?","This is all WRONG.","I CAN'T tell what's REAL.","Why does it feel off?","I don't recognize this.","This SHOULDN'T exist.","What is THIS supposed to be?","I can't FOLLOW this.","This isn't making sense anymore.","I think SOMETHING is broke.", "Why can't I understand THIS?", "This feels IMPOSSIBLE.", "I don't KNOW what I'm seeing.")))
		crazymofo.Jitter(5)
		if(prob(10))
			crazymofo.emote(pick("giggle","laugh","chuckle"))
	if(prob(crazymofo.hallucination/2) && crazymofo.hallucination > 50)
		crazymofo.blur_eyes(5)
		crazymofo.adjust_blurriness(10)
		crazymofo.blind_eyes(1.5)
		crazymofo.adjustBruteLoss(10)
		if(prob(10))
			crazymofo.emote("agony")
		to_chat(crazymofo, span_alert("MY EYES!!! THEY BURN!!!"))

/obj/item/clothing/shoes/roguetown/boots/muffle_matthios //I guess in case someone wants to make generic muffled boots? Change it to muffle/matthios if you do
	name = "gilded leather boots"
	desc = "Those who bear His fyre often cower in its shadow."
	icon_state = "matthiosboots"
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fff9c0" // we golden
	aura_color = "#ffe600"

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
	cooldown_time = 10
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/devotion_cost = 20

	var/list/options = list(
		"Pocket Sand" = list(
			path = /obj/item/impact_grenade/pocketsand,
			m_cooldown = 60 SECONDS,
			m_rank = SKILL_LEVEL_NOVICE,
			lines = list("Dust to blind thee!", "A handful of freedom!", "A gift for thee!", "Mind yer eyes!", "This always works like a miracle!")
		),
		"Gilded Lockpick" = list(
			path = /obj/item/melee/touch_attack/lesserknock/matthios,
			m_cooldown = 5 SECONDS,
			m_rank = SKILL_LEVEL_NOVICE,
			lines = list("#By thine hands...", "#No locks shall bar the free!", "#Thine tool shall bring liberation!", "#Matthios, shatter my locks!")
		),
		"Pouch of Bribery" = list(
			path = /obj/item/storage/belt/rogue/pouch/coins/matthios,
			m_cooldown = 5 MINUTES,
			m_rank = SKILL_LEVEL_EXPERT,
			lines = list("Coin begets coin!", "Matthios, grant me a sliver of thy wealth!", "Wealth through will, as He demands!")
		),
		"Gilded Dexterous Gloves" = list(
			path = /obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios,
			m_cooldown = 5 MINUTES,
			m_rank = SKILL_LEVEL_JOURNEYMAN,
			lines = list("#Hands of trade, be swift.", "#Let fingers dance for thy amusement.", "#Dexterity bought in faith.")
		),
		"Gilded Muffled Boots" = list(
			path = /obj/item/clothing/shoes/roguetown/boots/muffle_matthios,
			m_cooldown = 5 MINUTES,
			m_rank = SKILL_LEVEL_APPRENTICE,
			lines = list("#Steps unheard, as I walk in thy shadow.", "#Silent as coin slipping, for thy hoard.", "#No sound, no chain, no better wisdom, O' Lord.")
		),
		"Gilded Lockpicking Specs" = list(
			path = /obj/item/clothing/mask/rogue/spectacles/matthios,
			m_cooldown = 60 MINUTES,
			m_rank = SKILL_LEVEL_EXPERT,
			lines = list("#Guide my sight, O' Matthios.","#Through pins and wards, thy Free eyes see.","#No door shall be between me and truth.")
		),
		"Gilded Chains" = list(
			path = /obj/item/rope/chain/matthios,
			m_cooldown = 10 MINUTES,
			m_rank = SKILL_LEVEL_JOURNEYMAN,
			lines = list("Matthios! Chains for the tyrants!", "Matthios! Transact me thy chains!", "Lord of Freedom, chains for the unworthy!")
		),
		"Gilded Amulet of Matthios" = list(
			path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded,
			m_cooldown = 60 MINUTES,
			m_rank = SKILL_LEVEL_NOVICE,
			lines = list("MATTHIOS! MATTHIOS! MATTHIOS!", "MATTHIOS! MY ALLEGIANCE IS YOURS!!", "MATTHIOS IS MY LORD!!", "MATTHIOS IS MY MASTER!!", "MY FAITH IS IN YOU, MATTHIOS!!", "I AM NO THIEF, I AM FREE!!")
		),
		"Vial of Kingsfeast Base" = list(
			path = /obj/item/matthios_canister/kingsfeast,
			m_cooldown = 2 MINUTES,
			m_rank = SKILL_LEVEL_NOVICE,
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),
		"Vial of Goodnite Base" = list(
			path = /obj/item/matthios_canister/goodnite,
			m_cooldown = 2 MINUTES,
			m_rank = SKILL_LEVEL_APPRENTICE,
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),
		"Vial of Warsmith Base" = list(
			path = /obj/item/matthios_canister/warsmith,
			m_cooldown = 2 MINUTES,
			m_rank = SKILL_LEVEL_JOURNEYMAN,
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),
/*		"Vial of Liquid Desire Base" = list(
			path = /obj/item/matthios_canister/baotha,
			m_cooldown = 10 MINUTES,
			m_rank = SKILL_LEVEL_MASTER,
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),
		"Vial of Liquid Bloodlust Base" = list(
			path = /obj/item/matthios_canister/graggar,
			m_cooldown = 10 MINUTES,
			m_rank = SKILL_LEVEL_MASTER,
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),
		"Vial of Liquid Progress Base" = list(
			path = /obj/item/matthios_canister/zizo,
			m_cooldown = 10 MINUTES,
			m_rank = SKILL_LEVEL_MASTER,
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),
		"Vial of Liquid Freedom Base" = list(
			path = /obj/item/matthios_canister/matthios,
			m_cooldown = 10 MINUTES,
			m_rank = SKILL_LEVEL_MASTER,
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),*/
		"Vial of Lyfestruth Base" = list(
			path = /obj/item/matthios_canister/lyfestruth,
			m_cooldown = 10 MINUTES,
			m_rank = SKILL_LEVEL_MASTER, // exclusive to devotee missionary/heretic (HOPEFULLY!)
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),
/*		"Vial of Truthsnuke Base" = list(
			path = /obj/item/matthios_canister/truthsnuke,
			m_cooldown = 3 HOURS,
			m_rank = SKILL_LEVEL_MASTER, // exclusive to devotee missionary/heretic (HOPEFULLY!)
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),*/
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

	var/list/display = list()

	for(var/name in valid)
		var/time_left = item_cooldowns[name] ? max(0, item_cooldowns[name] - world.time) : 0
		var/display_name = time_left > 0 ? "[name] ([round(time_left/10, 1)]s)" : name
		display[display_name] = name

	var/choice_display = tgui_input_list(H, "Choose your tool", "Freeman's Tools", display)
	if(!choice_display)
		return FALSE

	var/choice = display[choice_display]
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

/obj/item/
	var/aura_color = null

/obj/item/Initialize()
	. = ..()
	if(aura_color)
		apply_aura()

/obj/item/proc/apply_aura()
	if(!aura_color)
		return
	if(!filters)
		filters = list()
	remove_aura()
	var/aura_color_final = "[aura_color]40"
	filters += filter(type="outline", color=aura_color_final, size=2)

/obj/item/proc/remove_aura()
	if(!filters)
		return

	for(var/F in filters)
		if(islist(F))
			if(F["type"] == "outline")
				filters -= F

/obj/item/proc/refresh_aura()
	if(aura_color)
		apply_aura()

/obj/item/alchserum
	var/current_color = "#ffffff"

/obj/item/alchserum/Initialize()
	. = ..()
	update_icon()

/obj/item/alchserum/update_icon()
	cut_overlays()

	var/mutable_appearance/fluid = mutable_appearance(icon, "canister_fluid")
	fluid.color = current_color
	add_overlay(fluid)

/obj/item/matthios_canister
	name = "gilded alchemical canister"
	desc = "A strange, fragile alchemical vessel housing a silent power beyond human comprehension. Is this true?"
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	w_class = WEIGHT_CLASS_TINY

	var/current_color = "#ffffff"
	var/list/required_ingredients = list()
	var/list/inserted_ingredients = list()
	var/list/ingredient_colors = list()
	var/result_path = null

/obj/item/matthios_canister/examine(mob/user)
	. = ..()

	if(HAS_TRAIT(user, TRAIT_FREEMAN))
		. += span_notice("[freeman_truth()]")
		. += span_warning("[freeman_progress(user)]")

/obj/item/matthios_canister/proc/freeman_truth()
	return "..."

/obj/item/matthios_canister/proc/freeman_progress(mob/user)
	return "..."

/obj/item/matthios_canister/update_icon()
	. = ..()
	cut_overlays()
	var/mutable_appearance/fluid = mutable_appearance(icon, "canister_fluid")
	fluid.color = current_color
	add_overlay(fluid)

/obj/item/matthios_canister/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		return TRUE

	if(istype(I, /obj/item/alch/golddust))
		var/list/missing = list()
		for(var/T in required_ingredients)
			if(!(T in inserted_ingredients))
				missing += T

		if(!missing.len)
			return TRUE

		if(do_after(user, 2 SECONDS))
			var/chosen = pick(missing)
			inserted_ingredients += chosen

			if(ingredient_colors[chosen])
				current_color = ingredient_colors[chosen]

			qdel(I)
			update_icon()
			check_completion(user)
		return TRUE

	var/valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			valid = TRUE
			break

	if(!valid)
		return TRUE

	if(I.type in inserted_ingredients)
		return TRUE

	if(do_after(user, 2 SECONDS))
		inserted_ingredients += I.type

		if(ingredient_colors[I.type])
			current_color = ingredient_colors[I.type]

		qdel(I)
		update_icon()
		check_completion(user)

	return TRUE

/obj/item/matthios_canister/proc/check_completion(mob/user)
	for(var/T in required_ingredients)
		if(!(T in inserted_ingredients))
			return
	alch_transform(user)

/obj/item/matthios_canister/proc/alch_transform(mob/user)
	if(!result_path)
		return
	to_chat(user, span_notice("The mixture stabilizes successfully."))
	new result_path(get_turf(src))
	qdel(src)

/obj/item/matthios_canister/lyfestruth
	name = "vial of lyfestruth base"
	desc = "Within the glass swells a searing draught, as though molten gold were stirred with the heartblood of a volcano. It glows too bright, too alive. The vessel ought crack, yet it does not. A sweetness clings to it—burnt, cloying, wrong. To gaze upon it is to feel thy pulse falter."
	color = "#ff7a7a"	
	required_ingredients = list(
		/obj/item/alch/atropa,
		/obj/item/alch/matricaria,
		/obj/item/alch/symphitum,
		/obj/item/alch/taraxacum,
		/obj/item/alch/euphrasia,
		/obj/item/alch/paris,
		/obj/item/alch/calendula,
		/obj/item/alch/mentha,
		/obj/item/alch/urtica,
		/obj/item/alch/salvia,
		/obj/item/alch/hypericum,
		/obj/item/alch/benedictus,
		/obj/item/alch/valeriana,
		/obj/item/alch/artemisia,
		/obj/item/reagent_containers/food/snacks/grown/manabloom,
		/obj/item/alch/rosa
	)

	ingredient_colors = list(
		/obj/item/alch/atropa = "#8b37c4",
		/obj/item/alch/matricaria = "#f5e6a8",
		/obj/item/alch/symphitum = "#4f8f6a",
		/obj/item/alch/taraxacum = "#ffd84d",
		/obj/item/alch/euphrasia = "#cfe8ff",
		/obj/item/alch/paris = "#62a044",
		/obj/item/alch/calendula = "#ff9f1a",
		/obj/item/alch/mentha = "#3aff7a",
		/obj/item/alch/urtica = "#2f7f3f",
		/obj/item/alch/salvia = "#6b8e23",
		/obj/item/alch/hypericum = "#ffcc33",
		/obj/item/alch/benedictus = "#d4b24c",
		/obj/item/alch/valeriana = "#8e5a3c",
		/obj/item/alch/artemisia = "#7a9e7e",
		/obj/item/reagent_containers/food/snacks/grown/manabloom = "#66ccff",
		/obj/item/alch/rosa = "#ff4d6d"
	)

	result_path = /obj/item/alchserum/matthios_lyfestruth

/obj/item/matthios_canister/lyfestruth/freeman_truth()
	return "This is no vulgar tonic, but 'Geald', the stolen fyre of Astrata condensed into liquid form. Oft called 'liquid anastasis', it restores not flesh, but the moment before death was writ. However, it is a fact of its volatile nature."

/obj/item/matthios_canister/lyfestruth/freeman_progress(mob/user)
	var/list/missing = list()

	for(var/T in required_ingredients)
		if(!(T in inserted_ingredients))
			missing += T

	if(!missing.len)
		return "It is made whole. The draught strains against its prison."

	var/obj/item/temp = new (pick(missing))
	var/name = initial(temp.name)
	qdel(temp)

	return "It lacks [name] or gold dust. ([missing.len] humours yet unbound)"

/obj/item/alchserum/matthios_lyfestruth
	name = "canister of lyfestruth"
	desc = "A radiant vial containing a volatile, life-restoring mixture. The liquid within churns with molten intensity, casting a searing orange-gold glow that flickers against its glass prison. It promises to restore what was lost— but not without exacting something in return. The heat is constant. Unnatural. Alive."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#ff9d00"
	aura_color = "#fffaad"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alchserum/matthios_lyfestruth/attack(mob/living/target, mob/user)
	if(!istype(target))
		return

	to_chat(user, span_notice("You begin pouring the lyfestruth over [target.name]..."))

	if(do_after(user, 3 SECONDS, target))
		apply_effect(target, user)

/obj/item/alchserum/matthios_lyfestruth/proc/apply_effect(mob/living/carbon/target, mob/user)
	if(!target)
		return

	target.fully_heal(admin_revive = TRUE, break_restraints = TRUE)

	to_chat(target, span_warning("Your body is violently forced back to life as searing heat floods your veins, your body, your everything!"))
	visible_message(span_warning("[target.name]'s wounds seal instantly... only for their body and everywhere around them ignite moments after."))

	explosion(target, devastation_range = null, heavy_impact_range = null, light_impact_range = 8, flame_range = 3, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))
	target.adjust_fire_stacks(10)
	target.ignite_mob()
	target.emote("agony", forced = TRUE)

	to_chat(user, span_notice("The vial burns to ash in your hands."))
	qdel(src)

/obj/item/matthios_canister/kingsfeast
	name = "vial of kingsfeast base"
	desc = "The brew within sloshes thick as spoiled blood. A stench rises from it most foul, resembling a mixture of rot and brine. The very vapours of said tincture can dissolve organic matter."

	var/max_ingredients = 10

	required_ingredients = list(
		/obj/item/alch/sinew,
		/obj/item/organ,
		/obj/item/alch/viscera,
		/obj/item/natural/bone,
		/obj/item/natural/bundle/bone,
		/obj/item/natural/fibers,
		/obj/item/reagent_containers/powder/salt,
		/obj/item/reagent_containers/food
	)
	ingredient_colors = list(
		/obj/item/alch/sinew = "#a84a4a",
		/obj/item/organ = "#a84a4a",
		/obj/item/alch/viscera = "#6e1e1e",
		/obj/item/natural/bone = "#e8e2cf",
		/obj/item/natural/bundle/bone = "#e8e2cf",
		/obj/item/natural/fibers = "#b59b6a",
		/obj/item/reagent_containers/powder/salt = "#f0f0f0",
		/obj/item/reagent_containers/food = "#d67a4a"
	)

/obj/item/matthios_canister/kingsfeast/freeman_truth()
	return "A primal alchemical reduction tincture. All organic input is stripped to its nutritional and experiential essence, then recomposed into perfected sustenance. It does not cook, it outright defines what it means to be food."

/obj/item/matthios_canister/kingsfeast/freeman_progress(mob/user)
	var/remaining = max_ingredients - inserted_ingredients.len
	if(remaining <= 0)
		return "The feast is ready to take form."

	return "It needs [remaining] more organic offerings."

/obj/item/matthios_canister/kingsfeast/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	var/valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			valid = TRUE
			break

	if(!valid)
		return TRUE

	if(inserted_ingredients.len >= max_ingredients)
		to_chat(user, span_warning("The canister refuses to take more. It is... full."))
		return TRUE

	if(do_after(user, 1.5 SECONDS))
		inserted_ingredients += I.type

		var/color_to_use = null
		for(var/T in ingredient_colors)
			if(istype(I, T))
				color_to_use = ingredient_colors[T]
				break

		if(color_to_use)
			current_color = color_to_use

		var/list/absorb_flavor = list(
			"The mixture's vapors overtake the [I] at once, breaking it down into a fine, formless draught...",
			"A faint hiss rises as the [I] is rendered to its base components, drawn into the brew...",
			"The [I] loses all shape, reduced to a pale suspension within the thickened mixture...",
			"The [I] slackens and falls apart, its substance wholly undone and folded into the draught...",
			"The brew strips the [I] to its essence, leaving no trace of its former form...",
			"A subtle reaction passes through the vessel as the [I] is reduced and made one with it...",
			"The [I] collapses into a fine residue, its nature thoroughly dissolved into the mixture...",
			"The [I] is unmade in moments, rendered down and claimed by the alchemical base...",
			"The draught clouds as the [I] is broken to its simplest form and drawn within...",
			"The [I] yields entirely, reduced and recomposed within the vessel's thick contents..."
		)
		qdel(I)

		to_chat(user, span_notice(pick(absorb_flavor)))
		update_icon()
		check_completion(user)

	return TRUE

/obj/item/matthios_canister/kingsfeast/check_completion(mob/user)
	if(inserted_ingredients.len < max_ingredients)
		return

	alch_transform(user)

/obj/item/matthios_canister/kingsfeast/alch_transform(mob/user)
	to_chat(user, span_notice("You begin channeling your greed into the mixture..."))

	var/list/options = list(
		"Ducal Peppersteak" = /obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal,
		"Lobster Meal" = /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal,
		"Crabcake" = /obj/item/reagent_containers/food/snacks/rogue/crabcake,
		"Chocolate" = /obj/item/reagent_containers/food/snacks/chocolate,
		"Meat Flatpie" = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate,
		"Broth Brique" = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique,
		"Strawberry Cake" = /obj/item/reagent_containers/food/snacks/rogue/strawberrycake,
		"Cookies" = /obj/item/reagent_containers/food/snacks/rogue/cookiec
	)

	var/choice = input(user, "What form shall your greed take?", "Kingsfeast") as null|anything in options
	if(!choice)
		return

	var/result_type = options[choice]

	if(prob(25))
		to_chat(user, span_warning("The mixture ignites violently, collapsing into useless slag and bitter disappointment. It... technically is edible..."))
		new /obj/item/reagent_containers/food/snacks/badrecipe(get_turf(src))
		qdel(src)
		return
	
	var/mob/living/L = user
	var/is_hungry = locate(/datum/status_effect/debuff/hungryt3) in L.status_effects

	if(!is_hungry && prob(60)) // bread troll
		to_chat(user, span_warning("The mixture shifts... simplifying itself into something more befitting your greed."))
		new /obj/item/reagent_containers/food/snacks/rogue/bread(get_turf(src))
		if(prob(20))
			user.emote(pick("sigh","groan"))
		qdel(src)
		return
	if(is_hungry)
		to_chat(user, span_notice("Matthios takes pity on your mortal limitations. You compulsively shout in gratitude!"))
		user.say(pick("PRAISE YOU, O' GENEROUS MATTHIOS!!","AT LAST, THE TRUE GOLD OF CULINARY ALCHEMY!!","BLESSED BE THY HANDS WHICH GRANT ME SUSTENANCE, MATTHIOS!!","I SHALL GIVE ALL FOR THY SMILE, LORD OF FREEDOM!!"))

	to_chat(user, span_notice("The mixture responds to your greed, taking a decadent form."))

	new result_type(get_turf(src))
	qdel(src)

/obj/item/matthios_canister/kingsfeast/attack_self(mob/user)
	if(inserted_ingredients.len < max_ingredients)
		to_chat(user, span_warning("It is not yet ready."))
		return

	to_chat(user, span_notice("The mixture churns expectantly, awaiting the weight of your greed..."))
	alch_transform(user)

/obj/item/matthios_canister/goodnite
	name = "vial of goodnite base"
	desc = "A dim, cloudy fluid rests inside, barely moving. Occasionally, something viscous streaks through it— like diluted brain matter. The glass feels warm, almost comforting. Staring at too long makes your eyelids heavy, and you get an odd compulsion to drink it."
	
	var/max_ingredients = 6

	required_ingredients = list(
		/obj/item/alch/bonemeal,
		/obj/item/alch/mentha,
		/obj/item/alch/manabloompowder,
	)

	ingredient_colors = list(
		/obj/item/alch/bonemeal = "#ffffff",
		/obj/item/alch/mentha = "#3aff7a",
		/obj/item/alch/manabloompowder = "#66ccff"
	)

/obj/item/matthios_canister/goodnite/freeman_truth()
	return "Condensed stellar residue. Dust harvested from a somnolent star that emits rhythmic sleep pulses. This is not sedation. It entrains the body to a universal resting cadence."

/obj/item/matthios_canister/goodnite/freeman_progress(mob/user)
	var/remaining = max_ingredients - inserted_ingredients.len

	if(remaining <= 0)
		return "The mixture has reached perfect stillness."

	return "It requires further refinement with either bonemeal, manabloom dust or whole menthas. ([remaining] infusions remaining)"

/obj/item/matthios_canister/goodnite/attackby(obj/item/I, mob/user)
	if(!HAS_TRAIT(user, TRAIT_MATTHIOS_EYES))
		to_chat(user, span_warning("The hell do I do with this? This is no alchemy!"))
		return TRUE

	var/valid = FALSE
	for(var/T in required_ingredients)
		if(istype(I, T))
			valid = TRUE
			break

	if(!valid)
		return TRUE

	if(inserted_ingredients.len >= max_ingredients)
		to_chat(user, span_warning("The vial will accept no more. It rests at perfect equilibrium."))
		return TRUE

	if(do_after(user, 1.5 SECONDS))
		inserted_ingredients += I.type

		var/color_to_use = null
		for(var/T in ingredient_colors)
			if(istype(I, T))
				color_to_use = ingredient_colors[T]
				break

		if(color_to_use)
			current_color = color_to_use

		qdel(I)

		var/list/absorb_flavor = list(
			"The mixture receives [I], its form dissolving into a calm, pale suspension...",
			"[I] softens and unravels, drawn quietly into the resting fluid...",
			"A faint stillness follows as [I] is reduced and folded into the mixture...",
			"[I] loses all distinction, rendered into a smooth, somnolent draught...",
			"The vial clouds gently as [I] is broken down and made one with it..."
		)

		to_chat(user, span_notice(pick(absorb_flavor)))

		update_icon()
		check_completion(user)

	return TRUE

/obj/item/matthios_canister/goodnite/check_completion(mob/user)
	if(inserted_ingredients.len < max_ingredients)
		return

	alch_transform(user)

/obj/item/matthios_canister/goodnite/alch_transform(mob/user)
	to_chat(user, span_notice("The mixture settles into a perfectly still, somnolent state."))
	new /obj/item/alchserum/matthios_goodnite(get_turf(src))
	qdel(src)

/obj/item/alchserum/matthios_goodnite
	name = "vial of goodnite"
	desc = "A soft-glowing concoction that induces immediate, restorative sleep. The fluid rests in perfect stillness, undisturbed by motion or time. Gazing into it too long draws a creeping heaviness into the body, as if the world itself is gently insisting you lie down and surrender to rest."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#5c6fb2"
	aura_color = "#ffe4b9"
	w_class = WEIGHT_CLASS_TINY

/obj/item/alchserum/matthios_goodnite/attack(mob/living/target, mob/user)
	if(!istype(target))
		return

	to_chat(user, span_notice("You begin gently administering the concoction to [target.name]'s eyes..."))

	if(do_after(user, 6 SECONDS, target))
		apply_sleep(target, user)

/obj/item/alchserum/matthios_goodnite/proc/apply_sleep(mob/living/target, mob/user)
	if(!target)
		return

	if(HAS_TRAIT(target, TRAIT_NOSLEEP))
		to_chat(user, span_warning("[target.name] resists the effects entirely."))
		return

	to_chat(target, span_notice("A heavy calm overtakes your body..."))
	sleep(5)
	visible_message(span_notice("[target.name] suddenly goes limp, overtaken by unnatural sleep."))

	target.SetSleeping(300)
	target.SetUnconscious(0)
	target.stat = UNCONSCIOUS

	spawn()
		while(target && target.IsSleeping())
			target.energy_add(20)

			if(target.nutrition > 0)
				target.adjustBruteLoss(-1)
				target.adjustFireLoss(-1)

			if(target.hydration > 0)
				target.adjustOxyLoss(-2)
				target.adjustToxLoss(-1)

			sleep(20)

	to_chat(user, span_notice("The vial dulls and crumbles away."))
	qdel(src)

/obj/item/matthios_canister/warsmith
	name = "vial of warsmith base"
	desc = "A biting liquor gnaws within the vial, as though it would eat iron itself. Flecks of metal drift and vanish, then return as if unmade and remade. It reeks of rust and sharp ruin. No forge would suffer this thing near its works."

	var/needed_scrap = 3
	var/current_scrap = 0
	var/has_needle = FALSE
	var/current_fibers = 0
	var/needed_fibers = 6

	required_ingredients = list(
		/obj/item/needle,
		/obj/item/natural/bundle/fibers,
		/obj/item/natural/fibers,
		/obj/item/scrap,
	)
	ingredient_colors = list(
		/obj/item/needle = "#c0c0c0",
		/obj/item/natural/bundle/fibers = "#1fa712",
		/obj/item/natural/fibers = "#1fa712",
		/obj/item/scrap = "#6e6e6e",
	)

/obj/item/matthios_canister/warsmith/freeman_truth()
	return "A cunning weave of filament and will. Metal and fiber undone to their first truths, that they may be rewrought aright. It does not destroy— it remembers the shape of perfection, and compels all things toward it."

/obj/item/matthios_canister/warsmith/freeman_progress(mob/user)
	return "Needle: [has_needle ? "set" : "wanting"]\nFibers: [current_fibers]/[needed_fibers]\nIron scrap: [current_scrap]/[needed_scrap]"

/obj/item/matthios_canister/warsmith/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/scrap))
		if(current_scrap >= needed_scrap)
			to_chat(user, span_warning("The mixture refuses more metal."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			current_scrap++
			qdel(I)

			var/color_to_use = ingredient_colors[/obj/item/scrap]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("You feed scrap into the mixture. ([current_scrap]/[needed_scrap])"))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/needle))
		if(has_needle)
			to_chat(user, span_warning("A needle has already been integrated."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			has_needle = TRUE
			qdel(I)

			var/color_to_use = ingredient_colors[/obj/item/needle]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("The needle dissolves into fine metallic thread."))
			update_icon()
			check_completion(user)
		return TRUE

	if(istype(I, /obj/item/natural/bundle/fibers))
		if(current_fibers >= needed_fibers)
			to_chat(user, span_warning("The mixture will take no more fiber."))
			return TRUE

		var/obj/item/natural/bundle/fibers/B = I
		var/amount = B.amount

		var/space_left = needed_fibers - current_fibers
		var/to_transfer = min(amount, space_left)

		if(do_after(user, 2 SECONDS))
			current_fibers += to_transfer

			if(to_transfer >= amount)
				qdel(B)
			else
				B.amount -= to_transfer
				B.update_icon()

			var/color_to_use = ingredient_colors[/obj/item/natural/bundle/fibers/full]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("You feed [to_transfer] measure\s of fiber into the mixture. ([current_fibers]/[needed_fibers])"))

			update_icon()
			check_completion(user)

		return TRUE

	if(istype(I, /obj/item/natural/fibers))
		if(current_fibers >= needed_fibers)
			to_chat(user, span_warning("The mixture will take no more fiber."))
			return TRUE

		if(do_after(user, 2 SECONDS))
			current_fibers++
			qdel(I)

			var/color_to_use = ingredient_colors[/obj/item/natural/bundle/fibers/full]
			if(color_to_use)
				current_color = color_to_use

			to_chat(user, span_notice("The fiber is reduced and drawn into the mixture. ([current_fibers]/[needed_fibers])"))

			update_icon()
			check_completion(user)

		return TRUE

	to_chat(user, span_warning("This does not belong in the canister."))
	return TRUE

/obj/item/matthios_canister/warsmith/check_completion(mob/user)
	if(current_scrap < needed_scrap)
		return
	if(!has_needle)
		return
	if(current_fibers < needed_fibers)
		return

	alch_transform(user)

/obj/item/matthios_canister/warsmith/alch_transform(mob/user)
	to_chat(user, span_notice("The mixture hardens, then liquefies into an amorphous, perfect balance of fiber and steel."))
	new /obj/item/alchserum/matthios_warsmith(get_turf(src))
	qdel(src)

/obj/item/alchserum/matthios_warsmith
	name = "vial of warsmith"
	desc = "A volatile fusion of textile and metal-binding alchemy. Filaments of steel and fiber drift within the mixture, weaving and unweaving themselves in restless patterns. It hums faintly when held, as if anticipating fracture— and the satisfaction of making something whole again."
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "canister_empty"
	current_color = "#9c7b45"
	aura_color = "#ffe4b9"
	w_class = WEIGHT_CLASS_TINY
	var/uses = 4

/obj/item/alchserum/matthios_warsmith/attack_obj(obj/O, mob/living/user)
	if(!isitem(O))
		return
	var/obj/item/I = O
	if(!I.max_integrity)
		to_chat(user, span_warning("This cannot be repaired."))
		return
	if(I.obj_integrity >= I.max_integrity)
		to_chat(user, span_warning("This is not broken."))
		return
	to_chat(user, span_notice("You begin applying the warsmith mixture to [I]..."))
	if(!do_after(user, 6 SECONDS, target = I))
		return
	playsound(loc, 'sound/magic/swap.ogg', 100, TRUE, -2)
	user.visible_message(span_info("[user] restores [I] with alchemical precision."))
	if(I.body_parts_covered != I.body_parts_covered_dynamic)
		I.repair_coverage()
	I.obj_integrity = I.max_integrity
	if(I.obj_broken)
		I.obj_fix()
	uses--
	if(uses > 0)
		to_chat(user, span_notice("The mixture settles, awkwardly. You estimate [uses] uses remain."))
	else
		to_chat(user, span_warning("The vial burns out, its contents fully spent."))
		qdel(src)

/obj/item/melee/touch_attack/lesserknock/matthios
	name = "Gilded Lockpick"
	desc = "A golden, glowing lockpick that appears to be held together by the truth of Matthios. To dispel it, simply use it on anything that isn't a door."
	catchphrase = null
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lockpick"
	color = "#eeff00" // we golden now, bij
	picklvl = 1.1 // 10% better than normal picks!
	max_integrity = 100
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF
	aura_color = "#ffe761"

/obj/item/melee/touch_attack/lesserknock/attack_self()
	qdel(src)

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded
	name = "strange gilded amulet"
	desc = "He was ever the one to make you ask questions: Why are we still here? Just to suffer? Nae. We are here to make a change. And a change we shall make, together."
	icon_state = "matthios"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	smeltresult = /obj/item/roguecoin/gold/matthios/pile
	var/grant_chant = FALSE
	aura_color = "#ffe761"

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & (ITEM_SLOT_NECK))
		if(HAS_TRAIT(user, TRAIT_FREEMAN))
			if(!user.has_language(/datum/language/thievescant))
				to_chat(user, span_info("The whispers of the unseen find my tongue."))
				user.grant_language(/datum/language/thievescant)
				grant_chant = TRUE

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && (user?.wear_neck == src))
		if(grant_chant)
			to_chat(user, span_info("The whispers fade from my tongue."))
			user.remove_language(/datum/language/thievescant)
			grant_chant = FALSE

/obj/item/rope/chain/matthios
	name = "gilded chain"
	desc = "A heavy, gilded chain that thrums with latent divine power. It resonates negatively with the essence of nobility, as if stirred by divine rebuke."	
	color = "#fdff86"
	aura_color = "#fff385"
	matthios_chains = TRUE
	smeltresult = /obj/item/roguecoin/gold/matthios/pile

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios
	name = "gilded fingerless gloves"
	desc = "Those who grasp at Fyre, are bount to be burned."
	sewrepair = TRUE
	armor = ARMOR_LEATHER
	color = "#fce517" // we golden
	aura_color = "#fff385"

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_GLOVES && HAS_TRAIT(user, TRAIT_FREEMAN))
		to_chat(user, span_info("Like Him, my hands ready to grasp the impossible."))
		ADD_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthiosboon")

/obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user.get_item_by_slot(SLOT_GLOVES) == src)
		to_chat(user, span_info("Once again, these hands are supplicant."))
		REMOVE_TRAIT(user, TRAIT_SILENT_LOCKPICK, "matthiosboon")

/obj/item/roguecoin/gold/matthios
	name = "zenar"
	desc = "A gold coin bearing the symbol of the Taurus and the pre-kingdom psycross. These were in the best condition of the provincial gold mints, the rest were melted down."
	sellprice = 0 // honk, though knowing these powergamers, the meme won't last forever, worst case this skill's worth is to create free pouches :'(

/obj/item/roguecoin/gold/matthios/examine(mob/user)
	. = ..()
	if(prob(20)) // this may be remove based on how much people troll with it, but for now
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
		for(var/mob/living/target in range(0, T))
			if(!target.mind || istype(target, /mob/living/simple_animal))
				target.adjustBruteLoss(5)
			if(iscarbon(target))
				target.blur_eyes(5)
				target.adjust_blurriness(10)
				target.blind_eyes(1.5)
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
	desc = "Invoke Matthios's name and invest 50 to 100 mammon of your own hoard into your next strike. The power of your offering mirrors the wealth spent, drawing even from your bank. Every coin fuels your glory.<br><br>Penetrates armor equal to 75% of the mammon spent."
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
	var/max_mammon = 100

/datum/action/cooldown/spell/mammonite/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/H = owner
	if(!H.cmode)
		to_chat(H, span_warning("I need some adrenaline pumping for this, my good sire!"))
		revert_cast() 
		return FALSE

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
	duration = 20 SECONDS
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
	var/apen = damage * 0.75

	arcyne_strike(
		owner,
		target,
		weapon,
		damage,
		owner.zone_selected,
		BCLASS_SMASH,
		apen,
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

#undef MAMMON_FILTER 

/obj/effect/proc_holder/spell/self/skulduggery
	name = "Skulduggery"
	desc = "Imbue your mind and eyes with the cunning of Matthios, reading strikes before they land and punishing them with brutal efficiency.<br><br>Toggle Throw mode to actively intercept and grapple attacks, otherwise, you'll try to avoid them however you can."
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "liberate"
	recharge_time = 120 SECONDS
	sound = 'sound/magic/haste.ogg'
	releasedrain = 10
	miracle = TRUE
	devotion_cost = 70
	antimagic_allowed = FALSE
	range = 0

/obj/effect/proc_holder/spell/self/skulduggery/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = user

	if(!H.cmode)
		to_chat(H, span_warning("I need some adrenaline pumping for this, my good sire!"))
		revert_cast() 
		return FALSE

	if(H.resting)
		H.set_resting(FALSE, FALSE)
		H.visible_message(
			span_warning("[H] kips up!"),
			span_warning("No rest for the wicked!"))

	H.visible_message(
		span_notice("[H] shifts their stance into something more relaxed and open! Their eyes glow golden..."),
		span_notice("My gaze is grafted with truth, my mind wanders in freedom..."))
	H.apply_status_effect(/datum/status_effect/buff/skulduggery)
	H.OffBalance(30)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/skulduggery 
	name = "Skulduggery" 
	desc = span_notice("I prepare to slip inside attacks and punish aggressors, like a true Free Man would.") 
	icon_state = "clash"

/datum/status_effect/buff/skulduggery
	id = "skulduggery"
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/skulduggery
	status_type = STATUS_EFFECT_REFRESH
	var/mob/living/carbon/human/grappled
	var/waiting_followup = FALSE
	var/afterimage_active = FALSE
	var/list/grapple_counts = list() // free grapple can only happen twice vs players
	var/parries_left = 0 // only got X free parries based on miracle level
	tick_interval = 1 SECONDS

/datum/status_effect/buff/skulduggery/on_creation(mob/living/new_owner, ...)
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(process_Wfist))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(on_incapacitate))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(on_incapacitate))

	new_owner.AddComponent(/datum/component/after_image)
	afterimage_active = TRUE
	parries_left = new_owner.get_skill_level(/datum/skill/magic/holy)
	. = ..()

/datum/status_effect/buff/skulduggery/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_STUN)
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND)

	owner.stop_pulling()
	waiting_followup = FALSE

	if(afterimage_active)
		var/datum/component/after_image/A = owner.GetComponent(/datum/component/after_image)
		if(A)
			qdel(A)
		afterimage_active = FALSE

	. = ..()

/datum/status_effect/buff/skulduggery/proc/on_incapacitate()
	SIGNAL_HANDLER 
	if(!owner) 
		return 
	if(!owner.IsKnockdown() && !owner.IsStun()) 
		return 
	to_chat(owner, span_warning("My footing falters! Carkin'--!")) 
	qdel(src)

/datum/status_effect/buff/skulduggery/tick()
	. = ..()
	if(!owner) return

	if(waiting_followup && grappled)
		if(owner.pulling != grappled)
			waiting_followup = FALSE
			grappled = null

	if(owner.has_status_effect(/datum/status_effect/buff/tempo_one) || owner.has_status_effect(/datum/status_effect/buff/tempo_two) || owner.has_status_effect(/datum/status_effect/buff/tempo_three) || owner.has_status_effect(/datum/status_effect/buff/equalizebuff))
		owner.apply_status_effect(/datum/status_effect/buff/skulduggery)
		return

// -------------------------
// SIGNAL HOOKS
// -------------------------

/datum/status_effect/buff/skulduggery/proc/process_Wfist(mob/living/carbon/human/parent,mob/living/carbon/human/attacker,mob/living/carbon/human/defender)
	if(!ishuman(defender)) return
	if(defender.process_skd(attacker, null))
		return COMPONENT_HAND_NO_ATTACK

/datum/status_effect/buff/skulduggery/proc/process_Wattack(mob/living/parent,mob/living/target,mob/user,obj/item/I)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.process_skd(user, I))
			return COMPONENT_NO_ATTACK

/mob/living/carbon/human/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	var/datum/status_effect/buff/skulduggery/S = has_status_effect(/datum/status_effect/buff/skulduggery)
	if(!S) return FALSE
	return S.process_skd(attacker, I)

// -------------------------
// CORE LOGIC
// -------------------------

/datum/status_effect/buff/skulduggery/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	if(!owner || !ishuman(owner) || !ishuman(attacker))
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/A = attacker

	// FOLLOW-UP STATE
	if(waiting_followup)
		if(A == grappled)
			slam_target(A)
		else
			slam_into(A)
		return TRUE

	// PRONE CHECK (FREE ACTION)
	if(A.IsKnockdown() || A.lying)
		return stomp_prone(A)

	// THROW MODE: INTERCEPT → GRAPPLE
	if(H.in_throw_mode)
		return attempt_grapple(H, A)

	// NPC BAMBOOZLING
	if(!A.mind)
		return auto_flank_move(H, A)

	// PLAYER STANDARD PARRY
	return attempt_parry(H, A, I)

/datum/status_effect/buff/skulduggery/proc/attempt_grapple(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(A.mind)
		if(!grapple_counts[A])
			grapple_counts[A] = 0

		if(grapple_counts[A] >= 2)
			H.visible_message(
				span_warning("[H] reaches for [A], but they anticipate it!"),
				span_notice("They've adapted... I can't grab them again!")
			)
			return FALSE

		grapple_counts[A]++

	H.start_pulling(A)
	H.setDir(get_dir(H, A))
	playsound(H, 'sound/combat/riposte.ogg', 100, TRUE)

	H.visible_message(
		span_boldwarning("[H] intercepts [A] and seizes them!"),
		span_notice("Got them!")
	)

	H.balloon_alert_to_viewers("SKD!!", "SKD!!", 10)

	grappled = A
	waiting_followup = TRUE

	return TRUE

/datum/status_effect/buff/skulduggery/proc/attempt_parry(mob/living/carbon/human/H, mob/living/carbon/human/A, obj/item/I)
	var/my_skill = H.get_skill_level(/datum/skill/magic/holy)
	var/enemy_skill = A.get_skill_level(I.associated_skill)

	// Skill difference (your advantage)
	var/skill_diff = my_skill - enemy_skill

	// Base success chance (20% per point of advantage)
	var/base_chance = skill_diff * 20

	// Parry bonus (+20% per remaining parry)
	var/parry_bonus = parries_left * 20

	// Final success chance
	var/success_chance = base_chance + parry_bonus
	success_chance = clamp(success_chance, 0, 90)

	// Roll
	if(!prob(success_chance))
		H.visible_message(
			span_warning("[H] tries to read [A]'s attack, but fails!"),
			span_notice("Gah, I can't keep up!")
		)
		return FALSE

	// Success
	if(parries_left > 0)
		parries_left--

	auto_flank_move(H, A)

	return TRUE

/datum/status_effect/buff/skulduggery/proc/is_valid_step(mob/living/carbon/human/H, turf/dest)
	if(!dest)
		return FALSE

	// Use your existing teleport validation
	if(arcyne_validate_blink_dest(dest, H))
		return FALSE

	// Extra paranoia (cliffs / void)
	if(istransparentturf(dest))
		return FALSE

	return TRUE

/datum/status_effect/buff/skulduggery/proc/auto_flank_move(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(!H || !A)
		return FALSE

	// Snapshot direction (important)
	var/original_dir = A.dir

	// Compute tiles
	var/left_dir = turn(original_dir, 90)
	var/right_dir = turn(original_dir, -90)
	var/behind_dir = turn(original_dir, 180)

	var/turf/left = get_step(A, left_dir)
	var/turf/right = get_step(A, right_dir)
	var/turf/behind = get_step(A, behind_dir)

	// Decide which side to use (based on relative position)
	var/dx = H.x - A.x
	var/dy = H.y - A.y
	var/use_left = (dx * dy >= 0)

	var/turf/side = use_left ? left : right
	var/turf/alt_side = use_left ? right : left

	// Validate full sequence: side to behind
	if(!is_valid_step(H, side) || !is_valid_step(H, behind))
		// fallback to opposite side
		side = alt_side

		if(!is_valid_step(H, side) || !is_valid_step(H, behind))
			// final fallback: just behind
			if(!is_valid_step(H, behind))
				return FALSE

			// blink directly behind
			H.forceMove(behind)
		else
			// blink side to behind
			H.forceMove(side)
			sleep(1) // 1 tick, enough to render
			H.forceMove(behind)
	else
		// main path: side to behind
		H.forceMove(side)
		sleep(1) // 1 tick, enough to render
		H.forceMove(behind)

	// Face target
	H.setDir(get_dir(H, A))

	// Effects
	if(!A.mind)
		A.Immobilize(8 SECONDS)
		A.OffBalance(8 SECONDS)
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
		if(A.mob_biotypes != MOB_UNDEAD && prob(25))
			A.emote("huh")
	else
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	H.visible_message(
		span_boldwarning("[H] slips past [A] in a blur and appears at their back!"),
		span_notice("Too slow.")
	)

	return TRUE

// -------------------------
// STOMP
// -------------------------

/datum/status_effect/buff/skulduggery/proc/stomp_prone(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner
	H.visible_message(
			span_boldwarning("[H] delivers their foot onto [T] while they try to swing!"),
			span_notice("Deserved kick for trying that, fool!")
		)
	H.do_attack_animation(T)
	T.adjustBruteLoss(8)
	T.stamina_add(8)
	H.setDir(get_dir(H, T))

	if(!T.mind)
		T.stamina_add(12)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)
	return TRUE
	
// -------------------------
// GROUND SLAM
// -------------------------

/datum/status_effect/buff/skulduggery/proc/slam_target(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner

	var/power = H.get_skill_level(/datum/skill/combat/unarmed) + (H.get_skill_level(/datum/skill/magic/holy) / 2)
	var/resist = (T.get_stat(STAT_CONSTITUTION) + T.get_stat(STAT_SPEED)/4)

	var/chance = clamp(50 + (power - resist), 10, 90)
	if(prob(chance))
		H.stop_pulling()
		waiting_followup = FALSE
		grappled = null
		H.visible_message(
			span_boldwarning("[H] turns [T] upside their head and slams them into the ground!"),
			span_notice("<i>I drive them into the floor with sheer skill!</i>")
		)
		H.setDir(get_dir(H, T))
		H.balloon_alert_to_viewers(message = "SKD Slam!!", self_message = "SKD Slam!!", y_offset = 10)
		playsound(get_turf(T), 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 100, FALSE)
		T.Knockdown(4 SECONDS)
		sleep(3)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 4 SECONDS)
		T.adjustBruteLoss(40)
		T.stamina_add(60)
		shake_camera(H, 2, 1)
		shake_camera(T, 2, 1)
		var/da_slam = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
		playsound(T, da_slam, 100, TRUE)
		playsound(T, 'sound/combat/tf2crit.ogg', 100, TRUE)
		if(!T.mind && T.mob_biotypes != MOB_UNDEAD)
			if(prob(50))
				T.Unconscious(800)
	else
		H.visible_message(
			span_warning("[T] resists the slam, forcing [H] to kick them away!"),
			span_notice("They resist my attempt to slam! I have to kick them off!")
		)
		H.balloon_alert_to_viewers(message = "SKD Kick!!", self_message = "SKD Kick!!", y_offset = 10)
		H.setDir(get_dir(H, T))
		playsound(T, 'sound/combat/hits/punch/punch_hard (2).ogg', 100, TRUE)
		T.Knockdown(1 SECONDS)
		var/dir = turn(get_dir(T, H), 180)
		if(dir & (NORTH|SOUTH))
			dir = (dir & NORTH) ? NORTH : SOUTH
		else
			dir = (dir & EAST) ? EAST : WEST
		var/turf/current = get_turf(T)
		for(var/i = 1 to 3)
			var/turf/next = get_step(current, dir)
			if(!next || next.density)
				break
			current = next
		T.throw_at(current, 2, 4)
		waiting_followup = FALSE

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)

	grappled = null
	waiting_followup = FALSE

// -------------------------
// SLAM INTO
// -------------------------

/datum/status_effect/buff/skulduggery/proc/slam_into(mob/living/carbon/human/other)
	if(!other || !grappled) return

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/G = grappled

	H.visible_message(
		span_boldwarning("[H] redirects [G] full force into [other]!"),
		span_notice("<i>Consecutive Skulduggery! Hells yae! Bring me more!</i>")
	)
	H.balloon_alert_to_viewers(message = "Consecutive SKD!!", self_message = "Consecutive SKD!!", y_offset = 10)
	H.setDir(get_dir(H, other))
	var/attack_sound = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
	playsound(other, attack_sound, 100, TRUE)

	G.forceMove(get_turf(other))

	G.adjustBruteLoss(30)
	other.adjustBruteLoss(30)
	other.stamina_add(25)

	G.Knockdown(1 SECONDS)
	other.Knockdown(1 SECONDS)

	shake_camera(H, 2, 1)
	shake_camera(G, 2, 1)
	shake_camera(other, 2, 1)

	var/dir = turn(get_dir(other, H), 180)

	if(dir & (NORTH|SOUTH))
		dir = (dir & NORTH) ? NORTH : SOUTH
	else
		dir = (dir & EAST) ? EAST : WEST

	var/turf/current = get_turf(other)

	for(var/i = 1 to 3)
		var/turf/next = get_step(current, dir)
		if(!next || next.density)
			break
		current = next

	other.throw_at(current, 1, 4)
	waiting_followup = FALSE

	addtimer(CALLBACK(src, .proc/_slam_followup, other, G), 0.5)

	grappled = null
	waiting_followup = FALSE

/datum/status_effect/buff/skulduggery/proc/_slam_followup(mob/living/carbon/human/other, mob/living/carbon/human/G)
	if(!other || !G) return

	G.forceMove(get_turf(other))

	var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
	var/turf/T = get_step(G, pick(dirs))
	if(T && !T.density)
		G.forceMove(T)

	addtimer(CALLBACK(G, /mob/proc/slamdunked), 1)
	addtimer(CALLBACK(other, /mob/proc/slamdunked), 1)

	if(!G.mind && G.mob_biotypes != MOB_UNDEAD)
		if(prob(50))
			G.Unconscious(800)

// -------------------------
// UTILS
// -------------------------

/mob/proc/slamdunked()
	var/amp = 6
	animate(src, pixel_x = 0, time = 0)
	for(var/i in 1 to 5)
		animate(src, pixel_x = -amp, time = 1)
		animate(src, pixel_x = amp, time = 1)
		amp = round(amp * 0.6)
	animate(src, pixel_x = 0, time = 2)
