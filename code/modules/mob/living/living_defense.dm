
/mob/living/proc/run_armor_check(def_zone = null, attack_flag = "blunt", absorb_text = null, soften_text = null, armor_penetration, penetrated_text, damage, blade_dulling, peeldivisor, intdamfactor, used_weapon = null)
	var/armor = getarmor(def_zone, attack_flag, damage, armor_penetration, blade_dulling, peeldivisor, intdamfactor, used_weapon)

	//the if "armor" check is because this is used for everything on /living, including humans
	if(armor > 0 && armor_penetration)
		armor = max(0, armor - armor_penetration)
		if(penetrated_text)
			to_chat(src, span_danger("[penetrated_text]"))
//		else
//			to_chat(src, span_danger("My armor was penetrated!"))
	else if(armor >= 100)
		if(absorb_text)
			to_chat(src, span_notice("[absorb_text]"))
//		else
//			to_chat(src, span_notice("My armor absorbs the blow!"))
	else if(armor > 0)
		if(soften_text)
			to_chat(src, span_warning("[soften_text]"))
//		else
//			to_chat(src, span_warning("My armor softens the blow!"))
	if(mob_timers[MT_INVISIBILITY] > world.time)			
		mob_timers[MT_INVISIBILITY] = world.time
		update_sneak_invis(reset = TRUE)
	return armor


/mob/living/proc/getarmor(def_zone, type, damage, armor_penetration, blade_dulling, peeldivisor, intdamfactor, used_weapon)
	return 0

//this returns the mob's protection against eye damage (number between -1 and 2) from bright lights
/mob/living/proc/get_eye_protection()
	return 0

//this returns the mob's protection against ear damage (0:no protection; 1: some ear protection; 2: has no ears)
/mob/living/proc/get_ear_protection()
	return 0

/mob/living/proc/is_mouth_covered(head_only = 0, mask_only = 0)
	return FALSE

/mob/living/proc/is_eyes_covered(check_glasses = 1, check_head = 1, check_mask = 1)
	return FALSE
/mob/living/proc/is_pepper_proof(check_head = TRUE, check_mask = TRUE)
	return FALSE
/mob/living/proc/on_hit(obj/projectile/P)
	return BULLET_ACT_HIT

/mob/living/bullet_act(obj/projectile/P, def_zone = BODY_ZONE_CHEST)
	if(SEND_SIGNAL(src, COMSIG_ATOM_BULLET_ACT, P, def_zone) & COMPONENT_ATOM_BLOCK_BULLET)
		return
	def_zone = bullet_hit_accuracy_check(P.accuracy + P.bonus_accuracy, def_zone)
	var/ap = (P.flag == "blunt") ? BLUNT_DEFAULT_PENFACTOR : P.armor_penetration
	var/armor = run_armor_check(def_zone, P.flag, "", "",armor_penetration = ap, damage = P.damage, used_weapon = P)

	next_attack_msg.Cut()

	var/on_hit_state = P.on_hit(src, armor)
	var/nodmg = FALSE
	if(!P.nodamage && on_hit_state != BULLET_ACT_BLOCK)
		if(!apply_damage(P.damage, P.damage_type, def_zone, armor))
			nodmg = TRUE
			next_attack_msg += VISMSG_ARMOR_BLOCKED
		apply_effects(stun = P.stun, knockdown = P.knockdown, unconscious = P.unconscious, slur = P.slur, stutter = P.stutter, eyeblur = P.eyeblur, drowsy = P.drowsy, blocked = armor, stamina = P.stamina, jitter = P.jitter, paralyze = P.paralyze, immobilize = P.immobilize)
		if(!nodmg)
			if(P.dismemberment)
				check_projectile_dismemberment(P, def_zone,armor)
			if(P.woundclass)
				check_projectile_wounding(P, def_zone)

			if(P.poisontype)// New proc for poisoning that respects if armor stopped damage from the projectile, by blocking or through reduction. Only called if poison type is defined.
				if(!P.poisonamount)
					CRASH("Projectile attempted to add poison with undefined amount.")
				if(iscarbon(src))
					var/mob/living/carbon/M = src
					M.reagents.add_reagent(P.poisontype, P.poisonamount)
					if(P.poisonfeel)
						M.show_message(span_danger("You feel an intense [P.poisonfeel] sensation spreading swiftly from the area!"))

			if(P.embedchance && !check_projectile_embed(P, def_zone))
				P.handle_drop()

		else
			P.handle_drop()

	var/organ_hit_text = ""
	var/limb_hit = check_limb_hit(def_zone)//to get the correct message info.
	if(limb_hit)
		organ_hit_text = " in \the [parse_zone(limb_hit)]"
	if(P.hitsound && !nodmg)
		var/volume = P.vol_by_damage()
		playsound(loc, pick(P.hitsound), volume, TRUE, -1)
	visible_message(span_danger("[src] is hit by \a [P][organ_hit_text]![next_attack_msg.Join()]"), \
			span_danger("I'm hit by \a [P][organ_hit_text]![next_attack_msg.Join()]"), null, COMBAT_MESSAGE_RANGE)
	next_attack_msg.Cut()


	return on_hit_state ? BULLET_ACT_HIT : BULLET_ACT_BLOCK

