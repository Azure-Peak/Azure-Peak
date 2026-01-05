/obj/item/reagent_containers/glass/cup
	name = "metal cup"
	desc = "A sturdy cup of metal. Often seen in the hands of warriors, wardens, and other sturdy folk."
	icon = 'modular/Neu_Food/icons/cookware/cup.dmi'
	icon_state = "iron"
	force = 5
	lefthand_file = 'modular/Neu_Food/icons/food_lefthand.dmi'
	righthand_file = 'modular/Neu_Food/icons/food_righthand.dmi'
	experimental_inhand = FALSE
	throwforce = 10
	reagent_flags = OPENCONTAINER
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	experimental_inhand = FALSE
	volume = 25
	obj_flags = CAN_BE_HIT
	sellprice = 1
	drinksounds = list('sound/items/drink_cup (1).ogg','sound/items/drink_cup (2).ogg','sound/items/drink_cup (3).ogg','sound/items/drink_cup (4).ogg','sound/items/drink_cup (5).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	anvilrepair = /datum/skill/craft/blacksmithing
	var/rolling = FALSE
	var/max_dice = 6
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/update_icon(dont_fill=FALSE)


	cut_overlays()

	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]filling")

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		add_overlay(filling)
	if(max_dice)
		var/dice_count = 0
		for(var/obj/item/dice/D in contents)
			dice_count++
		if(dice_count)
			dice_count = min(3, dice_count)
		add_overlay(mutable_appearance(icon, "[icon_state]dice[dice_count]"))

/obj/item/reagent_containers/glass/cup/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/dice) && max_dice)
		if(reagents && reagents.total_volume)
			to_chat(user, span_warning("[src] is full of liquid! You can’t fit dice in there."))
			return TRUE

		if(length(contents) >= max_dice)
			to_chat(user, span_warning("[src] can’t hold more than [max_dice] dice."))
			return TRUE

		I.forceMove(src)
		user.visible_message(
			span_notice("[user] drops [I] into [src]."),
			span_notice("I drop [I] into [src].")
		)
		update_icon()
		return TRUE
	. = ..()

/obj/item/reagent_containers/glass/cup/attack_self(mob/user)
	if(!max_dice)
		return
	if(rolling)
		return
	if(!contents)
		return
	var/list/dice_in_cup = list()
	for(var/obj/item/dice/D in contents)
		dice_in_cup += D

	if(!dice_in_cup.len)
		return
	
	playsound(src, 'sound/items/cup_dice_roll.ogg', 100, TRUE)
	if(do_after(user, 1.5 SECONDS))
		rolling = TRUE
		user.visible_message(
			span_notice("[user] shakes [src], rolling all the dice inside!"),
			span_notice("I shake [src] and roll the dice inside!")
		)

		var/turf/target_turf = get_step(user.loc, user.dir)
		if(!target_turf)
			target_turf = get_turf(user)

		for(var/obj/item/dice/D in dice_in_cup)
			D.forceMove(get_turf(user))
			D.throw_at(target_turf, 1, 2, user)

		rolling = FALSE
		update_icon()

/obj/item/reagent_containers/glass/cup/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return ..()

	if(istype(target, /obj/item/dice) && max_dice)
		if(reagents && reagents.total_volume)
			to_chat(user, span_warning("[src] is full of liquid! You can’t scoop dice into it."))
			return

		var/turf/T = get_turf(target)
		var/list/scooped = list()
		for(var/obj/item/dice/D in T)
			if(length(contents) >= max_dice)
				break
			D.forceMove(src)
			scooped += D

		if(scooped.len)
			user.visible_message(
				span_notice("[user] scoops up [english_list(scooped)] with [src]."),
				span_notice("I scoop up [english_list(scooped)] with [src].")
			)
		update_icon()
		return TRUE

	return ..()

/obj/item/reagent_containers/glass/cup/examine()
	. = ..()
	if (max_dice)
		var/dice_count = 0
		for(var/obj/item/dice/D in contents)
			dice_count++
		if(dice_count)
			. += span_info("There [dice_count > 1 ? "are" : "is"] [dice_count] [dice_count > 1 ? "dice" : "die"] inside the cup.")

