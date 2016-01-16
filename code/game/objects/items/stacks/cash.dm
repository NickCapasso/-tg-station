/obj/item/stack/spacecash
	name = "space cash"
	desc = "It's worth 1 credit."
	singular_name = "bill"
	icon = 'icons/obj/economy.dmi'
	icon_state = "spacecash"
	amount = 1
	max_amount = 20
	throwforce = 0
	throw_speed = 2
	throw_range = 2
	w_class = 1
	burn_state = FLAMMABLE

/obj/item/stack/spacecash/c10
	icon_state = "spacecash10"
	desc = "It's worth 10 credits."

//make it rain
/obj/item/stack/spacecash/c10/attack_self(mob/user)
	visible_message("<span class='notice'>[user] begins flinging his bills of spacecash into the air! What a grandiose display of wealth!</span>")
	var/i
	for (i=1; i<=10; i++)
		new/obj/item/stack/spacecash(user.loc)
	qdel(src)


/obj/item/stack/spacecash/c20
	icon_state = "spacecash20"
	desc = "It's worth 20 credits."

/obj/item/stack/spacecash/c50
	icon_state = "spacecash50"
	desc = "It's worth 50 credits."

/obj/item/stack/spacecash/c100
	icon_state = "spacecash100"
	desc = "It's worth 100 credits."

/obj/item/stack/spacecash/c200
	icon_state = "spacecash200"
	desc = "It's worth 200 credits."

/obj/item/stack/spacecash/c500
	icon_state = "spacecash500"
	desc = "It's worth 500 credits."

/obj/item/stack/spacecash/c1000
	icon_state = "spacecash1000"
	desc = "It's worth 1000 credits."
