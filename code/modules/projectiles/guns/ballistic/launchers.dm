//KEEP IN MIND: These are different from gun/grenadelauncher. These are designed to shoot premade rocket and grenade projectiles, not flashbangs or chemistry casings etc.
//Put handheld rocket launchers here if someone ever decides to make something so hilarious ~Paprika

/obj/item/gun/ballistic/revolver/grenadelauncher//this is only used for underbarrel grenade launchers at the moment, but admins can still spawn it if they feel like being assholes
	desc = ""
	name = "grenade launcher"
	icon_state = "dshotgun_sawn"
	item_state = "gun"
	fire_sound = 'sound/blank.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	bolt_type = BOLT_TYPE_NO_BOLT
	istrainable = TRUE // For the moment I'll allow these to be traineable until a proper way to level up bows and crossbows is coded. - Foxtrot
	var/damfactor = 1 // Multiplier for projectile damage. Used by bows and crossbows.
	var/accfactor = 1 // Multiplier for projectile accuracy. Used by bows and crossbows.
	var/penfactor = 0 // Additive modifier for projectile PEN tier. Slurbow uses -1 to reduce bolt pen by one tier.
	var/npc_force_arc = FALSE // Set by AI to force arc shot over allies
	var/uses_draw_curve = FALSE
	var/quickloading = FALSE
	var/ranged_skill = null
	var/draw_base = 0
	var/draw_floor = 0
	var/draw_per_skill = 0
	var/draw_per_str = 0
	var/arc_draw_extra = RANGED_ARC_DRAW_EXTRA
	var/arc_draw_floor_extra = RANGED_ARC_DRAW_FLOOR_EXTRA
	var/per_scales_damage = FALSE
	var/per_damage_baseline = RANGED_PER_DAMAGE_BASELINE
	var/per_damage_softcap = RANGED_PER_DAMAGE_SOFTCAP
	var/per_damage_mult = RANGED_PER_DAMAGE_MULT
	var/per_damage_cappedmult = RANGED_PER_DAMAGE_CAPPEDMULT
	var/per_damage_floor = RANGED_PER_DAMAGE_FLOOR
	var/draw_str_baseline = RANGED_DRAW_STR_BASELINE
	var/uncharged_spread = RANGED_UNCHARGED_SPREAD
	var/npc_spread_baseline_per = ARCHER_NPC_SPREAD_BASELINE
	var/npc_spread_per_point = 0
	var/early_release_acc_penalty = RANGED_EARLY_RELEASE_ACC_PENALTY
	var/early_release_embed_mult = RANGED_EARLY_RELEASE_EMBED_MULT
	var/release_drain = 0
	var/onehanded_draw_mult = 1
	var/onehanded_arc_draw_mult = 1

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/get_draw_time(mob/living/user, arcing = FALSE)
	if(!user || !draw_base)
		return 0
	var/newtime = draw_base
	var/floortime = draw_floor
	if(arcing)
		newtime += arc_draw_extra
		floortime += arc_draw_floor_extra
	if(ranged_skill)
		if(uses_draw_curve)
			var/list/curve = GLOB.ranged_draw_curve
			var/level = clamp(user.get_skill_level(ranged_skill), 0, length(curve) - 1)
			newtime = floortime + ((newtime - floortime) * curve[level + 1])
		else
			newtime -= user.get_skill_level(ranged_skill) * draw_per_skill
	if(draw_per_str)
		newtime += max(0, draw_str_baseline - user.STASTR) * draw_per_str
	newtime = max(newtime, floortime)
	if(chambered)
		newtime *= chambered.charge_time_mult
	return newtime

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/get_npc_chargetime(mob/living/user)
	if(!draw_base)
		return ARCHER_NPC_SIMULATED_CHARGETIME
	return (get_draw_time(user, npc_force_arc) + ARCHER_NPC_MIN_AIM_TIME + ARCHER_NPC_NOCK_TIME) * ARCHER_NPC_ROF_PENALTY

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/can_quick_load(mob/user)
	return TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/get_npc_drawtime(mob/living/user)
	return max(0, get_npc_chargetime(user) - ARCHER_NPC_NOCK_TIME)

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/get_shot_drain(mob/living/user, drain)
	if(!drain || !user)
		return 0
	if(!user.client)
		drain *= RANGED_NPC_DRAIN_MULT
	return drain

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/pay_release_drain(mob/living/user)
	var/cost = get_shot_drain(user, release_drain)
	if(cost)
		user.stamina_add(cost)

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/pay_letdown_drain(mob/living/user, draw_progress = 1)
	var/cost = get_shot_drain(user, release_drain * RANGED_LETDOWN_DRAIN_MULT * clamp(draw_progress, 0, 1))
	if(cost)
		user.stamina_add(cost)

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/get_per_damage_scaling(mob/living/user)
	if(!user || !per_scales_damage)
		return 1
	return max(per_damage_floor, 1 + ((min(user.STAPER, per_damage_softcap) - per_damage_baseline) * per_damage_mult) + (max(0, user.STAPER - per_damage_softcap) * per_damage_cappedmult))

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/get_ranged_spread(mob/living/user)
	if(!user)
		return 0
	if(!user.client)
		return max(0, (npc_spread_baseline_per - user.STAPER) * npc_spread_per_point)
	if(user.client.chargedprog >= 100)
		return user.client.charge_hold_instability * RANGED_HOLD_SPREAD_MAX
	return uncharged_spread - (uncharged_spread * (user.client.chargedprog / 100))

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/apply_ranged_accuracy(obj/projectile/BB, mob/living/user)
	if(!BB || !user)
		return
	var/level = ranged_skill ? user.get_skill_level(ranged_skill) : 0
	BB.aim_peak = (ACC_RANGED_BASE + (level * ACC_RANGED_PER_SKILL)) * accfactor

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/apply_early_release_penalty(obj/projectile/BB, mob/living/user)
	if(!BB || !user?.client || user.client.chargedprog >= 100)
		return
	BB.damage *= (user.client.chargedprog / 100)
	BB.embedchance *= early_release_embed_mult
	BB.aim_peak -= early_release_acc_penalty

/obj/item/gun/ballistic/revolver/grenadelauncher/get_mechanics_examine(mob/user)
	. = ..()
	if(chambered)
		. += chambered.get_sweetspot_examine("The loaded [chambered.name]")

/obj/item/gun/ballistic/revolver/grenadelauncher/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()
