
///books that teach things (intrinsic actions like bar flinging, spells like fireball or smoke, or martial arts)///

/obj/item/book/granter
	due_date = 0 // Game time in deciseconds
	unique = 1   // 0  Normal book, 1  Should not be treated as normal book, unable to be copied, unable to be modified
	var/list/remarks = list() //things to read about while learning.
	var/pages_to_mastery = 3 //Essentially controls how long a mob must keep the book in his hand to actually successfully learn
	var/reading = FALSE //sanity
	var/oneuse = TRUE //default this is true, but admins can var this to 0 if we wanna all have a pass around of the rod form book
	var/used = FALSE //only really matters if oneuse but it might be nice to know if someone's used it for admin investigations perhaps
	var/dreamcost

/obj/item/book/granter/proc/turn_page(mob/user)
	playsound(user, pick('sound/blank.ogg'), 30, TRUE)
	if(do_after(user,50, user))
		if(remarks.len)
			to_chat(user, span_notice("[pick(remarks)]"))
		else
			to_chat(user, span_notice("I keep reading..."))
		return TRUE
	return FALSE

/obj/item/book/granter/proc/recoil(mob/user) //nothing so some books can just return

/obj/item/book/granter/proc/already_known(mob/user)
	return FALSE

/obj/item/book/granter/proc/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading [name]..."))

/obj/item/book/granter/proc/on_reading_stopped(mob/user)
	to_chat(user, span_notice("I stop reading..."))

/obj/item/book/granter/proc/on_reading_finished(mob/user)
	to_chat(user, span_notice("I finish reading [name]!"))

/obj/item/book/granter/proc/onlearned(mob/user)
	used = TRUE


/obj/item/book/granter/attack_self(mob/living/user)
	if(reading)
		to_chat(user, span_warning("I'm already reading this!"))
		return FALSE
	if(!user.can_read(src))
		return FALSE
	if(already_known(user))
		return FALSE
/*	AZURE PEAK REMOVAL -- UNUSED ANYWAY
	if(user.STAINT < 12)
			to_chat(user, span_warning("You can't make sense of the sprawling runes!"))
			return FALSE */
	if(used && oneuse)
		to_chat(user, span_warning("This fount of knowledge was not meant to be sipped from twice!"))
		recoil(user)
		return FALSE
	on_reading_start(user)
	reading = TRUE
	for(var/i=1, i<=pages_to_mastery, i++)
		if(!turn_page(user))
			reading = FALSE
			on_reading_stopped()
			return FALSE
	if(do_after(user, 50, user))
		reading = FALSE
		on_reading_finished(user)
		return TRUE
	reading = FALSE //failsafe
	return FALSE

/obj/item/book/granter/spell
	grid_width = 64
	grid_height = 32

	var/spell
	var/spellname = "conjure bugs"

/obj/item/book/granter/spell/already_known(mob/user)
	if(!spell)
		return TRUE
	for(var/obj/effect/proc_holder/spell/knownspell in user.mind.spell_list)
		if(knownspell.type == spell)
			if(user.mind)
				to_chat(user,span_warning("You've already read this one!"))
			return TRUE
	return FALSE

/obj/item/book/granter/spell/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading about casting [spellname]..."))

/obj/item/book/granter/spell/on_reading_finished(mob/user)
	to_chat(user, span_notice("I feel like you've experienced enough to cast [spellname]!"))
	var/obj/effect/proc_holder/spell/S = new spell
	user.mind.AddSpell(S)
	user.log_message("learned the spell [spellname] ([S])", LOG_ATTACK, color="orange")
	onlearned(user)

/obj/item/book/granter/spell/random
	icon_state = "random_book"

/obj/item/book/granter/spell/random/Initialize()
	. = ..()
	var/static/banned_spells = list(/obj/item/book/granter/spell/mimery_blockade)
	var/real_type = pick(subtypesof(/obj/item/book/granter/spell) - banned_spells)
	new real_type(loc)
	return INITIALIZE_HINT_QDEL

///ACTION BUTTONS///

/obj/item/book/granter/action
	var/granted_action
	var/actionname = "catching bugs" //might not seem needed but this makes it so you can safely name action buttons toggle this or that without it fucking up the granter, also caps

/obj/item/book/granter/action/already_known(mob/user)
	if(!granted_action)
		return TRUE
	for(var/datum/action/A in user.actions)
		if(A.type == granted_action)
			to_chat(user, span_warning("I already know all about [actionname]!"))
			return TRUE
	return FALSE

/obj/item/book/granter/action/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading about [actionname]..."))

