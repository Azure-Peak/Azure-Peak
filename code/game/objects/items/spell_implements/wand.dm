/obj/item/rogueweapon/wand
	base_implement_name = "lesser wand"
	name = "lesser wand"
	desc = "A slender implement of carved wood tipped with a focus-gem. The gem captures excess energy dissipated into the air when a spell is cast, giving a fraction of it back to the wielder. Light enough to wield alongside a shield."
	icon = 'icons/obj/items/wands.dmi'
	icon_state = "wand_lesser"
	lefthand_file = 'icons/obj/items/wands.dmi'
	righthand_file = 'icons/obj/items/wands.dmi'
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK_R
	sharpness = IS_BLUNT
	can_parry = FALSE
	wlength = WLENGTH_SHORT
	wdefense = 1
	max_integrity = 80
	resistance_flags = FIRE_PROOF
	associated_skill = /datum/skill/magic/arcane
	possible_item_intents = list(SPEAR_BASH)
	sellprice = 34
	implement_tier = IMPLEMENT_TIER_LESSER
	implement_refund = IMPLEMENT_REFUND_LESSER

/obj/item/rogueweapon/wand/greater
	base_implement_name = "greater wand"
	name = "greater wand"
	desc = "A well-crafted wand set with a quality focus-gem. The gem captures excess energy dissipated into the air when a spell is cast, giving a generous share of it back to the wielder."
	icon_state = "wand_greater"
	max_integrity = 100
	sellprice = 42
	implement_tier = IMPLEMENT_TIER_GREATER
	implement_refund = IMPLEMENT_REFUND_GREATER

/obj/item/rogueweapon/wand/grand
	base_implement_name = "grand wand"
	name = "grand wand"
	desc = "A masterwork wand crowned with a gem of extraordinary quality. The gem captures excess energy dissipated into the air when a spell is cast, giving most of it back to the wielder - arcyne economy refined to an art."
	icon_state = "wand_grand"
	max_integrity = 120
	sellprice = 121
	implement_tier = IMPLEMENT_TIER_GRAND
	implement_refund = IMPLEMENT_REFUND_GRAND

/obj/item/rogueweapon/wand/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = 0,"nx" = 11,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/wand/examine(mob/user)
	. = ..()
	if(implement_refund)
		. += span_notice("When held while casting, this implement leaves behind Residual Focus, returning [round(implement_refund * 100)]% of the spell's resource cost as energy over 20 seconds.")

