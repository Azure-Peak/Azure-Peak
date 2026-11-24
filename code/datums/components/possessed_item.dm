#define POSSESSION_PROMPT_COOLDOWN 1 MINUTES	// so people can't spam it
#define CURSE_CORRUPTION_THRESHOLD 5 MINUTES	// after using a cursed item's power, you have this long to take it off before bad shit can start happening
#define POSSESSION_END_COOLDOWN 15 MINUTES		// if a possession ends by force, they'll have to wait this long before trying again.

/// an item with a mob inside. unlike /obj/item/mob_item and shapeshift_holder, this is specifically built to handle the mob in question possessing whoever
/// has the item equipped. while a bespoke system for counting item 'uses' is possible, it's easier and more streamlined to just have using the item start
/// a timer until you're vulnerable, with dropping the item stopping the timer
/datum/component/possessed_item
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// who has this item held/equipped, currently. can be null, otherwise will always be a minded humanmob
	var/mob/living/carbon/human/bearer
	/// who's inside the item? will never be null
	var/mob/living/carbon/human/spirit
	/// can be null. if non-null, this'll grant the item a heretical tag
	var/heresy_severity
	/// set alongside heresy_severity to provide a reason it looks heretical
	var/heresy_desc
	var/heresy_severity_active
	var/heresy_desc_active
	var/heresy_severity_passive
	var/heresy_desc_passive
	/// list of people (realnames) who've met the requirements for us to possess them without their active consent. basically, passing a threshold for "using" the spirit's power
	var/list/users = list()
	/// whether we actually CAN possess without consent. not true by default
	var/powerful
	/// if this is null, we're not resisting. otherwise, it's the timer id counting down towards auto-release
	var/resist_timer_id
	/// whether we should delete the item when we resist out of it
	var/ephemeral
	COOLDOWN_DECLARE(possession_prompt)
	COOLDOWN_DECLARE(possession_cooldown)
	/// holder for the lifesteal effect on weapons
	var/datum/magic_item/greater/lifesteal/magic_effect
	var/curse_timer_id
	var/item_filter
	var/bearer_verb // we use this for infernal armor, but if we later add non-vheslynite possession it could be something else
	var/possession_verbiage // visible message on host possession