/obj/item/book/granter/action/on_reading_finished(mob/user)
	to_chat(user, span_notice("I feel like you've got a good handle on [actionname]!"))
	var/datum/action/G = new granted_action
	G.Grant(user)
	onlearned(user)

//Crafting Recipe books

/obj/item/book/granter/crafting_recipe
	var/list/crafting_recipe_types = list()
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "learning_tome"
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/book/granter/crafting_recipe/on_reading_finished(mob/user)
	. = ..()
	if(!user.mind)
		return
	
	for(var/crafting_recipe_type in crafting_recipe_types)
		var/datum/crafting_recipe/R = crafting_recipe_type
		user.mind.teach_crafting_recipe(crafting_recipe_type)
		to_chat(user,span_notice("I learned how to make [initial(R.name)]."))
	to_chat(user,span_notice("The book falls apart in my hands."))
	qdel(src)

/////////////////////
// TAILORING BOOKS //
/////////////////////

/*
UNDER NO CIRCUMSTANCE SHOULD ANY OF THE BOOKS BE GIVEN OUT INTO SPAWNERS OR TO BE PURCHASABLE, BREAK THAT RULE ON YOUR OWN PERIL
*/
/obj/item/book/granter/crafting_recipe/tailor
	name = "MASTER TAILORING / LEATHERWORKING TOME"
	desc = "If you got hold of this either spawn system screwed up somewhere or admin is trolling you, report THIS."
	oneuse = TRUE
	crafting_recipe_types = list(
		/datum/crafting_recipe/roguetown/sewing/tailor/naledisash,
		/datum/crafting_recipe/roguetown/sewing/tailor/halfrobe,
		/datum/crafting_recipe/roguetown/sewing/tailor/monkrobe,
		/datum/crafting_recipe/roguetown/leather/unique/monkleather,
		/datum/crafting_recipe/roguetown/sewing/tailor/desertgown,
		/datum/crafting_recipe/roguetown/leather/unique/baggyleatherpants,
		/datum/crafting_recipe/roguetown/sewing/tailor/otavangambeson,
		/datum/crafting_recipe/roguetown/leather/unique/otavanleatherpants,
		/datum/crafting_recipe/roguetown/leather/unique/otavanboots,
		/datum/crafting_recipe/roguetown/sewing/tailor/hgambeson/fencer,
		/datum/crafting_recipe/roguetown/leather/unique/fencingbreeches,
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelhat,
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelshirt,
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelpants,
		/datum/crafting_recipe/roguetown/leather/unique/grenzelboots,
		/datum/crafting_recipe/roguetown/leather/unique/furlinedjacket,
		/datum/crafting_recipe/roguetown/leather/unique/artipants,
		/datum/crafting_recipe/roguetown/leatherunique/gladsandals,
		/datum/crafting_recipe/roguetown/leather/unique/buckleshoes,
		/datum/crafting_recipe/roguetown/leather/unique/winterjacket,
		/datum/crafting_recipe/roguetown/leather/unique/openrobes,
		/datum/crafting_recipe/roguetown/leather/unique/monkrobes
	)

/obj/item/book/granter/crafting_recipe/tailor/western
	name = "Grand Codex of Classic Tailoring"
	desc = "A thick book containing details on how to outfit an army of mammon-seeking scoundrels in style. Something tells you the author mislead you with the title."
	crafting_recipe_types = list(
		/datum/crafting_recipe/roguetown/sewing/tailor/otavangambeson,
		/datum/crafting_recipe/roguetown/leather/unique/otavanleathergloves,
		/datum/crafting_recipe/roguetown/leather/unique/otavanleatherpants,
		/datum/crafting_recipe/roguetown/leather/unique/otavanboots,//Otavan
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelhat,
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelshirt,
		/datum/crafting_recipe/roguetown/leather/unique/grenzelgloves,
		/datum/crafting_recipe/roguetown/sewing/tailor/grenzelpants,
		/datum/crafting_recipe/roguetown/leather/unique/grenzelboots//Grenzel
	)

