/proc/parse_zone(zone, obj/item/bodypart/affecting = null)
	// this helps adapt older code
	if(affecting?.body_zone == BODY_ZONE_TAUR)
		return "tauric half"
	switch(zone)
		if(BODY_ZONE_PRECISE_R_HAND)
			return "right hand"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "left hand"
		if(BODY_ZONE_L_ARM)
			return "left arm"
		if(BODY_ZONE_R_ARM)
			return "right arm"
		if(BODY_ZONE_L_LEG)
			return "left leg"
		if(BODY_ZONE_R_LEG)
			return "right leg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "left foot"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "right foot"
		if(BODY_ZONE_TAUR)
			return "tauric half"
		if(BODY_ZONE_PRECISE_NECK)
			return "throat"
		if(BODY_ZONE_PRECISE_GROIN)
			return "groin"
		if(BODY_ZONE_PRECISE_EARS)	//we want the chatlog to say 'grabbed his ear' not 'grabbed his ears' etc
			return "ear"
		if(BODY_ZONE_PRECISE_R_EYE)
			return "right eye"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "left eye"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_SKULL)
			return "skull"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
	return zone

/proc/parse_organ_slot(slot)
	switch(slot)
		if(ORGAN_SLOT_BRAIN)
			return "brain"
		if(ORGAN_SLOT_APPENDIX)
			return "appendix"
		if(ORGAN_SLOT_RIGHT_ARM_AUG)
			return "right arm implant"
		if(ORGAN_SLOT_LEFT_ARM_AUG)
			return "left arm implant"
		if(ORGAN_SLOT_STOMACH)
			return "stomach"
		if(ORGAN_SLOT_STOMACH_AID)
			return "stomach aid"
		if(ORGAN_SLOT_BREATHING_TUBE)
			return "breathing tube"
		if(ORGAN_SLOT_EARS)
			return "ears"
		if(ORGAN_SLOT_EYES)
			return "eyes"
		if(ORGAN_SLOT_LUNGS)
			return "lungs"
		if(ORGAN_SLOT_HEART)
			return "heart"
		if(ORGAN_SLOT_ZOMBIE)
			return "zombie gland"
		if(ORGAN_SLOT_THRUSTERS)
			return "thrusters"
		if(ORGAN_SLOT_HUD)
			return "eye implant"
		if(ORGAN_SLOT_LIVER)
			return "liver"
		if(ORGAN_SLOT_TONGUE)
			return "tongue"
		if(ORGAN_SLOT_VOICE)
			return "vocal cords"
		if(ORGAN_SLOT_ADAMANTINE_RESONATOR)
			return "adamantine resonator"
		if(ORGAN_SLOT_HEART_AID)
			return "heart aid"
		if(ORGAN_SLOT_BRAIN_ANTIDROP)
			return "brain antidrop implant"
		if(ORGAN_SLOT_BRAIN_ANTISTUN)
			return "brain antistun implant"
		if(ORGAN_SLOT_TAIL)
			return "tail"
		if(ORGAN_SLOT_PARASITE_EGG)
			return "parasite egg"
		if(ORGAN_SLOT_REGENERATIVE_CORE)
			return "regenerative core"
	return slot