/mob/living/proc/check_projectile_dismemberment(obj/projectile/P, def_zone)
	return 0

/mob/living/proc/check_projectile_wounding(obj/projectile/P, def_zone)
	return simple_woundcritroll(P.woundclass, P.damage, null, def_zone, crit_message = TRUE)

/mob/living/proc/check_projectile_embed(obj/projectile/P, def_zone)
	// Disable embeds on simples, allowing it to override on complex.
	return FALSE

/obj/item/proc/get_volume_by_throwforce_and_or_w_class()
	if(throwforce && w_class)
		return CLAMP((throwforce + w_class) * 5, 30, 100)// Add the item's throwforce to its weight class and multiply by 5, then clamp the value between 30 and 100
	else if(w_class)
		return CLAMP(w_class * 8, 20, 100) // Multiply the item's weight class by 8, then clamp the value between 20 and 100
	else
		return 0

/mob/living/hitby(atom/movable/AM, skipcatch, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum, damage_flag = "blunt")
	if(istype(AM, /obj/item))
		var/obj/item/I = AM
		// Hit the selected zone, or else a random zone centered on the chest
		var/zone = throwingdatum?.target_zone || ran_zone(BODY_ZONE_CHEST, 65)
		SEND_SIGNAL(I, COMSIG_MOVABLE_IMPACT_ZONE, src, zone)
		if(SEND_SIGNAL(src, COMSIG_LIVING_IMPACT_ZONE, I, zone) & COMPONENT_CANCEL_THROW)
			return FALSE
		if(!blocked)
			var/ap = (damage_flag == "blunt") ? BLUNT_DEFAULT_PENFACTOR : I.armor_penetration
			var/armor = run_armor_check(zone, damage_flag, "", "", armor_penetration = ap, damage = I.throwforce, used_weapon = I)
			next_attack_msg.Cut()
			var/nodmg = FALSE
			if(!apply_damage(I.throwforce, I.damtype, zone, armor))
				nodmg = TRUE
				next_attack_msg += VISMSG_ARMOR_BLOCKED
			if(!nodmg)
				if(iscarbon(src))
					var/obj/item/bodypart/affecting = get_bodypart(zone)
					if(affecting)
						var/throwee = null
						if(throwingdatum)
							throwee = isliving(throwingdatum.thrower) ? throwingdatum.thrower : null
						affecting.bodypart_attacked_by(I.thrown_bclass, I.throwforce, throwee, affecting.body_zone, crit_message = TRUE, weapon = I)
					I.do_special_attack_effect(I.thrownby, affecting, null, src, zone, thrown = TRUE)
				else
					simple_woundcritroll(I.thrown_bclass, I.throwforce, null, zone, crit_message = TRUE)
					if(((throwingdatum ? throwingdatum.speed : I.throw_speed) >= EMBED_THROWSPEED_THRESHOLD) || I.embedding.embedded_ignore_throwspeed_threshold)
						if(can_embed(I) && prob(I.embedding.embed_chance) && HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS) && !HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
							simple_add_embedded_object(I, silent = FALSE, crit_message = TRUE)
					I.do_special_attack_effect(I.thrownby, null, null, src, null, thrown = TRUE)
			visible_message("<span class='danger'>[src] is hit by [I]![next_attack_msg.Join()]</span>", \
							"<span class='danger'>I'm hit by [I]![next_attack_msg.Join()]</span>")
			next_attack_msg.Cut()
			if(I.thrownby)
				log_combat(I.thrownby, src, "threw and hit", I)
			var/volume = I.get_volume_by_throwforce_and_or_w_class()
			if (I.throwforce > 0)
				if (I.mob_throw_hit_sound)
					playsound(src, I.mob_throw_hit_sound, volume, TRUE, -1)
				else if(I.hitsound)
					playsound(src, pick(I.hitsound), volume, TRUE, -1)
				else
					playsound(src, 'sound/blank.ogg',volume, TRUE, -1)
			else
				playsound(src, 'sound/blank.ogg', volume, -1)
		else
			return 1

