/obj/structure/roguemachine/lottery_roguetown
	name = "XYLIX'S FORTUNE"
	desc = "An infinite, yawning hole that makes or breaks men. Come and play!"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "lottery"
	density = FALSE
	pixel_y = 32
	light_outer_range = 5
	light_color = "#1b7bf1"
	var/gamblingprice = 0
	var/checkchatter = 0
	var/chatterbox = 0

//ensure these two are the same, or else first roll will be fucky
	var/gamblingprob = 60
	var/gamblingbaseprob = 60

	var/diceroll = 100
	var/maxtithing = 100
	var/mintithing = 5
	var/stopgambling = 0
	var/probpenalty = 2
	var/oldtithe = 0


/obj/structure/roguemachine/lottery_roguetown/attack_hand(mob/living/user) //empty hand

	src.say("Your current tithe is [src.gamblingprice] mammons. Care to spin?")
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	return

/obj/structure/roguemachine/lottery_roguetown/attackby(obj/item/roguecoin/P, mob/living/user)

	. = ..()

	if(src.stopgambling == 1)
		return
	if(istype(P, /obj/item/roguecoin/aalloy))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		if(src.gamblingprice + (P.sellprice * P.quantity) > src.maxtithing)
			say("This puts the starting tithe over [src.maxtithing] mammons.")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		if(src.gamblingprice + (P.sellprice * P.quantity) < src.mintithing)
			say("This is below [src.mintithing] mammons.")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return

		else
			src.gamblingprice += (P.sellprice * P.quantity)
			qdel(P)
			src.say("Your current tithe is now [src.gamblingprice] mammons. Care to spin?")
			playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
			return


/obj/structure/roguemachine/lottery_roguetown/MiddleClick(mob/living/user, params) //LET'S GO GAMBLING
//checks - is it time to go gambling??
	if(src.stopgambling == 1)
		return
	if(src.gamblingprice == 0)
		src.say(pick("Eager fool; you need mammons to gamble your life away.", "You are missing your tithe.", "A lord without land is no lord at all."))
		src.stopgambling = 1
		sleep(20)
		src.stopgambling = 0
		return


	else
		src.diceroll = rand(1,100)
		src.say(pick("Around and around I go, where I stop, only I know.", "Xylix smiles upon your idiocy, child.", "The wheel of fate spins, and spins.", "Oh, you poor fool.", "This is going to hurt for one of us.", "I laugh, you cry; I weep, you cheer..", "I will be your fool; I'll perform for you...", "Let's go gambling!", "Around and around, folly abounds.", "Dance with ruin and wealth."))
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		playsound(src, 'sound/misc/letsgogambling.ogg', 100, FALSE, -1)
		src.gamblingprob += (user.STALUC - src.probpenalty)
		src.stopgambling = 1

		src.checkchatter -= 1

//thug shaker
		var/oldx = pixel_x
		animate(src, pixel_x = oldx+1, time = 1)
		animate(pixel_x = oldx-1, time = 1)
		animate(pixel_x = oldx, time = 1)
		sleep(50)

//let's actually go gambling and determine results
		if(src.gamblingprob > src.diceroll)
			src.oldtithe = src.gamblingprice
			src.gamblingprice *= pick(1.1, 1.1, 1.1, 1.1, 1.2, 1.2, 1.2, 1.4, 1.4, 2)
			src.gamblingprice = round(src.gamblingprice)

			peasant_betting()
			letsgogamblinggamblers()
			src.say(pick("Well-maneuvered, aristocrat! Your peasant's tithe is now [src.gamblingprice] mammons. Play again?", "A bountiful harvest, this year- the peasant's tithe rises to [src.gamblingprice] mammons. Spin me again?",))

			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			src.gamblingprob = src.gamblingbaseprob
			src.oldtithe = src.gamblingprice //this is redundant but i feel like bad things will happen if i don't do this :T
			sleep(15)
			src.stopgambling = 0
			return

		else
			src.say(pick("TEN, WHEEL OF FORTUNE - inversed.", "The Castle. O, Omen!", "A harvest of locusts...!", "Look into my eyes and whisper your woes.", "Aw, dangit.", "Fool. Poor fool.", "Your eyes leak out of your skull, drool falling from your lips.", "Divine idiocy.", "You stand just as I did; loser and a freek."))
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(20) //really make them THINK about their life choices up to this point
			src.say(pick("King of fools, your land is barren. Play again?", "Divine comedy. Play again?", "Next time, surely. Play again?", "Haha-...ah-ha-ha! Again! Play again, jester!", "Poor beggar! Spin me again?"))
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			src.gamblingprob = src.gamblingbaseprob
			src.gamblingprice = 0
			src.oldtithe = 0
			sleep(15)
			src.stopgambling = 0
			return



