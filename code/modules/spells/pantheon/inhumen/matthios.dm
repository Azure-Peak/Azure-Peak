#define EQUALIZED_GLOW "equalizer glow"

/datum/action/cooldown/spell/matthios
	background_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	button_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	spell_color = GLOW_COLOR_MATTHIOS
	ignore_armor_penalty = TRUE
	attunement_school = null
	primary_resource_type = SPELL_COST_DEVOTION
	secondary_resource_type = SPELL_COST_STAMINA
	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	zizo_spell = TRUE
	spell_tier = 0
	point_cost = 0
	required_items = list(/obj/item/clothing/neck/roguetown/psicross)

	spell_flags = SPELL_PSYDON //He does not discriminate

//////////////////////////
// T0 - Freeman's Tools //
//////////////////////////
// This is a multi-tier miracle that at its base just provides Pocket Sand, a Bread potion and a worse Lesser Knock.

// It provides more and better tools the higher your Miracle tier skill is, all the way to Master/Legendary.

// Most of the things included here envision utility and non-combat applications, and dhe "alchemy" part offers the
// means to convert discarded adven trash and item clutter into useful things.

/datum/action/cooldown/spell/matthios/freemans_tools
	button_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	button_icon_state = "lockpick"
	name = "Freeman's Tools"
	desc = "A simple prayer to the Free-God, granting the faithful a choice of three humble tools: an orb of Sacred Fyre, the most reliable tool for thievery, or the first secrets of Malchemy."
	fluff_desc = "The first lesson of any servant of Matthios is a simple one: freedom means being given the means to choose. This humble miracle offers just that, a choice of tools to begin walking one's own path. Whether fire stolen from Astrata, the implements of a thief, or the first instruments of Malchemy, the choice is yours. Matthios merely opens the door; what you do with what lies beyond is your own."
	associated_skill = /datum/skill/magic/holy
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP
	charge_required = FALSE
	cooldown_time = 10 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	var/path = null
	var/list/item_cooldowns = list()

