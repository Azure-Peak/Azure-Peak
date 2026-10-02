
//see volf.dm for parent animal
/mob/living/simple_animal/hostile/retaliate/rogue/wolf/dire
	anatomy_type = /datum/anatomy/quadruped/standard
	icon = 'icons/roguetown/mob/monster/direvolf.dmi'
	name = "direvolf"
	desc = "A large snarling beast of mangy fur and yellowed teeth. Direvolves oft hail from mountaineous areas and are known to attack hapless travelers in the deep forests when prey is scarce."
	icon_state = "direvolf_brown"
	icon_living = "direvolf_brown_dead"
	icon_dead = "direvolf_brown_dead"
	pixel_x = -8
	blood_toll_bucket = STATS_KILLED_GREATER_BEASTS
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/wolf = 2,//bigger volf, better meat
						/obj/item/alch/viscera = 2,
						/obj/item/alch/sinew = 1,
						/obj/item/natural/bone = 2)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/wolf = 3, //bigger volf, better meat
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1,
						/obj/item/alch/viscera = 3,
						/obj/item/natural/fur/wolf = 2,
						/obj/item/natural/bone = 3)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/wolf = 4, //bigger volf, better meat
						/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/natural/hide = 3,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 2,
						/obj/item/alch/viscera = 4,
						/obj/item/natural/fur/wolf = 3,
						/obj/item/natural/bone = 4)
	threat_point = THREAT_DEADLY
	health = BEAR_HEALTH	//volf is 120, direbear is 500
	maxHealth = BEAR_HEALTH
	melee_damage_lower = 50		// Ouch!!
	melee_damage_upper = 60
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES // silly furniture won't stop our boy
	food_type = list(/obj/item/reagent_containers/food/snacks,
					/obj/item/bodypart, //a delicious meal
					/obj/item/organ,
					/obj/item/natural/bone,
					/obj/item/natural/hide)
	STACON = 12
	STASTR = 13 //same stats as direbear. It's dire, ser.
	STASPD = 9
	remains_type = /obj/effect/decal/remains/direwolf

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/dire/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_icon()
	ai_controller.set_blackboard_key(BB_BASIC_FOODS, food_type)
	var/color = pick("brown", "black", "white")
	icon_state = "direvolf_[color]"
	icon_living = "direvolf_[color]"
	icon_dead = "direvolf_[color]_dead"

/mob/living/simple_animal/hostile/retaliate/rogue/wolf/dire/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/idle (3).ogg','sound/vo/mobs/vw/idle (4).ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')


/obj/effect/decal/remains/direwolf
	name = "remains"
	desc = "Whether by starvation, disease, inter-pack conflict, or an unlucky kick from a saiga, this direvolf has died."
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/direvolf.dmi'

