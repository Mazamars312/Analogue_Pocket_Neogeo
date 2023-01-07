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


defaultTemplateFile = "./template.json"

for game in games:
    templateFilePath = game["templateFile"] if "templateFile" in game else defaultTemplateFile
    gameFilePath = './Game.json/{}.json'.format(game["name"])

    print("Processing {} ({})".format(game["code"], game["name"]))

    # open both files
    with open(templateFilePath, 'r') as template, open(gameFilePath, 'w') as gameJsonFile:
        content = template.read()

        content = content.replace("GameFolder/", game["code"])

        # perform all replacements if necesary
        if "replacements" in game:
            for placeholder, value in game["replacements"].items():
                content = content.replace(placeholder, value)

        # write to game file
        gameJsonFile.write(content)


print("{} json game files generated successfully".format(len(games)))
    