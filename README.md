# Neogeo for Pocket (0.8.1)

This is the port of the Neogeo Core made by [Furrtek](https://www.patreon.com/furrtek/posts) to the Analogue Pocket using the APF framework and some of my own code.

### NOTE! read the installation and Usage as the default Bios file has changed and saves can cause an issue. 

## Bug fixes in 0.8.1

* Increased the memory access from the ASYNC CRAM cores.
* Changed the PLL timing and clocks to the cores. And changed how the B1 chip gets its video clock now from the LSPC chip. Audio still on its own clock from the PLL.
* AES and MVS modes and clock changes
* redone teh V2 Masking and offset to get all the PCM audio working on some games - Like Blue's Journey, NAM-74 and The Super Spy
* Add some bug fixes that paulb-nl found including the C1 waits and audio issues.
* On the fly Aspect ratio changes in the interact menu
* Mapable buttons in the menu - so the player type options are removed.
* Reloadable bios and game jsons while in the core.
* Reset has been removed from th eleft trigger to the interact menu.
* 320 or 304 output for some of thos games that dont use the full screen.
* masking fixed to CROMS in some games

## Installation and Usage 

If you have version 0.7.5 or below installed, it is recommended that you remove it and re-install with the new release

* There is a added file sfix.sfix required for this installation as well. please see below

The current Darksoft paks will work with this with the following file names:
*(Working on the *.Neo files soon)
* 68K PROG Asset: prom
* 68K PROG1 Asset: prom1 for the 7 games the require it.
* Z80 Asset: m1rom
* CROM Asset: crom0
* SFIX Asset: srom
* Voice Asset: vroma0
* Bios: "uni-bios_4_0.rom" - This needs to be in the "/assets/ng/common" - I upgraded to 4_0 so this might cause your pocket to not be able to launch so follow the How to use differnet BIOS below
* Lo Bios: "000-lo.lo" - This needs to be in the "/assets/ng/common"
* Sfix : "sfix.sfix" - This needs to be in the "/assets/ng/common" - Please make sure you have this files now!!!
* Copy the folders in the Github (dist) or the release .zip into the root of your SD card
* Place your game files grouped by game into its own directory in the "\assets\ng\common" folder.
* If you have an issue with an error 257 this means that the save files in the "\saves\ng\Mazamars312\" folder might need to be deleted as the max size of the saves can be 8Kbytes 

The Autoloading JSON's provided by terminator2k2 all work with the games using the Dark Soft directory names in the "/assets/ng/common' folder

## How to use change the game 
* While in the game, press the home button and /Core Settings/Load Game JSON Setup and select a new game.

## How to use differnt BIOS for the core 
You have 2 options:
* Change the filename to the firmware name you want to autoload in the /assets/ng/comman folder (Line 46 in the /Cores/Mazamars312.NeoGeo/data.json)
* While in the game, press the home button and /Core Settings/Load Bios and select an other bios file 

## Controllers 

These are all mapped by the Interact menu with Analogue Key mapper. So I have removed the old player controler types as it is not needed now.

## Are Memories Supported?
No at this moment, there are a lot of moving parts in the Neogeo. 

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
Yes. Once in the game, press the Anaolgue Pocket's Home button then direct yourself to the /Cor Settings/. In there you can select between NTSC and PAL on the fly. You can even move the screen around.

## Can I play in AES mode

Yes. Once in the game, press the Anaolgue Pocket's Home button then direct yourself to the /Core Settings/ then to MVS/AES. In there you can select between MVS and AES and this does change the clock speeds too but causes a reboot due to the clock change. This will not change in the UniBios startup display as that is a feature of the Bios, so go into the UniBios setup and change it in there :-) Thanks

## Are there bugs?

Yes. the current known bugs are in AOF 1 where some of the sprites are not displayed correcty (Im guessing a masking issue), and sometimes I have seen The Super Spy's logo will not come up. The next build I hope to have these done.

## Why is the refresh different then to the Mister core?
Not anymore. im out by only .001 of a frame now!!! YAY

## Some games are cut off on the sides of the image

Try running in High Res mode as that will run the game in 320 pixels and adjust both the screen X and Y to get the best image output.

## What caused the slow downs in the previous build?

* This happened due to me moving the SROMS into the CRAM memory that has both the 68K and Z80 programs with the SROM getting the highest prority. Thus the 68K was being staved of access.
* So not only did I decrease the time to get the data from the CRAM from about 11 clock cycles to about 7-8 at 96mhz. But also I made the video core more accepting to a slight delay for SROM data if the 68K needs access first.
* From what I can see this has improved the core a lot. Just not Metal Slug 2... we all know that it was full of slow downs even on real hardware. Get MSlug X or 2 Turbo and see the difference.

## Aspect ratios are weird???

Yes that is why I have configered the core so you can have 4 options between 304 and 320 H pixel outputs. By default in the list there is:
* 19:15 Best for the 304 output 
* 4:3 Best for 320 output 
* 160:144 Best for full screen on the Pocket
* 16:9 Best for outputing fullscreen on a 1080P screen 

## No the Aspect rations are really weird!!!

Well if you dont like them, you can change them yourself........ in the following json files :-)
* Video.json - in here there are the top 4 entrys are for the 304 resolution and the bottom 4 are for outputting in 320. From there you can change each one to the aspect ratio you want to see. Look for the aspect_h and aspect_v entries. Make sure you do this for both the 304 and 320 groups. Or mix it up thats your option here :-)
* interact.json - search for "name": "Video Scaler output", "id": 7, and in that list there are only 4 entrys that work with top and bottom 4 entrys in the Video.json. From here you can name them to what ever you want for your own reference from the Video.json.
Have a play with it as it will only affect the scaler. Hell, have a go with the rotation with values of 90 or 180 and give yourself a challange :-)

