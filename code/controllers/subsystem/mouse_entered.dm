/// Defers MouseEntered inputs to only apply to the most recently hovered over atom in the tick
SUBSYSTEM_DEF(mouse_entered)
	name = "MouseEntered"
	wait = 1
	flags = SS_NO_INIT | SS_TICKER
	priority = FIRE_PRIORITY_MOUSE_ENTERED
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/list/hovers = list()
	var/list/hover_params = list()

/datum/controller/subsystem/mouse_entered/fire()
	for(var/hovering_client in hovers)
		var/atom/hovering_atom = hovers[hovering_client]
		if(isnull(hovering_atom))
			continue

		hovering_atom.on_mouse_enter(hovering_client, hover_params[hovering_client])

		// This intentionally runs `= null` and not `-= hovering_client`, as we want to prevent the list from shrinking,
		// which could cause problems given the heat of MouseEntered.
		hovers[hovering_client] = null
		hover_params[hovering_client] = null