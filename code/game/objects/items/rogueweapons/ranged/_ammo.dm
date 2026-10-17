//parent of all bolts and arrows ฅ^•ﻌ•^ฅ
/obj/item/ammo_casing/caseless/rogue
	firing_effect_type = null
	icon = 'icons/roguetown/weapons/ammo.dmi'
	var/ammo_weight = 1 // Weight cost in a quiver. Default 1, heavy ammo costs more.
	materia = list(/datum/materia_aspect/air, /datum/materia_aspect/weapon)

/obj/item/ammo_casing/caseless/rogue/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Projectiles have maximum and minimum falloff ranges, with particular falloff factors for damage.")
	. += span_info("If the target is hit between the maximum and minimum tile range, then the full force is delivered.")
	. += get_sweetspot_examine()

/// Returns examine lines describing the sweetspot (full-force range) of this casing's projectile, or an empty list if it has none.
/obj/item/ammo_casing/proc/get_sweetspot_examine(subject = "This projectile")
	var/sweet_min
	var/sweet_max
	var/falloff
	if(BB)
		sweet_min = BB.min_range
		sweet_max = BB.max_range
		falloff = BB.dam_falloff_factor
	else if(projectile_type)
		var/obj/projectile/proj = projectile_type
		sweet_min = initial(proj.min_range)
		sweet_max = initial(proj.max_range)
		falloff = initial(proj.dam_falloff_factor)
	. = list()
	if(!sweet_min && !sweet_max)
		return
	if(sweet_min && sweet_max)
		. += span_info("[subject] has a sweetspot between <b>[sweet_min]</b> and <b>[sweet_max]</b> tiles, where it delivers full force.")
	else if(sweet_max)
		. += span_info("[subject] has a sweetspot up to <b>[sweet_max]</b> tiles, where it delivers full force.")
	else
		. += span_info("[subject] has a sweetspot beyond <b>[sweet_min]</b> tiles, where it delivers full force.")
	if(falloff != 1)
		. += span_info("Outside the sweetspot, its damage is reduced to <b>[falloff * 100]%</b>.")

/obj/item/ammo_casing/caseless/rogue/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -6,"nx" = 11,"ny" = -6,"wx" = -4,"wy" = -6,"ex" = 2,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//parent variable to projectiles
/obj/projectile
	var/is_silver_proj = FALSE //Self-explanatory.
	var/datum/action/cooldown/spell/source_spell
	/// Additional damage from a bow special based on the total damage of a fired projectile
	var/bow_smite_modifier
	/// Hunting skill from the person that just fired this projectile with a bow special
	var/hunting_skill
	/// Base damage from smites inherited by the bow used
	var/bow_smite_base_damage = 40

//handles the infliction of special effects upon projectile impact, such as silver-blighting
/obj/projectile/proc/do_special_projectile_effect(firer, obj/item/bodypart/affecting, mob/living/victim, selzone)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(victim, COMSIG_PROJECTILE_ATTACK_EFFECT, firer, affecting, selzone, src)
	SEND_SIGNAL(src, COMSIG_PROJECTILE_ATTACK_EFFECT_SELF, firer, affecting, victim, selzone)

	if(is_silver_proj && HAS_TRAIT(victim, TRAIT_SILVER_WEAK))
		SEND_SIGNAL(victim, COMSIG_FORCE_UNDISGUISE)
		to_chat(victim, span_silver("Silver rebukes my presence! My vitae smolders, and my powers wane!"))
		victim.adjust_fire_stacks(1, /datum/status_effect/fire_handler/fire_stacks/sunder) // Ammunition can't be blessed.
		victim.ignite_mob()

/obj/projectile/proc/get_bow_smite_damage(mob/living/target)
	var/base_damage = bow_smite_base_damage
	// 15% of the damage of the projectile is retained.
	// This means stone arrows are less effective, but not by much as to reduce the sheer value of bonus stacking.
	var/projectile_flat_bonus = round(damage * 0.15)
	var/hunting_skill_flat_bonus
	if(hunting_skill <= 2)
		// Levels 0-2 give up to +5 bonus (2.5 per level)
		hunting_skill_flat_bonus = round(hunting_skill * 2.5)
	else
		// Levels 3-6 give up to +7 additional bonus (~1.75 per level)
		hunting_skill_flat_bonus = 5 + round((hunting_skill - 2) * 1.75)
	var/adjusted_base_damage = base_damage + projectile_flat_bonus + hunting_skill_flat_bonus

	// Grab the smite multiplication modifier from the mob itself.
	// If unset, simply don't increase the base damage.
	// 60% extra damage taken by default
	var/damage_modifier
	if(!target.bow_smite_effective_modifier)
		damage_modifier = 1
	else
		damage_modifier = target.bow_smite_effective_modifier

	// Return increased damage if it's higher than the projectile's damage value only.
	// Yes, this does mean you can have cases firing at certain targets where your damage isn't increased at all for using your smite.
	return max(round(adjusted_base_damage * damage_modifier), damage)
