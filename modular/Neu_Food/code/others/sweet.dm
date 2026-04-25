// -------------- CHOCOLATE -----------------
/obj/item/reagent_containers/food/snacks/chocolate
	name = "chocolate ingot"
	desc = "An unbelievably decadant slab of fudge, made with Amazonia's cocoa beans and Grenzelhoft's saiga milk. A \
	recent trade agreement between the two nations has turned this once-expensive delicacy into a slightly-less-expensive \
	treat for many. </br>Following a rather unfortunate diplomatic incident involving a Lupian nobleman and a box of chocolates, \
	chocolate is also now-known to double as a potent 'humor rebalancer' for some of Dendor's children. </br>It looks like it can be \
	split in half with a dagger."
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "chocolate"
	bitesize = 4
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/chocolate/slice
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("sugary richness" = 1)
	faretype = FARE_LAVISH
	rotprocess = null
	eat_effect = /datum/status_effect/buff/sweet
	chopping_sound = TRUE

/obj/item/reagent_containers/food/snacks/chocolate/On_Consume(mob/living/eater)
	if(islupian(eater) || isvulp(eater))
		to_chat(eater, span_warning("The chocolate tastes delicious but my stomach churns violently!"))
		if(iscarbon(eater))
			var/mob/living/carbon/C = eater
			C.add_nausea(120) // enough to trigger vomiting
		eater.adjustToxLoss(5)
	return ..()

/obj/item/reagent_containers/food/snacks/chocolate/slice
	name = "halved chocolate ingot"
	desc = "An unbelievably decadant halve of fudge, made with Amazonia's cocoa beans and Grenzelhoft's saiga milk. A \
	recent trade agreement between the two nations has turned this once-expensive delicacy into a slightly-less-expensive \
	treat for many. </br>Following a rather unfortunate diplomatic incident involving a Lupian nobleman and a box of chocolates, \
	chocolate is also now-known to double as a potent 'humor rebalancer' for some of Dendor's children. </br>When combined with \
	pumpkin spice and tossed into a kettle, it makes for an absolutely divine drink."
	bitesize = 3 //Sharing is caring!
	icon_state = "chocolatehalf"
	slices_num = null
	slice_path = null

/obj/item/reagent_containers/food/snacks/jamtallow
	name = "stick of jamtallow"
	desc = "An ingot of jammified blackberries, fit only for the finest slices of bread. It beckons to be sliced with proper cutlery."
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "jamtallow6"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_POOR //Slightly better than eating a whole log of butter on your lonesome. Slightly.
	slice_path = /obj/item/reagent_containers/food/snacks/jamtallowslice
	slices_num = 6
	slice_batch = FALSE
	bitesize = 6
	slice_sound = TRUE
	tastes = list("stickied deliciousness" = 1, "subtle sour-tartiness" = 1)
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/jamtallow/update_icon()
	if(slices_num)
		icon_state = "jamtallow[slices_num]"
	else
		icon_state = "jamtallow_slice"

/obj/item/reagent_containers/food/snacks/jamtallow/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 1)
			slices_num = 5
		if(bitecount == 2)
			slices_num = 4
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/jamtallowslice
	name = "slice of jamtallow"
	desc = "A portion of jammy paradise, bearing the same hues as Azuria's morning skies. It yearns to be savored not by its lonesome, but upon a slice of bread - ideally, butterdoughed or toasted."
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "jamtallow_slice"
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("stickied deliciousness" = 1, "subtle sour-tartiness" = 1)
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/marmalade
	name = "stick of marmalade"
	desc = "An ingot of jammified tangerines, fit only for the finest slices of bread. It beckons to be sliced with proper cutlery."
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "marmalade6"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_POOR //Slightly better than eating a whole log of butter on your lonesome. Slightly.
	slice_path = /obj/item/reagent_containers/food/snacks/marmaladeslice
	slices_num = 6
	slice_batch = FALSE
	bitesize = 6
	slice_sound = TRUE
	tastes = list("stickied deliciousness" = 1, "subtle sweet-tartiness" = 1)
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/marmalade/update_icon()
	if(slices_num)
		icon_state = "marmalade[slices_num]"
	else
		icon_state = "marmalade_slice"

