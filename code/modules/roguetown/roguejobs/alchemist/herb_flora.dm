/obj/structure/flora/roguegrass/herb
	name = "herbbush"
	desc = "A bush, for a herb. This shouldn't show up."
	icon = 'icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "spritemeplz"
	var/res_replenish
	max_integrity = 10
	climbable = FALSE
	dir = SOUTH
	var/list/looty = list()
	var/herbtype

	var/timerid
	var/harvested = FALSE

/obj/structure/flora/roguegrass/herb/Initialize()
	. = ..()
	GLOB.herb_locations |= src
	loot_replenish()

/obj/structure/flora/roguegrass/herb/examine(mob/user)
	. = ..()
	. += span_notice("This is a potentially useful herb!")

/obj/structure/flora/roguegrass/herb/Destroy()
	. = ..()
	GLOB.harvested_herbs -= src
	GLOB.herb_locations -= src

/obj/structure/flora/roguegrass/herb/update_icon()
	return

/obj/structure/flora/roguegrass/herb/attack_hand(mob/user)
	if(harvested)
		to_chat(user, span_warning("Picked clean; but looks healthy. I should try again later."))
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 80, FALSE, -1)
		if(do_after(L, rand(3,5), src))
			if(!looty.len)
				return
			var/obj/item/B = pick_n_take(looty)
			if(B)
				B = new B(user.loc)
				user.put_in_hands(B)
				if(HAS_TRAIT(user, TRAIT_WOODWALKER))
					var/obj/item/C = new B.type(user.loc)
					user.put_in_hands(C)
				user.visible_message(span_notice("[user] finds [HAS_TRAIT(user, TRAIT_WOODWALKER) ? "two of " : ""][B] in [src]."))
				harvested = TRUE
				timerid = addtimer(CALLBACK(src, PROC_REF(loot_replenish)), 5 MINUTES, flags = TIMER_STOPPABLE)
				//add_filter("picked", 1, alpha_mask_filter(icon = icon('icons/effects/picked_overlay.dmi', "picked_overlay_[rand(1,3)]"), flags = MASK_INVERSE))
				GLOB.harvested_herbs |= src
				return
			user.visible_message(span_notice("[user] searches through [src]."))

/obj/structure/flora/roguegrass/herb/proc/loot_replenish()
	if(herbtype)
		looty += herbtype
	harvested = FALSE
	remove_filter("picked")
	GLOB.harvested_herbs -= src
	if(timerid)
		deltimer(timerid)

/obj/structure/flora/roguegrass/herb/random
	name = "random herb"
	desc = "Haha, im in danger."

/obj/structure/flora/roguegrass/herb/random/Initialize()
	var/type = pick(list(/obj/structure/flora/roguegrass/herb/atropa,
	/obj/structure/flora/roguegrass/herb/matricaria,
	/obj/structure/flora/roguegrass/herb/symphitum,
	/obj/structure/flora/roguegrass/herb/taraxacum,
	/obj/structure/flora/roguegrass/herb/euphrasia,
	/obj/structure/flora/roguegrass/herb/paris,
	/obj/structure/flora/roguegrass/herb/calendula,
	/obj/structure/flora/roguegrass/herb/mentha,
	/obj/structure/flora/roguegrass/herb/urtica,
	/obj/structure/flora/roguegrass/herb/salvia,
	/obj/structure/flora/roguegrass/herb/hypericum,
	/obj/structure/flora/roguegrass/herb/benedictus,
	/obj/structure/flora/roguegrass/herb/valeriana,
	/obj/structure/flora/roguegrass/herb/artemisia,
	/obj/structure/flora/roguegrass/herb/rosa,
	/obj/structure/flora/roguegrass/swampweed))

	var/obj/structure/flora/roguegrass/herb/boi = new type
	boi.forceMove(get_turf(src))
	boi.pixel_x += rand(-3,3)
	. = ..()

	return INITIALIZE_HINT_QDEL


/obj/structure/flora/roguegrass/herb/atropa
	name = "atropa"
	desc = "A flowering plant bearing large, flat leaves and glossy berries upon their stalks. Unpopular \
	among gardeners, as their berries are both very poisonous and very appetising in appearance."
	icon_state = "atropa"

	herbtype = /obj/item/alch/atropa

/obj/structure/flora/roguegrass/herb/matricaria
	name = "matricaria"
	desc = "Known more colloquially as 'mayweed' by the commonfolk, this is a narrow-leaved spindle of \
	a herb bearing bright yellow flowers. Many cunning-folk recommend it for toothache."
	icon_state = "matricaria"

	herbtype = /obj/item/alch/matricaria

/obj/structure/flora/roguegrass/herb/symphitum
	name = "symphitum"
	desc = "A thick-stemmed flower that typically grows in damp areas, such as marshes and adjacent to \
	river banks. In ancient times, these were frequently used to manufacture poultices."
	icon_state = "symphitum"

	herbtype = /obj/item/alch/symphitum