/mob/living/fire_act(added, maxstacks)
	if(added > 20)
		added = 20
	if(maxstacks > 20)
		maxstacks = 20
	if(!maxstacks)
		maxstacks = 1
	if(added)
		adjust_fire_stacks(added)
	else
		adjust_fire_stacks(1)
	ignite_mob()

/mob/living/proc/grabbedby(mob/living/carbon/user, supress_message = FALSE, item_override)
	if(!user || !src || anchored || !isturf(user.loc))
		return FALSE

	if(!user.pulling || user.pulling == src)
		user.start_pulling(src, supress_message = supress_message, item_override = item_override)
		return
/*
	if(!(status_flags & CANPUSH) || HAS_TRAIT(src, TRAIT_PUSHIMMUNE))
		to_chat(user, span_warning("[src] can't be grabbed more aggressively!"))
		return FALSE

	if(user.grab_state >= GRAB_AGGRESSIVE && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("I don't want to risk hurting [src]!"))
		return FALSE
	grippedby(user)*/

//proc to upgrade a simple pull into a more aggressive grab.
/mob/living/proc/grippedby(mob/living/carbon/user, instant = FALSE)
	user.changeNext_move(CLICK_CD_GRABBING * 2 - user.STASPD)
	var/skill_diff = 0
	var/combat_modifier = 1
	if(user.mind)
		skill_diff += (user.get_skill_level(/datum/skill/combat/wrestling)) //NPCs don't use this
	if(mind)
		skill_diff -= (get_skill_level(/datum/skill/combat/wrestling))

	if(user == src)
		instant = TRUE

	if(HAS_TRAIT(user, TRAIT_NOSTRUGGLE))	
		instant = TRUE
		
	if(surrendering)
		combat_modifier = 2

	if(restrained())
		combat_modifier += 0.25

	if(!(mobility_flags & MOBILITY_STAND) && user.mobility_flags & MOBILITY_STAND)
		combat_modifier += 0.05

	if(user.cmode && !cmode)
		combat_modifier += 0.3
	else if(!user.cmode && cmode)
		combat_modifier -= 0.3
	for(var/obj/item/grabbing/G in grabbedby)
		if(G.chokehold == TRUE)
			combat_modifier += 0.15
	if(!instant && !surrendering && !restrained() && !compliance)
		if(user.badluck(10))
			badluckmessage(user)
			return
	var/probby
	if(!compliance)
		probby = clamp((((4 + (((user.STASTR - STASTR)/2) + skill_diff)) * 10 + rand(-5, 5)) * combat_modifier), 5, 95)
	else
		probby = 100

	if(!prob(probby) && !instant && !stat)
		visible_message(span_warning("[user] struggles with [src]!"),
						span_warning("[user] struggles to restrain me!"), span_hear("I hear aggressive shuffling!"), null, user)
		if(src.client?.prefs.showrolls)
			to_chat(user, span_warning("I struggle with [src]! [probby]%"))
		else
			to_chat(user, span_warning("I struggle with [src]!"))
		playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
		user.Immobilize(2 SECONDS)
		user.changeNext_move(2 SECONDS)
		src.Immobilize(1 SECONDS)
		src.changeNext_move(1 SECONDS)
		if(user.badluck(5))
			badluckmessage(user)
			user.stop_pulling()
		return

	if(!instant)
		var/sound_to_play = 'sound/foley/grab.ogg'
		playsound(src.loc, sound_to_play, 100, FALSE, -1)


	user.setGrabState(GRAB_AGGRESSIVE)
	if(user.active_hand_index == 1)
		if(user.r_grab)
			user.r_grab.grab_state = GRAB_AGGRESSIVE
	if(user.active_hand_index == 2)
		if(user.l_grab)
			user.l_grab.grab_state = GRAB_AGGRESSIVE

	user.update_grab_intents()

	var/add_log = ""
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		add_log = " (pacifist)"
	send_grabbed_message(user)
	if(user != src)
		if(pulling != user) // If the person we're pulling aggro grabs us don't break the grab
			stop_pulling()
		user.set_pull_offsets(src, user.grab_state)
	log_combat(user, src, "grabbed", addition="aggressive grab[add_log]")
	return 1

/mob/living/proc/update_grab_intents(mob/living/target)
	return

