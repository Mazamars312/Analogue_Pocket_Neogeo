# Neogeo for Pocket (Alpha 0.5)

This is the port of the Neogeo Core made by [Furrtek](https://www.patreon.com/furrtek/posts) to the Analogue Pocket using the APF framework and some of my own code.

## Installation and Usage 
The current Darksoft paks will work with this with the following file names:
*(Working on the *.Neo files soon)
* 68K Asset: prom
* Z80 Asset: m1rom
* CROM Asset: crom0
* SFIX Asset: srom
* Voice Asset: vroma0
* Bios: "uni-bios_1_0.rom" - This needs to be in the "/assets/ng/common"
* Lo Bios: "000-lo.lo" - This needs to be in the "/assets/ng/common"
* Copy the folders in the Github (dist) or the release .zip into the root of your SD card
* Place your game files grouped by game into its own directory in the "\assets\ng\common" folder. Folder names are included

## Controllers 

* First and second player work with the Analogue Dock.
* While in Pre-release the left trigger on the Pocket or on the first player controller is set to the system reset.

## Are Memories Supported?
No at this moment, there are a lot of moving parts in the Neogeo, but once the compatibility is up to a good point then I can get this part done. 

## Does everything work?
Not at this moment. This is an alpha and I have created many modules including memory controllers and some APF controllers for the core. Save games are not yet implemented and I'll be working on this soon. Some special chips are not yet supported.

However, a lot of the games I have tried do work

Known working games:
* Metal Slug 1,2 and X
* King of fighters 1994, 1995
* Viewpoint
* Montest
* Neo Turf Masters
* NeoDrift
* Overthetop
* Pulstar
* AOF, AOF2, AOF3 - weird sounds tho (So turn the sound down)
* King of Monsters - Some glitches in the sound

## Will you get King of Fighters 2003 to work???
I hope to move the SFIX asset shortly so this will allow all games to run

## Do I have to build JSON files for each game
For most of the games there will be a default JSON file to autoload every asset. But some games will have special chips or config which I'm working on shortly. This is a alpha build so please hold :-)

## [Pocket APF](https://www.analogue.co/developer/docs/overview) Modules
I've made the following modules which are free to use without any license and full permission from me to create with them :-)
* CRAM (ASYNC) Access
* SDRAM (SYNC) Access
* SRAM (ASYNC) Access
* I2S Audio Bus

## Z80 Error
This is due to the Z80 most likely not booting fast enough for the commands to be setup or something else. This is on the list to fix. Just press the reset button (Left Trigger) to reset the core or restart the core if needed

## License
* All the code I have built is free and open to everyone to help on building cores. 
* All other Authors code is of their own licenses, so please support them.

## How can we support you?
I would like to ask that you support the people like [Furrtek](https://www.patreon.com/furrtek/posts) and other devs as they have done a lot of work into these cores. I wish to support them by handing over my code for the modules I have made for making cores easier on the Pocket.

## Credits
* [Furrtek](https://www.patreon.com/furrtek/posts) - Please support Furrtek as much as you can as they have done a lot with the community and I enjoy seeing the de-cap processes they do.
* Please advise if there are others in this core as I do want to thank them and make sure they are supported on this.

## Special Thanks
* Electron Ash - Mate thanks for the laughs and the advise on things

