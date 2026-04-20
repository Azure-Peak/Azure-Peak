/obj/item/book/manual/random
	icon_state = "random_book"

/obj/item/book/manual/random/Initialize()
	..()

	var/list/types = subtypesof(/obj/item/book/manual)
	types -= /obj/item/book/manual/random

	if(!length(types))
		return INITIALIZE_HINT_QDEL

	var/newtype = pick(types)
	new newtype(loc)

	return INITIALIZE_HINT_QDEL

/obj/item/book/random
	icon_state = "random_book"
	var/amount = 1
	var/category = null

/obj/item/book/random/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/book/random/LateInitialize()
	create_random_books(amount, src.loc, TRUE, category)
	qdel(src)

/obj/item/book/random/triple
	amount = 3

/obj/structure/bookcase/random
	var/category = null
	var/book_count = 10
	icon_state = "bookcase"
	anchored = TRUE
	state = 2

/obj/structure/bookcase/random/Initialize(mapload)
	. = ..()
	if(book_count && isnum(book_count))
		book_count += pick(-5,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-2,-2,-1,-1,0,)
		. = INITIALIZE_HINT_LATELOAD

/obj/structure/bookcase/random/LateInitialize()
	create_random_books_rogue(book_count, src)
	update_icon()

/obj/structure/bookcase/random/archive
	book_count = 10

/obj/structure/bookcase/random/archive/Initialize(mapload)
	. = ..()
	if(book_count && isnum(book_count))
		book_count += pick(0,1,2,3,4,5,6,7,8,9,10)
		. = INITIALIZE_HINT_LATELOAD

/obj/structure/bookcase/random/archive/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/book/rogue/playerbook))
		var/obj/item/book/rogue/playerbook/PB = I
		if(PB.is_in_round_player_generated)
			to_chat(user, span_notice("[SSlibrarian.playerbook2file(PB.player_book_text, PB.player_book_title, PB.player_book_author, PB.player_book_author_ckey, PB.player_book_icon)]"))
			PB.is_in_round_player_generated = FALSE

	. = ..()

/proc/create_random_books(amount = 2, location, fail_loud = FALSE, category = null)
	. = list()
	if(!isnum(amount) || amount<1)
		return
	if (!SSdbcore.Connect())
		if(fail_loud || prob(5))
			var/obj/item/paper/P = new(location)
			P.info = "IOU - The Book Thief"
			P.update_icon()
		return
	if(prob(25))
		category = null
	var/datum/DBQuery/query_get_random_books = SSdbcore.NewQuery({"
		SELECT author, title, content
		FROM [format_table_name("library")]
		WHERE isnull(deleted) AND (:category IS NULL OR category = :category)
		ORDER BY rand() LIMIT :limit
	"}, list("category" = category, "limit" = amount))
	if(query_get_random_books.Execute())
		while(query_get_random_books.NextRow())
			var/obj/item/book/B = new(location)
			. += B
			B.author	=	query_get_random_books.item[2]
			B.title		=	query_get_random_books.item[3]
			B.dat		=	query_get_random_books.item[4]
			B.name		=	"Book: [B.title]"
			B.icon_state=	"book[rand(1,8)]"
	qdel(query_get_random_books)

/proc/create_random_books_rogue(amount = 2, location)
	var/list/possible_books = subtypesof(/obj/item/book/rogue/)
	var/list/player_book_titles = SSlibrarian.pull_player_book_titles()
	for(var/b in 1 to amount)
		if(prob(0.1))
			new /obj/item/book_crafting_kit(location)
		if(prob(clamp(length(player_book_titles), 10, 90)))
			new /obj/item/book/rogue/playerbook(location)
		else
			var/obj/item/book/rogue/addition = pick(possible_books)
			var/obj/item/book/rogue/newbook = new addition(location)
			if(istype(newbook, /obj/item/book/rogue/secret))
				qdel(newbook)
				continue
			if(istype(newbook, /obj/item/book/rogue/bibble))
				qdel(newbook)
				continue


/obj/structure/bookcase/random/fiction
	name = "bookcase (Fiction)"
	category = "Fiction"
/obj/structure/bookcase/random/nonfiction
	name = "bookcase (Non-Fiction)"
	category = "Non-fiction"
/obj/structure/bookcase/random/religion
	name = "bookcase (Religion)"
	category = "Religion"
/obj/structure/bookcase/random/adult
	name = "bookcase (Adult)"
	category = "Adult"

/obj/structure/bookcase/random/reference
	name = "bookcase (Reference)"
	category = "Reference"
	var/ref_book_prob = 20

/obj/structure/bookcase/random_recipes
	name = "bookcase (Recipes)"

/obj/structure/bookcase/random_recipes/Initialize(mapload)
	. = ..()
	var/list/books = subtypesof(/obj/item/recipe_book)
	for(var/obj/item/recipe_book/listed_book as anything in books)
		if(initial(listed_book.can_spawn))
			continue
		books -= listed_book

	for(var/i = 1 to books.len) // Spawn one copy of every book
		var/obj/item/recipe_book/book = pick_n_take(books)
		new book(src)
	update_icon()
