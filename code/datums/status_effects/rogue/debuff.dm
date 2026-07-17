/datum/status_effect/debuff
	status_type = STATUS_EFFECT_REFRESH

///////////////////////////

/datum/status_effect/debuff/hungryt1
	id = "hungryt1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hungryt1
	effectedstats = list(STATKEY_CON = -1)
	duration = -1
	needs_processing = FALSE
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/hungryt1
	name = "Hungry"
	desc = "My stomach growls and my body yearns for food."
	icon_state = "hunger1"

/datum/status_effect/debuff/hungryt2
	id = "hungryt2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hungryt2
	effectedstats = list(STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_WIL = -1)
	duration = -1
	needs_processing = FALSE
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/hungryt2
	name = "Hungry"
	desc = "Hunger gnaws at my strength. I should eat soon."
	icon_state = "hunger2"

/datum/status_effect/debuff/hungryt3
	id = "hungryt3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hungryt3
	effectedstats = list(STATKEY_STR = -5, STATKEY_CON = -3, STATKEY_WIL = -2)
	duration = -1
	needs_processing = FALSE
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/hungryt3
	name = "Hungry"
	desc = "My body is beginning to fail from starvation!"
	icon_state = "hunger3"



/datum/status_effect/debuff/thirstyt1
	id = "thirsty1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thirstyt1
	effectedstats = list(STATKEY_WIL = -1)
	duration = -1
	needs_processing = FALSE
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/thirstyt1
	name = "Thirsty"
	desc = "My mouth feels a little dry."
	icon_state = "thirst1"

/datum/status_effect/debuff/thirstyt2
	id = "thirsty2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thirstyt2
	effectedstats = list(STATKEY_SPD = -1, STATKEY_WIL = -2)
	duration = -1
	needs_processing = FALSE
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/thirstyt2
	name = "Thirsty"
	desc = "My throat is dry, and it's harder to focus."
	icon_state = "thirst2"

/datum/status_effect/debuff/thirstyt3
	id = "thirsty3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/thirstyt3
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -2, STATKEY_WIL = -3)
	duration = -1
	needs_processing = FALSE
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/thirstyt3
	name = "Thirsty"
	desc = "I urgently need to drink something! Anything!"
	icon_state = "thirst3"



/datum/status_effect/debuff/vthirstt1
	id = "vthirst1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/vthirstt1
	effectedstats = list(STATKEY_CON = -1)
	duration = -1
	needs_processing = FALSE
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/vthirstt1
	name = "Blood Starved"
	desc = "Food and drink brings no comfort. The thought of consuming blood lingers in my mind."
	icon_state = "vblood1"

/datum/status_effect/debuff/vthirstt2
	id = "vthirst2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/vthirstt2
	effectedstats = list(STATKEY_CON = -2, STATKEY_LCK = -2)
	duration = -1
	needs_processing = FALSE
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/vthirstt2
	name = "Blood Starved"
	desc = "My fangs ache and I am twitchy. Every heartbeat nearby draws my attention."
	icon_state = "vblood2"

/datum/status_effect/debuff/vthirstt3
	id = "vthirst3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/vthirstt3
	effectedstats = list(STATKEY_STR = 4, STATKEY_SPD = -2, STATKEY_CON = -4, STATKEY_LCK = -4)
	duration = -1
	needs_processing = FALSE
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/vthirstt3
	name = "Blood Starved"
	desc = "<font color='#ff0000'><b>I CAN'T TAKE IT ANYMORE!! BLOOD!! WHERE IS BLOOD?! I NEED BLOOD!! I WANT BLOOD!!</b></font>"
	icon_state = "vblood3"

/////////

/datum/status_effect/debuff/uncookedfood
	id = "uncookedfood"
	effectedstats = null
	duration = 1

/datum/status_effect/debuff/uncookedfood/on_apply()
	if(HAS_TRAIT(owner, TRAIT_NASTY_EATER) || HAS_TRAIT(owner, TRAIT_ORGAN_EATER) || HAS_TRAIT(owner, TRAIT_WILD_EATER))
		return ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_nausea(100)
	return ..()

/datum/status_effect/debuff/badmeal
	id = "badmeal"
	effectedstats = null
	duration = 1

/datum/status_effect/debuff/badmeal/on_apply()
	owner.add_stress(/datum/stressevent/badmeal)
	return ..()

/datum/status_effect/debuff/burnedfood
	id = "burnedfood"
	effectedstats = null
	duration = 1

/datum/status_effect/debuff/burnedfood/on_apply()
	if(HAS_TRAIT(owner, TRAIT_NASTY_EATER))
		return ..()
	owner.add_stress(/datum/stressevent/burntmeal)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_nausea(100)
	return ..()

/datum/status_effect/debuff/rotfood
	id = "rotfood"
	effectedstats = null
	duration = 1

/datum/status_effect/debuff/rotfood/on_apply()
	if(HAS_TRAIT(owner, TRAIT_NASTY_EATER) || HAS_TRAIT(owner, TRAIT_ROT_EATER))
		return ..()
	owner.add_stress(/datum/stressevent/rotfood)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_nausea(200)
	return ..()

/datum/status_effect/debuff/bleeding
	id = "bleedingt1"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bleedingt1
	effectedstats = list(STATKEY_SPD = -1)
	duration = -1
	needs_processing = FALSE

/datum/status_effect/debuff/bleeding/on_apply() //mistwalker shitcode, scaling buff as they bleed out
	if (!HAS_TRAIT(owner, TRAIT_JOURNEYS_END))
		return ..()
	owner.apply_status_effect(/datum/status_effect/buff/journey_ending)
	return ..()

/datum/status_effect/debuff/bleeding/on_remove()
	if (!HAS_TRAIT(owner, TRAIT_JOURNEYS_END))
		return ..()
	owner.remove_status_effect(/datum/status_effect/buff/journey_ending)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/bleedingt1
	name = "Dizzy"
	desc = "I've lost a bit of blood, and my humors feel imbalanced.."
	icon_state = "bleed1"

/datum/status_effect/debuff/bleedingworse
	id = "bleedingt2"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bleedingt2
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -2)
	duration = -1
	needs_processing = FALSE

/datum/status_effect/debuff/bleedingworse/on_apply()
	if (!HAS_TRAIT(owner, TRAIT_JOURNEYS_END))
		return ..()
	owner.apply_status_effect(/datum/status_effect/buff/journey_end)
	return ..()

