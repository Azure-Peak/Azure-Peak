/obj/item/rogueweapon/shield
	name = ""
	desc = ""
	icon_state = ""
	icon = 'icons/roguetown/weapons/shields32.dmi'
	slot_flags = ITEM_SLOT_BACK
	flags_1 = null
	force = 10
	throwforce = 5
	throw_speed = 1
	throw_range = 3
	w_class = WEIGHT_CLASS_BULKY
	possible_item_intents = list(SHIELD_BASH, SHIELD_BLOCK, SHIELD_SMASH)
	block_chance = 0
	sharpness = IS_BLUNT
	wlength = WLENGTH_SHORT
	resistance_flags = FLAMMABLE
	can_parry = TRUE
	associated_skill = /datum/skill/combat/shields		//Trained via blocking or attacking dummys with; makes better at parrying w/ shields.
	wdefense = 10										//should be pretty baller
	var/coverage = 50
	var/heraldry_state = null
	var/heraldry_preview = null
	var/heraldry_x_offset = 0
	var/heraldry_y_offset = 0
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 100
	anvilrepair = /datum/skill/craft/carpentry
	COOLDOWN_DECLARE(shield_bang)
	special = /datum/special_intent/limbguard

/obj/item/rogueweapon/shield/attackby(obj/item/attackby_item, mob/user, params)

	// Shield banging
	if(src == user.get_inactive_held_item())
		if(istype(attackby_item, /obj/item/rogueweapon))
			if(!COOLDOWN_FINISHED(src, shield_bang))
				return
			user.visible_message(span_danger("[user] bangs [src] with [attackby_item]!"))
			playsound(user.loc, 'sound/combat/shieldbang.ogg', 50, TRUE)
			COOLDOWN_START(src, shield_bang, SHIELD_BANG_COOLDOWN)
			return

	return ..()

/obj/item/rogueweapon/shield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the projectile", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	SEND_SIGNAL(src, COMSIG_ITEM_HIT_REACT, args)
	var/mob/attacker
	var/obj/item/I
	if(attack_type == THROWN_PROJECTILE_ATTACK)
		if(istype(hitby, /obj/item)) // can't trust mob -> item assignments
			I = hitby
		if(I?.thrownby)
			attacker = I.thrownby
	if(attack_type == PROJECTILE_ATTACK)
		var/obj/projectile/P = hitby
		if(P?.firer)
			attacker = P.firer
	if(attacker && istype(attacker))
		if (!owner.can_see_cone(attacker))
			return FALSE
		if(obj_broken) // No blocking with a broken shield you fool
			return FALSE
		if((owner.client?.chargedprog == 100 && owner.used_intent?.tranged) || prob(coverage))
			owner.visible_message(span_danger("[owner] expertly blocks [hitby] with [src]!"))
			src.take_damage(floor(damage / 4))
			return TRUE
	return FALSE

