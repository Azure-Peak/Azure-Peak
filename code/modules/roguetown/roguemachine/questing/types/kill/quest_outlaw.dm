/// Goblin minion pool used by the large-goblin boss variant.
// Stopgap: archer and slinger removed from the pool because the ranged NPC AI is unreliable.
GLOBAL_LIST_INIT(quest_outlaw_goblin_goons, list(
	/mob/living/carbon/human/species/goblin/npc,
	/mob/living/carbon/human/species/goblin/npc,
	/mob/living/carbon/human/species/goblin/npc,
	/mob/living/carbon/human/species/goblin/npc/bomber,
))

/datum/quest/kill/outlaw
	quest_type = QUEST_OUTLAW
	// Stopgap: outlaw_ranger removed because it uses the unreliable archer AI controller.
	mob_types_to_spawn = list(
		/mob/living/carbon/human/species/human/northern/deranged_knight/hedgeknight,
		/mob/living/carbon/human/species/human/northern/outlaw_duelist,
		/mob/living/carbon/human/species/human/northern/outlaw_tank,
	)
	count_min = 1
	count_max = 1
	/// Typepath spawned by spawn_goons() as accompanying minions (human-outlaw default).
	var/goon_type = /mob/living/carbon/human/species/human/northern/highwayman/dk_goon
	/// Range of goons to spawn alongside the target.
	var/goon_count_min = 2
	var/goon_count_max = 5
	/// Flipped during generate() when the large-goblin boss roll lands — swaps goon pool to goblins.
	var/goblin_warlord_variant = FALSE

/datum/quest/kill/outlaw/get_title()
	if(title)
		return title
	return "Defeat [pick("the terrible", "the dreadful", "the monstrous", "the infamous", "the feared")] [pick("warlord", "outlaw", "renegade", "marauder", "brigand")]"

/datum/quest/kill/outlaw/get_objective_text()
	return "Slay [initial(target_mob_type.name)]."

/datum/quest/kill/outlaw/generate(obj/effect/landmark/quest_spawner/landmark)
	..()
	if(!landmark)
		return FALSE
	// Roll the goblin-warlord variant before spawning — swaps target pool and beefs up the goon count.
	if(prob(20))
		goblin_warlord_variant = TRUE
		mob_types_to_spawn = list(/mob/living/carbon/human/species/goblin/npc/large)
		goon_count_min = 5
		goon_count_max = 9
	spawn_kill_mobs(landmark)
	spawn_goons(landmark)
	return TRUE

/// Spawns proximity-gated goons near the quest landmark to accompany the outlaw target.
/datum/quest/kill/outlaw/proc/spawn_goons(obj/effect/landmark/quest_spawner/landmark)
	for(var/i in 1 to rand(goon_count_min, goon_count_max))
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
		var/goon_path = goblin_warlord_variant ? pick(GLOB.quest_outlaw_goblin_goons) : goon_type
		var/mob/living/goon = new goon_path(spawn_effect)
		goon.faction |= "quest"
		// Suppress AI scanning while dormant inside the spawn_effect — see __quest_kill_base.dm
		ADD_TRAIT(goon, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(goon, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
		spawn_effect.contained_atom = goon
		spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
		register_spawner(spawn_effect)
