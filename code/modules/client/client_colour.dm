
/*
	Client Colour Priority System By RemieRichards
	A System that gives finer control over which client.colour value to display on screen
	so that the "highest priority" one is always displayed as opposed to the default of
	"whichever was set last is displayed"
*/



/*
	Define subtypes of this datum
*/
/datum/client_colour
	var/colour = "" //Any client.color-valid value
	var/priority = 1 //Since only one client.color can be rendered on screen, we take the one with the highest priority value:
	//eg: "Bloody screen" > "goggles colour" as the former is much more important


/*
	Adds an instance of colour_type to the mob's client_colours list
	colour_type - a typepath (subtyped from /datum/client_colour)
*/
/mob/proc/add_client_colour(colour_type)
	if(!ispath(colour_type, /datum/client_colour))
		return
	
	var/datum/client_colour/CC = get_client_color(colour_type)
	if(CC)
		return CC

	CC = new colour_type()
	client_colours += CC
	sortTim(client_colours, GLOBAL_PROC_REF(cmp_clientcolour_priority))
	update_client_colour()
	return CC


/*
	Removes an instance of colour_type from the mob's client_colours list
	colour_type - a typepath (subtyped from /datum/client_colour)
*/
/mob/proc/remove_client_colour(colour_type)
	if(!ispath(colour_type, /datum/client_colour))
		return

	for(var/cc in client_colours)
		var/datum/client_colour/CC = cc
		if(CC.type == colour_type)
			client_colours -= CC
			qdel(CC)
			break
	update_client_colour()


/*
	Resets the mob's client.color to null, and then sets it to the highest priority
	client_colour datum, if one exists
*/
/mob/proc/update_client_colour()
	if(!client)
		return
	client.color = ""
	if(!client_colours?.len)
		return
	var/datum/client_colour/CC = client_colours[1]
	if(CC)
		client.color = CC.colour

/mob/proc/get_client_color(client_color_type)
	if(!client)
		return null
	for(var/datum/client_colour/cc as anything in client_colours)
		if(cc.type != client_color_type)
			continue
		return cc
	return null

/datum/client_colour/glass_colour
	priority = 0
	colour = "red"

/datum/client_colour/glass_colour/green
	colour = "#aaffaa"

/datum/client_colour/glass_colour/lightgreen
	colour = "#ccffcc"

/datum/client_colour/glass_colour/blue
	colour = "#aaaaff"

/datum/client_colour/glass_colour/lightblue
	colour = "#ccccff"

/datum/client_colour/glass_colour/yellow
	colour = "#ffff66"

/datum/client_colour/glass_colour/red
	colour = "#ffaaaa"

/datum/client_colour/glass_colour/darkred
	colour = "#bb5555"

/datum/client_colour/glass_colour/orange
	colour = "#ffbb99"

/datum/client_colour/glass_colour/lightorange
	colour = "#ffddaa"

/datum/client_colour/glass_colour/purple
	colour = "#ff99ff"

/datum/client_colour/glass_colour/gray
	colour = "#cccccc"

/datum/client_colour/monochrome
	colour = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	priority = INFINITY //we can't see colors anyway!

/datum/client_colour/test1
	colour = list(1,1,1,0.5, 1,1,1,0.5, 1,1,1,0.5)
	priority = 2

/datum/client_colour/test2
	colour = list(0.8,0.2,0.2, 0.2,0.8,0.3, 0.2,0.3,0.8)
	priority = 2

/datum/client_colour/test3
	colour = list(1,1,1, 1,1,1, 1,1,1)
	priority = 2

/datum/client_colour/maniac_marked
	colour = list(1,0,0, 0,1,0, 0,0,1.5)
	priority = 1

/datum/client_colour/nocshaded
	colour = list(rgb(139, 25, 30), rgb(197, 88, 38), rgb(16, 16, 16), rgb(0,0,0))
	priority = 1

/datum/client_colour/monochrome/trance
	priority = 2

/datum/client_colour/monochrome/blind
	priority = 2

/datum/client_colour/stress_fade
	colour = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)
	priority = 0

/datum/client_colour/underwater
	priority = 1.5
	colour = list(0.8,0.05,0,0, 0,0.9,0.05,0, 0.05,0.05,1.1,0, -0.01,-0.01,0.01,1)

