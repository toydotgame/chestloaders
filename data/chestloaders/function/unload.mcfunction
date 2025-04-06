#> CREATED ON: 2025-04-03
#> AUTHOR: toydotgame
#  unload.mcfunction - Must be called manually by `/function chestloaders:unload`. Simply a script
#  to delete all scoreboards  and created tags if you want the datapack to be uninstalled

scoreboard objectives remove cl.old_x
scoreboard objectives remove cl.old_y
scoreboard objectives remove cl.old_z
scoreboard objectives remove cl.x
scoreboard objectives remove cl.y
scoreboard objectives remove cl.z
scoreboard objectives remove cl.delta_x
scoreboard objectives remove cl.delta_y
scoreboard objectives remove cl.delta_z
scoreboard objectives remove cl.delta_pos

tag @e remove chestloaders.scheduled_unload
tag @e remove chestloaders.unload
tag @e remove chestloaders.just_unloaded

datapack disable "file/chestloaders"
