/obj/item/weapon/vape
	name = "vaporizer"
	desc = "A way to get your nicotine fix without smoking analogs like the unwashed masses."
	icon = 'icons/obj/items.dmi'
	icon_state = "vape0"
	item_state = "vape-notank"
	var/obj/item/weapon/reagent_containers/vape_tank/T = null
	var/hitsize = 3

/obj/effect/vape
	name = "vapor cloud"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "bigvape"
	opacity = 1
	mouse_opacity = 0
	unacidable = 1
	pass_flags = PASSTABLE | PASSGRILLE
	layer = 28

/obj/effect/vape/proc/addReagents(var/hitsize)
	src.create_reagents(hitsize)



/obj/effect/vape/New()
	..()
	spawn (20)
		qdel(src)
	return


/obj/item/weapon/vape/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W,/obj/item/weapon/reagent_containers/vape_tank))
		if(T)
			user << "<span class='notice'>The vaporizer already has a tank.</span>"
			return 0
		W.loc = src
		T = W
		T.possible_transfer_amounts = src.hitsize
		user << "<span class='notice'>You twist the tank onto the vaporizer.</span>"
		src.overlays += image('icons/obj/items.dmi', icon_state = "vapetank")

/obj/item/weapon/vape/attack_self(mob/user)
	if(T)
		src.overlays -= image('icons/obj/items.dmi', icon_state = "vapetank")
		T.loc = get_turf(src.loc)
		T = null


/obj/item/weapon/vape/attack(mob/M, mob/user)
	if(M==user)
		if(!T)
			user << "<span class='notice'>You can't vape without a tank.</span>"
			return 0
		else if(!T.reagents.total_volume)
			user << "<span class='notice'>Looks like you're all out of juice. Can't vape without the juice. Gotta have the juice.</span>"
			return 0
		T.reagents.trans_to(user, hitsize)
		var/obj/effect/vape/V = new
		V.loc = usr.loc
		V.dir = usr.dir
		V.addReagents(src.hitsize)
		T.reagents.trans_to(V, hitsize)
		switch(V.dir) //get the right offsets to make it look like it's blasting out of their mouth
			if(1)
				pixel_x = -32
				pixel_y = 24
				layer = 3
			if(2)
				pixel_x = -32
				pixel_y = -66
				layer = 28
			if(4)
				pixel_x = 20
				pixel_y = -24
				layer = 28
			if(8)
				pixel_x = -84
				pixel_y = -24
				layer = 28
		V.icon_state = "bigvape"
	else
		..()

/obj/item/weapon/reagent_containers/vape_tank
	name = "vaporizer tank"
	desc = "Fill with your favorite juice and vape your cares away. Nanovape is a subsidiary of Nanotrasen LLC and is not responsible for popcorn lung."
	icon = 'icons/obj/items.dmi'
	icon_state = "vapetank"
	possible_transfer_amounts = list(3,6)
	volume = 30

/obj/item/weapon/reagent_containers/vape_tank/prefilled
	name = "prefilled vape tank"

	New()
		..()
		reagents.add_reagent("nicotine", 30) //yummy