## The clock does not work

Yes, I need to build the rtc and timer for the core for this to do this. in the list for the next build.

## Why where you late with this release and the one before?

I have been both moving house and renovating at the same time. So I didnt want dust on and in my computer and Pocket. 20sq meters of ripping up tiles is a fun task but very dusty job. And add painting every room and building a new kitchen. Then there was building the Amiga core and working on a MPU for Media access on the pocket

## License
* All the code I have built is free and open to everyone to help on building cores. 
* All other Authors code is of their own licenses, so please support them.

## How can we support you?
I would like to ask that you support the people like [Furrtek](https://www.patreon.com/furrtek/posts) and other devs as they have done a lot of work into these cores. I wish to support them by handing over my code for the modules I have made for making cores easier on the Pocket. However I am a coffee freak so feel free to buy me a [coffee](https://www.buymeacoffee.com/Ultrafp64) if you like

## Are you getting paid by Analogue for all this work?

No not for any of the cores I have made for the pocket, they have given me hardware and always helped me when I have asked, so I am grateful for them for doing this. 
I do build these on the pocket as I do enjoy having a handheld device that I can use while on the train or going else where for my gaming fix(next to coffee). 
But the main thing is I love programming and love classic consoles when I can play them. 

## Why not Mister!

Mister stuff will come out soon, as I would like to see more cores out there. Right now Im already doing a lot and am not ready to get into more projects at this moment. 

## Credits
* [Furrtek](https://www.patreon.com/furrtek/posts) - Please support Furrtek as much as you can as they have done a lot with the community and I enjoy seeing the de-cap processes they do.
* [Jotego](https://www.patreon.com/topapate) - For his cycle accurate [JT12](https://github.com/jotego/jt12) and [JT49](https://github.com/jotego/jt49) implementation that is used in this core.
* [Jorge Cwik] (fx68k@fxatari.com) The FX68K M68000 cycle accurate, fully synchronous CPU 
* [sorg - Alexey Melnikov] (https://github.com/sorgelig) Has created many of the special chips in the core and operates the Mister distribution 
* [Mister team](https://github.com/MiSTer-devel) Everyone that is in this to build great cores
* [paulb-nl] (https://github.com/paulb-nl) Great finds on the last sprites not getting rendered, JT11 bug fixes for sound in cores and the C1 wait stat bugs.
* Please advise if there are others in this core as I do want to thank them and make sure they are supported on this.

## Special Thanks
* Electron Ash - Mate thanks for the laughs and the advise on things
* retrocaster and thehughhefner for advising me on more names of people for the credits how put work into this core
* terminator2k2 - advising on how some of the keymapping are on some controllers (Im still a fan of the SNES button layout tho LOL) And also building up the instanst.json file for this
* alexcom - knows a lot of the NeoGeo games and was testin games while I was building the core. But that bloody pixel clock dude LOL 
* Bitmap Bureau - Loved playing Xeno Crisis and it was a good test rom for finding the audio masking that was happening - Will build that 32Mbyte Stereo version up soon!!!

## Fun Facts
Everyone keeps on calling me Australian because my Github was created when I first moved to Auzzie about 12 years ago. Im in fact from New Zealand (Also known as Kiwis). So Im not going to let the Auzzies claim me like they try to with the band Crowded House and the cake known as Pavlova. Thats ours!!!! 
You Auzzies can keep Russel Crow tho HAHAHA. 

* Every time a Kiwi moves to Australia - The average IQ of both countries increases.
* Fosters Beer is an Australian beer that is not made in Australia. Talk about marketing there!!!
* After all the jokes we Kiwi's and Aussie say to each other, we will always come together for a beer and party with lots of laughs.