/datum/action/cooldown/spell/matthios/freemans_tools/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/skill = H.get_skill_level(associated_skill)

	if(!path)
		var/list/paths = list("Sunfyre", "Thievery", "Malchemy")
		if(skill >= SKILL_LEVEL_JOURNEYMAN)
			paths += "Greed"
		path = tgui_input_list(H, "Commit to a path (NOTE: ONLY ONE CHOICE!)", "Freeman's Tools", paths)
		if(!path)
			return FALSE

		switch(path)
			if("Sunfyre")
				name = "Sunfyre"
				desc = "Call upon the stolen fire of Astrata and shape it into an obedient little tool for lighting the path, or, in dire circumstances, a quick getaway by blinding your enemies with an unexpected flash."
				fluff_desc = "Matthios stole fire from the Sun-Tyrant and placed it into mortal hands. You need not understand the theft to benefit from it. Ask, and the flame comes forth."
			if("Thievery")
				name = "Thievery"
				desc = "Call upon the Free-God for a tool fit to bypass locks and open what was meant to remain closed. It can also be used to open access into Matthios's hoard, where you can draw a few extra tools to help your endeavors."
				fluff_desc = "A locked door is merely an invitation written in an inconvenient language. Matthios teaches that nothing is truly beyond reach when one has the wit, patience, and proper tools to claim it."
			if("Malchemy")
				name = "Malchemy"
				desc = "Invoke the First Law and receive a vessel through which all value of Psydonia may be dissolved, stored, and exchanged into other substances."
				fluff_desc = "The First Law is simple: nothing is created and nothing is lost. Value merely changes shape. What distant alchemists spent lifetimes pursuing, Malchem once accomplished with casual certainty. Matthios preserves a fragment of that old truth for those willing to use it."
			if("Greed")
				desc = "Take freely from the three humble tools of Matthios, choosing whichever serves your immediate purpose."
				fluff_desc = "The Free-God does not begrudge the ambitious. Why choose one road when you possess the means to walk all three? Take what you need, and let Matthios collect His due in time."

	if(path == "Greed")
		var/list/choices = list("Sunfyre", "Thievery", "Malchemy")
		var/greed_choice = tgui_input_list(H, "Choose your tool", "Freeman's Tools", choices)
		if(!greed_choice)
			return FALSE

		switch(greed_choice)
			if("Sunfyre")
				if(item_cooldowns["Greed Sunfyre"] > world.time)
					var/remaining = round((item_cooldowns["Greed Sunfyre"] - world.time) / 10)
					var/minutes = floor(remaining / 60)
					var/seconds = remaining % 60
					if(minutes)
						to_chat(H, span_warning("This tool is still cooling down for [minutes]m [seconds]s!"))
					else
						to_chat(H, span_warning("This tool is still cooling down for [seconds]s!"))
					return FALSE

				var/obj/item/flashlight/flare/torch/lantern/astrata/fire_orb = new /obj/item/flashlight/flare/torch/lantern/astrata(H.drop_location())
				if(!fire_orb)
					return FALSE
				fire_orb.volatile = TRUE
				fire_orb.aura_color = "#fff346"
				H.put_in_hands(fire_orb)
				H.say("Divine fyre, to me!")
				item_cooldowns["Greed Sunfyre"] = world.time + 2 MINUTES

			if("Thievery")
				var/obj/item/lockpick/gilded/lockpick = new /obj/item/lockpick/gilded(H.drop_location())
				if(!lockpick)
					return FALSE
				var/picklvl = 0
				var/max_integrity = 10
				if(skill >= SKILL_LEVEL_JOURNEYMAN)
					picklvl = 1
					max_integrity += 10
				if(skill >= SKILL_LEVEL_EXPERT)
					picklvl = 2
					max_integrity += 90
				lockpick.picklvl = picklvl
				lockpick.max_integrity = max_integrity
				lockpick.obj_integrity = max_integrity
				H.put_in_hands(lockpick)
				H.say("#Lord of Freedom, I beseeth a tool of liberation!")

			if("Malchemy")
				var/obj/item/matthios_canister/firstlaw/malchem = new /obj/item/matthios_canister/firstlaw(H.drop_location())
				if(!malchem)
					return FALSE
				H.put_in_hands(malchem)
				H.say("#Lord of Exchange, I shall finish thy work!")

		StartCooldown()
		return TRUE

	switch(path)
		if("Sunfyre")
			var/obj/item/flashlight/flare/torch/lantern/astrata/fire_orb = new /obj/item/flashlight/flare/torch/lantern/astrata(H.drop_location())
			if(!fire_orb)
				return FALSE
			if(skill >= SKILL_LEVEL_EXPERT)
				fire_orb.volatile = TRUE
				fire_orb.aura_color = "#fff346"
			H.put_in_hands(fire_orb)
			H.say("Divine fyre, to me!")
			cooldown_time = 2 MINUTES

		if("Thievery")
			var/obj/item/lockpick/gilded/lockpick = new /obj/item/lockpick/gilded(H.drop_location())
			if(!lockpick)
				return FALSE
			var/picklvl = 0
			var/max_integrity = 10
			if(skill >= SKILL_LEVEL_JOURNEYMAN)
				picklvl = 1
				max_integrity += 10
			if(skill >= SKILL_LEVEL_EXPERT)
				picklvl = 2
				max_integrity += 90
			lockpick.picklvl = picklvl
			lockpick.max_integrity = max_integrity
			lockpick.obj_integrity = max_integrity
			H.put_in_hands(lockpick)
			H.say("#Lord of Freedom, I beseeth a tool of liberation!")

		if("Malchemy")
			var/obj/item/matthios_canister/firstlaw/fl = new /obj/item/matthios_canister/firstlaw(H.drop_location())
			if(!fl)
				return FALSE
			H.put_in_hands(fl)
			H.say("#Lord of Exchange, I shall finish thy work!")

	StartCooldown()
	return TRUE

