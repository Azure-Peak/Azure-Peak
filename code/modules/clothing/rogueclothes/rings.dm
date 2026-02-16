

/obj/item/clothing/ring
	name = "ring"
	desc = ""
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/roguetown/clothing/rings.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/rings.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/rings.dmi'
	sleevetype = "shirt"
	icon_state = ""
	slot_flags = ITEM_SLOT_RING
	resistance_flags = FIRE_PROOF | ACID_PROOF
	anvilrepair = /datum/skill/craft/armorsmithing
	experimental_inhand = FALSE
	drop_sound = 'sound/foley/coinphy (1).ogg'
	salvage_result = null

/obj/item/clothing/ring/aalloy
	name = "decrepit ring"
	desc = "A coil of frayed bronze."
	icon_state = "ring_a"
	sellprice = 11

/obj/item/clothing/ring/bronze
	name = "bronze ring"
	desc = "A ring of bronzen resiliance."
	icon_state = "ring_b"
	sellprice = 22

/obj/item/clothing/ring/silver
	name = "silver ring"
	desc = "A ring of silvered glimmerance."
	icon_state = "ring_s"
	sellprice = 33
	is_silver = FALSE //Temporary measure to prevent people from easily metachecking vampyres. Replace with a more sophisticated alternative if-or-when available.

/obj/item/clothing/ring/gold
	name = "gold ring"
	desc = "A ring of golden beauty."
	icon_state = "ring_g"
	sellprice = 45

/obj/item/clothing/ring/blacksteel
	name = "blacksteel ring"
	icon_state = "ring_bs"
	sellprice = 70

/obj/item/clothing/ring/jade
	name = "jade ring"
	icon_state = "ring_jade"
	sellprice = 60

/obj/item/clothing/ring/coral
	name = "heartstone ring"
	icon_state = "ring_coral"
	sellprice = 70

/obj/item/clothing/ring/onyxa
	name = "onyxa ring"
	icon_state = "ring_onyxa"
	sellprice = 40

/obj/item/clothing/ring/shell
	name = "shell ring"
	icon_state = "ring_shell"
	sellprice = 20

/obj/item/clothing/ring/amber
	name = "amber ring"
	icon_state = "ring_amber"
	sellprice = 20

/obj/item/clothing/ring/turq
	name = "cerulite ring"
	icon_state = "ring_turq"
	sellprice = 85

/obj/item/clothing/ring/rose
	name = "rosestone ring"
	icon_state = "ring_rose"
	sellprice = 25

/obj/item/clothing/ring/opal
	name = "opal ring"
	icon_state = "ring_opal"
	sellprice = 90

/obj/item/clothing/ring/active
	var/active = FALSE
	desc = "A golden ring that bares a runic enigma, capable of nullifying all incoming magicka. The runic enigma pulsates with crimson light, rendering me invulnerable to arcynic violence!"
	var/cooldowny
	var/cdtime
	var/activetime
	var/activate_sound

/obj/item/clothing/ring/active/attack_right(mob/user)
	if(loc != user)
		return
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, span_warning("Nothing happens."))
			return
	user.visible_message(span_warning("[user] twists the [src]!"))
	if(activate_sound)
		playsound(user, activate_sound, 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src, PROC_REF(demagicify)), activetime)
	active = TRUE
	update_icon()
	activate(user)

/obj/item/clothing/ring/active/proc/activate(mob/user)
	user.update_inv_wear_id()

/obj/item/clothing/ring/active/proc/demagicify()
	active = FALSE
	update_icon()
	if(ismob(loc))
		var/mob/user = loc
		user.visible_message(span_warning("The ring settles down."))
		user.update_inv_wear_id()


/obj/item/clothing/ring/active/nomag
	name = "ring of null magic"
	icon_state = "ruby"
	desc = "A golden ring that bares a runic enigma, capable of nullifying all incoming magicka. Unfortuantely, like with most magic rings, its powers can only be used sparingly."
	activate_sound = 'sound/magic/antimagic.ogg'
	cdtime = 10 MINUTES
	activetime = 30 SECONDS
	sellprice = 100

/obj/item/clothing/ring/active/nomag/update_icon()
	..()
	if(active)
		icon_state = "rubyactive"
	else
		icon_state = "ruby"

