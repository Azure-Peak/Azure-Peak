// Estate sack - code/game/objects/items/rogueitems/bags.dm (/obj/item/storage/roguebag/estate)

var/sack_name = "estate sack"
var/sack_desc = "A coarse sack of tribute sent up from an estate."
var/sack_mechanics_sell = "Left-click a stockpile with it to sell everything inside that ."
var/sack_mechanics_tear = "It falls apart once emptied."

// Stockpile - code/modules/roguetown/roguemachine/stockpile/stockpile.dm

// get_mechanics_examine
var/stockpile_mechanics_container = "Left-click the machine with a sack or other container to sell everything inside it that the stockpile takes."

// attemptsell, said aloud when nothing in a container sells
var/container_nothing_sold = "Nothing in [container name] is accepted here."
