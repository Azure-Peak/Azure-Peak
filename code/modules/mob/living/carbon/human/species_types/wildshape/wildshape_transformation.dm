#define TRAIT_SOURCE_WILDSHAPE "wildshape_transform"

/mob/living/carbon/human/species/wildshape/death(gibbed, nocutscene = FALSE)
	wildshape_untransform(TRUE, gibbed)

/mob/living/carbon/human/proc/wildshape_transformation(shapepath)
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN TRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	//before we shed our items, save our neck and ring, if we have any, so we can quickly rewear them
	var/obj/item/stored_neck = wear_neck
	var/obj/item/stored_ring = wear_ring
	for(var/obj/item/I in src)
		if (I != underwear && I != cloak && I != legwear_socks) // keep underwear (+ socks) and our cloak, even if said cloak remains inaccessible.
			dropItemToGround(I)
	regenerate_icons()
	icon = null
	var/oldinv = invisibility
	invisibility = INVISIBILITY_MAXIMUM
	cmode = FALSE
	if(client)
		SSdroning.play_area_sound(get_area(src), client)

	var/mob/living/carbon/human/species/wildshape/W = new shapepath(loc) //We crate a new mob for the wildshaping player to inhabit

	W.set_patron(src.patron)
	W.gender = gender
	W.regenerate_icons()
	W.stored_mob = src
	W.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
	playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
	if (W.dna.species?.gibs_on_shapeshift)
		playsound(W.loc, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 200, FALSE, 3)
		W.spawn_gibs(FALSE)
	playsound(W.loc, 'sound/body/shapeshift-start.ogg', 100, FALSE, 3)
	src.forceMove(W)
	// re-equip our stored neck and ring items, if we have them
	if (stored_ring)
		W.equip_to_slot_if_possible(stored_ring, SLOT_RING) // have to do this because we can wear psycrosses as rings even though we shouldn't be able to

	if (stored_neck)
		W.equip_to_slot_if_possible(stored_neck, SLOT_NECK)
	W.after_creation()
	W.stored_language = new
	W.stored_language.copy_known_languages_from(src)
	W.stored_skills = ensure_skills().known_skills.Copy()
	W.stored_experience = ensure_skills().skill_experience.Copy()
	W.stored_spells = mind.spell_list.Copy()
	W.voice_color = voice_color
	W.cmode_music_override = cmode_music_override
	W.cmode_music_override_name = cmode_music_override_name

	for(var/datum/wound/old_wound in W.get_wounds())
		var/obj/item/bodypart/bp = W.get_bodypart(old_wound.bodypart_owner.body_zone)
		bp?.remove_wound(old_wound.type)

	var/list/datum/wound/woundlist = get_wounds()
	if(woundlist.len)
		for(var/datum/wound/wound in woundlist)
			var/obj/item/bodypart/c_BP = get_bodypart(wound.bodypart_owner.body_zone)
			var/obj/item/bodypart/w_BP = W.get_bodypart(wound.bodypart_owner.body_zone)
			w_BP.add_wound(wound.type)
			c_BP.remove_wound(wound.type)

	W.adjustBruteLoss(getBruteLoss())
	W.adjustFireLoss(getFireLoss())
	W.adjustOxyLoss(getOxyLoss())

	src.adjustBruteLoss(-src.getBruteLoss())
	src.adjustFireLoss(-src.getFireLoss())
	src.adjustOxyLoss(-src.getOxyLoss())
	W.blood_volume = blood_volume
	W.bleed_rate = bleed_rate
	W.bleedsuppress = bleedsuppress
	bleed_rate = 0
	bleedsuppress = TRUE
	W.set_nutrition(nutrition)
	W.set_hydration(hydration)

	mind.transfer_to(W)
	skills?.known_skills = list()
	skills?.skill_experience = list()
	W.grant_language(/datum/language/beast)
	W.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	W.update_a_intents()

	// temporal traits so our body won't die or snore
	ADD_TRAIT(src, TRAIT_NOSLEEP, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_SOURCE_WILDSHAPE)	
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_SOURCE_WILDSHAPE)
	ADD_TRAIT(src, TRAIT_PACIFISM, TRAIT_SOURCE_WILDSHAPE) // just an extra layer of protection in case something will go wrong
	src.status_flags |= GODMODE // so they won't die by any means
	invisibility = oldinv

	W.gain_inherent_skills()