/obj/item/clothing/ring/active/nomag/activate(mob/user)
	. = ..()
	AddComponent(/datum/component/anti_magic, TRUE, FALSE, FALSE, ITEM_SLOT_RING, INFINITY, FALSE)

/obj/item/clothing/ring/active/nomag/demagicify()
	. = ..()
	var/datum/component/magcom = GetComponent(/datum/component/anti_magic)
	if(magcom)
		magcom.ClearFromParent()

/obj/item/clothing/ring/active/nomag/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Right click to activate the ring's ward, which provides temporary invulnerability against all direct magical attacks for thirty seconds.")
    . += span_info("Wearers with unholy ailments are also rendered invulnerable to being sundered by silver weaponry, for the ward's duration.")
    . += span_info("Once the ring's ward is exhausted, it'll require ten minutes to recharge enough power for another activation.")

//gold rings
/obj/item/clothing/ring/emerald
	name = "gemerald ring"
	icon_state = "g_ring_emerald"
	desc = "A beautiful golden ring with a polished gemerald set into it."
	smeltresult = /obj/item/roguegem/green
	sellprice = 195

/obj/item/clothing/ring/ruby
	name = "rontz ring"
	icon_state = "g_ring_ruby"
	desc = "A beautiful golden ring with a polished rontz set into it."
	smeltresult = /obj/item/roguegem/ruby
	sellprice = 255

/obj/item/clothing/ring/topaz
	name = "toper ring"
	icon_state = "g_ring_topaz"
	desc = "A beautiful golden ring with a polished toper set into it."
	smeltresult = /obj/item/roguegem/yellow
	sellprice = 180

/obj/item/clothing/ring/quartz
	name = "blortz ring"
	icon_state = "g_ring_quartz"
	desc = "A beautiful golden ring with a polished blortz set into it."
	smeltresult = /obj/item/roguegem/blue
	sellprice = 245

/obj/item/clothing/ring/sapphire
	name = "saffira ring"
	icon_state = "g_ring_sapphire"
	desc = "A beautiful golden ring with a polished saffira set into it."
	smeltresult = /obj/item/roguegem/violet
	sellprice = 200

/obj/item/clothing/ring/diamond
	name = "dorpel ring"
	icon_state = "g_ring_diamond"
	desc = "A beautiful golden ring with a polished dorpel set into it."
	smeltresult = /obj/item/roguegem/diamond
	sellprice = 270

/obj/item/clothing/ring/signet
	name = "signet ring"
	icon_state = "signet"
	desc = "A ring of opulent gold, bearing the Lord's symbol. By dipping it in melted redtallow, it can seal writs of ducal importance."
	sellprice = 135
	var/tallowed = FALSE

/obj/item/clothing/ring/signet/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Left click the ring on a warmed tallowpot - filled with redtallow, specifically - to prepare a stamp.")
    . += span_info("Certain letters can be folded and stamped with a prepared ring, which proves minor financial benefits.")

/obj/item/clothing/ring/signet/silver
	name = "silver signet ring"
	icon_state = "signet_silver"
	desc = "A ring of blessed silver, bearing the Archbishop's symbol. By dipping it in melted redtallow, it can seal writs of religious importance."
	sellprice = 90
	is_silver = FALSE //Temporary measure to prevent people from easily metachecking vampyres. Replace with a more sophisticated alternative if-or-when available.

/obj/item/clothing/ring/signet/silver/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Stamping a folded ACCUSATION or CONFESSION will increase the amount of MARQUES it'll reward, once sent through the HERMES.")
    . += span_info("Packing an INDEXER into an ACCUSATION or CONFESSION before folding-and-stamping it will further amplify this financial bonus.")

/obj/item/clothing/ring/signet/attack_right(mob/user)
	. = ..()
	if(tallowed)
		if(alert(user, "SCRAPE THE TALLOW OFF?", "SIGNET RING", "YES", "NO") != "NO")
			tallowed = FALSE
			update_icon()

/obj/item/clothing/ring/signet/update_icon()
	. = ..()
	if(tallowed)
		icon_state = "[icon_state]_stamp"
	else
		icon_state = initial(icon_state)

//silver rings
/obj/item/clothing/ring/emeralds
	name = "silver gemerald ring"
	desc = "A glimmering silver ring with a polished gemerald set into it."
	icon_state = "s_ring_emerald"
	smeltresult = /obj/item/roguegem/green
	sellprice = 155
	is_silver = FALSE //Temporary measure to prevent people from easily metachecking vampyres. Replace with a more sophisticated alternative if-or-when available.

