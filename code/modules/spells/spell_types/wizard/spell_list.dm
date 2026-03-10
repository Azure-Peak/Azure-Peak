// Global list for all learnable spells.
// Maybe one day we'll have different schools of spells etc. and a system tied to them but this is fine for now.

GLOBAL_LIST_INIT(learnable_spells, (list(/obj/effect/proc_holder/spell/invoked/projectile/fireball,
		/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt,
		/obj/effect/proc_holder/spell/invoked/projectile/fetch,
		/obj/effect/proc_holder/spell/invoked/projectile/spitfire,
		/obj/effect/proc_holder/spell/invoked/forcewall,
		/obj/effect/proc_holder/spell/invoked/ensnare,
		/obj/effect/proc_holder/spell/self/message,
		/obj/effect/proc_holder/spell/invoked/repulse,
		/obj/effect/proc_holder/spell/invoked/blade_burst,
		/obj/effect/proc_holder/spell/targeted/touch/nondetection,
//  	/obj/effect/proc_holder/spell/invoked/knock,
		/obj/effect/proc_holder/spell/invoked/haste,
		/obj/effect/proc_holder/spell/invoked/featherfall,
		/obj/effect/proc_holder/spell/invoked/darkvision,
		/obj/effect/proc_holder/spell/invoked/longstrider,
		/obj/effect/proc_holder/spell/invoked/invisibility,
		/obj/effect/proc_holder/spell/invoked/projectile/acidsplash,
		/obj/effect/proc_holder/spell/invoked/projectile/fireball/greater,
//		/obj/effect/proc_holder/spell/invoked/frostbite,
		/obj/effect/proc_holder/spell/invoked/guidance,
		/obj/effect/proc_holder/spell/invoked/fortitude,
		/obj/effect/proc_holder/spell/invoked/snap_freeze,
		/obj/effect/proc_holder/spell/invoked/projectile/frostbolt,
		/obj/effect/proc_holder/spell/invoked/projectile/arcynebolt,
		/obj/effect/proc_holder/spell/invoked/projectile/arcynestrike,
		/obj/effect/proc_holder/spell/invoked/gravity,
		/obj/effect/proc_holder/spell/invoked/projectile/repel,

		/obj/effect/proc_holder/spell/targeted/touch/lesserknock,
		/obj/effect/proc_holder/spell/invoked/counterspell,
		/obj/effect/proc_holder/spell/invoked/enlarge,
		/obj/effect/proc_holder/spell/invoked/leap,
		/obj/effect/proc_holder/spell/invoked/blink,
		/obj/effect/proc_holder/spell/invoked/mirror_transform,
		/obj/effect/proc_holder/spell/invoked/mindlink,
		/obj/effect/proc_holder/spell/invoked/stoneskin,
		/obj/effect/proc_holder/spell/invoked/hawks_eyes,
		/obj/effect/proc_holder/spell/invoked/giants_strength,
		/obj/effect/proc_holder/spell/invoked/create_campfire,
		/obj/effect/proc_holder/spell/invoked/mending,
		/obj/effect/proc_holder/spell/self/light,
		/obj/effect/proc_holder/spell/invoked/conjure_weapon,
		/obj/effect/proc_holder/spell/self/conjure_armor,
		/obj/effect/proc_holder/spell/self/conjure_armor/dragonhide,
		/obj/effect/proc_holder/spell/self/conjure_armor/crystalhide,
		/obj/effect/proc_holder/spell/self/magicians_brick,
		/obj/effect/proc_holder/spell/invoked/fire_cascade,
		/obj/effect/proc_holder/spell/invoked/firewalker,
		/obj/effect/proc_holder/spell/invoked/thunderstrike,
		/obj/effect/proc_holder/spell/invoked/sundering_lightning,
		/obj/effect/proc_holder/spell/invoked/meteor_storm,
		/obj/effect/proc_holder/spell/invoked/enchant_weapon,
		/obj/effect/proc_holder/spell/invoked/forcewall/arcyne_prison,
		/obj/effect/proc_holder/spell/invoked/forcewall/greater,
		/obj/effect/proc_holder/spell/invoked/wither,
		/obj/effect/proc_holder/spell/invoked/rebuke,
		/obj/effect/proc_holder/spell/invoked/projectile/fireball/artillery,
		/obj/effect/proc_holder/spell/invoked/conjure_primordial,
		/obj/effect/proc_holder/spell/invoked/raise_deadite,
		/obj/effect/proc_holder/spell/invoked/bonechill,
		/obj/effect/proc_holder/spell/invoked/silence,
		/obj/effect/proc_holder/spell/self/findfamiliar,
		/obj/effect/proc_holder/spell/invoked/projectile/stygian
		)
))

/* Utility spells - non-combat support magic or very niche in combat spells meant to be freely available
to all mage classes.
*/
GLOBAL_LIST_INIT(utility_spells, (list(
		/obj/effect/proc_holder/spell/self/light,
		/obj/effect/proc_holder/spell/invoked/mending,
		/obj/effect/proc_holder/spell/self/message,
		/obj/effect/proc_holder/spell/invoked/mindlink,
		/obj/effect/proc_holder/spell/self/findfamiliar,
		/obj/effect/proc_holder/spell/invoked/create_campfire,
		/obj/effect/proc_holder/spell/invoked/projectile/lesser_fetch,
		/obj/effect/proc_holder/spell/invoked/projectile/lesser_repel,
		/obj/effect/proc_holder/spell/targeted/touch/lesserknock,
		/obj/effect/proc_holder/spell/targeted/touch/nondetection,
		/obj/effect/proc_holder/spell/invoked/darkvision, // Buff but it is fine to also put it in this list
		/obj/effect/proc_holder/spell/self/magicians_brick,
		/obj/effect/proc_holder/spell/invoked/mirror_transform 
		)
))

// Augmentation spells - self-buffs safe for certain types of shared pool
// No invisibility (too strong).
GLOBAL_LIST_INIT(augmentation_spells, (list(
		/obj/effect/proc_holder/spell/invoked/haste,
		/obj/effect/proc_holder/spell/invoked/darkvision,
		/obj/effect/proc_holder/spell/invoked/longstrider,
		/obj/effect/proc_holder/spell/invoked/stoneskin,
		/obj/effect/proc_holder/spell/invoked/hawks_eyes,
		/obj/effect/proc_holder/spell/invoked/giants_strength,
		/obj/effect/proc_holder/spell/invoked/fortitude,
		/obj/effect/proc_holder/spell/invoked/guidance,
		/obj/effect/proc_holder/spell/invoked/featherfall,
		)
))

// Summoning spells - creature summoning magic
GLOBAL_LIST_INIT(summoning_spells, (list(
		/obj/effect/proc_holder/spell/invoked/conjure_primordial,
		// /obj/effect/proc_holder/spell/invoked/raise_deadite, // Zizo-only, consider separate evil list
		)
))

/proc/get_spell_pool_list(pool_name)
	switch(pool_name)
		if("utility")
			return GLOB.utility_spells
		if("augmentation")
			return GLOB.augmentation_spells
		if("summoning")
			return GLOB.summoning_spells
	return list()
