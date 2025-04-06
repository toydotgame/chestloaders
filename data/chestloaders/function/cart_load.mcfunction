execute \
	as @e[predicate=chestloaders:moving_cart] \
	at @s \
	run \
		forceload add ~-16 ~-16 ~16 ~16
		# Creates a 3x3 of force-loaded entity processing  chunks around the cart

schedule function chestloaders:cart_load 1s