/obj/item/reagent_containers/glass/cup/onfill(obj/target, mob/user, silent = FALSE)
	..()
	if(max_dice && contents)
		for(var/obj/item/dice/D in contents)
			user.visible_message(
				span_notice("[user] accidentally spills [D] from [src] while filling it!"),
				span_notice("I accidentally spill [D] from [src] while filling it!")
			)
			D.forceMove(get_turf(user))
			update_icon()


/obj/item/reagent_containers/glass/cup/wooden
	name = "wooden cup"
	desc = "This cup whispers tales of drunken battles and feasts."
	resistance_flags = FLAMMABLE
	icon_state = "wooden"
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	anvilrepair = null
	sellprice = 0
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/steel
	name = "goblet"
	desc = "A steel goblet, its surface adorned with intricate carvings."
	icon_state = "steel"
	sellprice = 10
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/cup/aalloymug
	name = "decrepit mug"
	desc = "Frayed bronze, coiled into a cup. Here, adventurers of centuries-past would laugh and legendize; but now, nothing but empty chairs and empty tables remain."
	color = "#bb9696"
	icon_state = "amug"
	sellprice = 5
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/aalloygob
	name = "decrepit goblet"
	desc = "Frayed bronze, coiled into a hooked vessel. To think that this was once a nobleman's goblet; yet, it has endured far longer than their now-withered bloodline."
	color = "#bb9696"
	icon_state = "agoblet"
	sellprice = 10
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/cup/silver
	name = "silver goblet"
	desc = "A silver goblet, its surface adorned with intricate carvings and runes."
	icon_state = "silver"
	sellprice = 30
	last_used = 0
	is_silver = TRUE
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/cup/silver/pewter //ugly but better than the alternatives
	name = "pewter goblet"
	desc = "A pewter goblet, cheaper than silver, but with a similar shine!"
	is_silver = FALSE

/obj/item/reagent_containers/glass/cup/silver/small
	name = "silver cup"
	desc = "A silver cup, its surface adorned with intricate carvings and runes."
	icon_state = "scup"
	sellprice = 20
	is_silver = TRUE
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/golden
	name = "golden goblet"
	desc = "Adorned with gemstones, this goblet radiates opulence and grandeur."
	icon_state = "golden"
	sellprice = 50
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/cup/golden/small
	name = "golden cup"
	desc = "Adorned with gemstones, this cup radiates opulence and grandeur."
	icon_state = "gcup"
	sellprice = 40
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/golden/poison
	name = "golden goblet"
	desc = "Adorned with gemstones, this goblet radiates opulence and grandeur."
	icon_state = "golden"
	sellprice = 50
	list_reagents = list(/datum/reagent/toxin/killersice = 1, /datum/reagent/consumable/ethanol/elfred = 20)
	force = 10
	throwforce = 15

/obj/item/reagent_containers/glass/cup/skull
	name = "skull goblet"
	desc = "The hollow eye sockets tell me of forgotten, dark rituals."
	icon_state = "skull"
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/ceramic
	name = "teacup"
	desc = "A tea cup made out of ceramic. Used to serve tea."
	dropshrink = 0.7
	icon_state = "cup"
	sellprice = 10
	force = 5
	throwforce = 10

/obj/item/reagent_containers/glass/cup/ceramic/examine()
	. = ..()
	. += span_info("It can be brushed with a dye brush to glaze it.")

/obj/item/reagent_containers/glass/cup/ceramic/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(istype(I, /obj/item/dye_brush))
		if(reagents.total_volume)
			to_chat(user, span_notice("I can't glaze the cup while it has liquid in it."))
			return
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("I glaze the cup with the dye brush."))
			new /obj/item/reagent_containers/glass/cup/ceramic/fancy(get_turf(src))
			qdel(src)
		return

/obj/item/reagent_containers/glass/cup/ceramic/fancy
	name = "fancy teacup"
	desc = "A fancy tea cup made out of ceramic. Used to serve tea."
	icon_state = "cup_fancy"
	sellprice = 12
	force = 5
	throwforce = 10