/obj/item/book/granter/crafting_recipe/tailor/eastern
	name = "Almanach of Heritage Tailoring"
	desc = "A collection of images and instructions on how to assemble traditional outfits of more isolationist groups."
	crafting_recipe_types = list(
		/datum/crafting_recipe/roguetown/sewing/tailor/naledisash,
		/datum/crafting_recipe/roguetown/sewing/tailor/halfrobe,
		/datum/crafting_recipe/roguetown/sewing/tailor/monkrobe,
		/datum/crafting_recipe/roguetown/leather/unique/monkleather,
		/datum/crafting_recipe/roguetown/sewing/tailor/desertgown,
		/datum/crafting_recipe/roguetown/leather/unique/baggyleatherpants,//Naledi
		/datum/crafting_recipe/roguetown/sewing/tailor/hgambeson/fencer,
		/datum/crafting_recipe/roguetown/leather/unique/fencingbreeches,//Aanvr
		/datum/crafting_recipe/roguetown/leather/unique/openrobes,
		/datum/crafting_recipe/roguetown/leather/unique/gronngloves,
		/datum/crafting_recipe/roguetown/leather/unique/gronnpants,
		/datum/crafting_recipe/roguetown/leather/unique/gronnboots//Gronn
	)

//! --BLACKSTONE SCROLLS-- !/
/obj/item/book/granter/spell/blackstone/
    desc = "A scroll of potential known only to those that can decipher its secrets."
    icon = 'icons/roguetown/items/misc.dmi'
    oneuse = TRUE
    drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
    pickup_sound =  'sound/blank.ogg'

/obj/item/book/granter/spell/blackstone/Initialize()
	..()
	if(spell)
		var/obj/effect/proc_holder/S = spell
		desc = "[S.desc]"

/obj/item/book/granter/spell/blackstone/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		name = "siphoned scroll"
		desc = "A scroll once inscribed with magical scripture. The surface is now barren of knowledge, siphoned by someone else. It's utterly useless."
		icon_state = "scroll"
		user.visible_message(span_warning("[src] has had its magic ink ripped from the scroll!"))

/obj/item/book/granter/spell/blackstone/fireball
	name = "Scroll of Fireball"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/fireball
	spellname = "fireball"
	icon_state ="scrollred"
	remarks = list("Ignis et oleum..", "Flammam continere ad momentum..", "Flammam iactare..", "Sit flamma constructum..")
	dreamcost = 9

/obj/item/book/granter/spell/blackstone/greaterfireball
	name = "Scroll of Greater Fireball"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/fireball/greater
	spellname = "greater fireball"
	icon_state ="scrollred"
	remarks = list("Ignis et oleum..", "Flammam continere ad momentum..", "Flammam iactare..", "Sit flamma constructum..")

/obj/item/book/granter/spell/blackstone/lightning
	name = "Scroll of Lightning"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt
	spellname = "lightning"
	icon_state ="scrollyellow"
	remarks = list("Essentia fulgurum digitorum..", "Fulgur de nubibus desuper..", "Fulgur eiecit digitos..", "Praecipe intus aedificatur..")
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/fetch
	name = "Scroll of Fetch"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/fetch
	spellname = "fetch"
	icon_state ="scrollpurple"
	remarks = list("Returnus Revico..", "Manus de reverti..", "Menus de returnus..")
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/invisibility
	name = "Scroll of Invisibility"
	spell = /obj/effect/proc_holder/spell/invoked/invisibility
	spellname = "invisibility"
	icon_state ="scrollpurple"
	remarks = list("Pallium nihilum..", "Occultare veritatem..", "Veritatem removan menor..")
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/skeleton
	name = "Scroll of Raise Skeleton"
	spell = /obj/effect/proc_holder/spell/invoked/raise_undead
	spellname = "Raise Skeleton"
	icon_state ="scrolldarkred"
	remarks = list("Redi damnatos..", "Exitio ad Necram scriptor exolvuntur..", "Ossa in propinquus..")

/obj/item/book/granter/spell/blackstone/sicknessray
	name = "Scroll of Sickness Ray"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/sickness
	spellname = "Ray of Sickness"
	icon_state ="scrollgreen"
	remarks = list("Foe rubiginem meam..", "Pestilentia in terris..", "Trabes putrida..")

/obj/item/book/granter/spell/blackstone/bonechill
	name = "Scroll of Bone Chill"
	spell = /obj/effect/proc_holder/spell/invoked/bonechill
	spellname = "Bone Chill"
	icon_state ="scrolldarkred"
	remarks = list("Mediolanum ventis..", "Sana damnatorum..", "Frigidus ossa mortuorum..")

