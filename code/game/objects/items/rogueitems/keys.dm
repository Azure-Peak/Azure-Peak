
/obj/item/roguekey
	name = "key"
	desc = "An unremarkable iron key."
	icon_state = "iron"
	icon = 'icons/roguetown/items/keys.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75
	throwforce = 0
	var/lockhash = 0
	var/lockid = null
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK
	drop_sound = 'sound/items/gems (1).ogg'
	anvilrepair = /datum/skill/craft/blacksmithing
	resistance_flags = FIRE_PROOF
	experimental_inhand = FALSE

	grid_height = 32
	grid_width = 32

/obj/item/roguekey/Initialize()
	. = ..()
	if(lockid)
		if(GLOB.lockids[lockid])
			lockhash = GLOB.lockids[lockid]
		else
			lockhash = rand(100,999)
			while(lockhash in GLOB.lockhashes)
				lockhash = rand(100,999)
			GLOB.lockhashes += lockhash
			GLOB.lockids[lockid] = lockhash

/obj/item/lockpick
	name = "lockpick"
	desc = "A small, sharp piece of metal to aid opening locks in the absence of a key."
	icon_state = "lockpick"
	icon = 'icons/roguetown/items/keys.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75
	throwforce = 0
	max_integrity = 10
	picklvl = 1
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK
	destroy_sound = 'sound/items/pickbreak.ogg'
	resistance_flags = FIRE_PROOF
	associated_skill = /datum/skill/misc/lockpicking	//Doesn't do anything, for tracking purposes only
	always_destroy = TRUE

	grid_width = 32
	grid_height = 64

/obj/item/lockpick/goldpin
	name = "gold hairpin"
	desc = "Often used by wealthy courtesans and nobility to keep hair and clothing in place."
	icon_state = "goldpin"
	item_state = "goldpin"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK|ITEM_SLOT_HIP
	body_parts_covered = NONE
	w_class = WEIGHT_CLASS_TINY
	experimental_onhip = FALSE
	possible_item_intents = list(/datum/intent/use, /datum/intent/stab)
	force = 10
	throwforce = 5
	max_integrity = null
	dropshrink = 0.7
	drop_sound = 'sound/items/gems (2).ogg'
	destroy_sound = 'sound/items/pickbreak.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	associated_skill = /datum/skill/misc/lockpicking
	var/material = "gold"

	grid_width = 32
	grid_height = 32

/obj/item/lockpick/goldpin/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_BELT_R)
		icon_state = "[material]pin_beltr"
		user.update_inv_belt()
	if(slot == SLOT_BELT_L)
		icon_state = "[material]pin_beltl"
		user.update_inv_belt()
	else
		icon_state = "[material]pin"
		user.update_icon()

/obj/item/lockpick/goldpin/silver
	name = "silver hairpin"
	desc = "Often used by wealthy courtesans and nobility to keep hair and clothing in place. This one's silver - a rarity."
	icon_state = "silverpin"
	item_state = "silverpin"
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	material = "silver"
	is_silver = TRUE

/obj/item/roguekey/lord
	name = "master key"
	desc = "A magical key that molds itself to fit any lock. Can always be recalled by the Crown."
	icon_state = "bosskey"
	lockid = "lord"
	visual_replacement = /obj/item/roguekey/royal

/obj/item/roguekey/lord/Initialize()
	. = ..()
	if(SSroguemachine.key)
		qdel(src)
	else
		SSroguemachine.key = src

/obj/item/roguekey/lord/proc/anti_stall()
	src.visible_message(span_danger("The Key of Azure Peak crumbles to dust, the ashes spiriting away in the direction of the Keep."))
	SSroguemachine.key = null //Do not harddel.
	qdel(src) //Anti-stall

/obj/item/roguekey/lord/pre_attack(target, user, params)
	. = ..()
	if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/C = target
		if(C.masterkey)
			lockhash = C.lockhash
	if(istype(target, /obj/structure/mineral_door))
		var/obj/structure/mineral_door/D = target
		if(D.masterkey)
			lockhash = D.lockhash

