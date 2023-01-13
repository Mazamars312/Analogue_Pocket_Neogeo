######################################################################################################################
# Python - Script By Terminator2k2 & Timothee Groleau - Creates json files for Analogue Pocket NeoGeo Rom Set.       #
# Big Thank You to Timothee Groleau (timotheeg) who re-wrote the script.                                             #
# Big Thank You to Mazamars312 for porting/Fixes to the Superb Neogeo Core For The Analogue Pocket.                  #
# Big Thank You To all involved in creating this core for The MiSTer Project.                                        #
######################################################################################################################

import os
import sys
import json
import fileinput
import re
import copy

dirName = "Game.json"
try:
    os.makedirs(dirName)
    print("Directory " , dirName ,  " Created ")
except FileExistsError:
    print("Directory " , dirName ,  " already exists")
    
    
try:
    with open('romset.json', 'r') as romset:
        games = json.load(romset)
    print("Loaded {} game definitions from romset".format(len(games)))
except:
    print("Romset definition is not found")
    exit(1)    

with open('./template.json') as template_file:
    template = json.load(template_file)
    


memoryMap = {
    "PVC-Cart": "0xF0000404",
    "PCM":      "0xF000030c",
    "SMA-Cart": "0xF0000408",
    "CMC-Chip": "0xF000040c",
    "V2OFFSET":   "0xF0000310",
    "CTOLINK":  "0xF0000410",
    "V2MASK":  "0xF0000314",
    "C1WAIT":  "0xF0000400",
}

print("")

for game in games:
    gameFilePath = './Game.json/{}.json'.format(game["name"])
    print("Processing {} ({})".format(game["code"], game["name"]))

    gameFilePath = './{}/{}.json'.format(dirName, game["name"])

    content = copy.deepcopy(template)
    content["instance"]["data_path"] = game["code"]

    if ("memory_writes" in game):
        for memId, data in game["memory_writes"].items():
            content["instance"]["memory_writes"].append({
                "address": memoryMap[memId],
                "data": data
            })

    if ("has_prom1" in game and game["has_prom1"] == True):
        content["instance"]["data_slots"].append({
            "id": 8, # hardcoded 8 is not cool, but matches template
            "filename": "prom1",
        })

    # write to game file
    with open(gameFilePath, 'w') as gameJsonFile:
        gameJsonFile.write(json.dumps(content, indent=2))




print("")
print("{} json game files generated successfully".format(len(games)))     
print("Script Created by Terminator2k2 & Timothee Groleau - Enjoy")  