///////////////////
//T1 - Mammonite //
///////////////////
//Uses up to 200 Mammon to deal damage with equivalent armor penetration on your next strike. Can't get simpler than that.
//if you toast more than 80 mammon (I.E, Strong stance), you have a chance to gib NPCs. Let's go gambling.

/datum/action/cooldown/spell/matthios/mammonite
	name = "Mammonite"
	desc = "Invoke Matthios's name and invest 10 to 200 mammon from your possessions and treasury into your next strike (based on your intent, min. 'Weak', max. 'Strong'). The attack penetrates armor equal to 75% of the mammon spent and grows stronger with the value of the offering. Offering over 80 mammon in one strike has a chance to obliterate the mindless."
	fluff_desc = "The faithful tell of a merchant cornered by death, bereft of allies, steel, and hope. With nothing left but his fortune and his faith in Matthios, he offered both in desperate prayer. The coins vanished, and in their place came strength enough to fell those who would have slain him. Thus Mammonite serves as a reminder that wealth is never truly powerless in the hands of the devoted. Through greed, you proliferate His ambition, His name."

	button_icon_state = "mammonite"
	glow_intensity = GLOW_INTENSITY_MEDIUM
	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = "shout"
	charge_required = FALSE
	cooldown_time = 25 SECONDS

	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/min_mammon = 10
	var/max_mammon = 200

/datum/action/cooldown/spell/matthios/mammonite/cast(atom/cast_on)
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!H.cmode)
		to_chat(H, span_warning("I need some adrenaline pumping for this, my good sire!"))
		return FALSE

	if(H.has_status_effect(/datum/status_effect/buff/mammonite))
		to_chat(H, span_warning("Matthios' truth already lays claim to my next strike."))
		return FALSE

	var/bank = 0
	if(SStreasury.has_account(H))
		bank = SStreasury.get_balance(H)

	var/onhand = get_mammons_in_atom(H)
	var/total = bank + onhand

	var/list/range = get_investment_range(H)
	var/min_invest = range[1]
	var/max_invest = range[2]

	if(total < min_invest)
		to_chat(H, span_warning("I lack the wealth to invoke Matthios' favor... ([min_invest] mammon needed for [H.rmb_intent.name] stance.)"))
		return FALSE

	var/mammon_used = rand(min_invest, max_invest)
	mammon_used = min(mammon_used, total)

	var/list/invocations = list(
		"Gold to glory! Wealth, guide my hand!",
		"Wealth be spent, and power be gained!",
		"My hoard bleeds for strength, in His name!",
		"A king's ransom for a single blow!",
		"Roar! The weight of mine greed!",
	)

	H.say(pick(invocations), forced = invocation_type)

	var/remaining = mammon_used

	var/from_inventory = 0
	var/from_bank = 0

	var/drained_onhand = min(onhand, remaining)
	if(drained_onhand > 0)
		from_inventory = remove_mammons_from_atom(H, drained_onhand)
		remaining -= from_inventory

	if(remaining > 0 && SStreasury.has_account(H))
		from_bank = min(remaining, SStreasury.get_balance(H))

		if(from_bank > 0)
			SStreasury.burn(SStreasury.get_account(H), from_bank, "Meister reports the Mammon is missing. Is this true?")

		remaining -= from_bank

	var/datum/status_effect/buff/mammonite/E = H.apply_status_effect(/datum/status_effect/buff/mammonite)
	if(E)
		E.bonus_damage = round(mammon_used * 3)
		E.cap = max_mammon

	var/source_text = ""

	if(from_inventory > 0 && from_bank > 0)
		source_text = "MATTHIOS claims [from_inventory] from my possessions and [from_bank] from my treasury!"
	else if(from_inventory > 0)
		source_text = "MATTHIOS claims [from_inventory] from my possessions!"
	else if(from_bank > 0)
		source_text = "MATTHIOS claims [from_bank] from my treasury!"

	H.visible_message(span_danger("[H]'s weapon gleams with a greedy golden light!"), span_notice("I invest [mammon_used] mammon into my next strike. [source_text]"))

	playsound(get_turf(H), 'sound/magic/antimagic.ogg', 60, TRUE)

	return TRUE