/obj/item/roguekey/skeleton //Think of it less FOR skeletons and more just master key but can't be recalled and can be lost.
	name = "skeleton key"
	desc = "A moldable key able to fit anywhere. Marvel of engineering."
	icon_state = "skeletonkey"
	lockid = "lord"
	visual_replacement = /obj/item/roguekey/royal

/obj/item/roguekey/skeleton/pre_attack(target, user, params)
	. = ..()
	if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/C = target
		if(C.masterkey)
			lockhash = C.lockhash
	if(istype(target, /obj/structure/mineral_door))
		var/obj/structure/mineral_door/D = target
		if(D.masterkey)
			lockhash = D.lockhash

//////////////////////////////
// MANOR / NOBLES / COUNCIL //
//////////////////////////////

/obj/item/roguekey/royal
	name = "royal key"
	desc = "The key to the royal chambers. It even feels pretentious."
	icon_state = "ekey"
	lockid = "royal"

/obj/item/roguekey/manor
	name = "manor key"
	desc = "This key will open any general purpose manor doors."
	icon_state = "mazekey"
	lockid = "manor"

/obj/item/roguekey/heir
	name = "heir room key"
	desc = "A highly coveted key belonging to the doors of the heirs of this realm."
	icon_state = "hornkey"
	lockid = "heir"

/obj/item/roguekey/heir/one
	name = "heir room I key"
	lockid = "heir1"

/obj/item/roguekey/heir/two
	name = "heir room II key"
	lockid = "heir2"

/obj/item/roguekey/vault
	name = "vault key"
	desc = "This key opens the mighty vault."
	icon_state = "cheesekey"
	lockid = "vault"

/obj/item/roguekey/hand
	name = "hand's key"
	desc = "This key opens the quarters of the right hand man."
	icon_state = "cheesekey"
	lockid = "hand"

/obj/item/roguekey/steward
	name = "steward's key"
	desc = "This key belongs to the court's greedy steward."
	icon_state = "cheesekey"
	lockid = "steward"

/obj/item/roguekey/archive
	name = "archive key"
	desc = "This key opens the university archive."
	icon_state = "ekey"
	lockid = "archive"

/obj/item/roguekey/mage
	name = "magicians's key"
	desc = "This is the court wizard's key. It watches you..."
	icon_state = "eyekey"
	lockid = "mage"

/obj/item/roguekey/manor/knight
	name = "retinue bedroom I key"
	lockid = "manor_knight_one"

/obj/item/roguekey/manor/knight/two
	name = "retinue bedroom II key"
	lockid = "manor_knight_two"

/obj/item/roguekey/manor/knight/three
	name = "retinue bedroom III key"
	lockid = "manor_knight_three"

/obj/item/roguekey/manor/knight/four
	name = "retinue bedroom IV key"
	lockid = "manor_knight_four"

/obj/item/roguekey/manor/councillor
	name = "councillor bedroom I key"
	lockid = "manor_councillor_one"

/obj/item/roguekey/manor/councillor/two
	name = "councillor bedroom II key"
	lockid = "manor_councillor_two"

/obj/item/roguekey/manor/councillor/three
	name = "councillor bedroom III key"
	lockid = "manor_councillor_three"

/obj/item/roguekey/manor/guest
	name = "guest bedroom I key"
	lockid = "guest_knight_one"

/obj/item/roguekey/manor/guest/two
	name = "guest bedroom II key"
	lockid = "guest_knight_two"

/obj/item/roguekey/manor/guest/three
	name = "guest bedroom III key"
	lockid = "guest_knight_three"

/obj/item/roguekey/manor/guest/four
	name = "guest bedroom IV key"
	lockid = "guest_knight_four"

/obj/item/roguekey/manor/squire
	name = "squire bedroom I key"
	lockid = "squire_room_one"

