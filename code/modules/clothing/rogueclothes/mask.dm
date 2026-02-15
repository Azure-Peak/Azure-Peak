/obj/item/clothing/mask/rogue/MiddleClick(mob/user) 
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear \the [src] under my hair" : "wear \the [src] over my hair"]."))
	if(overarmor)
		alternate_worn_layer = HOOD_LAYER //Below Hair Layer
	else
		alternate_worn_layer = BACK_LAYER //Above Hair Layer
	user.update_inv_wear_mask()

/obj/item/clothing/mask/rogue
	name = ""
	icon = 'icons/roguetown/clothing/masks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/masks.dmi'
	body_parts_covered = FACE
	slot_flags = ITEM_SLOT_MASK
	experimental_inhand = FALSE
	experimental_onhip = FALSE
	var/overarmor = TRUE

/obj/item/clothing/mask/rogue/attack_right(mob/user)
	. = ..()

	if(!adjustable && initial(flags_inv) & HIDEFACE)
		flags_inv ^= HIDEFACE
		to_chat(user, span_notice("I adjust mask to [flags_inv & HIDEFACE ? "conceal" : "reveal"] identity."))
		user.update_inv_wear_mask()

/obj/item/clothing/mask/rogue/AltRightClick(mob/user)
	if(!istype(loc, /mob/living/carbon))
		return
	var/mob/living/carbon/H = user
	if(icon_state == "[initial(icon_state)]_snout")
		icon_state = initial(icon_state)
		H.update_inv_wear_mask()
		update_icon()
		return

	var/icon/J = new('icons/roguetown/clothing/onmob/masks.dmi')
	var/list/istates = J.IconStates()
	for(var/icon_s in istates)
		if(findtext(icon_s, "[icon_state]_snout"))
			icon_state += "_snout"
			H.update_inv_wear_mask()
			update_icon()
			return

/obj/item/clothing/mask/rogue/examine()
	. = ..()

	. += "[span_notice("Alt+RMB while on face to swap sprites between snout and standard variant, if it exists.")]"

/obj/item/clothing/mask/rogue/spectacles
	name = "spectacles"
	icon_state = "glasses"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 20
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	anvilrepair = /datum/skill/craft/armorsmithing
//	block2add = FOV_BEHIND

/obj/item/clothing/mask/rogue/spectacles/inq
	name = "otavan nocshade lens-pair"
	icon_state = "bglasses"
	desc = "Made to both ENDURE and incite debate within those few Noc-Sainted within Otava. Noc-lit walks, yae or nae? The lenses look like they can be brushed aside with a carefully guided right-pointer finger led motion."
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 300
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HEAD
	anvilrepair = /datum/skill/craft/armorsmithing
	var/lensmoved = FALSE

/obj/item/clothing/mask/rogue/spectacles/inq/spawnpair
	lensmoved = TRUE

/obj/item/clothing/mask/rogue/spectacles/inq/equipped(mob/user, slot)
	..()

	if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		if(!lensmoved)
			ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			return

/obj/item/clothing/mask/rogue/spectacles/inq/update_icon(mob/user, slot)	
	cut_overlays()
	..()
	if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		var/mutable_appearance/redlenses = mutable_appearance(mob_overlay_icon, "bglasses_glow")
		redlenses.layer = 19
		redlenses.plane = 20
		user.add_overlay(redlenses)	

/obj/item/clothing/mask/rogue/spectacles/inq/attack_right(mob/user, slot)
	..()

	if(!lensmoved)
		to_chat(user, span_info("You discreetly slide the inner lenses out of the way."))
		REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
		lensmoved = TRUE
		return
	to_chat(user, span_info("You discreetly slide the inner lenses back into place."))
	ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
	lensmoved = FALSE

/obj/item/clothing/mask/rogue/spectacles/inq/dropped(mob/user, slot)
	..()		
	if(slot != SLOT_WEAR_MASK || slot == SLOT_HEAD)
		if(!lensmoved)
			REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			return
		lensmoved = FALSE

