[i][right]English is not my native language, so sorry about that.[/right][/i]
Kerber's Mod Manager (KMM) - lets you do many things that any good mod manager can do, like activating plugins, configure game settings and mods installing.

[b][size=3]Supported games:[/size][/b]
The Elder Scrolls III: Morrowind
The Elder Scrolls IV: Oblivion
The Elder Scrolls V: Skyrim

Fallout 3
Fallout: New Vegas
Fallout 4

[b][size=3]Components[/size]
[/b]KMM consist of three main components: ConfigINI, DataFiles and Installers.

[b]ConfigINI
[/b]This component allows you to tweak game settings, creating backups of config files and control it's "Read only" attribute. ConfigINI fully developed only for Skyrim and Fallout 4 (it copies all config windows from Skyrim due to game engines similarity).

[b]DataFiles
[/b]Provides functions for plugin activation and some other small things such as archive registration, save manager, screenshots gallery etc.

Plugin activation bypass is available for Fallout 4 1.5+ as a toggleable option. Also contains "Read only" attribute control of load order files.

[b]Installers[/b]
Most large component. Provides all functions for creating customizable installers and installing them. KMM uses it's own installer format - AMI what stands for Advanced Mod Installer, immodest, I know. KMM also supports FOMod, but only configurable variant (with ModuleConfig.xml). I can say that AMI have some features that configurable FOMod don't support. I won't say anything about scripted installers - script is a script, you can do pretty anything with scripts. KMM do not have scripted variant of AMI. And i have no intend of creating it right now. KMM doesn't support BAIN either.

I can provide more information if you need.

[size=3][b]Localization
[/b][/size]KMM has russian and english interface translations. Help file is available only in russian. If you want to translate it - you're welcome.

Now about bad thing - Unicode. KMM doesn't support it, no, that's incorrect, KMM interface can not display unicode (UTF-8, UTF-16, any of it) and I can't do anythig to fix it right now. So any translation is system dependant, altrough english interface should work everywhere.

[size=3][b]Known issues
[/b][/size]Too many to write it here. I described above one of the largest. If you noticed something weird let me know.

[size=3][b]Requirements and installing
[/b][/size]Requires Windows XP or newer and [url=https://www.microsoft.com/en-US/download/details.aspx?id=5555]VC Redist 2010 x86[/url]﻿﻿, no .NET framework or something like that.
[size=3][b]
[/b][/size]Extract archive to any folder and run file "KerberModManager.exe". You may want to install programm to "Program FIles" folder, it doesn't matter. After launch program should automaticaly switch to english interface and show list of supported games, just like Nexus Mod Manager.

Program provided AS IS. I explain. I do not guarantee that it will work correctly on every system. I do guarantee that program works correctly on my system. And I am not responsible for any damage to your system (no, KMM does not contain viruses).

[size=3][b]Frequently Asked Questions
[/b][/size]Q: Is this better than Mod Organizer?
A: Relate to virtual file system - no. In all other cases - maybe. I don't use MO.

Will add more later.

[size=3][b]Licensing[/b]
[/size]Do not redistribute on other sites under any circumstances.