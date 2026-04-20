// Kinda glorified status effects. But they may apply a status effect or something else entirely.
// Since hags can mess with these from a distance, and they're tied to a specific hag,
// we don't want to store these on the mob like status effects.

/datum/hag_boon
	var/name = "Generic Boon"
	var/desc = "A boon description"
	var/time_granted = 0
	var/true_name = ""
	var/datum/component/hag_curio_tracker/tracker
	/// How powerful a boon is. Not used for all types of boons.
	var/points = 1
	/// Whether or not this boon can be transmuted into a curse. 
	/// Curses should never be able to transmuted.
	/// Some boons can only be triggered into specific curses, rather than free form.
	var/transmutable = TRUE
	var/hag_curse = FALSE
	var/hag_is_valid = TRUE
	var/hag_trait = FALSE

/datum/hag_boon/curse_scar
	name = "Curse Scar"
	desc = "A lingering mark of a previous pact. It represents the toll taken on the soul, claimed by the Mossmother. Whilst this pleases the Mossmother, keep in mind that those cursed may seek to expose your hut and kill you."
	points = 0
	transmutable = FALSE
	hag_curse = FALSE

/datum/hag_boon/New(t_name, datum/component/hag_curio_tracker/T, set_points)
	src.time_granted = world.time
	src.true_name = t_name
	src.tracker = T
	src.points = set_points
	var/mob/living/L = find_target()
	if(L)
		apply_boon_effect(L)

/datum/hag_boon/Destroy()
	var/mob/living/L = find_target()
	if(L)
		remove_boon_effect(L)
	return ..()

/datum/hag_boon/proc/find_target()
	for(var/mob/living/L in GLOB.player_list)
		if(L.real_name == true_name)
			return L
	// Fallback in case someone ghosts or druid shenaniganery!
	for(var/mob/living/L in GLOB.mob_living_list)
		if(L.real_name == true_name)
			return L
	return null

/datum/hag_boon/proc/apply_boon_effect(mob/living/L)
	// Apply status effects, mutations, etc.
	return

/datum/hag_boon/proc/remove_boon_effect(mob/living/L)
	// Strip those same effects
	return

/// HAG BOON DATUMS ///

/datum/hag_boon/item_debt
	name = "Material Pact"
	hag_is_valid = FALSE

/datum/hag_boon/item_debt/proc/add_points(amt)
	points += amt

