// Plunge your hand into someone's ribs to rip out their impure lux for your diabolical uses

/datum/action/cooldown/spell/lacrima
	name = "Lacrima"
	desc = "Requires an aggressive grab on a prone and living target. Begin a dark ritual that fractures their ribcage and, directly but violently, extracts their Lux."
	fluff_desc = "A method devised by the Cabal to require minimal ritual and effort. A method of extraction that is brutish, inelegant, yet undeniably effective. Zizo does not scorn efficiency, though resorting to something so lacking in flair can feel embarrassingly unceremonious. It may score a giggle or two from Her, especially against the ones who deserve it."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "zizograsp"
	charge_required = FALSE
	click_to_activate = FALSE
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 100
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = 100
	cooldown_time = 5 MINUTES
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = TRUE

/datum/action/cooldown/spell/lacrima/zizo
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 100
	secondary_resource_type = SPELL_COST_ENERGY
	secondary_resource_cost = 100
	associated_skill = /datum/skill/magic/holy
	cooldown_time = 1 MINUTES
	spell_requirements = SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/lacrima/cast(atom/cast_on)
	. = ..()
	if(!ishuman(owner))
		return FALSE

	if(!owner.pulling || !ishuman(owner.pulling) || owner.grab_state < GRAB_AGGRESSIVE)
		to_chat(owner, span_warning("I need an aggressive grab on a floored victim to use Lacrima!"))
		reset_spell_cooldown()
		return FALSE

	return lux_rip(owner.pulling, owner)

/datum/action/cooldown/spell/lacrima/proc/lux_rip(mob/living/carbon/human/target, mob/living/carbon/human/user)
	var/break_time = 13 SECONDS
	var/tear_time = 7 SECONDS

	if(target == user)
		return FALSE
	if(!iscarbon(target))
		to_chat(user, span_info("Their Lux is insufficient or plain worthless for this ritual."))
		return FALSE
	if(target.stat == DEAD)
		to_chat(user, span_notice("They're dead."))
		return FALSE
	if(!target.Adjacent(user))
		to_chat(user, span_info("I need to be next to [target] to excise their Lux."))
		return FALSE
	if(target.mobility_flags & MOBILITY_STAND)
		to_chat(user, span_info("My victim must be lying down."))
		return FALSE
	if(!target.has_extractable_lux())
		to_chat(user, span_notice("This husk holds no true lifeforce - there is nothing to excise."))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/debuff/devitalised) || (target.mob_biotypes & MOB_UNDEAD))
		to_chat(user, span_notice("This victim's Lux is corroded, yet regrowing. There is little I can make use of."))
		return FALSE

	var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		to_chat(user, span_warning("There is no viable chest to extract Lux from."))
		return FALSE

	user.visible_message(span_artery("[user] reaches towards [target]'s chest, necrotic flames wreathing [user.p_their()] hand..."))

	if(!chest.has_wound(/datum/wound/fracture/chest))
		if(!do_after(user, break_time, target = target))
			return FALSE
		user.say(",w Cede...")
		if(!chest)
			return FALSE

		if(!HAS_TRAIT(target, TRAIT_NOPAIN))
			target.emote("paincrit")

		chest.add_wound(/datum/wound/fracture/chest)
		target.apply_damage(50, BRUTE, BODY_ZONE_CHEST)
		user.visible_message(span_artery("[user] plunges their fist into [target]'s ribcage, shattering it spectacularly!"))

	user.playsound_local(user, 'sound/magic/repulse.ogg', 50, FALSE)

	if(!do_after(user, tear_time, target = target))
		return FALSE
	user.say(",w --et pars Magni Operis Eius eris!")
	user.playsound_local(user, 'sound/magic/swap.ogg', 50, FALSE)
	playsound(get_turf(target), 'sound/combat/brutal_impalement.ogg', 100, TRUE)

	if(HAS_TRAIT(target, TRAIT_UNFORGIVABLE)) //Oh boy, you're going to have a NASTY surprise in there
		to_chat(user, span_userdanger("Your hand finds nothing but an unnatural violet-ochre flame within [target], burning at your hand and soul!"))
		user.visible_message(span_artery("[user] recoils from [target]'s ribcage, as unholy violet-ochre flames flicker out and engulf them!"))
		user.emote("superagony")
		if(!HAS_TRAIT(user, TRAIT_NOMOOD))
			user.freak_out()
		playsound(user, 'sound/misc/lava_death.ogg', 100, TRUE)
		user.adjust_fire_stacks(20, /datum/status_effect/fire_handler/fire_stacks/vheslyn) //YOU PUT YOUR FUCKING HAND IN THE DEMONIC HUSK YOU DUMBASS
		user.ignite_mob()
		user.adjustFireLoss(60)
		user.Knockdown(20)
		user.Jitter(20)
		user.Stun(5) //ITS GOING TO HURT, A LOT
		return FALSE

	target.emote("superagony")

	playsound(user, 'sound/items/blackmirror_needle.ogg', 60, FALSE, 3)
	user.visible_message(span_artery("[user] tears a glob of pulsating Lux from [target]'s heart!"))

	if(HAS_TRAIT(target, TRAIT_PSYDONITE) || HAS_TRAIT(target, TRAIT_INQUISITION))
		target.add_stress(/datum/stressevent/torn_lux_psydonite)
		user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)

	else if(HAS_TRAIT(target, TRAIT_NOBLE) || HAS_TRAIT(target, TRAIT_CLERGY))
		target.add_stress(/datum/stressevent/torn_lux_devout)
		user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)

	else if(isaasimar(target))
		target.add_stress(/datum/stressevent/torn_lux_aasimar)

	else
		target.add_stress(/datum/stressevent/torn_lux)

	if(isaasimar(target))
		to_chat(user, span_warning("It settles softly in my grasp... Refined, radiant, exquisite. I shall remember this one."))
		user.put_in_hands(new /obj/item/reagent_containers/lux)
		target.apply_status_effect(/datum/status_effect/debuff/devitalised/greater)
	else
		to_chat(user, span_warning("It writhes in my grasp... Coarse and wanting, but not without use. It can be refined."))
		user.put_in_hands(new /obj/item/reagent_containers/lux_impure)
		target.apply_status_effect(/datum/status_effect/debuff/devitalised)

	SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_LUX_HARVESTED)
	record_round_statistic(STATS_TORTURES)

	if(!target.mind)
		target.dust(drop_items = TRUE)

	return TRUE

/datum/stressevent/torn_lux
	desc = span_boldred("MY LUX IS TORN ASUNDER!! My heartbeats feel erratic and hollow, as if my body wills to rot from inside out.")
	stressadd = 10
	timer = 5 MINUTES

/datum/stressevent/torn_lux_aasimar
	desc = span_boldred("MY LUX IS TORN ASUNDER!! I feel my body crumbling from within! The very divine essence of what I am-- I am failing to keep it together!")
	stressadd = 10
	timer = 15 MINUTES

/datum/stressevent/torn_lux_psydonite
	desc = span_boldred("MY LUX IS TORN ASUNDER!! My heartbeats feel erratic and hollow, as if my body wills to rot from inside out. I must endure... I must...")
	stressadd = 10
	timer = 10 MINUTES

/datum/stressevent/torn_lux_devout
	desc = span_boldred("MY LUX IS TORN ASUNDER!! My heartbeats feel erratic and hollow, as if my body wills to rot from inside out. My connection to the Pantheon feels faint... Am I forsaken?")
	stressadd = 10
	timer = 10 MINUTES
