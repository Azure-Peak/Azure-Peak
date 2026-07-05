/obj/effect/proc_holder/spell/invoked/projectile/unholyblast // this CANNOT be a child of divine_blast bc you have to call parent on cast. 
	name = "Unholy Blast"
	desc = "Channel unholy power and sunder the unbelievers. Deals additional damage to wretched conformists and Psydonites! \n\
	Damage is increased by 100% versus simple-minded creechurs.\n\
	Toggle arc mode (Shift+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	clothes_req = FALSE
	range = 12
	overlay_state = "unholy_blast"
	projectile_type = /obj/projectile/energy/unholyblast
	projectile_type_arc = /obj/projectile/energy/unholyblast/arc
	sound = list('sound/magic/vlightning.ogg')
	active = FALSE
	releasedrain = 20
	chargedrain = 1
	chargetime = 0
	recharge_time = 5 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	invocations = list("Dunkle macht")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE
	devotion_cost = 25
	human_req = TRUE


/obj/projectile/energy/unholyblast
	name = "Unholy Blast"
	icon_state = "unholy_blast"
	damage = 20 // wont do much to a heretical worshipper
	woundclass = BCLASS_CUT // I REALLY wanted to do cut
	nodamage = FALSE
	npc_simple_damage_mult = 2 // The Simple Skele Gibber
	hitsound = 'sound/magic/soulsteal.ogg' // its kinda quiet BUT its cool
	speed = 1

/obj/projectile/energy/unholyblast/arc
	name = "Arced Unholy Blast"
	damage = 15 // Slightly lower base damage
	arcshot = TRUE

/obj/effect/proc_holder/spell/invoked/projectile/unholyblast/cast(list/targets, mob/user = user)
	projectile_type = arc_mode ? projectile_type_arc : initial(projectile_type)
	. = ..()


/obj/projectile/energy/unholyblast/on_hit(target)
	if(isliving(target))
		var/mob/living/H = target
		if(out_of_effective_range())
			return
		if(H.mob_biotypes & MOB_UNDEAD)
			damage += 20
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(istype(H.patron, /datum/patron/divine))
			damage += 20
		if(istype(H.patron, /datum/patron/old_god))
			damage += 20
		var/mob/living/carbon/human/caster
		if (ishuman(firer))
			caster = firer
			switch(caster.patron.type)
				if(/datum/patron/inhumen/baotha)
					H.adjustToxLoss(10)
					H.Dizzy(5)
					H.visible_message(span_warning("[H] looks unwell..."), span_warning("I feel dizzy... and I've been poisoned!"))
					if(HAS_TRAIT(H, TRAIT_SILVER_WEAK) && !H.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
						H.visible_message("<font color='white'>Unholy power rebukes [H]!</font>")
						to_chat(H, span_userdanger("Unholy wrath rebukes my presence! My body catches aflame!"))
						H.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/divine)
						H.ignite_mob()
				if(/datum/patron/inhumen/matthios)
					if(HAS_TRAIT(H, TRAIT_NOBLE))
						damage += 10 
						H.adjust_fire_stacks(4) //ditto to Astrata
						H.visible_message(span_warning("[H]'s blue blood burns bright!"), span_warning("My body burns-- my blood is being transacted into fire!"))
					else
						H.visible_message(span_warning("[H] is set aflame with gilded flames!"), span_warning("Gilded flame engulfs me!"))
					H.adjust_fire_stacks(2)
					H.ignite_mob()
					if(HAS_TRAIT(H, TRAIT_SILVER_WEAK) && !H.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
						H.visible_message("<font color='white'>Unholy power rebukes [H]!</font>")
						to_chat(H, span_userdanger("Unholy wrath rebukes my presence! My body catches aflame!"))
						H.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/divine)
						H.ignite_mob()
				if(/datum/patron/inhumen/graggar)
					H.visible_message(span_warning("A splatter of blood covers [H]'s face!"), span_warning("A glob of blood splatters my vision!"))
					H.Dizzy(5)
					H.blur_eyes(5)
					if(HAS_TRAIT(H, TRAIT_SILVER_WEAK) && !H.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
						H.visible_message("<font color='white'>Unholy power rebukes [H]!</font>")
						to_chat(H, span_userdanger("Unholy wrath rebukes my presence! My body catches aflame!"))
						H.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/divine)
						H.ignite_mob()
						H.Slowdown(4) //Suffer
				if(/datum/patron/inhumen/zizo)
					if(istype(H.patron, /datum/patron/divine/necra)) //Hilarious, always hit with full regardless of silver weak
						H.adjust_fire_stacks(6, /datum/status_effect/fire_handler/fire_stacks/divine)
						H.ignite_mob()
						H.visible_message(span_warning("[H] is smited by unholy spite!"), span_warning("Zizo's seething <b>hatred</b> smites me!"))
						H.Slowdown(3)
					if(!HAS_TRAIT(H, TRAIT_SILVER_WEAK) && !HAS_TRAIT(H, TRAIT_LYCANRESILENCE) && !istype(H.patron, /datum/patron/divine/necra)) //We churn you for NOT being silver weak. ZIZO. ZIZO. ZIZO.
						H.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/divine)
						H.ignite_mob()
						H.visible_message(span_warning("Seething ambition sears [H]'s flesh aflame!"), span_warning("Visions of progress and ambition sears my flesh, mynd and sets me aflame!"))
						H.Slowdown(3)
					if(HAS_TRAIT(H, TRAIT_LYCANRESILENCE) && !istype(H.patron, /datum/patron/divine/necra)) //EXCEPT WEREWOLVES... Fuck Dendor. Specifically within werebeast form, hense the trait, not the antag check.
						H.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine) //Less cause this is an actual antag, UNLESS they worship Necra in which case you kind of deserve this.
						H.ignite_mob()
						H.visible_message(span_warning("[H] is churned by unholy spite!"), span_warning("Zizo's seething <b>hatred</b> rebukes me!"))
						H.Slowdown(3)
					if(HAS_TRAIT(H, TRAIT_SILVER_WEAK) && !HAS_TRAIT(H, TRAIT_LYCANRESILENCE) && !istype(H.patron, /datum/patron/divine/necra))
						H.visible_message(span_warning("Unholy spite slams into [H]!"), span_warning("Unholy spite slams into me!"))
						H.Slowdown(2) //Less severe slowdown
	else
		return




