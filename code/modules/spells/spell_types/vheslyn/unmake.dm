// Unmake -> it just kills you so you can manually explode
/datum/action/cooldown/spell/vheslyn/unmake
	name = "Unmake"
	desc = "Invoke an excess of corrupted magicked into the Needle in your skull and violently detonate your skull and body, injuring and setting anyone ablaze around you. This triggers it instantly by killing you, with no different effects to dying normally."
	fluff_desc = "The Needle is an artifact borne from the pyres of the Vheslynic cult, a reanimating blessing of Vheslyn, designed to hollow out creation and reanimate one to purpose anew. It also serves a second purpose of unraveling husks that have served their purpose."
	button_icon = 'icons/mob/actions/vheslynspells.dmi'
	button_icon_state = "unmake"
	charge_required = FALSE
	click_to_activate = FALSE
	cooldown_time = 5 SECONDS //Intended to be very short, this is a suicide spell sire.
	invocations = "UN'MER'KI SELIA!" //UNMAKE ME! - gibberished
	associated_skill = /datum/skill/magic/arcane

/datum/action/cooldown/spell/vheslyn/unmake/cast(list/targets, mob/living/user = usr)
	..()
	if(alert(user, "Do you wish to sacrifice this vessel early?", "Unravel this worthless husk", "Yes", "No") == "No")
		return
	
	user.death() //Your trait handles the explosion + gib. Its as simple as that.
	return TRUE
