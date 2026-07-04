/* Spellbook
Intended to be a reward or a goal for pure mage, allowing them to rebind their aspect spells.
*/

/obj/item/rogueweapon/spellbook
	base_implement_name = "lesser tome"
	var/open = FALSE
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "spellbookbrown_0"
	slot_flags = ITEM_SLOT_HIP
	grid_width = 32
	grid_height = 32
	var/base_icon_state = "spellbookbrown"
	var/unique = TRUE
	firefuel = 2 MINUTES
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	force = 20
	throwforce = 10
	w_class = WEIGHT_CLASS_SMALL
	sharpness = IS_BLUNT
	can_parry = FALSE
	wlength = WLENGTH_SHORT
	wdefense = 1
	max_integrity = 200
	integrity_failure = 0.3
	sewrepair = TRUE
	anvilrepair = null
	associated_skill = /datum/skill/combat/arcyne
	possible_item_intents = list(/datum/intent/mace/strike/wood, /datum/intent/tome/aegis)
	name = "\improper lesser tome of the arcyne"
	desc = "A crackling, glowing book, filled with runes and symbols that hurt the mind to stare at. It can rebind aspect spells and project an arcyne aegis."
	special = /datum/special_intent/arcyne_descent
	implement_tier = IMPLEMENT_TIER_LESSER
	implement_refund = IMPLEMENT_REFUND_LESSER
	sellprice = 34
	var/picked // if the book has had it's style picked or not
	var/curpage = 1
	var/aegis_energy_cost = 150
	var/aegis_cooldown = 180 SECONDS
	var/aegis_charge_time = 2 SECONDS
	var/obj/item/rogueweapon/shield/arcyne_aegis/tome/conjured_aegis
	COOLDOWN_DECLARE(aegis_cd)
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME | CLAMP_BREAK

/obj/item/rogueweapon/spellbook/greater
	base_implement_name = "greater tome"
	name = "\improper greater tome of the arcyne"
	desc = "A well-bound arcyne tome set with a quality focus-gem. It can rebind aspect spells, project an arcyne aegis, and return a generous share of spent spell energy."
	force = 22
	max_integrity = 100
	sellprice = 42
	implement_tier = IMPLEMENT_TIER_GREATER
	implement_refund = IMPLEMENT_REFUND_GREATER

/obj/item/rogueweapon/spellbook/grand
	base_implement_name = "grand tome"
	name = "\improper grand tome of the arcyne"
	desc = "A masterwork arcyne tome crowned with a gem of extraordinary quality. It can rebind aspect spells, project an arcyne aegis, and refine spent spell energy back to its bearer."
	force = 25
	max_integrity = 120
	sellprice = 121
	implement_tier = IMPLEMENT_TIER_GRAND
	implement_refund = IMPLEMENT_REFUND_GRAND

/obj/item/rogueweapon/spellbook/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/spellbook/examine(mob/user)
	. = ..()
	. += span_notice("Reading it allows you to rebind your aspect spells.")
	if(implement_refund)
		. += span_notice("When held while casting, this implement leaves behind Residual Focus, returning [round(implement_refund * 100)]% of the spell's resource cost as energy over 20 seconds.")
	. += span_notice("With the Arcyne Aegis intent selected, aim anywhere and hold to charge a shield into your offhand, costing [aegis_energy_cost] energy.")

/obj/item/rogueweapon/spellbook/attack_self(mob/living/carbon/human/user)
	if(istype(user) && istype(user.a_intent, /datum/intent/tome/aegis))
		conjure_aegis(user)
		return
	if(!open)
		attack_right(user)
		return
	read(user)
	user.update_inv_hands()

/obj/item/rogueweapon/spellbook/afterattack(atom/target, mob/living/user, proximity_flag, params)
	. = ..()
	if(!istype(user) || !istype(user.used_intent, /datum/intent/tome/aegis))
		return
	conjure_aegis(user)

/obj/item/rogueweapon/spellbook/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/rogueweapon/spellbook/Destroy()
	clear_aegis()
	return ..()

/obj/item/rogueweapon/spellbook/proc/read(mob/user)
	change_spells()
	return FALSE

/obj/item/rogueweapon/spellbook/proc/change_spells(mob/user = usr)
	var/datum/mind/user_mind = user.mind
	if(!user_mind)
		return
	if(!LAZYLEN(user_mind.mage_aspect_config))
		to_chat(user, span_warning("I lack the arcyne training to make use of this."))
		return
	var/datum/aspect_picker/picker = new(user, FALSE, user_mind.mage_aspect_config)
	picker.ui_interact(user)

