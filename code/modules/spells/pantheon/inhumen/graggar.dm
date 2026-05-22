/datum/action/cooldown/spell/graggar
	background_icon = 'icons/mob/actions/graggarmiracles.dmi'
	button_icon = 'icons/mob/actions/graggarmiracles.dmi'
	spell_color = GLOW_COLOR_GRAGGAR

	ignore_armor_penalty = TRUE

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross)

//T0: Bloodrage  -- Uncapped STR buff.
/obj/effect/proc_holder/spell/self/graggar_bloodrage
	name = "Bloodrage"
	desc = "Tap into Graggar's wellspring of strength and knowledge, granting unbound power at the cost of temporary insanity and physical exhaustion." 		//reflavored into "graggar grants you some of the strength he got from stealing the souls of miscellaneous ravoxians"
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "bloodrage"
	recharge_time = 5 MINUTES
	invocations = list("SINISTAR, SHATTER MY BINDS!!", // VERY CLEAR that you are a heretic and VERY clear you've popped
						"GRAGGAR, GRAGGAR, GRAGGAR!!", // your anti-stun Im Going to Kill You Now spell
						"I EMBODY THE MOTIVE FORCE!!") // DO NOT add any ambiguious invocations
	invocation_type = "shout"
	sound = 'sound/magic/bloodrage.ogg'
	releasedrain = 10
	miracle = TRUE
	devotion_cost = 80
	antimagic_allowed = FALSE
	range = 0
	var/static/list/purged_effects = list(
	/datum/status_effect/incapacitating/immobilized,
	/datum/status_effect/incapacitating/paralyzed,
	/datum/status_effect/incapacitating/stun,
	/datum/status_effect/incapacitating/knockdown,)

/obj/effect/proc_holder/spell/self/graggar_bloodrage/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.resting)
		H.set_resting(FALSE, FALSE)
	H.emote("warcry")
	for(var/effect in purged_effects)
		H.remove_status_effect(effect)
	H.apply_status_effect(/datum/status_effect/buff/bloodrage)
	H.visible_message(span_danger("[H] rises upward, boiling with immense rage!"))
	return TRUE

//T0: Graggar cuffbreak
/obj/effect/proc_holder/spell/self/graggar_chainbreak
	name = "Break the Chains"
	desc = "Snap off your restraints with unholy help."
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "breakchains"
	recharge_time = 10 MINUTES //Goes down pretty signifcantly if you have high holy level.
	invocations = list("GRAGGAR BREAK MY CHAINS!", "GRAGGAR SET ME FREE!", "SLAUGHTER RESUMED!")
	invocation_type = "shout"
	sound = 'sound/magic/break_chains.ogg'
	miracle = TRUE
	releasedrain = 10
	devotion_cost = 50
	antimagic_allowed = FALSE

/obj/effect/proc_holder/spell/self/graggar_chainbreak/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.handcuffed || H.legcuffed)
		H.visible_message(span_danger("[H]'s restraints loosen under inhumen pressure!"))
		H.uncuff()
		return TRUE
	else
		revert_cast()
		return FALSE

