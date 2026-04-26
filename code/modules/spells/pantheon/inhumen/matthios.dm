#define EQUALIZED_GLOW "equalizer glow"

//////////////////////////
// T0 - Freeman's Tools //
//////////////////////////
// This is a multi-tier miracle that at its base just provides Pocket Sand, a Bread potion and a worse Lesser Knock.

// It provides more and better tools the higher your Miracle tier skill is, all the way to Master/Legendary.

// Most of the things included here envision utility and non-combat applications, and dhe "alchemy" part offers the
// means to convert discarded adven trash and item clutter into useful things.

/datum/action/cooldown/spell/freemans_tools
	button_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	button_icon_state = "lockpick"
	name = "Freeman's Tools"
	desc = "A simple prayer to the Free-God Matthios, for tools of liberation or transaction.<br><br>His will manifests in three forms: gutter-born tricks of want, gilded tools of blessed liberation, or by granting the bases of Malchem, a form of primordial alchemy so impossible it is oft mistaken for sorcery."
	associated_skill = /datum/skill/magic/holy
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP
	charge_required = FALSE
	cooldown_time = 10 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	var/list/options = list(
		//a simple 'blinds u for 1 sec' throwable
		"Pocket Sand" = list(
			path = /obj/item/impact_grenade/pocketsand,
			m_cooldown = 60 SECONDS,
			m_devotion = 10,
			m_rank = SKILL_LEVEL_NOVICE,
			category = "Rogue Arts",
			lines = list("Dust to blind thee!", "A handful of freedom!", "A gift for thee!", "Mind yer eyes!", "This always works like a miracle!")
		),
		//basically just lesser knock
		"Gilded Lockpick" = list(
			path = /obj/item/melee/touch_attack/lesserknock/matthios,
			m_cooldown = 5 SECONDS,
			m_devotion = 10,
			m_rank = SKILL_LEVEL_NOVICE,
			category = "Gilded Tools",
			lines = list("#By thine hands...", "#No locks shall bar the free!", "#Thine tool shall bring liberation!", "#Matthios, shatter my locks!")
		),
		//rip the bag of bribery, say hello to pouch of smuggling
		"Pouch of Smuggling" = list(
			path = /obj/item/storage/belt/rogue/pouch/matthios,
			m_cooldown = 10 MINUTES,
			m_devotion = 100,
			m_rank = SKILL_LEVEL_NOVICE,
			category = "Rogue Arts",
			lines = list("#Let me begin your work!", "#Matthios, protect my well-deserved goods!", "#Grant me protection against those tyrant knaves!", "#Matthios, ordain me your blessed storage!")
		),
		//like a pouch of smuggling, but smugglier
		"Bag of Smuggling" = list(
			path = /obj/item/storage/backpack/rogue/backpack/matthios,
			m_cooldown = -1,
			m_devotion = 100,
			m_rank = SKILL_LEVEL_APPRENTICE,
			category = "Rogue Arts",
			lines = list("#Let me begin your work!", "#Matthios, protect my well-deserved goods!", "#Grant me protection against those tyrant knaves!", "#Matthios, ordain me your blessed storage!")
		),
		//makes failed lockpicking attempts muffled
		"Gilded Dexterous Gloves" = list(
			path = /obj/item/clothing/gloves/roguetown/fingerless_leather/muffle_matthios,
			m_cooldown = 5 MINUTES,
			m_devotion = 200,
			m_rank = SKILL_LEVEL_JOURNEYMAN,
			category = "Gilded Tools",
			lines = list("#Hands of trade, be silent.", "#Let fingers dance for thy amusement.", "#Dexterity bought in faith.")
		),
		//makes your footsteps muffled
		"Gilded Muffled Boots" = list(
			path = /obj/item/clothing/shoes/roguetown/boots/muffle_matthios,
			m_cooldown = 5 MINUTES,
			m_devotion = 100,
			m_rank = SKILL_LEVEL_APPRENTICE,
			category = "Gilded Tools",
			lines = list("#Steps unheard, as I walk in thy shadow.", "#Silent as coin slipping, for thy hoard.", "#No sound, no chain, no better wisdom, O' Lord.")
		),
		//enables piss night vision and sets your lockpick timer to 3 secs, makes you insane over time and prolonged use
		"Gilded Lockpicking Specs" = list(
			path = /obj/item/clothing/mask/rogue/spectacles/matthios,
			m_cooldown = -1, // this is too stronk, so only 1 allowed
			m_devotion = 200,
			m_rank = SKILL_LEVEL_EXPERT,
			category = "Gilded Tools",
			lines = list("#Guide my sight, O' Matthios.","#Through pins and wards, thy Free eyes see.","#No door shall be between me and truth.")
		),
		//normal chains that bind nobility faster
		"Gilded Chains" = list(
			path = /obj/item/rope/chain/matthios,
			m_cooldown = 10 MINUTES,
			m_devotion = 200,
			m_rank = SKILL_LEVEL_JOURNEYMAN,
			category = "Gilded Tools",
			lines = list("Matthios! Chains for the tyrants!", "Matthios! Transact me thy chains!", "Lord of Freedom, chains for the unworthy!")
		),
		//enables thieves' cant when worn on neck
		"Gilded Amulet of Matthios" = list(
			path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gilded,
			m_cooldown = 30 MINUTES,
			m_devotion = 100,
			m_rank = SKILL_LEVEL_NONE,
			category = "Gilded Tools",
			lines = list("#Matthios, let thine will be done.", "#Lord of Exchange, my soul is yours.", "#God of the Stolen Fyre, thou will be done.")
		),
		//miralchemy mode on
		"Vial of Firstlaw" = list(
			path = /obj/item/matthios_canister/firstlaw,
			m_cooldown = 1 MINUTES,
			m_devotion = 100,
			m_rank = SKILL_LEVEL_NOVICE,
			category = "Malchem Vials",
			lines = list("#Matthios, provide the base, I shall complete thy work!", "#Matthios! Deliver unto me the truth of alchemy!", "#Lord of Exchange, I shall finish thy work!")
		),
		//turns 10 organic items into 1 rich food of choice (that will often be burned mess or bread if you're not starving to death)
		"Vial of Kingsfeast Base" = list(
			path = /obj/item/matthios_canister/kingsfeast,
			m_cooldown = 2 MINUTES,
			m_devotion = 50,
			m_rank = SKILL_LEVEL_NOVICE,
			category = "Malchem Vials",
			lines = list("#Matthios, provide the base, I shall complete thy work!", "#Matthios! Deliver unto me the truth of alchemy!", "#Lord of Exchange, I shall finish thy work!")
		),
		//basically turns water or fruits into wine, if used with blood or lux instead, becomes Kingsblood
		"Vial of Kingswine Base" = list(
			path = /obj/item/matthios_canister/kingswine,
			m_cooldown = 2 MINUTES,
			m_devotion = 50,
			m_rank = SKILL_LEVEL_NOVICE,
			category = "Malchem Vials",
			lines = list("#Matthios, provide the base, I shall complete thy work!", "#Matthios! Deliver unto me the truth of alchemy!", "#Lord of Exchange, I shall finish thy work!")
		),
		//makes you honk shoo mimimi, while restoring energy over time
		"Vial of Goodnite Base" = list(
			path = /obj/item/matthios_canister/goodnite,
			m_cooldown = 2 MINUTES,
			m_devotion = 50,
			m_rank = SKILL_LEVEL_APPRENTICE,
			category = "Malchem Vials",
			lines = list("#Matthios, provide the base, I shall complete thy work!", "#Matthios! Deliver unto me the truth of alchemy!", "#Lord of Exchange, I shall finish thy work!")
		),
		//a 4 use vial of mending
		"Vial of Warsmith Base" = list(
			path = /obj/item/matthios_canister/warsmith,
			m_cooldown = 2 MINUTES,
			m_devotion = 50,
			m_rank = SKILL_LEVEL_JOURNEYMAN,
			category = "Malchem Vials",
			lines = list("#Matthios, provide the base, I shall complete thy work!", "#Matthios! Deliver unto me the truth of alchemy!", "#Lord of Exchange, I shall finish thy work!")
		),
		// idk what else, but it should be used by baothans, something they'll want a lot
/*		"Vial of Liquid Desire Base" = list(
			path = /obj/item/matthios_canister/baotha,
			m_cooldown = 10 MINUTES,
			m_rank = SKILL_LEVEL_MASTER,
			category = "Malchem Vials",
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),
		// same idea but graggarites
		"Vial of Liquid Bloodlust Base" = list(
			path = /obj/item/matthios_canister/graggar,
			m_cooldown = 10 MINUTES,
			m_rank = SKILL_LEVEL_MASTER,
			category = "Malchem Vials",
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),
		// same idea but zizoids
		"Vial of Liquid Progress Base" = list(
			path = /obj/item/matthios_canister/zizo,
			m_cooldown = 10 MINUTES,
			m_rank = SKILL_LEVEL_MASTER,
			category = "Malchem Vials",
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),
		// the og idea was to make this deconvert nobles but idk now
		"Vial of Liquid Freedom Base" = list(
			path = /obj/item/matthios_canister/matthios,
			m_cooldown = 10 MINUTES,
			m_rank = SKILL_LEVEL_MASTER,
			category = "Malchem Vials",
			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
		),*/

		// a spicy, explosive, very, very difficult-to-make revive vial, uses all herbs in the world and 1 of any lux type
		"Vial of Lyfestruth Base" = list(
			path = /obj/item/matthios_canister/lyfestruth,
			m_cooldown = 30 MINUTES,
			m_devotion = 100,
			m_rank = SKILL_LEVEL_EXPERT,
			category = "Malchem Vials",
			lines = list("#Matthios, provide the base, I shall complete thy work!", "#Matthios! Deliver unto me the truth of alchemy!", "#Lord of Exchange, I shall finish thy work!")
		),
		// a spicy, explosive grenade that ignites over a massive area, making tennites and nobles roll in agony and go insane
		// but in my BETTER JUDGEMENT, this is just my early april fools joke, go to sleep my child
//		"Vial of Truthsnuke Base" = list(
//			path = /obj/item/matthios_canister/truthsnuke,
//			m_cooldown = -1, // single use
//			m_rank = SKILL_LEVEL_MASTER, // exclusive to devotee missionary/heretics
//			category = "Malchem Vials",
//			lines = list("Matthios, provide the base, I shall complete thy work!", "Matthios! Deliver unto me the truth of alchemy!", "Lord of Exchange, I shall finish thy work!")
//		),
		// MIGHT be enough tools but this thing here lets anyone add anything as much as they want, have fun!
		// I'll probably reuse this as a template for a Zizo Artificery miracle in the future.
	)

	var/list/item_cooldowns = list()