/obj/item/clothing/mask/rogue/spectacles/golden
	name = "golden spectacles"
	icon_state = "goggles"
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	max_integrity = 35
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	anvilrepair = /datum/skill/craft/armorsmithing
	adjustable = CAN_CADJUST
	var/active_item = FALSE

/obj/item/clothing/mask/rogue/spectacles/golden/equipped(mob/user, slot)
	..()
	if(active_item)
		return
	else if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		if (user.get_skill_level(/datum/skill/craft/engineering) >= 2)
			ADD_TRAIT(user, TRAIT_ENGINEERING_GOGGLES, "[type]")
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/engineeranalyze)
			to_chat(user, span_notice("Time to build"))
			active_item = TRUE
			return
		else 
			to_chat(user, span_notice("I can't understand these words and numbers before my eyes"))
			return
	else
		return

				
		
		

/obj/item/clothing/mask/rogue/spectacles/golden/dropped(mob/user, slot)
	..()
	if(active_item)
		active_item = FALSE
		REMOVE_TRAIT(user, TRAIT_ENGINEERING_GOGGLES, "[type]")
		user.mind.RemoveSpell(new /obj/effect/proc_holder/spell/invoked/engineeranalyze)
		to_chat(user, span_notice("Time to stop working"))

/obj/item/clothing/mask/rogue/spectacles/golden/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))	//Standard mask

/obj/item/clothing/mask/rogue/spectacles/Initialize()
	..()
	AddComponent(/datum/component/spill, null, 'sound/blank.ogg')

/obj/item/clothing/mask/rogue/spectacles/Crossed(mob/crosser)
	if(isliving(crosser) && !obj_broken)
		take_damage(11, BRUTE, "blunt", 1)
	..()

/obj/item/clothing/mask/rogue/equipped(mob/user, slot)
	..()
	user.update_fov_angles()

/obj/item/clothing/mask/rogue/dropped(mob/user)
	..()
	user.update_fov_angles()

/obj/item/clothing/mask/rogue/eyepatch
	name = "eyepatch"
	desc = "An eyepatch, fitted for the right eye."
	icon_state = "eyepatch"
	max_integrity = 20
	integrity_failure = 0.5
	block2add = FOV_RIGHT
	body_parts_covered = EYES
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/eyepatch/left
	desc = "An eyepatch, fitted for the left eye."
	icon_state = "eyepatch_l"
	block2add = FOV_LEFT

/obj/item/clothing/mask/rogue/lordmask
	name = "golden halfmask"
	desc = "Half of your face turned gold."
	icon_state = "lmask"
	sellprice = 50
	anvilrepair = /datum/skill/craft/armorsmithing
	resistance_flags = FIRE_PROOF

/obj/item/clothing/mask/rogue/lordmask/l
	icon_state = "lmask_l"

/obj/item/clothing/mask/rogue/lordmask/tarnished
	name = "tarnished golden halfmask"
	desc = "Runes and wards, meant for daemons; the gold has somehow rusted in unnatural, impossible agony. The gold is now worthless, but that is not why the Naledi wear them."
	sellprice = 20

////////////////////////
// Triumph Exclusive! //
////////////////////////

//Purchasable via Triumphs. Blacklisted from the Stockpile and fitted with a reduced saleprice.
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

//

/obj/item/clothing/mask/rogue/sack
	name = "sack mask"
	desc = "A brown sack with eyeholes cut into it."
	icon_state = "sackmask"
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	max_integrity = 200
	prevent_crits = list(BCLASS_BLUNT)
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	flags_inv = HIDEFACE|HIDESNOUT|HIDEHAIR|HIDEEARS
	body_parts_covered = FACE|HEAD
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	armor = ARMOR_PADDED 
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/sack/psy
	name = "psydonic sack mask"
	desc = "An ordinary brown sack. This one has eyeholes cut into it, bearing a crude chalk drawing of Psydon's cross upon its visage. Unsettling for most."
	icon_state = "sackmask_psy"

