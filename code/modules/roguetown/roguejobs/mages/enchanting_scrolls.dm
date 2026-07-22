

/*Enchantment scrolls here. Here enchantment scroll has a component. Refer to magic_items.dm, and it's various subfolders for differant enchantment datums.
T1 Enchantments below here*/

/obj/item/enchantmentscroll
	name = "runic tincture"
	desc = "An alchemical ink designed to conduct a specific type of arcana. Can be used on certain items and objects to imbue them."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clayfancyvasecook_bluegold" // temp
	var/component
	possible_item_intents = list(/datum/intent/hand/draw)
	grid_width = 64
	grid_height = 32
	dropshrink = 0.8
	var/apply_to_pretty // text describing what it can be applied to
	var/effects_pretty	// text describing what it does when applied

/obj/item/enchantmentscroll/get_mechanics_examine(mob/user)
	. = ..()
	if(!isarcyne(user))
		return
	. += span_info(apply_to_pretty)
	. += span_info(effects_pretty)

/obj/item/enchantmentscroll/attack_obj(obj/item/O, mob/living/user)
	if(!isarcyne(user))
		to_chat(user, span_warning("You've no idea how to draw the runes needed to use this."))
		return FALSE
	if(O.unenchantable)
		to_chat(user, span_warning("You cannot enchant this item."))
		return FALSE
	var/datum/component/magic_item/M = O.GetComponent(/datum/component/magic_item, component)
	if(M)
		if(length(M.magical_effects) >= M.enchanting_capacity)
			to_chat(user, span_warning("This item is already enchanted to its full capacity."))
			return FALSE
	return TRUE

// Tier hierarchy: scrolls are filed under /basic, /superior, /greater, /mythic.
// The Crown's standing-order goods (TRADE_GOOD_ENCHSCROLL_BASIC etc.) match each tier
// parent with accept_subtypes — a new scroll dropped under the right tier is automatically
// priced and shippable, no whitelist edits. Mythics are bespoke gear and intentionally
// not Crown-fungible.

/obj/item/enchantmentscroll/basic/woodcut
	name = "runic tincture of woodcutting"
	desc = "A vial of quicksilver ink, imbued with an enchantment of woodcutting."
	component = /datum/magic_item/mundane/woodcut
	apply_to_pretty = "Can be applied to axes, halberds, and most other axe-like weapons."
	effects_pretty = "Increases the woodcutting skill of the user while held."

/obj/item/enchantmentscroll/basic/woodcut/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon/stoneaxe) || istype(O,/obj/item/rogueweapon/halberd) || istype(O,/obj/item/rogueweapon/greataxe) || istype(O,/obj/item/rogueweapon/pick/bronze))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of woodcutting"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/basic/mining
	name = "runic tincture of mining"
	desc = "A vial of quicksilver ink, imbued with an enchantment of mining. Good for mining rock."
	component = /datum/magic_item/mundane/mining
	apply_to_pretty = "Can be applied to pickaxes and dolabras."
	effects_pretty = "Increases the mining skill of the user while held."

/obj/item/enchantmentscroll/basic/mining/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon/pick))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of mining"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/basic/xylix
	name = "runic tincture of xylix's grace"
	desc = "A vial of quicksilver ink, imbued with an enchantment of luck. Grants luck to its wearer."
	component = /datum/magic_item/mundane/xylix
	apply_to_pretty = "Can be applied to clothing."
	effects_pretty = "Increases the user's luck while equipped."

/obj/item/enchantmentscroll/basic/xylix/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of xylixs grace"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/basic/revealinglight
	name = "runic tincture of revealing light"
	desc = "A vial of quicksilver ink, imbued with an enchantment of revealing light."
	component = /datum/magic_item/mundane/revealinglight
	apply_to_pretty = "Can be applied to any clothing, armor, or weapon; alternately, can be used to draw a rune on the floor."
	effects_pretty = "Causes an affected item to emit light, or summons a permanent magelight orb on a turf."

/obj/item/enchantmentscroll/basic/revealinglight/attack_turf(turf/T, mob/living/user, multiplier)
	. = ..()
	if(!istype(T, /turf/open/floor))
		to_chat(user, span_warning("I need stable ground to draw a rune on!"))
		return
	user.visible_message(span_notice("\The [user] leans down towards \the [T], carefully inscribing a rune..."), span_notice("I start to draw a rune on \the [T] with the arcyne ink..."))
	if(!do_after(user, 2 SECONDS, target=T))
		to_chat(user, span_warning("My concentration breaks!"))
		return
	new /obj/effect/wisp/prestidigitation/runelight(T)
	playsound(T, 'sound/items/firelight.ogg', 100)
	qdel(src)

