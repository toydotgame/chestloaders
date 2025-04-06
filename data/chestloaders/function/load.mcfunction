#> CREATED ON: 2025-04-03
#> AUTHOR: toydotgame
#  load.mcfunction - Schedule functions to run on intervals rather than each tick.
#  I'm honestly not sure how this scheduling manages to keep distant carts loaded, given they're
#  technically unloaded for around a second or so. My game theory is that `forceload` is called to
#  load first,  and it prioritises `add` over `remove all` if they're called in the same tick, so chunks
#  that have been explicitly called by `cart_load` are preserved whilst `cart_unload` purges all
#  which haven't been previously force-loaded in this tick.
#  The effect of this is zero need for logic or storage to pick which chunks should be kept or not! :D

#> TODO: Fix certain chunks staying loaded forever if they have small but always-moving minecart circuits in them.
#  Maybe through placing an armour stand in a chunk every 60s and if that stand can be found after 60s more then the chunk has certainly been there too long, forcefully unload it (how?) and remove all stands, wait 60s, place stands, wait 60 more, etc. Idk!!! :3

# Look for chunks to load each second:
schedule function chestloaders:cart_load 1s
# Purge chunks after 15 seconds:
schedule function chestloaders:cart_unload 15s
