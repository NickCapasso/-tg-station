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
		T.update_icon()
		src.overlays += T.overlay_icon
		src.overlays += T.filling_small

/obj/item/weapon/vape/attack_self(mob/user)
	if(T)
		T.update_icon()
		src.overlays -= T.overlay_icon
		src.overlays -= T.filling_small
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
		user << "<span class='notice'>You pull on the vaporizer and exhale a massive cloud.</span>"
		T.reagents.trans_to(user, hitsize)
		T.update_icon()
		var/obj/effect/vape/V = new
		V.loc = usr.loc
		V.dir = usr.dir
		V.addReagents(src.hitsize)
		T.reagents.trans_to(V, hitsize)
		V.icon_state = "bigvape"
		switch(V.dir) //get the right offsets to make it look like it's blasting out of their mouth
			if(1)
				V.pixel_x = -32
				V.pixel_y = 24
				V.layer = 3
			if(2)
				V.pixel_x = -32
				V.pixel_y = -66
				V.layer = 28
			if(4)
				V.pixel_x = 20
				V.pixel_y = -24
				V.layer = 28
			if(8)
				V.pixel_x = -84
				V.pixel_y = -24
				V.layer = 28
	else
		..()

/obj/item/weapon/reagent_containers/vape_tank
	name = "vaporizer tank"
	desc = "Fill with your favorite juice and vape your cares away. Nanovape is a subsidiary of Nanotrasen LLC and is not responsible for popcorn lung."
	icon = 'icons/obj/items.dmi'
	icon_state = "vapetank"
	var/overlay_icon = "vapetank-overlay"
	var/image/filling = null
	var/image/filling_small = null
	possible_transfer_amounts = list(3,6)
	volume = 30

/obj/item/weapon/vape/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W,/obj/item/weapon/reagent_containers))
		W.reagents.trans_to(src,3) //magic number, change this later.
	..()

/obj/item/weapon/reagent_containers/vape_tank/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")
		filling_small = image('icons/obj/reagentfillings.dmi', src, "[overlay_icon]10")
		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)
				filling.icon_state = "[icon_state]-10"
				filling_small.icon_state = "[overlay_icon]-10"
			if(10 to 24)
				filling.icon_state = "[icon_state]10"
				filling_small.icon_state = "[overlay_icon]10"
			if(25 to 49)
				filling.icon_state = "[icon_state]25"
				filling_small.icon_state = "[overlay_icon]25"
			if(50 to 74)
				filling.icon_state = "[icon_state]50"
				filling_small.icon_state = "[overlay_icon]50"
			if(75 to 79)
				filling.icon_state = "[icon_state]75"
				filling_small.icon_state = "[overlay_icon]75"
			if(80 to 90)
				filling.icon_state = "[icon_state]80"
				filling_small.icon_state = "[overlay_icon]80"
			if(91 to INFINITY)
				filling.icon_state = "[icon_state]100"
				filling_small.icon_state = "[overlay_icon]100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		filling_small.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

/obj/item/weapon/reagent_containers/vape_tank/New()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/vape_tank/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/vape_tank/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/vape_tank/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/vape_tank/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/vape_tank/prefilled
	name = "prefilled vape tank"

	New()
		..()
		reagents.add_reagent("nicotine", 30) //yummy