/obj/item/recipe_book/hag_grimoire
	name = "The Mother's Ledger"
	wiki_name = "Hag's Boons"
	icon_state = "book7_0"
	base_icon_state = "book7"
	can_spawn = FALSE
	types = list(
		/datum/hag_boon/curse_scar,
		/datum/hag_boon/trait/ritualist,
		/datum/hag_boon/trait/webwalk,
		/datum/hag_boon/trait/nightowl,
		/datum/hag_boon/trait/beautiful,
		/datum/hag_boon/trait/beautiful_uncanny,
		/datum/hag_boon/trait/leaper,
		/datum/hag_boon/trait/ignoreslowdown,
		/datum/hag_boon/trait/battleready,
		/datum/hag_boon/trait/armor_medium,
		/datum/hag_boon/trait/armor_heavy,
		/datum/hag_boon/trait/dodge_expert,
		/datum/hag_boon/trait/bleed_resistance,
		/datum/hag_boon/trait/grab_immunity,
		/datum/hag_boon/trait/crackhead,
		/datum/hag_boon/trait/civil_barbarian,
		/datum/hag_boon/trait/water_breathing,
		/datum/hag_boon/trait/sharper_blades,
		/datum/hag_boon/trait/guidance,
		/datum/hag_boon/trait/good_trainer,
		/datum/hag_boon/trait/counter_counterspell,
		/datum/hag_boon/trait/keen_ears,
		/datum/hag_boon/trait/hard_dismember,
		/datum/hag_boon/trait/no_pain,
		/datum/hag_boon/trait/dark_vision,
		/datum/hag_boon/trait/azure_native,
		/datum/hag_boon/trait/matthios_eyes,
		/datum/hag_boon/trait/wood_walker,
		/datum/hag_boon/trait/unbound_strength,
		/datum/hag_boon/trait/jack_of_all_trades,
		/datum/hag_boon/trait/expert_medicine,
		/datum/hag_boon/trait/expert_alchemy,
		/datum/hag_boon/trait/expert_smithing,
		/datum/hag_boon/trait/expert_sewing,
		/datum/hag_boon/trait/expert_survival,
		/datum/hag_boon/trait/expert_homestead,
		/datum/hag_boon/trait/self_sustenance,
		/datum/hag_boon/trait/combat_aware,
		/datum/hag_boon/trait/wyrd_labourer,
		/datum/hag_boon/trait/curse/critical_weakness,
		/datum/hag_boon/trait/curse/no_spells,
		/datum/hag_boon/trait/curse/no_run,
		/datum/hag_boon/trait/curse/ugly,
		/datum/hag_boon/trait/curse/mute,
		/datum/hag_boon/trait/curse/no_defense,
		/datum/hag_boon/trait/curse/silver_weakness,
		/datum/hag_boon/buff/curse/choking_moss,
		/datum/hag_boon/buff/curse/waterlogged,
		/datum/hag_boon/buff/curse/slumber,
		/datum/hag_boon/spell/spider_speak,
		/datum/hag_boon/spell/twist_food,
		/datum/hag_boon/spell/find_riches,
		/datum/hag_boon/spell/banish,
		/datum/hag_boon/buff/storm_rebirth,
		/datum/hag_boon/buff/natural_communion,
		/datum/hag_boon/buff/creeping_moss,
		/datum/hag_boon/curse/rotting_touch,
		/datum/hag_boon/curse/storm_weakness,
		/datum/hag_boon/item/hag_sword,
		/datum/hag_boon/item/hag_axe,
		/datum/hag_boon/item/hag_spear,
		/datum/hag_boon/item/wyrd_cross
	)

/obj/item/recipe_book/hag_grimoire/attack_self(mob/user)
	if(!GLOB.active_hags.Find(user))
		to_chat(user, span_warning("The runes give you a migraine. You can't make sense of this."))
		return
	..()

/obj/item/recipe_book/hag_grimoire/moss_recipes
	name = "The Mother's Botanical Ledger"
	desc = "A heavy, damp volume bound in shifting lichen. Its pages are stained with the colorful juices of crushed moss and the grit of raw ores."
	wiki_name = "Hag Alchemical Recipes"
	icon_state = "book8_0"
	base_icon_state = "book8"
	can_spawn = FALSE
	types = list(
		// --- Core Catalysts ---
		/datum/crafting_recipe/roguetown/alchemy/hag/varnish,
		/datum/crafting_recipe/roguetown/alchemy/hag/synth_shiny,
		/datum/crafting_recipe/roguetown/alchemy/hag/synth_base,

		// --- Low Rarity Mosses ---
		/datum/crafting_recipe/roguetown/alchemy/hag/faded_moss,
		/datum/crafting_recipe/roguetown/alchemy/hag/crawling_moss,
		/datum/crafting_recipe/roguetown/alchemy/hag/stormy_moss,
		/datum/crafting_recipe/roguetown/alchemy/hag/corrosive_moss,

		// --- Mid Rarity Mosses ---
		/datum/crafting_recipe/roguetown/alchemy/hag/lustrous_moss,
		/datum/crafting_recipe/roguetown/alchemy/hag/caring_moss,
		/datum/crafting_recipe/roguetown/alchemy/hag/rooted_moss,
		/datum/crafting_recipe/roguetown/alchemy/hag/creeping_moss,

		// --- High Rarity Mosses ---
		/datum/crafting_recipe/roguetown/alchemy/hag/prismatic_moss,
		/datum/crafting_recipe/roguetown/alchemy/hag/gilded_moss,
		/datum/crafting_recipe/roguetown/alchemy/hag/drowned_moss,

		// --- Items ---
		/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_cross,
		/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_axe,
		/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_sword,
		/datum/crafting_recipe/roguetown/alchemy/hag/wyrd_spear,
	)
