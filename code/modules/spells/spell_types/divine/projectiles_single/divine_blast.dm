/obj/effect/proc_holder/spell/invoked/projectile/divineblast
	name = "Divine Blast"
	desc = "Shoot out a blast of divine power! Deals more damage to heretics(Psydonians/Inhumen) and Undead! \n\
	Damage is increased by 100% versus simple-minded creechurs.\n\
	Toggle arc mode (Shift+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	clothes_req = FALSE
	range = 12
	projectile_type = /obj/projectile/energy/divineblast
	projectile_type_arc = /obj/projectile/energy/divineblast/arc
	overlay_state = "divine_blast"
	sound = list('sound/magic/vlightning.ogg')
	active = FALSE
	releasedrain = 20
	chargedrain = 1
	chargetime = 0
	recharge_time = 5 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	invocations = list("Göttliche Macht")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE
	devotion_cost = 25
	human_req = TRUE

/obj/effect/proc_holder/spell/invoked/projectile/divineblast/cast(list/targets, mob/user = user)
	projectile_type = arc_mode ? projectile_type_arc : initial(projectile_type)
	. = ..()


/obj/projectile/energy/divineblast
	name = "Divine Blast"
	icon_state = "divine_blast"
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE
	damage = 20 // wont do much to a divine worshipper
	woundclass = BCLASS_STAB // divine blade!
	nodamage = FALSE
	npc_simple_damage_mult = 2 // The Simple Skele Gibber
	hitsound = 'sound/magic/churn.ogg'
	speed = 1

/obj/projectile/energy/divineblast/arc
	name = "Arced Divine Blast"
	damage = 15 // Slightly lower base damage and barely matter due to low to hit but not a problem on acolyte / cleric.
	arcshot = TRUE

/obj/projectile/energy/divineblast/on_hit(target, blocked = FALSE)
	. = ..()
	if(blocked >= 100)
		return
	if(isliving(target))
		var/mob/living/H = target
		if(H.job in GLOB.church_positions) // TRAIT_CLERGY could work here but is unmaintained and druids, sextons, etc. all lack it.
			visible_message(span_warning("The divine blast bounces off [H] harmlessly!"))
			playsound(get_turf(H), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(out_of_effective_range())
			return
		if(H.mob_biotypes & MOB_UNDEAD)
			damage += 10
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(istype(H.patron, /datum/patron/divine))
			if(H in GLOB.excommunicated_players)
				damage += 20
		if(istype(H.patron, /datum/patron/inhumen))
			damage += 20
		if(istype(H.patron, /datum/patron/old_god))
			damage += 20
		if(HAS_TRAIT(H, TRAIT_SILVER_WEAK) && !H.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			H.visible_message("<font color='white'>Divine power rebukes [H]!</font>")
			to_chat(H, span_userdanger("Divine fury rebukes my presence! My body catches aflame!")) //Its NOT a Silver sunder, for balance reasons w/ the buffs. Change this back to sunders when clergy isn't absolutely fucked to fight.
			H.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/divine)
			H.ignite_mob()
		if(H.has_status_effect(/datum/status_effect/debuff/necran_cross))
			// Undead weakened by a blessed necran cross are more fragile to divine magycks
			damage += 30
		var/mob/living/carbon/human/caster
		if (ishuman(firer))
			caster = firer
			switch(caster.patron.type)
				if(/datum/patron/divine/undivided)
					damage += 15 // just more raw damage. As mentioned in UNDIVIDED. Our generics are better as a trade off of not having higher tier uniques.
					H.visible_message(span_warning("Holy light slams into [H] with force!"), span_warning("Holy light slams into me with force!"))
				if(/datum/patron/divine/astrata)
					if(istype(H.patron, /datum/patron/inhumen/matthios))
						H.visible_message(span_warning("[H] is engulfed in flames!"), span_warning("Astrata's <b>hatred</b> sets me aflame!"))
						H.adjust_fire_stacks(3) //ANCIENT ENEMY I DO NOT FEAR YOU
						H.ignite_mob()
					else
						H.visible_message(span_warning("[H] is engulfed in flames!"), span_warning("Astrata's fury sets me aflame!"))
						H.adjust_fire_stacks(2) //Remains regular, setting everyone on fire is funnier
						H.ignite_mob()
				if(/datum/patron/divine/abyssor)
					H.visible_message(span_warning("Water seeps from [H]'s lips!"), span_warning("Choking water in my lungs!"))
					H.Dizzy(5)
					H.emote("drown")
				if(/datum/patron/divine/dendor)
					H.Slowdown(2) // Shared with Ravox cuz immobilize + offbal is 2 strong
					H.visible_message(span_warning("Roots coil around [H]'s legs!"), span_warning("Roots tangle around my legs!"))
				if(/datum/patron/divine/necra)
					if((H.mob_biotypes & MOB_UNDEAD) || HAS_TRAIT(H, TRAIT_DEATHLESS)) //DEATH TO THE DEATHLESS, NECRA HATES YOU.
						H.adjust_fire_stacks(4, /datum/status_effect/fire_handler/fire_stacks/divine)
						H.ignite_mob()
						H.visible_message(span_warning("[H] is rebuked by Divine Scorn!"), span_warning("The Undermaiden's <b>scornful</b> gaze rebukes me!"))
				if(/datum/patron/divine/pestra)
					H.vomit(stun = 0)
					H.adjustToxLoss(10)
					H.visible_message(span_warning("[H] expels some leeches out of them!"), span_warning("Something roils within me!"))
					new /obj/item/natural/worms/leech(get_turf(H))
				if(/datum/patron/divine/eora)
					H.blur_eyes(10)
				if(/datum/patron/divine/noc)
					H.visible_message(span_warning("Moonlight engulfs [H]"), span_warning("Moonlight engulfs me!"))
					damage += (caster.get_stat(STATKEY_INT) * 2)
				if(/datum/patron/divine/ravox)
					H.Slowdown(2)
					H.visible_message(span_warning("Divine chains briefly coil around [H]'s legs!"), span_warning("Divine chains briefly shackle around my legs!"))
				if(/datum/patron/divine/malum)
					H.adjustBruteLoss(10) //Think of it like hammering into you, it was straight direct armor-peircing burn damage before and could crit you insanely fast
					H.visible_message(span_warning("[H] is hammered with divine force!"), span_warning("Malum's disappointment hammers into me!"))
					//He's not mad, he's not proud, he's not hateful, he's as neutrally disappointed in you as one can be. (Its also funnier this way)
	else
		return



