/mob/living/carbon/human/proc/select_skeleton_features()
	var/mob/living/carbon/human/H = src
	if(!H)
		return

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		to_chat(H, span_warning("You have no head to modify!"))
		return

	// init for scope
	var/datum/preferences/P = null
	if(src.client)
		if(client.prefs)
			P = src.client.prefs

	// 1. Skull Customization (using the Accessory bodypart feature)

	// init for scope
	var/skull_choice = null
	if(P.preset_skeleton_skull && P.preset_skeleton_enabled)
		skull_choice = P.preset_skeleton_skull
	else
		skull_choice = input(H, "Choose your skull structure", "Skull Customization") as null|anything in GLOB.skeleton_head_choices
	if(skull_choice)
		// Remove any existing accessory feature
		for(var/datum/bodypart_feature/accessory/old_acc in head.bodypart_features)
			head.remove_bodypart_feature(old_acc)
			break

		var/skull_path = GLOB.skeleton_head_choices[skull_choice]
		// "HUMEN" doesnt have a path, so we can just check if there IS one in the first place.
		if(skull_path)
			var/datum/bodypart_feature/accessory/new_acc = new()
			new_acc.set_accessory_type(GLOB.skeleton_head_choices[skull_choice], "#FFFFFF", H)
			var/datum/sprite_accessory/SA = SPRITE_ACCESSORY(new_acc.accessory_type)
			if(SA)
				new_acc.accessory_colors = SA.get_default_colors(color_key_source_list_from_carbon(H))
			head.add_bodypart_feature(new_acc)

	// 2. Tail Customization

	// init for scope
	var/tail_choice = null
	if(P.preset_skeleton_tail && P.preset_skeleton_enabled)
		tail_choice = P.preset_skeleton_tail
	else
		tail_choice = input(H, "Choose your tail", "Tail Customization") as null|anything in GLOB.skeleton_tail_choices
	if(tail_choice)
		// i am the liberal i am the wiener i am the john kerry
		var/tail_path = GLOB.skeleton_tail_choices[tail_choice]
		var/obj/item/organ/tail/tail_organ = H.getorganslot(ORGAN_SLOT_TAIL)
		// if "NONE" is picked, the path is null.
		if(!tail_path)
			if(tail_organ)
				tail_organ.Remove(H)
				qdel(tail_organ)
		else
			if(!tail_organ)
				tail_organ = new /obj/item/organ/tail/anthro()
				tail_organ.Insert(H, TRUE, FALSE)
			tail_organ.accessory_type = GLOB.skeleton_tail_choices[tail_choice]
			var/datum/sprite_accessory/tail/tail_type = SPRITE_ACCESSORY(tail_organ.accessory_type)
			tail_organ.accessory_colors = tail_type.get_default_colors(color_key_source_list_from_carbon(H))

	// Force visual update
	H.update_hair()
	H.update_body()
	H.update_body_parts()

/// This is the version of "Choose pronouns and body" specifically for skeletons.
/mob/living/carbon/human/proc/choose_skeleton_pronouns_and_body()
	// init for scope
	var/datum/preferences/P = null

	var/has_pronouns = FALSE
	var/has_body_type = FALSE
	if(src.client)
		if(src.client.prefs)
			P = src.client.prefs
	if(P.preset_skeleton_enabled)
		if(P.preset_skeleton_pronouns)
			src.pronouns = P.preset_skeleton_pronouns
			has_pronouns = TRUE
		if(P.preset_skeleton_body)
			src.gender = GLOB.skeleton_body_choices[P.preset_skeleton_body]
			has_body_type = TRUE
	// OK lets check if they didnt have either
	if(!has_pronouns)
		var/p_input = input(src, "Choose your character's pronouns", "Pronouns") as anything in GLOB.pronouns_list
		if(p_input)
			src.pronouns = p_input
	if(!has_body_type)
		if(alert(src, "Do you wish to change your frame?", "Body Type", "Yes", "No") == "Yes")
			src.gender = (src.gender == MALE) ? FEMALE : MALE
	src.regenerate_icons()

/*
* █████▄   ███     ███     ███   ▄█  █▄
* ██ ▄█▀  ██ ██   ██ ██   ██ ██  ██▄▄██
* ██ ▀█▄ ██▀▀▀██ ██▀▀▀██ ██▀▀▀██ ██▀▀██
* █████▀  ██ ██   ██ ██   ██ ██  ▀█  █▀

*                      :::!~!!!!!:.
*                  .xUHWH!! !!?M88WHX:.
*                .X*#M@$!!  !X!M$$$$$$WWx:.
*               :!!!!!!?H! :!$!$$$$$$$$$$8X:
*              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:
*             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!
*             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!
*               !:~~~ .:!M"T#$$$$WX??#MRRMMM!
*               ~?WuxiW*`   `"#$$$$8!!!!??!!!
*             :X- M$$$$       `"T#$T~!8$WUXU~
*            :%`  ~#$$$m:        ~!~ ?$$$$$$
*          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"
*.....   -~~:<` !    ~?T#$$@@W@*?$$      /`
*W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :
*#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`
*:::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~
*.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `
*Wi.~!X$?!-~    : ?$$$B$Wu("**$RM!
*$R@i.~~ !     :   ~$$$$$B$$en:``
*?MXT@Wx.~    :     ~"##*$$$$M~
*/