/datum/status_effect/debuff/bleedingworse/on_remove()
	if (!HAS_TRAIT(owner, TRAIT_JOURNEYS_END))
		return ..()
	owner.remove_status_effect(/datum/status_effect/buff/journey_end)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/bleedingt2
	name = "Faint"
	desc = "I've lost some blood, and it's hard to keep myself steady.."
	icon_state = "bleed2"

/datum/status_effect/debuff/bleedingworst
	id = "bleedingt3"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bleedingt3
	effectedstats = list(STATKEY_STR = -3, STATKEY_SPD = -4)
	duration = -1
	needs_processing = FALSE

/datum/status_effect/debuff/bleedingworst/on_apply()
	if (!HAS_TRAIT(owner, TRAIT_JOURNEYS_END))
		return ..()
	owner.apply_status_effect(/datum/status_effect/buff/journey_end_final)
	return ..()

/datum/status_effect/debuff/bleedingworst/on_remove()
	if (!HAS_TRAIT(owner, TRAIT_JOURNEYS_END))
		return ..()
	owner.remove_status_effect(/datum/status_effect/buff/journey_end_final)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/bleedingt3
	name = "Drained"
	desc = "I've lost a lot of blood, and I can barely keep myself conscious.."
	icon_state = "bleed3"

/datum/status_effect/debuff/sleepytime
	id = "sleepytime"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/sleepytime
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/netted
	name = "Net"
	desc = "A net was thrown on me.. how can I move?"
	icon_state = "muscles"

/datum/status_effect/debuff/netted
	id = "net"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/netted
	effectedstats = list(STATKEY_SPD = -5, STATKEY_WIL = -2)

/datum/status_effect/debuff/netted/on_creation(mob/living/new_owner, newdur)
	if(newdur)
		duration = newdur
	. = ..()

/datum/status_effect/debuff/netted/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_NET_SLOWDOWN, multiplicative_slowdown = 3)

/datum/status_effect/debuff/netted/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.legcuffed = null
		C.update_inv_legcuffed()
		C.remove_movespeed_modifier(MOVESPEED_ID_NET_SLOWDOWN)

/datum/status_effect/debuff/netted/vile
	duration = 10 SECONDS

/datum/status_effect/debuff/netted/vile/on_remove()
	. = ..()
	if(iscarbon(owner))
		// grasp no longer legcuffs you, so lets not remove any cuffs on a person.
		var/mob/living/carbon/C = owner
		C.remove_movespeed_modifier(MOVESPEED_ID_NET_SLOWDOWN)
		owner.visible_message(span_danger("[owner] slips free of their binds!"), span_info("I slip free of my bindings!"))

/atom/movable/screen/alert/status_effect/debuff/sleepytime
	name = "Tired"
	desc = "I should get some rest."
	icon_state = "sleepy"

/datum/status_effect/debuff/muscle_sore
	id = "muscle_sore"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/muscle_sore
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -1)

/atom/movable/screen/alert/status_effect/debuff/muscle_sore
	name = "Muscle Soreness"
	desc = "My muscles need some sleep to recover."
	icon_state = "muscles"

/datum/status_effect/debuff/sunder_stacks
	id = "sundered"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/sunder_stacks
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -1, STATKEY_CON = -1, STATKEY_SPD = -1, STATKEY_LCK = -1)	//Slightly punishing.
	duration = 10 SECONDS	//Punishing and tied to the duration of your sundering stacks.

/atom/movable/screen/alert/status_effect/debuff/sunder_stacks
	name = "Sundered!"
	desc = "Something has been taken from me, and it will take time to recover."
	icon_state = "luxstrain"

/datum/status_effect/debuff/devitalised
	id = "devitalised"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/devitalised
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -1, STATKEY_CON = -1, STATKEY_SPD = -1, STATKEY_LCK = -1)	//Slightly punishing.
	duration = 15 MINUTES	//Punishing, same time as revival, but mildly less punishing than revival itself.

/datum/status_effect/debuff/devitalised/lesser
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -1, STATKEY_CON = -1, STATKEY_SPD = -1, STATKEY_LCK = -1)
	duration = 5 MINUTES

/datum/status_effect/debuff/devitalised/greater
	duration = 30 MINUTES

/atom/movable/screen/alert/status_effect/debuff/devitalised
	name = "Devitalised"
	desc = "Something vital has been taken from me; my heart beats in arrythmia, as it struggles to restore what has been lost."
	icon_state = "lux"

/datum/status_effect/debuff/vamp_dreams
	id = "sleepytime"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/vamp_dreams
	needs_processing = FALSE

/atom/movable/screen/alert/status_effect/debuff/vamp_dreams
	name = "Insight"
	desc = "With some sleep in a coffin I feel like I could become better."
	icon_state = "sleepy"

/datum/status_effect/debuff/ritualdefiled
	id = "ritualdefiled"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ritualdefiled
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -1, STATKEY_CON = -1, STATKEY_SPD = -1, STATKEY_LCK = -1)
	duration = 1 HOURS // Punishing AS FUCK, but not as punishing as being dead.

/atom/movable/screen/alert/status_effect/debuff/ritualdefiled
	name = "Defilementia"
	desc = "My very spirit aches, as my body struggles against the lux-cursing whims of a forbidden ritual!"
	icon_state = "rituos_cooldown_greater"

/// SURRENDERING DEBUFFS
/datum/status_effect/debuff/breedable
	id = "breedable"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/breedable
	duration = 30 SECONDS

/datum/status_effect/debuff/breedable/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, id)

/datum/status_effect/debuff/breedable/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE, id)

/atom/movable/screen/alert/status_effect/debuff/breedable
	name = "Obedient"
	desc = "They won't hurt me too much..."

/datum/status_effect/debuff/submissive
	id = "submissive"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/submissive
	duration = 60 SECONDS

/datum/status_effect/debuff/submissive/on_apply()
	. = ..()
	owner.add_movespeed_modifier("SUBMISSIVE", multiplicative_slowdown = 4)

/datum/status_effect/debuff/submissive/on_remove()
	. = ..()
	owner.remove_movespeed_modifier("SUBMISSIVE")

/atom/movable/screen/alert/status_effect/debuff/submissive
	name = "Conformable"
	desc = "Falling in line is my only choice."

/datum/status_effect/debuff/chilled
	id = "chilled"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/chilled
	effectedstats = list(STATKEY_SPD = -5, STATKEY_STR = -2, STATKEY_WIL = -2)
	duration = 15 SECONDS

/atom/movable/screen/alert/status_effect/debuff/chilled
	name = "Chilled"
	desc = "I can barely feel my limbs!"
	icon_state = "chilled"

