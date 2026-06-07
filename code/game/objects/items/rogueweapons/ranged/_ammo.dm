//parent of all bolts and arrows ฅ^•ﻌ•^ฅ
/obj/item/ammo_casing/caseless/rogue
	firing_effect_type = null
	icon = 'icons/roguetown/weapons/ammo.dmi'
	var/ammo_weight = 1 // Weight cost in a quiver. Default 1, heavy ammo costs more.

/obj/item/ammo_casing/caseless/rogue/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Projectiles have maximum and minimum falloff ranges, with particular falloff factors for damage.")
	. += span_info("If the target is hit between the maximum and minimum tile range, then the full force is delivered.")

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

//handles the infliction of special effects upon projectile impact, such as silver-blighting
/obj/projectile/proc/do_special_projectile_effect(firer, obj/item/bodypart/affecting, mob/living/victim, selzone)
    SHOULD_CALL_PARENT(TRUE)
    SEND_SIGNAL(victim, COMSIG_PROJECTILE_ATTACK_EFFECT, firer, affecting, selzone, src)
    SEND_SIGNAL(src, COMSIG_PROJECTILE_ATTACK_EFFECT_SELF, firer, affecting, victim, selzone)

    if(is_silver_proj && HAS_TRAIT(victim, TRAIT_SILVER_WEAK))
        SEND_SIGNAL(victim, COMSIG_FORCE_UNDISGUISE)
        to_chat(victim, span_danger("Silver rebukes my presence! My vitae smolders, and my powers wane!"))
        victim.adjust_fire_stacks(1, /datum/status_effect/fire_handler/fire_stacks/sunder) // Ammunition can't be blessed.
        victim.ignite_mob()
