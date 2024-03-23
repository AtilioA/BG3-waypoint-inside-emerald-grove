[size=5]commuting is [b]OVER[/b][/size]
[b]Waypoint Inside Emerald Grove allows you to finally have a waypoint  INSIDE the Emerald Grove. Works on Multiplayer.[/b]
This mod works out of the box, but you can also configure it with a JSON file and pick from three different new locations: [b][u]next to Dammon and Ethel[/u] (default), next to Arron, OR next to the Sacred Pool[/b]. See the settings breakdown in the Configuration section below for more details.

[b]Clickbaity summary[/b] 😳?? It actually works by teleporting you after using the [i]Emerald Grove Environs[/i] waypoint. Well, [b]you can still teleport to the original [i]Environs[/i] waypoint location if you teleport to it while sneaking[/b]. The mod should also replace the [i]"Emerald Grove Environs"[/i]  name with [i]"Emerald Grove"[/i]. [b]It will only replace the vanilla behavior once you've entered the Grove for the first time, and if the Grove is accessible.
[/b]
Did you know that the [i]Environs[/i] waypoint also gets blocked when the Grove becomes inaccessible, despite being located well outside of it? Why can't we have a waypoint inside the Grove, then, Larian?

[img]https://i.imgur.com/fciig8j.gif[/img]

[line][b][size=5][b]
Installation[/b][/size][/b]
[list=1]
[*]Download the .zip file and install using BG3MM (recommended), or use Vortex.

[/list][b][size=4]Requirements
[/size][/b][size=2][b][url=https://www.nexusmods.com/baldursgate3/mods/7676]Volition Cabinet[/url][/b]
[url=https://github.com/Norbyte/bg3se]BG3 Script Extender[/url] [size=2](you can easily install it with BG3MM through its [i]Tools[/i] tab or by pressing CTRL+SHIFT+ALT+T while its window is focused)
[line]
[/size][/size][size=5][b]Configuration[/b][/size][size=2][size=2]
When you load a save with the mod for the first time, it will automatically create a [/size][/size][font=Courier New]waypoint_inside_emerald_grove_config[/font][size=2][size=2][font=Courier New].json[/font] file with default options.

You can easily navigate to it on Windows by pressing WIN+R and entering
[quote][size=2][size=2][code]explorer %LocalAppData%\Larian Studios\Baldur's Gate 3\Script Extender\WaypointInsideEmeraldGrove
[/code][/size][/size][/quote][/size][/size][size=2][size=2]
Open the JSON file with any text editor, even regular Notepad will work. Here's what each option inside does (order doesn't matter):

[font=Courier New]"GENERAL"[/font]:
    [font=Courier New]    "enabled"[/font]: Set to [font=Courier New]true[/font] to enable the mod, false to disable it without uninstalling. Enabled by default.

[font=Courier New]"FEATURES"[/font]:
    [font=Courier New]    "new_waypoint_destination"     [/font]: Which new destination to use. Options: [/size][/size][size=2][size=2][size=2]"[font=Courier New]THE HOLLOW[/font]"[/size][/size][/size][size=2][size=2], "[font=Courier New]ARRON[/font]"[size=2],[size=2][size=2] "[font=Courier New]SACRED POOL[/font]"[/size][/size]. [size=2][size=2][size=2]"[font=Courier New]THE HOLLOW[/font]"[/size][/size][/size] by default.[/size]
    [font=Courier New]    "original_waypoint_if_sneaking"[/font][/size][/size][size=2][size=2]: Set to [font=Courier New]true[/font] to use the original waypoint if the player is hiding/sneaking. [size=2]Enabled by default.[/size]

[font=Courier New]"DEBUG"[/font]:
    [font=Courier New]    "level"   [/font]: Set the debug level. 0 for no debug, 1 for minimal, and 2 for verbose logs. 0 by default.
[size=2]
[size=2][size=2][size=2][size=2][size=2][size=2]After saving your changes while the game is running, load a save to reflect your changes or run [font=Courier New]!wieg_reload[/font] in the SE console.[/size][/size][/size][/size][/size][/size]

[/size][/size][line][size=4][b]
[/b][/size][/size][size=5][b]Compatibility[/b][/size]
This mod should be compatible with most game versions and other mods and should be uninstall-friendly.

[line][size=4][b]
Special Thanks[/b][/size]
Thanks to [url=https://www.nexusmods.com/baldursgate3/users/69959758?tab=user+files]Eralyne[/url] for the help with flags (to check player progression); to [url=https://www.nexusmods.com/baldursgate3/users/84303488?tab=user+files]alterNERDtive[/url] for helping troubleshoot my localization setup and ultimately playtesting this locale when I gave up trying to make it work on my machine (that's why the GIF shows [i]Environs[/i]); and to [url=https://github.com/Norbyte]Norbyte[/url] for the Script Extender.

[size=4][b]Source Code[/b][/size][size=4][b]
[/b][/size]The source code is available on [url=https://github.com/AtilioA/BG3-waypoint-to-emerald-grove-interior]GitHub[/url] or by unpacking the .pak file. Endorse on Nexus and give it a star on GitHub if you liked it!
[line]
[center][b][size=4]My mods[/size][/b][size=2]
[b][/b][url=https://www.nexusmods.com/baldursgate3/mods/7676]Volition Cabinet[/url]﻿ - library mod for most of my other mods
[url=https://www.nexusmods.com/baldursgate3/mods/6995]Waypoint Inside Emerald Grove[/url] - 'adds' a waypoint inside Emerald Grove
[b][size=4][url=https://www.nexusmods.com/baldursgate3/mods/7035][size=4][size=2]Auto Send Read Books To Camp[/size][/size][/url]﻿[size=4][size=2] [/size][/size][/size][/b][size=4][size=4][size=2]- [/size][/size][/size][size=2]send read books to camp chest automatically[/size]
[url=https://www.nexusmods.com/baldursgate3/mods/6880]Auto Use Soap[/url]﻿ - automatically use soap after combat/entering camp
[url=https://www.nexusmods.com/baldursgate3/mods/6540]Send Wares To Trader[/url]﻿[b] [/b]- automatically send all party members' wares to a character that initiates a trade[b]
[/b][b][url=https://www.nexusmods.com/baldursgate3/mods/6313]Preemptively Label Containers[/url]﻿[/b] - automatically tag nearby containers with 'Empty' or their item count[b]
[/b][url=https://www.nexusmods.com/baldursgate3/mods/5899]Smart Autosaving[/url] - create conditional autosaves at set intervals
[url=https://www.nexusmods.com/baldursgate3/mods/6086]Auto Send Food To Camp[/url] - send food to camp chest automatically
[url=https://www.nexusmods.com/baldursgate3/mods/6188]Auto Lockpicking[/url] - initiate lockpicking automatically
[size=2]
[/size][url=https://ko-fi.com/volitio][img]https://raw.githubusercontent.com/doodlum/nexusmods-widgets/main/Ko-fi_40px_60fps.png[/img][/url]﻿﻿[/size][/center][url=https://www.nexusmods.com/baldursgate3/mods/7294][center][/center][center][img]https://i.imgur.com/hOoJ9Yl.png[/img]﻿[/center][/url][center][/center]
