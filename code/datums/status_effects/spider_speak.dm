/atom/movable/screen/alert/status_effect/buff/spider_speak
	name = "Spider language"
	desc = "I'm able to click my tongue how spiders speak."
	icon_state = "buff"

/datum/status_effect/buff/spider_speak
	id = "spider_speak"
	alert_type = /atom/movable/screen/alert/status_effect/buff/spider_speak
	duration = 2700 SECONDS

/datum/status_effect/buff/spider_speak/on_apply()
	owner.faction += "spiders"
	examine_text = "SUBJECTPRONOUN occasionally clicks [owner.p_their(FALSE)] tongue quietly."
	return TRUE

/datum/status_effect/buff/spider_speak/on_remove()
	owner.faction -= "spiders"
	return TRUE

/atom/movable/screen/alert/status_effect/buff/wildtongue
	name = "Wildtongue"
	desc = "The Wild recognizes me as kin."
	icon_state = "buff"


/datum/status_effect/buff/wildtongue
	id = "wildtongue"
	alert_type = /atom/movable/screen/alert/status_effect/buff/wildtongue
	duration = 15 MINUTES
	status_type = STATUS_EFFECT_REPLACE

	var/had_beast_language = FALSE
	var/list/preexisting_factions = list()


/datum/status_effect/buff/wildtongue/on_apply()
	if(!owner)
		return FALSE

	// Store factions the owner already had
	if(FACTION_PLANTS in owner.faction)
		preexisting_factions += FACTION_PLANTS
	if(FACTION_HORSE in owner.faction)
		preexisting_factions += FACTION_HORSE
	if(FACTION_CHICKENS in owner.faction)
		preexisting_factions += FACTION_CHICKENS
	if(FACTION_COWS in owner.faction)
		preexisting_factions += FACTION_COWS
	if(FACTION_GOATS in owner.faction)
		preexisting_factions += FACTION_GOATS
	if(FACTION_PIGS in owner.faction)
		preexisting_factions += FACTION_PIGS
	if(FACTION_LIZARDS in owner.faction)
		preexisting_factions += FACTION_LIZARDS
	if(FACTION_CABBITS in owner.faction)
		preexisting_factions += FACTION_CABBITS
	if(FACTION_MOLES in owner.faction)
		preexisting_factions += FACTION_MOLES
	if(FACTION_RATS in owner.faction)
		preexisting_factions += FACTION_RATS
	if(FACTION_SPIDER_LOWERS in owner.faction)
		preexisting_factions += FACTION_SPIDER_LOWERS
	if(FACTION_SPIDERS in owner.faction)
		preexisting_factions += FACTION_SPIDERS
	if(FACTION_CRABS in owner.faction)
		preexisting_factions += FACTION_CRABS
	if(FACTION_SAIGA in owner.faction)
		preexisting_factions += FACTION_SAIGA
	if(FACTION_BEARS in owner.faction)
		preexisting_factions += FACTION_BEARS
	if(FACTION_WOLFS in owner.faction)
		preexisting_factions += FACTION_WOLFS
	if(FACTION_BOARS in owner.faction)
		preexisting_factions += FACTION_BOARS
	if(FACTION_ROGUEANIMAL in owner.faction)
		preexisting_factions += FACTION_ROGUEANIMAL
	if(FACTION_DEEPONE in owner.faction)
		preexisting_factions += FACTION_DEEPONE
	if(FACTION_FAE in owner.faction)
		preexisting_factions += FACTION_FAE
	if(FACTION_ELEMENTAL in owner.faction)
		preexisting_factions += FACTION_ELEMENTAL
	if(FACTION_CAVES in owner.faction)
		preexisting_factions += FACTION_CAVES
	if(FACTION_TROLLS in owner.faction)
		preexisting_factions += FACTION_TROLLS
	if("White Stag" in owner.faction)
		preexisting_factions += "White Stag"

	// Add factions
	owner.faction += FACTION_PLANTS
	owner.faction += FACTION_HORSE
	owner.faction += FACTION_CHICKENS
	owner.faction += FACTION_COWS
	owner.faction += FACTION_GOATS
	owner.faction += FACTION_PIGS
	owner.faction += FACTION_LIZARDS
	owner.faction += FACTION_CABBITS
	owner.faction += FACTION_MOLES
	owner.faction += FACTION_RATS
	owner.faction += FACTION_SPIDER_LOWERS
	owner.faction += FACTION_SPIDERS
	owner.faction += FACTION_CRABS
	owner.faction += FACTION_SAIGA
	owner.faction += FACTION_BEARS
	owner.faction += FACTION_WOLFS
	owner.faction += FACTION_BOARS
	owner.faction += FACTION_ROGUEANIMAL
	owner.faction += FACTION_DEEPONE
	owner.faction += FACTION_FAE
	owner.faction += FACTION_ELEMENTAL
	owner.faction += FACTION_CAVES
	owner.faction += FACTION_TROLLS
	owner.faction += "White Stag"

	if(owner.has_language(/datum/language/beast))
		had_beast_language = TRUE
	else
		owner.grant_language(/datum/language/beast)

	examine_text = "<font color='#1b7500'>SUBJECTPRONOUN occasionally mimics the sounds and instincts of wild creatures.</font>"

	return TRUE