/datum/component/possessed_item/Initialize(mob/living/carbon/human/possessor, outline_color, h_severity_passive, h_desc_passive, h_severity_active, h_desc_active, start_powerful = FALSE, temp = FALSE, verb_to_bearer, revert_on_break = TRUE, verbiage)
	if(!isitem(parent) || !possessor)
		return COMPONENT_INCOMPATIBLE
	spirit = possessor
	var/obj/item/I = parent
	possessor.forceMove(parent)
	if(outline_color)
		item_filter = filter(type = "drop_shadow", x=0, y=0, size=1, offset = 2, color = outline_color)
		I.filters += item_filter
	heresy_severity_passive = h_severity_passive
	heresy_desc_passive = h_desc_passive
	heresy_severity_active = h_severity_active
	heresy_desc_active = h_desc_active
	// set the initial values to the passive ones. we'll switch to active when we possess someone
	heresy_severity = heresy_severity_passive
	heresy_desc = heresy_desc_passive
	powerful = start_powerful
	ephemeral = temp
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(update_bearer))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	if(revert_on_break) // for cursed items we want you to have to DESTROY the item (melt it down with a lamptern/break it completely)
		RegisterSignal(parent, COMSIG_ITEM_BROKEN, PROC_REF(revert))
	RegisterSignal(spirit, COMSIG_LIVING_RESIST, PROC_REF(revert))
	RegisterSignal(spirit, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	possession_verbiage = verbiage

	if(istype(parent, /obj/item/rogueweapon))
		magic_effect = new /datum/magic_item/greater/lifesteal
		magic_effect.flat_heal = 5 // halved effectiveness from the enchantment
		magic_effect.glow_color = null // we already have our own glow
		magic_effect.on_apply(parent)
		// if(change_sprites && istype(parent, /obj/item/rogueweapon/sword) && I.inhand_x_dimension == 64) // swords with a compatible spritesize get temp swapped to the infernal sword sprite - DOES NOT WORK as altgrips (?) overwrite it. someone can put this back if they figure out a way to make it work, cba rn
		// 	I.icon = 'icons/roguetown/weapons/swords64.dmi'
		// 	I.icon_state = "blksword"
	else if(istype(I, /obj/item/clothing) && !isstatring(I))
		magic_effect = new /datum/magic_item/greater/phoenixguard 	// with how nothingburger firestacks are now this is probably fine. will change it if it becomes
		magic_effect.glow_color = null								// a problem but like this is the one that makes you valid and all
		magic_effect.on_apply(parent)								// you don't get this if you pick a statring, though, so as to not double dip

	bearer_verb = verb_to_bearer
	I.become_hearing_sensitive()
	spirit.set_resting(TRUE, TRUE)
	add_verb(spirit.client, /client/proc/possessed_item_possess)

// undo the possession, clean ourselves up
/datum/component/possessed_item/proc/revert()
	if(bearer)
		bearer.release_vessel() // no lingering possession
		bearer.remove_infernal_armor() // should this be a comsig? probably. but it's harmless to have here as it doesn't do anything unless there IS infernal armor to remove so that's a problem for future me
	spirit.forceMove(get_turf(parent))
	remove_verb(spirit.client, /client/proc/possessed_item_possess)
	if(magic_effect)
		QDEL_NULL(magic_effect)
	if(ephemeral)
		qdel(parent)
	else
		qdel(src)

/datum/component/possessed_item/Destroy(force, silent)
	UnregisterSignal(parent, COMSIG_ITEM_EQUIPPED)
	UnregisterSignal(parent, COMSIG_ITEM_BROKEN)
	UnregisterSignal(spirit, COMSIG_LIVING_RESIST)
	UnregisterSignal(spirit, COMSIG_MOB_SAY)
	var/obj/item/I = parent
	I.filters -= item_filter
	remove_verb(spirit.client, /client/proc/possessed_item_possess)
	. = ..()

/datum/component/possessed_item/proc/update_bearer(datum/source, mob/equipper, slot)
	var/obj/item/I = parent
	if(ishuman(equipper) && !equipper.icon_state && equipper.mind && equipper != bearer) // i know this looks insane. but icon_state being null is actually the best way to tell if someone's a normal human, or if they're some manner of wildshape/special-cased human like familiars, hag trueform, wws, etc - none of which we want to count for this!
		bearer = equipper
		if(bearer_verb)
			add_verb(bearer, bearer_verb) // they get this as a freebie to aurafarm
		RegisterSignal(bearer, COMSIG_MOB_DROPITEM, PROC_REF(handle_drop))
		RegisterSignal(bearer, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, PROC_REF(handle_attack)) // if you whack someone with it, you're cooked
		if((istype(parent, /obj/item/clothing/ring) || istype(parent, /obj/item/clothing/neck/roguetown/psicross)) && slot != ITEM_SLOT_HANDS) // rings grant passive effects, so simply wearing them is enough; amulets are quintessential cursed item and get an easy pass too
			to_chat(bearer, span_userdanger("I feel [I]'s power over me grow stronger as I use it...")) // let them know they're being #corrupted so they can drop it if they don't want that
			curse_timer_id = addtimer(CALLBACK(src, PROC_REF(add_user), bearer), CURSE_CORRUPTION_THRESHOLD, TIMER_STOPPABLE)
		else if(I.has_armor_value()) // for armor, using it to tank blows is what does you in
			RegisterSignal(bearer, COMSIG_MOB_ARMOR_INTEGRITY_DAMAGED, PROC_REF(handle_armor_damage))

/datum/component/possessed_item/proc/on_examine(atom/movable/source, mob/user, list/examine_list)
	if(magic_effect && magic_effect.description)
		examine_list += span_info(magic_effect.description)

/datum/component/possessed_item/proc/add_user(mob/living/carbon/human/user)
	if(bearer == user && !(bearer.real_name in users)) // we do need to still be equipped on them for the whole timer period
		to_chat(spirit, span_warning("My hold over [bearer] strengthens. Should I be strong enough, I can forcibly possess [bearer.p_them()] now."))
		users += bearer.real_name
		UnregisterSignal(bearer, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY) // no reason to keep listening for opportunties once they're already corrupted
		UnregisterSignal(bearer, COMSIG_MOB_ARMOR_INTEGRITY_DAMAGED)

/datum/component/possessed_item/proc/handle_speech(mob/living/speaker, list/speech_args)
	if(speech_args[SPEECH_MODE] == MODE_WHISPER)
		speaker.log_talk(speech_args[SPEECH_MESSAGE], LOG_WHISPER)
		to_chat(speaker, span_centcomradio("You whisper into [bearer]'s mind... \"[speech_args[SPEECH_MESSAGE]]\""))
		to_chat(bearer, span_centcomradio("You hear a whisper in your mind... \"[speech_args[SPEECH_MESSAGE]]\""))
		speech_args[SPEECH_MESSAGE] = null // cancel the speech

// no matter how powerful a possessed item is, someone resisting will always put them on a timer. it's quite the timer, though, giving them lots of time to wreak havoc; intentional, as you either have to consent to this, or willingly use an obviously cursed item enough to give it power over you
/datum/component/possessed_item/proc/handle_resist(mob/dead/observer/eye/screye/displaced_soul/resister)
	if(!resister)
		return
	if(resist_timer_id)
		to_chat(resister, span_warning("I cease my struggles, allowing their hold on me to strengthen once more."))
		deltimer(resist_timer_id)
		resist_timer_id = null
		return
	to_chat(spirit, span_warning("[resister]'s soul bucks and writhes, resisting my possession! My hold on them will slip in [NONCON_POSSESS_TIMELIMIT] minutes if I cannot convince or coerce them into settling down."))
	to_chat(resister, span_warning("I will not be restrained! My resistance begins to weaken their hold; I will break free in [NONCON_POSSESS_TIMELIMIT] minutes. Though, maybe they're not so bad... I could attempt resistance again to cease my struggles."))
	resist_timer_id = addtimer(CALLBACK(bearer, TYPE_PROC_REF(/mob/living/carbon/human, release_vessel)), NONCON_POSSESS_TIMELIMIT MINUTES)

/datum/component/possessed_item/proc/handle_release(mob/living/carbon/human/vessel, mob/dead/observer/eye/screye/displaced_soul/dsoul, mob/living/carbon/human/original, dying)
	heresy_severity = heresy_severity_passive
	heresy_desc = heresy_desc_passive
	if(bearer_verb)
		remove_verb(vessel, bearer_verb)
	UnregisterSignal(vessel, COMSIG_MOB_POSSESS_RELEASE)
	COOLDOWN_START(src, possession_cooldown, POSSESSION_END_COOLDOWN)
	return TRUE

// parting the item from the host is the fastest way to free them
/datum/component/possessed_item/proc/handle_drop(mob/user, obj/item/dropped)
	if(dropped != parent || dropped.loc == user)
		return // but don't do it when just swapping slots around
	if(bearer.release_vessel()) // will do nothing if they're not actually possessed
		bearer.visible_message("As [dropped] breaks contact with [bearer], the strange aura surrounding them dissipates!") // let people know it worked if they were
	UnregisterSignal(bearer, COMSIG_MOB_DROPITEM)
	UnregisterSignal(bearer, COMSIG_MOB_ARMOR_INTEGRITY_DAMAGED)
	UnregisterSignal(bearer, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
	if(bearer_verb)
		remove_verb(bearer, bearer_verb) // no aurafarming if you aren't actually using the thing
	bearer = null
	if(curse_timer_id)
		to_chat(bearer, span_warning("The energies flowing from [dropped] suddenly cease, our connection broken.")) // let them know it worked
		deltimer(curse_timer_id)

/datum/component/possessed_item/proc/handle_attack(datum/source, mob/target, mob/user, obj/item/I)
	if(powerful && !curse_timer_id && I == parent)
		to_chat(bearer, span_userdanger("I feel [I]'s power over me grow stronger as I use it...")) // let them know they're being #corrupted so they can drop it if they don't want that
		curse_timer_id = addtimer(CALLBACK(src, PROC_REF(add_user), bearer), CURSE_CORRUPTION_THRESHOLD, TIMER_STOPPABLE)

/datum/component/possessed_item/proc/handle_armor_damage(datum/source, amount, obj/item/clothing/damaged)
	if(powerful && !curse_timer_id && damaged == parent)
		to_chat(bearer, span_userdanger("I feel [damaged]'s power over me grow stronger as I use it...")) // let them know they're being #corrupted so they can drop it if they don't want that
		curse_timer_id = addtimer(CALLBACK(src, PROC_REF(add_user), bearer), CURSE_CORRUPTION_THRESHOLD, TIMER_STOPPABLE)

/client/proc/possessed_item_possess()
	set name = "Possess Bearer"
	set category = "RoleUnique.Possessed Item"

	var/mob/living/carbon/human/H = mob
	if(!istype(H))
		return
	var/obj/item/cursed_item = mob.loc
	if(!cursed_item || !istype(cursed_item))
		return
	var/datum/component/possessed_item/curse = cursed_item.GetComponent(/datum/component/possessed_item)
	if(!curse || !curse.bearer || (cursed_item.loc != curse.bearer))
		return
	if(!COOLDOWN_FINISHED(curse, possession_cooldown))
		to_chat(curse.spirit, span_warning("I cannot possess again for another [COOLDOWN_TIMELEFT(curse, possession_cooldown) / (1 MINUTES)] minutes."))
		return
	// powerful curses can possess without consent, but only if the conditions are met. nonpowerful or non-valid targets instead get a consent prompt, but not a spammable one
	if((!curse.powerful || !(curse.bearer.real_name in curse.users)))
		if(!COOLDOWN_FINISHED(curse, possession_prompt))
			to_chat(curse.spirit, span_warning("I cannot attempt another possession request for [COOLDOWN_TIMELEFT(curse, possession_prompt) / (1 SECONDS)] seconds."))
			return
		else if (alert(curse.bearer, "You feel powerful energies from [cursed_item] flood your very self, seeking to take over...! Do you resist?", "POSSESSION IS IMMINENT", "Yes, my body is my own!", "No, let them in!") != "No, let them in!")
			to_chat(curse.spirit, span_warning("[curse.bearer] resists my possession... for now."))
			COOLDOWN_START(curse, possession_prompt, POSSESSION_PROMPT_COOLDOWN)
			return

	curse.bearer.visible_message(replacetext(replacetext(curse.possession_verbiage, "$src", "[curse.parent]"), "$bearer", "[curse.bearer]"))
	curse.heresy_severity = curse.heresy_severity_active
	curse.heresy_desc = curse.heresy_desc_active
	H.possess_vessel(curse.bearer, TRAIT_POSSESSED_ITEM, FALSE, TRUE)
	curse.RegisterSignal(curse.bearer, COMSIG_MOB_POSSESS_RELEASE, TYPE_PROC_REF(/datum/component/possessed_item, handle_release))
	var/mob/dead/observer/eye/screye/displaced_soul/dsoul = curse.bearer.get_displaced_soul()
	if(dsoul)
		curse.RegisterSignal(dsoul, COMSIG_DEAD_RESIST, TYPE_PROC_REF(/datum/component/possessed_item, handle_resist))
	if(curse.bearer_verb)
		add_verb(curse.bearer, curse.bearer_verb)

#undef POSSESSION_END_COOLDOWN
#undef CURSE_CORRUPTION_THRESHOLD
#undef POSSESSION_PROMPT_COOLDOWN