/obj/item/enchantmentscroll/basic/revealinglight/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of revealing light"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/basic/holding
	name = "runic tincture of storage"
	desc = "A vial of quicksilver ink, imbued with an enchantment of storage."
	component = /datum/magic_item/mundane/holding
	w_class = WEIGHT_CLASS_HUGE
	apply_to_pretty = "Can be applied to any storage item."
	effects_pretty = "Increases the item's storage by 2 columns, and allows smaller containers to hold objects with more bulk."

/obj/item/enchantmentscroll/basic/holding/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/storage))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of storage"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/basic/magnifiedlight
	name = "runic tincture of magnified light"
	desc = "A vial of quicksilver ink, imbued with an enchantment of magnified light."
	component = /datum/magic_item/mundane/magnifiedlight
	apply_to_pretty = "Can be applied to any light source sufficiently akin to a torch or lamptern."
	effects_pretty = "Doubles the range of lightsources."

/obj/item/enchantmentscroll/basic/magnifiedlight/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/flashlight/flare/torch))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of magnified light"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/basic/fairseeming
	name = "runic tincture of fair seeming"
	desc = "A vial of quicksilver ink, imbued with an enchantment of fair seeming."
	component = /datum/magic_item/mundane/fairseeming
	apply_to_pretty = "Can be applied to hand mirrors or any clothing."
	effects_pretty = "Right-click the enchanted item to cleanse yourself with magic."

/obj/item/enchantmentscroll/basic/fairseeming/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/handmirror))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of fair seeming"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

//T2 Enchantments below

/obj/item/enchantmentscroll/superior/nightvision
	name = "runic tincture of darkvision"
	desc = "A vial of quicksilver ink, imbued with an enchantment of darkvision."
	component = /datum/magic_item/superior/nightvision
	apply_to_pretty = "Can be applied to clothing."
	effects_pretty = "Grants the bearer nightvision."

/obj/item/enchantmentscroll/superior/nightvision/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of darkvision"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/superior/featherstep
	name = "runic tincture of featherstep"
	desc = "A vial of quicksilver ink, imbued with an enchantment of featherstep. Makes you speedier, and makes your footfalls silent."
	component = /datum/magic_item/superior/featherstep
	apply_to_pretty = "Can be applied to boots or a ring."
	effects_pretty = "Silences footsteps, quickens sneaking, and increases speed."

/obj/item/enchantmentscroll/superior/featherstep/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/shoes)||istype(O,/obj/item/clothing/ring))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of featherstep"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/superior/climbing
	name = "runic tincture of spider-climbing"
	desc = "A vial of quicksilver ink, imbued with an enchantment of spider-climbing."
	component = /datum/magic_item/superior/climbing
	apply_to_pretty = "Can be applied to clothing."
	effects_pretty = "Increases the bearer's climbing skill."

/obj/item/enchantmentscroll/superior/climbing/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of spider-climbing"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/superior/thievery
	name = "runic tincture of nimble fingers"
	desc = "A vial of quicksilver ink, imbued with an enchantment of thievery."
	component = /datum/magic_item/superior/thievery
	apply_to_pretty = "Can be applied to gloves or a ring."
	effects_pretty = "Increases the bearer's skill in pickpocketing and lockpicking."

/obj/item/enchantmentscroll/superior/thievery/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/gloves)||istype(O,/obj/item/clothing/ring))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of nimble fingers"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/superior/smithing
	name = "runic tincture of smithing"
	desc = "A vial of quicksilver ink, imbued with an enchantment of smithing.."
	component = /datum/magic_item/superior/smithing
	apply_to_pretty = "Can be applied to hammers."
	effects_pretty = "Increases the chance for deft strikes at an anvil."

/obj/item/enchantmentscroll/superior/smithing/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon/hammer))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of smithing"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))
//T3 Enchantments below

/obj/item/enchantmentscroll/greater/lifesteal
	name = "runic tincture of lyfestealing"
	desc = "A vial of quicksilver ink, imbued with an enchantment of lyfe stealing."
	component = /datum/magic_item/greater/lifesteal
	apply_to_pretty = "Can be applied to weapons."
	effects_pretty = "Heals you when striking enemies, on a cooldown."

/obj/item/enchantmentscroll/greater/lifesteal/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of lyfestealing"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/greater/lightning
	name = "runic tincture of lightning"
	desc = "A vial of quicksilver ink, imbued with an enchantment of lightning."
	component = /datum/magic_item/greater/lightning
	apply_to_pretty = "Can be applied to weapons."
	effects_pretty = "Shocks struck foes. Lightning occasionally leaps to other targets - including friendly ones."

/obj/item/enchantmentscroll/greater/lightning/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of lightning"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/greater/frostveil
	name = "runic tincture of lesser freezing"
	desc = "A vial of quicksilver ink, imbued with an enchantment of lesser freezing."
	component = /datum/magic_item/greater/frostveil
	apply_to_pretty = "Can be applied to clothing or weapons."
	effects_pretty = "Slows enemies that hit you (on armor) or that you hit (on weapons)."