/datum/intent/shield/bash
	name = "bash"
	icon_state = "inbash"
	hitsound = list('sound/combat/shieldbash_wood.ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/shield/bash/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/shield/block
	name = "block"
	icon_state = "inblock"
	tranged = 1 //we can't attack directly with this intent, but we can charge it
	tshield = 1
	chargetime = 1
	hitsound = list('sound/combat/shieldbash_wood.ogg')
	warnie = "shieldwarn"
	item_d_type = "blunt"

/datum/intent/shield/block/prewarning()
	if(mastermob)
		mastermob.visible_message(span_warning("[mastermob] raises [masteritem]!"))
		playsound(mastermob, pick('sound/combat/shieldraise.ogg'), 100, FALSE)

/datum/intent/shield/block/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/mace/smash/shield
	hitsound = list('sound/combat/shieldbash_wood.ogg')

/datum/intent/mace/smash/shield/metal
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/mace/smash/shield/metal/great
	chargetime = 8
	chargedrain = 2
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/datum/intent/effect/daze/shield
	hitsound = list('sound/combat/parry/shield/metalshield (1).ogg')

/obj/item/rogueweapon/shield/wood
	name = "wooden shield"
	desc = "A sturdy wooden shield. Will block anything you can imagine."
	icon_state = "woodsh"
	dropshrink = 0.8
	anvilrepair = /datum/skill/craft/carpentry
	coverage = 30
	heraldry_x_offset = 1
	heraldry_y_offset = -1 // 1px right and down to make it look centered

/obj/item/rogueweapon/shield/wood/deprived
	name = "ghastly shield"
	desc = "A frail looking amalgamation of planks. Yet somehow, the very wood itself seem to be filling you with resolve."
	icon_state = "deprived"
	coverage = 40
	max_integrity = 200

/// Returns list of heraldry names native to this shield type (stripped of prefix)
/obj/item/rogueweapon/shield/proc/get_heraldry_options()
	var/static/list/cached_by_type = list()
	if(!cached_by_type[icon_state])
		var/list/options = list()
		var/icon/J = new('icons/roguetown/weapons/legacy_shield_heraldry.dmi')
		for(var/s in J.IconStates())
			if(findtext(s, "[icon_state]_") == 1)
				options += copytext(s, length("[icon_state]_") + 1)
		cached_by_type[icon_state] = sortList(options)
	return cached_by_type[icon_state]

/// Returns list of generic flat heraldry states from shield_heraldry_flat.dmi
/obj/item/rogueweapon/shield/proc/get_other_heraldry_options()
	var/static/list/cached_flat = null
	if(!cached_flat)
		cached_flat = list()
		var/icon/J = new('icons/roguetown/weapons/shield_heraldry_flat.dmi')
		for(var/s in J.IconStates())
			if(length(s))
				cached_flat += s
		cached_flat = sortList(cached_flat)
	return cached_flat

/* Mask a heraldry icon to only show within the paintable area of the shields. To create these masks, I copied the existing shield sprites and then applied a 7-color bright greyscale palette, mapping darkest to brightest in this order:
- #B8B8B8, #C2C2C2, #CCCCCC, #D6D6D6, #E2E2E2, #EFEFEF, #FFFFFF
- For kite shield I specifically applied dark edges to the side to create the illusion of edge
- This was done with Aseprite's Replace Color tool. Wooden Shield has 7 colors, Kite & Heater had 8, and Iron had something like 15. I compressed the rest's range.
- Iron Shield had like 7 colors that were just a tiny variation with one pixel it felt like - so I just compressed literally all of them into E2E2E2 with no actual loss of fidelity. 
- If you want edge, boss, rims etc. to be dynamically excluded just paint them transparent.
- This applies a shading and 3D depth to a flat heraldry, and allows us to in the future uses heraldry across multiple shields. For now, since I have no art skills I cannot retroactively convert the existing per shield heraldry to a flat heraldry that is then, applied dynamically on top.
- But once artist catch up to my work this will enables us to share 1 heraldry across 4 or more shields with very simple work.
*/
/obj/item/rogueweapon/shield/proc/mask_heraldry_to_shield(heraldry_state_name)
	var/icon/heraldry
	var/list/flat_states = icon_states('icons/roguetown/weapons/shield_heraldry_flat.dmi')
	var/is_flat = (heraldry_state_name in flat_states)
	if(is_flat)
		heraldry = new /icon('icons/roguetown/weapons/shield_heraldry_flat.dmi', heraldry_state_name)
	else
		heraldry = new /icon('icons/roguetown/weapons/legacy_shield_heraldry.dmi', heraldry_state_name)

	if(is_flat && (heraldry_x_offset || heraldry_y_offset))
		if(heraldry_x_offset > 0)
			heraldry.Shift(EAST, heraldry_x_offset)
		else if(heraldry_x_offset < 0)
			heraldry.Shift(WEST, abs(heraldry_x_offset))
		if(heraldry_y_offset > 0)
			heraldry.Shift(NORTH, heraldry_y_offset)
		else if(heraldry_y_offset < 0)
			heraldry.Shift(SOUTH, abs(heraldry_y_offset))

	var/mask_state = "[icon_state]_mask"
	var/icon/mask = new /icon('icons/roguetown/weapons/shield_heraldry_masks.dmi', mask_state)
	heraldry.Blend(mask, ICON_MULTIPLY)
	return heraldry

/obj/item/rogueweapon/shield/proc/apply_heraldry(full_state)
	cut_overlays()
	heraldry_state = full_state
	heraldry_preview = null
	if(full_state)
		var/icon/masked = mask_heraldry_to_shield(full_state)
		var/mutable_appearance/M = mutable_appearance(masked)
		M.appearance_flags = NO_CLIENT_COLOR
		add_overlay(M)
	update_icon()

/obj/item/rogueweapon/shield/proc/open_heraldry_ui(mob/user)
	var/list/native = get_heraldry_options()
	var/list/others = get_other_heraldry_options()
	if(!length(native) && !length(others))
		to_chat(user, span_warning("No heraldries available."))
		return

	var/datum/browser/menu = new(user, "shield_heraldry", "Shield Heraldry", 800, 650, src)
	var/list/dat = list()
	dat += "<head><style>"
	dat += "body { background-color: #2b2b2b; color: #d4d4d4; font-family: Arial, sans-serif; text-align: center; margin: 8px; }"
	dat += "h3 { margin: 4px 0; color: #c8a84e; }"
	dat += "h4 { margin: 8px 0 4px; color: #a89060; font-size: 13px; }"
	dat += ".preview img, .grid img { image-rendering: pixelated; image-rendering: crisp-edges; }"
	dat += ".grid { display: flex; flex-wrap: wrap; justify-content: center; gap: 4px; margin: 4px 0; }"
	dat += ".hopt { display: inline-block; padding: 3px; border: 2px solid #444; text-align: center; text-decoration: none; color: #d4d4d4; vertical-align: top; }"
	dat += ".hopt:hover { border-color: #c8a84e; }"
	dat += ".hopt.sel { border-color: #ffd700; background-color: #3a3520; }"
	dat += ".hopt small { font-size: 10px; display: block; }"
	dat += ".actions { margin-top: 10px; }"
	dat += ".actions a { color: #c8a84e; text-decoration: none; padding: 4px 12px; border: 1px solid #c8a84e; margin: 0 4px; }"
	dat += ".actions a:hover { background-color: #c8a84e; color: #1a1a1a; }"
	dat += "</style></head>"
	dat += "<body>"
	dat += "<h3>Shield Heraldry</h3>"

	var/active = heraldry_preview || heraldry_state
	dat += "<div class='preview'>"
	if(active)
		var/icon/raw_preview
		var/list/flat_check = icon_states('icons/roguetown/weapons/shield_heraldry_flat.dmi')
		if(active in flat_check)
			raw_preview = new /icon('icons/roguetown/weapons/shield_heraldry_flat.dmi', active)
		else
			raw_preview = new /icon('icons/roguetown/weapons/legacy_shield_heraldry.dmi', active)
		var/icon/masked_heraldry = mask_heraldry_to_shield(active)
		var/icon/combined_preview = new /icon(icon, icon_state)
		combined_preview.Blend(masked_heraldry, ICON_OVERLAY)
		dat += "<img src='data:image/png;base64,[icon2base64(raw_preview)]' width='96' height='96'>"
		dat += "<img src='data:image/png;base64,[icon2base64(combined_preview)]' width='96' height='96'>"
		var/display_name = active
		if(findtext(active, "[icon_state]_") == 1)
			display_name = copytext(active, length("[icon_state]_") + 1)
		dat += "<br>[display_name]"
	else
		var/icon/shield_preview = new /icon(icon, icon_state, SOUTH)
		dat += "<img src='data:image/png;base64,[icon2base64(shield_preview)]' width='96' height='96'>"
		dat += "<br><small>No heraldry selected</small>"
	dat += "</div>"

	if(length(native))
		dat += "<h4>This Shield</h4>"
		dat += "<div class='grid'>"
		for(var/h_name in native)
			var/full = "[icon_state]_[h_name]"
			var/icon/h_icon = new /icon('icons/roguetown/weapons/legacy_shield_heraldry.dmi', full, SOUTH)
			var/sel_class = (active == full) ? " sel" : ""
			dat += "<a href='?src=\ref[src];pick_heraldry=[url_encode(full)]' class='hopt[sel_class]'>"
			dat += "<img src='data:image/png;base64,[icon2base64(h_icon)]' width='48' height='48'>"
			dat += "<small>[h_name]</small></a>"
		dat += "</div>"

	if(length(others))
		dat += "<h4>Generic Heraldry</h4>"
		dat += "<div class='grid'>"
		for(var/full_state in others)
			var/icon/o_raw = new /icon('icons/roguetown/weapons/shield_heraldry_flat.dmi', full_state)
			var/icon/o_masked = mask_heraldry_to_shield(full_state)
			var/sel_class = (active == full_state) ? " sel" : ""
			dat += "<a href='?src=\ref[src];pick_heraldry=[url_encode(full_state)]' class='hopt[sel_class]'>"
			dat += "<img src='data:image/png;base64,[icon2base64(o_raw)]' width='48' height='48'>"
			dat += "<img src='data:image/png;base64,[icon2base64(o_masked)]' width='48' height='48'>"
			dat += "<small>[full_state]</small></a>"
		dat += "</div>"

	dat += "<div class='actions'>"
	if(active)
		dat += "<a href='?src=\ref[src];apply_heraldry=1'>Apply</a>"
	if(heraldry_state)
		dat += "<a href='?src=\ref[src];clear_heraldry=1'>Remove</a>"
	dat += "</div>"
	dat += "</body>"

	menu.set_content("<html>[dat.Join("")]</html>")
	menu.open()

/obj/item/rogueweapon/shield/proc/has_heraldry_mask()
	var/mask_state = "[icon_state]_mask"
	var/list/available = icon_states('icons/roguetown/weapons/shield_heraldry_masks.dmi')
	return (mask_state in available)

/obj/item/rogueweapon/shield/attack_right(mob/user)
	if(!has_heraldry_mask())
		to_chat(user, span_warning("This shield cannot bear heraldry."))
		return ..()
	if(heraldry_state)
		return ..()
	open_heraldry_ui(user)

/obj/item/rogueweapon/shield/Topic(href, href_list)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	if(!usr.canUseTopic(src, BE_CLOSE, NO_DEXTERITY))
		return

	if(href_list["pick_heraldry"])
		heraldry_preview = href_list["pick_heraldry"]
		open_heraldry_ui(usr)
	else if(href_list["apply_heraldry"])
		var/to_apply = heraldry_preview || heraldry_state
		if(to_apply)
			apply_heraldry(to_apply)
		open_heraldry_ui(usr)
	else if(href_list["clear_heraldry"])
		apply_heraldry(null)
		open_heraldry_ui(usr)

/obj/item/rogueweapon/shield/wood/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/tower
	name = "tower shield"
	desc = "A gigantic, iron reinforced shield that covers the entire body, a design-copy of the Aasimar shields of an era gone by."
	icon_state = "shield_tower"
	force = 6
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	wlength = WLENGTH_NORMAL
	resistance_flags = FLAMMABLE
	var/swapped = FALSE
	wdefense = 10
	coverage = 40
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 300
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/shield/tower/holysee
	name = "decablessed shield"
	desc = "A blessed kite shield, said to bestow the Pantheon's protection upon the wielder. A final, staunch line against the darkness. For it's not what is before the shield-carrier that matters, but the home behind them."
	icon_state = "gsshield"
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)	
	wlength = WLENGTH_NORMAL
	resistance_flags = null
	flags_1 = CONDUCT_1
	wdefense = 11
	coverage = 50
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 330
	sellprice = 30

