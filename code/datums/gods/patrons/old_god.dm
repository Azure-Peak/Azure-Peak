/datum/patron/old_god
	name = "Psydon"
	domain = "Otava, Naledi, Rockhill, and most of Psydonia's outermost fiefs."
	desc = "  </br>''God. The manifestation of maximal good, and the father of all.'' </br>''He, who created reality for His children to frollick within.'' </br>''He, who breathed lyfe into the Pantheon to shepherd His virtues.'' </br>''He, who sacrificed His strength to strike down the Archdevil with the Comet Syon.'' </br>''He, who yet slumbers to this dae; and who may yet still return.''"
	worshippers = "Commonfolk, Zealots, Heroes, and the Esoteric."
	associated_faith = /datum/faith/old_god
	mob_traits = list(TRAIT_PSYDONIAN_GRIT) //Assigned to all mobs with Psydon as the chosen patron. Gives a Willpower-scaling chance to resist succumbing to pain.
	miracles = list(/obj/effect/proc_holder/spell/targeted/touch/orison			= CLERIC_ORI,
					/obj/effect/proc_holder/spell/self/check_boot				= CLERIC_T0, //Personal spell - summons a completely random item upon use. Your mileage might vary.
					/obj/effect/proc_holder/spell/invoked/psydonendure			= CLERIC_T1, //External spell - seals bleeding wounds and helps to save people who've been critically injured.
					/obj/effect/proc_holder/spell/self/psydonprayer				= CLERIC_T1, //Internal spell - minor self-regeneration, repeatedly casted while still.
					/obj/effect/proc_holder/spell/self/psydonrespite			= CLERIC_T2, //Ditto, but stronger. The original variant, intended for dedicated - non-Adventuring - combat classes.
					/obj/effect/proc_holder/spell/self/psydonpersist			= CLERIC_T3, //Ditto-ditto. Intended for non-combative devotee classes, such as the Missionary and Absolver.
	)
	traits_tier = list(TRAIT_PSYDONITE = CLERIC_T0) //Requires a minimal holy skill or the 'Devotee' virtue to unlock. Offers passive wound regeneration, but prevents healing from most miracles.
	confess_lines = list(
		"THERE IS ONLY ONE TRUE GOD!",
		"PSYDON YET LYVES! PSYDON YET ENDURES!",
		"REBUKE THE HEATHEN, SUNDER THE MONSTER!",
		"MY GOD - WITH EVERY BROKEN BONE, I SWORE I LYVED!",
		"EVEN NOW, THERE IS STILL HOPE FOR MAN! AVE PSYDONIA!",
		"WITNESS ME, PSYDON; THE SACRIFICE MADE MANIFEST!",
	)


/////////////////////////////////
// Does God Hear Your Prayer ? //
/////////////////////////////////
// no he's dead - ok maybe he does

/datum/patron/old_god/can_pray(mob/living/follower)
	. = ..()
	. = TRUE
	// Allows prayer near psycross.
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == FALSE)
			to_chat(follower, span_danger("That defiled cross interupts my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer if raining and outside. Psydon weeps.
	if(GLOB.forecast == "rain")
		if(istype(get_area(follower), /area/rogue/outdoors))
			return TRUE
	// Allows prayer if bleeding.
	if(follower.bleed_rate > 0)
		return TRUE
	// Allows prayer if holding silver psycross.
	if(istype(follower.get_active_held_item(), /obj/item/clothing/neck/roguetown/psicross/silver))
		return TRUE
	to_chat(follower, span_danger("..yet, I feel incomplete. To complete my prayer, I must stand before a structured cross, be grasping a silvered psycross, be bleeding from a wound, or be standing in the rain. Just as He weeps, so must I."))
	return FALSE