/// RITUOS DEBUFFS
/datum/status_effect/debuff/ritesexpended
	id = "ritesexpended"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ritesexpended
	duration = 30 MINUTES

/datum/status_effect/debuff/armamentrites
	id = "armamentrites"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/armamentrites
	duration = 2 HOURS

/atom/movable/screen/alert/status_effect/debuff/ritesexpended
	name = "Rituos Fatigatio"
	desc = "My ritual is complete, yet not without cost. I must gift my lux tyme to recover, before I can conduct another rite."
	icon_state = "rituos_cooldown"

/datum/status_effect/debuff/lux_exhausted
	id = "lux_exhausted"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/lux_exhausted
	effectedstats = list(STATKEY_STR = -2, STATKEY_WIL = -2, STATKEY_LCK = -2)
	duration = 2 HOURS

/atom/movable/screen/alert/status_effect/debuff/lux_exhausted
	name = "Rituos Langouria"
	desc = "Body and will alike, sacrificed to complete the rites for another. Your will shall be done, but it will be quite some time before your lux can sustain another rite."
	icon_state = "rituos_exchange"

/datum/status_effect/debuff/ritesexpended_heavy
	id = "ritesexpended_heavy"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ritesexpended_heavy
	duration = 1 HOURS

/atom/movable/screen/alert/status_effect/debuff/armamentrites
	name = "Rituos Desicco"
	desc = "My ritual is complete, yet not without cost. I must gift my lux plenty of tyme to recover, before I can conduct another rite."
	icon_state = "rituos_cooldown_greater"

/atom/movable/screen/alert/status_effect/debuff/ritesexpended_heavy
	name = "Rituos Desicco"
	desc = "My ritual is complete, yet not without cost. I must gift my lux plenty of tyme to recover, before I can conduct another rite."
	icon_state = "rituos_cooldown_greater"

/atom/movable/screen/alert/status_effect/debuff/ravox_spirit_backlash
	name = "Spiritual Backlash"
	desc = "Myne body weak, myne muscles burn - but I must fight on!"
	icon_state = "call_to_arms_negative"

/atom/movable/screen/alert/status_effect/debuff/ravox_warrior_spirit
	name = "Luxstrain"
	desc = "My spirit is momentarily stretched thin!"
	icon_state = "luxstrain"

/// RESURRECTION DEBUFFS
/datum/status_effect/debuff/revived
	id = "revived" //For revive - your body DIDN'T rot, but it did suffer damage. Unlike being rotted, this one is only timed. Not forever.
	alert_type = /atom/movable/screen/alert/status_effect/debuff/revived
	effectedstats = list(STATKEY_STR = -1, STATKEY_PER = -1, STATKEY_INT = -1, STATKEY_WIL = -1, STATKEY_CON = -1, STATKEY_SPD = -1, STATKEY_LCK = -1)
	duration = 15 MINUTES		//Should be long enough to stop someone from running back into battle. Plus, this stacks with body-rot debuff. RIP.

/atom/movable/screen/alert/status_effect/debuff/revived
	name = "Revived" //Formerly 'Revival Sickness'.
	desc = "Brought back from death's sweet embrace, you walk amongst the living once more. Yet, it is not without consequence - your body aches, your spirit wanes, and your fate is still uncertain."
	icon_state = "revived"

/datum/status_effect/debuff/revived/on_apply()
	. = ..()
	owner.add_stress(/datum/stressevent/resurrected)
	switch(owner.patron?.type)
		if(/datum/patron/old_god) //Pseudoplaceholder. Feel free to rewrite, if desired.
			to_chat(owner, span_gamedeadsay("Blinding light, enveloping warmth, unconditional love. The darkness recedes behind me, as I come closer to the end of the tunnel - yet, just before I crest the horizon, something jerks me back into the inky-black.."))
		if(/datum/patron/divine/undivided) //Pseudoplaceholder. Feel free to rewrite, if desired.
			to_chat(owner, span_gamedeadsay("Blinding light, enveloping warmth, unconditional love. The darkness recedes behind me, as I come closer to the end of the tunnel - yet, just before I crest the horizon, something jerks me back into the inky-black.."))
		if(/datum/patron/divine/astrata)
			to_chat(owner, span_gamedeadsay("It was so cold without Her light. I felt it in my bones and my skin and my insides. Permeating darkness - consuming what little light I took with me. I will never take Her warmth for granted again.."))
		if(/datum/patron/divine/noc)
			to_chat(owner, span_gamedeadsay("There, at the edge of reality, laid a singular point of light. The more I focused upon it, the more it expanded. A tapestry of stars, speckled amongst a sea of phlogiston, forming indecipherable truths for me to ponder. I shouldn't have stared for so long.."))
		if(/datum/patron/divine/necra)
			to_chat(owner, span_gamedeadsay("Her halls were beautiful. Cold. Sterile. The world seems so much more chaotic compared to her demesne. I wasn't meant to come back.."))
		if(/datum/patron/divine/pestra)
			to_chat(owner, span_gamedeadsay("I trailed my body as it laid slumped over in that terrible, terrible place. To see my life spilling out onto the soil, to see my flesh wither into crusted rot, and to feel my grasp on this world slipping; it was too much for anyone to bare, let alone me.."))
		if(/datum/patron/divine/malum)
			to_chat(owner, span_gamedeadsay("The heat of the forge was overwhelming. My skin was tempered into moving steel and living armor. They fitted me with weapons of war and sent me to the line. There were so many others. All perfect in their construction. Waking up was the sweetest relief.."))
		if(/datum/patron/divine/dendor)
			to_chat(owner, span_gamedeadsay("The hunting grounds! Absolute freedom - primal violence and dancing madmen. So many were consumed by the beasts. But I was faster, more cunning, staying just ahead of the Mad God.."))
		if(/datum/patron/divine/xylix)
			to_chat(owner, span_gamedeadsay("The play has come to a close, yet the crowd hungers for an encore. Amidst a sea of tossed rosas, who am I to deny the audience what they crave the most? I clear my throat and prepare.."))
		if(/datum/patron/divine/eora)
			to_chat(owner, span_gamedeadsay("I woke upon a bed of silken sheets and creamy pillows, surrounded by my family. They looked overjoyed to see me - but I could hardly see their faces. They smiled and spoke, reaching out to welcome me. I wish I could remember what they looked like.."))
		if(/datum/patron/divine/abyssor)
			to_chat(owner, span_gamedeadsay("The rushing currents swept me down, down. Down towards the sleeping God. My lungs cried out in pain as I took saltwater into them. Vision clouding with red and black. His eye opened. His eye opened his eye opened HIS EYE OPENED HIS EYE OPENED HE WAS STIRRING-"))
		if(/datum/patron/divine/ravox)
			to_chat(owner, span_gamedeadsay("One by one - the injustices I committed were set upon the scales. Sweat ran down my back as I watched those that I saved plead my case. One by one - the scale lifted so slowly. The line of petitioners growing shorter.."))
		if(/datum/patron/inhumen/matthios) //Pseudoplaceholder. Feel free to rewrite, if desired.
			to_chat(owner, span_gamedeadsay("It was so cold without Her light. I felt it in my bones and my skin and my insides. Permeating darkness - consuming what little light I took with me. I will never take Her warmth for granted again.."))
		if(/datum/patron/inhumen/graggar) //Pseudoplaceholder. Feel free to rewrite, if desired.
			to_chat(owner, span_gamedeadsay("One by one - the injustices I committed were set upon the scales. Sweat ran down my back as I watched those that I saved plead my case. One by one - the scale lifted so slowly. The line of petitioners growing shorter.."))
		if(/datum/patron/inhumen/baotha) //Pseudoplaceholder. Feel free to rewrite, if desired.
			to_chat(owner, span_gamedeadsay("I woke upon a bed of silken sheets and creamy pillows, surrounded by my family. They looked overjoyed to see me - but I could hardly see their faces. They smiled and spoke, reaching out to welcome me. I wish I could remember what they looked like.."))
		if(/datum/patron/inhumen/zizo) //Pseudoplaceholder. Feel free to rewrite, if desired.
			to_chat(owner, span_gamedeadsay("There, at the edge of reality, laid a singular point of light. The more I focused upon it, the more it expanded. A tapestry of stars, speckled amongst a sea of phlogiston, forming indecipherable truths for me to ponder. I shouldn't have stared for so long.."))
		if(/datum/patron/godless) //Pseudoplaceholder. Feel free to rewrite, if desired.
			to_chat(owner, span_gamedeadsay("I saw my entire lyfe flash before my eyes, and then-.. nothing. No light, no darkness; complete, utter nothingness - save for a single thought, sinking into the inky-blackness.. and into whatever awaited on the other side. Suddenly, I feel myself yanked in a non-existing direction!"))
		else
			to_chat(owner, span_gamedeadsay("Blinding light, enveloping warmth, unconditional love. The darkness recedes behind me, as I come closer to the end of the tunnel - yet, just before I crest the horizon, something jerks me back into the inky-black.."))