/obj/item/clothing/mask/rogue/facemask/steel/confessor
	name = "strange mask"
	desc = "It is said that the original version of this mask was used for obscure rituals prior to the fall of the Empire of the Holy Celestia, and now it has been repurposed as a veil for the cunning hand of the Otavan Orthodoxy.<br> <br>Others say it is a piece of heresy, a necessary evil, capable of keeping its user safe from left-handed magicks. You can taste copper whenever you draw breath."
	icon_state = "confessormask"
	max_integrity = 200
	equip_sound = 'sound/items/confessormaskon.ogg'
	smeltresult = /obj/item/ingot/steel	
	var/worn = FALSE
	slot_flags = ITEM_SLOT_MASK
	stack_fovs = FALSE
	
/obj/item/clothing/mask/rogue/facemask/steel/confessor/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(user.wear_mask == src)
		worn = TRUE

/obj/item/clothing/mask/rogue/facemask/steel/confessor/dropped(mob/user)
	. = ..()
	if(worn)
		playsound(user, 'sound/items/confessormaskoff.ogg', 80)
		worn = FALSE

/obj/item/clothing/mask/rogue/facemask/steel/confessor/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/clothing/mask/rogue/spectacles/inq))
		user.visible_message(span_warning("[user] starts to insert [I]'s lenses into [src]."))
		if(do_after(user, 4 SECONDS))
			var/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed/P = new /obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(P)
			P.obj_integrity = src.obj_integrity
			qdel(src)
			qdel(I)
		else
			user.visible_message(span_warning("[user] stops inserting the lenses into [src]."))
		return		

/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed
	name = "stranger mask"
	desc = "It is said that the original version of this mask was used for obscure rituals prior to the fall of the Empire of the Holy Celestia, and now it has been repurposed as a veil for the cunning hand of the Otavan Orthodoxy.<br> <br>Others say it is a piece of heresy, a necessary evil, capable of keeping its user safe from left-handed magicks. You can taste copper whenever you draw breath."
	icon_state = "confessormask_lens"
	var/lensmoved = TRUE

/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed/equipped(mob/user, slot)
	..()
	if(slot == SLOT_WEAR_MASK || slot == SLOT_HEAD)
		if(!lensmoved)
			ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			return

/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed/attack_right(mob/user, slot)
	..()
	if(!lensmoved)
		to_chat(user, span_info("You discreetly slide the inner lenses out of the way."))
		REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
		lensmoved = TRUE
		return
	to_chat(user, span_info("You discreetly slide the inner lenses back into place."))
	ADD_TRAIT(user, TRAIT_NOCSHADES, "redlens")
	lensmoved = FALSE

/obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed/dropped(mob/user, slot)
	..()		
	if(slot != SLOT_WEAR_MASK || slot == SLOT_HEAD)
		if(!lensmoved)
			REMOVE_TRAIT(user, TRAIT_NOCSHADES, "redlens")
			return	

/obj/item/clothing/mask/rogue/wildguard
	name = "wild guard"
	desc = "A mask shaped after the snarling beasts of Dendor."
	icon_state = "wildguard"
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	max_integrity = 100
	resistance_flags = FIRE_PROOF
	armor = ARMOR_PLATE
	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	stack_fovs = TRUE

/obj/item/clothing/mask/rogue/facemask
	name = "iron mask"
	desc = "A simple, utilitarian mask designed to protect the face from oncoming blows."
	icon_state = "imask"
	max_integrity = 100
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	resistance_flags = FIRE_PROOF
	armor = ARMOR_PLATE
	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	experimental_onhip = TRUE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/iron
	stack_fovs = TRUE

/obj/item/clothing/mask/rogue/facemask/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/mask/rogue/facemask/shadowfacemask
	name = "anthraxi war mask"
	desc = "A metal mask resembling a spider's face. Such a visage haunts many an older dark elf's nitemares - while the younger generation simply scoffs at such relics."
	icon_state = "shadowfacemask"
	smeltresult = /obj/item/ingot/drow
	smelt_bar_num = 1

