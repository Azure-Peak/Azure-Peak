//please store common type caches here.
//type caches should only be stored here if used in mutiple places or likely to be used in mutiple places.

//Note: typecache can only replace istype if you know for sure the thing is at least a datum.

GLOBAL_LIST_INIT(typecache_mob, typecacheof(/mob))

GLOBAL_LIST_INIT(typecache_living, typecacheof(/mob/living))

GLOBAL_LIST_INIT(typecache_machine_or_structure, typecacheof(list(/obj/machinery, /obj/structure)))
//Below typecache used for letting combat-mode attacks pass through a sprite and to the tile you click on.
GLOBAL_LIST_INIT(typecache_combat_click_through, typecacheof(list(/obj/structure/flora/roguetree, /obj/structure/flora/rogueshroom,
)))