/datum/status_effect/debuff/revived/on_remove()
	. = ..()
	owner.remove_stress(/datum/stressevent/resurrected)

// /datum/status_effect/debuff/revived_addendum
//	id = "revived_addendum"
//	alert_type = /atom/movable/screen/alert/status_effect/debuff/revived_addendum
//	duration = 5 MINUTES		//If timed right, it should naturally end alongside the 'Death's Door' debuff. Purely cosmetic, for the sake of keeping some continuity with the effects of resurrection.

//	/atom/movable/screen/alert/status_effect/debuff/revived_addendum
//	name = "Resurr.."
//	desc = "You can feel yourself, in both body and soul, becoming fully grounded once more. Tyme will tell if you'll lyve to see tomorrow, however, or if this is merely an intermission.."
//	icon_state = "revived_addendum"

// /datum/status_effect/debuff/revived/on_remove()
//	owner.apply_status_effect(/datum/status_effect/debuff/revival_addendum) //Cosmetic continuance, to ensure it ends with the 'Permadeath' debuff.*/ //Readd when someone can figure out how to un-errorify this.
//	. = ..()

/datum/status_effect/debuff/rotted
	id = "rotted_body" //For de-rot - your body ROTTED. Harsher penalty for longer, can be fully off-set with a cure-rot potion.
	alert_type = /atom/movable/screen/alert/status_effect/debuff/rotted
	effectedstats = list(STATKEY_STR = -2, STATKEY_PER = -2, STATKEY_INT = -2, STATKEY_WIL = -2, STATKEY_CON = -2, STATKEY_SPD = -2, STATKEY_LCK = -2)
	duration = 30 MINUTES	// Back to a temporary 30 minute duration. It hurts.

/atom/movable/screen/alert/status_effect/debuff/rotted
	name = "Atrophia"
	desc = "You came back from death, but everything aches.. you can feel it in your muscles, your bones.. Even in your nose, you can smell something putrid and foul. You.. live yet, but at what cost.. ?"
	icon_state = "revived_rot"

/datum/status_effect/debuff/rotted_zombie
	id = "rotted_zombie" //Replaces the flat-stat change, this should ONLY apply to zombies who have been dead for some time. Makes them easier to kill.
	alert_type = /atom/movable/screen/alert/status_effect/debuff/rotted_zombie
	effectedstats = list(STATKEY_CON = -8) //No duration = infinate in time - this is removed on de-rot miricle OR de-rot surgery. Won't be applied unless you've been a zombie for ~20 min.

/atom/movable/screen/alert/status_effect/debuff/rotted_zombie
	name = "Decomposing"
	desc = "Rotting flesh, dangling innards - the decay of what once was, no longer guarded by lyfe's thrumbings. Your spirit is struggling to remain rooted within this world.."
	icon_state = "rot"

/datum/status_effect/debuff/permadeath
	id = "permadeath"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/permadeath
	duration = 10 MINUTES //Effectively determines how long a character is threatened with permadeath. Kicks into gear once the initial deathmark-imposed grace period completes. Timed to match Revival Sickness.

/atom/movable/screen/alert/status_effect/debuff/permadeath
	name = "Death's Door"
	desc = "Your heart beats with arrythmic fright, as an otherworldly chill rolls through your very spirit. Should you perish again within a half-dae's tyme, nothing will be able to bring you back from death's grasp."
	icon_state = "permadeath"

/datum/status_effect/debuff/permadeath/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_DNR, id)
	owner.add_stress(/datum/stressevent/permadeath_threat)

/datum/status_effect/debuff/permadeath/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_DNR, id)
	owner.remove_stress(/datum/stressevent/permadeath_threat)
	owner.add_stress(/datum/stressevent/permadeath_end)