/obj/item/clothing/mask/rogue/facemask/aalloy
	name = "decrepit mask"
	desc = "Frayed bronze, molded into an unblinking visage. Only the statues, buried within the innards of Mount Decapitation, share its wrinkled lip and sneer of cold command."
	icon_state = "ancientmask"
	max_integrity = 75
	color = "#bb9696"
	chunkcolor = "#532e25"
	material_category = ARMOR_MAT_PLATE
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	prevent_crits = PREVENT_CRITS_NONE

/obj/item/clothing/mask/rogue/facemask/copper
	name = "copper mask"
	icon_state = "cmask"
	desc = "A heavy copper mask that conceals and protects the face, though not very effectively."
	armor = ARMOR_PLATE_BAD
	smeltresult = /obj/item/ingot/copper

/obj/item/clothing/mask/rogue/facemask/psydonmask
	name = "psydonic mask"
	desc = "A silver mask, forever locked in a rigor of uncontestable joy. The Order of Saint Xylix can't decide on whether it's meant to represent Psydon's 'mirthfulness,' 'theatricality,' or the unpredictable melding of both."
	icon_state = "psydonmask"
	item_state = "psydonmask"

/obj/item/clothing/mask/rogue/facemask/steel
	name = "steel mask"
	desc = "Expressionless steel sits where a face ought to be. It is better to be \
	safe than to be known."
	icon_state = "smask"
	max_integrity = 200
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/mask/rogue/facemask/steel/paalloy
	name = "ancient mask"
	desc = "Polished gilbranze, molded into an intimidating visage. Touch the cheek; it is warm, \
	like flesh. But it is not flesh. Not yet."
	icon_state = "ancientmask"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/mask/rogue/facemask/steel/steppesman
	name = "steppesman war mask"
	desc = "A steel mask shaped like the face of a rather charismatic fellow! Pronounced cheeks, a nose, and a large mustache. Well, people outside of Aavnr don't think you'd look charismatic at all wearing this."
	max_integrity = 250
	icon_state = "steppemask"
	layer = HEAD_LAYER

/obj/item/clothing/mask/rogue/facemask/steel/steppesman/anthro
	name = "steppesman beast mask"
	desc = "A steel mask shaped like the face of a rather charismatic beastman! Pronounced cheeks, a nose, and small spikes for whiskers. Well, people outside of Aavnr don't think you'd look charismatic at all wearing this."
	icon_state = "steppemask_snout"

/obj/item/clothing/mask/rogue/facemask/goldmask
	name = "gold mask"
	icon_state = "goldmask"
	max_integrity = 150
	sellprice = 100
	smeltresult = /obj/item/ingot/gold

/obj/item/clothing/mask/rogue/facemask/goldmaskc
	name = "gold mask"
	icon_state = "goldmaskc"
	max_integrity = 150
	sellprice = 100
	smeltresult = /obj/item/ingot/gold

/obj/item/clothing/mask/rogue/facemask/yoruku_oni
	name = "oni mask"
	desc = "A wood mask carved in the visage of demons said to stalk the mountains of Kazengun."
	icon_state = "oni"
	stack_fovs = FALSE

/obj/item/clothing/mask/rogue/facemask/yoruku_kitsune
	name = "kitsune mask"
	desc = "A wood mask carved in the visage of the fox spirits said to ply their tricks in the forests of Kazengun."
	icon_state = "kitsune"
	stack_fovs = FALSE

/obj/item/clothing/mask/rogue/facemask/steel/kazengun
	name = "soldier's half-mask"
	desc = "\"The first lesson of war is that it would be better to live in peace.\""
	block2add = null
	armor = ARMOR_PLATE_BAD // because it's only half
	icon_state = "kazengunmouthguard"
	item_state = "kazengunmouthguard"

/obj/item/clothing/mask/rogue/facemask/steel/kazengun/full
	name = "ogre mask"
	desc = "\"The second lesson: Rich men have dreams. Poor men die to make them come true.\""
	icon_state = "kazengunfaceguard"
	item_state = "kazengunfaceguard"