/mob/living/carbon/update_grab_intents()
	var/obj/item/grabbing/G = get_active_held_item()
	if(!istype(G))
		return
	if(ismob(G.grabbed))
		if(isitem(G.sublimb_grabbed))
			var/obj/item/I = G.sublimb_grabbed
			G.possible_item_intents = I.grabbedintents(src, G.sublimb_grabbed)
		else
			if(iscarbon(G.grabbed) && G.limb_grabbed)
				var/obj/item/I = G.limb_grabbed
				G.possible_item_intents = I.grabbedintents(src, G.sublimb_grabbed)
			else
				var/mob/M = G.grabbed
				G.possible_item_intents = M.grabbedintents(src, G.sublimb_grabbed)
	if(isobj(G.grabbed))
		var/obj/I = G.grabbed
		G.possible_item_intents = I.grabbedintents(src, G.sublimb_grabbed)
	if(isturf(G.grabbed))
		var/turf/T = G.grabbed
		G.possible_item_intents = T.grabbedintents(src)
	update_a_intents()

/turf/proc/grabbedintents(mob/living/user)
	//RTD up and down
	return list(/datum/intent/grab/move)

/obj/proc/grabbedintents(mob/living/user, precise)
	return list(/datum/intent/grab/move)

/obj/item/grabbedintents(mob/living/user, precise)
	return list(/datum/intent/grab/remove, /datum/intent/grab/twistitem)

/mob/proc/grabbedintents(mob/living/user, precise)
	return list(/datum/intent/grab/move)

/mob/living/proc/send_grabbed_message(mob/living/carbon/user)
	if(HAS_TRAIT(user, TRAIT_NOTIGHTGRABMESSAGE))	
		return
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		visible_message(span_danger("[user] firmly grips [src]!"),
						span_danger("[user] firmly grips me!"), span_hear("I hear aggressive shuffling!"), null, user)
		to_chat(user, span_danger("I firmly grip [src]!"))
	else
		visible_message(span_danger("[user] tightens [user.p_their()] grip on [src]!"), \
						span_danger("[user] tightens [user.p_their()] grip on me!"), span_hear("I hear aggressive shuffling!"), null, user)
		to_chat(user, span_danger("I tighten my grip on [src]!"))

/mob/living/attack_animal(mob/living/simple_animal/M)
	if(M.swinging)
		return
	M.swinging = TRUE
	M.face_atom(src)
	if(M.melee_damage_upper == 0)
		visible_message(span_notice("\The [M] [pick(M.a_intent.attack_verb)] [src]."), \
						span_notice("\The [M] [pick(M.a_intent.attack_verb)] me!"), null, COMBAT_MESSAGE_RANGE)
		return FALSE
	if(HAS_TRAIT(M, TRAIT_PACIFISM))
		to_chat(M, span_warning("I don't want to hurt anyone!"))
		return FALSE

	M.do_attack_animation(src, visual_effect_icon = M.a_intent.animname)
	playsound(get_turf(M), pick(M.attack_sound), 100, FALSE)

	var/cached_intent = M.used_intent

	sleep(M.used_intent.swingdelay)
	M.swinging = FALSE
	if(M.a_intent != cached_intent)
		return FALSE
	if(QDELETED(src) || QDELETED(M))
		return FALSE
	if(!M.CanReach(src)) // Possible performance hit.
		return FALSE
	if(M.incapacitated())
		return FALSE

	if(checkmiss(M))
		return FALSE

	if(checkdefense(M.a_intent, M))
		return FALSE

	if(M.attack_sound)
		playsound(loc, M.a_intent.hitsound, 100, FALSE)

	log_combat(M, src, "attacked")

	return TRUE


/mob/living/attack_paw(mob/living/carbon/monkey/M)
	if(isturf(loc) && istype(loc.loc, /area/start))
//		to_chat(M, "No attacking people at spawn, you jackass.")
		return FALSE

	if (M.used_intent.type == INTENT_HARM)
		if(HAS_TRAIT(M, TRAIT_PACIFISM))
			to_chat(M, span_info("I don't want to hurt anyone!"))
			return FALSE

		if(M.is_muzzled() || M.is_mouth_covered(FALSE, TRUE))
			to_chat(M, span_warning("I can't bite with my mouth covered!"))
			return FALSE
		M.do_attack_animation(src, ATTACK_EFFECT_BITE)
		if (prob(75))
			log_combat(M, src, "attacked")
			playsound(loc, 'sound/blank.ogg', 50, TRUE, -1)
			visible_message(span_danger("[M.name] bites [src]!"), \
							span_danger("[M.name] bites you!"), span_hear("I hear a chomp!"), COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_danger("I bite [src]!"))
			return TRUE
		else
			visible_message(span_danger("[M.name]'s bite misses [src]!"), \
							span_danger("I avoid [M.name]'s bite!"), span_hear("I hear the sound of jaws snapping shut!"), COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_warning("My bite misses [src]!"))
	return FALSE