/// CONT. DEBUFFS
/datum/status_effect/debuff/dazed
	id = "dazed"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dazed
	effectedstats = list(STATKEY_PER = -2, STATKEY_INT = -2)
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/debuff/dazed/shield
	effectedstats = list(STATKEY_PER = -3, STATKEY_LCK = -1)
	duration = 8 SECONDS

/datum/status_effect/debuff/dazed/skullshatter
	effectedstats = list(STATKEY_PER = -1, STATKEY_INT = -1, STATKEY_SPD = -1)
	duration = -1

/datum/status_effect/debuff/dazed/smite
	effectedstats = list(STATKEY_PER = -1, STATKEY_INT = -2, STATKEY_SPD = -1)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/debuff/dazed
	name = "Dazed"
	desc = "You've been smacked on the head very hard. Which way is left, again?"
	icon_state = "dazed"

/datum/status_effect/debuff/cold
	id = "Chilled"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/cold
	effectedstats = list(STATKEY_SPD = -2)
	duration = 10 SECONDS
	var/cold_color = "#88BFFF"

/datum/status_effect/debuff/cold/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.add_atom_colour(cold_color, TEMPORARY_COLOUR_PRIORITY)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, cold_color), duration)

/atom/movable/screen/alert/status_effect/debuff/cold
	name = "Chilled"
	desc = "Something has chilled me to the bone! It's hard to move."
	icon_state = "muscles"

/datum/status_effect/debuff/cold/greater
	id = "Frozen"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/cold/greater
	effectedstats = list(STATKEY_SPD = -3)
	duration = 20 SECONDS
	cold_color = "#64A0FF"

/atom/movable/screen/alert/status_effect/debuff/cold/greater
	name = "Frozen"
	desc = "An intense cold has seized my body! I can barely move."
	icon_state = "muscles"

/// wrestler verison of daze////
/datum/status_effect/debuff/dazed/stunner
	id = "discombobulated"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dazed
	effectedstats = list(STATKEY_CON = -2, STATKEY_INT = -2)
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REFRESH

///// Freifechter Daze Variants /////
/datum/status_effect/debuff/dazed/longsword
	id = "durchlauffen"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dazed/longsword
	effectedstats = list(STATKEY_WIL = -4, STATKEY_INT = -1)
	duration = 18 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/dazed/longsword
	name = "CAN'T FUCKING BREATHE"
	desc = "WHAT THE HELL DID THEY DO TO ME?! I NEED TO ATTACK THEM WHILE THEY'RE SWINGING SO THEY CAN'T SHATTER MY WINDPIPE!!"
	icon_state = "mstrike"

/datum/status_effect/debuff/dazed/longsword2h
	id = "zorn ort"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dazed/longsword2h
	effectedstats = list(STATKEY_PER = -4, STATKEY_LCK = -3)
	duration = 16 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/dazed/longsword2h
	name = "CAN'T FUCKING SEE"
	desc = "WHAT THE HELL DID THEY DO TO ME?! I NEED TO RIPOSTE THEM WHILE THEY'RE SWINGING SO THEY CAN'T POKE MY EYES!!"
	icon_state = "mstrike"

/datum/status_effect/debuff/dazed/freisabre
	id = "uszkodzić"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dazed/freisabre
	effectedstats = list(STATKEY_STR = -2, STATKEY_SPD = -3)
	duration = 16 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/dazed/freisabre
	name = "Master Strike"
	desc = "How the fuck did they do that!? My wrist!"
	icon_state = "mstrike"

/datum/status_effect/debuff/dazed/swipe
	id = "clinch & swipe"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dazed/swipe
	effectedstats = list(STATKEY_CON = -4, STATKEY_STR = -1)
	duration = 1.5 SECONDS	//Should last BARELY ENOUGH for someone who's actively grappling and swiping you to get a constant refresh of the dedbuff, otherwise it's useless.
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/debuff/dazed/swipe
	name = "Clinched and Swiped!"
	desc = "Urgh! My face! My grip is weakened!"
	icon_state = "swiped"

/*/atom/movable/screen/alert/status_effect/debuff/dazed/shield
	name = "Dazed by fencer's wrap"
	desc = "That stupid piece of cloth is so distracting! It pisses me off!"
	icon_state = "dazed" */

/datum/status_effect/debuff/staggered
	id = "staggered"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/staggered
	effectedstats = list(STATKEY_PER = -2, STATKEY_SPD = -2, STATKEY_CON = -2)
	duration = 10 SECONDS

/atom/movable/screen/alert/status_effect/debuff/staggered
	name = "Staggered"
	desc = "You've been smacked by something big. The force of impact has left you staggered."
	icon_state = "dazed"

/datum/status_effect/debuff/staggered/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.5)

/datum/status_effect/debuff/staggered/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)

/datum/status_effect/debuff/excomm
	id = "Excommunicated!"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/excomm
	effectedstats = list(STATKEY_LCK = -2, STATKEY_INT = -2, STATKEY_SPD = -1, STATKEY_WIL = -1, STATKEY_CON = -1)
	duration = -1

/atom/movable/screen/alert/status_effect/debuff/excomm
	name = "Excommunicated!"
	desc = "The Ten have forsaken me!"
	icon_state = "excommunication"

/datum/status_effect/debuff/apostasy
	id = "Apostasy!"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/apostasy
	effectedstats = list(STATKEY_LCK = -5, STATKEY_INT = -3, STATKEY_PER = -2 , STATKEY_SPD = -2, STATKEY_WIL = -2, STATKEY_CON = -2)
	duration = -1
	var/resistant = FALSE
	var/original_devotion = 0
	var/original_prayer_effectiveness = 0
	var/original_passive_devotion_gain = 0
	var/original_passive_progression_gain = 0

/datum/status_effect/debuff/apostasy/on_creation(mob/living/new_owner, resistant = FALSE)
	src.resistant = resistant
	return ..()

/datum/status_effect/debuff/apostasy/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!H.devotion)
		return FALSE

	var/datum/devotion/D = H.devotion
	original_devotion = D.devotion
	original_prayer_effectiveness = D.prayer_effectiveness
	original_passive_devotion_gain = D.passive_devotion_gain
	original_passive_progression_gain = D.passive_progression_gain

	if(resistant)
		D.devotion = original_devotion * 0.5
		D.prayer_effectiveness = original_prayer_effectiveness * 0.5
		D.passive_devotion_gain = original_passive_devotion_gain * 0.5
		D.passive_progression_gain = original_passive_progression_gain * 0.5
	else
		D.devotion = 0
		D.prayer_effectiveness = 0
		D.passive_devotion_gain = 0
		D.passive_progression_gain = 0

	to_chat(H, span_boldnotice("I have been excommunicated. I am now unable to gain devotion."))
	return ..()

