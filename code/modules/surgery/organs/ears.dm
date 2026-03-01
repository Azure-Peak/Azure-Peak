/obj/item/organ/ears
	name = "ears"
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "ear"
	desc = ""
	zone = BODY_ZONE_PRECISE_EARS
	slot = ORGAN_SLOT_EARS
	gender = PLURAL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = span_info("My ears begin to resonate with an internal ring sometimes.")
	now_failing = span_warning("I are unable to hear at all!")
	now_fixed = span_info("Noise slowly begins filling my ears once more.")
	low_threshold_cleared = span_info("The ringing in my ears has died down.")

	visible_organ = TRUE

	// `deaf` measures "ticks" of deafness. While > 0, the person is unable
	// to hear anything.
	var/deaf = 0

	// `damage` in this case measures long term damage to the ears, if too high,
	// the person will not have either `deaf` or `ear_damage` decrease
	// without external aid (earmuffs, drugs)

	//Resistance against loud noises
	var/bang_protect = 0
	// Multiplier for both long term and short term ear damage
	var/damage_multiplier = 1

	//Used for the panel - probably can be used for something ELSE as well.
	var/ear_sensitivity = EARS_NORMAL //Nothing happens

/obj/item/organ/ears/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	for(var/datum/wound/facial/ears/ear_wound as anything in M.get_wounds())
		qdel(ear_wound)

/obj/item/organ/ears/on_life()
	if(!iscarbon(owner))
		return
	..()
	var/mob/living/carbon/C = owner
	if((damage < maxHealth) && (organ_flags & ORGAN_FAILING))	//ear damage can be repaired from the failing condition
		organ_flags &= ~ORGAN_FAILING
	// genetic deafness prevents the body from using the ears, even if healthy
	if(HAS_TRAIT(C, TRAIT_DEAF))
		deaf = max(deaf, 1)
	else if(!(organ_flags & ORGAN_FAILING)) // if this organ is failing, do not clear deaf stacks.
		deaf = max(deaf - 1, 0)
		if(prob(damage / 20) && (damage > low_threshold))
			adjustEarDamage(0, 4)
			SEND_SOUND(C, sound('sound/blank.ogg'))
			to_chat(C, span_warning("The ringing in my ears grows louder, blocking out any external noises for a moment."))
	else if((organ_flags & ORGAN_FAILING) && (deaf == 0))
		deaf = 1	//stop being not deaf you deaf idiot

/obj/item/organ/ears/proc/restoreEars()
	deaf = 0
	damage = 0
	organ_flags &= ~ORGAN_FAILING

	var/mob/living/carbon/C = owner

	if(iscarbon(owner) && HAS_TRAIT(C, TRAIT_DEAF))
		deaf = 1

/obj/item/organ/ears/proc/adjustEarDamage(ddmg, ddeaf)
	damage = max(damage + (ddmg*damage_multiplier), 0)
	deaf = max(deaf + (ddeaf*damage_multiplier), 0)

/obj/item/organ/ears/proc/minimumDeafTicks(value)
	deaf = max(deaf, value)

/obj/item/organ/ears/invincible
	damage_multiplier = 0


/mob/proc/restoreEars()

/mob/living/carbon/restoreEars()
	var/obj/item/organ/ears/ears = getorgan(/obj/item/organ/ears)
	if(ears)
		ears.restoreEars()

/mob/proc/adjustEarDamage()

/mob/living/carbon/adjustEarDamage(ddmg, ddeaf)
	var/obj/item/organ/ears/ears = getorgan(/obj/item/organ/ears)
	if(ears)
		ears.adjustEarDamage(ddmg, ddeaf)

/mob/proc/minimumDeafTicks()

/mob/living/carbon/minimumDeafTicks(value)
	var/obj/item/organ/ears/ears = getorgan(/obj/item/organ/ears)
	if(ears)
		ears.minimumDeafTicks(value)

/obj/item/organ/ears/cat
	name = "cat ears"
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "kitty"
	damage_multiplier = 2
	accessory_type = /datum/sprite_accessory/ears/cat_big
	ear_sensitivity = EARS_SENSITIVE

/obj/item/organ/ears/penguin
	name = "penguin ears"
	desc = ""
	var/datum/component/waddle

/obj/item/organ/ears/penguin/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	. = ..()
	if(istype(H))
		to_chat(H, span_notice("I suddenly feel like you've lost my balance."))
		waddle = H.AddComponent(/datum/component/waddling)

/obj/item/organ/ears/penguin/Remove(mob/living/carbon/human/H,  special = 0)
	. = ..()
	if(istype(H))
		to_chat(H, span_notice("My sense of balance comes back to you."))
		QDEL_NULL(waddle)

/obj/item/organ/ears/bronze
	name = "tin ears"
	desc = ""
	damage_multiplier = 0.1 //STRONK
	bang_protect = 1 //Fear me weaklings.

/obj/item/organ/ears/cybernetic
	name = "cybernetic ears"
	icon_state = "ears-c"
	desc = ""
	damage_multiplier = 0.9
	organ_flags = ORGAN_SYNTHETIC

/obj/item/organ/ears/cybernetic/upgraded
	name = "upgraded cybernetic ears"
	icon_state = "ears-c-u"
	desc = ""
	damage_multiplier = 0.5

/obj/item/organ/ears/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	damage += 40/severity

/obj/item/organ/ears/anthro
	name = "wild-kin ears"
	ear_sensitivity = EARS_SENSITIVE

/obj/item/organ/ears/lupian
	name = "lupian ears"
	ear_sensitivity = EARS_SENSITIVE

/obj/item/organ/ears/vulpkanin
	name = "venardine ears"
	accessory_type = /datum/sprite_accessory/ears/fox
	ear_sensitivity = EARS_SENSITIVE

/obj/item/organ/ears/tajaran
	name = "tajaran ears"
	ear_sensitivity = EARS_SENSITIVE

/obj/item/organ/ears/elf
	name = "elf ears"
	accessory_type = /datum/sprite_accessory/ears/elf
	ear_sensitivity = EARS_SENSITIVE

/obj/item/organ/ears/elfw
	name = "wood elf ears"
	accessory_type = /datum/sprite_accessory/ears/elfw
	ear_sensitivity = EARS_SENSITIVE

/obj/item/organ/ears/tiefling
	name = "tiefling ears"
	accessory_type = /datum/sprite_accessory/ears
	ear_sensitivity = EARS_SENSITIVE

/obj/item/organ/ears/akula
	name = "axian ears"
	accessory_type = /datum/sprite_accessory/ears/shark

/obj/item/organ/ears/halforc
	name = "halforc ears"
	accessory_type = /datum/sprite_accessory/ears/halforc
	ear_sensitivity = EARS_SENSITIVE

/obj/item/organ/ears/goblin
	name = "goblin ears"
	accessory_type = /datum/sprite_accessory/ears/goblin
	ear_sensitivity = EARS_SENSITIVE

/obj/item/organ/ears/psy_vault_guard
	name = "cobra hood"
	accessory_type = /datum/sprite_accessory/ears/cobrahood