/obj/item/rogueweapon/shield/tower/holysee/MiddleClick(mob/user, params)
	. = ..()
	swapped = !swapped
	update_icon()

/obj/item/rogueweapon/shield/tower/holysee/update_icon()
	. = ..()
	if(swapped)
		icon_state = "gsshielddark"
	else
		icon_state = "gsshield"


/obj/item/rogueweapon/shield/tower/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/tower/metal
	name = "kite shield"
	desc = "A kite-shaped iron shield. Reliable and sturdy."
	icon_state = "kitesh"
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 3
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wlength = WLENGTH_NORMAL
	resistance_flags = null
	flags_1 = CONDUCT_1
	wdefense = 12
	coverage = 60
	heraldry_x_offset = 1 // Shift right by 1px to center flat heraldry.
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 300
	sellprice = 30
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/shield/tower/metal/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
	return ..()

/obj/item/rogueweapon/shield/tower/metal/gold
	name = "golden shield"
	desc = "A resplendant kite shield, assembled from six golden plates that've been hooked together by a glimmering holy sigil. Nobility may be fragile, but - so long as its grip remains steadfast - none could ever hope to sever its weakest link."
	icon_state = "goldshield"
	force = 25
	throwforce = 35
	throw_speed = 1
	throw_range = 3
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wlength = WLENGTH_NORMAL
	resistance_flags = null
	flags_1 = CONDUCT_1
	wdefense = 14
	coverage = 50
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 50
	smeltresult = /obj/item/ingot/gold
	unenchantable = TRUE

