/datum/action/cooldown/spell/readomen
	name = "Read Omen"
	desc = "A spell used to read the secrets of the world. This spell has two modes, OMEN, and ORB. \n\
	While in OMEN mode, casting the spell will give you a vague reading of the leylines indicating which pantheon is dominant currently. \n\
	While in Orb Mode, casting the spell summons an ORB OF WISDOM. \n\
	clicking with it will cause the orb to answer one of your deepest questions."
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "readomen"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Miror quid.") // I wonder why
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 1 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 1

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/current_mode = 1
	var/list/modes = list(
		list("name" = "Read Omen", "tag" = "OMEN", "icon" = "readomen", "invocation" = "Caelum Feri!"),
		list("name" = "Orb of Wisdom", "tag" = "ORB", "icon" = "readomen", "invocation" = "Feri Fulmine Hostem!"),
	)

	var/list/reign_messages = list(
		/datum/faith/divine = list(
			/datum/faith/divine = "The Leylines feel still, and ready to be molded.",
			/datum/faith/inhumen = "They Leylines feel controlled, like it's potential is being suppressed.",
			/datum/faith/old_god = "They Leylines feel average, they could always be more controlled.",
		),
		/datum/faith/inhumen = list(
			/datum/faith/inhumen = "The Leylines feel ripe for change, excitement fills your Lux as you behold it.",
			/datum/faith/divine = "The Leylines feel unstable, something is causing the mana in them to fluxuate.",
			/datum/faith/old_god = "The Leylines are being leeched, something is manipulating Psydonia.",
		),
		/datum/faith/old_god = list(
			/datum/faith/divine = "The Leylines feel dull, perhaps they are healing.",
			/datum/faith/inhumen = "The Leylines power is being dulled, an insult to the Arcyne.",
			/datum/faith/old_god = "The Leylines are as they should be, a perfect balance of calm.",
		)
	)

	var/obj/item/rogueweapon/conjured_orb = null

/datum/action/cooldown/spell/readomen/Grant(mob/grant_to)
	. = ..()
	apply_mode(current_mode)

/datum/action/cooldown/spell/readomen/proc/apply_mode(index)
	var/list/mode = modes[index]
	name = mode["name"]
	button_icon_state = mode["icon"]
	invocations = list(mode["invocation"])
	build_all_button_icons()
	update_mode_maptext(mode["tag"])

/datum/action/cooldown/spell/readomen/toggle_alt_mode(mob/user)
	current_mode = (current_mode % length(modes)) + 1
	apply_mode(current_mode)
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]] mode."))
	return TRUE

/datum/action/cooldown/spell/readomen/proc/update_mode_maptext(tag)
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(tag)
		holder.maptext_x = 5
		holder.color = GLOW_COLOR_LIGHTNING

/datum/action/cooldown/spell/readomen/cast()
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(current_mode == 1)
		cast_omen(H)
	else
		cast_orb(H)
	return TRUE

/datum/action/cooldown/spell/readomen/proc/cast_omen(mob/living/user)
	var/dominant_faith = GLOB.dominant_faith_tracker.dominant_faith
	user.visible_message(span_info("The eyes of [user] roll back into their head for a moment!"), span_info("Your eyes roll into the back of your head!"))
	if(!istype(user) || !user.patron || ispath(user.patron.associated_faith, /datum/faith/godless))
		to_chat(user, "<span class='warning'>For some reason, I cannot get a good grasp of the Leylines.</span>")
		return FALSE
	if(ispath(user.patron.associated_faith, /datum/faith/accelerationism))
		to_chat(user, "<span class='warningbig'>FUCK THE LEYLINES, THEY ARE A TOOL, I DON'T CARE HOW THEY FEEL. I'LL BLOW THEM THE FUCK UP TOO WHEN I'M DONE.</span>")
		return FALSE
	if(ispath(user.patron.associated_faith, /datum/faith/mossmother))
		to_chat(user, "<span class='blue'>The Leylines moods are of no concern to me.</span>")
		return FALSE
	if(ispath(dominant_faith, /datum/faith/old_god))
		to_chat(user, span_blue(replacetext(reign_messages[user.patron.associated_faith][dominant_faith], "$patron", get_god_name(user.patron))))
	else if(ispath(user.patron.associated_faith, dominant_faith))
		to_chat(user, span_boldgreen(replacetext(reign_messages[user.patron.associated_faith][dominant_faith], "$patron", get_god_name(user.patron))))
	else
		to_chat(user, span_warningbig(replacetext(reign_messages[user.patron.associated_faith][dominant_faith], "$patron", get_god_name(user.patron))))