/obj/item/book/granter/spell/blackstone/acidsplash
	name = "Scroll of Acid Splash"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/acidsplash
	spellname = "Acid Splash"
	icon_state ="scrolldarkred"
	remarks = list("Lapides corrodunt..", "Spuma venenosa..", "Guttae flavescentes..")
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/spitfire
	name = "Scroll of Spitfire"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/spitfire
	spellname = "Spitfire"
	icon_state ="scrollred"
	remarks = list("Ignis et oleum..", "Flammam continere ad momentum..", "Flammam iactare..", "Sit flamma constructum..")
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/lesserknock
	name = "Scroll of Lesser Knock"
	spell = /obj/effect/proc_holder/spell/targeted/touch/lesserknock
	spellname = "Lesser Knock"
	icon_state ="scrollred"
	remarks = list("Clavis vetusta portam..", "Perdita numquam..", "Manus tremens..")
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/repel
	name = "Scroll of Repel"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/repel
	spellname = "Repel"
	icon_state ="scrolldarkred"
	remarks = list("Ventos adversos..", "Terra sibilat..", "Lapides vetusti..")
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/guidance
	name = "Scroll of Guidance"
	spell = /obj/effect/proc_holder/spell/invoked/guidance
	spellname = "Guidance"
	icon_state ="scrolldarkred"
	remarks = list("Lux in tenebris..", "Passus certus umbras non timet..", "Anima viam scit..")
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/frostbolt
	name = "Scroll of Frostbolt"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/frostbolt
	spellname = "Frostbolt"
	icon_state ="scrolldarkred"
	remarks = list("Gelum serpentibus..", "Crystallum in silentio..", "Nullum ardor glaciem..")
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/fortitude
	name = "Scroll of Fortitude"
	spell = /obj/effect/proc_holder/spell/invoked/fortitude
	spellname = "Fortitude"
	icon_state ="scrolldarkred"
	remarks = list("Animus in adversis..", "Gravitas oneris..", "Vita renascitur..")
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/message
	name = "Scroll of Message"
	spell = /obj/effect/proc_holder/spell/self/message
	spellname = "Message"
	icon_state ="scrolldarkred"
	remarks = list("Verba volant..", "Vincula inter mentes..", "Inter verba et silentium..")
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/ensnare
	name = "Scroll of Ensnare"
	spell = /obj/effect/proc_holder/spell/invoked/ensnare
	spellname = "Ensnare"
	icon_state ="scrolldarkred"
	remarks = list("Qui intrat..", "Radices in tenebris..", "Nexus occultus..")
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/forcewall_weak
	name = "Scroll of Forcewall"
	spell = /obj/effect/proc_holder/spell/invoked/forcewall
	spellname = "Forcewall"
	icon_state ="scrolldarkred"
	remarks = list("Murus non solum hostem..", "Manus invisibiles saxa invicem..", "Infracta moenia..")
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/featherfall
	name = "Scroll of Featherfall"
	spell = /obj/effect/proc_holder/spell/invoked/featherfall
	spellname = "Featherfall"
	icon_state ="scrolldarkred"
	remarks = list("In silentio cadit..", "Alis levitas..", "Plumis taciti dolores..")
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/enlarge
	name = "Scroll of Enlarge"
	spell = /obj/effect/proc_holder/spell/invoked/enlarge
	spellname = "Enlarge"
	icon_state ="scrolldarkred"
	remarks = list("Immensum agitur..", "Montes tremunt..", "Quantitas expanditur..")
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/leap
	name = "Scroll of Leap"
	spell = /obj/effect/proc_holder/spell/invoked/leap
	spellname = "Leap"
	icon_state ="scrolldarkred"
	remarks = list("Altitudinem revelat..", "Cuius pedes in aere volant..", "In levitate audacia..")
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/repulse
	name = "Scroll of Repulse"
	spell = /obj/effect/proc_holder/spell/invoked/repulse
	spellname = "Repulse"
	icon_state ="scrolldarkred"
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/blade_burst
	name = "Scroll of Blade Burst"
	spell = /obj/effect/proc_holder/spell/invoked/blade_burst
	spellname = "Blade Burst"
	icon_state ="scrolldarkred"
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/haste
	name = "Scroll of Haste"
	spell = /obj/effect/proc_holder/spell/invoked/haste
	spellname = "Haste"
	icon_state ="scrolldarkred"
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/longstrider
	name = "Scroll of Longstrider"
	spell = /obj/effect/proc_holder/spell/invoked/longstrider
	spellname = "Longstrider"
	icon_state ="scrolldarkred"
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/arcynebolt
	name = "Scroll of Arcyne Bolt"
	spell = /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt
	spellname = "Arcyne Bolt"
	icon_state ="scrolldarkred"
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/counterspell
	name = "Scroll of Counterspell"
	spell = /obj/effect/proc_holder/spell/invoked/counterspell
	spellname = "Counterspell"
	icon_state ="scrolldarkred"
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/blink
	name = "Scroll of Blink"
	spell = /obj/effect/proc_holder/spell/invoked/blink
	spellname = "Blink"
	icon_state ="scrolldarkred"
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/mirror_transform
	name = "Scroll of Mirror Transform"
	spell = /obj/effect/proc_holder/spell/invoked/mirror_transform
	spellname = "Mirror Transform"
	icon_state ="scrolldarkred"
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/stoneskin
	name = "Scroll of Stoneskin"
	spell = /obj/effect/proc_holder/spell/invoked/stoneskin
	spellname = "Stoneskin"
	icon_state ="scrolldarkred"
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/hawks_eyes
	name = "Scroll of Hawks Eyes"
	spell = /obj/effect/proc_holder/spell/invoked/hawks_eyes
	spellname = "Hawks Eyes"
	icon_state ="scrolldarkred"
	dreamcost = 3