/obj/item/roguekey/manor/squire/two
	name = "squire bedroom II key"
	lockid = "squire_room_two"

/obj/item/roguekey/manor/squire/three
	name = "squire bedroom III key"
	lockid = "squire_room_three"

/obj/item/roguekey/manor/squire/four
	name = "squire bedroom IV key"
	lockid = "squire_room_four"

/obj/item/roguekey/manor/servant
	name = "servant bedroom I key"
	lockid = "servant_room_one"

/obj/item/roguekey/manor/servant/two
	name = "servant bedroom II key"
	lockid = "servant_room_two"

/obj/item/roguekey/manor/servant/three
	name = "servant bedroom III key"
	lockid = "servant_room_three"

/obj/item/roguekey/manor/servant/four
	name = "servant bedroom IV key"
	lockid = "servant_room_four"

/obj/item/roguekey/manor/servant/five
	name = "servant bedroom V key"
	lockid = "servant_room_five"

/obj/item/roguekey/manor/servant/six
	name = "servant bedroom VI key"
	lockid = "servant_room_six"

////////////////////////
// RETINUE / GARRISON //
////////////////////////

/obj/item/roguekey/justiciary
	name = "justiciary key"
	desc = "This key opens the justiciary."
	icon_state = "cheesekey"
	lockid = "sheriff"

/obj/item/roguekey/knight
	name = "knight's key"
	desc = "This is a key to the knight's chambers."
	icon_state = "ekey"
	lockid = "knight"

/obj/item/roguekey/sergeant
	name = "sergeant key"
	desc = "This key opens garrison's sergeant office."
	icon_state = "spikekey"
	lockid = "sergeant"

/obj/item/roguekey/garrison
	name = "barracks key"
	desc = "This simple key opens the garrison's barracks."
	icon_state = "spikekey"
	lockid = "garrison"

/obj/item/roguekey/warden
	name = "watchtower key"
	desc = "This key opens the warden's watchtower."
	icon_state = "spikekey"
	lockid = "warden"

/obj/item/roguekey/dungeon
	name = "dungeon key"
	desc = "This key opens the dungeons."
	icon_state = "rustkey"
	lockid = "dungeon"

/obj/item/roguekey/walls
	name = "walls key"
	desc = "This key opens the walls and gatehouses around the city."
	icon_state = "rustkey"
	lockid = "walls"

/obj/item/roguekey/armory
	name = "armory key"
	desc = "This key opens the garrison's armory."
	icon_state = "hornkey"
	lockid = "armory"

/////////////////////
// PANTHEON CHURCH //
/////////////////////

/obj/item/roguekey/priest
	name = "bishop's key"
	desc = "This is the master key of the church."
	icon_state = "cheesekey"
	lockid = "priest"

/obj/item/roguekey/keeper
	name = "beast sanctum key"
	desc = "This key should open and close the heart beast's sanctum."
	icon_state = "beastkey"
	lockid = "keeper"

/obj/item/roguekey/keeper_inner
	name = "beast inner sanctum key"
	desc = "This key should open and close the iron gates within the beast's sanctum."
	icon_state = "beastkey2"
	lockid = "keeper2"

/obj/item/roguekey/church
	name = "church key"
	desc = "This bronze key should open almost all doors in the church."
	icon_state = "brownkey"
	lockid = "church"

/obj/item/roguekey/graveyard
	name = "crypt key"
	desc = "This rusty key opens the crypt."
	icon_state = "rustkey"
	lockid = "graveyard"

/obj/item/roguekey/church/roomi
	name = "church bedroom I key"
	desc = "The key to the first room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_1"

/obj/item/roguekey/church/roomii
	name = "church bedroom II key"
	desc = "The key to the second room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_2"

/obj/item/roguekey/church/roomiii
	name = "church bedroom III key"
	desc = "The key to the third room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_3"

/obj/item/roguekey/church/roomiv
	name = "church bedroom IV key"
	desc = "The key to the fourth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_4"