/datum/status_effect/debuff/apostasy/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.devotion)
			var/datum/devotion/D = H.devotion
			D.devotion = original_devotion
			D.prayer_effectiveness = original_prayer_effectiveness
			D.passive_devotion_gain = original_passive_devotion_gain
			D.passive_progression_gain = original_passive_progression_gain

		to_chat(H, span_boldnotice("I have been welcomed back to the Church. I am now able to gain devotion again."))

/atom/movable/screen/alert/status_effect/debuff/apostasy
	name = "Apostasy!"
	desc = "Shame upon the member of clergy!"
	icon_state = "apostate"

/datum/status_effect/debuff/hereticsermon
	id = "Heathen's Voyeurism!"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hereticsermon
	effectedstats = list(STATKEY_INT = -2, STATKEY_SPD = -2, STATKEY_LCK = -2)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/debuff/hereticsermon
	name = "Heathen's Voyeurism!"
	desc = "I was on the sermon, and my patron is not proud of me."
	icon_state = "hereticsermon"

/datum/status_effect/debuff/lost_naledi_mask
	id = "naledimask"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/naledimask
	effectedstats = list(STATKEY_WIL = -3, STATKEY_LCK = -3)

/atom/movable/screen/alert/status_effect/debuff/naledimask
	name = "Lost Mask"
	desc = "Djinns and daemons may claim me at any moment without the mask. It is not safe."
	icon_state = "muscles"

/datum/status_effect/debuff/lost_shaman_hood
	id = "naledimask"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/shamanhood
	effectedstats = list(STATKEY_WIL = -3, STATKEY_LCK = -3)

/atom/movable/screen/alert/status_effect/debuff/shamanhood
	name = "Lost Hood"
	desc = "The sacred hood is lost. I feel frail and sapped without it."

/datum/status_effect/debuff/lost_dungeoneer_hood
	id = "dungeoneerhood"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dungeoneer_hood
	effectedstats = list(STATKEY_STR = -3, STATKEY_LCK = -3)

/atom/movable/screen/alert/status_effect/debuff/dungeoneer_hood
	name = "Gnarly Visage"
	desc = "I am a repulsive freek looked down upon by everyone else. I'd do best to hide my visage once more."
	icon_state = "muscles"

///////////////////////
/// CLIMBING STUFF ///
/////////////////////

/// OPEN SPACE TURF BASED CLIMBING, MOB DRAG-DROP TILE
/datum/status_effect/debuff/climbing_lfwb
	id = "climbing_lfwb"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/climbing_lfwb
	tick_interval = 10
	var/stamcost = 30
	var/stamcost_final = 30
	var/mob/living/carbon/human/climber

/datum/status_effect/debuff/climbing_lfwb/on_creation(mob/living/new_owner, new_stamcost)
    stamcost = new_stamcost
    return ..()

/datum/status_effect/debuff/climbing_lfwb/on_apply()
	. = ..()
	climber = owner
	climber.climbing = TRUE
	climber.put_in_hands(new /obj/item/clothing/wall_grab, TRUE, FALSE, TRUE) // gotta have new before /obj/... , otherwise its gonna die

/datum/status_effect/debuff/climbing_lfwb/tick() // do we wanna do this shit every single second? I guess we do boss
	. = ..()
	climber = owner
	if((istype(climber.backr, /obj/item/clothing/climbing_gear)) || (istype(climber.backl, /obj/item/clothing/climbing_gear)))
		stamcost_final = stamcost / 2
		climber.stamina_add(stamcost_final) // every tick interval this much stamina is deducted
	else
		stamcost_final = stamcost
		climber.stamina_add(stamcost_final) // every tick interval this much stamina is deducted
//	to_chat(climber, span_warningbig("[stamcost_final] REMOVED!")) // debug msg
	var/turf/tile_under_climber = climber.loc
	var/list/random_shit_under_climber = list()
	for(var/obj/structure/flora/newbranch/branch in climber.loc)
		random_shit_under_climber += branch
	for(var/obj/machinery/light/rogue/chand/chandelier in climber.loc)
		random_shit_under_climber += chandelier
	for(var/obj/structure/kybraxor/fucking_hatch in climber.loc)
		random_shit_under_climber += fucking_hatch
	if(!istype(tile_under_climber, /turf/open/transparent/openspace))// if we aren't on open space turf, remove debuff (aka our feet are on solid shi or water)
		climber.remove_status_effect(/datum/status_effect/debuff/climbing_lfwb)
	if(random_shit_under_climber.len) // branches dont remove open space turf, so we have to check for it separately
		climber.remove_status_effect(/datum/status_effect/debuff/climbing_lfwb)
	else if(climber.stamina >= climber.max_stamina) // if we run out of green bar stamina, we fall
		to_chat(climber, span_dead("I can't hold onto the ledge for any longer!"))
		climber.remove_status_effect(/datum/status_effect/debuff/climbing_lfwb)
		tile_under_climber.zFall(climber)


/datum/status_effect/debuff/climbing_lfwb/on_remove()
	. = ..()
	climber = owner
	climber.climbing = FALSE
	climber.reset_offsets("wall_press")
	if(climber.is_holding_item_of_type(/obj/item/clothing/wall_grab)) // the slop slops itself holy shit
		for(var/obj/item/clothing/wall_grab/I in climber.held_items)
			if(istype(I, /obj/item/clothing/wall_grab))
				qdel(I)
				return

/atom/movable/screen/alert/status_effect/debuff/climbing_lfwb
	name = "Climbing..."
	desc = "Guess what, you are climbing, buddy."
	icon_state = "muscles"

/datum/status_effect/debuff/mesmerised
	id = "mesmerised"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/mesmerised
	effectedstats = list(STATKEY_STR = -2, STATKEY_LCK = -2, STATKEY_PER = -2, STATKEY_SPD = -2)
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/debuff/mesmerised
	name = "Mesmerised"
	desc = span_warning("Their beauty is otherwordly..")
	icon_state = "acid"

/datum/status_effect/debuff/liver_failure
	id = "liver_failure"
	alert_type = null
	tick_interval = -1
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/debuff/liver_failure/on_apply()
	if(!iscarbon(owner))
		return FALSE

	RegisterSignal(owner, COMSIG_LIVING_LIFE, PROC_REF(on_life))
	return ..()

/datum/status_effect/debuff/liver_failure/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_LIFE)
	return ..()