/obj/item/clothing/ring/rubys
	name = "silver rontz ring"
	desc = "A glimmering silver ring with a polished rontz set into it."
	icon_state = "s_ring_ruby"
	smeltresult = /obj/item/roguegem/ruby
	sellprice = 215
	is_silver = FALSE //Ditto.

/obj/item/clothing/ring/topazs
	name = "toper ring"
	desc = "A glimmering silver ring with a polished toper set into it."
	icon_state = "s_ring_topaz"
	smeltresult = /obj/item/roguegem/yellow
	sellprice = 140
	is_silver = FALSE

/obj/item/clothing/ring/quartzs
	name = "silver blortz ring"
	desc = "A glimmering silver ring with a polished blortz set into it."
	icon_state = "s_ring_quartz"
	smeltresult = /obj/item/roguegem/blue
	sellprice = 205
	is_silver = FALSE

/obj/item/clothing/ring/sapphires
	name = "silver saffira ring"
	desc = "A glimmering silver ring with a polished saffira set into it."
	icon_state = "s_ring_sapphire"
	smeltresult = /obj/item/roguegem/violet
	sellprice = 160
	is_silver = FALSE

/obj/item/clothing/ring/diamonds
	name = "silver dorpel ring"
	desc = "A glimmering silver ring with a polished dorpel set into it."
	icon_state = "s_ring_diamond"
	smeltresult = /obj/item/roguegem/diamond
	sellprice = 230
	is_silver = FALSE

/obj/item/clothing/ring/duelist
	name = "duelist's ring"
	desc = "Born out of duelists desire for theatrics, this ring denotes a proposal — an honorable duel, with stakes set ahigh.\nIf both duelists wear this ring, successful baits will off balance them, and clashing disarms will never be unlikely.\n<i>'You shall know his name. You shall know his purpose. You shall die.'</i>"
	icon_state = "ring_duel"
	sellprice = 10

/obj/item/clothing/ring/fate_weaver
	name = "fate weaver"
	desc = "An arcyne creation first theorized by malcontents with the resolution of Xylix's plays. It protects it's wearer by tugging things gently toward less fatal potentials."
	icon_state = "ring_s"
	max_integrity = 50
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET | COVERAGE_HEAD_NOSE | NECK | HANDS | FEET //field covers the whole body
	armor = ARMOR_FATEWEAVER //even protection against most damage types
	blade_dulling = DULLING_BASHCHOP
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	armor_class = ARMOR_CLASS_LIGHT
	unenchantable = TRUE

/obj/item/clothing/ring/fate_weaver/proc/dispel()
	if(!QDELETED(src))
		src.visible_message(span_warning("The [src]'s borders begin to shimmer and fade, before it vanishes entirely!"))
		qdel(src)

/obj/item/clothing/ring/fate_weaver/obj_break()
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/ring/fate_weaver/attack_hand(mob/user)
	. = ..()
	if(!QDELETED(src))
		dispel()

/obj/item/clothing/ring/fate_weaver/dropped()
	. = ..()
	if(!QDELETED(src))
		dispel()

/////////////////////////
// Wedding Rings/Bands //
/////////////////////////

// These are meant to not be smelted down for anything or sell for much. Loadout items for roleplay, kinda simple.
// Also, can rename their name/desc to put parnters name in it and stuff. Some customization. TODO: allow sprite selection between 2-3 types of wedding band sprites.
/obj/item/clothing/ring/band
	name = "silver weddingband"
	desc = "A simple silver wedding band complete with an ornate design of a lover's name."
	icon_state = "s_ring_wedding"
	sellprice = 3	//You don't get to smelt this down or sell it. No free mams for a loadout item.
	var/choicename = FALSE
	var/choicedesc = FALSE
	is_silver = FALSE //Love wins.

/obj/item/clothing/ring/band/attack_right(mob/user)
	if(choicename)
		return
	if(choicedesc)
		return
	var/current_time = world.time
	var/namechoice = input(user, "Input a new name", "Rename Object")
	var/descchoice = input(user, "Input a new description", "Describe Object")
	if(namechoice)
		name = namechoice
		choicename = TRUE
	if(descchoice)
		desc = descchoice
		choicedesc = TRUE
	else
		return
	if(world.time > (current_time + 30 SECONDS))
		return

