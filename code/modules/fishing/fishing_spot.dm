// A thing you can fish in
/datum/component/fishing_spot
	/// Defines the probabilities and fish availibilty
	var/datum/fish_source/fish_source

/datum/component/fishing_spot/Initialize(configuration)
	if(ispath(configuration,/datum/fish_source))
		//Create new one of the given type
		fish_source = new configuration
	else if(istype(configuration,/datum/fish_source))
		//Use passed in instance
		fish_source = configuration
	else
		return COMPONENT_INCOMPATIBLE
	fish_source.on_fishing_spot_init(src)
	RegisterSignal(parent, COMSIG_FISHING_ROD_CAST, PROC_REF(handle_cast))
	ADD_TRAIT(parent, TRAIT_FISHING_SPOT, REF(src))

/datum/component/fishing_spot/Destroy()
	REMOVE_TRAIT(parent, TRAIT_FISHING_SPOT, REF(src))
	fish_source.on_fishing_spot_del(src)
	fish_source = null
	REMOVE_TRAIT(parent, TRAIT_FISHING_SPOT, REF(src))
	return ..()

/datum/component/fishing_spot/proc/handle_cast(datum/source, obj/item/fishingrod/rod, mob/user, automated)
	SIGNAL_HANDLER
	if(try_start_fishing(rod,user,automated))
		return FISHING_ROD_CAST_HANDLED
	return NONE

/datum/component/fishing_spot/proc/try_start_fishing(obj/item/possibly_rod, mob/user, automated)
	SIGNAL_HANDLER
	var/obj/item/fishingrod/rod = possibly_rod
	if(!istype(rod))
		return
	if(GLOB.fishing_challenges_by_user[user] || rod.fishing_line)
		user.balloon_alert(user, "already fishing")
		return COMPONENT_NO_AFTERATTACK
	var/denial_reason = fish_source.reason_we_cant_fish(rod, user, parent)
	if(denial_reason)
		to_chat(user, span_warning(denial_reason))
		return COMPONENT_NO_AFTERATTACK
	// In case the fishing source has anything else to do before beginning to fish.
	fish_source.on_start_fishing(rod, user, parent)
	if(HAS_TRAIT(user, TRAIT_EXPERT_FISHER))
		var/ratio = fish_source.prized_stock_ratio()
		if(!isnull(ratio) && ratio < FISHING_STOCK_LOW_RATIO)
			to_chat(user, span_smallred("This body of water seems depleted of good fishes, maybe I should fish elsewhere."))
	if(!rod.baited)
		to_chat(user, span_warning("My hook is bare. Little but junk will bite without bait."))
	var/datum/fishing_challenge/challenge = new(src, rod, user, automated)
	fish_source.pre_challenge_started(rod, user, challenge)
	challenge.start(user)
	return COMPONENT_NO_AFTERATTACK