/obj/item/rogueweapon/shield/tower/metal/psy
	name = "Covenant"
	desc = "A Psydonian endures. A Psydonian preserves themselves. A Psydonian preserves His flock."
	icon_state = "psyshield"
	force = 15
	throwforce = 5
	throw_speed = 1
	throw_range = 3
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wlength = WLENGTH_NORMAL
	resistance_flags = null
	flags_1 = CONDUCT_1
	wdefense = 14
	coverage = 50
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 350
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/shield/tower/metal/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = -3,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 1,\
	)

/obj/item/rogueweapon/shield/tower/metal/alloy
	name = "decrepit shield"
	desc = "A hefty tower shield, wrought from frayed bronze. Looped with dried kelp and reeking of saltwater, you'd assume that this had been fished out from the remains of a long-sunken warship.. alongside its former legionnaire."
	max_integrity = 120
	wdefense = 9
	icon_state = "ancientsh"
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/rogueweapon/shield/tower/metal/palloy
	name = "ancient shield"
	desc = "A venerable scutum, plated with polished gilbranze. An undying legionnaire's closest friend; that which rebukes arrow-and-bolt alike with unphasing prejudice. It is a reminder - one of many - that Her progress cannot be stopped."
	icon_state = "ancientsh"
	smeltresult = /obj/item/ingot/purifiedaalloy