/////////////////////////
// Blacksteel Rings    //
/////////////////////////

/obj/item/clothing/ring/emeraldbs
	name = "gemerald ring"
	icon_state = "bs_ring_emerald"
	desc = "A beautiful golden ring with a polished Gemerald set into it."
	sellprice = 295

/obj/item/clothing/ring/rubybs
	name = "rontz ring"
	icon_state = "bs_ring_ruby"
	desc = "A beautiful golden ring with a polished Rontz set into it."
	sellprice = 355

/obj/item/clothing/ring/topazbs
	name = "toper ring"
	icon_state = "bs_ring_topaz"
	desc = "A beautiful golden ring with a polished Toper set into it."
	sellprice = 380

/obj/item/clothing/ring/quartzbs
	name = "blortz ring"
	icon_state = "bs_ring_quartz"
	desc = "A beautiful golden ring with a polished Blortz set into it."
	sellprice = 345

/obj/item/clothing/ring/sapphirebs
	name = "saffira ring"
	icon_state = "bs_ring_sapphire"
	desc = "A beautiful golden ring with a polished Saffira set into it."
	sellprice = 300

/obj/item/clothing/ring/diamondbs
	name = "dorpel ring"
	icon_state = "bs_ring_diamond"
	desc = "A beautiful golden ring with a polished Dorpel set into it."
	sellprice = 370

////////////////////////
// Triumph Exclusive! //
////////////////////////

//Purchasable via Triumphs. Blacklisted from the Stockpile and fitted with a reduced saleprice.
/obj/item/clothing/ring/diamond/triumph
	name = "ornate dorpel ring"
	icon_state = "g_newring_diamond"
	desc = "A ring of royal splendor, crested with a magnificently-cut dorpel. Its prismesque reflections remind you of a dream, from long ago; a ship, sailing across a sea of rainbowed phlogiston, to a castle far beyond the clouds.."
	sellprice = 99
	smeltresult = /obj/item/clothing/ring/signet/triumph

/obj/item/clothing/ring/signet/triumph
	name = "ornate signet ring"
	desc = "A ring of opulent gold, bearing the symbol of an aristocratic household. By dipping it in melted redtallow, it can seal writs of religious importance - a matter better known to the Inquisition, rather than the Church or Crown."
	sellprice = 77 

/obj/item/clothing/ring/gold/triumph
	name = "ornate gold ring"
	desc = "A ring of golden beauty, who's story could only be retold by a lonesome tongue."
	sellprice = 33

/////////////////////////
// Stat-Boosting Rings //
/////////////////////////

//Anything above +1 that bestows positive traits or has no downsides should be restricted to higher-tier dungeons and loot pools.
//Anything below that - either a +1, or anything that comes with a negative trait or malus - should be acceptable for lower-tier dungeons and loot pools.
//These rings shouldn't be craftable under any circumstance, unless it involves combining multiple rings or rare components. Don't add recipes unless you absolutely know what you're doing.

/obj/item/clothing/ring/statgemerald
	name = "ring of swiftness"
	desc = "A gemerald ring, glimmering with verdant brilliance. The closer your hand drifts to it, the stronger that the wind howls."
	icon_state = "g_newring_emerald"
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statgemerald/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_green("'..the way of lyfe, bountiful but fleeting..'"))
		user.change_stat(STATKEY_SPD, 1)
		user.change_stat(STATKEY_LCK, 1)
	return

/obj/item/clothing/ring/statgemerald/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_green("'..but without an end to the journey, what would become of lyfe's meaning?'"))
		user.change_stat(STATKEY_SPD, -1)
		user.change_stat(STATKEY_LCK, -1)
		active_item = FALSE
	return

/obj/item/clothing/ring/statonyx
	name = "ring of vitality"
	desc = "An onyx ring, shining with violet determination. The closer your hand drifts to it, the faster your heart pounds."
	icon_state = "g_newring_quartz"
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statonyx/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_purple("'..the way of blood, shed from you in vain..'"))
		user.change_stat(STATKEY_CON, 1)
		user.change_stat(STATKEY_WIL, 1)
	return