/obj/item/rogueweapon/spellbook/attack_right(mob/user)
	if(!picked)
		var/list/designlist = list("green", "yellow", "brown", "steel", "gem", "skin", "mimic", "wyrdbark", "sunfire", "abyssal", "cinder", "vessel", "edgebound", "sovereign")
		var/the_time = world.time
		var/design = tgui_input_list(user, "Select a design.","Spellbook Design", designlist)
		if(!design)
			return
		if(world.time > (the_time + 30 SECONDS))
			return
		base_icon_state = "spellbook[design]"
		update_icon()
		picked = TRUE
		switch(design) //super lazy but idrc
			if ("green")
				return
			if ("yellow")
				return
			if ("brown") //preserve default name and desc for the basic options
				return
			if ("steel")
				desc = "A metallic tome adorned with alignments of runes and alchemical symbols. Can be used to unbind spells."
			if ("gem")
				desc = "The pages form a window to the breadth of the stars. Can be used to unbind spells."
			if ("skin")
				desc = "Profane symbols adorn this spellbook- is that blood dripping off the pages? Can be used to unbind spells."
			if ("mimic")
				desc = "This book seems to be reading you, instead. Can be used to unbind spells."
			if ("wyrdbark")
				desc = "Formed of heartwood and fae magics, leaves flutter about when it opens. Can be used to unbind spells."
			if ("sunfire")
				desc = "Astrata's radiance pours freely from this book's enchanted parchment. Can be used to unbind spells."
			if ("abyssal")
				desc = "Frigid and numb to the touch; you feel so much smaller just looking at it. Can be used to unbind spells."
			if ("cinder")
				desc = "Wafting smoke and smoldering crackles come from the papyrus, though it never catches alight. Can be used to unbind spells."
			if ("vessel")
				desc = "A stoppered bottle of ink that forms into a fully-fledged tome when uncorked. Can be used to unbind spells."
				name = "\improper arcyne vessel" //calling it 'vessel tome' is weird as fuck
				return
			if ("edgebound")
				desc = "Harsh, sturdy, and practical; can a war-mage ask for more? Can be used to unbind spells."
			if ("sovereign")
				desc = "Regal and opulent, you feel a stronge urge to call this tome some title of reverence. Can be used to unbind spells."
		name = "\improper [design] tome"
		return
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	curpage = 1
	update_icon()
	user.update_inv_hands()

/obj/item/rogueweapon/spellbook/update_icon()
	icon_state = "[base_icon_state]_[open]"

/obj/item/rogueweapon/spellbook/proc/get_aegis_type()
	switch(implement_tier)
		if(IMPLEMENT_TIER_GREATER)
			return /obj/item/rogueweapon/shield/arcyne_aegis/tome/greater
		if(IMPLEMENT_TIER_GRAND)
			return /obj/item/rogueweapon/shield/arcyne_aegis/tome/grand
	return /obj/item/rogueweapon/shield/arcyne_aegis/tome

/obj/item/rogueweapon/spellbook/proc/can_conjure_aegis(mob/living/carbon/human/user, feedback = FALSE)
	if(!istype(user) || !user.is_holding(src))
		return FALSE
	if(user.get_inactive_held_item())
		if(feedback)
			to_chat(user, span_warning("I need my offhand free to project the Aegis!"))
		return FALSE
	if(!COOLDOWN_FINISHED(src, aegis_cd))
		if(feedback)
			to_chat(user, span_warning("The [src] is still gathering arcyne force. [round(COOLDOWN_TIMELEFT(src, aegis_cd) / 10, 1)] seconds remain."))
		return FALSE
	if(user.energy < aegis_energy_cost)
		if(feedback)
			to_chat(user, span_warning("I need [aegis_energy_cost] arcyne energy to project the Aegis!"))
		return FALSE
	return TRUE

/obj/item/rogueweapon/spellbook/proc/conjure_aegis(mob/living/carbon/human/user)
	if(user.client && user.client.chargedprog < 100)
		return FALSE
	if(!can_conjure_aegis(user, feedback = TRUE))
		return FALSE
	clear_aegis()
	var/aegis_type = get_aegis_type()
	var/obj/item/rogueweapon/shield/arcyne_aegis/tome/S = new aegis_type(user.drop_location())
	S.link_tome(src)
	S.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE, TRUE, user, src)
	if(!user.put_in_hands(S))
		qdel(S)
		to_chat(user, span_warning("I fail to conjure the Aegis in my offhand."))
		return FALSE
	conjured_aegis = S
	user.energy_add(-aegis_energy_cost)
	COOLDOWN_START(src, aegis_cd, aegis_cooldown)
	playsound(user, 'sound/magic/whiteflame.ogg', 80, TRUE)
	user.balloon_alert(user, "<font color = '#9BCCD0'>Aegis!</font>")
	user.visible_message(span_notice("[user] projects a shimmering arcyne shield from [src]!"))
	return TRUE

/obj/item/rogueweapon/spellbook/proc/clear_aegis()
	if(conjured_aegis && !QDELETED(conjured_aegis))
		qdel(conjured_aegis)
	conjured_aegis = null