/mob/living/carbon/human/proc/wildshape_untransform(dead,gibbed)
	if(!stored_mob)
		return
	if(!mind)
		log_runtime("NO MIND ON [src.name] WHEN UNTRANSFORMING")
	Paralyze(1, ignore_canstun = TRUE)
	// as before, save our worn stuff and prepare to move it back to the mob
	var/obj/item/stored_neck = wear_neck
	var/obj/item/stored_ring = wear_ring
	for(var/obj/item/W in src)
		dropItemToGround(W)
	icon = null
	invisibility = INVISIBILITY_MAXIMUM

	var/mob/living/carbon/human/W = stored_mob
	stored_mob = null

	REMOVE_TRAIT(W, TRAIT_NOSLEEP, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOBREATH, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOPAIN, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_TOXIMMUNE, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOHUNGER, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_NOMOOD, TRAIT_SOURCE_WILDSHAPE)
	REMOVE_TRAIT(W, TRAIT_PACIFISM, TRAIT_SOURCE_WILDSHAPE)
	W.status_flags &= ~GODMODE
	// re-equip our stored neck and ring items, if we have them
	if (stored_ring)
		W.equip_to_slot_if_possible(stored_ring, SLOT_RING) // have to do this because we can wear psycrosses as rings even though we shouldn't be able to

	if (stored_neck)
		W.equip_to_slot_if_possible(stored_neck, SLOT_NECK)
	if(dead)
		W.death()

	for(var/datum/wound/old_wound in W.get_wounds())
		var/obj/item/bodypart/bp = W.get_bodypart(old_wound.bodypart_owner.body_zone)
		bp?.remove_wound(old_wound.type)

	var/list/datum/wound/woundlist = get_wounds()
	if(woundlist.len)
		for(var/datum/wound/wound in woundlist)
			var/obj/item/bodypart/c_BP = get_bodypart(wound.bodypart_owner.body_zone)
			var/obj/item/bodypart/w_BP = W.get_bodypart(wound.bodypart_owner.body_zone)
			w_BP.add_wound(wound.type)
			c_BP.remove_wound(wound.type)

	W.adjustBruteLoss(getBruteLoss())
	W.adjustFireLoss(getFireLoss())
	W.adjustOxyLoss(getOxyLoss())

	src.adjustBruteLoss(-src.getBruteLoss())
	src.adjustFireLoss(-src.getFireLoss())
	src.adjustOxyLoss(-src.getOxyLoss())
	W.blood_volume = blood_volume
	W.bleed_rate = bleed_rate
	W.bleedsuppress = bleedsuppress
	W.set_nutrition(nutrition)
	W.set_hydration(hydration)

	W.forceMove(get_turf(src))
	mind.transfer_to(W)

	var/mob/living/carbon/human/species/wildshape/WA = src
	W.copy_known_languages_from(WA.stored_language)
	skills?.known_skills = WA.stored_skills.Copy()
	skills?.skill_experience = WA.stored_experience.Copy()
	playsound(W.loc, 'sound/body/shapeshift-end.ogg', 100, FALSE, 3)
	//Compares the list of spells we had before transformation with those we do now. If there are any that don't match, we remove them
	for(var/obj/effect/proc_holder/spell/self/originspell in WA.stored_spells)
		for(var/obj/effect/proc_holder/spell/self/wildspell in W.mind.spell_list)
			if(wildspell != originspell)
				W.RemoveSpell(wildspell)

	W.regenerate_icons()
	to_chat(W, span_userdanger("I return to my old form."))

	qdel(src)

#undef TRAIT_SOURCE_WILDSHAPE