/obj/item/clothing/mask/rogue/shepherd
	name = "halfmask"
	icon_state = "shepherd"
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	block2add = null
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	experimental_onhip = TRUE
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/shepherd/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))	//Standard mask

/obj/item/clothing/mask/rogue/shepherd/shadowmask
	name = "purple halfmask"
	icon_state = "shadowmask"
	desc = "For when one wants to conceal their face while performing dastardly deeds in the name of the crown."

/obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
	desc = "Tiny drops of white dye mark its front, not unlike teeth. A smile that leers from shadow."

/obj/item/clothing/mask/rogue/physician
	name = "plague mask"
	desc = "What better laboratory than the blood-soaked battlefield?"
	icon_state = "physmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	body_parts_covered = FACE|EYES|MOUTH
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/mask/rogue/skullmask
	name = "skull mask"
	desc = "A mask in the shape of a skull, designed to terrify."
	icon_state = "skullmask"
	max_integrity = 100
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	resistance_flags = FIRE_PROOF
	armor = ARMOR_PADDED_BAD
	prevent_crits = null
	flags_inv = HIDEFACE|HIDESNOUT
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	experimental_onhip = TRUE
	smeltresult = /obj/item/natural/bone
	salvage_result = /obj/item/natural/bone
	salvage_amount = 1

/obj/item/clothing/mask/rogue/ragmask
	name = "rag mask"
	icon_state = "ragmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	experimental_onhip = TRUE
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/ragmask/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))	//Standard mask

/obj/item/clothing/mask/rogue/ragmask/red //predyed mask for NPCs
	color = CLOTHING_RED

/obj/item/clothing/mask/rogue/ragmask/black
	color = CLOTHING_BLACK

/obj/item/clothing/mask/rogue/lordmask/naledi
	name = "war scholar's mask"
	item_state = "naledimask"
	icon_state = "naledimask"
	desc = "Runes and wards, meant for daemons; the gold has somehow rusted in unnatural, impossible agony. The most prominent of these etchings is in the shape of the Naledian psycross. Armored to protect the wearer's face."
	max_integrity = 100
	armor = ARMOR_PLATE
	flags_inv = HIDEFACE|HIDESNOUT
	sellprice = 0

/obj/item/clothing/mask/rogue/lordmask/naledi/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_NALEDI, "naledi_mask")

/obj/item/clothing/mask/rogue/lordmask/naledi/sojourner
	name = "sojourner's mask"
	item_state = "naledimask"
	icon_state = "naledimask"
	desc = "A golden mask, gnarled by the sustained agonies of djinnic corruption; yet as long as its Naledian hexes endure, so too will its wearer. Hand-fitted shingles flank the sides to repel incoming strikes. </br>'..Clad with the stereotype of abruptly disappearing without any forewarning, the typical Sojourner is in constant pursuit of diversifying their erudition. One might arrive to learn the local witch's recipe of sanctifying atropa extract and spend yils in the community trying to master it, while another might work alongside the region's Orthodoxic chapter to slay a lycker lord in exchange for his archive, only to vanish the very next day..'"
	max_integrity = 150
	armor = ARMOR_PLATE
	flags_inv = HIDEFACE|HIDESNOUT
	sellprice = 0

/obj/item/clothing/mask/rogue/exoticsilkmask
	name = "exotic silk mask"
	icon_state = "exoticsilkmask"
	flags_inv = HIDEFACE|HIDEFACIALHAIR
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	sewrepair = TRUE
	adjustable = CAN_CADJUST
	toggle_icon_state = FALSE
	salvage_result = /obj/item/natural/silk
	salvage_amount = 2

/obj/item/clothing/mask/rogue/exoticsilkmask/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, NECK, null, null, 'sound/foley/equip/rummaging-03.ogg', null, (UPD_HEAD|UPD_MASK))	//Standard mask

