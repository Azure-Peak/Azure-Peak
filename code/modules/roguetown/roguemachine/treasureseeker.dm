// A bathhouse cousin of the HEADEATER: swallows treasures instead of skulls and
// spirits them away to the bath house vault. Every consignment is entered
// into the BRASSFACE's Hoard ledger, and the hoard pays interest on the vault's
// contents via the BMtreasury subsystem.
/obj/structure/roguemachine/headeater/treasureseeker
	name = "TREASURE SEEKER"
	desc = "A kin of the HEADEATER, its brass gullet re-tuned by the Bathhouse for gentler appetites. Feed it any trinket and the prize is whisked away - where the hoard remembers its worth. Its jaws open only for the Bathhouse's own."

/obj/structure/roguemachine/headeater/treasureseeker/examine()
	. = ..()
	. += span_info("Left-click with an item to consign it to the Bath House's vault. Right-click to consign every item on the tile beneath its maw.")
	. += span_smallnotice("Its jaws open only for the Bath House's staff.")

/obj/structure/roguemachine/headeater/treasureseeker/get_mechanics_examine(mob/user)
	. = list()
	. += span_info("Items deposited into its maw are sent directly to the Bath House's vault.")
	. += span_info("Each consignment is entered into the BRASSFACE's hoard ledger, and the hoard pays interest on the vault's treasures.")
	. += span_info("Dross is refused - it swallows only what the hoard can turn a profit on, leaving worthless trinkets, loose coin and containers behind.")

/// Only the Bathhouse's own may consign to the hoard
/obj/structure/roguemachine/headeater/treasureseeker/proc/is_bathhouse_consignor(mob/user)
	if(!user)
		return FALSE
	if(user.job in GLOB.bathhouse_positions)
		return TRUE
	return HAS_TRAIT(user, TRAIT_AGENT_BATHHOUSE)

/// Collects the open floor turfs of the bath vault area.
/obj/structure/roguemachine/headeater/treasureseeker/proc/get_vault_turfs()
	var/area/vault_area = GLOB.areas_by_type[/area/rogue/outdoors/exposed/bath/vault]
	if(!vault_area)
		return list()
	var/list/turfs = list()
	for(var/turf/open/floor/vault_floor in vault_area)
		turfs += vault_floor
	return turfs

/// Records one consigned item in the hoard ledger. Returns the item's appraised value.
/obj/structure/roguemachine/headeater/treasureseeker/proc/log_consignment(obj/item/I, mob/user)
	var/value = I.get_real_price() || 0
	SSBMtreasury.add_hoard_log("deposit", I.name, value, user.real_name)
	return value

/// Records a bulk consignment of same-type items as a single ledger line - count and
/// combined value, so a pile doesn't spam the ledger with one row per item.
/obj/structure/roguemachine/headeater/treasureseeker/proc/log_bulk_consignment(item_name, count, total_value, mob/user)
	if(count <= 0)
		return
	SSBMtreasury.add_hoard_log("deposit", "[item_name] x[count]", total_value, user.real_name)

/// Message for stuff appearing in the room so that it is not just out of nowhere
/obj/structure/roguemachine/headeater/treasureseeker/proc/announce_arrival(obj/item/I, turf/destination)
	if(!destination)
		return
	for(var/mob/M in hearers(7, destination))
		to_chat(M, span_notice("[I] suddenly appears in a golden flash upon the ground of the vault."))

/// Same as above but for multiple items at once to stop message spam
/obj/structure/roguemachine/headeater/treasureseeker/proc/announce_bulk_arrival(turf/destination, count)
	if(!destination || count <= 0)
		return
	for(var/mob/M in hearers(7, destination))
		to_chat(M, span_notice("[count] items of treasure suddenly appear in a golden flash upon the ground of the vault."))

/obj/structure/roguemachine/headeater/treasureseeker/attackby(obj/item/I, mob/user, params)
	var/mob/living/L = user
	if(istype(L) && L.used_intent && L.used_intent.type == INTENT_HARM)
		return // Harm intent bashes the machine; heads and dross alike are refused.
	if(!is_bathhouse_consignor(user))
		to_chat(user, span_warning("[src] stays shut, its brass jaws sealed - the hoard answers only to the Bathhouse."))
		return TRUE
	if(!SSBMtreasury.generates_profit(I))
		to_chat(user, span_warning("[src] sniffs at [I] and turns its brass nose up - the hoard has no taste for such dross."))
		return TRUE
	var/list/turfs = get_vault_turfs()
	if(!length(turfs))
		to_chat(user, span_warning("[src] rattles hollowly - the Bathhouse's vault cannot be reached."))
		return TRUE
	var/turf/destination = pick(turfs)
	if(!user.transferItemToLoc(I, destination))
		to_chat(user, span_warning("[I] is stuck to your hand!"))
		return TRUE
	log_consignment(I, user)
	announce_arrival(I, destination)
	playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
	to_chat(user, span_danger("[src] gulps down [I], whisking it away."))
	return TRUE

/obj/structure/roguemachine/headeater/treasureseeker/attack_right(mob/user)
	// The sprite is pixel-shifted over its base turf (as the headeater's is), so the
	// parent sweeps get_turf(src) - do the same rather than stepping off by dir.
	if(!is_bathhouse_consignor(user))
		to_chat(user, span_warning("[src] stays shut, its brass jaws sealed - the hoard answers only to the Bathhouse."))
		return
	var/turf/front = get_turf(src)
	if(!front)
		return
	var/list/to_ship = list()
	var/rejected = 0
	for(var/obj/item/I in front.contents)
		if(I.anchored)
			continue
		if(!SSBMtreasury.generates_profit(I)) // Dross is left behind.
			rejected++
			continue
		to_ship += I
	if(!length(to_ship))
		if(rejected)
			to_chat(user, span_warning("[src] turns its brass nose up at the dross before it - nothing there would fatten the hoard."))
		else
			to_chat(user, span_info("Nothing glitters upon the tile before [src]."))
		return
	var/list/turfs = get_vault_turfs()
	if(!length(turfs))
		to_chat(user, span_warning("[src] rattles hollowly - the Bathhouse's vault cannot be reached."))
		return
	var/shipped = 0
	var/turf/last_destination
	var/obj/item/last_item
	var/list/bulk_counts = list() // item name -> count
	var/list/bulk_values = list() // item name -> combined value
	for(var/obj/item/I in to_ship)
		if(I.loc != front) // Something else grabbed it mid-gulp.
			continue
		last_destination = pick(turfs)
		I.forceMove(last_destination)
		var/value = I.get_real_price() || 0
		bulk_counts[I.name] = (bulk_counts[I.name] || 0) + 1
		bulk_values[I.name] = (bulk_values[I.name] || 0) + value
		last_item = I
		shipped++	// Itemise one treasure; group a haul into one ledger line per type.
	if(shipped == 1)
		log_consignment(last_item, user)
	else
		for(var/item_name in bulk_counts)
			log_bulk_consignment(item_name, bulk_counts[item_name], bulk_values[item_name], user)
	// A single treasure is named; a haul is summarised - the itemised record
	// lives in the BRASSFACE Hoard ledger.
	if(shipped == 1)
		announce_arrival(last_item, last_destination)
	else if(shipped > 1)
		announce_bulk_arrival(last_destination, shipped)
	if(shipped)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		to_chat(user, span_danger("[src] gulps down [shipped] treasure[shipped > 1 ? "s" : ""], whisking them away."))
		if(rejected)
			to_chat(user, span_warning("[src] leaves [rejected] trifle[rejected > 1 ? "s" : ""] untouched - the hoard has no taste for such dross."))
