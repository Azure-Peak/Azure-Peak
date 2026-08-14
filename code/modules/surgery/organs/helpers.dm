/**
	* Get the organ object from the mob matching the passed in typepath
	*
	* Arguments:
	* * typepath The typepath of the organ to get
	*/
/mob/proc/getorgan(typepath)
	return

/**
	* Get an organ relating to a specific slot
	*
	* Arguments:
	* * slot Slot to get the organ from
	*/
/mob/proc/getorganslot(slot)
	return

/**
	* Get organ objects by zone
	*
	* This will return a list of all the organs that are relevant to the zone that is passedin
	*
	* Arguments:
	* * zone [a BODY_ZONE_X define](https://github.com/tgstation/tgstation/blob/master/code/__DEFINES/combat.dm#L187-L200)
	*/
/mob/proc/getorganszone(zone, subzones = FALSE)
	return

/mob/living/carbon/getorgan(typepath)
	return (locate(typepath) in internal_organs)

/mob/living/carbon/getorganslot(slot)
	RETURN_TYPE(/obj/item/organ)
	return internal_organs_slot[slot]

/mob/living/carbon/getorganszone(zone, subzones = FALSE)
	var/list/returnorg = list()
	if(subzones)
		var/obj/item/bodypart/bodypart = get_bodypart(zone)
		if(bodypart)
			for(var/subzone in (bodypart.subtargets - zone))
				returnorg += getorganszone(subzone)

	for(var/obj/item/organ/organ as anything in internal_organs)
		if(organ.zone != zone)
			continue
		returnorg += organ
	return returnorg
