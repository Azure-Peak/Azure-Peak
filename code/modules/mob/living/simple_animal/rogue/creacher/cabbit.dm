/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit	//Technically mudcrab subtype, it's a rabbit though. Shrimpler that way.
	name = "cabbit"
	desc = "A cabbit, a particular favorite of local fauna; both as a pet and as a tasty meal."
	icon = 'icons/roguetown/mob/cabbit.dmi'
	icon_state = "cabbit"
	icon_living = "cabbit"
	icon_dead = "cabbit_dead"
	remains_type = /obj/effect/decal/remains/cabbit
	speak = list("Meow!", "Chk!", "Purr!", "Chrr!")
	speak_emote = list("chirrups", "meows")
	faction = list("cabbits")	//Snowflake code
	emote_hear = list("meows.", "clucks.")
	emote_see = list("brings their ears alert.", "scratches their ear with a hindleg.")
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit = 3, 
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1,
							/obj/item/natural/fur/rabbit = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit = 4, 
							/obj/item/alch/sinew = 1,
							/obj/item/alch/bone = 1,
							/obj/item/natural/fur/rabbit = 1,
							/obj/item/natural/rabbitsfoot = 1)	//Rare rabbits foot for luck charm.

/mob/living/simple_animal/hostile/retaliate/rogue/mudcrab/cabbit/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/rabbit/rabbit_alert.ogg')
		if("pain")
			return pick('sound/vo/mobs/rabbit/rabbit_pain1.ogg', 'sound/vo/mobs/rabbit/rabbit_pain2.ogg')
		if("death")
			return pick('sound/vo/mobs/rabbit/rabbit_death.ogg')

/obj/effect/decal/remains/cabbit
	name = "remains"
	desc = "This pile of indistinct bones was once an adorable cabbit. The realm's endearment earned it no respite from the grave."
	gender = PLURAL
	icon = 'icons/roguetown/mob/cabbit.dmi'
	icon_state = "cabbit_remains"
