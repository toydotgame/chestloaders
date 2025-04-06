#> CREATED ON: 2025-04-06
#> AUTHOR: toydotgame
#  cart_timeout.mcfunction - Prevent carts which haven't travelled more than a chunk in a minute
#  from staying force-loaded (prevents easy creation of chunkloaders). Runs once a minute.
#  Requires `cart_load` to have run at least once beforehand (since `load`), because it depends on
#  the x,y,z scoreboards being set

# We have to do this crazy set of commands to save us creating _another_ scoreboard for consts
#> Motion towards +x,y,z:
# Initialise d{x,y,z} with values of x,y,z:
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.x > @s cl.old_x \
	run scoreboard players operation @s cl.delta_x = @s cl.x
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.y > @s cl.old_y \
	run scoreboard players operation @s cl.delta_y = @s cl.y
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.z > @s cl.old_z \
	run scoreboard players operation @s cl.delta_z = @s cl.z
# d{x,y,z} -= old{x,y,z} (aka d{x,y,z} = x,y,z - old{x,y,z}):
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.x > @s cl.old_x \
	run scoreboard players operation @s cl.delta_x -= @s cl.old_x
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.y > @s cl.old_y \
	run scoreboard players operation @s cl.delta_y -= @s cl.old_y
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.z > @s cl.old_z \
	run scoreboard players operation @s cl.delta_z -= @s cl.old_z
#> No motion along x,y,z: Optimise maths using direct `set` 
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.x = @s cl.old_x \
	run scoreboard players set @s cl.delta_x 0
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.y = @s cl.old_y \
	run scoreboard players set @s cl.delta_y 0
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.z = @s cl.old_z \
	run scoreboard players set @s cl.delta_z 0
#> Motion towards -x,y,z:
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.x < @s cl.old_x \
	run scoreboard players operation @s cl.delta_x = @s cl.old_x
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.y < @s cl.old_y \
	run scoreboard players operation @s cl.delta_y = @s cl.old_y
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.z < @s cl.old_z \
	run scoreboard players operation @s cl.delta_z = @s cl.old_z
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.x < @s cl.old_x \
	run scoreboard players operation @s cl.delta_x -= @s cl.x
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.y < @s cl.old_y \
	run scoreboard players operation @s cl.delta_y -= @s cl.y
execute as @e[predicate=chestloaders:moving_cart] \
	if score @s cl.z < @s cl.old_z \
	run scoreboard players operation @s cl.delta_z -= @s cl.z
#> Get sum of all deltas:
execute as @e[predicate=chestloaders:moving_cart] run scoreboard players set @s cl.delta_pos 0
execute as @e[predicate=chestloaders:moving_cart] \
	run scoreboard players operation @s cl.delta_pos += @s cl.delta_x
execute as @e[predicate=chestloaders:moving_cart] \
	run scoreboard players operation @s cl.delta_pos += @s cl.delta_y
execute as @e[predicate=chestloaders:moving_cart] \
	run scoreboard players operation @s cl.delta_pos += @s cl.delta_z

#> Mark carts for unloading that are too slow:
#  After 60s, carts that move fast again are removed from the unload queue, but if they don't, then
#  they are promoted to be immediately unloaded. Carts with the `unload` tag are unloaded after 
#  cart_unload` purges every 15s
execute as @e[predicate=chestloaders:moving_cart,scores={cl.delta_pos=16..},tag=chestloaders.scheduled_unload] \
	run tag @s remove chestloaders.scheduled_unload
execute as @e[tag=chestloaders.scheduled_unload] run tag @s add chestloaders.unload
execute as @e[tag=chestloaders.scheduled_unload] run tag @s remove chestloaders.scheduled_unload
execute as @e[predicate=chestloaders:moving_cart,scores={cl.delta_pos=..15},tag=!chestloaders.unload] \
	run tag @s add chestloaders.scheduled_unload

#> Store new old x,y,z values for next run; run last:
#  Using `scoreboard` rather than `store result` to save us an NBT query and optimise a little
execute as @e[predicate=chestloaders:moving_cart] \
	run scoreboard players operation @s cl.old_x = @s cl.x
execute as @e[predicate=chestloaders:moving_cart] \
	run scoreboard players operation @s cl.old_y = @s cl.y
execute as @e[predicate=chestloaders:moving_cart] \
	run scoreboard players operation @s cl.old_z = @s cl.z

# Loop once a minute:
schedule function chestloaders:cart_timeout 60s
