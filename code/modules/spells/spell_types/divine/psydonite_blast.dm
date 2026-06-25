/////////////////////////////////
// PSYDON... BLASssss-- huh?  //
////////////////////////////////

//A joke spell for missionaries, there's a 99% chance you get a rock, a 1% you get a boulder from your shoe
//Hilarious

/datum/action/cooldown/spell/psydon/enduring_blast //Hilarious
	name = "ENDURING BLAST"
	desc = "'Now, where did I put that..?' </br>Checks your boot - or failing that, your surroundings - for something worthy of enacting HIS divine fury."
	button_icon_state = "ENDURINGBLAST"
	sound = null

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_NONE
	invocations = null

	devotion_cost = 25 //It costing the same amount despite being tenfold worse is hilarious, TBH.
	charge_required = FALSE
	cooldown_time = 5 SECONDS //WE CLOWN IN THIS FUCKIN' TOWN

/datum/action/cooldown/spell/psydon/enduring_blast/cast(atom/cast_on)
	. = ..()
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/turf/T = get_turf(H)
	if(!T)
		return FALSE

	var/obj/item/found_thing
	if(prob(99))
		found_thing = new /obj/item/natural/stone/(T)
		to_chat(H, span_info("I pluck a [found_thing] from my boot, for unleashing his wraith upon HIS enemies!"))
	else
		found_thing = new /obj/item/natural/rock(T) //HILARIOUS
		to_chat(H, span_info("I pluck a [found_thing] from my boot... wait, how did that even fit in there?!"))

	if(!H.put_in_hands(found_thing, FALSE))
		found_thing.forceMove(T)

	return TRUE
