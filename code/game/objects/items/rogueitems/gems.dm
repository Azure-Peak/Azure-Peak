
/obj/item/roguegem
	name = "mother of all gems"
	icon_state = "ruby_cut"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "A debug tool to help us later"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 1
	static_price = FALSE
	resistance_flags = FIRE_PROOF

/obj/item/roguegem/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -1,"sy" = 0,"nx" = 11,"ny" = 1,"wx" = 0,"wy" = 1,"ex" = 4,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 15,"sturn" = 0,"wturn" = 0,"eturn" = 39,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/roguegem/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	playsound(loc, pick('sound/items/gems (1).ogg','sound/items/gems (2).ogg'), 100, TRUE, -2)
	..()

/obj/item/roguegem/green
	name = "gemerald"
	icon_state = "emerald_cut"
	sellprice = 42
	desc = "Glints with verdant brilliance."

/obj/item/roguegem/green/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/emerald_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/blue
	name = "blortz"
	icon_state = "quartz_cut"
	sellprice = 88
	desc = "Pale blue, like a frozen tear."

/obj/item/roguegem/blue/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/quartz_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/yellow
	name = "toper"
	icon_state = "topaz_cut"
	sellprice = 34
	desc = "Its amber hues remind you of the sunset."

/obj/item/roguegem/yellow/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/toper_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/violet
	name = "saffira"
	icon_state = "sapphire_cut"
	sellprice = 56
	desc = "This gem is admired by many wizards."

/obj/item/roguegem/violet/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/sapphire_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/ruby
	name = "rontz"
	icon_state = "ruby_cut"
	sellprice = 100
	desc = "Its facets shine so brightly..."

/obj/item/roguegem/ruby/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/ruby_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/diamond
	name = "dorpel"
	icon_state = "diamond_cut"
	sellprice = 121
	desc = "Beautifully clear, it demands respect."

/obj/item/roguegem/onyxa
	name = "onyxa"
	desc = "A sinister, glimmering stone. Valuable to the drow, it is sometimes used in necromantic rituals. Mirrors made of this are said to never show your own face."
	icon = 'icons/roguetown/gems/gem_onyxa.dmi'
	icon_state = "raw_onyxa"
	sellprice = 30

/obj/item/roguegem/jade
	name = "jade"
	desc = "A dull green gem prized in Lingyue and Kazengun alike. Lingyuese tradition holds that jade is the essence of Psydon, protecting both soul and flesh from decay and corruption."
	icon = 'icons/roguetown/gems/gem_jade.dmi'
	icon_state = "raw_jade"
	sellprice = 50

/obj/item/roguegem/oyster
	name = "fossilized clam"
	desc = "A fossilized clam shell. It would be a good idea to pry it open with a knife."
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "oyster_closed"
	sellprice = 5

/obj/item/roguegem/coral
	name = "heartstone"
	desc = "Jagged like a hound's tooth. Heartstone is speculated to be the crystalized blood of fallen sailors. It is sacred to Abyssorites and is used in numerous Abyssorites rituals."
	icon = 'icons/roguetown/gems/gem_coral.dmi'
	icon_state = "raw_coral"
	sellprice = 60

/obj/item/roguegem/turq
	name = "cerulite"
	desc = "A beautiful teal gem that carves easily. Beloved by mages, its remarkable clarity makes it a favored tool of Naledi’s astrologer-mages in divination."
	icon = 'icons/roguetown/gems/gem_turq.dmi'
	icon_state = "raw_turq"
	sellprice = 75

/obj/item/roguegem/amber
	name = "amber"
	desc = "A chunk of fossilized sunlight. Believed to have been shed during the shattering of the First Sun, its remnants are prized among Astratans. Raaneshi sometimes use fragments as currency, instead of mammon."
	icon = 'icons/roguetown/gems/gem_amber.dmi'
	icon_state = "raw_amber"
	sellprice = 50

/obj/item/roguegem/opal
	name = "opal"
	desc = "A dazzling gem of great value. Opal is widely speculated to be the crystallized essence left behind by rainbows."
	icon = 'icons/roguetown/gems/gem_opal.dmi'
	icon_state = "raw_opal"
	sellprice = 80

/obj/item/roguegem/diamond/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/diamond_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

// Do NOT add these to the stockpile treasures list, they have other uses.
/obj/item/roguegem/blood_diamond
	name = "glut"
	icon_state = "blood"
	sellprice = 188
	desc = "Something about this gem just doesn't sit right with you. Holding it makes the blood leave your fingertips."
	smeltresult = /obj/item/ingot/component/glutcrystal
	dropshrink = 1

/obj/item/roguegem/blood_diamond/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/inhumen/graggar)
			. += span_danger("You know this gem well. They are born out of great violence, but only if it involves the mightiest of warriors. </br>Fleshcrafting it with the meat of whatever warrior birthed this gem will allow me to summon another of their kind into this world.")

/obj/item/roguegem/blood_diamond/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 188, "size" = 1))

/obj/item/roguegem/amethyst
	name = "amythortz"
	icon_state = "amethyst"
	desc = "A deep lavender crystal, it surges with magical energy, yet it's artificial nature means it is worth little."

/obj/item/roguegem/amethyst/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/amethyst_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/roguegem/amethyst/naledi
	name = "naledic amythortz"
	desc = "A deep lavender crystal, crackling with magical energy. To a Disciple, it might simply be a keepsake from pilgrimages abroad: but to a Sojourner, it is the leyline to their arcyne-enchanted form of martial combat. </br>This gemstone can be applied to a yet-unfinished spelltome by those with arcyne potential, in order to recall more spells."

/obj/item/roguegem/random
	name = "random gem"
	desc = "You shouldn't be seeing this."
	icon_state = null

/obj/item/roguegem/random/Initialize()
	..()
	var/newgem = list(/obj/item/roguegem/ruby = 5, 
		/obj/item/roguegem/green = 15, 
		/obj/item/roguegem/blue = 10, 
		/obj/item/roguegem/yellow = 20,
		/obj/item/roguegem/violet = 10,
		/obj/item/roguegem/diamond = 5,
		/obj/item/riddleofsteel = 1,
		/obj/item/rogueore/silver = 3,
		/obj/item/roguegem/onyxa = 5,
		/obj/item/roguegem/jade = 3,
		/obj/item/roguegem/coral = 3,
		/obj/item/roguegem/turq = 3,
		/obj/item/roguegem/amber = 3,
		/obj/item/roguegem/opal = 3,
		/obj/item/roguegem/blood_diamond = 1)
	var/pickgem = pickweight(newgem)
	new pickgem(get_turf(src))
	qdel(src)


/// riddle


/obj/item/riddleofsteel
	name = "riddle of steel"
	icon_state = "ros"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "Flesh, mind."
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 400

/obj/item/riddleofsteel/Initialize()
	. = ..()
	set_light(2, 2, 1, l_color = "#ff0d0d")

	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/gemstaff/quartz_staff,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/pearl
	name = "pearl"
	icon_state = "pearl"
	icon = 'icons/roguetown/items/gems.dmi'
	desc = "A beautiful pearl. Can be strung up into an amulet."
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.4
	drop_sound = 'sound/items/gem.ogg'
	sellprice = 20

/obj/item/pearl/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/pearlcross,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/pearl/blue
	name = "Blue pearl"
	icon_state = "bpearl"
	desc = "A beautiful blue pearl. A bounty of Abyssor. Can be strung up into amulets."
	sellprice = 60

/obj/item/pearl/blue/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/bpearlcross,
		/datum/crafting_recipe/roguetown/survival/abyssoramulet
		)