///////////////////
// T2 - Transact //
///////////////////

/datum/action/cooldown/spell/matthios/transact
	name = "Transact"
	desc = "Sacrifice an item in your hand, applying a heal over time to yourself with strenght depending on its value."
	button_icon_state = "transact"
	sound = 'sound/effects/hood_ignite.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_SHOUT
	invocations = list("Transaction for a lyfe!")

	charge_required = FALSE
	cooldown_time = 45 SECONDS

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/matthios/transact/cast(atom/cast_on)
	. = ..()

	var/obj/item/held_item = owner.get_active_held_item()
	if(!held_item)
		to_chat(owner, span_info("I need something of value to make a transaction..."))
		return
	var/helditemvalue = held_item.get_real_price()
	if(!helditemvalue)
		to_chat(owner, span_info("This has no value, It will be of no use in such a transaction."))
		return
	if(helditemvalue<10)
		to_chat(owner, span_info("This has little value, It will be of no use in such a transaction."))
		return
	if(isliving(cast_on))
		var/mob/living/target = cast_on
		owner.visible_message(span_notice("The transaction is made! [target] is bathed in a golden light!"))
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/datum/status_effect/buff/healing/heal_effect = C.apply_status_effect(/datum/status_effect/buff/healing)
			if(heal_effect)
				heal_effect.healing_on_tick = helditemvalue / 2
			playsound(owner, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
			if(istype(held_item, /obj/item/rogueweapon))
				to_chat(owner, "<font color='yellow'>[held_item] melts at its very fabric turning it into a heap of scrap. My transaction is accepted.</font>")
				held_item.obj_break(TRUE)
				held_item.sellprice = 1
			else
				to_chat(owner, "<font color='yellow'>[held_item] is engulfed in unholy flame and dissipates into ash. My transaction is accepted.</font>")
				qdel(held_item)
		else
			target.adjustBruteLoss(helditemvalue/2)
			target.adjustFireLoss(helditemvalue/2)
			playsound(owner, 'sound/combat/hits/burn (2).ogg', 100, TRUE)
			if(istype(held_item, /obj/item/rogueweapon))
				to_chat(owner, "<font color='yellow'>[held_item] melts at its very fabric turning it into a heap of scrap. My transaction is accepted.</font>")
				held_item.obj_break(TRUE)
				held_item.sellprice = 1
			else
				to_chat(owner, "<font color='yellow'>[held_item] is engulfed in unholy flame and dissipates into ash. My transaction is accepted.</font>")
				qdel(held_item)
		return TRUE
	return FALSE


/////////////////
// T2 - Barter //
/////////////////

/datum/action/cooldown/spell/matthios/barter
	name = "Barter"
	desc = "Offer the targeted item to your patron, in exchange for a sum of mammon, scaling with my expertise in holy skill. The capricious nature of Matthios makes this a poor value exchange, all in all."
	button_icon_state = "barter"
	sound = null

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 35 SECONDS

	spell_requirements = SPELL_REQUIRES_SAME_Z

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

/datum/action/cooldown/spell/matthios/barter/cast(atom/cast_on)
	. = ..()
	if(!istype(cast_on, /obj/item))
		to_chat(owner, span_warning("This is not a suitable item to Barter with."))
		return FALSE
	var/obj/item/I = cast_on
	var/item_value = I.get_real_price()
	if(item_value < 2)
		to_chat(owner, span_warning("This thing is worthless."))
		return FALSE
	if(I.GetComponent(/datum/component/martyrweapon))
		to_chat(owner, span_danger("My divine energies recoil from the relic! It resists!"))
		return TRUE	//why did you try this? Go on full CD, bad.
	if(I.override_state)	//-some- reskinned triumph kit weapons / -some- donor weapons, active martyr weapon
		to_chat(owner, span_warning("This thing has been glamoured or changed -- its value is too unclear."))
		return FALSE
	if(I.GetComponent(/datum/component/holster))
		var/datum/component/holster/SC = I.GetComponent(/datum/component/holster)
		if(SC.sheathed)
			to_chat(owner, span_warning("I should empty it, first."))
			return FALSE
	if((istype(I, /obj/item/rogueweapon) || istype(I, /obj/item/clothing)))
		if(!(I.type in barter_whitelist))
			to_chat(owner, span_warning("Weapons and clothing do not appease my Patron, He is not lacking in fashion."))
			return FALSE

	var/delay = 1 SECONDS
	delay += round((item_value / 50) SECONDS)
	if(I.Adjacent(owner))
		if(do_after(owner, delay))
			if(I.Adjacent(owner))	//We make sure it didnt' get yoinked after the delay.
				var/ratio = 0.4 + ((owner.get_skill_level(associated_skill)) * 0.05)
				var/mammonreward = round(item_value * ratio)
				var/turf/T = get_turf(I)
				new /obj/effect/temp_visual/barter_fx(T)
				addtimer(CALLBACK(src, PROC_REF(process_barter), mammonreward, owner, T), 0.3 SECONDS)	//fluffy delay to make it sync up with the barter_fx.
				if(I.GetComponent(/datum/component/storage))
					var/datum/component/storage/ST = I.GetComponent(/datum/component/storage)
					if(!ST.do_quick_empty(T))
						return FALSE
				qdel(I)

/datum/action/cooldown/spell/matthios/barter/proc/process_barter(mammon, mob/user, turf/target_turf)
	playsound(target_turf, 'sound/effects/matth_barter.ogg', 100, TRUE)
	budget2change(mammon, user, putinhands = FALSE, custom_turf = target_turf)

/datum/action/cooldown/spell/matthios/barter_secular
	name = "Secular Barter" //rebased, mostly copypasta but with some differences
	desc = "Your contacts allow you to find a buyer for most items, though it at a lesser rate than reputable merchants"
	background_icon = 'icons/mob/actions/antiquarianspells.dmi'
	button_icon = 'icons/mob/actions/antiquarianspells.dmi'
	button_icon_state = "secularbarter"
	sound = null
	associated_skill = /datum/skill/misc/reading

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT


	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_NONE

	charge_required = FALSE
	cooldown_time = 35 SECONDS

	spell_requirements = SPELL_REQUIRES_SAME_Z
	required_items = null

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

/datum/action/cooldown/spell/matthios/barter_secular/cast(atom/cast_on)
	. = ..()
	if(!istype(cast_on, /obj/item))
		to_chat(owner, span_warning("This is not a suitable item to Barter with."))
		return FALSE
	var/obj/item/I = cast_on
	var/item_value = I.get_real_price()
	if(item_value < 2)
		to_chat(owner, span_warning("This thing is worthless."))
		return FALSE
	if(I.override_state)	//-some- reskinned triumph kit weapons / -some- donor weapons, active martyr weapon
		to_chat(owner, span_warning("This thing has been glamoured or changed -- its value is too unclear."))
		return FALSE
	if(I.GetComponent(/datum/component/holster))
		var/datum/component/holster/SC = I.GetComponent(/datum/component/holster)
		if(SC.sheathed)
			to_chat(owner, span_warning("I should empty it, first."))
			return FALSE
	if((istype(I, /obj/item/rogueweapon) || istype(I, /obj/item/clothing)))
		if(!(I.type in barter_whitelist))
			to_chat(owner, span_warning("Arms and armor are too difficult to fence on the market, best stick to valuables."))
			return FALSE
	if(!SStreasury.has_account(owner))
		to_chat(owner, span_warning("Your contacts can't pay you without a registered treasury account. Visit a Meister."))
		return FALSE

	var/delay = 1 SECONDS
	delay += round((item_value / 50) SECONDS)
	if(I.Adjacent(owner))
		if(do_after(owner, delay))
			if(I.Adjacent(owner))	//We make sure it didnt' get yoinked after the delay.
				var/ratio = 0.4 + ((owner.get_skill_level(associated_skill)) * 0.05)
				var/mammonreward = round(item_value * ratio)
				var/turf/T = get_turf(I)
				new /obj/effect/temp_visual/barter_fx(T)
				addtimer(CALLBACK(src, PROC_REF(process_secularbarter), mammonreward, owner, T), 0.3 SECONDS)	//fluffy delay to make it sync up with the barter_fx.
				if(I.GetComponent(/datum/component/storage))
					var/datum/component/storage/ST = I.GetComponent(/datum/component/storage)
					if(!ST.do_quick_empty(T))
						return FALSE
				qdel(I)
				owner.visible_message(span_info("[owner] markets [I] off to [owner.p_their()] contacts."), span_danger("Fencing off [I] to your contacts, [mammonreward] mammons are transferred to your account."))
				var/datum/fund/account = SStreasury.get_account(owner)
				SStreasury.mint(account, mammonreward, "interstate mammon transfer")

/datum/action/cooldown/spell/matthios/barter_secular/proc/process_secularbarter(mammon, mob/user, turf/target_turf)
	playsound(target_turf, 'sound/effects/secularbarter.ogg', 100, TRUE)


///////////////////
// T3 - Equalize //
///////////////////

/datum/action/cooldown/spell/matthios/equalize
	name = "Equalize"
	desc = "Create equality, with a thumb on the scales, with your target. Siphon strength, speed, and constitution from them."
	button_icon_state = "equalize"
	sound = 'sound/magic/swap.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 4 SECONDS
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 6 MINUTES

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/matthios/equalize/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	var/mob/living/target = cast_on
	if(isliving(cast_on))
		if(spell_guard_check(cast_on, TRUE))
			cast_on.visible_message(span_warning("[cast_on] resists EQUALITY!"))
			return TRUE
		if(HAS_TRAIT(target, TRAIT_NOBLE))
			target.apply_status_effect(/datum/status_effect/debuff/equalizedebuff_noble)
			user.apply_status_effect(/datum/status_effect/buff/equalizebuff)//Same buff but they get punished harder
			return TRUE
		else
			target.apply_status_effect(/datum/status_effect/debuff/equalizedebuff)
			user.apply_status_effect(/datum/status_effect/buff/equalizebuff)
			return TRUE
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

////////////////////////
// T4 - Churn Wealthy //
////////////////////////

/datum/action/cooldown/spell/matthios/churn
	name = "Churn Wealthy"
	desc = "Attacks the target by weight of their greed, dealing increased damage and effects depending on how wealthy they are."
	button_icon_state = "churnwealthy"
	sound = null //Handled on cast

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY

	secondary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	invocation_type = INVOCATION_NONE //Handled on cast
	invocations = null

	charge_required = TRUE
	charge_time = 5 SECONDS
	charge_slowdown = 2
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 10 MINUTES

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/matthios/churn/cast(atom/cast_on)
	. = ..()
	if(ishuman(cast_on))
		var/mob/living/carbon/human/target = cast_on

		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] resists the weight of their greed!"))
			return TRUE
		var/mammonsonperson = get_mammons_in_atom(target)
		var/mammonsinbank = SStreasury.get_balance(target)
		var/totalvalue = mammonsinbank + mammonsonperson
		if(HAS_TRAIT(target, TRAIT_NOBLE))
			totalvalue += 101 // We're ALWAYS going to do a medium level smite minimum to nobles.
		if(HAS_TRAIT(target, TRAIT_FREEMAN))
			totalvalue -= 50 // We do little bit less damage to other Matthiosites
		switch(totalvalue)
			if(0 to 10)
				to_chat(owner, "<font color='yellow'>[target] one has no wealth to hold against them.</font>")
				return FALSE
			if(11 to 30)
				owner.say("Wealth becomes woe!")
				target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
				target.adjustFireLoss(30)
				playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
			if(31 to 60)
				owner.say("Wealth becomes woe!")
				target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
				target.adjustFireLoss(60)
				playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
			if(61 to 100)
				owner.say("Wealth becomes woe!")
				target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth burning at my soul!"))
				target.adjustFireLoss(80)
				target.Stun(20)
				playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
			if(101 to 200)
				owner.say("The Free-God rebukes!")
				target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth tearing at my soul!"))
				target.adjustFireLoss(100)
				target.adjust_fire_stacks(7, /datum/status_effect/fire_handler/fire_stacks/divine)
				target.Stun(20)
				target.ignite_mob()
				playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
			if(201 to 500)
				owner.say("The Free-God rebukes!")
				target.visible_message(span_danger("[target] is burned by holy light!"), span_userdanger("I feel the weight of my wealth tearing at my soul!"))
				target.adjustFireLoss(120)
				target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
				target.ignite_mob()
				target.Stun(40)
				playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
			if(500 to 2500)
				target.visible_message(span_danger("[target] is smited with holy light!"), span_userdanger("I feel the weight of my wealth rend my soul apart!"))
				owner.say("Your final transaction! The Free-God rebukes!!")
				target.Stun(60)
				target.emote("agony")
				target.adjustFireLoss(140)
				target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
				target.ignite_mob()
				playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
				explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
			if(2501 to 9999999) //THE POWER OF MY STAND: 'EXPLODE AND DIE INSTANTLY'
				target.visible_message(span_danger("[target]'s skin begins to SLOUGH AND BURN HORRIFICALLY, glowing like molten metal!"), span_userdanger("MY LIMBS BURN IN AGONY..."))
				owner.say("Wealth beyond measure- YOUR FINAL TRANSACTION!!")
				target.Stun(80)
				target.emote("agony")
				target.adjustFireLoss(50)
				target.adjust_fire_stacks(9, /datum/status_effect/fire_handler/fire_stacks/divine)
				target.ignite_mob()
				playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
				explosion(get_turf(target), light_impact_range = 1, flame_range = 1, smoke = FALSE)
				sleep(80)

				target.visible_message(span_danger("[target]'s limbs REND into coin and gem!"), span_userdanger("WEALTH. POWER. THE FINAL SIGHT UPON MYNE EYE IS A DRAGON'S MAW TEARING ME IN TWAIN. MY ENTRAILS ARE OF GOLD AND SILVER."))			//this one's actually pretty good. i like this
				playsound(owner, 'sound/magic/churn.ogg', 100, TRUE)
				playsound(owner, 'sound/magic/whiteflame.ogg', 100, TRUE)
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