/obj/item/rogueweapon/shield/tower/raneshen
	name = "rider shield"
	desc = "A shield of Raneshen design. Clever usage of wood, iron, and leather make an impressive match for any weapon."
	icon_state = "desert_rider"
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK)
	force = 25
	throwforce = 25 //for cosplaying captain raneshen
	wdefense = 11
	max_integrity = 220 //not fully metal but not fully wood either
	anvilrepair = /datum/skill/craft/carpentry

/obj/item/rogueweapon/shield/tower/raneshen/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/tower/spidershield
	name = "spider shield"
	desc = "A bulky shield of spike-like lengths molten together. The motifs evoke anything but safety and protection."
	icon_state = "spidershield"
	coverage = 55
	smeltresult = /obj/item/ingot/drow
	smelt_bar_num = 1

/obj/item/rogueweapon/shield/buckler
	name = "buckler shield"
	desc = "A sturdy buckler shield. Will block anything you can imagine."
	icon_state = "bucklersh"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 20
	throwforce = 10
	dropshrink = 0.8
	resistance_flags = null
	possible_item_intents = list(SHIELD_BASH_METAL, SHIELD_BLOCK, SHIELD_SMASH_METAL)
	wdefense = 9
	coverage = 10
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	max_integrity = 130
	associated_skill = /datum/skill/combat/shields
	grid_width = 32
	grid_height = 64
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/shield/buckler/equipped(mob/user, slot, initial)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_GNARLYDIGITS))
		to_chat(user, span_danger("Woe! the handle of the [src] is too small for me to hold onto!"))
		forceMove(user.loc)

/obj/item/rogueweapon/shield/buckler/examine(mob/living/user)
	. = ..()
	. += "Buckler uses the skill of your active weapon to parry. Otherwise it uses your shields skill."

