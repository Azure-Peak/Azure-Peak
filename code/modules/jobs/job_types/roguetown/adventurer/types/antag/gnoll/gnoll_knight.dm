/datum/advclass/gnoll/knight
	name = "Gnoll Knight"
	tutorial = "You were forged in the fires of the volcano, burn marks have long since healed, but the armor hammered against your muscle isn't so fleeting."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/gnoll/knight
	category_tags = list(CTAG_GNOLL)
	traits_applied = list(TRAIT_HEAVYARMOR)
	
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	reset_stats = TRUE
	subclass_stats = list(
		// Weighted towards 16 currently. They don't get statpacks or racial stats, so we could consider this about 2 less at least, maybe 3. For about a 13.
		STATKEY_STR = 3,
		STATKEY_WIL = 3,
		STATKEY_CON = 4,
		STATKEY_SPD = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,

		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,

		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,

		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
	)
	cmode_music = 'sound/music/combat_graggar.ogg'

/datum/outfit/job/roguetown/gnoll/knight/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/knight(H)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		don_pelt(H)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/claws/gnoll/knight)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/knight
	icon_state = "knight"
	max_integrity = 750
	armor = ARMOR_GNOLL_STRONG
	relative_repair_interval = 25 SECONDS

/obj/item/rogueweapon/werewolf_claw/gnoll/knight
	var/coverage = 30 // Worse than any shield, but still some passive defense against ranged attacks.
	name = "Knight Claw"
	wdefense = 8 // The Knight gets the best Wdef. They have about 20% higher parry chance than Berserker.
	force = 30 // Deals 30 * 1.3 = 39 force with their base STR.
	possible_item_intents = list(/datum/intent/shield/block, /datum/intent/simple/werewolf/gnoll, /datum/intent/mace/smash/werewolf/gnoll/knight, /datum/intent/mace/strike/gnoll)

/obj/item/rogueweapon/werewolf_claw/gnoll/knight/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the projectile", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	var/mob/attacker
	var/obj/item/I
	if(attack_type == THROWN_PROJECTILE_ATTACK)
		if(istype(hitby, /obj/item)) // can't trust mob -> item assignments
			I = hitby
		if(I?.thrownby)
			attacker = I.thrownby
	if(attack_type == PROJECTILE_ATTACK)
		var/obj/projectile/P = hitby
		if(P?.firer)
			attacker = P.firer
	if(attacker && istype(attacker))
		if (!owner.can_see_cone(attacker))
			return FALSE
		if(obj_broken) // No blocking with a broken shield you fool
			return FALSE
		if((owner.client?.chargedprog == 100 && owner.used_intent?.tranged) || prob(coverage))
			owner.visible_message(span_danger("[owner] expertly blocks [hitby] with [src]!"))
			src.take_damage(floor(damage / 4))
			return TRUE
	return FALSE

/datum/intent/mace/smash/werewolf/gnoll/knight
	maxrange = 3 // Templar and Knight gets 3 tiles if they are buffed, no more.

/obj/item/rogueweapon/werewolf_claw/gnoll/knight/right
	icon_state = "claw_r"
	wlength = WLENGTH_SHORT

/obj/item/rogueweapon/werewolf_claw/gnoll/knight/left
	icon_state = "claw_l"
	wlength = WLENGTH_SHORT