//T1: Call to Slaughter - AoE buff for Inhumen surrounding you, debuff for Pantheoneers
/datum/action/cooldown/spell/graggar/graggar_battlecry
	name = "Call to Slaughter"
	desc = "Grants you and all allies nearby a buff to their strength, willpower, and constitution. Debuffs followers of the Ten, but not Psydonites."
	fluff_desc = "The battlefield quakes with your roar! Shaken to their core, they will prove easy pickings for a worthy champion such as yourself; the power of the Sinistar, unleashed.\
	SLAUGHTER THE LAMBS - DRINK THEIR MARROW - FEAST UPON THEIR FLESH - LEAVE NO TRACE OF THEIR PATHETIC EXISTENCE! - THE SINISTAR HUNGERS!"
	button_icon_state = "call_to_slaughter"
	sound = 'sound/magic/battle_cry_graggar.ogg'
	glow_intensity = 0

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_AURA

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR - 10

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("LAMBS TO THE SLAUGHTER!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/graggar/graggar_battlecry/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	for(var/mob/living/carbon/target in view(cast_range, get_turf(owner)))
		if(istype(target.patron, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/buff/call_to_slaughter)	//Buffs inhumens
			continue
		if(istype(target.patron, /datum/patron/old_god))
			to_chat(target, span_danger("You feel a surge of cold wash over you; leaving your body as quick as it hit.."))	//No effect on Psydonians!
			continue
		if(!owner.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/debuff/call_to_slaughter)	//Debuffs non-inhumens/psydonians
	return TRUE

/atom/movable/screen/alert/status_effect/buff/call_to_slaughter
	name = "Call to Slaughter"
	desc = span_bloody("LAMBS TO THE SLAUGHTER!")
	icon_state = "call_to_slaughter"

/datum/status_effect/buff/call_to_slaughter
	id = "call_to_slaughter"
	alert_type = /atom/movable/screen/alert/status_effect/buff/call_to_slaughter
	duration = 2.5 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 2, STATKEY_CON = 1)

/atom/movable/screen/alert/status_effect/debuff/call_to_slaughter
	name = "Call to Slaughter"
	desc = "A putrid rotting scent fills your nose as Graggar's call for slaughter rattles you to your core.."
	icon_state = "call_to_slaughter_negative"

/datum/status_effect/debuff/call_to_slaughter
	id = "call_to_slaughter"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/call_to_slaughter
	effectedstats = list(STATKEY_WIL = -2, STATKEY_CON = -2)
	duration = 2.5 MINUTES

//T2: Unholy Grasp - Throws disappearing net made of viscera at enemy. Creates blood on impact.
/obj/effect/proc_holder/spell/invoked/projectile/graggar_blood_net
	name = "Unholy Grasp"
	desc = "Unleashes a snare of external blood and guts. The viscera winds around the legs of mortals... \
	Though has little effect on simple creatures. Mortals cannot remove the net, but it decays ten seconds after landing."
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "unholy_grab"
	miracle = TRUE
	devotion_cost = 50
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/magic/unholy_grasp
	chargedloop = /datum/looping_sound/invokeascendant // this should stand out on a gaggar guy
	releasedrain = 20
	chargedrain = 0
	chargetime = 15
	recharge_time = 40 SECONDS // no running, super slow. this FUCKS people. lower it if 40 is too much.
	invocation_type = "shout"
	invocations = list("BE STILL!!") // VERY loud. do NOT add other invocations, this projectile can FUUUCK people up and needs to be telegraphed.
	sound = 'sound/magic/blood_net.ogg'
	range = 8

/obj/projectile/magic/unholy_grasp
	name = "visceral organ net"
	icon_state = "tentacle_end"
	nodamage = TRUE
	range = 8 // you can dodge it, see speed. lower if need be.
	speed = 1.6
	hitsound = 'sound/magic/slimesquish.ogg'

/obj/projectile/magic/unholy_grasp/on_hit(target)
	. = ..()
	if(!iscarbon(target))
		return
	if(target)
		ensnare(target)

/obj/projectile/magic/unholy_grasp/proc/ensnare(mob/living/carbon/carbon)
	carbon.visible_message(span_warning("[src] ensnares [carbon] around their legs in a horrid cacophany of blood and guts!"), span_warning("I AM ENCAPTURED BY BLOOD AND GUTS! THERES A NET ON MY LEGS!"))
	carbon.apply_status_effect(/datum/status_effect/debuff/netted/vile)
	playsound(src, 'sound/combat/caught.ogg', 50, TRUE)

//T2: Unholy Silence - Silences a target, preventing them from speaking or casting spells.
/obj/effect/proc_holder/spell/invoked/silence/graggar
	name = "Unholy Silence"
	desc = "Tie up the tongue of your foe, making them unable to speak or cast spells/miracles."
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "unholy_silence"
	miracle = TRUE
	devotion_cost = 50
	releasedrain = 20
	chargedrain = 2
	chargetime = 3 SECONDS
	range = 4
	recharge_time = 2 MINUTES //This lasts 25 SECONDS at max holy rank so for purposes of it not being chainable solo.
	associated_skill = /datum/skill/magic/holy
	invocation_type = "shout"
	sound = 'sound/magic/graggar_silence.ogg'
	invocations = list("BE SILENT!", "QUIET!", "NOT ANOTHER WORD!")
	zizo_spell = FALSE // Graggar wants his car back.

/obj/effect/proc_holder/spell/invoked/silence/graggar/cast(list/targets, mob/user = usr)//This one does actually work on mages, fully.
	if(iscarbon(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(user == target) //self target
			to_chat(user, "<span class='warning'>I may not silence myself.</span>")
			revert_cast()
			return
		if(HAS_TRAIT(target, TRAIT_COUNTERCOUNTERSPELL) || HAS_TRAIT(target, TRAIT_ANTIMAGIC) || HAS_TRAIT(target, TRAIT_MUTE))
			to_chat(user, "<span class='warning'>The spell fizzles, it won't work on them!</span>")
			revert_cast()
			return
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] resists the silencing magic!"))
			return TRUE
		ADD_TRAIT(target, TRAIT_MUTE, MAGIC_TRAIT)
		playsound(get_turf(target), 'sound/magic/zizo_snuff.ogg', 80, TRUE, soundping = TRUE)
		to_chat(target, span_warning("The wind in my voice goes still. I can't speak!"))
		var/dur = max((2 + (user.get_skill_level(associated_skill, 2))))//10 seconds at lvl 6 HOLY
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = dur SECONDS)
		return TRUE
	else //misfire
		to_chat(user, "<span class='warning'>I must attempt to silence a speaking, thinking being.</span>")
		revert_cast()
		return

//T3: Revel in Death - Increase bleeding and pain of a target.
/obj/effect/proc_holder/spell/invoked/revel_in_slaughter
	name = "Revel in Death"
	desc = "Increases the bleeding and pain of a target. Their blood-loss amount scales with every point of constitution over ten. \
	Those with ten or less constituion will instead have a flat rate (x1.25)."
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "bloodsteal"
	recharge_time = 1 MINUTES
	chargetime = 10
	chargedrain = 0
	chargedloop = /datum/looping_sound/invokeevil
	invocations = list("SINISTAR, MAKE THEM BLEED!")
	invocation_type = "shout"
	sound = 'sound/magic/bleed_out.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 70

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/human/human = targets[1]

	if(!istype(human) || human == user)
		to_chat(user, span_danger("THAT WONT WORK!"))
		revert_cast()
		return FALSE

	if(spell_guard_check(human, TRUE))
		human.visible_message(span_warning("[human] resists the bloodlust!"))
		return TRUE
	
	human.apply_status_effect(/datum/status_effect/debuff/bloody_mess)
	human.apply_status_effect(/datum/status_effect/debuff/sensitive_nerves)

	return TRUE
