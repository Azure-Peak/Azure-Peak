

/*Enchantment scrolls here. Here enchantment scroll has a component. Refer to magic_items.dm, and it's various subfolders for differant enchantment datums.
T1 Enchantments below here*/

/obj/item/enchantmentscroll
	name = "scroll of enchanting"
	desc = "A scroll imbued with an arcane enchantment. Can be used on certain items to imbue them."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "enchantment"
	var/component
	possible_item_intents = list(/datum/intent/use)
	grid_width = 64
	grid_height = 32

/obj/item/enchantmentscroll/attack_obj(obj/item/O, mob/living/user)
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
	name = "enchanting scroll of woodcutting"
	desc = "A scroll imbued with an enchantment of woodcutting. Good for cutting wood."
	component = /datum/magic_item/mundane/woodcut

/obj/item/enchantmentscroll/basic/woodcut/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon/stoneaxe))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of woodcutting"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/basic/mining
	name = "enchanting scroll of mining"
	desc = "A scroll imbued with an enchantment of mining. Good for mining rock."
	component = /datum/magic_item/mundane/mining

/obj/item/enchantmentscroll/basic/mining/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon/pick))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of mining"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/basic/xylix
	name = "enchanting scroll of xylix's grace"
	desc = "A scroll imbued with an enchantment of luck. Grants luck to its wearer."
	component = /datum/magic_item/mundane/xylix

/obj/item/enchantmentscroll/basic/xylix/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of xylixs grace"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/basic/revealinglight
	name = "enchanting scroll of revealing light"
	desc = "A scroll imbued with an enchantment of revealing light. Causes an enchanted item to glow with light."
	component = /datum/magic_item/mundane/revealinglight

/obj/item/enchantmentscroll/basic/revealinglight/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of revealing light"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/basic/holding
	name = "enchanting scroll of storage"
	desc = "A scroll imbued with an enchantment of storage. Doubles the storage space of a container."
	component = /datum/magic_item/mundane/holding
	w_class = WEIGHT_CLASS_HUGE

/obj/item/enchantmentscroll/basic/holding/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/storage))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of storage"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/basic/magnifiedlight
	name = "enchanting scroll of magnified light"
	desc = "A scroll imbued with an enchantment of magnified light. Doubles the range of lightsources."
	component = /datum/magic_item/mundane/magnifiedlight

/obj/item/enchantmentscroll/basic/magnifiedlight/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/flashlight/flare/torch))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of magnified light"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

//T2 Enchantments below

/obj/item/enchantmentscroll/superior/nightvision
	name = "enchanting scroll of darkvision"
	desc = "A scroll imbued with an enchantment of darkvision. Good for seeing in the dark."
	component = /datum/magic_item/superior/nightvision

/obj/item/enchantmentscroll/superior/nightvision/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of darkvision"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/superior/unbreaking
	name = "enchanting scroll of unbreaking"
	desc = "A scroll imbued with an enchantment of unbreakingt. Causes an enchanted item to be able to take more punishment.."
	component = /datum/magic_item/superior/unbreaking

/obj/item/enchantmentscroll/superior/unbreaking/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of unbreaking"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/superior/featherstep
	name = "enchanting scroll of featherstep"
	desc = "A scroll imbued with an enchantment of featherstep. Makes you speedier, and makes your footfalls silent."
	component = /datum/magic_item/superior/featherstep

/obj/item/enchantmentscroll/superior/featherstep/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/shoes)||istype(O,/obj/item/clothing/ring))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of featherstep"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/superior/fireresist
	name = "enchanting scroll of fire resistance"
	desc = "A scroll imbued with an enchantment of fire resistance. Prevents you from catching fire."
	component = /datum/magic_item/superior/fireresist

/obj/item/enchantmentscroll/superior/fireresist/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of fire resistance"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/superior/climbing
	name = "enchanting scroll of spider-climbing"
	desc = "A scroll imbued with an enchantment of spider-climbing. Helps you clamber up difficult surfaces."
	component = /datum/magic_item/superior/climbing

/obj/item/enchantmentscroll/superior/climbing/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of spider-climbing"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/superior/thievery
	name = "enchanting scroll of nimble fingers"
	desc = "A scroll imbued with an enchantment of thievery. Helps you steal and pick locks."
	component = /datum/magic_item/superior/thievery

/obj/item/enchantmentscroll/superior/thievery/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/gloves)||istype(O,/obj/item/clothing/ring))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of nimble fingers"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/superior/smithing
	name = "enchanting scroll of smithing"
	desc = "A scroll imbued with an enchantment of smithing. Provides more effective hammer strikes on anvils."
	component = /datum/magic_item/superior/smithing

/obj/item/enchantmentscroll/superior/smithing/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon/hammer))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of smithing"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))
//T3 Enchantments below

/obj/item/enchantmentscroll/greater/lifesteal
	name = "enchanting scroll of lyfestealing"
	desc = "A scroll imbued with an enchantment of lyfe stealing. Heals you occasionally when you hit a living foe."
	component = /datum/magic_item/greater/lifesteal

/obj/item/enchantmentscroll/greater/lifesteal/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of lyfestealing"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/greater/lightning
	name = "enchanting scroll of lightning"
	desc = "A scroll imbued with an enchantment of lightning. This enchantment shocks foes with a chance to spread to nearby friends and foes alike."
	component = /datum/magic_item/greater/lightning