/obj/item/roguekey/church/roomv
	name = "church bedroom V key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_5"

/obj/item/roguekey/church/roomvi
	name = "church bedroom VI key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_6"

/obj/item/roguekey/church/roomvii
	name = "church bedroom VII key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_7"

/obj/item/roguekey/church/roomviii
	name = "church bedroom VIII key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_8"

/obj/item/roguekey/church/roomix
	name = "church bedroom IX key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_9"

/obj/item/roguekey/church/roomx
	name = "church bedroom X key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_10"

/obj/item/roguekey/church/roomxi
	name = "church bedroom XI key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_11"
	
/obj/item/roguekey/church/roomxii
	name = "church bedroom XII key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_12"

/obj/item/roguekey/church/roomxiii
	name = "church bedroom XIII key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_13"

/obj/item/roguekey/church/roomxiv
	name = "church bedroom XIV key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "church_bedroom_up_14"

//////////////
// BURGHERS //
//////////////

/obj/item/roguekey/crier
	name = "crier's key"
	desc = "This key should open and close the crier's office."
	icon_state = "cheesekey"
	lockid = "crier"

/obj/item/roguekey/crafterguild
	name = "guild's key"
	desc = "The key to the Crafter's Guild."
	icon_state = "brownkey"
	lockid = "crafterguild"

/obj/item/roguekey/craftermaster
	name = "guildmaster's key"
	desc = "The key of the Crafter's Guild Guildmaster."
	icon_state = "hornkey"
	lockid = "craftermaster"

/obj/item/roguekey/tailor
	name = "tailor's key"
	desc = "This key opens the tailor's shop. There is a thin thread wrapped around it."
	icon_state = "brownkey"
	lockid = "tailor"

/obj/item/roguekey/physician
	name = "physician key"
	desc = "The key smells of herbs, feeling soothing to the touch."
	icon_state = "greenkey"
	lockid = "physician"

///////////////////////
// MERCHANT / STALLS //
///////////////////////

/obj/item/roguekey/merchant
	name = "merchant's key"
	desc = "A merchant's key."
	icon_state = "cheesekey"
	lockid = "merchant"

/obj/item/roguekey/shop
	name = "shop key"
	desc = "This key opens and closes a shop door."
	icon_state = "ekey"
	lockid = "shop"

/obj/item/roguekey/apartments/stall1
	name = "stall i key"
	icon_state = "brownkey"
	lockid = "stall1"

/obj/item/roguekey/apartments/stall2
	name = "stall ii key"
	icon_state = "brownkey"
	lockid = "stall2"

/obj/item/roguekey/apartments/stall3
	name = "stall iii key"
	icon_state = "brownkey"
	lockid = "stall3"

/obj/item/roguekey/apartments/stall4
	name = "stall iv key"
	icon_state = "brownkey"
	lockid = "stall4"

/obj/item/roguekey/apartments/stable1
	name = "stable i key"
	icon_state = "brownkey"
	lockid = "stable1"

/obj/item/roguekey/apartments/stable2
	name = "stable ii key"
	icon_state = "brownkey"
	lockid = "stable2"

/obj/item/roguekey/apartments/stablemaster_1
	name = "stable i key"
	icon_state = "brownkey"
	lockid = "stable_master_1"

/obj/item/roguekey/apartments/stablemaster_2
	name = "stable ii key"
	icon_state = "brownkey"
	lockid = "stable_master_2"

/obj/item/roguekey/apartments/stablemaster_3
	name = "stable iii key"
	icon_state = "brownkey"
	lockid = "stable_master_3"

/obj/item/roguekey/apartments/stablemaster_4
	name = "stable iv key"
	icon_state = "brownkey"
	lockid = "stable_master_4"

/obj/item/roguekey/apartments/stablemaster_5
	name = "stable v key"
	icon_state = "brownkey"
	lockid = "stable_master_5"