/obj/item/reagent_containers/food/snacks/marmalade/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 1)
			slices_num = 5
		if(bitecount == 2)
			slices_num = 4
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/marmaladeslice
	name = "slice of marmalade"
	desc = "A portion of jammy paradise, bearing the same hues as Azuria's evening seas. It yearns to be savored not by its lonesome, but upon a slice of bread - ideally, butterdoughed or toasted."
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "marmalade_slice"
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("stickied deliciousness" = 1, "subtle sweet-tartiness" = 1)
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/caramel
	name = "caramel giblets"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "caramel3"
	desc = "Glassy droppings of tallow-fried sugar, oft-divvied out amongst the youth by Psydonia's wisest and kindliest elders."
	faretype = FARE_FINE
	fried_type = null
	bitesize = 3
	slice_path = null
	tastes = list("rich sugariness" = 1, "a lingering sweetness on the tongue" = 1)
	w_class = WEIGHT_CLASS_TINY
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/caramel/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "caramel2"
	if(bitecount == 2)
		icon_state = "caramel1"

/obj/item/reagent_containers/food/snacks/dragee
	name = "dragée"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "dragee3"
	desc = "Glassy droppings of tallow-fried rocknuts, coated in sugary shells and laced with herbal medicine. Such giblets are popular \
	amongst Psydonia's youth - both as a reward to Otavan children for remembering their scripture, and as a remedy to childhood ailments."
	faretype = FARE_LAVISH
	fried_type = null
	bitesize = 3
	slice_path = null
	tastes = list("nutty sugariness" = 1, "a lingering hint of herbal warmth on the tongue" = 1)
	w_class = WEIGHT_CLASS_TINY
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT, /datum/reagent/medicine/healthpot = 5) //Very light medicinal effect, equivalent to half of a vial when fully eaten. Yum!
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/dragee/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "dragee2"
	if(bitecount == 2)
		icon_state = "dragee1"

//SUGARSHAPES!!!
/obj/item/reagent_containers/food/snacks/grown/sugarshape
	name = "sugarshape"
	desc = "A mound of sugar, shaped into a decorative treat. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "sugarmound"
	fried_type = null
	slice_path = null
	rotprocess = null
	faretype = FARE_POOR
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("a mouthful of sugar" = 1)
	mill_result = /obj/item/reagent_containers/food/snacks/sugar
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/grown/sugarshape/dmark
	name = "sugarshape of ducal mark"
	desc = "A mound of sugar, shaped into a decorative mark with Azuria's sigil. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/dmark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/smark
	name = "sugarshape of skull mark"
	desc = "A mound of sugar, shaped into a decorative skull-mark. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/smark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/amark
	name = "sugarshape of holy mark"
	desc = "A mound of sugar, shaped into a decorative mark with the Church's sigil. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/amark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/zmark
	name = "sugarshape of zizonic mark"
	desc = "A mound of sugar, shaped into a decorative mark with Zizo's sigil. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/zmark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/pmark
	name = "sugarshape of psydonic mark"
	desc = "A mound of sugar, shaped into a decorative mark with Psydon's sigil. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/pmark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/hmark
	name = "sugarshape of heart mark"
	desc = "A mound of sugar, shaped into a decorative heart-mark. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/hmark

/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuer
	name = "sugarshape of ducal statue"
	desc = "A mound of sugar, shaped into a decorative royaltere. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/statuer

/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuek
	name = "sugarshape of knightly statue"
	desc = "A mound of sugar, shaped into a decorative knight. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/statuek

/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuey
	name = "sugarshape of yeomannic statue"
	desc = "A mound of sugar, shaped into a decorative yeoman. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/statuey

/obj/item/reagent_containers/food/snacks/grown/sugarshape/statuel
	name = "sugarshape of lordly statue"
	desc = "A mound of sugar, shaped into a decorative lord. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/statuel

/obj/item/reagent_containers/food/snacks/grown/sugarshape/arch
	name = "sugarshape of arch"
	desc = "A mound of sugar, shaped into a decorative arch. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/arch

/obj/item/reagent_containers/food/snacks/grown/sugarshape/archway
	name = "sugarshape of archway"
	desc = "A mound of sugar, shaped into a decorative archway. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/archway

/obj/item/reagent_containers/food/snacks/grown/sugarshape/tower
	name = "sugarshape of tower"
	desc = "A mound of sugar, shaped into a decorative tower. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/tower

/obj/item/reagent_containers/food/snacks/grown/sugarshape/towers
	name = "sugarshape of small tower"
	desc = "A mound of sugar, shaped into a decorative small tower. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/towers

