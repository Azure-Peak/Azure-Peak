/obj/item/book/rogue/bibble/psy/read(mob/living/carbon/human/user)
	if(!open)
		to_chat(user, span_info("Open it first."))
		return FALSE
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		return
	if(in_range(user, src) || isobserver(user))
		user.changeNext_move(CLICK_CD_MELEE)
		var/m
		if(sect)
			var/list/verses = world.file2list("modular_twilight_axis/lore/strings/psy[sect].txt")
			m = pick(verses)
			if(m)
				if(prob(1) && sect == "sect1")
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					user.say("ПСАЙ 66:6... +_Всеотец_+ изрёк: «Я прощаю тебя, ибо люблю тебя как отец любит свою дочь». И кровь стекала по лезвию и из груди е- Откуда это здесь?!")
				else
					user.say(m)	

/obj/item/book/rogue/bibble/psy/MiddleClick(mob/user, params)
	var/sects = list("Завет Псайдона", "Житиё Псайдона", "Завет Отавика")
	var/sect_choice = input(user, "Выберите Завет", "О ПСАЙДОНИИ") as anything in sects
	switch(sect_choice)
		if("Завет Псайдона")
			sect = "sect1"
		if("Житиё Псайдона")
			sect = "sect2"
		if("Завет Отавика")
			sect = "sect3"
	return