///////////////////
// T? - Appraise //
///////////////////
//Unused besides the secular part

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
	associated_skill = /datum/skill/misc/reading
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
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
		var/mammonsinbank = SStreasury.get_balance(target)
		var/totalvalue = mammonsinbank + mammonsonperson
		to_chat(user, ("<font color='yellow'>[target] has [mammonsonperson] mammons on them, [mammonsinbank] in their meister, for a total of [totalvalue] mammons.</font>"))


///////////////
// T? - Raze //
///////////////
//Meant for specific roles rather than generally be avaiable, dragon aspect or smthing.

/datum/action/cooldown/spell/matthios/raze // Shamelessly steals Wither's cool code / Originally from Racial Perk PR for drakians
	name = "Raze"
	desc = "Exhale a cone of stolen fyre before you, scorching enemies and igniting the ground. Damage increases with Holy Skill. These flames are also strong enough to turn unworthy corpses into ashes and dust."
	fluff_desc = "Some legends claim Matthios to be the origin of dragonkind itself. Whether innate gift or Malchem synthesis, most worshippers of the Free God can naturally give voice to His stolen fyre. A gentle puff of a whisper to some, a roaring inferno to others."
	button_icon_state = "breath"
	sound = 'sound/misc/bamf.ogg'
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 2 MINUTES
	charge_required = TRUE
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_time = 1 SECONDS
	primary_resource_type = SPELL_COST_ENERGY//So lirvans can use it
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_MIRACLE_MINOR

	associated_skill = /datum/skill/magic/holy
	var/delay = 12
	var/strike_delay = 2
	var/damage = 20
	var/cone_range = 3
	var/familiar = FALSE

