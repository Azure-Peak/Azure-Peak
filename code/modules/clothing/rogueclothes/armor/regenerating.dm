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

	/// Regen interrupt vars
	var/interrupt_damount
	var/interrupt_dtype
	var/interrupt_dflag
	var/interrupt_ddir

	/// Added to support healable skin armor.
	var/regeneration = TRUE

/obj/item/clothing/suit/roguetown/armor/regenerating/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	..()
	if(regeneration)
		if(reptimer)
			if(!regen_interrupt(damage_amount, damage_type, damage_flag, attack_dir))
				return
			to_chat(loc, span_notice(repairmsg_stop))
			deltimer(reptimer)

		to_chat(loc, span_notice(repairmsg_begin))
		reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), repair_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/obj/item/clothing/suit/roguetown/armor/regenerating/proc/armour_regen(var/repair_percent = 0.2 * max_integrity)
	if(obj_integrity >= max_integrity)
		to_chat(loc, span_notice(repairmsg_end))
		if(reptimer)
			deltimer(reptimer)
		return

	to_chat(loc, span_notice(repairmsg_continue))
	obj_integrity = min(obj_integrity + repair_percent, max_integrity)
	if(obj_broken)
		obj_fix(full_repair = FALSE)
	if(regeneration)
		reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), repair_time, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

		

/obj/item/clothing/suit/roguetown/armor/regenerating/proc/regen_interrupt(damage_amount, damage_type, damage_flag, attack_dir)
	if(regeneration)
		if(interrupt_damount && interrupt_damount > damage_amount)
			return FALSE
		if(interrupt_dtype && interrupt_dtype != damage_type)
			return FALSE
		if(interrupt_dflag && interrupt_dflag != damage_flag)
			return FALSE
		if(interrupt_ddir && interrupt_ddir != attack_dir)
			return FALSE
		return TRUE


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
	desc = "It's far more than just an oath. </br>'AEON, PSYDON, ADONAI - ENTROPY, HUMENITY, DIVINITY. A TRINITY THAT IS ONE, \
	YET THREE; KNOWN BY ALL, YET FORGOTTEN TO TYME.' </br>'A CORPSE. \
	I AM LIVING ON A FUCKING CORPSE. HE IS THE WORLD, AND THE WORLD IS ROTTING AWAY. \
	HEAVEN CLOSED ITS GATES TO US, LONG AGO.' </br>'YET, HIS CHILDREN PERSIST; AND AS LONG AS THEY DO, SO MUST I. \
	HAPPINESS MUST BE FOUGHT FOR.'"
	armor = list("blunt" = 30, "slash" = 50, "stab" = 50, "piercing" = 20, "fire" = 0, "acid" = 0) //Custom value; padded gambeson's slash- and stab- armor.
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT)
	max_integrity = 300
	repair_time = 20 SECONDS


/// Abstract parent for all healable sources. This is here because I expect that other sources of healing will be added in the future.
/obj/item/clothing/suit/roguetown/armor/regenerating/skin/healable
	name = "healable skin armor"
	desc = "This is an abstract parent for future forms of healable skin armor. If you see this, contact a dev."

	/// Might break things if you turn this on w/ a secondary source of healing.
	regeneration = FALSE


/// The check for calling armour regen for this is in exercise.dm, and while this is unideal, I'm not a good enough coder to know another way.
/obj/item/clothing/suit/roguetown/armor/regenerating/skin/healable/pushups
	name = "muscled skin"
	desc = "The reward for all your hard work. </br> THE INFLUENCE OF THE HAM SANDWYCH RACE IS WANING. I MUST DO PUSH-UPS, TO REMIND MY MUSCLES OF THEIR OWN STRENGTH."

	/// We don't have repairmsg_stop set because there shouldn't be any way the healing can be interrupted. If you wanna try and do pushups as someone's smacking you with a sword, be my guest.
	/// The same thing for begin: we don't use the timers, so it shouldn't ever be called.
	repairmsg_continue = "My muscles mend from my efforts."
	repairmsg_end = "My muscles sheen with vitality!"


/// For advent barbarian. Sets armor stats to be equal to leather armor.
/obj/item/clothing/suit/roguetown/armor/regenerating/skin/healable/pushups/leather
	armor_class = ARMOR_LEATHER

/// For wretch beserkers. An upgraded version of the advent one.
/obj/item/clothing/suit/roguetown/armor/regenerating/skin/healable/pushups/leather/good
	armor_class = ARMOR_LEATHER_GOOD