/datum/action/cooldown/spell/readomen/proc/cast_orb(atom/cast_on)
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	if(src.conjured_orb)
		qdel(conjured_orb)
	var/obj/item/R = new /obj/item/orbofwisdom(user.drop_location())
	R.AddComponent(/datum/component/conjured_item, null, FALSE, user, src)
	user.put_in_hands(R)
	src.conjured_orb = R
	return TRUE

/obj/item/orbofwisdom
	name = "orb of wisdom"
	desc = "Said to house the essence of the condemned Wizard 'Mineester the Omnipotent', whomst was punished for his hubris and arrogance. His grand punishment is to serve as a simple tool for answering any and all the questions that may be posed by all the Magos of Psydonia. (CLICK WITH THE ORB TO ANSWER YOUR QUESTION)"
	w_class = WEIGHT_CLASS_NORMAL
	force = 10
	icon = 'icons/roguetown/rav/obj/cult.dmi'
	color = "#72cbff"
	icon_state = "sphere0"
	item_state = "sphere0"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	possible_item_intents = list(/datum/intent/use)

/obj/item/orbofwisdom/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()

	var/turf/T = get_turf(src)
	var/list/florish_message = list("A brilliant question, truelee...", "Hrm... allow me to PONDER this question...", "BAH, to thynk my wisdom is wasted on such a question...", "I SUPPOSE I can contemplate this...", "You know I used to be a GRANDMASTER?", "I miss my wyfe...", "Hrm! Allow me to ponder... WOOOSHH WHHSHWOOOSH, WHOOSSSHH...", "Whatte? MUST I ponder this? Fyne...", "TO THINK my ABILITIES could be used for FAR BETTER THINGS THAN SUCH a SIMPLE QUESTION... alas...", "Yeeees, Yeeeeees. I will answer your question you fool...")
	var/list/arcyne_wisdom = list("THE ANSWER IS YES.", "Maybe? It is uncertain.", "Yeeeeeeees.", "Absolutely not, now unhand me.", "No.", "I am so tired, ask me later.", "I COULD HAVE BEEN A LYCH AT THIS POINT BUT NO, I HAVE TO ANSWER YOUR FOOLISH QUESTI- sure whatever.", "Perhaps another Magos should ask.", "No, you weerdoe.", "PERHAPS. Perhaps...")

	if(!HAS_TRAIT(user, TRAIT_ARCYNE))
		visible_message(span_warningbig("FOOL, you are no Wyzard, I'm not LEGALLY BOUND to answer to your QUESTIONS, unhand me at this instant."))
		user.dropItemToGround(src)
		playsound(src, 'sound/combat/hits/onglass/glassbreak (2).ogg', 100)
		qdel(src)
		return
	else
		visible_message(span_say("[src] bellows \"[pick(florish_message)]\""))
		sleep(rand(1 SECONDS, 5 SECONDS))
		visible_message(span_say("[src] answers \"[pick(arcyne_wisdom)]\""))
		sleep(2 SECONDS)
		visible_message(span_say("[src] says \"NOW, I must AWAY. Other Wyzards need my wisdom.\""))
		sleep(1 SECONDS)
		playsound(src, 'sound/combat/tempo_loss.ogg', 100)
		visible_message(span_emote("[src] poofs in a puff of smoke."))
		if(T)
			var/mutable_appearance/poof = mutable_appearance('icons/effects/effects.dmi', "mist", layer = 10)
			T.add_overlay(poof)
			addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), poof), 1 SECONDS)
		qdel(src)
		return
