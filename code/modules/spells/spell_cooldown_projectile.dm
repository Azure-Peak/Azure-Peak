/**
 * ### Projectile spells
 *
 * Spells that fire a projectile on cast — either at a clicked target
 * (click_to_activate = TRUE) or in the caster's facing direction.
 *
 * Supports firing multiple projectiles per cast via projectiles_per_fire.
 * The iteration index is passed to ready_projectile() so subtypes can
 * apply spread angles (see Stygian Efflorescence for a shotgun pattern).
 *
 * Supports arc mode toggle via projectile_type_arc.
 */
/datum/action/cooldown/spell/projectile
	abstract_type = /datum/action/cooldown/spell/projectile
	self_cast_possible = FALSE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC // Projectiles travel physically, no same-Z restriction

	/// What projectile we create when we shoot our spell.
	var/obj/projectile/projectile_type = /obj/projectile/magic/teleport
	/// Optional arc mode projectile variant. If set, spell supports arc mode toggle.
	var/obj/projectile/projectile_type_arc
	/// How many projectiles we fire per cast. Each gets ready_projectile() called with an iteration index.
	var/projectiles_per_fire = 1
	/// Whether this spell is currently set to fire in arc mode.
	var/arc_mode = FALSE

/datum/action/cooldown/spell/projectile/generate_wiki_html(mob/user)
	if(!displayed_damage && projectile_type)
		displayed_damage = initial(projectile_type.damage)
	return ..()

/// cast_on is the turf or atom we're firing at.
/datum/action/cooldown/spell/projectile/cast(atom/cast_on)
	. = ..()
	if(!isturf(owner.loc))
		return FALSE

	var/atom/target = cast_on
	// For non-click spells, resolve target in the caster's facing direction
	if(!click_to_activate)
		target = get_ranged_target_turf(owner, owner.dir, cast_range)

	fire_projectile(target)
	return TRUE

/// Fire the projectile(s) at the target.
/datum/action/cooldown/spell/projectile/proc/fire_projectile(atom/target)
	for(var/i in 1 to projectiles_per_fire)
		var/active_type = (arc_mode && projectile_type_arc) ? projectile_type_arc : projectile_type
		var/obj/projectile/to_fire = new active_type(owner.loc)
		ready_projectile(to_fire, target, owner, i)
		to_fire.fire()
	return TRUE

/// Configure the projectile before firing. Override for spell-specific setup (e.g., spread angles).
/// iteration is the 1-indexed projectile number within this volley.
/datum/action/cooldown/spell/projectile/proc/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	to_fire.firer = user
	to_fire.fired_from = get_turf(user)
	to_fire.def_zone = user.zone_selected

	// Propagate spell impact intensity to the projectile
	if(istype(to_fire, /obj/projectile/magic))
		var/obj/projectile/magic/M = to_fire
		M.spell_impact_intensity = spell_impact_intensity

	// Accuracy from INT and skill, matching the old proc_holder system
	if(isliving(user))
		var/mob/living/L = user
		to_fire.accuracy += (L.STAINT - 9) * 4
		to_fire.bonus_accuracy += (L.STAINT - 8) * 3
		if(L.mind)
			to_fire.bonus_accuracy += (L.get_skill_level(associated_skill) * 5)

	// Apply attunement glow if the caster is holding a spell implement
	if(attunement_school && ishuman(user))
		var/obj/item/rogueweapon/best_implement = get_held_implement(user)
		best_implement?.attune_implement(spell_color, attunement_school)

	to_fire.preparePixelProjectile(target, user)

	// Register hit signal so the spell knows when the projectile connects
	RegisterSignal(to_fire, COMSIG_PROJECTILE_SELF_ON_HIT, PROC_REF(on_cast_hit))

/// Signal handler for when our projectile hits something.
/datum/action/cooldown/spell/projectile/proc/on_cast_hit(atom/source, mob/firer, atom/hit, angle)
	SIGNAL_HANDLER

	SEND_SIGNAL(src, COMSIG_SPELL_PROJECTILE_HIT, hit, firer, source)

/// Toggle arc mode on this spell. Only works if projectile_type_arc is set.
/datum/action/cooldown/spell/projectile/proc/toggle_arc_mode(mob/user)
	if(!projectile_type_arc)
		to_chat(user, span_warning("[name] cannot be arced."))
		return
	arc_mode = !arc_mode
	to_chat(user, span_notice("[name] arc mode [arc_mode ? "enabled" : "disabled"]."))
	update_arc_maptext()

/// Updates the ARC maptext indicator on the spell's action button.
/datum/action/cooldown/spell/projectile/proc/update_arc_maptext()
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/arc_holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			arc_holder = existing
			break
		if(!arc_holder)
			arc_holder = new(B)
			B.vis_contents.Add(arc_holder)
		if(arc_mode)
			arc_holder.maptext = MAPTEXT("ARC")
			arc_holder.color = "#00ccff"
		else
			arc_holder.maptext = null

/datum/action/cooldown/spell/projectile/get_spell_statistics(mob/living/user)
	var/list/stats = ..(user)
	// Replace cast range with projectile range
	for(var/i in stats)
		if(findtext(i, "Range:"))
			stats -= i
			break
	var/proj_range = initial(projectile_type.range)
	if(proj_range)
		stats.Insert(1, span_info("Projectile range: [proj_range] tiles"))
	// Auto-display projectile damage
	var/proj_damage = initial(projectile_type.damage)
	if(proj_damage > 0)
		if(projectiles_per_fire > 1)
			stats += span_info("Damage: [proj_damage] x[projectiles_per_fire]")
		else
			stats += span_info("Damage: [proj_damage]")
	return stats