/obj/item/roguekey/apartments/stablemaster
	name = "stablemaster key"
	icon_state = "brownkey"
	lockid = "stablemaster"

//////////////////////////
// INN / TAVERN / BATHS //
//////////////////////////

/obj/item/roguekey/tavern
	name = "tavern key"
	desc = "This key should open and close any tavern door."
	icon_state = "hornkey"
	lockid = "tavern"

/obj/item/roguekey/tavernkeep
	name = "innkeep's key"
	desc = "This key opens and closes the innkeep's bedroom."
	icon_state = "greenkey"
	lockid = "innkeep"

/obj/item/roguekey/bath // For use in round-start available bathhouse quarters. Do not use default lockID.
	name = "bathhouse quarter key"
	desc = "The key to an employee's quarters. Hope it's not lost."
	icon_state = "brownkey"
	lockid = "bath"

/obj/item/roguekey/bathmaster
	name = "bathmaster's key"
	desc = "This regal key opens the bathmaster's office - and his vault."
	icon_state = "greenkey"
	lockid = "nightman"

/obj/item/roguekey/bathworker
	name = "bathhouse key"
	desc = "This regal key opens doors inside the bath-house."
	icon_state = "bathkey"
	lockid = "nightmaiden"

/obj/item/roguekey/roomi
	name = "room I key"
	desc = "The key to the first room."
	icon_state = "brownkey"
	lockid = "roomi"

/obj/item/roguekey/roomii
	name = "room II key"
	desc = "The key to the second room."
	icon_state = "brownkey"
	lockid = "roomii"

/obj/item/roguekey/roomiii
	name = "room III key"
	desc = "The key to the third room."
	icon_state = "brownkey"
	lockid = "roomiii"

/obj/item/roguekey/roomiv
	name = "room IV key"
	desc = "The key to the fourth room."
	icon_state = "brownkey"
	lockid = "roomiv"

/obj/item/roguekey/roomv
	name = "room V key"
	desc = "The key to the fifth room."
	icon_state = "brownkey"
	lockid = "roomv"

/obj/item/roguekey/roomvi
	name = "room VI key"
	desc = "The key to the sixth room."
	icon_state = "brownkey"
	lockid = "roomvi"

/obj/item/roguekey/roomhunt
	name = "HUNT room key"
	desc = "The key to the HUNT room, the penthouse suite of the local inn."
	icon_state = "brownkey"
	lockid = "roomhunt"

/obj/item/roguekey/fancyroomi
	name = "luxury room I key"
	desc = "The key to the first luxury room."
	icon_state = "hornkey"
	lockid = "fancyi"

/obj/item/roguekey/fancyroomii
	name = "luxury room II key"
	desc = "The key to the second luxury room."
	icon_state = "hornkey"
	lockid = "fancyii"

/obj/item/roguekey/fancyroomiii
	name = "luxury room III key"
	desc = "The key to the third luxury room."
	icon_state = "hornkey"
	lockid = "fancyiii"

/obj/item/roguekey/fancyroomiv
	name = "luxury room IV key"
	desc = "The key to the fourth luxury room."
	icon_state = "hornkey"
	lockid = "fancyiv"

/obj/item/roguekey/fancyroomv
	name = "luxury room V key"
	desc = "The key to the fifth luxury room."
	icon_state = "hornkey"
	lockid = "fancyv"

/obj/item/roguekey/mercenary
	name = "mercenary key"
	desc = "Why, a mercenary would not kick doors down."
	icon_state = "greenkey"
	lockid = "merc"

/obj/item/roguekey/mercenary/bedrooms
	name = "mercenary bunk i key"
	desc = "Why, a mercenary would not kick doors down."
	icon_state = "greenkey"
	lockid = "merc_bunk_i"

/obj/item/roguekey/mercenary/bedrooms/ii
	name = "mercenary bunk ii key"
	lockid = "merc_bunk_ii"

