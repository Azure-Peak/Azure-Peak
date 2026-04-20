
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
	if(user.mind.has_spell(spell, specific = TRUE))
		to_chat(user, span_warning("You've already read this one!"))
		return TRUE
	return FALSE

/obj/item/book/granter/spell/on_reading_start(mob/user)
	to_chat(user, span_notice("I start reading about casting [spellname]..."))

/obj/item/book/granter/spell/on_reading_finished(mob/user)
	to_chat(user, span_notice("I feel like you've experienced enough to cast [spellname]!"))
	var/datum/S = new spell
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

/obj/item/book/granter/spell/bonechill
	name = "Scroll of Bone Chill"
	spell = /obj/effect/proc_holder/spell/invoked/bonechill
	spellname = "Bone Chill"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scrolldarkred"
	oneuse = TRUE
	drop_sound = 'sound/foley/dropsound/paper_drop.ogg'
	pickup_sound = 'sound/blank.ogg'
	remarks = list("Mediolanum ventis..", "Sana damnatorum..", "Frigidus ossa mortuorum..")

/obj/item/book/granter/spell/bonechill/onlearned(mob/living/carbon/user)
	..()
	if(oneuse)
		name = "siphoned scroll"
		desc = "A scroll once inscribed with magical scripture. The surface is now barren of knowledge, siphoned by someone else. It's utterly useless."
		icon_state = "scroll"
		user.visible_message(span_warning("[src] has had its magic ink ripped from the scroll!"))

