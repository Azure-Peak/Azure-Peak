////////////////////////
// TRIUMPH-EXCLUSIVE! //
////////////////////////
// Addresses all Triumph-exclusive items that don't fall under the category of 'reskins'.
// To note - as mentioned in the 'loadout_triumphs.dm' file, make sure these items are blacklisted from the Stockpile if chosen (and applicable). Otherwise, it's open season!

//

/obj/item/reagent_containers/glass/bottle/alchemical/tripot
	name = "vial of distilled triumphance"
	desc = "The fruits of your labor, distilled into a sparkling pittance that shimmers with Azurian light. Sipping this tincture will lightly amplify all of your characteristics for a week's tyme."
	list_reagents = list(/datum/reagent/buff/tri = 10)

/datum/reagent/buff/tri //Keep this restricted to the TRI-locked alchemic reward.
	name = "Distilled Triumphance"
	color = "#74cde0"
	taste_description = "sweet victory"
	scent_description = "memories of a former triumph"

/datum/reagent/buff/tri/on_mob_life(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/buff/alch/tripot)
	return ..()

/datum/status_effect/buff/alch/tripot
	id = "tripot" //Triumph-exclusive. Shouldn't be craftable or obtainable under any other circumstance.
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/tripot
	effectedstats = list(STATKEY_STR = 1, STATKEY_PER = 1, STATKEY_INT = 1, STATKEY_CON = 1, STATKEY_WIL = 1, STATKEY_SPD = 1, STATKEY_LCK = 1)
	duration = 777 MINUTES

/atom/movable/screen/alert/status_effect/buff/alch/tripot
	name = "Triumphance"
	desc = "My latest triumph has empowered me! I am a true champion of Azuria!"
	icon_state = "triumph"

//

/obj/item/clothing/neck/roguetown/ornateamulet/noble/triumph
	name = "ornate amulet"
	desc = "An opulent, golden necklace. When it catches the candelight, it offers a warped yet unmarred reflection of its wearer's guise."
	sellprice = 33

/obj/item/clothing/neck/roguetown/psicross/g/triumph
	name = "ornate golden psycross"
	desc = "'It does not matter, whether He is lyving or gone. His greatest creation still persists; the very world that our feet tread 'pon, now. That, alone, makes everything worth fighting for.'"
	sellprice = 55

/obj/item/clothing/neck/roguetown/psicross/inhumen/g/triumph
	name = "ornate inverted psycross"
	desc = "'Meet your lord, and know your place. Let progress be my chariot, and let my hands be the vessel that rips paradise free from its heavenly grasp. Let Psydonia's carcass not spell the death of Man, but the birth of Gods.'"
	sellprice = 66

/obj/item/clothing/neck/roguetown/psicross/astrata/g/triumph
	name = "ornate amulet of Astrata"
	desc = "Her command is absolute, and Her tyranny is unmarrable. Reclaim this world, child of mine, from those who'd seek to destroy it."
	icon_state = "astrata_g"
	sellprice = 77

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

/obj/item/clothing/head/roguetown/circlet/triumph
	name = "ornate golden circlet"
	desc = "An opulent crown, and the mantle of lesser nobility. It has been meticulously polished to turn even the slightest glimmer into a blinding glare."
	sellprice = 33

/obj/item/clothing/mask/rogue/lordmask/triumph
	name = "ornate golden halfmask"
	desc = "An ornate halfmask of pure, glistening gold. What lies underneath to cradle the face: a besilked cushion, or cold alloys?"
	sellprice = 33

/obj/item/clothing/mask/rogue/facemask/goldmask/triumph
	name = "ornate golden mask"
	desc = "An ornate mask of pure, glistening gold. If you have no face to call your own, then can you truly call yourself humen at all?"
	sellprice = 77
	smeltresult = /obj/item/clothing/mask/rogue/lordmask/triumph

/obj/item/clothing/mask/rogue/facemask/goldmaskc/triumph
	name = "ornate golden mask"
	desc = "An ornate mask of pure, glistening gold. If you have no face to call your own, then can you truly call yourself humen at all?"
	sellprice = 77
	smeltresult = /obj/item/clothing/mask/rogue/lordmask/triumph

/obj/item/clothing/head/roguetown/grenzelhofthat/triumph
	name = "grenzelhoft tellerbarret"
	desc = "The latest in sixteenth-century fashionwear, stitched by the finest tailors in Grenzelhoft. </br>I can fit this onto a sallet, Etruscan bascinet, or Blacksteel armet for added protection."
	max_integrity = ARMOR_INT_HELMET_CLOTH
	icon_state = "grenzelhat"
	item_state = "grenzelhat"
	icon = 'icons/roguetown/clothing/head.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	dynamic_hair_suffix = ""
	armor = ARMOR_PADDED_BAD
	resistance_flags = FLAMMABLE
	color = "#262927"
	detail_color = "#FFFFFF"
	altdetail_color = "#007fff"

/obj/item/clothing/head/roguetown/grenzelhofthat/triumph/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Grenzelhoft colors") as anything in COLOR_MAP
		var/playerchoice = COLOR_MAP[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/grenzelhofthat/triumph/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/reagent_containers/glass/bottle/rogue/triumphbeer
	name = "bottle of beer"
	list_reagents = list(/datum/reagent/consumable/ethanol/beer = 50)
	desc = "A glass bottle with a laced cork-seal. It swishes with fizzled goodness; a cure to the parched throat, a remedy to the sleepless nites, and a toast for the journey ahead."
