######################################################################################################################
# Python - Script By Terminator2k2 - Creates json files for Analogue Pocket NeoGeo Rom Set. This requires an up to   #
# date template.json in the same folder as this file. output files go to a folder named   "Game.json"                #
# Big Thank You to Mazamars312 for porting/Fixes to the Superb Neogeo Core For The Analogue Pocket.                  #
# Big Thank You To all involved in creating this core for The MiSTer Project.                                        #
######################################################################################################################

import os
import sys
import fileinput

#os.makedirs("Game.json") 
dirName = "Game.json"
try:
    os.makedirs("Game.json")    
    print("Directory " , dirName ,  " Created ")
except FileExistsError:
    print("Directory " , dirName ,  " already exists")   

# open both files
with open('template.json','r') as firstfile, open ('./Game.json/2020 Super Baseball.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/2020 Super Baseball.json", inplace=True):
    
    # This will replace string "GameFolder/" with "2020bb" in each line
    line = line.replace("GameFolder/", "2020bb")
    
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
  # open both files
with open('template.json','r') as firstfile, open ('./Game.json/2020 Super Baseball (set 2).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/2020 Super Baseball (set 2).json", inplace=True):
    
    # This will replace string "GameFolder/" with "2020bba" in each line
    line = line.replace("GameFolder/", "2020bba")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)



 # open both files
with open('template.json','r') as firstfile, open ('./Game.json/2020 Super Baseball (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/2020 Super Baseball (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "2020bbh" in each line
    line = line.replace("GameFolder/", "2020bbh")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/3 Count Bout.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/3 Count Bout.json", inplace=True):
    
    # This will replace string "GameFolder/" with "3countb" in each line
    line = line.replace("GameFolder/", "3countb")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
   




# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Alpha Mission II.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Alpha Mission II.json", inplace=True):
    
    # This will replace string "GameFolder/" with "alpham2" in each line
    line = line.replace("GameFolder/", "alpham2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Alpha Mission II Proto.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Alpha Mission II Proto.json", inplace=True):
    
    # This will replace string "GameFolder/" with "alpham2p" in each line
    line = line.replace("GameFolder/", "alpham2p")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Andro Dunos.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Andro Dunos.json", inplace=True):
    
    # This will replace string "GameFolder/" with "androdun" in each line
    line = line.replace("GameFolder/", "androdun")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Aggressor\'s of Dark Kombat.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Aggressor\'s of Dark Kombat.json", inplace=True):
    
    # This will replace string "GameFolder/" with "aodk" in each line
    line = line.replace("GameFolder/", "aodk")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Art of Fighting.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Art of Fighting.json", inplace=True):
    
    # This will replace string "GameFolder/" with "aof" in each line
    line = line.replace("GameFolder/", "aof")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Art of Fighting 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Art of Fighting 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "aof2" in each line
    line = line.replace("GameFolder/", "aof2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
        # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Art of Fighting 2 (NGH-056).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Art of Fighting 2 (NGH-056).json", inplace=True):
    
    # This will replace string "GameFolder/" with "aof2a" in each line
    line = line.replace("GameFolder/", "aof2a")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    




     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Art of Fighting 3.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Art of Fighting 3.json", inplace=True):
    
    # This will replace string "GameFolder/" with "aof3" in each line
    line = line.replace("GameFolder/", "aof3")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
      # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Bang Bang Buster\'s.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Bang Bang Buster\'s.json", inplace=True):
    
    # This will replace string "GameFolder/" with "b2b" in each line
    line = line.replace("GameFolder/", "b2b")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Bakatonosama Mahjong Manyuuki.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Bakatonosama Mahjong Manyuuki.json", inplace=True):
    
    # This will replace string "GameFolder/" with "bakatono" in each line
    line = line.replace("GameFolder/", "bakatono")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Bang Bead.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Bang Bead.json", inplace=True):
    
    # This will replace string "GameFolder/" with "bangbead" in each line
    line = line.replace("GameFolder/", "bangbead")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Blue\'s Journey.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Blue\'s Journey.json", inplace=True):
    
    # This will replace string "GameFolder/" with "bjourney" in each line
    line = line.replace("GameFolder/", "bjourney")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Blazing Star.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Blazing Star.json", inplace=True):
    
    # This will replace string "GameFolder/" with "blazstar" in each line
    line = line.replace("GameFolder/", "blazstar")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Breakers.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Breakers.json", inplace=True):
    
    # This will replace string "GameFolder/" with "breakers" in each line
    line = line.replace("GameFolder/", "breakers")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Breakers Revenge.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Breakers Revenge.json", inplace=True):
    
    # This will replace string "GameFolder/" with "breakrev" in each line
    line = line.replace("GameFolder/", "breakrev")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Baseball Stars Professional.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Baseball Stars Professional.json", inplace=True):
    
    # This will replace string "GameFolder/" with "bstars" in each line
    line = line.replace("GameFolder/", "bstars")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Baseball Stars Professional (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Baseball Stars Professional (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "bstarsh" in each line
    line = line.replace("GameFolder/", "bstarsh")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Baseball Stars 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Baseball Stars 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "bstars2" in each line
    line = line.replace("GameFolder/", "bstars2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Burning Fight.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Burning Fight.json", inplace=True):
    
    # This will replace string "GameFolder/" with "burningf" in each line
    line = line.replace("GameFolder/", "burningf")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Burning Fight (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Burning Fight (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "brningfh" in each line
    line = line.replace("GameFolder/", "brningfh")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Burning Fight (prototype).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Burning Fight (prototype).json", inplace=True):
    
    # This will replace string "GameFolder/" with "brnngfpa" in each line
    line = line.replace("GameFolder/", "brnngfpa")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)  




        # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Burning Fight (proto older).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Burning Fight (proto older).json", inplace=True):
    
    # This will replace string "GameFolder/" with "brningfp" in each line
    line = line.replace("GameFolder/", "brningfp")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line) 
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Columns.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Columns.json", inplace=True):
    
    # This will replace string "GameFolder/" with "columnsn" in each line
    line = line.replace("GameFolder/", "columnsn")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Crossed Swords 2 (CD conv).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Crossed Swords 2 (CD conv).json", inplace=True):
    
    # This will replace string "GameFolder/" with "crswd2bl" in each line
    line = line.replace("GameFolder/", "crswd2bl")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    





# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Crossed Swords.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Crossed Swords.json", inplace=True):
    
    # This will replace string "GameFolder/" with "crsword" in each line
    line = line.replace("GameFolder/", "crsword")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Captain Tomaday.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Captain Tomaday.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ctomaday" in each line
    line = line.replace("GameFolder/", "ctomaday")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Cyber-Lip.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Cyber-Lip.json", inplace=True):
    
    # This will replace string "GameFolder/" with "cyberlip" in each line
    line = line.replace("GameFolder/", "cyberlip")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Digger Man.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Digger Man.json", inplace=True):
    
    # This will replace string "GameFolder/" with "diggerma" in each line
    line = line.replace("GameFolder/", "diggerma")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Double Dragon.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Double Dragon.json", inplace=True):
    
    # This will replace string "GameFolder/" with "doubledr" in each line
    line = line.replace("GameFolder/", "doubledr")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Dragons Heaven.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Dragons Heaven.json", inplace=True):
    
    
    
    # This will replace string "GameFolder/" with "dragonsh" in each line
    line = line.replace("GameFolder/", "dragonsh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Eight Man.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Eight Man.json", inplace=True):
    
    # This will replace string "GameFolder/" with "eightman" in each line
    line = line.replace("GameFolder/", "eightman")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Fatal Fury Special.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Fatal Fury Special.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fatfursp" in each line
    line = line.replace("GameFolder/", "fatfursp")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Fatal Fury Special (NGM-058).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Fatal Fury Special (NGM-058).json", inplace=True):
    
    # This will replace string "GameFolder/" with "ftfurspa" in each line
    line = line.replace("GameFolder/", "ftfurspa")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Fatal Fury.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Fatal Fury.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fatfury1" in each line
    line = line.replace("GameFolder/", "fatfury1")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template3.json','r') as firstfile, open ('./Game.json/Fatal Fury 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Fatal Fury 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fatfury2" in each line
    line = line.replace("GameFolder/", "fatfury2")
    line = line.replace("0xCTOLINK", "0x00000001")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Fatal Fury 3.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Fatal Fury 3.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fatfury3" in each line
    line = line.replace("GameFolder/", "fatfury3")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Football Frenzy.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Football Frenzy.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fbfrenzy" in each line
    line = line.replace("GameFolder/", "fbfrenzy")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Fight Fever.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Fight Fever.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fightfev" in each line
    line = line.replace("GameFolder/", "fightfev")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Fight Fever (set 2).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Fight Fever (set 2).json", inplace=True):
    
    # This will replace string "GameFolder/" with "fghtfeva" in each line
    line = line.replace("GameFolder/", "fghtfeva")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Battle Flip Shot.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Battle Flip Shot.json", inplace=True):
    
    # This will replace string "GameFolder/" with "flipshot" in each line
    line = line.replace("GameFolder/", "flipshot")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Frog Feast.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Frog Feast.json", inplace=True):
    
    # This will replace string "GameFolder/" with "frogfest" in each line
    line = line.replace("GameFolder/", "frogfest")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Idol Mahjong Final Romance 2 (CD conv).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Idol Mahjong Final Romance 2 (CD conv).json", inplace=True):
    
    # This will replace string "GameFolder/" with "froman2b" in each line
    line = line.replace("GameFolder/", "froman2b")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Fighters Swords.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Fighters Swords.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fswords" in each line
    line = line.replace("GameFolder/", "fswords")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Galaxy Fight Universal Warriors.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Galaxy Fight Universal Warriors.json", inplace=True):
    
    # This will replace string "GameFolder/" with "galaxyfg" in each line
    line = line.replace("GameFolder/", "galaxyfg")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # Python - Modifying a file using fileinput and sys module




# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Ganryu.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ganryu.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ganryu" in each line
    line = line.replace("GameFolder/", "ganryu")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Garou - Mark of the Wolves (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Garou - Mark of the Wolves (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "garoubl" in each line
    line = line.replace("GameFolder/", "garoubl")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/Garou - Mark of the Wolves.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Garou - Mark of the Wolves.json", inplace=True):
    
    # This will replace string "GameFolder/" with "garou" in each line
    line = line.replace("GameFolder/", "garou")
    line = line.replace("0xPVC-Cart", "0x00000000")
    line = line.replace("0xSMA-Cart", "0x00000002")
    line = line.replace("0xCMC-Chip", "0x00000001")
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/Garou - Mark of the Wolves (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Garou - Mark of the Wolves (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "garouh" in each line
    line = line.replace("GameFolder/", "garouh")
    line = line.replace("0xPVC-Cart", "0x00000000")
    line = line.replace("0xSMA-Cart", "0x00000003")
    line = line.replace("0xCMC-Chip", "0x00000001")
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Garou - Mark of the Wolves (proto).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Garou - Mark of the Wolves (proto).json", inplace=True):
    
    # This will replace string "GameFolder/" with "garoup" in each line
    line = line.replace("GameFolder/", "garoup")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
   




# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Ghostlop.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ghostlop.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ghostlop" in each line
    line = line.replace("GameFolder/", "ghostlop")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Goal! Goal! Goal!.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Goal! Goal! Goal!.json", inplace=True):
    
    # This will replace string "GameFolder/" with "goalx3" in each line
    line = line.replace("GameFolder/", "goalx3")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Voltage Fighter Gowcaizer.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Voltage Fighter Gowcaizer.json", inplace=True):
    
    # This will replace string "GameFolder/" with "gowcaizr" in each line
    line = line.replace("GameFolder/", "gowcaizr")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Ghost Pilots.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ghost Pilots.json", inplace=True):
    
    # This will replace string "GameFolder/" with "gpilots" in each line
    line = line.replace("GameFolder/", "gpilots")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00280000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Ghost Pilots (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ghost Pilots (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "gpilotsh" in each line
    line = line.replace("GameFolder/", "gpilotsh")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00280000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Gururin.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Gururin.json", inplace=True):
    
    # This will replace string "GameFolder/" with "gururin" in each line
    line = line.replace("GameFolder/", "gururin")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Hyprnoid.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Hyprnoid.json", inplace=True):
    
    # This will replace string "GameFolder/" with "hyprnoid" in each line
    line = line.replace("GameFolder/", "hyprnoid")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Ironclad.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ironclad.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ironclad" in each line
    line = line.replace("GameFolder/", "ironclad")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Ironclad (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ironclad (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "irnclado" in each line
    line = line.replace("GameFolder/", "irnclado")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Irritating Maze.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Irritating Maze.json", inplace=True):
    
    # This will replace string "GameFolder/" with "irrmaze" in each line
    line = line.replace("GameFolder/", "irrmaze")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Janshin Densetsu Quest of Jongmaster.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Janshin Densetsu Quest of Jongmaster.json", inplace=True):
    
    # This will replace string "GameFolder/" with "janshin" in each line
    line = line.replace("GameFolder/", "janshin")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Puzzled.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Puzzled.json", inplace=True):
    
    # This will replace string "GameFolder/" with "joyjoy" in each line
    line = line.replace("GameFolder/", "joyjoy")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # Python - Modifying a file using fileinput and sys module




# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Far East of Eden Kabuki Klash.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Far East of Eden Kabuki Klash.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kabukikl" in each line
    line = line.replace("GameFolder/", "kabukikl")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Karnov\'s Revenge.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Karnov\'s Revenge.json", inplace=True):
    
    # This will replace string "GameFolder/" with "karnovr" in each line
    line = line.replace("GameFolder/", "karnovr")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Kizuna Encounter Super Tag Battle.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Kizuna Encounter Super Tag Battle.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kizuna" in each line
    line = line.replace("GameFolder/", "kizuna")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters 2002 Magic Plus II, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters 2002 Magic Plus II, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kf2k2mp2" in each line
    line = line.replace("GameFolder/", "kf2k2mp2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters 2002 Magic Plus, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters 2002 Magic Plus, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kf2k2mp" in each line
    line = line.replace("GameFolder/", "kf2k2mp")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    

    
    
    
    # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/King of Fighters 2000.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters 2000.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2000" in each line
    line = line.replace("GameFolder/", "kof2000")
    line = line.replace("0xPVC-Cart", "0x00000000")
    line = line.replace("0xSMA-Cart", "0x00000005")
    line = line.replace("0xCMC-Chip", "0x00000002")
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters 2001, The (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters 2001, The (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2001h" in each line
    line = line.replace("GameFolder/", "kof2001h")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters 2001, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters 2001, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2001" in each line
    line = line.replace("GameFolder/", "kof2001")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters 2002, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters 2002, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2002" in each line
    line = line.replace("GameFolder/", "kof2002")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/King of Fighters 2003, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters 2003, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2003" in each line
    line = line.replace("GameFolder/", "kof2003")
    line = line.replace("0xPVC-Cart", "0x00000001")
    line = line.replace("0xSMA-Cart", "0x00000000")
    line = line.replace("0xCMC-Chip", "0x00000002")
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters Special Edition 2004, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters Special Edition 2004, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2k4se" in each line
    line = line.replace("GameFolder/", "kof2k4se")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters 10th Anniversary, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters 10th Anniversary, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kf10thep" in each line
    line = line.replace("GameFolder/", "kf10thep")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'94, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'94, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof94" in each line
    line = line.replace("GameFolder/", "kof94")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'95, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'95, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof95" in each line
    line = line.replace("GameFolder/", "kof95")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'95, The (NGM-084).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'95, The (NGM-084).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof95a" in each line
    line = line.replace("GameFolder/", "kof95a")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'95, The (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'95, The (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof95h" in each line
    line = line.replace("GameFolder/", "kof95h")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'96, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'96, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof96" in each line
    line = line.replace("GameFolder/", "kof96")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'96, The (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'96, The (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof96h" in each line
    line = line.replace("GameFolder/", "kof96h")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'97, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'97, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof97" in each line
    line = line.replace("GameFolder/", "kof97")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'97, The (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'97, The (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof97h" in each line
    line = line.replace("GameFolder/", "kof97h")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'97, The (Korean).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'97, The (Korean).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof97k" in each line
    line = line.replace("GameFolder/", "kof97k")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'97, The Chongchu Jianghu Plus 2003.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'97, The Chongchu Jianghu Plus 2003.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof97oro" in each line
    line = line.replace("GameFolder/", "kof97oro")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'97 Plus, The (Bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'97 Plus, The (Bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof97pls" in each line
    line = line.replace("GameFolder/", "kof97pls")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'98, The - The Slugfest (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'98, The - The Slugfest (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof98h" in each line
    line = line.replace("GameFolder/", "kof98h")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'98, The - The Slugfest (NGM-2420).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'98, The - The Slugfest (NGM-2420).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof98a" in each line
    line = line.replace("GameFolder/", "kof98a")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'98, The - The Slugfest.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'98, The - The Slugfest.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof98" in each line
    line = line.replace("GameFolder/", "kof98")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'98, The - The Slugfest (Korean).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'98, The - The Slugfest (Korean).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof98k" in each line
    line = line.replace("GameFolder/", "kof98k")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Fighters \'99, The Millennium Battle (proto).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'99, The Millennium Battle (proto).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof99p" in each line
    line = line.replace("GameFolder/", "kof99p")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/King of Fighters \'99, The Millennium Battle.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'99, The Millennium Battle.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof99" in each line
    line = line.replace("GameFolder/", "kof99")
    line = line.replace("0xPVC-Cart", "0x00000000")
    line = line.replace("0xSMA-Cart", "0x00000001")
    line = line.replace("0xCMC-Chip", "0x00000000")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




     # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/King of Fighters \'99, The Millennium Battle (earlier).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Fighters \'99, The Millennium Battle (earlier).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof99e" in each line
    line = line.replace("GameFolder/", "kof99e")
    line = line.replace("0xPVC-Cart", "0x00000000")
    line = line.replace("0xSMA-Cart", "0x00000001")
    line = line.replace("0xCMC-Chip", "0x00000000")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of Gladiators.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of Gladiators.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kog" in each line
    line = line.replace("GameFolder/", "kog")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of the Monsters.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of the Monsters.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kotm" in each line
    line = line.replace("GameFolder/", "kotm")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of the Monsters (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of the Monsters (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kotmh" in each line
    line = line.replace("GameFolder/", "kotmh")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of the Monsters 2 The Next Thing.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of the Monsters 2 The Next Thing.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kotm2" in each line
    line = line.replace("GameFolder/", "kotm2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/King of the Monsters 2 The Next Thing (proto).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/King of the Monsters 2 The Next Thing (proto).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kotm2p" in each line
    line = line.replace("GameFolder/", "kotm2p")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Lansquenet 2004 (Shock Troopers 2nd Squad).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Lansquenet 2004 (Shock Troopers 2nd Squad).json", inplace=True):
    
    # This will replace string "GameFolder/" with "lans2004" in each line
    line = line.replace("GameFolder/", "lans2004")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Last Blade, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Last Blade, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lastblad" in each line
    line = line.replace("GameFolder/", "lastblad")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Last Blade, The (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Last Blade, The (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "lstbladh" in each line
    line = line.replace("GameFolder/", "lstbladh")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
        
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Last Blade 2, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Last Blade 2, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lastbld2" in each line
    line = line.replace("GameFolder/", "lastbld2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Last Hope.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Last Hope.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lasthope" in each line
    line = line.replace("GameFolder/", "lasthope")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Last Soldier, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Last Soldier, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lastsold" in each line
    line = line.replace("GameFolder/", "lastsold")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/League Bowling.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/League Bowling.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lbowling" in each line
    line = line.replace("GameFolder/", "lbowling")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Legend of Success Joe.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Legend of Success Joe.json", inplace=True):
    
    # This will replace string "GameFolder/" with "legendos" in each line
    line = line.replace("GameFolder/", "legendos")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Last Resort.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Last Resort.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lresort" in each line
    line = line.replace("GameFolder/", "lresort")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





       # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Last Resort (prototype).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Last Resort (prototype).json", inplace=True):
    
    # This will replace string "GameFolder/" with "lresortp" in each line
    line = line.replace("GameFolder/", "lresortp")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line) 
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Magical Drop II.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Magical Drop II.json", inplace=True):
    
    # This will replace string "GameFolder/" with "magdrop2" in each line
    line = line.replace("GameFolder/", "magdrop2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Magical Drop III.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Magical Drop III.json", inplace=True):
    
    # This will replace string "GameFolder/" with "magdrop3" in each line
    line = line.replace("GameFolder/", "magdrop3")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Magician Lord.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Magician Lord.json", inplace=True):
    
    # This will replace string "GameFolder/" with "maglord" in each line
    line = line.replace("GameFolder/", "maglord")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Magician Lord (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Magician Lord (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "maglordh" in each line
    line = line.replace("GameFolder/", "maglordh")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)  





       # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Neo Black Tiger.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Neo Black Tiger.json", inplace=True):
    
    # This will replace string "GameFolder/" with "nblktigr" in each line
    line = line.replace("GameFolder/", "nblktigr")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line) 
    
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Mahjong Kyo Retsuden.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Mahjong Kyo Retsuden.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mahretsu" in each line
    line = line.replace("GameFolder/", "mahretsu")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Chibi Marukochan Deluxe Quiz.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Chibi Marukochan Deluxe Quiz.json", inplace=True):
    
    # This will replace string "GameFolder/" with "marukodq" in each line
    line = line.replace("GameFolder/", "marukodq")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/Power Instinct Matrimelee.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Power Instinct Matrimelee.json", inplace=True):
    
    # This will replace string "GameFolder/" with "matrim" in each line
    line = line.replace("GameFolder/", "matrim")
    line = line.replace("0xPVC-Cart", "0x00000000")
    line = line.replace("0xSMA-Cart", "0x00000000")
    line = line.replace("0xCMC-Chip", "0x00000002")
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Money Puzzle Exchanger.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Money Puzzle Exchanger.json", inplace=True):
    
    # This will replace string "GameFolder/" with "miexchng" in each line
    line = line.replace("GameFolder/", "miexchng")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Minasan no Okagesamadesu! Dai Sugoroku Taikai.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Minasan no Okagesamadesu! Dai Sugoroku Taikai.json", inplace=True):
    
    # This will replace string "GameFolder/" with "minasan" in each line
    line = line.replace("GameFolder/", "minasan")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00280000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Monitor Test ROM.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Monitor Test ROM.json", inplace=True):
    
    # This will replace string "GameFolder/" with "MonitorTest" in each line
    line = line.replace("GameFolder/", "MonitorTest")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Shougi no Tatsujin - Master of Syougi.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Shougi no Tatsujin - Master of Syougi.json", inplace=True):
    
    # This will replace string "GameFolder/" with "moshougi" in each line
    line = line.replace("GameFolder/", "moshougi")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Metal Slug.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug" in each line
    line = line.replace("GameFolder/", "mslug")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Metal Slug 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug2" in each line
    line = line.replace("GameFolder/", "mslug2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Metal Slug 2 Turbo.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug 2 Turbo.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug2t" in each line
    line = line.replace("GameFolder/", "mslug2t")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/Metal Slug 3.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug 3.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug3" in each line
    line = line.replace("GameFolder/", "mslug3")
    line = line.replace("0xPVC-Cart", "0x00000000")
    line = line.replace("0xSMA-Cart", "0x00000004")
    line = line.replace("0xCMC-Chip", "0x00000001")
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/Metal Slug 3 (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug 3 (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug3h" in each line
    line = line.replace("GameFolder/", "mslug3h")
    line = line.replace("0xPVC-Cart", "0x00000000")
    line = line.replace("0xSMA-Cart", "0x00000004")
    line = line.replace("0xCMC-Chip", "0x00000001")
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/Metal Slug 4.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug 4.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug4" in each line
    line = line.replace("GameFolder/", "mslug4")
    line = line.replace("0xPVC-Cart", "0x00000000")
    line = line.replace("0xSMA-Cart", "0x00000000")
    line = line.replace("0xCMC-Chip", "0x00000001")
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/Metal Slug 4 (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug 4 (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug4h" in each line
    line = line.replace("GameFolder/", "mslug4h")
    line = line.replace("0xPVC-Cart", "0x00000000")
    line = line.replace("0xSMA-Cart", "0x00000000")
    line = line.replace("0xCMC-Chip", "0x00000001")
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Metal Slug 4 Plus.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug 4 Plus.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ms4plus" in each line
    line = line.replace("GameFolder/", "ms4plus")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/Metal Slug 5.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug 5.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug5" in each line
    line = line.replace("GameFolder/", "mslug5")
    line = line.replace("0xPVC-Cart", "0x00000001")
    line = line.replace("0xSMA-Cart", "0x00000000")
    line = line.replace("0xCMC-Chip", "0x00000000")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/Metal Slug 5 (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug 5 (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug5h" in each line
    line = line.replace("GameFolder/", "mslug5h")
    line = line.replace("0xPVC-Cart", "0x00000001")
    line = line.replace("0xSMA-Cart", "0x00000000")
    line = line.replace("0xCMC-Chip", "0x00000000")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Metal Slug 6.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug 6.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug6" in each line
    line = line.replace("GameFolder/", "mslug6")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Metal Slug X.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Metal Slug X.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslugx" in each line
    line = line.replace("GameFolder/", "mslugx")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Mutation Nation.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Mutation Nation.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mutnat" in each line
    line = line.replace("GameFolder/", "mutnat")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/NAM-1975.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/NAM-1975.json", inplace=True):
    
    # This will replace string "GameFolder/" with "nam1975" in each line
    line = line.replace("GameFolder/", "nam1975")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Ninja Combat.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ninja Combat.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ncombat" in each line
    line = line.replace("GameFolder/", "ncombat")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Ninja Combat (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ninja Combat (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "ncombath" in each line
    line = line.replace("GameFolder/", "ncombath")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Ninja Commando.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ninja Commando.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ncommand" in each line
    line = line.replace("GameFolder/", "ncommand")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Neo Bomberman.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Neo Bomberman.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neobombe" in each line
    line = line.replace("GameFolder/", "neobombe")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Neo-Geo Cup 98 The Road to the Victory.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Neo-Geo Cup 98 The Road to the Victory.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neocup98" in each line
    line = line.replace("GameFolder/", "neocup98")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Neo Drift Out New Technology.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Neo Drift Out New Technology.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neodrift" in each line
    line = line.replace("GameFolder/", "neodrift")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Neo Fight.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Neo Fight.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neofight" in each line
    line = line.replace("GameFolder/", "neofight")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Neo Mr Do.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Neo Mr Do.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neomrdo" in each line
    line = line.replace("GameFolder/", "neomrdo")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Neo Thunder.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Neo Thunder.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neothund" in each line
    line = line.replace("GameFolder/", "neothund")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    



# open both files
with open('template.json','r') as firstfile, open ('./Game.json/NeoTRIS.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/NeoTRIS.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neotris" in each line
    line = line.replace("GameFolder/", "neotris")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Ninja Master\'s.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ninja Master\'s.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ninjamas" in each line
    line = line.replace("GameFolder/", "ninjamas")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Nightmare in the Dark.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Nightmare in the Dark.json", inplace=True):
    
    # This will replace string "GameFolder/" with "nitd" in each line
    line = line.replace("GameFolder/", "nitd")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
      # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Nightmare in the Dark (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Nightmare in the Dark (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "nitdbl" in each line
    line = line.replace("GameFolder/", "nitdbl")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/OverTop.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/OverTop.json", inplace=True):
    
    # This will replace string "GameFolder/" with "overtop" in each line
    line = line.replace("GameFolder/", "overtop")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Panic Bomber.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Panic Bomber.json", inplace=True):
    
    # This will replace string "GameFolder/" with "panicbom" in each line
    line = line.replace("GameFolder/", "panicbom")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Puzzle Bobble 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Puzzle Bobble 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pbobbl2n" in each line
    line = line.replace("GameFolder/", "pbobbl2n")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Puzzle Bobble.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Puzzle Bobble.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pbobblen" in each line
    line = line.replace("GameFolder/", "pbobblen")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





        # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Puzzle Bobble (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Puzzle Bobble (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "pbbblenb" in each line
    line = line.replace("GameFolder/", "pbbblenb")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line) 
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Pleasure Goal.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Pleasure Goal.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pgoal" in each line
    line = line.replace("GameFolder/", "pgoal")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Pochi and Nyaa.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Pochi and Nyaa.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pnyaa" in each line
    line = line.replace("GameFolder/", "pnyaa")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Pop \'n Bounce.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Pop \'n Bounce.json", inplace=True):
    
    # This will replace string "GameFolder/" with "popbounc" in each line
    line = line.replace("GameFolder/", "popbounc")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Prehistoric Isle 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Prehistoric Isle 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "preisle2" in each line
    line = line.replace("GameFolder/", "preisle2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Power Spikes II.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Power Spikes II.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pspikes2" in each line
    line = line.replace("GameFolder/", "pspikes2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    





# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Pulstar.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Pulstar.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pulstar" in each line
    line = line.replace("GameFolder/", "pulstar")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Puzzle De Pon! R!.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Puzzle De Pon! R!.json", inplace=True):
    
    # This will replace string "GameFolder/" with "puzzldpr" in each line
    line = line.replace("GameFolder/", "puzzldpr")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Puzzle De Pon!.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Puzzle De Pon!.json", inplace=True):
    
    # This will replace string "GameFolder/" with "puzzledp" in each line
    line = line.replace("GameFolder/", "puzzledp")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Quiz Meitantei.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Quiz Meitantei.json", inplace=True):
    
    # This will replace string "GameFolder/" with "quizdai2" in each line
    line = line.replace("GameFolder/", "quizdai2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Quiz Daisousa Sen The Last Count Down.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Quiz Daisousa Sen The Last Count Down.json", inplace=True):
    
    # This will replace string "GameFolder/" with "quizdais" in each line
    line = line.replace("GameFolder/", "quizdais")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Quiz Salibtamjeong The Last Count Down (Korean).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Quiz Salibtamjeong The Last Count Down (Korean).json", inplace=True):
    
    # This will replace string "GameFolder/" with "quizdask" in each line
    line = line.replace("GameFolder/", "quizdask")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Quiz King of Fighters.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Quiz King of Fighters.json", inplace=True):
    
    # This will replace string "GameFolder/" with "quizkof" in each line
    line = line.replace("GameFolder/", "quizkof")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Quiz King of Fighters (Korean).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Quiz King of Fighters (Korean).json", inplace=True):
    
    # This will replace string "GameFolder/" with "quizkofk" in each line
    line = line.replace("GameFolder/", "quizkofk")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Ragnagard.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ragnagard.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ragnagrd" in each line
    line = line.replace("GameFolder/", "ragnagrd")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Real Bout Fatal Fury.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Real Bout Fatal Fury.json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbff1" in each line
    line = line.replace("GameFolder/", "rbff1")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Real Bout Fatal Fury (bug fix).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Real Bout Fatal Fury (bug fix).json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbff1a" in each line
    line = line.replace("GameFolder/", "rbff1a")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Real Bout Fatal Fury 2 The Newcomers.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Real Bout Fatal Fury 2 The Newcomers.json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbff2" in each line
    line = line.replace("GameFolder/", "rbff2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Real Bout Fatal Fury 2 The Newcomers (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Real Bout Fatal Fury 2 The Newcomers (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbff2h" in each line
    line = line.replace("GameFolder/", "rbff2h")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   





     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Real Bout Fatal Fury 2 The Newcomers (Korean).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Real Bout Fatal Fury 2 The Newcomers (Korean).json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbff2k" in each line
    line = line.replace("GameFolder/", "rbff2k")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Real Bout Fatal Fury Special.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Real Bout Fatal Fury Special.json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbffspec" in each line
    line = line.replace("GameFolder/", "rbffspec")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Real Bout Fatal Fury Special (Korean).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Real Bout Fatal Fury Special (Korean).json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbffspck" in each line
    line = line.replace("GameFolder/", "rbffspck")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template4.json','r') as firstfile, open ('./Game.json/Riding Hero.json','w') as secondfile:

# read content from first file
    for line in firstfile:
    
# write content to second file
             secondfile.write(line)
             
# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Riding Hero.json", inplace=True):

    # This will replace string "GameFolder/" with "ridhero" in each line
    line = line.replace("GameFolder/", "ridhero")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    line = line.replace("0xCTOLINK", "0x00000002")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
      
    
    
    
    
    # open both files
with open('template4.json','r') as firstfile, open ('./Game.json/Riding Hero (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Riding Hero (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "ridheroh" in each line
    line = line.replace("GameFolder/", "ridheroh")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    line = line.replace("0xCTOLINK", "0x00000002")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Robo Army.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Robo Army.json", inplace=True):
    
    # This will replace string "GameFolder/" with "roboarmy" in each line
    line = line.replace("GameFolder/", "roboarmy")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Robo Army (NGM-032).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Robo Army (NGM-032).json", inplace=True):
    
    # This will replace string "GameFolder/" with "roboarma" in each line
    line = line.replace("GameFolder/", "roboarma")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)  
    
    
    





     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Rage of the Dragons.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Rage of the Dragons.json", inplace=True):
    
    # This will replace string "GameFolder/" with "rotd" in each line
    line = line.replace("GameFolder/", "rotd")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
      # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Rage of the Dragons (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Rage of the Dragons (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "rotdh" in each line
    line = line.replace("GameFolder/", "rotdh")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Strikers 1945 Plus.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Strikers 1945 Plus.json", inplace=True):
    
    # This will replace string "GameFolder/" with "s1945p" in each line
    line = line.replace("GameFolder/", "s1945p")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    



    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho" in each line
    line = line.replace("GameFolder/", "samsho")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samshoh" in each line
    line = line.replace("GameFolder/", "samshoh")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown II.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown II.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho2" in each line
    line = line.replace("GameFolder/", "samsho2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Saulabi Spirits (Korean release of Samurai Shodown II).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Saulabi Spirits (Korean release of Samurai Shodown II).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho2k" in each line
    line = line.replace("GameFolder/", "samsho2k")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Saulabi Spirits (Korean release of Samurai Shodown II, set 2).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Saulabi Spirits (Korean release of Samurai Shodown II, set 2).json", inplace=True):
    
    # This will replace string "GameFolder/" with "smsho2k2" in each line
    line = line.replace("GameFolder/", "smsho2k2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown III.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown III.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho3" in each line
    line = line.replace("GameFolder/", "samsho3")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown III (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown III (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho3h" in each line
    line = line.replace("GameFolder/", "samsho3h")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown IV Amakusa\'s Revenge.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown IV Amakusa\'s Revenge.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho4" in each line
    line = line.replace("GameFolder/", "samsho4")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Pae Wang Jeon Seol - Legend of a Warrior.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Pae Wang Jeon Seol - Legend of a Warrior.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho4k" in each line
    line = line.replace("GameFolder/", "samsho4k")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)  





    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown V Special.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown V Special.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsh5sp" in each line
    line = line.replace("GameFolder/", "samsh5sp")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)  




     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown V Special (2nd release, less censored).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown V Special (2nd release, less censored).json", inplace=True):
    
    # This will replace string "GameFolder/" with "smsh5sph" in each line
    line = line.replace("GameFolder/", "smsh5sph")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown V Special (1st release, censored).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown V Special (1st release, censored).json", inplace=True):
    
    # This will replace string "GameFolder/" with "smsh5spo" in each line
    line = line.replace("GameFolder/", "smsh5spo")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown V.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown V.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho5" in each line
    line = line.replace("GameFolder/", "samsho5")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown V (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown V (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho5b" in each line
    line = line.replace("GameFolder/", "samsho5b")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown V (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown V (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho5h" in each line
    line = line.replace("GameFolder/", "samsho5h")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
      # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown V (XBOX version hack).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown V (XBOX version hack).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho5x" in each line
    line = line.replace("GameFolder/", "samsho5x")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown V Special Final Edition.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown V Special Final Edition.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsh5fe" in each line
    line = line.replace("GameFolder/", "samsh5fe")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Samurai Shodown V Perfect.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Samurai Shodown V Perfect.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsh5pf" in each line
    line = line.replace("GameFolder/", "samsh5pf")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
 
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Savage Reign.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Savage Reign.json", inplace=True):
    
    # This will replace string "GameFolder/" with "savagere" in each line
    line = line.replace("GameFolder/", "savagere")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Super Bubble Pop.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Super Bubble Pop.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sbp" in each line
    line = line.replace("GameFolder/", "sbp")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Super Dodge Ball.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Super Dodge Ball.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sdodgeb" in each line
    line = line.replace("GameFolder/", "sdodgeb")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Sengoku.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Sengoku.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sengoku" in each line
    line = line.replace("GameFolder/", "sengoku")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Sengoku (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Sengoku (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "sengokuh" in each line
    line = line.replace("GameFolder/", "sengokuh")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Sengoku 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Sengoku 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sengoku2" in each line
    line = line.replace("GameFolder/", "sengoku2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Sengoku 3.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Sengoku 3.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sengoku3" in each line
    line = line.replace("GameFolder/", "sengoku3")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Shock Troopers 2nd Squad.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Shock Troopers 2nd Squad.json", inplace=True):
    
    # This will replace string "GameFolder/" with "shocktr2" in each line
    line = line.replace("GameFolder/", "shocktr2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Shock Troopers.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Shock Troopers.json", inplace=True):
    
    # This will replace string "GameFolder/" with "shocktro" in each line
    line = line.replace("GameFolder/", "shocktro")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Shock Troopers (set 2).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Shock Troopers (set 2).json", inplace=True):
    
    # This will replace string "GameFolder/" with "shcktroa" in each line
    line = line.replace("GameFolder/", "shcktroa")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Soccer Brawl.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Soccer Brawl.json", inplace=True):
    
    # This will replace string "GameFolder/" with "socbrawl" in each line
    line = line.replace("GameFolder/", "socbrawl")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Soccer Brawl (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Soccer Brawl (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "scbrawlh" in each line
    line = line.replace("GameFolder/", "scbrawlh")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Aero Fighters 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Aero Fighters 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sonicwi2" in each line
    line = line.replace("GameFolder/", "sonicwi2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Aero Fighters 3.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Aero Fighters 3.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sonicwi3" in each line
    line = line.replace("GameFolder/", "sonicwi3")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    

# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Spinmaster.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Spinmaster.json", inplace=True):
    
    # This will replace string "GameFolder/" with "spinmast" in each line
    line = line.replace("GameFolder/", "spinmast")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template3.json','r') as firstfile, open ('./Game.json/Super Sidekicks.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Super Sidekicks.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ssideki" in each line
    line = line.replace("GameFolder/", "ssideki")
    line = line.replace("0xCTOLINK", "0x00000001")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Super Sidekicks 2 The World Championship.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Super Sidekicks 2 The World Championship.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ssideki2" in each line
    line = line.replace("GameFolder/", "ssideki2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Super Sidekicks 3 The Next Glory.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Super Sidekicks 3 The Next Glory.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ssideki3" in each line
    line = line.replace("GameFolder/", "ssideki3")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Ultimate 11, The The SNK Football Championship.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Ultimate 11, The The SNK Football Championship.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ssideki4" in each line
    line = line.replace("GameFolder/", "ssideki4")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Stakes Winner.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Stakes Winner.json", inplace=True):
    
    # This will replace string "GameFolder/" with "stakwin" in each line
    line = line.replace("GameFolder/", "stakwin")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Stakes Winner 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Stakes Winner 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "stakwin2" in each line
    line = line.replace("GameFolder/", "stakwin2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Street Hoop.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Street Hoop.json", inplace=True):
    
    # This will replace string "GameFolder/" with "strhoop" in each line
    line = line.replace("GameFolder/", "strhoop")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Super Spy, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Super Spy, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "superspy" in each line
    line = line.replace("GameFolder/", "superspy")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00280000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Tetris.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Tetris.json", inplace=True):
    
    # This will replace string "GameFolder/" with "tetrismn" in each line
    line = line.replace("GameFolder/", "tetrismn")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template1.json','r') as firstfile, open ('./Game.json/SNK vs. Capcom.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/SNK vs. Capcom.json", inplace=True):
    
    # This will replace string "GameFolder/" with "svc" in each line
    line = line.replace("GameFolder/", "svc")
    line = line.replace("0xPVC-Cart", "0x00000001")
    line = line.replace("0xSMA-Cart", "0x00000000")
    line = line.replace("0xCMC-Chip", "0x00000002")
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/SNK vs. Capcom Plus.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/SNK vs. Capcom Plus.json", inplace=True):
    
    # This will replace string "GameFolder/" with "svcplus" in each line
    line = line.replace("GameFolder/", "svcplus")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Top Hunter.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Top Hunter.json", inplace=True):
    
    # This will replace string "GameFolder/" with "tophuntr" in each line
    line = line.replace("GameFolder/", "tophuntr")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Top Hunter (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Top Hunter (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "tphuntrh" in each line
    line = line.replace("GameFolder/", "tphuntrh")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Treasure of the Caribbean.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Treasure of the Caribbean.json", inplace=True):
    
    # This will replace string "GameFolder/" with "totc" in each line
    line = line.replace("GameFolder/", "totc")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template2.json','r') as firstfile, open ('./Game.json/Top Players Golf.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Top Players Golf.json", inplace=True):
    
    # This will replace string "GameFolder/" with "tpgolf" in each line
    line = line.replace("GameFolder/", "tpgolf")
    line = line.replace("0xPCM", "0xFFFFFFFF")
    line = line.replace("0xOFFSET", "0x00200000")
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Thrash Rally.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Thrash Rally.json", inplace=True):
    
    # This will replace string "GameFolder/" with "trally" in each line
    line = line.replace("GameFolder/", "trally")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Neo Turf Masters.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Neo Turf Masters.json", inplace=True):
    
    # This will replace string "GameFolder/" with "turfmast" in each line
    line = line.replace("GameFolder/", "turfmast")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    





# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Twinkle Star Sprites.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Twinkle Star Sprites.json", inplace=True):
    
    # This will replace string "GameFolder/" with "twinspri" in each line
    line = line.replace("GameFolder/", "twinspri")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Tecmo World Soccer 96.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Tecmo World Soccer 96.json", inplace=True):
    
    # This will replace string "GameFolder/" with "tws96" in each line
    line = line.replace("GameFolder/", "tws96")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
   




# open both files
with open('template.json','r') as firstfile, open ('./Game.json/Viewpoint.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Viewpoint.json", inplace=True):
    
    # This will replace string "GameFolder/" with "viewpoin" in each line
    line = line.replace("GameFolder/", "viewpoin")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Waku Waku 7.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Waku Waku 7.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wakuwak7" in each line
    line = line.replace("GameFolder/", "wakuwak7")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/World Heroes.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/World Heroes.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wh1" in each line
    line = line.replace("GameFolder/", "wh1")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/World Heroes (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/World Heroes (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "wh1h" in each line
    line = line.replace("GameFolder/", "wh1h")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/World Heroes (set 3).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/World Heroes (set 3).json", inplace=True):
    
    # This will replace string "GameFolder/" with "wh1ha" in each line
    line = line.replace("GameFolder/", "wh1ha")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/World Heroes 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/World Heroes 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wh2" in each line
    line = line.replace("GameFolder/", "wh2")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open ('./Game.json/World Heroes 2 Jet.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/World Heroes 2 Jet.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wh2j" in each line
    line = line.replace("GameFolder/", "wh2j")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/World Heroes Perfect.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/World Heroes Perfect.json", inplace=True):
    
    # This will replace string "GameFolder/" with "whp" in each line
    line = line.replace("GameFolder/", "whp")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Windjammers.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Windjammers.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wjammers" in each line
    line = line.replace("GameFolder/", "wjammers")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Windjammers Supersonic.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Windjammers Supersonic.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wjammss" in each line
    line = line.replace("GameFolder/", "wjammss")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Xeno Crisis.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Xeno Crisis.json", inplace=True):
    
    # This will replace string "GameFolder/" with "XenoCrisis" in each line
    line = line.replace("GameFolder/", "XenoCrisis")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Zed Blade.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Zed Blade.json", inplace=True):
    
    # This will replace string "GameFolder/" with "zedblade" in each line
    line = line.replace("GameFolder/", "zedblade")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open ('./Game.json/ZinTricK.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/ZinTricK.json", inplace=True):
    
    # This will replace string "GameFolder/" with "zintrckb" in each line
    line = line.replace("GameFolder/", "zintrckb")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
      
    




     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Zupapa!.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Zupapa!.json", inplace=True):
    
    # This will replace string "GameFolder/" with "zupapa" in each line
    line = line.replace("GameFolder/", "zupapa")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open ('./Game.json/Crouching Tiger Hidden Dragon.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("./Game.json/Crouching Tiger Hidden Dragon.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ct2k3sa" in each line
    line = line.replace("GameFolder/", "ct2k3sa")
    
    
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
print("Analogue Pocket Neogeo game.json files created successfully in " , dirName ,"folder")      
print("Script Created by Terminator2k2 - Enjoy")  
    
    
    
    

    
    
    