/mob/living/ex_act(severity, target)
	..()

/mob/living/attack_paw(mob/living/carbon/monkey/M)
	if(isturf(loc) && istype(loc.loc, /area/start))
//		to_chat(M, "No attacking people at spawn, you jackass.")
		return FALSE

	if (M.used_intent.type == INTENT_HARM)
		if(HAS_TRAIT(M, TRAIT_PACIFISM))
			to_chat(M, span_info("I don't want to hurt anyone!"))
			return FALSE

		if(M.is_muzzled() || M.is_mouth_covered(FALSE, TRUE))
			to_chat(M, span_warning("I can't bite with my mouth covered!"))
			return FALSE
		M.do_attack_animation(src, ATTACK_EFFECT_BITE)
		if (prob(75))
			log_combat(M, src, "attacked")
			playsound(loc, 'sound/blank.ogg', 50, TRUE, -1)
			visible_message(span_danger("[M.name] bites [src]!"), \
							span_danger("[M.name] bites you!"), span_hear("I hear a chomp!"), COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_danger("I bite [src]!"))
			return TRUE
		else
			visible_message(span_danger("[M.name]'s bite misses [src]!"), \
							span_danger("I avoid [M.name]'s bite!"), span_hear("I hear the sound of jaws snapping shut!"), COMBAT_MESSAGE_RANGE, M)
			to_chat(M, span_warning("My bite misses [src]!"))
	return FALSE

//Looking for irradiate()? It's been moved to radiation.dm under the rad_act() for mobs.

/mob/living/acid_act(acidpwr, acid_volume)
	take_bodypart_damage(acidpwr * min(1, acid_volume * 0.1))
	return 1

///As the name suggests, this should be called to apply electric shocks.
/mob/living/proc/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	SEND_SIGNAL(src, COMSIG_LIVING_ELECTROCUTE_ACT, shock_damage, source, siemens_coeff, flags)
	shock_damage *= siemens_coeff
	if((flags & SHOCK_TESLA) && (flags_1 & TESLA_IGNORE_1))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_SHOCKIMMUNE))
		return FALSE
	if(shock_damage < 1)
		return FALSE
	if(!(flags & SHOCK_ILLUSION))
		adjustFireLoss(shock_damage)
	else
		adjustStaminaLoss(shock_damage)
	visible_message(
		span_danger("[src] was shocked by \the [source]!"), \
		span_danger("I feel a powerful shock coursing through my body!"), \
		span_hear("I hear a heavy electrical crack.") \
	)
	playsound(get_turf(src), pick('sound/misc/elec (1).ogg', 'sound/misc/elec (2).ogg', 'sound/misc/elec (3).ogg'), 100, FALSE)
	return shock_damage

/mob/living/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_CONTENTS)
		return
	for(var/obj/O in contents)
		O.emp_act(severity)


//called when the mob receives a bright flash
/mob/living/proc/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /atom/movable/screen/fullscreen/flash)
	if(HAS_TRAIT(src, TRAIT_NOFLASH))
		return FALSE
	if(get_eye_protection() < intensity && (override_blindness_check || !(HAS_TRAIT(src, TRAIT_BLIND))))
		overlay_fullscreen("flash", type)
		addtimer(CALLBACK(src, PROC_REF(clear_fullscreen), "flash", 25), 25)
		return TRUE
	return FALSE

//called when the mob receives a loud bang
/mob/living/proc/soundbang_act()
	return 0

//to damage the clothes worn by a mob
/mob/living/proc/damage_clothes(damage_amount, damage_type = BRUTE, damage_flag = 0, def_zone)
	return


/mob/living/do_attack_animation(atom/A, visual_effect_icon, obj/item/used_item, no_effect, item_animation_override = null, datum/intent/used_intent, simplified = TRUE)
	if(!used_item)
		used_item = get_active_held_item()
	..()
	setMovetype(movement_type & ~FLOATING) // If we were without gravity, the bouncing animation got stopped, so we make sure we restart the bouncing after the next movement.