/datum/action/cooldown/spell/matthios/raze/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE
	var/turf/source_turf = get_turf(user)

	if(T.z != user.z)
		return FALSE

	var/direction = get_dir(source_turf, T)

	for(var/distance = 1, distance <= cone_range, distance++)
		var/list/current_wave = list()
		var/turf/center = source_turf

		for(var/i = 1, i <= distance, i++)
			center = get_step(center, direction)

		if(!center)
			continue

		current_wave += center

		var/width = distance - 1

		var/left_dir
		var/right_dir

		switch(direction)
			if(NORTH, SOUTH)
				left_dir = WEST
				right_dir = EAST
			if(EAST, WEST)
				left_dir = NORTH
				right_dir = SOUTH
			if(NORTHEAST, SOUTHWEST)
				left_dir = NORTHWEST
				right_dir = SOUTHEAST
			if(NORTHWEST, SOUTHEAST)
				left_dir = NORTHEAST
				right_dir = SOUTHWEST

		for(var/offset = 1, offset <= width, offset++)
			var/turf/L = center
			var/turf/R = center

			for(var/j = 1, j <= offset, j++)
				L = get_step(L, left_dir)
				R = get_step(R, right_dir)

			if(L)
				current_wave |= L
			if(R)
				current_wave |= R

		var/tile_delay = delay + (strike_delay * (distance - 1))

		for(var/turf/affected_turf in current_wave)
			if(!(affected_turf in view(source_turf)))
				continue

			new /obj/effect/temp_visual/telegraph/firebreath(affected_turf, tile_delay)
			addtimer(CALLBACK(src, PROC_REF(ignite), affected_turf), tile_delay)

	user.visible_message(span_yellow("[user] sharply exhales, breathing out a cloud of fyre!"))
	user.Immobilize(15)

	return TRUE

