/datum/advclass/vagabond_thrall
	name = "Abandoned Thrall"
	tutorial = "An unfortunate victim of a vampire attack, you were fortunate enough to rise again... but when you did there was no shadowey cabal to welcome you to their fold, only smoldering piles of ash and the inquisition's banners. You slipped away without joining them immediately, but your normal life is over."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/vagabond/thrall
	category_tags = list(CTAG_VAGABOND)
	traits_applied = list(TRAIT_SILVER_WEAK)
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_SPD = 2,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN
	)
	extra_context = "This class starts with a weakened form of vampirism. They may not use disciplines or disguise themselves, picking this is akin to picking a feral animal to be hunted."

/datum/outfit/job/roguetown/vagabond/thrall/pre_equip(mob/living/carbon/human/H)
	..()

	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant

		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l

		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(33))
		cloak = /obj/item/clothing/cloak/half/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
	
	if(H.mind)
		H.job = "Abandoned Thrall" //Used for my shitcode job checks to remove certain vampire abilties
		H.change_stat(STATKEY_WIL, rand(-2, 2))
		var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(generation = GENERATION_THINNERBLOOD)
		H.mind.add_antag_datum(new_antag)
		H.apply_status_effect(STATUS_EFFECT_VAMPIRE_SPAWN_PROTECTION)
		H.maxbloodpool = 1000
		H.set_bloodpool (500)

//Allegedly all this stuff below is needed for vampire bites to function? Might be removeable.
/datum/reagent/vampsolution
	metabolization_rate = 0.5

/datum/reagent/vampsolution/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(30)
	if(prob(5))
		if(M.gender == FEMALE)
			M.emote(pick("twitch_s","giggle"))
		else
			M.emote(pick("twitch_s","chuckle"))
	M.apply_status_effect(/datum/status_effect/debuff/vampbite)
	..()

/atom/movable/screen/fullscreen/vampsolution
	icon_state = "spa"
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	blend_mode = 0
	show_when_dead = FALSE

/datum/reagent/vampsolution/on_mob_metabolize(mob/living/M, mob/living/S)
	M.overlay_fullscreen("druqk", /atom/movable/screen/fullscreen/druqks)
	if(M.client)
		ADD_TRAIT(M, TRAIT_DRUQK, "based")
		SSdroning.area_entered(get_area(M), M.client)

/datum/reagent/vampsolution/on_mob_end_metabolize(mob/living/M, mob/living/S)
	M.clear_fullscreen("druqk")
	M.remove_status_effect(/datum/status_effect/buff/druqks)
	M.set_drugginess(0)
	if(M.client)
		REMOVE_TRAIT(M, TRAIT_DRUQK, "based")
		SSdroning.play_area_sound(get_area(M), M.client)
