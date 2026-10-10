#define BREW_COOKING_TIME 30 SECONDS

/datum/container_craft/cooking/brew
	abstract_type = /datum/container_craft/cooking/brew
	category = FOOD_CAT_BREWS

/datum/container_craft/cooking/brew/extra_html()
	. = ..()
	var/datum/reagent/consumable/drink = created_reagent
	. += "</p><p>[initial(drink.description)]"
	var/datum/status_effect/buff/brew/buff = initial(drink.brew_buff)
	if(!buff)
		return
	var/atom/movable/screen/alert/alert = initial(buff.alert_type)
	. += "</p><p>Grants [capitalize(initial(alert.name))] for [initial(buff.duration) / (1 MINUTES)] minutes."

/datum/container_craft/cooking/brew/minttea
	name = "Mint Tea"
	wildcard_requirements = list(/obj/item/alch/mentha = 1)
	created_reagent = /datum/reagent/consumable/brew/minttea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/wormwoodtea
	name = "Wormwood Tea"
	wildcard_requirements = list(/obj/item/alch/artemisia = 1)
	created_reagent = /datum/reagent/consumable/brew/wormwoodtea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/sagetea
	name = "Sage Tea"
	wildcard_requirements = list(/obj/item/alch/salvia = 1)
	created_reagent = /datum/reagent/consumable/brew/sagetea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/valeriantea
	name = "Valerian Tea"
	wildcard_requirements = list(/obj/item/alch/valeriana = 1)
	created_reagent = /datum/reagent/consumable/brew/valeriantea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/baothatea
	name = "Baothan Tea"
	wildcard_requirements = list(/obj/item/alch/atropa = 1)
	created_reagent = /datum/reagent/consumable/brew/baothatea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/eyebrighttea
	name = "Euphrasia Tea"
	wildcard_requirements = list(/obj/item/alch/euphrasia = 1)
	created_reagent = /datum/reagent/consumable/brew/eyebrighttea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/bloomtea
	name = "Bloom Tea"
	wildcard_requirements = list(/obj/item/alch/manabloompowder = 1)
	created_reagent = /datum/reagent/consumable/caffeine/bloomtea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/eorantea
	name = "Eoran Tea"
	wildcard_requirements = list(/obj/item/alch/calendula = 1)
	created_reagent = /datum/reagent/consumable/brew/eorantea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/psytea
	name = "Pilgrim Tea"
	wildcard_requirements = list(/obj/item/alch/benedictus = 1)
	created_reagent = /datum/reagent/consumable/brew/psytea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/dandelioncoffee
	name = "Dandelion Coffee"
	wildcard_requirements = list(/obj/item/alch/taraxacum = 1)
	created_reagent = /datum/reagent/consumable/brew/dandelioncoffee
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/nettletea
	name = "Nettle Tea"
	wildcard_requirements = list(/obj/item/alch/urtica = 1)
	created_reagent = /datum/reagent/consumable/brew/nettletea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/chamomiletea
	name = "Chamomile Tea"
	wildcard_requirements = list(/obj/item/alch/matricaria = 1)
	created_reagent = /datum/reagent/consumable/brew/chamomiletea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/raneshenbitters
	name = "Raneshen Bitter Tea"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/raneshenbitters = 1)
	created_reagent = /datum/reagent/consumable/caffeine/raneshenbitter
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/eoragrace
	name = "Eora's Grace"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoragrace = 1)
	created_reagent = /datum/reagent/consumable/brew/eorasgracetea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/eoralovefake
	name = "Faked Eora's Love"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoralovefake = 1)
	created_reagent = /datum/reagent/consumable/brew/eorasloveteafake
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/eoralove
	name = "Eora's Love"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/eoralove = 1)
	created_reagent = /datum/reagent/consumable/brew/eorasloveteatrue
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/ravoxcalm
	name = "Ravox's Calm"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/ravoxcalm = 1)
	created_reagent = /datum/reagent/consumable/caffeine/ravoxtea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/mocha
	name = "Veranda Coffee"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/mocha = 1)
	created_reagent = /datum/reagent/consumable/caffeine/mocha
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/gerevine
	name = "Gerevine Brew"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/gerevine = 1)
	created_reagent = /datum/reagent/consumable/brew/gerevine
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/schorle
	name = "Apfelschorle"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/schorle = 1)
	created_reagent = /datum/reagent/consumable/caffeine/schorle
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/baothablend
	name = "Void's Embrace"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/baothablend = 1)
	created_reagent = /datum/reagent/consumable/brew/baothablend
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/forgottenlove
	name = "Tea of Sisters"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/forgottenlove = 1)
	created_reagent = /datum/reagent/consumable/brew/forgottenlove
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/chai
	name = "Chai"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/chai = 1)
	created_reagent = /datum/reagent/consumable/caffeine/chai
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/volfmilk
	name = "Vargmjölk"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/volfmilk = 1)
	created_reagent = /datum/reagent/consumable/brew/volfmilk
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/frukkte
	name = "Fruktte"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/frukkte = 1)
	created_reagent = /datum/reagent/consumable/brew/icetea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/barleytea
	name = "Barley Tea"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/barleytea = 1)
	created_reagent = /datum/reagent/consumable/brew/barleytea
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/kvass
	name = "Kvass"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/kvass = 1)
	created_reagent = /datum/reagent/consumable/brew/kvass
	crafting_time = BREW_COOKING_TIME

/datum/container_craft/cooking/brew/avantare
	name = "Avantare"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/grown/rogue/blend/avantare = 1)
	created_reagent = /datum/reagent/consumable/brew/avantare
	crafting_time = BREW_COOKING_TIME

#undef BREW_COOKING_TIME
