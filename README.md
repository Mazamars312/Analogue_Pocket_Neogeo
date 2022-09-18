# Neogeo for Pocket (Alpha 0.7.5)

This is the port of the Neogeo Core made by [Furrtek](https://www.patreon.com/furrtek/posts) to the Analogue Pocket using the APF framework and some of my own code.

This version fixes all the memory controllers and locations for every OG Neogeo game to atleast run on the pocket.

## Installation and Usage 

If you have version 0.7.0 or below installed, it is recommended that you remove it and re-install with the new release

* There is a added file sfix.sfix required for this installation as well. please see below

The current Darksoft paks will work with this with the following file names:
*(Working on the *.Neo files soon)
* 68K PROG Asset: prom
* 68K PROG1 Asset: prom1 for the 7 games the require it.
* Z80 Asset: m1rom
* CROM Asset: crom0
* SFIX Asset: srom
* Voice Asset: vroma0
* Bios: "uni-bios_1_0.rom" - This needs to be in the "/assets/ng/common"
* Lo Bios: "000-lo.lo" - This needs to be in the "/assets/ng/common"
* Sfix : "sfix.sfix" - This needs to be in the "/assets/ng/common" - Please make sure you have this files now!!!
* Copy the folders in the Github (dist) or the release .zip into the root of your SD card
* Place your game files grouped by game into its own directory in the "\assets\ng\common" folder.

The Autoloading JSON's provided by terminator2k2 all work with the games using the Dark Soft directory names in the "/assets/ng/common' folder

## How to use differnt BIOS for the core 
If you want more BIOS to access, First open the "/Cores/Mazamars312.NeoGeo/data.json" file. Then goto the BIOS selections Then you have 3 options:
* Change the filename to the firmware name you want to autoload in the /assets/ng/comman folder (Line 46 in the data.json)
* Remove the filename line completely to then be able to select in the Pocket Menu. (Line 46 in the data.json)
* While in the game, press the home button and /Core Settings/Load Bios and select the other bioses

## Controllers 

* First and second player work with the Analogue Dock.
* While in Alpha 0.7.5 the left trigger on the Pocket or on the first player controller is set to the system reset.
* Currently it is setup for SNES controller layout. Analogue will allow you to change the layout in the input.json for your own enjoyment. 

I have added in the interact.json file to switch between the SNES, Normal Neogeo controller and the Neogeo CD controller layouts for instant changes. Press the home button then goto "/Core Settings/Player Type 1" and selectet between the 3 types
* Option 1 - SNES Controller layout 
* Option 2 - NeoGeo Normal controller 
* Option 3 - NeoGeo CDrom Controller 

## Are Memories Supported?
No at this moment, there are a lot of moving parts in the Neogeo, but once the compatibility is up to a good point then I can get this part done. 

## Does everything work?
This build has fixed a lot with the memory units where all of the larger orginal Neogeo game will load now. So to my knowledge every OG Neogeo game will run. so please advise if you find one that does not :-)  
There are graphic fixes that need to be addressed on games like KOF2003 with the timer and a few others. This will be looked at in later versions.

## Will you get NEO files working?
Soon I want to do this in later versions at this moment. I dont fully understand how these files fully at this moment. So this is a limit on my side for this moment.

## Do I have to build JSON files for each game
No not evey game, terminator2k2 has build every game that is in the ROMset that also configures the core for special chips as well. So big thanks to him on this. His code via python is in the folders as well. He has also added Xeno Crisis JSON as well, So please support [Bitmap Bureau](https://bitmapbureau.com/) and get their fantastic game.

## [Pocket APF](https://www.analogue.co/developer/docs/overview) Modules
I've made the following modules which are free to use without any license and full permission from me to create with them :-)
* CRAM (ASYNC) Access
* SDRAM (SYNC) Access
* SRAM (ASYNC) Access
* I2S Audio Bus

## Can I play in PAL mode
Yes. Once in the game, press the Anaolgue Pocket's Home button then direct yourself to the /Core Settings/Cores menu. In there you can select between NTSC and PAL on the fly. You can even move the screen around, but this is very limited at this moment.

## Why is the refresh different then to the Mister core?
First off the core runs in MSV mode (so a straight 24mhz) So I bet that is one of the two issues.

Secondly, I am using a PLL and not counters for dividing the clocks internally on the Neogeo, My theory is that the counters ran a bit faster on the set and hold stage of the regs then the PLL.

Will be making a PLL Configuration tool soon to correct this.

## Some games are cut off on the sides of the image

It looks like some games like to use about 304 pixel output and others like 320 pixels. The next build will have this option to select between these two options.

## Why where you late with this release?
I have been both moving house and renovating at the same time. So I didnt want dust on and in my computer and Pocket. 20sq meters of ripping up tiles is a fun task but very dusty job.

## License
* All the code I have built is free and open to everyone to help on building cores. 
* All other Authors code is of their own licenses, so please support them.

## How can we support you?
I would like to ask that you support the people like [Furrtek](https://www.patreon.com/furrtek/posts) and other devs as they have done a lot of work into these cores. I wish to support them by handing over my code for the modules I have made for making cores easier on the Pocket. However I am a coffee freak so feel free to buy me a [coffee](https://www.buymeacoffee.com/Ultrafp64) if you like

## Credits
* [Furrtek](https://www.patreon.com/furrtek/posts) - Please support Furrtek as much as you can as they have done a lot with the community and I enjoy seeing the de-cap processes they do.
* [Jotego](https://www.patreon.com/topapate) - For his cycle accurate [JT12](https://github.com/jotego/jt12) and [JT49](https://github.com/jotego/jt49) implementation that is used in this core.
* [Jorge Cwik] (fx68k@fxatari.com) The FX68K M68000 cycle accurate, fully synchronous CPU 
* [sorg - Alexey Melnikov] (https://github.com/sorgelig) Has created many of the special chips in the core and operates the Mister distribution 
* [Mister team](https://github.com/MiSTer-devel) Everyone that is in this to build great cores
* Please advise if there are others in this core as I do want to thank them and make sure they are supported on this.

## Special Thanks
* Electron Ash - Mate thanks for the laughs and the advise on things
* retrocaster and thehughhefner for advising me on more names of people for the credits how put work into this core
* terminator2k2 - advising on how some of the keymapping are on some controllers (Im still a fan of the SNES button layout tho LOL) And also building up the instanst.json file for this
* alexcom - knows a lot of the NeoGeo games and was testin games while I was building the core.
* Bitmap Bureau - Loved playing Xeno Crisis and it was a good test rom for finding the audio masking that was happening

## Fun Facts
Everyone keeps on calling me Australian because my Github was created when I first moved to Auzzie about 12 years ago. Im in fact from New Zealand (Also known as Kiwis). So Im not going to let the Auzzies claim me like they try to with the band Crowded House and the cake known as Pavlova. Thats ours!!!! 
You Auzzies can keep Russel Crow tho HAHAHA. 

* Every time a Kiwi moves to Australia - The average IQ of both countries increases.
* Fosters Beer is an Australian beer that is not made in Australia. Talk about marketing there!!!
* After all the jokes we Kiwi's and Aussie say to each other, we will always come together for a beer and party with lots of laughs.
