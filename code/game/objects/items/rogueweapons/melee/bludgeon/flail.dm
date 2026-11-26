/obj/item/rogueweapon/flail
	name = "flail"
	desc = "A spiked macehead and wooden handle, linked together with a length of chain. It can be spun around to smash armored opponents with tremendous force, cracking plate and bone alike with unflinching impunity."
	icon_state = "iflail"
	icon = 'icons/roguetown/weapons/blunt32.dmi'
	force = 25
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/flail/smash, /datum/intent/flail/bash)
	sharpness = IS_BLUNT
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	//dropshrink = 0.75
	max_integrity = 150
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	associated_skill = /datum/skill/combat/whipsflails
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_LARGE
	throwforce = 5
	wdefense = 0
	minstr = 4
	grid_width = 32
	grid_height = 96
	special = /datum/special_intent/flail_sweep

/obj/item/rogueweapon/flail/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -2,"wx" = -7,"wy" = -3,"ex" = 3,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 22,"sturn" = -23,"wturn" = -23,"eturn" = 29,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/flail/alt
	desc = "A studded macehead and wooden handle, linked together with a length of chain. It can be spun around to smash armored opponents with tremendous force, cracking plate and bone alike with unflinching impunity."
	icon_state = "iflailalt"

/obj/item/rogueweapon/flail/cleric
	name = "anointed flail"
	icon_state = "crusaderflail"
	desc = "A crusader's morning star, adorned with a head of cold iron and blessed to smite evil. Though this blessed alloy lacks the strength to \
	sunder those who bear greater curses, it nevertheless channels enough power to dispel the lesser curses of mindless fiends-and-foes."
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/flail/smash/ranged, /datum/intent/flail/bash)
	max_integrity = 200 //+50
	minstr = 12
	is_even_lesser_silver = TRUE // adv paladin exclusive weapon, works like unblessed silver but only in pve

/obj/item/rogueweapon/flail/ancient/decrepit
	name = "decrepit flail"
	desc = "A spiked ball of rotted metal, chained to a rotwooden handle. The chains groan with every twirl, strained by forces it hadn't felt in millennia; swing it a bit too hard, and there's a chance that the flailhead might completely fly off."
	icon_state = "aflail"
	force = 22
	max_integrity = 75
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/rogueweapon/flail/ancient
	name = "ancient flail"
	desc = "A spiked ball of polished gilbranze, chained to a reinforced handle. They say that His children worshipped the flail above all else, for its twirls replicated the Comet Syon's blazing flights."
	icon_state = "aflail"
	smeltresult = /obj/item/ingot/aaslag
	force = 30

/obj/item/rogueweapon/flail/bronze
	name = "bronze flail"
	desc = "A studded weight and a whittled handle, linked together with a length of bronze chain. It can be spun around to smash armored opponents with tremendous force, cracking plate and bone alike with unflinching impunity."
	icon_state = "bronzeflail"
	force = 27
	throwforce = 20
	max_integrity = 125
	smeltresult = /obj/item/ingot/bronze
	minstr = 7

/obj/item/rogueweapon/flail/steel
	desc = "A flanged macehead and a carved handle, linked together with a length of steel chain. It can be spun around to smash armored opponents with tremendous force, cracking plate and bone alike with unflinching impunity."
	icon_state = "flail"
	smeltresult = /obj/item/ingot/steel
	minstr = 5
	force = 30

/obj/item/rogueweapon/flail/steel/holysee
	name = "holy see flail"
	desc = "A blessed flail, oft conflicts arise betwixt the Otavian Orthodoxy and Holy See on the origins \
			being betwixt Psydon and Noc being the origin of such weapon, regardless against the forces of evil, \
			it serves one absolute truth - smashing through plate and skull of Heathen and Heretic alike. Often favored \
			by Xylix's following for theatrics but also curiously Noc's following as a ceremonial tool of war."
	icon_state = "churchflail"
	wlength = WLENGTH_LONG

/obj/item/rogueweapon/flail/silver
	name = "silver morningstar"
	desc = "A heavy, silver flail. It follows the Grenzelhoftian design of a 'morning star', utilizing a longer chain to extend its reach."
	icon_state = "silverflail"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/flail/smash/ranged, /datum/intent/flail/bash)
	smeltresult = /obj/item/ingot/silver
	minstr = 5
	force = 30
	is_silver = TRUE

/obj/item/rogueweapon/flail/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE\
	)

/obj/item/rogueweapon/flail/silver/necra
	name = "swift journey"
	desc = "The striking head is full of teeth, rattling viciously with every strike, with every rotation. Each set coming from one the wielder has laid to rest. Carried alongside them as a great show of respect."
	icon_state = "necraflail"
	force = 35
	is_silver = TRUE

