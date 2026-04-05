/datum/action/cooldown/spell/magicians_brick
	button_icon = 'icons/mob/actions/roguespells.dmi'
	name = "Magician's Brick"
	desc = "Conjure a magical brick in your hand. Its power scale up to your Intelligence\n\
	The brick lasts until a new one is summoned or the spell is forgotten."
	fluff_desc = "One of the oldest spell in creation - probably invented after Magician's Stone (now considered obsolete). It is one of the few spell considered completely foolproof against anti-magic defenses, probably because a brick is so absurdly mundane that the spell itself refuses to be considered magic, even if it is."
	button_icon_state = "magicians_brick"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Valtarem!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW

	point_cost = 2

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/rogueweapon/conjured_brick = null

/datum/action/cooldown/spell/magicians_brick/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	if(src.conjured_brick)
		qdel(conjured_brick)
	var/obj/item/rogueweapon/R = new /obj/item/rogueweapon/magicbrick(user.drop_location())
	R.AddComponent(/datum/component/conjured_item)

	if(user.STAINT > 10)
		var/int_scaling = user.STAINT - 10
		R.force = R.force + int_scaling
		R.throwforce = R.throwforce + int_scaling * 2 // 2x scaling for throwing. Let's go.
		R.name = "magician's brick +[int_scaling]"
	user.put_in_hands(R)
	src.conjured_brick = R
	return TRUE

/datum/action/cooldown/spell/magicians_brick/Destroy()
	if(src.conjured_brick)
		conjured_brick.visible_message(span_warning("The [conjured_brick]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(conjured_brick)
	return ..()

/obj/item/rogueweapon/magicbrick
	name = "magician's brick"
	desc = "A brick formed out of arcane energy. Not a actual brick and cannot be used for construction. Makes for a very deadly melee and throwing weapon. Considered an implement for casting spell."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "claybrickcook"
	dropshrink = 0.75
	force = 15 // Copy pasted from real brick + 1 for neat number
	throwforce = 20 // +2 from real brick for neat scaling
	throw_speed = 4
	armor_penetration = PEN_NONE // It is a BRICK
	wdefense = 0
	wbalance = WBALANCE_NORMAL
	max_integrity = 50 // Don't parry with it lol
	slot_flags = ITEM_SLOT_MOUTH
	obj_flags = null
	w_class = WEIGHT_CLASS_TINY
	implement_tier = IMPLEMENT_TIER_LESSER
	implement_multiplier = IMPLEMENT_MULT_LESSER
	possible_item_intents = list(/datum/intent/mace/strike) // Not giving it smash so it don't become competetive with conjure weapon (as a melee weapon)
	associated_skill = /datum/skill/combat/maces // If it was tied to Arcyne it'd be too strong
	hitsound = list('sound/combat/hits/blunt/brick.ogg')
