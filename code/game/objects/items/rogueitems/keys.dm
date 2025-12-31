
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
	desc = "The Lord's key."
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

/obj/item/roguekey/royal
	name = "Royal Key"
	desc = "The Key to the royal chambers. It even feels pretentious."
	icon_state = "ekey"
	lockid = "royal"

/obj/item/roguekey/manor
	name = "manor key"
	desc = "This key will open any manor doors."
	icon_state = "mazekey"
	lockid = "manor"

/obj/item/roguekey/heir
	name = "heir room key"
	desc = "A highly coveted key belonging to the doors of the heirs of this realm."
	icon_state = "hornkey"
	lockid = "heir"

/obj/item/roguekey/garrison
	name = "town watch key"
	desc = "This key belongs to the town guards."
	icon_state = "spikekey"
	lockid = "garrison"

/obj/item/roguekey/sergeant
	name = "sergeant key"
	desc = "This key belongs to the sergeant of the Men-at-Arms."
	icon_state = "spikekey"
	lockid = "sergeant"

/obj/item/roguekey/warden
	name = "watchtower key"
	desc = "This key belongs to the wardens."
	icon_state = "spikekey"
	lockid = "warden"

/obj/item/roguekey/dungeon
	name = "dungeon key"
	desc = "This key should unlock the rusty bars and doors of the dungeon."
	icon_state = "rustkey"
	lockid = "dungeon"

/obj/item/roguekey/vault
	name = "vault key"
	desc = "This key opens the mighty vault."
	icon_state = "cheesekey"
	lockid = "vault"

/obj/item/roguekey/sheriff
	name = "Knight Captain's key"
	desc = "This key belongs to the captain of the guard."
	icon_state = "cheesekey"
	lockid = "sheriff"

/obj/item/roguekey/bailiff
	name = "bailiff's key"
	desc = "This key belongs to the bailiff."
	icon_state = "cheesekey"
	lockid = "sheriff"

/obj/item/roguekey/armory
	name = "armory key"
	desc = "This key opens the garrison's armory."
	icon_state = "hornkey"
	lockid = "armory"

/obj/item/roguekey/knight
	name = "knight's key"
	desc = "This is a key to the knight's chambers."
	icon_state = "ekey"
	lockid = "knight"

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

/obj/item/roguekey/townie // For use in round-start available houses in town. Do not use default lockID.
	name = "town dwelling key"
	desc = "The key of some townie's home. Hope it's not lost."
	icon_state = "brownkey"
	lockid = "townie"

/obj/item/roguekey/bath // For use in round-start available bathhouse quarters. Do not use default lockID.
	name = "bathhouse quarter key"
	desc = "The key to an employee's quarters. Hope it's not lost."
	icon_state = "brownkey"
	lockid = "bath"

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

/obj/item/roguekey/crier
	name = "crier's key"
	desc = "This key should open and close the crier's office."
	icon_state = "cheesekey"
	lockid = "crier"

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

/obj/item/roguekey/tavern/village
	lockid = "vtavern"

/obj/item/roguekey/roomi/village
	lockid = "vroomi"

/obj/item/roguekey/roomii/village
	lockid = "vroomii"

/obj/item/roguekey/roomiii/village
	lockid = "vroomiii"

/obj/item/roguekey/roomiv/village
	lockid = "vroomiv"

/obj/item/roguekey/roomv/village
	lockid = "vroomv"

/obj/item/roguekey/roomvi/village
	lockid = "vroomvi"

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

//vampire mansion//
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
//

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

/obj/item/roguekey/walls
	name = "walls key"
	desc = "This is a rusty key."
	icon_state = "rustkey"
	lockid = "walls"

/obj/item/roguekey/bandit
	name = "old key"
	desc = "This is a rusty key."
	icon_state = "rustkey"
	lockid = "bandit"

/obj/item/roguekey/farm
	name = "farm key"
	desc = "This is a rusty key that'll open farm doors."
	icon_state = "rustkey"
	lockid = "farm"

