//Lazily shoving all donator fluff items in here for now. Feel free to make this a sub-folder or something, I think it's just easier to keep a list here and just modify as needed.

//Plexiant's donator item - rapier
/obj/item/rogueweapon/sword/rapier/aliseo
	name = "Rapier di Aliseo"
	desc = "A rapier of sporting a steel blade and decrotive silver-plating. Elaborately designed in classic intricate yet functional Etrucian style, the pummel appears to be embedded with a cut emerald with a family crest engraved in the fine leather grip of the handle."
	icon_state = "plex"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

//Ryebread's donator item - estoc
/obj/item/rogueweapon/estoc/worttrager
	name = "Wortträger"
	desc = "An imported Grenzelhoftian panzerstecher, a superbly crafted implement devoid of armory marks- merely bearing a maker's mark and the Zenitstadt seal. This one has a grip of walnut wood, and a pale saffira set within the crossguard. The ricasso is engraved with Ravoxian scripture."
	icon_state = "mansa"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

//Srusu's donator item - dress
/obj/item/clothing/suit/roguetown/shirt/dress/emerald
	name = "emerald dress"
	desc = "A silky smooth emerald-green dress, only for the finest of ladies."
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR	//Goes either slot, no armor on it after all.
	icon_state = "laciedress"
	sleevetype = "laciedress"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'

//Strudles donator item - mage vest (same as robes)
/obj/item/clothing/suit/roguetown/shirt/robe/sofiavest
	name = "grenzelhoftian mages vest"
	desc = "A vest often worn by those of the Grenzelhoftian mages college."
	icon_state = "sofiavest"
	item_state = "sofiavest"
	sleevetype = "sofiavest"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	flags_inv = HIDEBOOB
	color = null
	nodismemsleeves = TRUE // prevents sleeves from being torn

//Bat's donator item - custom harp sprite
/obj/item/rogue/instrument/harp/handcarved
	name = "handcrafted harp"
	desc = "A handcrafted harp."
	icon_state = "batharp"
	icon = 'icons/obj/items/donor_objects.dmi'

//Rebel0's donator item - visored sallet with a hood on under it. (Same as normal sallet)
/obj/item/clothing/head/roguetown/helmet/sallet/visored/gilded
	name = "gilded visored sallet"
	desc = "A steel helmet with gilded trim which protects the ears, nose, and eyes."
	icon_state = "gildedsallet_visor"
	item_state = "gildedsallet_visor"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

//Bigfoot's donator item - knight helmet with gilded pattern
/obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded
	name = "gilded knight's helmet"
	desc = "A noble knight's helm made of steel and completed with a gilded trim."
	icon_state = "gildedknight"
	item_state = "gildedknight"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'

/obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

//Bigfoot's donator item - steel great axe with gilded pattern
/obj/item/rogueweapon/greataxe/steel/gilded
	name = "gilded greataxe"
	desc = "A gilded steel great axe, a long-handled axe with a single blade made for ruining someone's day beyond any measure.."
	icon_state = "orin"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

//Zydras donator item - merchant dress
/obj/item/clothing/suit/roguetown/shirt/dress/silkydress/zydrasdress //Recolored silky dress
	name = "Gold-Black silky dress"
	desc = "A gorgeous black and gold dress. It seems the padding was removed."
	icon_state = "zydrasdress"
	item_state = "zydrasdress"
	sleevetype = "zydrasdress"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi' //No sleeves

//Eiren's donator items - zweihander and sabres
/obj/item/rogueweapon/greatsword/zwei/eiren
	name = "Regret"
	desc = "People bring the small flames of their wishes together... to keep them from burning out, we cast our own flames into the biggest fire we can find. But you know... I didn't bring a flame with me. As for me, maybe I just wandered up to the campfire to warm myself a little..."
	icon_state = "eiren"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/greatsword/eiren
	name = "Regret"
	desc = "People bring the small flames of their wishes together... to keep them from burning out, we cast our own flames into the biggest fire we can find. But you know... I didn't bring a flame with me. As for me, maybe I just wandered up to the campfire to warm myself a little..."
	icon_state = "eiren"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/rogueweapon/greatsword/grenz/flamberge/eiren
	name = "Regret"
	desc = "People bring the small flames of their wishes together... to keep them from burning out, we cast our own flames into the biggest fire we can find. But you know... I didn't bring a flame with me. As for me, maybe I just wandered up to the campfire to warm myself a little..."
	icon_state = "eiren"
	icon = 'icons/obj/items/donor_weapons_64.dmi'


/obj/item/rogueweapon/sword/sabre/eiren
	name = "Lunae"
	desc = "Two blades, one forged in Noc's light, a soothing breath of clarity. Here, and here alone, were moon and fire ever together."
	icon_state = "eiren2"
	icon = 'icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "eiren2"

/obj/item/rogueweapon/sword/sabre/eiren/small
	name = "Cinis"
	desc = "Two blades, the other born of Astrata's ire, a raging flame of passion. Here, and here alone, were fates severed and torn."
	icon_state = "eiren3"
	icon = 'icons/obj/items/donor_weapons.dmi'
	sheathe_icon = "eiren3"

//pretzel's special sword
/obj/item/rogueweapon/greatsword/weeperslathe
	name = "Weeper's Lathe"
	desc = "A recreation of a gilbronze greatsword, wrought in steel. Inscribed on the blade is a declaration: \"I HAVE ONLY A SHORT TYME TO LYVE, BUT I AM NOT AFRAID TO DIE.\"" 
	icon_state = "weeperslathe"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

//inverserun's claymore
/obj/item/rogueweapon/greatsword/zwei/inverserun
	name = "Votive Thorns"
	desc = "Promises hurt, but so does plucking rosa. Hoping hurts, but so does looking at the beauty of Astrata's light. Pick yourself back up. Remember your promise, despite the thorns."
	icon_state = "inverse"
	icon = 'icons/obj/items/donor_weapons_64.dmi'

/obj/item/clothing/cloak/raincloak/feather_cloak
	name = "Shroud of the Undermaiden"
	desc = "A fine cloak made from the feathers of Necra's servants, each gifted to a favoured child of the Lady of Veils. While it offers no physical protection, perhaps it ensures that the Undermaiden's gaze is never far from its wearer..."
	icon_state = "feather_cloak"
	item_state = "feather_cloak"
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
	boobed = FALSE
	sleeved = 'icons/clothing/onmob/donor_sleeves_armor.dmi'
	sleevetype = "feather_cloak"
	hoodtype = /obj/item/clothing/head/hooded/rainhood/feather_hood

/obj/item/clothing/head/hooded/rainhood/feather_hood
	name = "feather hood"
	desc = "This one will shelter me from the weather and my identity too."
	icon_state = "feather_hood"
	item_state = "feather_hood"
	slot_flags = ITEM_SLOT_HEAD
	dynamic_hair_suffix = ""
	edelay_type = 1
	body_parts_covered = HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDETAIL
	block2add = FOV_BEHIND
	icon = 'icons/clothing/donor_clothes.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/donor_clothes.dmi'