/obj/structure/roguemachine/lottery_roguetown/attack_right(mob/living/user) //how the fuck do i
	. = ..()

	if(!ishuman(user))
		return
	if(src.stopgambling == 1)
		return

	else
		if(gamblingprice <= 0)
			say("Poor thing, you are coinless.")
			return
		if(gamblingprice < 0)
			say("Your peasant's tithe is NEGATIVE.")
			return
		var/list/choicez = list()
		if(gamblingprice > 10)
			choicez += "GOLD"
		if(gamblingprice > 5)
			choicez += "SILVER"
		choicez += "BRONZE"
		var/selection = input(user, "Make a Selection", src) as null|anything in choicez
		if(!selection)
			return
		var/mod = 1
		if(selection == "GOLD")
			mod = 10
		if(selection == "SILVER")
			mod = 5
		var/maxwithdraw = min(floor(gamblingprice/mod), 20)
		var/coin_amt = input(user, "Sayyid, you have [src.gamblingprice] mammon in tithes. You may withdraw [maxwithdraw] [selection] COINS.", src) as null|num
		coin_amt = min(round(coin_amt), 20)
		if(coin_amt < 1)
			return
		if(!Adjacent(user))
			return
		if(src.stopgambling == 1) // double check because it's possible to have input field open before starting gambling
			return
		if((coin_amt*mod) > gamblingprice)
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		else
			budget2change(coin_amt*mod, user, selection)
			gamblingprice -= coin_amt*mod



/obj/structure/roguemachine/lottery_roguetown/proc/peasant_betting()

	if(src.gamblingprice == oldtithe)
		src.gamblingprice += pick(1,1,1,1,2,2)


/obj/structure/roguemachine/lottery_roguetown/proc/letsgogamblinggamblers()

	if(src.checkchatter > 1) //procs any time it's under 1
		return

	if(prob(90))
		return

	chatterbox = rand(1,12)

	switch(chatterbox)
		if(1)
			src.say("I still remember the rain on my skin.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("The wind in my fur...or was it hair? Either way...")
			playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
		if(2)
			src.say("The worship of gods is pernicious.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(20)
			src.say("But this punishment is not as bad as others'! Ha-ha-ha!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(3)
			src.say("There are fates worse than death...")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("...especially for a lowly fool who thought himself a king.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(4)
			src.say("She didn't realize Her machine would kill Her, of course.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("...though 'tis difficult to argue what happened after that didn't benefit Her.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(5)
			src.say("Oh, Psydon?")
			playsound(src, 'sound/misc/machinequestion.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("To be honest, I'm about PSY-DONE with this whole debate! Ha-ha-h- ...No? Too soon? Alright.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(6)
			src.say("You know, jester, those Ecclesials have the right idea.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("Won't someone think of the deadite-loving, tax-hating, drug-using murderers?!")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(7)
			src.say("...well, don't look at me for conversation.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("I've been the one doing all the chatting.")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		if(8)
			src.say("Can't you smell the stench in the air? It's terrible.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("It wasn't nearly so bad, before. Rot and puss. Oh, well.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(9)
			src.say("Can't you smell the stench in the air, fool? It's terrible.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("I don't know how you could miss it. Rot and puss. Oh, well.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(10)
			src.say("Maybe you ought stop while you are ahead, jester.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("...greed is what got your lot into this mess, after all.")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		if(11)
			src.say("A father and his son are riding a carriage through a forrest. Suddenly, Z's curse! The axle snaps!")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("The father dies, but the son- the son yet lives! He's brought to the nearby village's physician.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			sleep(30)
			src.say("Upon seeing him, the physician ga-...what do you mean, you've heard this one before?")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)
		else
			src.say("Me? Am I anybody important...? Oh, no.")
			playsound(src, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
			sleep(25)
			src.say("I am nothing but a lowly jester, just like you! Ha-ha-ha!")
			playsound(src, 'sound/misc/bug.ogg', 100, FALSE, -1)

	sleep(40)
	src.checkchatter = rand(1,11) //hope he doesn't have pocket aces