/obj/item/roguekey/mercenary/bedrooms/iii
	name = "mercenary bunk iii key"
	lockid = "merc_bunk_iii"

/obj/item/roguekey/mercenary/bedrooms/iv
	name = "mercenary bunk iv key"
	lockid = "merc_bunk_iv"

/obj/item/roguekey/mercenary/bedrooms/v
	name = "mercenary bunk v key"
	lockid = "merc_bunk_v"

/obj/item/roguekey/mercenary/bedrooms/vi
	name = "mercenary bunk vi key"
	lockid = "merc_bunk_vi"

/obj/item/roguekey/mercenary/bedrooms/vii
	name = "mercenary bunk vii key"
	lockid = "merc_bunk_vii"

/obj/item/roguekey/mercenary/bedrooms/viii
	name = "mercenary bunk viii key"
	lockid = "merc_bunk_viii"

//////////////////////
// PEASANTS / SERFS //
//////////////////////

/obj/item/roguekey/townie // For use in round-start available houses in town. Do not use default lockID.
	name = "town dwelling key"
	desc = "The key of some townie's home. Hope it's not lost."
	icon_state = "brownkey"
	lockid = "townie"

/obj/item/roguekey/farm
	name = "farm key"
	desc = "This is a rusty key that'll open farm doors."
	icon_state = "rustkey"
	lockid = "farm"

/obj/item/roguekey/university
	name = "university key"
	desc = "This key should open anything within the university."
	icon_state = "greenkey"
	lockid = "university"

/obj/item/roguekey/townie_smith_extras
	name = "town smith key"
	desc = "The key to the basement and bedroom of the towner smiths house."
	icon_state = "brownkey"
	lockid = "townie_smith_extra"

/////////////////
// INQUISITION //
/////////////////

/obj/item/roguekey/inquisitor
	name = "inquisitors's key"
	desc = "This is an intricate key most likely meant for the inquisitor." // i have no idea what is this key about
	icon_state = "mazekey"
	lockid = "puritan"

/obj/item/roguekey/inquisitionmanor
	name = "inquisition manor key"
	desc = "This key opens the doors to the inquisition manor."
	icon_state = "brownkey"
	lockid = "inquisition"

//////////////////////////
// VAMPIRE / ANTAGONIST //
//////////////////////////

/obj/item/roguekey/vampire
	name = "mansion key"
	desc = "The key to a vampire lord's castle."
	icon_state = "vampkey"
	lockid = "mansionvampire"

/obj/item/roguekey/vampire/guest
	name = "mansion guest key"
	icon_state = "brownkey"
	lockid = "mansionvampire_guest"

/obj/item/roguekey/vampire/maid
	name = "mansion maid key"
	icon_state = "ekey"
	lockid = "mansionvampire_maid"

/obj/item/roguekey/bandit
	name = "old key"
	desc = "This is a rusty key."
	icon_state = "rustkey"
	lockid = "bandit"

//Zurch

/obj/item/roguekey/inhumen
	name = "old cell key"
	desc = "A ancient, rusty key. Seems like it goes to some kind of cell."
	icon_state = "rustkey"
	lockid = "inhumen"

/obj/item/roguekey/inhumen/one
	name = "cell key one"
	desc = "A ancient, rusty key. Seems like it goes to some kind of cell."
	icon_state = "rustkey"
	lockid = "inhumen1"

/obj/item/roguekey/inhumen/two
	name = "cell key two"
	desc = "A ancient, rusty key. Seems like it goes to some kind of cell."
	icon_state = "rustkey"
	lockid = "inhumen2"

/obj/item/roguekey/inhumen/three
	name = "cell key three"
	desc = "A ancient, rusty key. Seems like it goes to some kind of cell."
	icon_state = "rustkey"
	lockid = "inhumen3"

/obj/item/roguekey/inhumen/four
	name = "cell key four"
	desc = "A ancient, rusty key. Seems like it goes to some kind of cell."
	icon_state = "rustkey"
	lockid = "inhumen4"

