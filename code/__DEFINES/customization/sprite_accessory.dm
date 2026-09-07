#define SPRITE_ACCESSORY(type) GLOB.sprite_accessories[type]

/// Cap on the generated accessory icon cache. Keyed by type x icon_state x colours.
#define SPRITE_ACCESSORY_ICON_CACHE_LEN 600

/// Cap on the custom hair painter's colour-derived caches (palettes, swatch lists). Their keys
/// include hex colours, so the key space is open-ended and needs a ceiling.
#define HAIR_COLOUR_CACHE_LEN 300
/// Cap on cached gradient-blended hair icons. Keyed by content rather than colour, but each entry
/// holds a whole icon, so it is capped for memory rather than key growth.
#define HAIR_GRADIENT_ICON_CACHE_LEN 200

#define KEY_MUT_COLOR_ONE "mut1"
#define KEY_MUT_COLOR_TWO "mut2"
#define KEY_MUT_COLOR_THREE "mut3"
#define KEY_HAIR_COLOR "hair"
#define KEY_FACE_HAIR_COLOR "facehair"
#define KEY_EYE_COLOR "eye"
#define KEY_SKIN_COLOR "skin"
#define KEY_CHEST_COLOR "chest"