/datum/status_effect/buff/wildtongue/on_remove()
	if(!owner)
		return FALSE

	if(!(FACTION_PLANTS in preexisting_factions))
		owner.faction -= FACTION_PLANTS
	if(!(FACTION_HORSE in preexisting_factions))
		owner.faction -= FACTION_HORSE
	if(!(FACTION_CHICKENS in preexisting_factions))
		owner.faction -= FACTION_CHICKENS
	if(!(FACTION_COWS in preexisting_factions))
		owner.faction -= FACTION_COWS
	if(!(FACTION_GOATS in preexisting_factions))
		owner.faction -= FACTION_GOATS
	if(!(FACTION_PIGS in preexisting_factions))
		owner.faction -= FACTION_PIGS
	if(!(FACTION_LIZARDS in preexisting_factions))
		owner.faction -= FACTION_LIZARDS
	if(!(FACTION_CABBITS in preexisting_factions))
		owner.faction -= FACTION_CABBITS
	if(!(FACTION_MOLES in preexisting_factions))
		owner.faction -= FACTION_MOLES
	if(!(FACTION_RATS in preexisting_factions))
		owner.faction -= FACTION_RATS
	if(!(FACTION_SPIDER_LOWERS in preexisting_factions))
		owner.faction -= FACTION_SPIDER_LOWERS
	if(!(FACTION_SPIDERS in preexisting_factions))
		owner.faction -= FACTION_SPIDERS
	if(!(FACTION_CRABS in preexisting_factions))
		owner.faction -= FACTION_CRABS
	if(!(FACTION_SAIGA in preexisting_factions))
		owner.faction -= FACTION_SAIGA
	if(!(FACTION_BEARS in preexisting_factions))
		owner.faction -= FACTION_BEARS
	if(!(FACTION_WOLFS in preexisting_factions))
		owner.faction -= FACTION_WOLFS
	if(!(FACTION_BOARS in preexisting_factions))
		owner.faction -= FACTION_BOARS
	if(!(FACTION_ROGUEANIMAL in preexisting_factions))
		owner.faction -= FACTION_ROGUEANIMAL
	if(!(FACTION_DEEPONE in preexisting_factions))
		owner.faction -= FACTION_DEEPONE
	if(!(FACTION_FAE in preexisting_factions))
		owner.faction -= FACTION_FAE
	if(!(FACTION_ELEMENTAL in preexisting_factions))
		owner.faction -= FACTION_ELEMENTAL
	if(!(FACTION_CAVES in preexisting_factions))
		owner.faction -= FACTION_CAVES
	if(!(FACTION_TROLLS in preexisting_factions))
		owner.faction -= FACTION_TROLLS
	if(!("White Stag" in preexisting_factions))
		owner.faction -= "White Stag"

	if(!had_beast_language)
		owner.remove_language(/datum/language/beast)

	return TRUE