/obj/item/clothing/ring/statonyx/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_purple("'..but if you don't stand for those who cannot, who will?'"))
		user.change_stat(STATKEY_CON, -1)
		user.change_stat(STATKEY_WIL, -1)
		active_item = FALSE
	return

/obj/item/clothing/ring/statamythortz
	name = "ring of wisdom"
	desc = "A saffira ring, crackling with azuric fascination. The closer your hand drifts to it, the clearer your mind becomes."
	icon_state = "g_newring_sapphire"
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statamythortz/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_rose("'..the way of knowledge, cursing its pursuers with inzanity..'"))
		user.change_stat(STATKEY_INT, 1)
		user.change_stat(STATKEY_PER, 1)
	return

/obj/item/clothing/ring/statamythortz/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_rose("'..but if we root ourselves in the thoughtless, how else will we progress?'"))
		user.change_stat(STATKEY_INT, -1)
		user.change_stat(STATKEY_PER, -1)
		active_item = FALSE
	return

/obj/item/clothing/ring/statrontz
	name = "ring of courage"
	desc = "A rontz ring, radiating with crimson authority. The closer your hand drifts to it, the tighter your knuckles curl."
	icon_state = "g_newring_ruby"
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statrontz/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_red("'..the way of death, indiscriminate and total..'"))
		user.change_stat(STATKEY_STR, 1)
		ADD_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	return

/obj/item/clothing/ring/statrontz/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_red("'..but without violence, what would stop evil from triumphing?'"))
		user.change_stat(STATKEY_STR, -1)
		REMOVE_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
		active_item = FALSE
	return

///

/obj/item/clothing/ring/statdorpel
	name = "ring of omnipotence"
	desc = "A dorpel ring, glowing with resplendent beauty. The closer your hand drifts to it, the more that your fears melt away."
	icon_state = "newmulticolor"
	smeltresult = /obj/item/riddleofsteel
	is_silver = TRUE
	sellprice = 777
	var/active_item

/obj/item/clothing/ring/statdorpel/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_blue("'..the way of hope, unbreakable and unifying..'"))
		user.change_stat(STATKEY_SPD, 1)
		user.change_stat(STATKEY_LCK, 1)
		user.change_stat(STATKEY_INT, 1)
		user.change_stat(STATKEY_PER, 1)
		user.change_stat(STATKEY_CON, 1)
		user.change_stat(STATKEY_WIL, 1)
		user.change_stat(STATKEY_STR, 1)
		ADD_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	return

/obj/item/clothing/ring/statdorpel/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_blue("'..I know that kindness exists, for I am kind..' </br>'..I know hope exists, for I have hope..' </br>'..and I know love exists, for I love.'"))
		user.change_stat(STATKEY_SPD, -1)
		user.change_stat(STATKEY_LCK, -1)
		user.change_stat(STATKEY_INT, -1)
		user.change_stat(STATKEY_PER, -1)
		user.change_stat(STATKEY_CON, -1)
		user.change_stat(STATKEY_WIL, -1)
		user.change_stat(STATKEY_STR, -1)
		REMOVE_TRAIT(user, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
		active_item = FALSE
	return

///

/obj/item/clothing/ring/dragon_ring
	name = "dragonstone ring"
	icon_state = "dragonring" //Should be safe for vampyres to wear, as the ring itself isn't made of silver. If they've suffered enough to make this ring, they should be able to wear it.
	desc = "A gilded blacksteel ring with a drake's head, sculpted from silver. Perched within its sockets is a blortz and saffira - each, crackling with the reflection of a raging fire."
	smeltresult = /obj/item/ingot/draconic
	sellprice = 666
	var/active_item

/obj/item/clothing/ring/dragon_ring/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == SLOT_RING)
		active_item = TRUE
		to_chat(user, span_suicide("Draconic fire courses through my veins! I feel powerful!"))
		user.change_stat(STATKEY_STR, 2)
		user.change_stat(STATKEY_CON, 2)
		user.change_stat(STATKEY_WIL, 2)
	return

/obj/item/clothing/ring/dragon_ring/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_suicide("A chilling sensation courses through my body, and the ring's heat remains oh-so-alluring.. </br>..yet, one must wonder.. could such fiery strength withstand a forge's heat?"))
		user.change_stat(STATKEY_STR, -2)
		user.change_stat(STATKEY_CON, -2)
		user.change_stat(STATKEY_WIL, -2)
		active_item = FALSE
	return