/obj/item/roguekey/zurch_bedroom
	name = "bedroom i key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_1"

/obj/item/roguekey/zurch_bedroom/two
	name = "bedroom ii key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_2"

/obj/item/roguekey/zurch_bedroom/three
	name = "bedroom iii key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_3"

/obj/item/roguekey/zurch_bedroom/four
	name = "bedroom iv key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_4"

/obj/item/roguekey/zurch_bedroom/five
	name = "bedroom v key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_5"

/obj/item/roguekey/zurch_bedroom/six
	name = "bedroom vi key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_6"

/obj/item/roguekey/zurch_bedroom/seven
	name = "bedroom vii key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_7"

/obj/item/roguekey/zurch_bedroom/eight
	name = "bedroom viii key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_8"

/obj/item/roguekey/zurch_bedroom/nine
	name = "bedroom ix key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_9"

/obj/item/roguekey/zurch_bedroom/ten
	name = "bedroom x key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_10"

/obj/item/roguekey/zurch_bedroom/eleven
	name = "bedroom xi key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_11"

/obj/item/roguekey/zurch_bedroom/twelve
	name = "bedroom xii key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "zurch_bedroom_12"

/obj/item/roguekey/zurch_bedroom/admin
	name = "ancient key"
	desc = "A ancient, rusty key."
	icon_state = "rustkey"
	lockid = "admin_event_door"

//////////////
// SIDEFOLK //
//////////////

/obj/item/roguekey/veteran
	name = "veteran's keys"
	desc = "A key to the private residence of the town's grumpy battlemaster."
	icon_state = "greenkey"
	lockid = "veteran"


///////////////////////////////////////
// ABSOLUTELY ZERO CLUE WHAT THIS IS //
///////////////////////////////////////
//grenchensnacker
/obj/item/roguekey/porta
	name = "strange key"
	desc = "Was this key enchanted by a wizard locksmith...?"//what is grenchensnacker.
	icon_state = "eyekey"
	lockid = "porta"


//custom key
/obj/item/roguekey/custom
	name = "custom key"
	desc = "A custom key designed by a blacksmith."
	icon_state = "brownkey"

/obj/item/roguekey/custom/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		var/input = (input(user, "What would you name this key?", "", "") as text)
		if(input)
			name = input + " key"
			to_chat(user, span_notice("You rename the key to [name]."))

//custom key blank
/obj/item/customblank //i'd prefer not to make a seperate item for this honestly
	name = "blank custom key"
	desc = "A key without its teeth carved in. Endless possibilities..."
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "brownkey"
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.75
	var/lockhash = 0

/obj/item/customblank/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		var/input = input(user, "What would you like to set the key ID to?", "", 0) as num
		input = max(0, input)
		to_chat(user, span_notice("You set the key ID to [input]."))
		lockhash = 10000 + input //having custom lock ids start at 10000 leaves it outside the range that opens normal doors, so you can't make a key that randomly unlocks existing key ids like the church

/obj/item/customblank/attack_right(mob/user)
	if(istype(user.get_active_held_item(), /obj/item/roguekey))
		var/obj/item/roguekey/held = user.get_active_held_item()
		src.lockhash = held.lockhash
		to_chat(user, span_notice("You trace the teeth from [held] to [src]."))
	else if(istype(user.get_active_held_item(), /obj/item/customlock))
		var/obj/item/customlock/held = user.get_active_held_item()
		src.lockhash = held.lockhash
		to_chat(user, span_notice("You fine-tune [src] to the lock's internals."))
	else if(istype(user.get_active_held_item(), /obj/item/rogueweapon/hammer) && src.lockhash != 0)
		var/obj/item/roguekey/custom/F = new (get_turf(src))
		F.lockhash = src.lockhash
		to_chat(user, span_notice("You finish [F]."))
		qdel(src)