/obj/item/enchantmentscroll/greater/lightning/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of lightning"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/greater/voidtouched
	name = "enchanting scroll of voidtouched"
	desc = "A scroll imbued with an enchantment of voidtouched. This enchantment pulls foes briefly into the void, and spits them out nearby."
	component = /datum/magic_item/greater/void

/obj/item/enchantmentscroll/greater/voidtouched/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of voidtouched"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/greater/frostveil
	name = "enchanting scroll of lesser freezing"
	desc = "A scroll imbued with an enchantment of lesser freezing. Slows enemies that hit you when applied on armor, or enemies that you hit when applied on weapons."
	component = /datum/magic_item/greater/frostveil

/obj/item/enchantmentscroll/greater/frostveil/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of lesser freezing"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))
/obj/item/enchantmentscroll/greater/phoenixguard
	name = "enchanting scroll of phoenix guard"
	desc = "A scroll imbued with an enchantment of phoenixguard. Sets those that strike you on fire."
	component = /datum/magic_item/greater/phoenixguard

/obj/item/enchantmentscroll/greater/phoenixguard/attack_obj(obj/item/O, mob/living/user)
	.=..()
	if(istype(O,/obj/item/clothing))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of phoenix guard"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/greater/woundclosing
	name = "enchanting scroll of wound closure"
	desc = "A scroll imbued with an enchantment of wound closure. Allows you to periodically seal wounds."
	component = /datum/magic_item/greater/woundclosing

/obj/item/enchantmentscroll/greater/woundclosing/attack_obj(obj/item/O, mob/living/user)
	.=..()
	if(istype(O,/obj/item/clothing/ring))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of wound closure"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/greater/returningweapon
	name = "enchanting scroll of returning weapon"
	desc = "A scroll imbued with an enchantment of returning weapon. Enables you to summon an existing weapon back to you."
	component = /datum/magic_item/greater/returningweapon

/obj/item/enchantmentscroll/greater/returningweapon/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/ring)||istype(O,/obj/item/clothing/gloves))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of returning weapon"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/greater/archery
	name = "enchanting scroll of archery"
	desc = "A scroll imbued with an enchantment of archery. Provides the wearer with better archery skill."
	component = /datum/magic_item/greater/archery

/obj/item/enchantmentscroll/greater/archery/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/clothing/ring)||istype(O,/obj/item/clothing/gloves)|| istype(O, /obj/item/clothing/wrists/roguetown/bracers))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of archery"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

//T4 below here

/obj/item/enchantmentscroll/mythic/infernalflame
	name = "enchanting scroll of infernalflame"
	desc = "A scroll imbued with an enchantment of infernalflame. Hitting an opponent sets them on fire."
	component = /datum/magic_item/mythic/infernalflame

/obj/item/enchantmentscroll/mythic/infernalflame/attack_obj(obj/item/O, mob/living/user)
	.=..()
	if(istype(O,/obj/item/gun/ballistic/revolver/grenadelauncher)|| istype(O,/obj/item/rogueweapon)|| istype(O,/obj/item/clothing))	//bow and crossbows included
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of infernal flame"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/mythic/freeze
	name = "enchanting scroll of greater freezing"
	desc = "A scroll imbued with an enchantment of greater freezing. Heavily slows enemies with an intense chill."
	component = /datum/magic_item/mythic/freezing

/obj/item/enchantmentscroll/mythic/freeze/attack_obj(obj/item/O, mob/living/user)
	.=..()
	if(istype(O,/obj/item/gun/ballistic/revolver/grenadelauncher)||istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))//bow and crossbows included
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of greater freezing"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/mythic/rewind
	name = "enchanting scroll of temporal rewind"
	desc = "A scroll imbued with an enchantment of temporal. Teleports you back to where you were hit, a few seconds after being hit."
	component = /datum/magic_item/mythic/rewind

/obj/item/enchantmentscroll/mythic/rewind/attack_obj(obj/item/O, mob/living/user)
	.=..()
	if(istype(O,/obj/item/clothing)|| istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of temporal rewind"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/mythic/briars
	name = "enchanting scroll of briar's curse"
	desc = "A scroll imbued with an enchantment of briar's curse. A weapon with this enchantment does more damage, but damages its wielder in return."
	component = /datum/magic_item/mythic/briarcurse

/obj/item/enchantmentscroll/mythic/briars/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of briar's curse"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))

/obj/item/enchantmentscroll/mythic/chaos_storm
	name = "enchanting scroll of chaos storm"
	desc = "A scroll imbued with an enchantment of chaos. A weapon with this enchantment causes random effects."
	component = /datum/magic_item/mythic/chaos_storm

/obj/item/enchantmentscroll/mythic/chaos_storm/attack_obj(obj/item/O, mob/living/user)
	if(!..())
		return
	if(istype(O,/obj/item/rogueweapon))
		to_chat(user, span_notice("You open [src] and place [O] within. Moments later, it flashes blue with arcana, and [src] crumbles to dust."))
		var/magiceffect= new component
		O.AddComponent(/datum/component/magic_item, magiceffect)
		O.name += " of chaos storm"
		qdel(src)
	else
		to_chat(user, span_notice("Nothing happens. Perhaps you can't enchant [O] with this?"))
