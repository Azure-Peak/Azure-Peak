/datum/keybinding/client/communication
	category = CATEGORY_COMMUNICATION

/datum/keybinding/client/communication/say
	hotkey_keys = list("T")
	name = "Say"
	full_name = "Say"
	clientside = "say_typing_indicator"
/datum/keybinding/client/communication/say/down(client/user)
	var/mob/M = user.mob
	M.say_typing_indicator()
	return TRUE

/datum/keybinding/client/communication/me
	hotkey_keys = list("M")
	name = "Me"
	full_name = "Me (emote)"
	clientside = "me_typing_indicator"

/datum/keybinding/client/communication/me/down(client/user)
	var/mob/M = user.mob
	M.me_typing_indicator()
	return TRUE

/datum/keybinding/client/communication/me_big
	hotkey_keys = list(",")
	name = "Me (big)"
	full_name = "Me (big emote)"
	clientside = "me_big_verb_indicator"

/datum/keybinding/client/communication/me_big/down(client/user)
	var/mob/M = user.mob
	M.me_big_verb_indicator()
	return TRUE

/datum/keybinding/client/communication/antagooc
	hotkey_keys = list("F10")
	name = "AntagOOC"
	full_name = "AntagOOC"
	description = "Talk in the AntagOOC channel."

/datum/keybinding/client/communication/antagooc/down(client/user)
	user.antagooc()
	return TRUE