/datum/status_effect/debuff/liver_failure/proc/on_life(mob/living/carbon/carbon, seconds, times_fired)
	SIGNAL_HANDLER

	INVOKE_ASYNC(carbon, TYPE_PROC_REF(/mob/living/carbon, liver_failure))

/datum/status_effect/debuff/disgracedguardsman
	id = "disgracedguardsman"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/disgracedguardsman
	// No effected stats. Because outlaw already remove Guardsman buff

/atom/movable/screen/alert/status_effect/debuff/disgracedguardsman
	name = "Disgraced Guardsman"
	desc = "I betrayed my liege."
	icon_state = "guardsman_disgraced"

/datum/status_effect/debuff/vampbite
	id = "Vampire Bite"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/vampbite
	duration = 30 SECONDS

/datum/status_effect/debuff/vampbite/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_DRUQK, id)
	owner.add_stress(/datum/stressevent/high)
	to_chat(owner, span_love("Momentarily, you feel a sharp pain but it quickly shifts into a pleasant feeling washing over you..."))
	owner.overlay_fullscreen("vampirebite", /atom/movable/screen/fullscreen/weedsm)
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)

/datum/status_effect/debuff/vampbite/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_DRUQK, id)
	owner.remove_stress(/datum/stressevent/high)
	owner.clear_fullscreen("vampirebite")
	owner.visible_message("[owner]'s eyes appear to return to normal.")
	if(owner?.client)
		if(owner.client.screen && owner.client.screen.len)
			var/atom/movable/screen/plane_master/game_world/PM = locate(/atom/movable/screen/plane_master/game_world) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_fov_hidden) in owner.client.screen
			PM.backdrop(owner)
			PM = locate(/atom/movable/screen/plane_master/game_world_above) in owner.client.screen
			PM.backdrop(owner)

/atom/movable/screen/alert/status_effect/debuff/vampbite
	name = "Vampyrebiten"
	desc = "You are feeling something... Interesting.."
	icon_state = "acid"

/datum/status_effect/debuff/joybringer_druqks
	id = "joybringer_druqks"
	effectedstats = list(STATKEY_LCK = -2)
	duration = 15 SECONDS
	alert_type = null

/datum/status_effect/debuff/joybringer_druqks/on_apply()
	. = ..()
	owner.overlay_fullscreen("joybringer_weeds", /atom/movable/screen/fullscreen/weedsm)
	owner.overlay_fullscreen("joybringer_druqks", /atom/movable/screen/fullscreen/druqks)

	ADD_TRAIT(owner, TRAIT_DRUQK, src)

	if(owner.client)
		SSdroning.play_area_sound(get_area(owner), owner.client)

/datum/status_effect/debuff/joybringer_druqks/on_remove()
	. = ..()
	owner.clear_fullscreen("joybringer_druqks")
	owner.clear_fullscreen("joybringer_weeds")

	REMOVE_TRAIT(owner, TRAIT_DRUQK, src)

	if(owner.hallucination > 0)
		owner.hallucination = max(0, owner.hallucination - 15)

	if(owner.client)
		SSdroning.play_area_sound(get_area(owner), owner.client)

/datum/status_effect/debuff/joybringer_druqks/tick()
	if(owner.hallucination < 15) // this can stack up INFINITELY if you dont cap it like this
		owner.hallucination += 3 // and it doesnt decay *that* fast.
	owner.Jitter(1)

	if(!prob(10))
		return

	owner.emote(pick("chuckle", "giggle"), forced = TRUE)

/datum/status_effect/debuff/hobbled
	id = "hobbled"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/hobbled
	effectedstats = list(STATKEY_SPD = -2)
	duration = 8 SECONDS

/atom/movable/screen/alert/status_effect/debuff/hobbled
	name = "Hobbled"
	desc = "You've been struck in the leg! The force has left you staggered!"
	icon_state = "dazed"

/datum/status_effect/debuff/hobbled/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.5)

/datum/status_effect/debuff/hobbled/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)


/datum/status_effect/debuff/necrandeathdoorwilloss
	id = "Necran Deathly Calm"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/necranwilloss
	effectedstats = list(STATKEY_WIL = -4)
	var/blimmune = FALSE
	var/nobreath = FALSE

/datum/status_effect/debuff/necrandeathdoorwilloss/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.add_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING, multiplicative_slowdown = PULL_PRONE_SLOWDOWN)
		if(HAS_TRAIT(H, TRAIT_BLOODLOSS_IMMUNE))
			blimmune = TRUE
		else
			ADD_TRAIT(H, TRAIT_BLOODLOSS_IMMUNE, STATUS_EFFECT_TRAIT)
		if(HAS_TRAIT(H, TRAIT_NOBREATH))
			nobreath = TRUE
		else
			ADD_TRAIT(H, TRAIT_NOBREATH, STATUS_EFFECT_TRAIT)

/datum/status_effect/debuff/necrandeathdoorwilloss/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.remove_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING)
		if(!blimmune)
			REMOVE_TRAIT(H, TRAIT_BLOODLOSS_IMMUNE, STATUS_EFFECT_TRAIT)
		if(!nobreath)
			REMOVE_TRAIT(H, TRAIT_NOBREATH, STATUS_EFFECT_TRAIT)

/datum/status_effect/debuff/necrandeathdoorwilloss/process()
	.=..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.energy_add(-1)	//being in death's edge drains energy from people
		var/area/rogue/our_area = get_area(H)
		if(!(our_area.necra_area))
			owner.remove_status_effect(/datum/status_effect/debuff/necrandeathdoorwilloss)

/atom/movable/screen/alert/status_effect/debuff/necranwilloss
	name = "Necran Deathly Calm"
	desc = "I am on the edge of my lady's realm. My motivation slackens with such deathly tranquility."
	icon_state = "necravow"
	color ="#af9f9f"

/datum/status_effect/debuff/deathdoorwilloss
	id = "Deathly Calm"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/deathdoorwilloss
	effectedstats = list(STATKEY_WIL = -8)
	var/blimmune = FALSE
	var/nobreath = FALSE

/datum/status_effect/debuff/deathdoorwilloss/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.add_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING, multiplicative_slowdown = PULL_PRONE_SLOWDOWN)
	if(HAS_TRAIT(H, TRAIT_BLOODLOSS_IMMUNE))
		blimmune = TRUE
	else
		ADD_TRAIT(H, TRAIT_BLOODLOSS_IMMUNE, STATUS_EFFECT_TRAIT)
	if(HAS_TRAIT(H, TRAIT_NOBREATH))
		nobreath = TRUE
	else
		ADD_TRAIT(H, TRAIT_NOBREATH, STATUS_EFFECT_TRAIT)

