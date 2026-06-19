/datum/action/cooldown/spell/conjure_spectacles
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "Conjure Spectacles"
	desc = "Conjure an illusionary set of Spectacles of your choice in your hand.\n\
	The Spectacles will be unsummoned should you conjure a new one or unbind the spell.\n\
	Unlike actual Spectacle varients, these won't grant special abilities/sight."
	button_icon_state = "conjspect"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Caeca sum!") // I'm blind!
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1

	point_cost = 0
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/clothing/mask/rogue/spectacles/conjured_spectacles = null

	var/list/spectacles = list(
		"Spectacles" = /obj/item/clothing/mask/rogue/spectacles,
		"Nocshades" = /obj/item/clothing/mask/rogue/spectacles/inq_lesser_summoned,
		"Golden Spectacles" = /obj/item/clothing/mask/rogue/spectacles/golden_lesser_summoned,
		"Silver Monocle" = /obj/item/clothing/mask/rogue/spectacles/monocle,
		"Smokey Onyxa Spectacles" = /obj/item/clothing/mask/rogue/spectacles/onyxa_lesser_summoned,
	)

/datum/action/cooldown/spell/conjure_spectacles/cast(list/targets, mob/living/user = usr)
	. = ..()
	var/spectacles_choice = input(user, "Choose a spectacles", "Conjure Spectacles") as anything in spectacles
	if(!spectacles_choice)
		return
	if(src.conjured_spectacles)
		qdel(src.conjured_spectacles)
	spectacles_choice = spectacles[spectacles_choice]

	var/obj/item/clothing/mask/rogue/spectacles/R = new spectacles_choice(user.drop_location())
	if(!QDELETED(R))
		R.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE)
	user.put_in_hands(R)
	src.conjured_spectacles = R
	R.sellprice = 0
	return TRUE

/datum/action/cooldown/spell/conjure_spectacles/miracle
	associated_skill = /datum/skill/magic/holy

/datum/action/cooldown/spell/conjure_spectacles/Destroy()
	if(src.conjured_spectacles)
		conjured_spectacles.visible_message(span_warning("The [conjured_spectacles]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(src.conjured_spectacles)
	return ..()

//Sorry, it has to be done. No engineering/night vision for no spellcost. You could probably add crafted varients and axe this codenote though if such is done. Considering mages can make worse things than Nocshades.

// Nocshades summonable lesser varient - with no mechanical effects

/obj/item/clothing/mask/rogue/spectacles/inq_lesser_summoned
	name = "summoned nocshade lens-pair"
	icon_state = "bglasses"
	desc = "An argument between the chosen of Noc and the Otavan Orthodoxy has raged on for years.\n\
	No-one truly knows who the original creator of these glasses was.\n\
	But one thing, at least, is certain: they are quite fashionable."

// Smokey onyxa spectacles summonable lesser varient - with no mechanical effects (seperate cause my third-eye senses potental for the original varient)
// ALso because your specs aren't the authentic real-deal, its funnier to have them visably a knockoff varient.

/obj/item/clothing/mask/rogue/spectacles/onyxa_lesser_summoned
	name = "summoned smokey onyxa spectacles"
	icon_state = "sglasses"
	desc = "Death has come to your little town, Sheriff. Now, you can either ignore it, or you can help me to stop it." //KEEPING IT, ITS PEAK SIRE
		
// Golden spectacles summonable lesser varient - with no mechanical effects

/obj/item/clothing/mask/rogue/spectacles/golden_lesser_summoned
	name = "summoned golden spectacles"
	icon_state = "goggles"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 35
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	anvilrepair = /datum/skill/craft/armorsmithing
	adjustable = CAN_CADJUST
	var/active_item = FALSE

/obj/item/clothing/mask/rogue/spectacles/golden_lesser_summoned/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))	//Standard mask