/obj/item/rogueweapon/shield/buckler/proc/bucklerskill(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/bucklerer = user
	var/obj/item/mainhand = bucklerer.get_active_held_item()
	var/weapon_parry = FALSE
	if(mainhand)
		if(mainhand.can_parry)
			weapon_parry = TRUE
	if(istype(mainhand, /obj/item/rogueweapon/shield/buckler))
		associated_skill = /datum/skill/combat/shields
	if(weapon_parry && mainhand.associated_skill && ispath(mainhand.associated_skill, /datum/skill/combat))
		associated_skill = mainhand.associated_skill
	else
		associated_skill = /datum/skill/combat/shields

/obj/item/rogueweapon/shield/buckler/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/buckler/palloy
	name = "ancient buckler"
	desc = "An object once before its time, now out of it. The artisan's hammerstrikes are still visible in the mottled surface, yet \
	the encroach of rust and rot threatens even this memory."
	icon_state = "ancient_buckler"
	max_integrity = 85
	smeltresult = /obj/item/ingot/purifiedaalloy

// unique, better buckler for champion
/obj/item/rogueweapon/shield/buckler/banneret
	name = "'Aegis'"
	desc = "A special buckler made out of blacksteel for the Knight Banneret, adorned with a crest. An inscription along the top reads,\"RUAT CAELUM\""
	icon_state = "capbuckler"
	icon = 'icons/roguetown/weapons/special/captain.dmi'
	max_integrity = 150
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	sellprice = 100 // lets not make it too profitable
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/shield/heater
	name = "heater shield"
	desc = "A sturdy wood and leather shield. Made to not be too encumbering while still providing good protection."
	icon_state = "heatersh"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 15
	throwforce = 10
	dropshrink = 0.8
	coverage = 30
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 220

/obj/item/rogueweapon/shield/heater/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)


/obj/item/rogueweapon/shield/iron
	name = "iron shield"
	desc = "A heavy iron shield. It's cheaper than steel, but more encumbering."
	icon_state = "ironsh"
	force = 20
	throwforce = 25 // "I can do this all day."
	dropshrink = 0.8
	coverage = 30
	resistance_flags = null
	flags_1 = CONDUCT_1
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	possible_item_intents = list(SHIELD_SMASH_METAL, SHIELD_BLOCK) // No SHIELD_BASH. Too heavy to swing quickly, or something.
	max_integrity = 220
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/shield/iron/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/iron/bone
	name = "bone shield"
	desc = "If they couldn't protect their previous owners, how confident are you in these bones protecting you?"
	icon_state = "boneshield"
	smeltresult = null 
	
#undef SHIELD_BANG_COOLDOWN

/obj/item/rogueweapon/shield/bronze
	name = "hoplon shield"
	desc = "The finest companion to a javelin, gladius, and warclub; a thick-yet-sturdy shield of bronze."
	icon_state = "bronzeshield"
	force = 25
	throwforce = 30 // DO NOT GIVE ANYTHING; BUT TAKE FROM THEM.. EVERYTHING!
	dropshrink = 0.8 // Free free to add actual designs to this shield, too, if-or-whenever.
	coverage = 30
	resistance_flags = null
	flags_1 = CONDUCT_1
	minstr = 11 //Particularly heavy to use as a melee weapon.
	attacked_sound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	parrysound = list('sound/combat/parry/shield/metalshield (1).ogg','sound/combat/parry/shield/metalshield (2).ogg','sound/combat/parry/shield/metalshield (3).ogg')
	possible_item_intents = list(/datum/intent/shield/block, /datum/intent/mace/smash/shield/metal, /datum/intent/effect/daze) // No SHIELD_BASH. Able to inflict Daze due to its weight. 
	max_integrity = 260
	anvilrepair = /datum/skill/craft/weaponsmithing

/obj/item/rogueweapon/shield/bronze/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/iron/steppesman
	name = "steppesman shield"
	desc = "A banded iron shield decorated with traditional Aavnic colours, often seen in the hands of the Steppesmen."
	icon_state = "ironsh_steppeman"
	max_integrity = 250 //+30

/*/obj/item/rogueweapon/shield/buckler/freelancer
	name = "fencer's wrap"
	desc = "A traditional Etruscan quilted cloth square with a woolen cover. It can be used to daze and distract people with its bright colours and hanging steel balls."
	force = 10
	throwforce = 10
	coverage = 15
	max_integrity = 200
	possible_item_intents = list(SHIELD_BLOCK, FENCER_DAZE) */

//////////////
// SPECIAL! //
//////////////

/obj/item/rogueweapon/shield/steam
	name = "steam shield"
	desc = "A sturdy wood shield thats been highly modified by an artificer. It seems to have several pipes and gears built into it."
	icon_state = "artificershield"
	force = 15
	throwforce = 10
	dropshrink = 0.8
	coverage = 60
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 200
	var/smoke_path = /obj/effect/particle_effect/smoke
	var/cooldowny
	var/cdtime = 30 SECONDS

