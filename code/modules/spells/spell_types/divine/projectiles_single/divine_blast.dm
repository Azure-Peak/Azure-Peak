/obj/effect/proc_holder/spell/invoked/projectile/divineblast
	name = "Divine Blast"
	desc = "Shoot out a blast of divine power! Deals more damage to heretics(Psydonians/Inhumen) and Undead! \n\
	Damage is increased by 100% versus simple-minded creechurs.\n\
	Can be fired in an arc over an ally's head with a mage's staff, spellbook or psicross on arc intent. It will deals 25% less damage that way."
	clothes_req = FALSE
	range = 12
	projectile_type = /obj/projectile/energy/divineblast
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
	invocations = list("Goettlichen macht!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	miracle = TRUE
	devotion_cost = 25

/obj/effect/proc_holder/spell/invoked/projectile/divineblast/cast(list/targets, mob/user = user)
	var/mob/living/carbon/human/H = user
	var/datum/intent/a_intent = H.a_intent
	if(istype(a_intent, /datum/intent/special/magicarc))
		projectile_type = /obj/projectile/energy/divineblast/arc
	else
		projectile_type = /obj/projectile/energy/divineblast
	. = ..()


/obj/projectile/energy/divineblast
	name = "Divine Blast"
	icon_state = "divine_blast"
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

/obj/projectile/energy/divineblast/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/H = target
		if((H.job in list("Templar", "Acolyte", "Bishop", "Martyr")))
			visible_message(span_warning("[src]'s power brushes off of [H] with no harm!"))
			playsound(get_turf(H), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(H.mob_biotypes & MOB_UNDEAD)
			damage += 20
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
			H.visible_message("<font color='white'>The unholy strike weakens the curse temporarily!</font>")
			to_chat(H, span_userdanger("Silver rebukes my presence! My vitae smolders, and my powers wane!"))
			H.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/sunder)
		if(H.has_status_effect(/datum/status_effect/debuff/necran_cross))
			// Undead weakened by a blessed necran cross are more fragile to divine magycks
			damage += 20
		var/mob/living/carbon/human/caster
		if (ishuman(firer))
			caster = firer
			switch(caster.patron.type)
				if(/datum/patron/divine/undivided)
					damage += 15 // just more raw damage. As mentioned in UNDIVIDED. Our generics are better as a trade off of not having higher tier uniques.
				if(/datum/patron/divine/astrata)
					H.adjust_fire_stacks(2)
					H.ignite_mob()
				if(/datum/patron/divine/abyssor)
					H.visible_message(span_warning("Water seeps from [H]'s lips!"), span_warning("Choking water in my lungs!"))
					H.Dizzy(5)
					H.emote("drown")
				if(/datum/patron/divine/dendor)
					H.Slowdown(2) // Shared with Ravox cuz immobilize + offbal is 2 strong
					H.visible_message(span_warning("Roots coil around [H]'s legs!"), span_warning("Roots tangle around my legs!"))
				if(/datum/patron/divine/necra)
					if(H.mob_biotypes & MOB_UNDEAD)
						H.adjust_fire_stacks(4)
						H.ignite_mob()
				if(/datum/patron/divine/pestra)
					H.vomit(stun = 0)
					H.adjustToxLoss(10)
					H.visible_message(span_warning("[H] expels some leeches out of them!"), span_warning("Something roils within me!"))
					new /obj/item/natural/worms/leech(get_turf(H))
				if(/datum/patron/divine/eora)
					H.blur_eyes(10)
				if(/datum/patron/divine/noc)
					H.visible_message(span_warning("Moonlight engulfs [H]"), span_warning("Moonlight engulfs me!"))
					for(var/obj/O in range(0, H))	
						O.extinguish()
					for(var/mob/M in range(0, H)) // extinguish lights of target(zizo snuff pretty much but range 0 always)
						for(var/obj/O in M.contents)
							O.extinguish()
				if(/datum/patron/divine/ravox)
					H.Slowdown(2)
				if(/datum/patron/divine/malum)
					H.adjustFireLoss(10)
					H.visible_message(span_warning("Singing flames lick at [H]!"), span_warning("Malum's forge broils me!"))
	else
		return



