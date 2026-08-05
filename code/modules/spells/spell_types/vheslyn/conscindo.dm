/* Conscindo - a perversion or perhaps even the original art of "Lacrima" used by zizites except, this one has a much more sinister purpose
instead of just meaning tear, this means "tear and rend" which is actually pretty fucking cool if you know latin.
Its a lethal version of Lacrima that works on the undead too, instead of giving you usable lux however
you violently rend it asunder and heal you instead, intended as a finisher to make these bastards scary, because murder is your creed.
*/
/datum/action/cooldown/spell/vheslyn/conscindo
	name = "Conscindo"
	desc = "Requires an aggressive grab on a prone and living target. Begin a unspeakable ritual that fractures their ribcage and, directly but violently, rends apart their Lux by melting it killing them instantly and devitalising them for a long-period of time."
	fluff_desc = "A method from tymes long forgotten and unspeakable, reborn through applying unstable magic and corrupted Vheslynite essense to essentally re-purpose the Lacrima spell of Zizo into a method of lux destruction and murder that is brutish, inelegant, yet undeniably effective."
	button_icon = 'icons/mob/actions/vheslynspells.dmi'
	button_icon_state = "conscindo"
	charge_required = FALSE
	click_to_activate = FALSE
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 100
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = 100
	cooldown_time = 8 MINUTES //Intended to be very long, this is an instant-kill spell.
	invocations = "Ezavr Un'mari Sae'Vi Ofi' Ce'aetia." //BE UNMADE SLAVE OF CREATION - gibberished
	associated_skill = /datum/skill/magic/arcane

/datum/action/cooldown/spell/vheslyn/conscindo/cast(atom/cast_on)
	. = ..()
	if(!ishuman(owner))
		return FALSE

	if(owner.pulling && ishuman(owner.pulling) && owner.grab_state >= GRAB_AGGRESSIVE)
		lux_rend(owner.pulling, owner)
		return TRUE

	to_chat(owner, span_warning("I need an aggressive grab on a floored victim to use Lacrima!"))
	reset_spell_cooldown()
	return FALSE

/datum/action/cooldown/spell/vheslyn/conscindo/proc/lux_rend(mob/living/carbon/human/target, mob/living/carbon/human/user)
	var/break_time = 13 SECONDS
	var/tear_time = 7 SECONDS //This one kills, used as a finisher on shattered ribs ideally

	if(target == user)
		return
	if(!iscarbon(target))
		to_chat(user, span_info("This ritual would be impractical, considering their physique. Applying a weapon and vigorous amounts of fire may be better."))
		return
	if(target.stat == DEAD)
		to_chat(user, span_notice("They're already dead."))
		return
	if(!target.Adjacent(user))
		to_chat(user, span_info("I need to be next to [target] to rend apart their Lux."))
		return
	if((target.mobility_flags & MOBILITY_STAND))
		to_chat(user, span_info("My victim must be lying down."))
		return
	if(!target.has_extractable_lux())
		to_chat(user, span_info("This conjuration holds no true lux to rend."))
		return
	if(HAS_TRAIT(target, TRAIT_UNFORGIVABLE)) //Vheslynites aren't fucking humen, also I don't see why you'd kill your exploding allies this way.
		to_chat(user, span_info("They lack any lux to begin with."))
		return
	//We don't care if you're undead, we're tearing it out to kill you.
	else
		user.visible_message(span_alert("[user] reaches towards [target]'s chest, unholy violet-ochre flames wreathing [user.p_their()] hand..."))
	//Handle our mood debuffs for being witnessed within 7 tiles
	for(var/mob/living/carbon/stresstarget in view(7, user))
		if(!HAS_TRAIT(stresstarget, TRAIT_UNFORGIVABLE) && !HAS_TRAIT(stresstarget, TRAIT_INQUISITION)) //Non inquis get heftier stress
			stresstarget.add_stress(/datum/stressevent/witnessvheslyn)
			continue
		if(!HAS_TRAIT(stresstarget, TRAIT_UNFORGIVABLE) && HAS_TRAIT(stresstarget, TRAIT_INQUISITION)) //Inquis get lesser stress
			stresstarget.add_stress(/datum/stressevent/witnessvheslyninquis)
			continue

	var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
	if(!chest.has_wound(/datum/wound/fracture/chest))
		if(!do_after(user, break_time, target = target))
			return
		if(chest)
			if(!HAS_TRAIT(target, TRAIT_NOPAIN))
				target.emote("agony")
			chest.add_wound(/datum/wound/fracture/chest)
			target.adjust_fire_stacks(10, /datum/status_effect/fire_handler/fire_stacks/vheslyn) //Unique violet firestacks. we do a LOT of them, this ritual keeps people /down/.
			target.ignite_mob()
			target.apply_damage(70, BRUTE, BODY_ZONE_CHEST) //We aren't delicate vs Zizo's version, we want them dead.
			user.visible_message(span_alert("[user] violently plunges their fist into [target]'s ribcage, shattering it spectacularly!"))
	if(!do_after(user, tear_time, target = target) && chest.has_wound(/datum/wound/fracture/chest))
		return
	if(!HAS_TRAIT(target, TRAIT_NOPAIN))
		target.emote("agony")
	playsound(user, 'sound/items/blackmirror_needle.ogg', 60, FALSE, 3)
	playsound(user, 'sound/misc/lava_death.ogg', 100, TRUE) //You literally ripped their lux out and tore it apart + melted it to nothing.
	user.visible_message(span_alert("[user] tears and rends the Lux in [target]'s heart, turning it to violet flames that engulf them and restore their wounds!"))
	target.adjust_fire_stacks(20, /datum/status_effect/fire_handler/fire_stacks/vheslyn) //Unique violet firestacks. we do a LOT of them, this ritual keeps people /down/.
	target.ignite_mob()
	target.apply_damage(70, BRUTE, BODY_ZONE_CHEST) //AGAIN, we tore most of their lux apart. THIS will HURT.
	user.adjust_fire_stacks(10, /datum/status_effect/fire_handler/fire_stacks/vheslyn)
	user.ignite_mob()
	user.heal_overall_damage(80, 80) //Very hefty heal
	user.heal_wounds(30) //Remove a good chunk of your wounds as well.
	to_chat(target, span_userdanger("[user] rips a chunk of my weary lux and tears it to peices, reforming into into flames that sunder me and restore them!"))

	//I would gib DNRs but its probably better to not permanently remove players in niche cases like the Weeping Psycross.

	//No lux, we have "technically" extracted it, we just fucking obliterated it in unholy fire.
	SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_LUX_HARVESTED)
	record_round_statistic(STATS_TORTURES) //Okay Zizo, it technically counts I guess.
	target.apply_status_effect(/datum/status_effect/debuff/devitalised/greater) //YOUR LUX IS FUCKING TORN TO SHREADS, ITS GOING TO TAKE MORE THAN A SHORT-WHILE
