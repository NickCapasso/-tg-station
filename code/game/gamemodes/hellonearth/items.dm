/obj/item/weapon/athame
	name = "Athame"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "athame1"
	item_state = "athame1"
	desc = "A ritual dagger used in demonic blood rituals. It can only be energized with the blood of multiple victims."


/obj/item/projectile/lamprey_fist
	name = "Lamprey Fist"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "lamprey_fist_r"
	damage = 20
	damage_type = BRUTE
	projectile_type = "/obj/item/projectile/lamprey_fist"
	var/pulling = null
	var/dragging = 0
	var/mob/living/carbon/owner = null

/*
/obj/item/projectile/lamprey_fist/proc/start_pulling(atom/movable/AM)
	if ( !AM || !src || src==AM || !isturf(AM.loc) )	//if there's no person pulling OR the person is pulling themself OR the object being pulled is inside something: abort!
		return
	src.pulling = AM
	AM.pulledby = src

/obj/item/projectile/lamprey_fist/proc/stop_pulling()
	if(pulling)
		pulling = null

/obj/item/projectile/lamprey_fist/on_hit(atom/movable/target, blocked = 0, hit_zone)
	if(!istype(target, /mob/living/carbon/human) && (target != owner))
		dragging = 1
		throw_at_fast(owner, 30, 2,target)
		while(dragging == 1)
			target.loc = src.loc
	else if(target == owner)
		dragging = 0
		qdel(src)
		if(istype(owner.r_hand,/obj/item/weapon/gun/lamprey_fist))
			var/obj/item/weapon/gun/lamprey_fist/L = owner.r_hand
			L.has_hand = 1
*/

/obj/item/weapon/gun/lamprey_fist
	name = "Lamprey Fist"
	desc = "True power is brokered only in measures of blood."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "parasite_hand_r"
	righthand_file = 'icons/mob/inhands/guns_righthand.dmi'
	lefthand_file = 'icons/mob/inhands/guns_righthand.dmi'
	item_state = "parasite_hand"
	w_class = 4
	throw_speed = 2
	throw_range = 7
	throwforce = 15
	force = 30
	var/intent = "grab"
	var/mob/living/carbon/owner
	var/has_hand = 1

/obj/item/weapon/gun/lamprey_fist/dropped(mob/user)
	user << "<span class='danger'>The tendrils constrict with renewed strength around your right arm!</span>"
	shake_camera(user, 1, strength=1)
	if(istype(user,/mob/living/carbon/human))
		user:adjustBruteLoss(10)
	return 0

/obj/item/weapon/gun/lamprey_fist/attack_hand(mob/user)
	if(src.loc == user.l_hand)
		user << "<span class='warning'>It seems to slide off your left hand as if unwilling.</span>"
		return 0
	user << "<span class='danger'>You feel powerful tendrils anchoring themselves on your arm!</span>"
	owner = user
	..()

/obj/item/weapon/gun/lamprey_fist/attack_self(mob/user)
	if(intent == "grab")
		intent = "harm"
		user << "<span class='warning'>[name] has switched to harm intent.</span>"
	else if(intent == "harm")
		intent = "grab"
		user << "<span class='warning'>[name] has switched to grab intent.</span>"


/obj/item/weapon/gun/lamprey_fist/afterattack(atom/target as mob|obj|turf, mob/living/carbon/human/user as mob|obj, flag, params)
	if(has_hand)
		var/obj/item/projectile/lamprey_fist/L = new(src.loc)
		L.owner = user
		throw_at_fast(target, 30, 2,owner)
		has_hand = 0