/obj/structure/flora/roguegrass/herb/taraxacum
	name = "taraxacum"
	desc = "More prominently known as 'dandelions', these are among the most common and survivable flowers \
	in the known world. Incredibly swift to propagate, prone to growing wherever they would like - and quite \
	enjoyable to blow on once they've seeded."
	icon_state = "taraxacum"

	herbtype = /obj/item/alch/taraxacum

/obj/structure/flora/roguegrass/herb/euphrasia
	name = "euphrasia"
	desc = "A low-lying, dainty plant with small, bright flowers. Known among the commonfolk as 'eyebright', \
	its leaves are thought to help combat bad memory when ingested. It is thereby quite popular among those with \
	substantial gaps in their memory from misplaced magic, brain damage, or long periods spent as a deadite."
	icon_state = "euphrasia"

	herbtype = /obj/item/alch/euphrasia

/obj/structure/flora/roguegrass/herb/paris
	name = "paris"
	desc = "Common in ancient woodlands in particular, this stout growths are capped with a single \
	solitary berry. It's poison, of course - but it also tastes awful, so there isn't much allure to it."
	icon_state = "paris"

	herbtype = /obj/item/alch/paris

/obj/structure/flora/roguegrass/herb/calendula
	name = "calendula"
	desc = "Ubiquitous in modern times for its utility in alchemical healing potions, calendula - \
	better known as 'marigold' - is a well-adored flower said by some to be favoured by the fae-folk."
	icon_state = "calendula"

	herbtype = /obj/item/alch/calendula

/obj/structure/flora/roguegrass/herb/mentha
	name = "mentha"
	desc = "A truly voracious herb known to spread underground to appear in the most unlikely of places! \
	Difficult to kill, impossible to contain - but, carrying quite a pleasant taste, thereby rendering all \
	its other sins forgiven. Known colloquially as 'mint'."
	icon_state = "mentha"

	herbtype = /obj/item/alch/mentha

/obj/structure/flora/roguegrass/herb/urtica
	name = "urtica"
	desc = "Known among the commonfolk as 'stinging nettles', the leaves of this plant cause painful irritation \
	and swelling upon the flesh of anyone who touches them. Despite this, it carries varied culinary uses, and \
	was even used to create fabric in ancient times."
	icon_state = "urtica"

	herbtype = /obj/item/alch/urtica

/obj/structure/flora/roguegrass/herb/salvia
	name = "salvia"
	desc = "An extremely populous and popular herb typically referred to as 'sage', the leaves of this flower \
	have been used in alchemy and in culinary work since ancient times."
	icon_state = "salvia"

	herbtype = /obj/item/alch/salvia

/obj/structure/flora/roguegrass/herb/hypericum
	name = "hypericum"
	desc = "Said by some folk healers to treat low mood and macabre thoughts, these occur throughout almost \
	the entire known world and are widely derided as weeds by gardeners across Psydonia. Known less learnedly \
	as 'goatweed'."
	icon_state = "hypericum"

	herbtype = /obj/item/alch/hypericum

/obj/structure/flora/roguegrass/herb/benedictus
	name = "benedictus"
	desc = "Known as 'blessed thistle' by many commonfolk, the priests of the Otavan Orthodoxy claim \
	this hairy, leathery plant to be sacred to Psydon; it thereby features often in sites of Psydonite \
	pilgrimage. The Holy See, in conscious contradiction, refuses to acknowledge any sacred association whatsoever."
	icon_state = "benedictus"

	herbtype = /obj/item/alch/benedictus

/obj/structure/flora/roguegrass/herb/valeriana
	name = "valeriana"
	desc = "Famed for their beautiful flowers, valerians are a common sight in aristocratic gardens and \
	the bouquets of young lovers both. They do smell a little odd once dried, though."
	icon_state = "valeriana"

	herbtype = /obj/item/alch/valeriana

/obj/structure/flora/roguegrass/herb/artemisia
	name = "artemisia"
	desc = "A tough, hardy shrub with an extremely strong aroma and a sharp, bitter taste which renders \
	then very unappealing to herbivores. Durable survivors, willing to embitter their flesh to avoid \
	predation."
	icon_state = "artemisia"

	herbtype = /obj/item/alch/artemisia

/obj/structure/flora/roguegrass/herb/rosa
	name = "rosa"
	desc = "Said to be the beloved flower of Eora, these are taken by many as the ultimate \
	expression of romantic affection; as beautiful to behold as they are painful to hold, owed \
	to their many prickly spines."
	icon_state = "rosa"

	herbtype = /obj/item/alch/rosa

/obj/structure/flora/roguegrass/herb/manabloom
	name = "manabloom"
	desc = "A bright, ethereal flower sprouting from a narrow stem held by only the most marginal \
	of root systems. Thought to occur wherever magic falls to the earth, and wildly useful for \
	magicians, wizards, and other practitioners."
	icon = 'icons/roguetown/misc/crops.dmi' // this is awful why am I doing this
	icon_state = "manabloom2"

	herbtype = /obj/item/reagent_containers/food/snacks/grown/manabloom