/obj/item/roguekey/butcher
	name = "butcher key"
	desc = "This is a rusty key that'll open butcher doors."
	icon_state = "rustkey"
	lockid = "butcher"

/obj/item/roguekey/church
	name = "church key"
	desc = "This bronze key should open almost all doors in the church."
	icon_state = "brownkey"
	lockid = "church"

/obj/item/roguekey/priest
	name = "Bishop's key"
	desc = "This is the master key of the church."
	icon_state = "cheesekey"
	lockid = "priest"

/obj/item/roguekey/university
	name = "university key"
	desc = "This key should open anything within the university."
	icon_state = "greenkey"
	lockid = "university"

/obj/item/roguekey/mage
	name = "magicians's key"
	desc = "This is the court wizard's key. It watches you..."
	icon_state = "eyekey"
	lockid = "mage"

/obj/item/roguekey/graveyard
	name = "crypt key"
	desc = "This rusty key belongs to the gravekeeper."
	icon_state = "rustkey"
	lockid = "graveyard"


/obj/item/roguekey/tailor
	name = "tailor's key"
	desc = "This key opens the tailor's shop. There is a thin thread wrapped around it."
	icon_state = "brownkey"
	lockid = "tailor"

/obj/item/roguekey/nightman
	name = "bathmaster's key"
	desc = "This regal key opens the bathmaster's office - and his vault."
	icon_state = "greenkey"
	lockid = "nightman"

/obj/item/roguekey/nightmaiden
	name = "bathhouse key"
	desc = "This regal key opens doors inside the bath-house."
	icon_state = "bathkey"
	lockid = "nightmaiden"

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

/obj/item/roguekey/physician
	name = "physician key"
	desc = "The key smells of herbs, feeling soothing to the touch."
	icon_state = "greenkey"
	lockid = "physician"

/obj/item/roguekey/puritan
	name = "puritan's key"
	desc = "This is an intricate key." // i have no idea what is this key about
	icon_state = "mazekey"
	lockid = "puritan"

/obj/item/roguekey/inquisition
	name = "inquisition key"
	desc = "This key opens the doors leading into the church's basement, where the inquisition dwells."
	icon_state = "brownkey"
	lockid = "inquisition"

/obj/item/roguekey/inhumen
	name = "old cell key"
	desc = "A ancient, rusty key. Seems like it goes to some kind of cell."
	icon_state = "rustkey"
	lockid = "inhumen"

/obj/item/roguekey/hand
	name = "hand's key"
	desc = "This regal key belongs to the Grand Duke's Right Hand."
	icon_state = "cheesekey"
	lockid = "hand"

/obj/item/roguekey/steward
	name = "steward's key"
	desc = "This key belongs to the court's greedy steward."
	icon_state = "cheesekey"
	lockid = "steward"

/obj/item/roguekey/archive
	name = "archive key"
	desc = "This key looks barely used."
	icon_state = "ekey"
	lockid = "archive"

//grenchensnacker
/obj/item/roguekey/porta
	name = "strange key"
	desc = "Was this key enchanted by a wizard locksmith...?"//what is grenchensnacker.
	icon_state = "eyekey"
	lockid = "porta"

//Apartment and shop keys
/obj/item/roguekey/apartments
	name = ""
	icon_state = ""
	lockid = ""

/obj/item/roguekey/apartments/apartment1
	name = "apartment i key"
	icon_state = "brownkey"
	lockid = "apartment1"

/obj/item/roguekey/apartments/apartment2
	name = "apartment ii key"
	icon_state = "brownkey"
	lockid = "apartment2"

/obj/item/roguekey/apartments/apartment3
	name = "apartment iii key"
	icon_state = "brownkey"
	lockid = "apartment3"

/obj/item/roguekey/apartments/apartment4
	name = "apartment iv key"
	icon_state = "brownkey"
	lockid = "apartment4"

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