//custom lock unfinished
/obj/item/customlock
	name = "unfinished lock"
	desc = "A lock without its pins set. Endless possibilities..."
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "lock"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.75
	var/lockhash = 0

/obj/item/customlock/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		var/input = input(user, "What would you like to set the lock ID to?", "", 0) as num
		input = max(0, input)
		to_chat(user, span_notice("You set the lock ID to [input]."))
		lockhash = 10000 + input //same deal as the customkey
	else if(istype(I, /obj/item/roguekey))
		var/obj/item/roguekey/ID = I
		if(ID.lockhash == src.lockhash)
			to_chat(user, span_notice("[I] twists cleanly in [src]."))
		else
			to_chat(user, span_warning("[I] jams in [src],"))
	else if(istype(I, /obj/item/customblank))
		var/obj/item/customblank/ID = I
		if(ID.lockhash == src.lockhash)
			to_chat(user, span_notice("[I] twists cleanly in [src].")) //this makes no sense since the teeth aren't formed yet but i want people to be able to check whether the locks theyre making actually fit
		else
			to_chat(user, span_warning("[I] jams in [src]."))

/obj/item/customlock/attack_right(mob/user)
	if(istype(user.get_active_held_item(), /obj/item/roguekey))//i need to figure out how to avoid these massive if/then trees, this sucks
		var/obj/item/roguekey/held = user.get_active_held_item()
		src.lockhash = held.lockhash
		to_chat(user, span_notice("You align the lock's internals to [held].")) //locks for non-custom keys
	else if(istype(user.get_active_held_item(), /obj/item/customblank))
		var/obj/item/customblank/held = user.get_active_held_item()
		src.lockhash = held.lockhash
		to_chat(user, span_notice("You align the lock's internals to [held]."))
	else if(istype(user.get_active_held_item(), /obj/item/rogueweapon/hammer) && src.lockhash != 0)
		var/obj/item/customlock/finished/F = new (get_turf(src))
		F.lockhash = src.lockhash
		to_chat(user, span_notice("You finish [F]."))
		qdel(src)

//finished lock
/obj/item/customlock/finished
	name = "lock"
	desc = "A customized iron lock that is used by keys."
	var/holdname = ""

/obj/item/customlock/finished/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rogueweapon/hammer))
		src.holdname = input(user, "What would you like to name this?", "", "") as text
		if(holdname)
			to_chat(user, span_notice("You label the [name] with [holdname]."))
	else
		..()

/obj/item/customlock/finished/attack_right(mob/user)//does nothing. probably better ways to do this but whatever

/obj/item/customlock/finished/attack_obj(obj/structure/K, mob/living/user)
	if(istype(K, /obj/structure/closet))
		var/obj/structure/closet/KE = K
		if(KE.keylock == TRUE)
			to_chat(user, span_warning("[K] already has a lock."))
		else
			KE.keylock = TRUE
			KE.lockhash = src.lockhash
			KE.lock_strength = 100
			if(src.holdname)
				KE.name = (src.holdname + " " + KE.name)
			to_chat(user, span_notice("You add [src] to [K]."))
			qdel(src)
	if(istype(K, /obj/structure/mineral_door))
		var/obj/structure/mineral_door/KE = K
		if(KE.keylock == TRUE)
			to_chat(user, span_warning("[K] already has a lock."))
		else
			KE.keylock = TRUE
			KE.lockhash = src.lockhash
			KE.lock_strength = 100
			if(src.holdname)
				KE.name = src.holdname
			to_chat(user, span_notice("You add [src] to [K]."))
			qdel(src)
	if(istype(K, /obj/structure/englauncher))
		var/obj/structure/englauncher/KE = K
		if(KE.keylock == TRUE)
			to_chat(user, span_warning("[K] already has a lock."))
		else
			KE.keylock = TRUE
			KE.lockhash = src.lockhash
			if(src.holdname)
				KE.name = src.holdname
			to_chat(user, span_notice("You add [src] to [K]."))
			qdel(src)	