/datum/action/cooldown/spell/matthios/raze/proc/ignite(turf/damage_turf)
	new /obj/effect/temp_visual/firebreath_actual(damage_turf)
	playsound(damage_turf, 'sound/magic/fireball.ogg', 50, TRUE)

	for(var/mob/living/L in damage_turf)
		if(L == usr)
			continue
		var/total_damage = (damage + (usr.get_skill_level(associated_skill, 15)))
		L.adjustFireLoss(total_damage) // Just straight damage, no firestacks or ignite
		to_chat(L, span_userdanger("You're scorched by flames!"))

		// Vaporize dead NPC / departed player corpses
		if(L.stat == DEAD)
			if(!L.mind || (!L.key && !L.get_ghost(FALSE, TRUE)))
				addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living, dust)), 2 SECONDS)

	new /obj/effect/hotspot(damage_turf) // This is the actual scary part

/obj/effect/temp_visual/telegraph/firebreath
	icon = 'icons/effects/effects.dmi'
	icon_state = "impact_bullet"
	duration = 10 SECONDS
	layer = MASSIVE_OBJ_LAYER
	plane = GAME_PLANE

/obj/effect/temp_visual/firebreath_actual
	icon = 'icons/effects/fire.dmi'
	icon_state = "2"
	light_outer_range = 2
	light_color = "#FF6A00"
	duration = 1 SECONDS