/obj/item/book/granter/spell/blackstone/mending
	name = "Scroll of Mending"
	spell = /obj/effect/proc_holder/spell/invoked/mending
	spellname = "Stoneskin"
	icon_state ="scrolldarkred"
	dreamcost = 6

/obj/item/book/granter/spell/blackstone/familiar //Find Familiar Scroll
	name = "Scroll of Find Familiar"
	spell = /obj/effect/proc_holder/spell/self/findfamiliar
	spellname = "Find Familiar"
	icon_state ="scrolldarkred"
	oneuse = FALSE

//scroll for giving the reader 3 spell points, this should be dungeon loot
/obj/item/book/granter/spell_points
	name = "Arcyne Insight"
	icon_state = "scrollpurple"
	icon = 'icons/roguetown/items/misc.dmi'
	desc = "This scroll grants the reader an additional three spell points. They must already be a NOVICE in the arcyne..."
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'
	var/spellpoints = 3
	dreamcost = 12

/obj/item/book/granter/spell_points/on_reading_finished(mob/user)
	var/arcaneskill = user.get_skill_level(/datum/skill/magic/arcane)
	if(arcaneskill >= SKILL_LEVEL_NOVICE) //Required arcane skill of NOVICE or higher to use the granter
		to_chat(user, span_notice("I absorb the insights on the scroll, and feel more adept at spellcraft!"))
		user.mind.adjust_spellpoints(spellpoints)
		onlearned(user)
	else
		to_chat(user, span_notice("I don't know what to make of this."))

/obj/item/book/granter/spell_points/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		name = "siphoned scroll"
		desc = "A scroll once inscribed with magical scripture. The surface is now barren of knowledge, siphoned by someone else. It's utterly useless."
		icon_state = "scroll"
		user.visible_message(span_warning("[src] has had its magic ink ripped from the scroll!"))

/obj/item/book/granter/spell_points/voiddragon
	name = "Arcyne Void Insight"
	spellpoints = 6

/obj/item/book/granter/arcynetyr
	name = "Arcyne Manuscript"
	icon_state = "scrollpurple"
	icon = 'icons/roguetown/items/misc.dmi'
	desc = "This scroll gives the reader greater arcyne power, and spell-points to accompany it."
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound =  'sound/blank.ogg'
	var/spellpoints = 3
	dreamcost = 15

/obj/item/book/granter/arcynetyr/on_reading_finished(mob/user)
	var/arcaneskill = user.get_skill_level(/datum/skill/magic/arcane)
	if(arcaneskill >= SKILL_LEVEL_NOVICE) //Required arcane skill of NOVICE or higher to use the granter
		to_chat(user, span_notice("I absorb the insights on the scroll, and feel more adept at spellcraft!"))
		if(HAS_TRAIT(user, TRAIT_ARCYNE_T3) || HAS_TRAIT(user, TRAIT_ARCYNE_T4))
			user.mind.adjust_spellpoints(5)
		if(HAS_TRAIT(user, TRAIT_ARCYNE_T2))
			ADD_TRAIT(user, TRAIT_ARCYNE_T3, TRAIT_GENERIC)
			user.mind.adjust_spellpoints(1)
			REMOVE_TRAIT(user, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
		if(HAS_TRAIT(user, TRAIT_ARCYNE_T1))
			ADD_TRAIT(user, TRAIT_ARCYNE_T2, TRAIT_GENERIC)
			user.mind.adjust_spellpoints(1)
			REMOVE_TRAIT(user, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
		onlearned(user)

/obj/item/book/granter/arcynetyr/onlearned(mob/living/carbon/user)
	..()
	if(oneuse == TRUE)
		name = "siphoned scroll"
		desc = "A scroll once inscribed with magical scripture. The surface is now barren of knowledge, siphoned by someone else. It's utterly useless."
		icon_state = "scroll"
		user.visible_message(span_warning("[src] has had its magic ink ripped from the scroll!"))
