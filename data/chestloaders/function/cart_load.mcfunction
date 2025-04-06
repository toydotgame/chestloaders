#> CREATED ON: 2025-04-05
#> AUTHOR: toydotgame
#  cart_load.mcfunction - Handles force-loading eligible (`moving_cart` predicate) carts and
#  tracking ages. Run once a second

# Force-load all (eligible) moving carts:
execute \
	as @e[predicate=chestloaders:moving_cart,tag=!chestloaders.unload] \
	at @s \
	run forceload add ~-16 ~-16 ~16 ~16
	# Creates a 3x3 of force-loaded entity processing  chunks around the cart

# Remove unload tag from carts once force-loading is done (and they have been skipped):
execute as @e[tag=chestloaders.unload] run tag @s remove chestloaders.unload
# These formerly `unload`-tagged carts will become unloaded when the next call of `cart_unload`
# occurs and purges them. `cart_timeout` occurs _after_ `cart_unload` and thus they don't
# receive any second chance after being marked as `unload`

# Update movement tracking data for `cart_timeout`:
execute as @e[predicate=chestloaders:moving_cart] \
	store result score @s cl.x run data get entity @s Pos[0]
execute as @e[predicate=chestloaders:moving_cart] \
	store result score @s cl.y run data get entity @s Pos[1]
execute as @e[predicate=chestloaders:moving_cart] \
	store result score @s cl.z run data get entity @s Pos[2]

# Look again (loop) for chunks to load each second:
schedule function chestloaders:cart_load 1s
