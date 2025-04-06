#> CREATED ON: 2025-04-03
#> AUTHOR: toydotgame
#  load.mcfunction - Schedule functions to run on intervals rather than each tick
#  I'm honestly not sure how this scheduling manages to keep distant carts loaded, given they're
#  technically unloaded for around a second or so. My game theory is that `forceload` is called to
#  load first,  and it prioritises `add` over `remove all` if they're called in the same tick, so chunks
#  that have been explicitly called by `cart_load` are preserved whilst `cart_unload` purges all
#  which haven't been previously force-loaded in this tick. `forceload` is async so it probably just
#  has a buffer for this and its priorities are respected for that, so whenever the chunk is loaded
#  (in a later tick) it uses this buffer value(?)
#  The effect of this is zero need for logic or storage to pick which chunks should be kept or not! :D
#  This doesn't apply for chunks that still have moving carts in them, so we have `cart_timeout` to
#  check that we are only loading long-distance carts rather than small contraptions

# Movement tracking scoreboards:
scoreboard objectives add cl.old_x dummy
scoreboard objectives add cl.old_y dummy
scoreboard objectives add cl.old_z dummy
scoreboard objectives add cl.x dummy
scoreboard objectives add cl.y dummy
scoreboard objectives add cl.z dummy
scoreboard objectives add cl.delta_x dummy
scoreboard objectives add cl.delta_y dummy
scoreboard objectives add cl.delta_z dummy
scoreboard objectives add cl.delta_pos dummy
# Store old pos values for `cart_timeout` once before it is first run
execute as @e[predicate=chestloaders:moving_cart] \
	store result score @s cl.old_x run data get entity @s Pos[0]
execute as @e[predicate=chestloaders:moving_cart] \
	store result score @s cl.old_y run data get entity @s Pos[1]
execute as @e[predicate=chestloaders:moving_cart] \
	store result score @s cl.old_z run data get entity @s Pos[2]

# Execution order:
function chestloaders:cart_load
function chestloaders:cart_unload
function chestloaders:cart_timeout
