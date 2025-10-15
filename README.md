# chestloaders

chestloaders is a Minecraft 1.21.8+ datapack that adds a simple and lag-friendly chunk loading system  for chest minecarts. It utilises `/forceload` to load a 3x3 of entity-processing chunks around the cart, much akin to Nether Portal loading—but on rails!

## Algorithm
* **Every second** carts moving @ ≥ 1 m/s get a 3x3 chunk area loaded
	* Carts **marked for unloading** don't get re-force loaded
* **Every 15 seconds**, all chunks _without_ a cart nearby that was just force loaded above are unloaded
* **Every 60 seconds**, all carts that have moved ≤ 15 m in the last minute are **scheduled** to be checked again
	* **After 60 seconds** from being **scheduled**:
		* **If the cart moved ≥ 16 m** in the last minute, its **schedule** is cancelled
		* **If not**, then the cart is promoted to be fully **marked for unloading**. The chunks around it will be unloaded in the range of 1–15 seconds from now

> [!note]
> **The distance a cart moved in a minute** is an important check for the logic of determining which carts shouldn't be loaded, in order to prevent lag. It is calculated as:<br>
> $$\mathrm{delta_pos}(x, y, z) \coloneqq \left|x_\mathrm{new} - x_\mathrm{old}\right| + \left|y_\mathrm{new} - y_\mathrm{old}\right| + \left|z_\mathrm{new} - z_\mathrm{old}\right|$$
> 
> **Note that** this is using the X/Y/Z coordinates, and _not_ velocity maths. Therefore, a cart can travel 300 m around a circular track (for example), but this track **must** cross over ~16 blocks in at least one axis. This prevents carts travelling in a small circle or in machines from being used as chunkloaders, thus only permitting long-distance-travelling carts.

## Installing
1. Download [the code as a ZIP](https://github.com/toydotgame/chestloaders/archive/refs/heads/main.zip) using that link or by hitting _Code_ → _Download ZIP_ above
2. Extract the ZIP to your world or server's `<world name>/datapacks/` folder. The ZIP will contain a folder called `chestloaders-main/`, and inside _that_ will be `pack.mcmeta`, `data/`, etc: you want `chestloaders-main/` to be **directly** under the `datapacks/` folder, i.e. the `pack.mcmeta` will be inside `<world name>/datapacks/chestloaders-main/`
3. In game, run `/datapack enable "file/chestloaders-main"`. That's it!
	* chestloaders will run automatically upon every world load/server boot. There's nothing you need to do in-game to get it to start chunk loading carts

## Removing
1. Run `/function chestloaders:unload` as opposed to `/datapack disable ...` to remove all scoreboards created, etc. The `unload` function will disable the datapack itself automatically, and will also tidy up tags and scoreboards created
2. Delete the `chestloaders-main/` folder inside `<world name>/datapacks/`

> [!note]
> The `unload` function removes the following tags from all entities:
> * `chestloaders.scheduled_unload`
> * `chestloaders.unload`
> * `chestloaders.just_unloaded`
> 
> It uses `@e` to do this. Generally, if a cart has these tags, it's because it's loaded. The **only** time a cart will have these tags and be unloaded is if the server restarted or crashed whilst a cart was chunk loading.
> **Tags do not inherently cause any performance issues,** however they do take up space in entity NBT and if you want to be 100% rid of chestloaders for whatever reason, do note that these tags cannot be automatically removed by the `unload` function if the carts with the tags in question aren't loaded in.
