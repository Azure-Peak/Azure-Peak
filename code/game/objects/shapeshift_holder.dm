/datum/soullink/shapeshift
	var/obj/shapeshift_holder/source

/datum/soullink/shapeshift/ownerDies(gibbed, mob/living/owner)
	if(source && !source.restoring)
		source.casterDeath(gibbed)

/datum/soullink/shapeshift/sharerDies(gibbed, mob/living/sharer)
	if(source && !source.restoring)
		source.shapeDeath(gibbed)

/obj/shapeshift_holder
	name = "Shapeshift holder"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ON_FIRE | UNACIDABLE | ACID_PROOF

	var/mob/living/stored
	var/mob/living/shape
	var/restoring = FALSE

	var/datum/soullink/shapeshift/slink
	var/obj/effect/proc_holder/spell/targeted/shapeshift/source



/obj/shapeshift_holder/proc/rebuild_perception(mob/living/M)
	if(!M)
		return

	if(!M.client)
		return

	M.client.eye = M

	if(hascall(M, "reset_perspective"))
		M.reset_perspective(null)

	if(hascall(M, "update_sight"))
		M.update_sight()



/obj/shapeshift_holder/proc/hard_reset_spatial(mob/living/M)
	if(!M)
		return

	var/atom/oldloc = M.loc

	M.moveToNullspace()

	if(oldloc)
		M.forceMove(oldloc)
//


/obj/shapeshift_holder/Initialize(mapload, obj/effect/proc_holder/spell/targeted/shapeshift/source, mob/living/caster, mob/living/new_shape)
	. = ..()

	src.source = source
	stored = caster
	shape = new_shape

	if(!stored || !shape)
		to_chat(caster, "Initialize failure: invalid mobs | stored=[stored] shape=[shape]")
		CRASH("shapeshift holder initialized without valid mobs")

	if(!isliving(shape))
		to_chat(caster, "Initialize failure: shape not living | shape=[shape]")
		CRASH("shapeshift holder received non-living shape")

	if(stored.mind)
		stored.mind.transfer_to(shape)

	rebuild_perception(shape)
	hard_reset_spatial(shape)

	stored.forceMove(src)
	stored.notransform = TRUE

	if(source?.convert_damage)
		var/damage_percent = (stored.maxHealth - stored.health) / max(stored.maxHealth, 1)
		var/damapply = damage_percent * shape.maxHealth
		shape.apply_damage(damapply, source.convert_damage_type, forced = TRUE)

	slink = soullink(/datum/soullink/shapeshift, stored, shape)
	if(slink)
		slink.source = src



/obj/shapeshift_holder/Destroy()
	restoring = TRUE

	if(slink)
		qdel(slink)
		slink = null

	stored = null
	shape = null

	return ..()



/obj/shapeshift_holder/Moved()
	if(restoring || QDELETED(src))
		return
	. = ..()
	restore()



/obj/shapeshift_holder/handle_atom_del(atom/A)
	if(restoring || QDELETED(src))
		return
	if(A == stored)
		restore()



/obj/shapeshift_holder/Exited(atom/movable/AM)
	if(restoring || QDELETED(src))
		return
	if(AM == stored)
		restore()



/obj/shapeshift_holder/proc/casterDeath(gibbed)
	if(source?.revert_on_death)
		restore(death = TRUE)
	else if(shape)
		shape.death()



/obj/shapeshift_holder/proc/shapeDeath(gibbed)
	if(source?.die_with_shapeshifted_form)
		if(source?.revert_on_death)
			restore(death = TRUE)
	else
		restore(knockout = source?.knockout_on_death)



/obj/shapeshift_holder/proc/restore(death = FALSE, knockout = 0)
	if(restoring || QDELETED(src))
		return

	restoring = TRUE

	if(slink)
		qdel(slink)
		slink = null

	if(!stored)
		qdel(src)
		return

	var/mob/living/temp = stored
	stored = null

	var/turf/original_turf = get_turf(src)

	if(original_turf)
		temp.forceMove(original_turf)
		hard_reset_spatial(temp)

	temp.notransform = FALSE

	var/datum/mind/M = temp?.mind || shape?.mind
	if(M)
		M.transfer_to(temp)

	rebuild_perception(temp)

	var/obj/effect/track/the_evidence = new(temp.loc)
	the_evidence.handle_creation(temp)

	if(knockout)
		temp.Unconscious(knockout, TRUE, TRUE)

	if(death)
		temp.death()
	else if(source?.convert_damage && shape)
		temp.revive(full_heal = TRUE, admin_revive = FALSE)

		var/damage_percent = (shape.maxHealth - shape.health) / max(shape.maxHealth, 1)
		var/damapply = temp.maxHealth * damage_percent
		temp.apply_damage(damapply, source.convert_damage_type, forced = TRUE)

	if(shape)
		var/mob/living/old_shape = shape
		shape = null
		qdel(old_shape)

	stored = temp

	qdel(src)