/obj/item/clothing/mask/rogue/blindfold
	name = "blindfold"
	desc = "A strip of cloth tied around the eyes to block vision."
	icon_state = "blindfold"
	item_state = "blindfold"
	body_parts_covered = EYES
	sewrepair = TRUE
	tint = 3
	mob_overlay_icon = 'icons/mob/clothing/eyes.dmi'
	icon = 'icons/obj/clothing/glasses.dmi'

/obj/item/clothing/mask/rogue/blindfold/fake
	desc = "A strip of cloth tied around the eyes. It's too transparent to block vision."
	tint = 0

/obj/item/clothing/mask/rogue/duelmask
	name = "duelist's mask"
	desc = "A black cloth mask for those masked duelists, doesn't grant any protection, but covers your eyes, and your identity... somehow."
	icon_state = "duelmask"
	flags_inv = HIDEFACE
	body_parts_covered = EYES
	slot_flags = ITEM_SLOT_MASK
	color = COLOR_ALMOST_BLACK	
	detail_tag = "_detail"
	detail_color = COLOR_SILVER
	sewrepair = TRUE

/obj/item/clothing/mask/rogue/courtphysician
	name = "head physician's mask"
	desc = "This one is made with actual bone! Don't ask whose."
	icon = 'icons/roguetown/clothing/special/courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/courtphys.dmi'
	icon_state = "docmask"
	item_state = "docmask"
	salvage_result = /obj/item/natural/bone

//gemcarved masks from Vanderlin

/obj/item/clothing/mask/rogue/facemask/carved
	name = "carved mask"
	icon_state = "ancientmask"
	desc = "You shouldn't be seeing this."
	max_integrity = 50
	blocksound = PLATEHIT
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	flags_inv = HIDEFACE
	body_parts_covered = FACE
	block2add = FOV_BEHIND
	slot_flags = ITEM_SLOT_MASK|ITEM_SLOT_HIP
	anvilrepair = /datum/skill/craft/armorsmithing //Maybe these shouldn't be repairable, someone else can do that if they want.
	clothing_flags = CANT_SLEEP_IN
	sellprice = 70
	smeltresult = null
	salvage_result = null

/obj/item/clothing/mask/rogue/facemask/carved/jademask
	name = "jade mask "
	icon_state = "mask_jade"
	desc = "A jade mask that both conceals and protects the face."
	sellprice = 70

/obj/item/clothing/mask/rogue/facemask/carved/jademask
	name = "jade mask"
	icon_state = "mask_jade"
	desc = "A jade mask that both conceals and protects the face."
	sellprice = 70

/obj/item/clothing/mask/rogue/facemask/carved/turqmask
	name = "cerulite mask"
	icon_state = "mask_turq"
	desc = "A cerulite mask that both conceals and protects the face."
	sellprice = 95

/obj/item/clothing/mask/rogue/facemask/carved/rosemask
	name = "rosestone mask"
	icon_state = "mask_rose"
	desc = "A rosestone mask that both conceals and protects the face."
	sellprice = 35

/obj/item/clothing/mask/rogue/facemask/carved/shellmask
	name = "shell mask"
	icon_state = "mask_shell"
	desc = "A shell mask that both conceals and protects the face."
	sellprice = 30

/obj/item/clothing/mask/rogue/facemask/carved/coralmask
	name = "heartstone mask"
	icon_state = "mask_coral"
	desc = "An heartstone mask that both conceals and protects the face."
	sellprice = 80

/obj/item/clothing/mask/rogue/facemask/carved/ambermask
	name = "amber mask"
	icon_state = "mask_amber"
	desc = "A amber mask that both conceals and protects the face."
	sellprice = 70

/obj/item/clothing/mask/rogue/facemask/carved/onyxamask
	name = "onyxa mask"
	icon_state = "mask_onyxa"
	desc = "An onyxa mask that both conceals and protects the face."
	sellprice = 50

/obj/item/clothing/mask/rogue/facemask/carved/opalmask
	name = "opal mask"
	icon_state = "mask_opal"
	desc = "An opal mask that both conceals and protects the face."
	sellprice = 100