/obj/item/rogueweapon/shield/steam/attack_self(mob/user)
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, span_warning("[src] hisses weakly, it's still building up steam!"))
			return
	if(prob(25))
		smoke_path = /obj/effect/particle_effect/smoke/bad
	else
		smoke_path = /obj/effect/particle_effect/smoke
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	user.visible_message(span_notice("Loud whizzing clockwork and the hiss of steam comes from within [src]."))
	to_chat(user, span_warning("[user] activates a mechanism on [src]!"))
	sleep(15)
	playsound(user, 'sound/items/steamrelease.ogg', 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src,PROC_REF(steamready), user), cdtime)
	for(var/atom/movable/AM in view(1, user))
		thrownatoms += AM
	for(var/turf/T in oview(2, user))
		new smoke_path(T) //smoke everywhere!

	for(var/atom/movable/AM as anything in thrownatoms)
		if(AM == user || AM.anchored)
			continue
		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)

		if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(10)
				M.adjustFireLoss(25)
				to_chat(M, span_danger("You're slammed into the floor by [user]!"))
		else
			if(isliving(AM))
				var/mob/living/M = AM
				M.adjustFireLoss(25)
				to_chat(M, span_danger( "You're thrown back by [user]!"))
			AM.safe_throw_at(throwtarget, 4, 2, user, TRUE, force = MOVE_FORCE_OVERPOWERING)

/obj/item/rogueweapon/shield/steam/proc/steamready(mob/user)
	playsound(user, 'sound/items/steamcreation.ogg', 100, FALSE, -1)
	to_chat(user, span_warning("[src] is ready to be used again!"))
/obj/item/rogueweapon/shield/steam/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = 0,"ey" = 2,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)


/obj/item/rogueweapon/shield/tower/metal/gold/king
	name = "\"Bulwarke\""
	desc = "A resplendant kite shield, assembled from six golden plates that've been hooked together by a glimmering holy sigil. Mounted in its core is a shard of Astrata's divinity authority, crackling with the strength to violently repulse man-and-monster alike. ‎</br>‎‎ </br>'Tyranny and honor! Glory to thine kingdome-come! Let thine will be done!'"
	icon_state = "goldshieldking"
	max_integrity = 350
	var/smoke_path = /obj/effect/particle_effect/smoke/transparent
	var/cooldowny
	var/cdtime = 30 SECONDS
	unenchantable = TRUE

/obj/item/rogueweapon/shield/tower/metal/gold/king/attack_self(mob/user)
	if(cooldowny)
		if(world.time < cooldowny + cdtime)
			to_chat(user, span_warning("[src] weakly crackles, yet to be ready for another repulsation!"))
			return
	if(prob(25))
		smoke_path = /obj/effect/particle_effect/smoke
	else
		smoke_path = /obj/effect/particle_effect/smoke/transparent
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	user.visible_message(span_notice("The dorpel mounted upon [src] crackles, crackling with restored power!"))
	to_chat(user, span_warning("[user] invokes the power within [src], releasing a powerful shockwave!"))
	sleep(15)
	playsound(user, 'sound/items/steamrelease.ogg', 100, FALSE, -1)
	cooldowny = world.time
	addtimer(CALLBACK(src,PROC_REF(steamready), user), cdtime)
	for(var/atom/movable/AM in view(1, user))
		thrownatoms += AM
	for(var/turf/T in oview(2, user))
		new smoke_path(T) //smoke everywhere!

	for(var/atom/movable/AM as anything in thrownatoms)
		if(AM == user || AM.anchored)
			continue
		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)

		if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(10)
				M.adjustFireLoss(25)
				to_chat(M, span_danger("You're slammed into the floor by [user]!"))
		else
			if(isliving(AM))
				var/mob/living/M = AM
				M.adjustFireLoss(25)
				to_chat(M, span_danger( "You're thrown back by [user]!"))
			AM.safe_throw_at(throwtarget, 4, 2, user, TRUE, force = MOVE_FORCE_OVERPOWERING)

/obj/item/rogueweapon/shield/tower/metal/gold/king/proc/steamready(mob/user)
	playsound(user, 'sound/items/steamcreation.ogg', 100, FALSE, -1)
	to_chat(user, span_warning("[src] is ready to be used again!"))
