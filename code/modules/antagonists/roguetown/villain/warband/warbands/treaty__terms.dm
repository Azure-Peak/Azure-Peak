//////////// TERMS
/datum/treaty/terms
	var/name
	var/custom_name					// freeform terms can be renamed
	var/desc

	var/target	 					// the "source"
	var/receiver					// the "destination"
	var/obj_target					// the "object" / territory/object being moved

	var/target_options = 0			// 0 = no direct target | 1 = human target | 2 = territory target | 3 = faction target | 5 = faction territory/cede | 6 = open text target & receiver (mob or faction). not used atm | 7 = faction target & receiver 
	// don't ask what happened to target option number 4

	var/list/authorities = list()	// if a character's listed on a term as an authority, their signature is required.
	var/list/signatures = list()
	var/minimum_signatures = 1		// how many authorities need to sign a term before it's confirmed
	var/open_signatures = FALSE		// when this is true, a term will accept any signature
	var/hint						// when someone without Law Expert examines a treaty, they'll only get a vague idea about the terms involved
	var/warbandlock 				// certain terms can only be demanded by certain warbands
	var/signed = FALSE				// if a term has been signed
	var/text = ""					// for written text (e.g: new laws, freeform demands)
	var/number = 0 					// for numbers (e.g: new tax rates, money demands)
	var/requires_number = FALSE
	var/requires_text = FALSE
	var/datum/mind/author 			// the mind that drafted the term

//////////// CATEGORY: LAW
//////////////////////////
/datum/treaty/terms/codify_law
	name = "Codify Law"
	authorities = list(/datum/job/roguetown/lord)
	desc = "A codified law cannot be removed."
	hint = "...something about codifying a law..."
	requires_text = TRUE

/datum/treaty/terms/remove_law
	name = "Abolish Law"
	authorities = list(/datum/job/roguetown/lord, /datum/job/roguetown/hand, /datum/job/roguetown/marshal) // this can easily be reversed, so there's no real harm in letting the Hand & Marshal sign for it too
	desc = "An abolished law will be erased."
	hint = "...something about abolishing a law..."
	requires_number = TRUE

/datum/treaty/terms/freeze_laws
	name = "Freeze Laws"
	authorities = list(/datum/job/roguetown/lord)
	desc = "No law can be instated or erased for the forseeable future."
	hint = "...something about something else getting frozen..."

//////////// CATEGORY: TAX
//////////////////////////
/datum/treaty/terms/set_tax/noble
	name = "Adjust Noble Tax"
	desc = "A tax rate established here shall remain for yils."
	authorities = list(/datum/job/roguetown/lord)
	hint = "...something about taxes and the Nobility..."
	requires_number = TRUE

/datum/treaty/terms/set_tax/yeoman
	name = "Adjust Yeoman Tax"
	desc = "A tax rate established here shall remain for yils."
	authorities = list(/datum/job/roguetown/lord)
	hint = "...something about Yeomen and taxes..."
	requires_number = TRUE

/datum/treaty/terms/set_tax/peasant
	name = "Adjust Peasantry Tax"
	desc = "A tax rate established here shall remain for yils."
	authorities = list(/datum/job/roguetown/lord)
	hint = "...something about the peasantry's tax rate..."
	requires_number = TRUE
 
/datum/treaty/terms/set_tax/church
	name = "Adjust Church Tax"
	desc = "A tax rate established here shall remain for yils."
	authorities = list(/datum/job/roguetown/lord, /datum/job/roguetown/priest)
	hint = "...something about taxes and the Church..."
	requires_number = TRUE

//////////// CATEGORY: COIN & TERRITORY
///////////////////////////////////////
/datum/treaty/terms/territory_loss
	name = "Cede Territory"
	desc = "Cede an entire territory"
	target_options = 5
	hint = "...something about ceding some territory."
	authorities = list("faction owner")

/datum/treaty/terms/cointribute
	name = "Mammon"
	desc = "A tribute of coin. Coin may be demanded at an excess beyond a target's coffers - at which point they are sunk into a deficit."
	hint = "...there's a few details about an exchange of mammon..."
	authorities = list("target")
	requires_number = TRUE
	target_options = 7

//////////// CATEGORY: MISC
///////////////////////////
/datum/treaty/terms/exile
	name = "Exile"
	authorities = list("target", /datum/job/roguetown/priest, /datum/job/roguetown/lord)
	desc = "Should daelight find the Exile within the city limits, they'll be lit ablaze."
	hint = "...something regarding someone's exile..."
	minimum_signatures = 2
	target_options = 1

/datum/treaty/terms/freeform
	name = "Freeform"
	desc = "As written."
	hint = "...something I truly can't make heads or tails of..."
	requires_text = TRUE
	open_signatures = TRUE

//////////// CATEGORY: UNIQUE
/////////////////////////////
/datum/treaty/terms/unique/wizard
	name = "Acknowledge Superior Wizard"
	desc = "Admit the arcane superiority of the SORCERER-KING, henceforth and forever."
	warbandlock = /datum/warbands/storyteller/wizard
	authorities = list(/datum/job/roguetown/magician)
	hint = "...every other sentence is about how magnificent some wizard is.."

//////////////////////////////////////////////////////
//////////////////////////////////////////////////////
//////////////////////////////////////////////////////



#undef WARBAND_TERMS
