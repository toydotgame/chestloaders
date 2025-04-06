#> CREATED ON: 2025-04-05
#> AUTHOR: toydotgame
#  cart_unload.mcfunction - Unloads all chunks where there were no `moving_cart` predicates
#  force-loaded in `cart_load` (therefore must be called in the same tick as `cart_load`). Runs
#  every 15 seconds

forceload remove all
schedule function chestloaders:cart_unload 15s