/obj/item/enchantmentscroll/greater/frostveil/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of lesser freezing"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/greater/phoenixguard
	name = "runic tincture of phoenix guard"
	desc = "A vial of quicksilver ink, imbued with an enchantment of phoenixguard."
	component = /datum/magic_item/greater/phoenixguard
	apply_to_pretty = "Can be applied to clothing."
	effects_pretty = "Ignites enemies that strike the bearer."

/obj/item/enchantmentscroll/greater/phoenixguard/attack_obj(obj/item/O, mob/living/user)
	.=..()
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of phoenix guard"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/greater/woundclosing
	name = "runic tincture of wound closure"
	desc = "A vial of quicksilver ink, imbued with an enchantment of wound closure."
	component = /datum/magic_item/greater/woundclosing
	apply_to_pretty = "Can be applied to clothing."
	effects_pretty = "Grants the bearer the ability to heal wounds, similar to a spell or miracle."

/obj/item/enchantmentscroll/greater/woundclosing/attack_obj(obj/item/O, mob/living/user)
	.=..()
	if(istype(O,/obj/item/clothing/ring))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of wound closure"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/greater/returningweapon
	name = "runic tincture of returning weapon"
	desc = "A vial of quicksilver ink, imbued with an enchantment of returning weapon."
	component = /datum/magic_item/greater/returningweapon
	apply_to_pretty = "Can be applied to gloves or a ring."
	effects_pretty = "Grants the bearer the ability to bond with a weapon, recalling it to themselves at a later time."

/obj/item/enchantmentscroll/greater/returningweapon/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/ring)||istype(O,/obj/item/clothing/gloves))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of returning weapon"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/greater/archery
	name = "runic tincture of archery"
	desc = "A vial of quicksilver ink, imbued with an enchantment of archery."
	component = /datum/magic_item/greater/archery
	apply_to_pretty = "Can be applied to gloves, rings, or bracers."
	effects_pretty = "Increases the bearer's archery skill."

/obj/item/enchantmentscroll/greater/archery/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/ring)||istype(O,/obj/item/clothing/gloves)|| istype(O, /obj/item/clothing/wrists/roguetown/bracers))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of archery"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

//T4 below here

/obj/item/enchantmentscroll/mythic/infernalflame
	name = "runic tincture of infernalflame"
	desc = "A vial of quicksilver ink, imbued with an enchantment of infernalflame. Hitting an opponent sets them on fire."
	component = /datum/magic_item/mythic/infernalflame
	apply_to_pretty = "Can be applied to weapons, ranged weaponry, or clothing."
	effects_pretty = "Ignites struck enemies (on weaponry) or enemies that strike the bearer (on clothing)."

/obj/item/enchantmentscroll/mythic/infernalflame/attack_obj(obj/item/O, mob/living/user)
	.=..()
	if(istype(O,/obj/item/gun/ballistic/revolver/grenadelauncher)|| istype(O,/obj/item/rogueweapon)|| istype(O,/obj/item/clothing))	//bow and crossbows included
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of infernal flame"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/mythic/freeze
	name = "runic tincture of greater freezing"
	desc = "A vial of quicksilver ink, imbued with an enchantment of greater freezing."
	component = /datum/magic_item/mythic/freezing
	apply_to_pretty = "Can be applied to weapons, ranged weaponry, or clothing."
	effects_pretty = "Freezes struck enemies (on weaponry) or enemies that strike the bearer (on clothing)."

/obj/item/enchantmentscroll/mythic/freeze/attack_obj(obj/item/O, mob/living/user)
	.=..()
	if(istype(O,/obj/item/gun/ballistic/revolver/grenadelauncher)||istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))//bow and crossbows included
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of greater freezing"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/mythic/rewind
	name = "runic tincture of temporal rewind"
	desc = "A vial of quicksilver ink, imbued with an enchantment of temporal rewind."
	component = /datum/magic_item/mythic/rewind
	apply_to_pretty = "Can be applied to weapons or clothing."
	effects_pretty = "A few seconds after being struck, the bearer will teleport back to the location of the blow."

/obj/item/enchantmentscroll/mythic/rewind/attack_obj(obj/item/O, mob/living/user)
	.=..()
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of temporal rewind"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))

/obj/item/enchantmentscroll/mythic/briars
	name = "runic tincture of briar's curse"
	desc = "A vial of quicksilver ink, imbued with an enchantment of briar's curse."
	component = /datum/magic_item/mythic/briarcurse
	apply_to_pretty = "Can be applied to weapons."
	effects_pretty = "Increases a weapon's force, but its durability decays faster."

/obj/item/enchantmentscroll/mythic/briars/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You scribe intricate runes onto [O] with [src], imbuing it with an enchantment!"))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of briar's curse"
		qdel(src)
	else
		to_chat(user, span_notice("You don't think [O] will take to the enchantment. Best not to waste the ink."))
