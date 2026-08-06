/datum/advclass/wretch/licker
	name = "Licker"
	tutorial = "You have recently been embraced as a vampire. You do not know whom your sire is, strange urges, unnatural strength, a thirst you can barely control. You were outed as a monster and are now on the run."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/wretch/licker
	class_select_category = CLASS_CAT_ACCURSED
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_SILVER_WEAK,
	)
	maximum_possible_slots = 2
	applies_post_equipment = FALSE

/datum/outfit/job/roguetown/wretch/licker/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.adjust_blindness(-3)
		var/list/possible_classes = list()
		for(var/datum/advclass/CHECKS in SSrole_class_handler.sorted_class_categories[CTAG_LICKER_WRETCH])
			possible_classes += CHECKS

		var/datum/advclass/C = input(H.client, "What is my class?", "Adventure") as null|anything in possible_classes
		C.equipme(H)

		H.adjust_skillrank_up_to(/datum/skill/magic/blood, 4, TRUE)
		var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(generation = GENERATION_NEONATE)
		H.mind.add_antag_datum(new_antag)
		H.apply_status_effect(STATUS_EFFECT_VAMPIRE_SPAWN_PROTECTION)
		REMOVE_TRAIT(H, TRAIT_OUTLAW, JOB_TRAIT)
		if(HAS_TRAIT(H, TRAIT_CRITICAL_RESISTANCE))
			REMOVE_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, null)
		if(HAS_TRAIT(H, TRAIT_RAGE))
			REMOVE_TRAIT(H, TRAIT_RAGE, null)
		to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as a Wretch, you are expected to actively create conflict with other players. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards.")) //giving this notice, since its part of the bounty system
		//leaving the below in if people want to give lickers outlaw/bounty status again, this will keep it off the trader roles but combat roles will have to choose a bounty
		/*var/list/traderjobs = list("Aristocrat",
									"Scholar",
								   "Peddler",
								   "Jeweler",
								   "Harlequin",
								   "Doomsayer",
								   "Cuisiner",
								   "Brewer")
		if(H.advjob in traderjobs)
			REMOVE_TRAIT(H, TRAIT_OUTLAW, JOB_TRAIT) //removing since these are non-combat roles and they need to be able to use the stocks and miesters to blend in
			to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as a Wretch, you are expected to actively create conflict with other players. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards.")) //giving this notice, since its part of the bounty system
		else
			wretch_select_bounty(H)*/

		if(HAS_TRAIT(H, TRAIT_DNR))
			ADD_TRAIT(H, TRAIT_DUSTABLE, TRAIT_GENERIC)//give DNR vampires the option to turn to dust

/datum/reagent/vampsolution
	metabolization_rate = 0.5
	var/stun_timer

/datum/reagent/vampsolution/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(30)

	if(prob(5))
		if(M.gender == FEMALE)
			M.emote(pick("twitch_s", "giggle"))
		else
			M.emote(pick("twitch_s", "chuckle"))

	M.apply_status_effect(/datum/status_effect/debuff/vampbite)

	// NPCs, low-WIL characters, or those with certain unsated addictions can be overwhelmed by the bite and stunned briefly.
	if((!M.mind || M.STAWIL < 10 || M.has_status_effect(/datum/status_effect/debuff/addiction/nympho) || M.has_status_effect(/datum/status_effect/debuff/addiction/junkie) || M.has_status_effect(/datum/status_effect/debuff/addiction/masochist)) && world.time >= stun_timer)
		if(HAS_TRAIT(M, TRAIT_PSYDONIAN_GRIT) && prob(50)) // endvre as a final bulletproof vest against being stunned
			to_chat(M, span_purple(pick("NO! I ENDURE!", "PSYDON, grant me strength. I will not yield!", "My flesh may falter. My faith will not.", "I have suffered worse than this. I WILL ENDURE.", "Your temptations mean nothing. PSYDON endures within ME!", "Pain is fleeting. Psydon is eternal.", "I shall not break. I shall not yield. I ENDURE.", "The sensation washes over me, but my resolve remains UNBROKEN.", "Psydon did not carry me this far for me to surrender now.", "I bite down on the good feeling and endure. FOR PSYDON!", "My mynd is mine. My will is mine. I YIELD TO NONE!", "Let the weakness pass. Let the flesh scream. I ENDURE.")))
		else
			to_chat(M, span_green(pick("I... I can't think straight anymore...", "Gods... my resolve is slipping...", "No... no, I'm losing my grip...", "I can't... I can't fight this feeling...", "That's enough... I give in...", "My will... it's just gone...", "Why can't I resist this...?", "I... I'm folding...", "Stop... please... I can't keep myself together...", "That bite... it broke something in me...", "I can't make myself pull away...", "Everything in my head is going soft...", "I know I should resist... so why can't I?", "My thoughts are falling apart...", "I... I surrender. I can't help it...", "Whatever strength I had left... it's gone...", "I can't hold myself together anymore...", "My resolve is completely gone...", "I was going to fight... I really was...", "I can't even remember why I was resisting...", "Gods, my knees are weak... my head is spinning...", "I'm trying to resist... I'm really trying...", "I've lost the will to fight this...", "That's it... you've broken my resolve...", "I... I don't think I can say no anymore...", "My mind is screaming at me to resist, but I can't...", "I've completely lost my nerve...", "I can't keep pretending I'm in control...", "My thoughts are just... slipping away...", "I should be fighting this... but I can't...", "All that bravado, and now look at me...", "I thought I was stronger-willed than this...", "My resolve lasted all of a heartbeat...", "I've completely folded...", "There's nothing left in me to resist with...", "I... yield. Gods help me, I yield...")))
		M.Stun(3 SECONDS)
		M.Immobilize(3 SECONDS)
		M.apply_status_effect(/datum/status_effect/debuff/exposed)
		stun_timer = world.time + 6 SECONDS

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
