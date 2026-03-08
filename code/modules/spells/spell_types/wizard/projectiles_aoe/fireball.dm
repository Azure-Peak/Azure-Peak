/obj/effect/proc_holder/spell/invoked/projectile/fireball
	name = "Fireball"
	desc = "Shoot out a ball of fire that emits a light explosion on impact, setting the target alight. Consumes <b>Arcane Marks</b> for extra damage when fully stacked."
	clothes_req = FALSE
	range = 8
	projectile_type = /obj/projectile/magic/aoe/fireball/rogue
	overlay_state = "fireball"
	sound = list('sound/magic/fireball.ogg')
	releasedrain = 30
	chargedrain = 1
	chargetime = 15
	recharge_time = 15 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	spell_tier = 3 // AOE
	invocations = list("Sphaera Ignis!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	chargedloop = /datum/looping_sound/invokefire
	associated_skill = /datum/skill/magic/arcane
	cost = 6
	xp_gain = TRUE

/obj/projectile/magic/aoe/fireball/rogue
	name = "fireball"
	exp_heavy = -1
	exp_light = -1
	exp_flash = 0
	exp_fire = 1
	damage = 40
	damage_type = BURN
	npc_simple_damage_mult = 3 // 1 shotting crawlers is cool. intentionally different from other fireballs due to arcyne mark disparity
	accuracy = 40 // Base accuracy is lower for burn projectiles because they bypass armor
	nodamage = FALSE
	flag = "magic"
	hitsound = 'sound/blank.ogg'
	aoe_range = 0


/obj/projectile/magic/aoe/fireball/rogue/on_hit(target)

	var/mob/living/M
	var/consume_marks = FALSE
	if(ismob(target))
		M = target
		var/datum/status_effect/debuff/arcanemark/mark = M.has_status_effect(/datum/status_effect/debuff/arcanemark)
		if(mark && mark.stacks >= mark.max_stacks)
			damage += 20 //Fuck You, Dude.
			consume_marks = TRUE


	. = ..()

	if(ismob(target))
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(consume_marks)
			to_chat(M, "<span class='userdanger'>SCALDING HELLFIRE; TRYPTICH-MARKE DETONATION!</span>")
			M.adjust_fire_stacks(2)
			consume_arcane_mark_stacks(M)
		M.adjust_fire_stacks(2)