/obj/item/rogueweapon/flail/silver/necra/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE\
	)

/obj/item/rogueweapon/flail/silver/psy
	name = "psydonic flail"
	desc = "An ornate flail, plated in a ceremonial veneer of silver. Its flanged head can crumple even the toughest of darksteel-maille."
	icon_state = "psyflail"
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/flail/silver/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN\
	)

/obj/item/rogueweapon/flail/silver/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN\
	)

/obj/item/rogueweapon/flail/silver/psy/relic
	name = "\"Consecratia\""
	desc = "The weight of His anguish, His pain, His hope and His love for humenkind - all hanging on the ornamental silver-steel head chained to this arm. <br><br>A declaration of love for all that Psydon lives for, and a crushing reminder to the arch-nemesis that they will not triumph as long as He endures."
	icon_state = "psymorningstar"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/flail/smash/ranged, /datum/intent/flail/bash)
	force = 35
	minstr = 11
	max_integrity = 250

/obj/item/rogueweapon/flail/silver/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN\
	)

/obj/item/rogueweapon/flail/blacksteel
	name = "blacksteel flail"
	desc = "An elegant flail of blacksteel. The heftsome weight makes it unmatched for driving back plate-armored opponents, so long as one \
	has the stamina to swing its alloyed chains around."
	icon_state = "bs_flail"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/flail/smash, /datum/intent/flail/bash, /datum/intent/flail/sweep)
	smeltresult = /obj/item/ingot/blacksteel
	max_integrity = 250
	minstr = 12
	force = 35

//Greatflails. Two-handed flails. You get the jist.
/obj/item/rogueweapon/flail/great
	name = "militia thresher"
	desc = "Just like how a sling's bullet can fell a giant, so too does this great flail follow the principle of converting 'momentum' into 'plate-rupturing force'."
	icon_state = "great"
	icon = 'icons/roguetown/weapons/blunt64.dmi'
	force = 10
	force_wielded = 35
	possible_item_intents = list(/datum/intent/flail/strike)
	gripped_intents = list(/datum/intent/flail/strike/ranged, /datum/intent/flail/smash/ranged, /datum/intent/flail/sweep)
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = null
	minstr = 9
	wbalance = WBALANCE_HEAVY
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/whipsflails
	anvilrepair = /datum/skill/craft/carpentry
	dropshrink = 0.9
	wdefense = 4
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/flail/great/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)

/obj/item/rogueweapon/flail/great/iron
	name = "greatflail"
	desc = "The lucerne's ungainly cousin, favoring a 'ball-and-chain' design that - once spun - can devastate anything caught in its way; a trait that makes it dearly beloved by both peasantry and knights alike."
	icon_state = "greatflail"
	wdefense = 6
	minstr = 12
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/flail/great/steel
	name = "steel greatflail"
	desc = "The greatflail's noblehearted brother, rebuking unruly assailants with a sextuple-spiked countermeasure."
	force = 15
	wdefense = 6
	minstr = 12
	icon_state = "sgreatflail"
	smeltresult = /obj/item/ingot/steel
	max_integrity = 200
	//gripped_intents = list(/datum/intent/flail/strike/ranged, /datum/intent/flail/smash/ranged, /datum/intent/flail/sweep, /datum/intent/flail/smash/heavy)

/obj/item/rogueweapon/flail/great/matthios
	name = "gilded flail"
	desc = "Weight of wealth in a deadly striking end."
	icon_state = "matthiosflail"
	sellprice = 250
	smeltresult = /obj/item/ingot/steel
	possible_item_intents = list(/datum/intent/flail/strike/ranged/matthios)
	no_loot_taint = TRUE
	gripped_intents = list(/datum/intent/flail/strike/ranged/matthios, /datum/intent/flail/smash/ranged/matthios, /datum/intent/flail/sweep)
	max_integrity = 400 //You're supposed to be parrying with this, I guess. 7 defense, so 400 integrity is the bare minimum for this to be usable without having to turn combat mode off after 60 seconds.
	associated_skill = /datum/skill/combat/whipsflails
	slot_flags = ITEM_SLOT_BACK
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/component/matthios

/obj/item/rogueweapon/flail/great/matthios/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_FREEMAN, "FLAIL")

/obj/item/rogueweapon/flail/great/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_MATTHIOS_WEAPON)

// Unique Flails.
/obj/item/rogueweapon/flail/militia
	name = "militia flail"
	desc = "In another lyfe, this humble thresher was used to pound stalks into grain. Under a militiaman's grasp, however, it has found a new purpose: to humble overconfident bandits with crippling blows."
	icon_state = "milflail"
	possible_item_intents = list(/datum/intent/flail/strike, /datum/intent/flail/smash/militia)
	force = 27
	wdefense = 3
	wbalance = WBALANCE_HEAVY
