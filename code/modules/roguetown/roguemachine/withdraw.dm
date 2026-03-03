/obj/structure/roguemachine/withdraw
	name = "vomitorium"
	desc = "A magitech wall device connected to the local trade network. Users can buy basic goods, crafting materials, and food for a price from these units, either from in-town or imported for a heftier price."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "submit"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/stockpile_index = 1
	var/datum/withdraw_tab/withdraw_tab = null

/obj/structure/roguemachine/withdraw/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with an open hand to check the vomitorium's stockpile. Stored mammons can be used to purchase a wide variety of materials, which're then vended out for use.")
	. += span_info("Left-clicking the machine with an item will load it into the stockpile, rewarding you coinage in turn. Make sure to register an account with the MEISTER, first, or you won't receive any coinage.")
	. += span_info("Right-clicking the machine will automatically load all adjacent items into the stockpile at once.")
	. += span_info("The vomitorium's stockpile naturally refills over time. Loaded items are added to the stockpile's quantities, which can then be vended by others or exported by the Steward for profit.")
	. += span_info("The vomitorium can also accept treasures, gemstones, and many other valuables that're particularly expensive; a portion of it is always taxed and returned to the Steward's treasury.")

/obj/structure/roguemachine/withdraw/Initialize()
	. = ..()
	SSroguemachine.stock_machines += src
	withdraw_tab = new(stockpile_index, src)

/obj/structure/roguemachine/withdraw/Destroy()
	SSroguemachine.stock_machines -= src
	return ..()

/obj/structure/roguemachine/withdraw/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin/aalloy))
		return

	if(istype(P, /obj/item/roguecoin/inqcoin))	
		return

	if(istype(P, /obj/item/roguecoin))
		withdraw_tab.insert_coins(P)
		return attack_hand(user)
	..()

/obj/structure/roguemachine/withdraw/Topic(href, href_list)
	. = ..()
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(withdraw_tab.perform_action(href, href_list))
		if(href_list["withdraw"])
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			flick("submit_anim",src)
		return attack_hand(usr, "withdraw")
	return attack_hand(usr)

/obj/structure/roguemachine/withdraw/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	var/contents = withdraw_tab.get_contents("VOMITORIUM", FALSE)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 800)
	popup.set_content(contents)
	popup.open()
