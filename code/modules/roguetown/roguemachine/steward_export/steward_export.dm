GLOBAL_LIST_EMPTY(steward_export_machines)

/// Marker placed in the Crown warehouse. When the Steward fulfills an equipment standing
/// order, the economy subsystem iterates items in `view(1, M)` around each registered
/// machine - confined to a 3x3 footprint per machine to avoid world-wide scans.
/// Mapped invisible/indestructible; mappers drop one per warehouse cluster.
/obj/structure/roguemachine/steward_export
	name = "steward's export machine"
	desc = "A machine near where Crown-hired clerks tally exports. Wares left within reach of this machine are counted toward Crown standing orders."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = FALSE
	anchored = TRUE
	max_integrity = 0
	blade_dulling = DULLING_BASH
	resistance_flags = FIRE_PROOF | LAVA_PROOF | INDESTRUCTIBLE | UNACIDABLE
	layer = BELOW_OBJ_LAYER

/obj/structure/roguemachine/steward_export/Initialize()
	. = ..()
	GLOB.steward_export_machines += src

/obj/structure/roguemachine/steward_export/Destroy()
	GLOB.steward_export_machines -= src
	return ..()