/datum/status_effect/debuff/deathdoorwilloss/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.remove_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING)
		if(!blimmune)
			REMOVE_TRAIT(H, TRAIT_BLOODLOSS_IMMUNE, STATUS_EFFECT_TRAIT)
		if(!nobreath)
			REMOVE_TRAIT(H, TRAIT_NOBREATH, STATUS_EFFECT_TRAIT)

/datum/status_effect/debuff/deathdoorwilloss/process()
	.=..()
	owner.energy_add(-1)	//being in death's edge drains energy from people
	var/area/rogue/our_area = get_area(owner)
	if(!(our_area.necra_area))
		owner.remove_status_effect(/datum/status_effect/debuff/deathdoorwilloss)

/atom/movable/screen/alert/status_effect/debuff/deathdoorwilloss
	name = "Deathly Calm"
	desc = "I am on the edge of Death's realm. It is hard to feel motivated with such deathly tranquility."
	icon_state = "necravow"
	color ="#af9f9f"

/datum/status_effect/debuff/no_coom_cheating //Gets triggered when someone sets their arousal, prevents orgasms from sating vice/giving mood boosts
	id = "nocoomcheating"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/no_coom_cheating
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/debuff/no_coom_cheating
	name = "Arousal Imbalanced"
	desc = "My arousal level changed drastically, any orgasm I have now will not be satisfactory."
	icon_state = "arousalimbalance"

/datum/status_effect/debuff/no_coom_cheating/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_UNSATISFIED, id)

/datum/status_effect/debuff/no_coom_cheating/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_UNSATISFIED, id)

/datum/status_effect/debuff/bloody_mess
	id = "bloodymess"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bloody_mess
	duration = 20 SECONDS // this is EASILY enough time to kill someone w/ the effect.

/datum/status_effect/debuff/bloody_mess/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/physiology/phy = H.physiology 
	var/con_mod = H.STACON - 10
	// con mod needs to be greater than 1 for scaling
	if(con_mod > 0)
		// ensure their gotten con mod does not go below 1 or exceed the bleedrate cap.
		con_mod = clamp(con_mod, 1, CONSTITUTION_BLEEDRATE_CAP - 10)
		// this ""equalizes"" high con ppl into bleeding more, but they SHOULD generally still 
		// bleed less than if they had just 10 con. remember: this numbers gets sent THRU their con score after.
		phy.bleed_mod = 1.15 + (con_mod * 0.1) // at 15 con you'll bleed from a wound by .825
	else
		phy.bleed_mod = 1.15 // if you already have low con, we're not going to turbofuck you. ok?
	H.visible_message(span_warning("[owner]'s blood runs thin and begins GUSHING out of their wounds!"), span_danger("A FOUL SPELL IS CAUSING ME TO BLEED EN MASSE!"))

/datum/status_effect/debuff/bloody_mess/on_remove()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/physiology/phy = H.physiology 
	phy.bleed_mod = initial(phy.bleed_mod) // con can lower from the bleeding so we want it to just directly be set back to the initial
	H.visible_message(span_warning("[owner] has their wounds calm..."), span_warning("My wounds stop bleeding so heavily!"))


/atom/movable/screen/alert/status_effect/debuff/bloody_mess
	name = "Bloody Mess"
	desc = "My bleeding is quickened! I must grip my wounds, or I will lose myself steadfast!"

/datum/status_effect/debuff/sensitive_nerves
	id = "sensitivenerves"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/sensitive_nerves
	duration = 20 SECONDS // this is EASILY enough time to kill someone w/ the effect.

/datum/status_effect/debuff/sensitive_nerves/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/physiology/phy = H.physiology 
	var/pain_mod = phy.pain_mod
	phy.pain_mod = pain_mod * 1.15 // this then gets reduced by wil, among other things. change as needed.
	H.visible_message(span_warning("[owner] looks to be in great pain, their wounds BLACKENING!"), span_danger("EVERYTHING HURTS!! MY WOUNDS PAIN HAS INCREASED!!"))

/datum/status_effect/debuff/sensitive_nerves/on_remove()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/physiology/phy = H.physiology 
	var/pain_mod = phy.pain_mod
	phy.pain_mod = pain_mod / 1.15 // this should be a define fuuuck
	H.visible_message(span_warning("[owner]'s wounds suddenly return to normal!"), span_warning("My magickally induced pain subsides!"))


/atom/movable/screen/alert/status_effect/debuff/sensitive_nerves
	name = "Sensitive Nerves"
	desc = "IT HURTS!!! MY WOUNDS BITE INTO MY FLESH WITH SUCH RABID FEROCITY!"

/datum/status_effect/debuff/weapon_binded
	id = "wep_bind_debuff"
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/debuff/weapon_bind_debuff

/datum/status_effect/debuff/weapon_binded/on_apply()
	. = ..()
	owner.stamina_add(10)

/atom/movable/screen/alert/status_effect/debuff/weapon_bind_debuff
	name = "Weapon Binded"
	desc = "Our weapons binded! That conniving sod knew right where I was aiming! I can't benefit from a weapon bind!"
	icon = 'icons/mob/screen_alert_combat.dmi'
	icon_state = "weapon_bind_debuff"

/datum/status_effect/debuff/knockout
	id = "knockout"
	effectedstats = null
	alert_type = null
	duration = 12 SECONDS
	var/time = 0

/datum/status_effect/debuff/knockout/tick()
	time += 1
	switch(time)
		if(3)
			if(prob(70)) //You don't always know...
				var/msg = pick("I feel sleepy...", "I feel relaxed.", "My eyes feel a little heavy.")
				to_chat(owner, span_warning(msg))

		if(5)
			if(prob(50))
				owner.Slowdown(20)
			else
				owner.Slowdown(10)
		if(8)
			if(iscarbon(owner))
				var/mob/living/carbon/C = owner
				var/msg = pick("yawn", "cough", "clearthroat")
				C.emote(msg, forced = TRUE)
		if(12)
			// it's possible that stacking effects delay this.
			// If we hit 12 regardless we end
			Destroy()

/datum/status_effect/debuff/knockout/on_remove()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		if(C.IsSleeping()) //No need to add more it's already pretty long.
			return ..()
		C.SetSleeping(20 SECONDS)
	..()

/atom/movable/screen/alert/status_effect/debuff/knockout
	name = "Drowsy"
