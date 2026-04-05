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

/obj/item/gun/ballistic/revolver/grenadelauncher/proc/get_npc_chargetime(mob/living/user)
	return ARCHER_NPC_SIMULATED_CHARGETIME * ARCHER_NPC_ROF_PENALTY

/obj/item/gun/ballistic/revolver/grenadelauncher/attackby(obj/item/A, mob/user, params)
	. = ..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()
