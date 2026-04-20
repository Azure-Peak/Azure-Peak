/proc/getfishingloot(var/mob/living/carbon/human/fisherman, var/list/modlist, turf/target, var/skill_power = 1)
	var/frwt = list(/turf/open/water/river, /turf/open/water/cleanshallow, /turf/open/water/pond)
	var/salwt_coast = list(/turf/open/water/ocean)
	var/salwt_deep = list(/turf/open/water/ocean/deep)
	var/mud = list(/turf/open/water/swamp, /turf/open/water/swamp/deep)
	if(ishuman(fisherman))
		if(fisherman.patron.type == /datum/patron/divine/abyssor)
			modlist["dangerFishingMod"] *= 1.10  // +10% danger
			modlist["treasureFishingMod"] *= 0.90  // -10% treasure
			modlist["rareFishingMod"] *= 1.25  // +25% rare
		if(fisherman.STALUC > 10)
			var/trait_bonus = 0
			if(HAS_TRAIT(fisherman, TRAIT_CAUTIOUS_FISHER))
				trait_bonus = 0.20
			var/tier1_bonus = min(fisherman.STALUC - 10, 5) // 5% bonus per point up until 15
			var/tier2_bonus = max(fisherman.STALUC - 15, 0) // 1% bonus per point past 15
			var/total_bonus = ((tier1_bonus * 0.05) + (tier2_bonus * 0.01) + (trait_bonus)) * skill_power
			modlist["rareFishingMod"] *= (1 + total_bonus)
			modlist["treasureFishingMod"] *= (1 + total_bonus)
			modlist["dangerFishingMod"] *= (1 - (trait_bonus * 3))
	var/fishingloot
	if(target.type in frwt)
		fishingloot = pickweightAllowZero(createFreshWaterFishWeightListModlist(modlist))
	else if(target.type in salwt_coast)
		fishingloot = pickweightAllowZero(createCoastalSeaFishWeightListModlist(modlist))
	else if(target.type in salwt_deep)
		fishingloot = pickweightAllowZero(createDeepSeaFishWeightListModlist(modlist))
	else if(target.type in mud)
		fishingloot = pickweightAllowZero(createMudFishWeightListModlist(modlist))
	return fishingloot

/proc/upgradecagemodlist(var/mob/living/carbon/human/fisherman, var/list/modlist, var/skill_power = 1)
	if(ishuman(fisherman))
		if(fisherman.patron.type == /datum/patron/divine/abyssor)
			modlist["dangerFishingMod"] *= 1.10  // +10% danger
			modlist["treasureFishingMod"] *= 0.90  // -10% treasure
			modlist["rareFishingMod"] *= 1.25  // +25% rare
		if(fisherman.STALUC > 10)
			var/trait_bonus = 0
			if(HAS_TRAIT(fisherman, TRAIT_CAUTIOUS_FISHER))
				trait_bonus = 0.20
			var/tier1_bonus = min(fisherman.STALUC - 10, 5) // 5% bonus per point up until 15
			var/tier2_bonus = max(fisherman.STALUC - 15, 0) // 1% bonus per point past 15
			var/total_bonus = ((tier1_bonus * 0.05) + (tier2_bonus * 0.01) + (trait_bonus)) * skill_power
			modlist["rareFishingMod"] *= (1 + total_bonus)
			modlist["treasureFishingMod"] *= (1 + total_bonus)
			modlist["dangerFishingMod"] *= (1 - (trait_bonus * 3))
	return modlist

/proc/getbaitlife(var/fishing_skill, var/obj/item/bait, var/basechance = 80)
	if(bait.baitresilience > 0)
		if(fishing_skill >= SKILL_LEVEL_MASTER)
			bait.baitresilience = max(0, bait.baitresilience - 1)
		else
			bait.baitresilience = max(0, bait.baitresilience - 2)
		return FALSE
	if(prob(basechance - (fishing_skill * 10)))
		return TRUE
	return FALSE
