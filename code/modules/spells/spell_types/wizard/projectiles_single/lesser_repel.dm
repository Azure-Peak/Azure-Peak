/obj/effect/proc_holder/spell/invoked/projectile/lesser_repel
	name = "Lesser Repel"
	desc = "Shoot out a magical bolt that pushes away a freestanding item from the caster. Doesn't work on large or living targets. Instead of repelling a target, it will throw an object in your hand if cast while in throw mode."
	clothes_req = FALSE
	range = 15
	projectile_type = /obj/projectile/magic/lesser_repel
	overlay_state = "fetch"
	sound = list('sound/magic/unmagnet.ogg')
	active = FALSE
	releasedrain = 15
	chargedrain = 0
	chargetime = 0
	recharge_time = 15 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	invocations = list("Minora Exmoveo!")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW
	cost = 1

/obj/projectile/magic/lesser_repel
	name = "lesser bolt of repelling"
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	range = 15
	cannot_cross_z = TRUE

/obj/effect/proc_holder/spell/invoked/projectile/lesser_repel/cast(list/targets, mob/living/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/proj = H.get_active_held_item()
		if(isobj(proj))
			var/obj/I = proj
			if(I && H.in_throw_mode)
				var/atom/throw_target = get_edge_target_turf(H, get_dir(user,get_step(user,user.dir)))
				if(throw_target)
					invocation(user)
					H.dropItemToGround(I)
					if(I)	//In case it's something that gets qdel'd on drop
						I.throw_at(throw_target, 7, 4)
						H.throw_mode_off()
					return TRUE
	. = ..()

/obj/projectile/magic/lesser_repel/on_hit(target)
	var/atom/throw_target = get_edge_target_turf(firer, get_dir(firer, target))
	if(isliving(target))
		var/mob/living/L = target
		L.visible_message(span_warning("[src] vanishes on contact with [target]!"))
		return BULLET_ACT_BLOCK
	else
		if(isitem(target))
			var/obj/item/I = target
			var/mob/living/carbon/human/carbon_firer
			if (ishuman(firer))
				carbon_firer = firer
				if (carbon_firer?.can_catch_item())
					throw_target = get_edge_target_turf(firer, get_dir(firer, target))
			I.throw_at(throw_target, 7, 4)