/obj/item/reagent_containers/food/snacks/grown/sugarshape/castle
	name = "sugarshape of castle"
	desc = "A mound of sugar, shaped into a decorative castle. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/castle

/obj/item/reagent_containers/food/snacks/grown/sugarshape/flag
	name = "sugarshape of flag"
	desc = "A mound of sugar, shaped into a decorative flag. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/flag

/obj/item/reagent_containers/food/snacks/grown/sugarshape/house
	name = "sugarshape of house"
	desc = "A mound of sugar, shaped into a decorative house. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/house

/obj/item/reagent_containers/food/snacks/grown/sugarshape/tree
	name = "sugarshape of tree"
	desc = "A mound of sugar, shaped into a decorative tree. It yearns to be completed beneath an oven's heat, or to be milled back down into sugarpowder."
	cooked_type = /obj/item/reagent_containers/food/snacks/sugarstatue/tree

/obj/item/reagent_containers/food/snacks/sugarstatue
	name = "sugarglass statue"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a statue. Deliciously regal!"
	icon = 'modular/Neu_Food/icons/others/sweet.dmi'
	icon_state = "sugarstatue"
	fried_type = null
	slice_path = null
	rotprocess = null
	faretype = FARE_FINE
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("crispy sugarglass" = 1)
	sellprice = 15
	drop_sound = 'sound/foley/dropsound/glass_drop.ogg'
	eat_effect = /datum/status_effect/buff/sweet

/obj/item/reagent_containers/food/snacks/sugarstatue/dmark
	name = "ducal sugarglass mark"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a sigil of Azuria's royal house. Deliciously regal!"
	icon_state = "sugarstatuemarkd"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/smark
	name = "skulled sugarglass mark"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic the visage of a chittering skull. Deliciously deathsome!"
	icon_state = "sugarstatuemarks"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/amark
	name = "holy sugarglass mark"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a sigil of the Church. Deliciously holy!"
	icon_state = "sugarstatuemarka"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/zmark
	name = "zizonic sugarglass mark"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a sigil of Zizo. Deliciously sinful!"
	icon_state = "sugarstatuemarkz"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/pmark
	name = "psydonic sugarglass mark"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a sigil of Psydon. Deliciously enduring!"
	icon_state = "sugarstatuemarkp"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/hmark
	name = "hearted sugarglass mark"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic the visage of a poem's heart. Deliciously lovely!"
	icon_state = "sugarstatuemarkh"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/statuer
	name = "royal sugarglass statue"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a person of royalty. Deliciously tyrannical!"
	icon_state = "sugarstatuequeen"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/statuek
	name = "knightly sugarglass statue"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a knight in shining armor. Deliciously chivalrous!"
	icon_state = "sugarstatueknight"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/statuel
	name = "lordly sugarglass statue"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a crowned lord. Deliciously noble!"
	icon_state = "sugarstatue"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/statuey
	name = "yeomannic sugarglass statue"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a cloaked yeoman. Deliciously dutiful!"
	icon_state = "sugarstatueyeoman"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/arch
	name = "sugarglass arch"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a connectable archbridge. Deliciously masonic!"
	icon_state = "sugarstatuearch"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/archway
	name = "sugarglass archway"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a twin-towered archway. Deliciously imposing!"
	icon_state = "sugarstatuearchway"
	bitesize = 4

/obj/item/reagent_containers/food/snacks/sugarstatue/tower
	name = "sugarglass tower"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a tower. Deliciously parapitted!"
	icon_state = "sugarstatuetower"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/sugarstatue/towers
	name = "small sugarglass tower"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a small tower. Deliciously barred!"
	icon_state = "sugarstatuesmalltower"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/castle
	name = "sugarglass castle"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic the Keep. Deliciously fortified!"
	icon_state = "sugarstatuecastle"
	bitesize = 4

/obj/item/reagent_containers/food/snacks/sugarstatue/flag
	name = "sugarglass flag"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a flag-in-motion. Deliciously decorative!"
	icon_state = "sugarstatueflag"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/house
	name = "sugarglass house"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a humble abode. Deliciously cozy!"
	icon_state = "sugarstatuehouse"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sugarstatue/tree
	name = "sugarglass tree"
	desc = "A decorative piece of sugarglass, meticulously fashioned to mimic a thriving tree. Deliciously natural!"
	icon_state = "sugarstatuetree"
	bitesize = 3
