// REGENERATING ARMOUR

/obj/item/clothing/suit/roguetown/armor/regenerating
	name = "regenerating armour"
	desc = "Abstract parent. Contact developer if you see this."
	icon_state = null
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR

	/// Feedback messages
	var/repairmsg_begin = "My armour begins to slowly mend its abuse.."
	var/repairmsg_continue = "My armour mends some of its abuse.."
	var/repairmsg_stop = "My armour stops mending from the onslaught!"
	var/repairmsg_end = "My armour has become taut with newfound vigor!"

	/// Time taken for regeneration
	var/repair_time
	/// Holder for timer
	var/reptimer

	/// To make repairs relative or not.
	/// In other words, if you use relative repairing then it will use a different repair interval.
	/// Repair_time becomes how long it will take on average for the armor to fully repair itself.
	/// In this mode, armor doesn't repair with a flat 20%, but it repairs at a rate relative to the total time set to repair armor on average.
	var/relative_repair_mode = FALSE
	var/relative_repair_interval = 15 SECONDS

	/// Auto mode.
	/// Enables relative repair mode if not enabled.
	/// Sets the total repair time of the armor to be relative to the base repair amount and time.
	/// By default, aims to repair 100 armor every 15 seconds.
	var/auto_repair_mode = FALSE
	var/auto_repair_mode_triggered = FALSE
	var/auto_repair_mode_base = 100
	var/auto_repair_mode_time = 15 SECONDS

	/// Regen interrupt vars
	var/interrupt_damount
	var/interrupt_dtype
	var/interrupt_dflag
	var/interrupt_ddir

/obj/item/clothing/suit/roguetown/armor/regenerating/Initialize(mapload)
	. = ..()
	if(auto_repair_mode)
		setup_auto_repair()

/obj/item/clothing/suit/roguetown/armor/regenerating/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	..()
	if(reptimer)
		if(!regen_interrupt(damage_amount, damage_type, damage_flag, attack_dir))
			return
		to_chat(loc, span_notice(repairmsg_stop))
		deltimer(reptimer)
		reptimer = null

	// If relative repair mode is on, use the interval instead of repairing 20% every repair_time seconds
	var/wait_time = relative_repair_mode ? relative_repair_interval : repair_time

	to_chat(loc, span_notice(repairmsg_begin))
	reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), wait_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/item/clothing/suit/roguetown/armor/regenerating/proc/armour_regen()
	reptimer = null

	if(obj_integrity >= max_integrity)
		to_chat(loc, span_notice(repairmsg_end))
		return

	var/repair_amount
	var/next_tick_time
	var/skin_broken = 0
	if(obj_integrity == 0)
		skin_broken = 1

	if(relative_repair_mode)
		// math: (interval / total time) * max health
		// example: (5s / 50s) * 100 HP = 10 HP per tick
		var/repair_ratio = relative_repair_interval / repair_time
		if(!skin_broken)
			repair_amount = repair_ratio * max_integrity
		else
			repair_amount = 5
		next_tick_time = relative_repair_interval
	else
		// static mode: 20% of max integrity
		if(!skin_broken)
			repair_amount = 0.2 * max_integrity
		else
			repair_amount = 5
		next_tick_time = repair_time

	obj_integrity = min(obj_integrity + repair_amount, max_integrity)

	// Fix armor so it can still be interrupted from regenerating
	if(obj_broken && obj_integrity > 0)
		obj_fix(full_repair = FALSE)

	to_chat(loc, span_notice(repairmsg_continue))

	reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), next_tick_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/item/clothing/suit/roguetown/armor/regenerating/proc/regen_interrupt(damage_amount, damage_type, damage_flag, attack_dir)
	if(interrupt_damount && interrupt_damount > damage_amount)
		return FALSE
	if(interrupt_dtype && interrupt_dtype != damage_type)
		return FALSE
	if(interrupt_dflag && interrupt_dflag != damage_flag)
		return FALSE
	if(interrupt_ddir && interrupt_ddir != attack_dir)
		return FALSE
	return TRUE

/obj/item/clothing/suit/roguetown/armor/regenerating/proc/setup_auto_repair()
	repair_time = (max_integrity / auto_repair_mode_base) * auto_repair_mode_time
	
	// Ensure relative mode is on to respect the new calculated repair_time
	relative_repair_mode = TRUE
	auto_repair_mode_triggered = TRUE

// SKIN ARMOUR

/obj/item/clothing/suit/roguetown/armor/regenerating/skin
	name = "regenerating skin"
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	resistance_flags = FIRE_PROOF
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL
	flags_inv = null //Exposes the chest and-or breasts.
	surgery_cover = FALSE //Should permit surgery and other invasive processes.
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = ARMOR_CLASS_LIGHT
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	armor = ARMOR_PADDED

	repairmsg_begin = "My skin begins to slowly mend its abuse.."
	repairmsg_continue = "My skin mends some of its abuse.."
	repairmsg_stop = "My skin stops mending from the onslaught!"
	repairmsg_end = "My skin has become taut with newfound vigor!"

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/Initialize(mapload)
	..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/dropped(mob/living/carbon/human/user)
	..()
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple
	name = "disciple's skin"
	desc = "It's far more than just an oath. \
	</br>Aeon, Psydon, Adonai. Entropy, Humenity, Divinity; a trinity known to all, yet forgotten to tyme. \
	</br>A corpse. I am living on a fucking corpse. He is the world, and the world is rotting away. \
	</br>To give into despair and hopelessness, however, is to rob all meaning from His sacrifice. \
	</br>Heaven's gate closed to us long ago, yet His children persist; as as long as they do, so must I. \
	</br>Happiness must be fought for."
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0) //Custom value; padded gambeson's slash- and stab- armor.
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	max_integrity = 400
	repair_time = 20 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/iconoclast
	name = "dragon's skin"
	desc = "We passed upon the stair, we spoke of was and when.</br> \
	Although I wasn't there, he said I was his friend.</br> \
	Which came as some surprise. I spoke into his eyes.</br> \
	I thought you died alone, a long, long time ago.</br> \
	Oh no, not me, I never lost control.</br> \
	You're face to face, with the man who sold the world."
	armor = list("blunt" = 40, "slash" = 60, "stab" = 50, "piercing" = 40, "fire" = 50, "acid" = 0) //Fire resistance unlike the disciple one
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	max_integrity = 450
	repair_time = 20 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
	name = "barbarian's skin"
	desc = "Toughened from abuse. My mettle remains."
	max_integrity = 200
	repair_time = 25 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/berserker
	name = "berserker's skin"
	desc = "I've endured enough. The onslaught has lost its meaning."
	armor = ARMOR_LEATHER

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/bailiff
	name = "executioneer's skin"
	desc = "Bearing scars of countless whips leaves a gnarly visage. Now it's your time to inflict the same fate upon others."
	max_integrity = 250