/datum/action/cooldown/spell/freemans_tools/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/skill = H.get_skill_level(associated_skill)

	// FILTER VALID OPTIONS
	var/list/valid = list()
	for(var/name in options)
		var/list/entry = options[name]
		if(!islist(entry))
			continue
		if(skill >= entry["m_rank"])
			valid[name] = entry

	if(!valid.len)
		return FALSE

	// CATEGORY SELECTION
	var/list/categories = list(
		"Rogue Arts",
		"Gilded Tools",
		"Malchem Vials"
	)

	var/category = tgui_input_list(H, "Choose your path", "Freeman's Tools", categories)
	if(!category)
		return FALSE

	// BUILD DISPLAY LIST
	var/list/display = list()

	for(var/name in valid)
		var/list/entry = valid[name]

		if(entry["category"] != category)
			continue

		var/cd = item_cooldowns[name]
		var/display_name

		var/devotion_cost = entry["m_devotion"] || 0

		if(cd == -1)
			display_name = "[name] (UNAVAILABLE)"
		else
			var/time_left = cd ? max(0, cd - world.time) : 0
			if(time_left > 0)
				display_name = "[name] ([round(time_left/10, 1)]s | [devotion_cost] Devotion)"
			else
				display_name = "[name] ([devotion_cost] Devotion)"

		display[display_name] = name

	if(!display.len)
		to_chat(H, span_warning("Nothing available in this category."))
		return FALSE

	// CHOICE
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
	var/devotion_cost = entry["m_devotion"] || 0

	if(!item_path)
		return FALSE

	// COOLDOWN CHECK
	if(item_cooldowns[choice] == -1)
		to_chat(H, span_warning("[choice] cannot be used again."))
		return FALSE

	if(item_cooldowns[choice] && world.time < item_cooldowns[choice])
		to_chat(H, span_warning("[choice] is on cooldown for [round((item_cooldowns[choice] - world.time)/10, 1)] seconds."))
		return FALSE

	// DEVOTION CHECK
	if(devotion_cost > 0)
		src.devotion_cost = devotion_cost
		if(!H.devotion?.check_devotion(src))
			to_chat(H, span_warning("Your connection to the Free God is faint. Don't ask favors you cannot pay for."))
			return FALSE

	// SPAWN ITEM
	var/obj/item/I = new item_path(H.drop_location())
	if(!I)
		return FALSE

	H.put_in_hands(I)

	if(lines && lines.len)
		H.say(pick(lines), language = /datum/language/common)

	// APPLY DEVOTION COST
	if(devotion_cost > 0)
		H.devotion.update_devotion(-devotion_cost)

	// APPLY COOLDOWN
	if(m_cd == -1)
		item_cooldowns[choice] = -1
	else
		item_cooldowns[choice] = world.time + m_cd

	StartCooldown()
	return TRUE

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

// T1 - Skulduggery, lets you slip behind people who attack you
// number of times scales from your miracle tier, then once those "free" dodges are spent, it takes enem skill vs miracle chance
// can grapple attackers by having throw intent on, if attacked again by your target or someone else, either slam them down, or slam them on the attacker

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

////////////////
//T2 - Mammonite
//Uses up to 100 Mammon to deal 100 damage with 75% armor penetration on your next strike. Can't get simpler than that.

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
	var/min_mammon = 25
	var/max_mammon = 100

/datum/action/cooldown/spell/mammonite/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/H = owner
	if(!H.cmode)
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

	if(!H.cmode)
		to_chat(H, span_warning("I need some adrenaline pumping for this, my good sire!"))
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
		E.bonus_damage = round(mammon_used * 3) // jakk here

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
