######################################################################################################################
# Python - Script By Terminator2k2 - Creates json files for Analogue Pocket NeoGeo Rom Set. This requires an up to   #
# date template.json in the same folder as this file. output files go to a folder named   "Game.json"                #
# Big Thank You to Mazamars312 for porting/Fixes to the Superb Neogeo Core For The Analogue Pocket.                  #
# Big Thank You To all involved in creating this core for The MiSTer Project.                                        #
######################################################################################################################

import os
import sys
import json
import fileinput

dirName = "Game.json"
try:
    os.makedirs(dirName)
    print("Directory" , dirName ,  "Created")
except FileExistsError:
    print("Directory" , dirName ,  "already exists")   


try:
    with open('romset.json', 'r') as romset:
        games = json.load(romset)
    print("Loaded {} game definitions from romset".format(len(games)))
except:
    print("Romset definition is not found")
    exit(1)


templateFilePath = "./template.json"

memoryMap = {
    "PVC-Cart": "0xf0000024",
    "PCM":      "0xf0000028",
    "SMA-Cart": "0xf000002C",
    "CMC-Chip": "0xf0000030",
    "OFFSET":   "0xf000003C",
    "CTOLINK":  "0xf0000040",
}


for game in games:
    gameFilePath = './Game.json/{}.json'.format(game["name"])

    print("Processing {} ({})".format(game["code"], game["name"]))

    # open both files
    with open(templateFilePath, 'r') as template, open(gameFilePath, 'w') as gameJsonFile:
        content = json.load(template)

        content["instance"]["data_path"] = game["code"]

        if ("memory_writes" in game):
            for memId, data in game["memory_writes"].items():
                content["instance"]["memory_writes"].append({
                    "address": memoryMap[memId],
                    "data": data
                })

        # write to game file
        gameJsonFile.write(json.dumps(content, indent=2))


print("{} json game files generated successfully".format(len(games)))
    