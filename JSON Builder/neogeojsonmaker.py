# Python - Script By Terminator2k2 - Creates json files for NeoGeo Rom Set. This requires an up to date template.json in the same folder as this file.
# Big Thank You to Mazamars312 for porting/Fixes to the Superb Neogeo Core For Analogue Pocket.
# Big Thank You To all involved in creating this core for The MiSTer Project.


import sys
import fileinput

# open both files
with open('template.json','r') as firstfile, open('2020 Super Baseball.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("2020 Super Baseball.json", inplace=True):
    
    # This will replace string "GameFolder/" with "2020bb" in each line
    line = line.replace("GameFolder/", "2020bb")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
  # open both files
with open('template.json','r') as firstfile, open('2020 Super Baseball (set 2).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("2020 Super Baseball (set 2).json", inplace=True):
    
    # This will replace string "GameFolder/" with "2020bba" in each line
    line = line.replace("GameFolder/", "2020bba")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)



 # open both files
with open('template.json','r') as firstfile, open('2020 Super Baseball (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("2020 Super Baseball (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "2020bbh" in each line
    line = line.replace("GameFolder/", "2020bbh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('3 Count Bout.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("3 Count Bout.json", inplace=True):
    
    # This will replace string "GameFolder/" with "3countb" in each line
    line = line.replace("GameFolder/", "3countb")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
   




# open both files
with open('template.json','r') as firstfile, open('Alpha Mission II.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Alpha Mission II.json", inplace=True):
    
    # This will replace string "GameFolder/" with "alpham2" in each line
    line = line.replace("GameFolder/", "alpham2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Alpha Mission II Proto.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Alpha Mission II Proto.json", inplace=True):
    
    # This will replace string "GameFolder/" with "alpham2p" in each line
    line = line.replace("GameFolder/", "alpham2p")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Andro Dunos.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Andro Dunos.json", inplace=True):
    
    # This will replace string "GameFolder/" with "androdun" in each line
    line = line.replace("GameFolder/", "androdun")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Aggressors of Dark Kombat.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Aggressors of Dark Kombat.json", inplace=True):
    
    # This will replace string "GameFolder/" with "aodk" in each line
    line = line.replace("GameFolder/", "aodk")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Art of Fighting.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Art of Fighting.json", inplace=True):
    
    # This will replace string "GameFolder/" with "aof" in each line
    line = line.replace("GameFolder/", "aof")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Art of Fighting 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Art of Fighting 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "aof2" in each line
    line = line.replace("GameFolder/", "aof2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
        # open both files
with open('template.json','r') as firstfile, open('Art of Fighting 2 (NGH-056).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Art of Fighting 2 (NGH-056).json", inplace=True):
    
    # This will replace string "GameFolder/" with "aof2a" in each line
    line = line.replace("GameFolder/", "aof2a")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    




     # open both files
with open('template.json','r') as firstfile, open('Art of Fighting 3.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Art of Fighting 3.json", inplace=True):
    
    # This will replace string "GameFolder/" with "aof3" in each line
    line = line.replace("GameFolder/", "aof3")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
      # open both files
with open('template.json','r') as firstfile, open('Bang Bang Busters.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Bang Bang Busters.json", inplace=True):
    
    # This will replace string "GameFolder/" with "b2b" in each line
    line = line.replace("GameFolder/", "b2b")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Bakatonosama Mahjong Manyuuki.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Bakatonosama Mahjong Manyuuki.json", inplace=True):
    
    # This will replace string "GameFolder/" with "bakatono" in each line
    line = line.replace("GameFolder/", "bakatono")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Bang Bead.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Bang Bead.json", inplace=True):
    
    # This will replace string "GameFolder/" with "bangbead" in each line
    line = line.replace("GameFolder/", "bangbead")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Blues Journey.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Blues Journey.json", inplace=True):
    
    # This will replace string "GameFolder/" with "bjourney" in each line
    line = line.replace("GameFolder/", "bjourney")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Blazing Star.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Blazing Star.json", inplace=True):
    
    # This will replace string "GameFolder/" with "blazstar" in each line
    line = line.replace("GameFolder/", "blazstar")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Breakers.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Breakers.json", inplace=True):
    
    # This will replace string "GameFolder/" with "breakers" in each line
    line = line.replace("GameFolder/", "breakers")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Breakers Revenge.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Breakers Revenge.json", inplace=True):
    
    # This will replace string "GameFolder/" with "breakrev" in each line
    line = line.replace("GameFolder/", "breakrev")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Baseball Stars Professional.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Baseball Stars Professional.json", inplace=True):
    
    # This will replace string "GameFolder/" with "bstars" in each line
    line = line.replace("GameFolder/", "bstars")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Baseball Stars Professional (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Baseball Stars Professional (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "bstarsh" in each line
    line = line.replace("GameFolder/", "bstarsh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Baseball Stars 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Baseball Stars 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "bstars2" in each line
    line = line.replace("GameFolder/", "bstars2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Burning Fight.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Burning Fight.json", inplace=True):
    
    # This will replace string "GameFolder/" with "burningf" in each line
    line = line.replace("GameFolder/", "burningf")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Burning Fight (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Burning Fight (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "brningfh" in each line
    line = line.replace("GameFolder/", "brningfh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




     # open both files
with open('template.json','r') as firstfile, open('Burning Fight (prototype).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Burning Fight (prototype).json", inplace=True):
    
    # This will replace string "GameFolder/" with "brnngfpa" in each line
    line = line.replace("GameFolder/", "brnngfpa")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)  




        # open both files
with open('template.json','r') as firstfile, open('Burning Fight (prototype older).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Burning Fight (prototype older).json", inplace=True):
    
    # This will replace string "GameFolder/" with "brningfp" in each line
    line = line.replace("GameFolder/", "brningfp")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line) 
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Columns.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Columns.json", inplace=True):
    
    # This will replace string "GameFolder/" with "columnsn" in each line
    line = line.replace("GameFolder/", "columnsn")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Crossed Swords 2 (CD conversion).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Crossed Swords 2 (CD conversion).json", inplace=True):
    
    # This will replace string "GameFolder/" with "crswd2bl" in each line
    line = line.replace("GameFolder/", "crswd2bl")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    





# open both files
with open('template.json','r') as firstfile, open('Crossed Swords.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Crossed Swords.json", inplace=True):
    
    # This will replace string "GameFolder/" with "crsword" in each line
    line = line.replace("GameFolder/", "crsword")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Captain Tomaday.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Captain Tomaday.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ctomaday" in each line
    line = line.replace("GameFolder/", "ctomaday")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Cyber-Lip.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Cyber-Lip.json", inplace=True):
    
    # This will replace string "GameFolder/" with "cyberlip" in each line
    line = line.replace("GameFolder/", "cyberlip")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Digger Man.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Digger Man.json", inplace=True):
    
    # This will replace string "GameFolder/" with "diggerma" in each line
    line = line.replace("GameFolder/", "diggerma")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Double Dragon.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Double Dragon.json", inplace=True):
    
    # This will replace string "GameFolder/" with "doubledr" in each line
    line = line.replace("GameFolder/", "doubledr")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Dragons Heaven.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Dragons Heaven.json", inplace=True):
    
    # This will replace string "GameFolder/" with "dragonsh" in each line
    line = line.replace("GameFolder/", "dragonsh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Eight Man.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Eight Man.json", inplace=True):
    
    # This will replace string "GameFolder/" with "eightman" in each line
    line = line.replace("GameFolder/", "eightman")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Fatal Fury Special.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Fatal Fury Special.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fatfursp" in each line
    line = line.replace("GameFolder/", "fatfursp")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Fatal Fury Special (NGM-058 ~ NGH-058, set 2).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Fatal Fury Special (NGM-058 ~ NGH-058, set 2).json", inplace=True):
    
    # This will replace string "GameFolder/" with "ftfurspa" in each line
    line = line.replace("GameFolder/", "ftfurspa")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Fatal Fury.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Fatal Fury.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fatfury1" in each line
    line = line.replace("GameFolder/", "fatfury1")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Fatal Fury 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Fatal Fury 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fatfury2" in each line
    line = line.replace("GameFolder/", "fatfury2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Fatal Fury 3.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Fatal Fury 3.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fatfury3" in each line
    line = line.replace("GameFolder/", "fatfury3")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Football Frenzy.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Football Frenzy.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fbfrenzy" in each line
    line = line.replace("GameFolder/", "fbfrenzy")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('Fight Fever.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Fight Fever.json", inplace=True):
    
    # This will replace string "GameFolder/" with "fightfev" in each line
    line = line.replace("GameFolder/", "fightfev")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Fight Fever (set 2).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Fight Fever (set 2).json", inplace=True):
    
    # This will replace string "GameFolder/" with "fghtfeva" in each line
    line = line.replace("GameFolder/", "fghtfeva")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Battle Flip Shot.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Battle Flip Shot.json", inplace=True):
    
    # This will replace string "GameFolder/" with "flipshot" in each line
    line = line.replace("GameFolder/", "flipshot")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Frog Feast.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Frog Feast.json", inplace=True):
    
    # This will replace string "GameFolder/" with "frogfest" in each line
    line = line.replace("GameFolder/", "frogfest")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Idol Mahjong Final Romance 2 (CD conversion).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Idol Mahjong Final Romance 2 (CD conversion).json", inplace=True):
    
    # This will replace string "GameFolder/" with "froman2b" in each line
    line = line.replace("GameFolder/", "froman2b")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Fighters Swords (Korean release of Samurai Shodown III).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Fighters Swords (Korean release of Samurai Shodown III).json", inplace=True):
    
    # This will replace string "GameFolder/" with "fswords" in each line
    line = line.replace("GameFolder/", "fswords")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Galaxy Fight Universal Warriors.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Galaxy Fight Universal Warriors.json", inplace=True):
    
    # This will replace string "GameFolder/" with "galaxyfg" in each line
    line = line.replace("GameFolder/", "galaxyfg")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # Python - Modifying a file using fileinput and sys module




# open both files
with open('template.json','r') as firstfile, open('Ganryu.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ganryu.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ganryu" in each line
    line = line.replace("GameFolder/", "ganryu")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Garou - Mark of the Wolves (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Garou - Mark of the Wolves (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "garoubl" in each line
    line = line.replace("GameFolder/", "garoubl")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Garou - Mark of the Wolves.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Garou - Mark of the Wolves.json", inplace=True):
    
    # This will replace string "GameFolder/" with "garou" in each line
    line = line.replace("GameFolder/", "garou")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open('Garou - Mark of the Wolves (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Garou - Mark of the Wolves (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "garouh" in each line
    line = line.replace("GameFolder/", "garouh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





    # open both files
with open('template.json','r') as firstfile, open('Garou - Mark of the Wolves (prototype).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Garou - Mark of the Wolves (prototype).json", inplace=True):
    
    # This will replace string "GameFolder/" with "garoup" in each line
    line = line.replace("GameFolder/", "garoup")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
   




# open both files
with open('template.json','r') as firstfile, open('Ghostlop.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ghostlop.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ghostlop" in each line
    line = line.replace("GameFolder/", "ghostlop")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Goal! Goal! Goal!.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Goal! Goal! Goal!.json", inplace=True):
    
    # This will replace string "GameFolder/" with "goalx3" in each line
    line = line.replace("GameFolder/", "goalx3")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Voltage Fighter Gowcaizer.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Voltage Fighter Gowcaizer.json", inplace=True):
    
    # This will replace string "GameFolder/" with "gowcaizr" in each line
    line = line.replace("GameFolder/", "gowcaizr")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Ghost Pilots.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ghost Pilots.json", inplace=True):
    
    # This will replace string "GameFolder/" with "gpilots" in each line
    line = line.replace("GameFolder/", "gpilots")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Ghost Pilots (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ghost Pilots (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "gpilotsh" in each line
    line = line.replace("GameFolder/", "gpilotsh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Gururin.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Gururin.json", inplace=True):
    
    # This will replace string "GameFolder/" with "gururin" in each line
    line = line.replace("GameFolder/", "gururin")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Hyprnoid.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Hyprnoid.json", inplace=True):
    
    # This will replace string "GameFolder/" with "hyprnoid" in each line
    line = line.replace("GameFolder/", "hyprnoid")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('Ironclad.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ironclad.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ironclad" in each line
    line = line.replace("GameFolder/", "ironclad")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Ironclad (prototype, bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ironclad (prototype, bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "irnclado" in each line
    line = line.replace("GameFolder/", "irnclado")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Irritating Maze.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Irritating Maze.json", inplace=True):
    
    # This will replace string "GameFolder/" with "irrmaze" in each line
    line = line.replace("GameFolder/", "irrmaze")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Janshin Densetsu Quest of Jongmaster.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Janshin Densetsu Quest of Jongmaster.json", inplace=True):
    
    # This will replace string "GameFolder/" with "janshin" in each line
    line = line.replace("GameFolder/", "janshin")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Puzzled.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Puzzled.json", inplace=True):
    
    # This will replace string "GameFolder/" with "joyjoy" in each line
    line = line.replace("GameFolder/", "joyjoy")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # Python - Modifying a file using fileinput and sys module




# open both files
with open('template.json','r') as firstfile, open('Far East of Eden Kabuki Klash.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Far East of Eden Kabuki Klash.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kabukikl" in each line
    line = line.replace("GameFolder/", "kabukikl")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Karnovs Revenge.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Karnovs Revenge.json", inplace=True):
    
    # This will replace string "GameFolder/" with "karnovr" in each line
    line = line.replace("GameFolder/", "karnovr")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Kizuna Encounter Super Tag Battle.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Kizuna Encounter Super Tag Battle.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kizuna" in each line
    line = line.replace("GameFolder/", "kizuna")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 2002 Magic Plus II, The (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 2002 Magic Plus II, The (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kf2k2mp2" in each line
    line = line.replace("GameFolder/", "kf2k2mp2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 2002 Magic Plus, The (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 2002 Magic Plus, The (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kf2k2mp" in each line
    line = line.replace("GameFolder/", "kf2k2mp")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    

    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 2000.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 2000.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2000" in each line
    line = line.replace("GameFolder/", "kof2000")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 2001, The (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 2001, The (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2001h" in each line
    line = line.replace("GameFolder/", "kof2001h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 2001, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 2001, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2001" in each line
    line = line.replace("GameFolder/", "kof2001")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


# open both files
with open('template.json','r') as firstfile, open('King of Fighters 2002, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 2002, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2002" in each line
    line = line.replace("GameFolder/", "kof2002")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 2003, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 2003, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2003" in each line
    line = line.replace("GameFolder/", "kof2003")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('King of Fighters Special Edition 2004, The (The King of Fighters 2002 bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters Special Edition 2004, The (The King of Fighters 2002 bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof2k4se" in each line
    line = line.replace("GameFolder/", "kof2k4se")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 10th Anniversary Extra Plus, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 10th Anniversary Extra Plus, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kf10thep" in each line
    line = line.replace("GameFolder/", "kf10thep")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 94, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 94, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof94" in each line
    line = line.replace("GameFolder/", "kof94")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 95, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 95, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof95" in each line
    line = line.replace("GameFolder/", "kof95")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 95, The (NGM-084, alt board).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 95, The (NGM-084, alt board).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof95a" in each line
    line = line.replace("GameFolder/", "kof95a")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 95, The (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 95, The (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof95h" in each line
    line = line.replace("GameFolder/", "kof95h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 96, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 96, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof96" in each line
    line = line.replace("GameFolder/", "kof96")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 96, The (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 96, The (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof96h" in each line
    line = line.replace("GameFolder/", "kof96h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    


     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 97, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 97, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof97" in each line
    line = line.replace("GameFolder/", "kof97")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 97, The (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 97, The (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof97h" in each line
    line = line.replace("GameFolder/", "kof97h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 97, The (Korean release).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 97, The (Korean release).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof97k" in each line
    line = line.replace("GameFolder/", "kof97k")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 97, The Chongchu Jianghu Plus 2003.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 97, The Chongchu Jianghu Plus 2003.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof97oro" in each line
    line = line.replace("GameFolder/", "kof97oro")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 97 Plus, The (Bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 97 Plus, The (Bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof97pls" in each line
    line = line.replace("GameFolder/", "kof97pls")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 98, The - The Slugfest (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 98, The - The Slugfest (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof98h" in each line
    line = line.replace("GameFolder/", "kof98h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 98, The - The Slugfest (NGM-2420, alt board).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 98, The - The Slugfest (NGM-2420, alt board).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof98a" in each line
    line = line.replace("GameFolder/", "kof98a")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 98, The - The Slugfest.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 98, The - The Slugfest.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof98" in each line
    line = line.replace("GameFolder/", "kof98")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open('King of Fighters 98, The - The Slugfest (Korean release).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 98, The - The Slugfest (Korean release).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof98k" in each line
    line = line.replace("GameFolder/", "kof98k")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 99, The Millennium Battle (prototype).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 99, The Millennium Battle (prototype).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof99p" in each line
    line = line.replace("GameFolder/", "kof99p")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 99, The Millennium Battle.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 99, The Millennium Battle.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof99" in each line
    line = line.replace("GameFolder/", "kof99")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




     # open both files
with open('template.json','r') as firstfile, open('King of Fighters 99, The Millennium Battle (earlier release).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Fighters 99, The Millennium Battle (earlier release).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kof99e" in each line
    line = line.replace("GameFolder/", "kof99e")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of Gladiators.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of Gladiators.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kog" in each line
    line = line.replace("GameFolder/", "kog")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of the Monsters.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of the Monsters.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kotm" in each line
    line = line.replace("GameFolder/", "kotm")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of the Monsters (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of the Monsters (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kotmh" in each line
    line = line.replace("GameFolder/", "kotmh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('King of the Monsters 2 The Next Thing.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of the Monsters 2 The Next Thing.json", inplace=True):
    
    # This will replace string "GameFolder/" with "kotm2" in each line
    line = line.replace("GameFolder/", "kotm2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





     # open both files
with open('template.json','r') as firstfile, open('King of the Monsters 2 The Next Thing (prototype).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("King of the Monsters 2 The Next Thing (prototype).json", inplace=True):
    
    # This will replace string "GameFolder/" with "kotm2p" in each line
    line = line.replace("GameFolder/", "kotm2p")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    


# open both files
with open('template.json','r') as firstfile, open('Lansquenet 2004 (Shock Troopers 2nd Squad Bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Lansquenet 2004 (Shock Troopers 2nd Squad Bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "lans2004" in each line
    line = line.replace("GameFolder/", "lans2004")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Last Blade, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Last Blade, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lastblad" in each line
    line = line.replace("GameFolder/", "lastblad")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Last Blade, The (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Last Blade, The (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "lstbladh" in each line
    line = line.replace("GameFolder/", "lstbladh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
        
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Last Blade 2, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Last Blade 2, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lastbld2" in each line
    line = line.replace("GameFolder/", "lastbld2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Last Hope.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Last Hope.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lasthope" in each line
    line = line.replace("GameFolder/", "lasthope")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Last Soldier, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Last Soldier, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lastsold" in each line
    line = line.replace("GameFolder/", "lastsold")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('League Bowling.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("League Bowling.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lbowling" in each line
    line = line.replace("GameFolder/", "lbowling")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Legend of Success Joe.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Legend of Success Joe.json", inplace=True):
    
    # This will replace string "GameFolder/" with "legendos" in each line
    line = line.replace("GameFolder/", "legendos")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Last Resort.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Last Resort.json", inplace=True):
    
    # This will replace string "GameFolder/" with "lresort" in each line
    line = line.replace("GameFolder/", "lresort")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





       # open both files
with open('template.json','r') as firstfile, open('Last Resort (prototype).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Last Resort (prototype).json", inplace=True):
    
    # This will replace string "GameFolder/" with "lresortp" in each line
    line = line.replace("GameFolder/", "lresortp")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line) 
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Magical Drop II.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Magical Drop II.json", inplace=True):
    
    # This will replace string "GameFolder/" with "magdrop2" in each line
    line = line.replace("GameFolder/", "magdrop2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Magical Drop III.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Magical Drop III.json", inplace=True):
    
    # This will replace string "GameFolder/" with "magdrop3" in each line
    line = line.replace("GameFolder/", "magdrop3")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Magician Lord.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Magician Lord.json", inplace=True):
    
    # This will replace string "GameFolder/" with "maglord" in each line
    line = line.replace("GameFolder/", "maglord")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Magician Lord (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Magician Lord (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "maglordh" in each line
    line = line.replace("GameFolder/", "maglordh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)  





       # open both files
with open('template.json','r') as firstfile, open('Neo Black Tiger.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Neo Black Tiger.json", inplace=True):
    
    # This will replace string "GameFolder/" with "nblktigr" in each line
    line = line.replace("GameFolder/", "nblktigr")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line) 
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Mahjong Kyo Retsuden.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Mahjong Kyo Retsuden.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mahretsu" in each line
    line = line.replace("GameFolder/", "mahretsu")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Chibi Marukochan Deluxe Quiz.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Chibi Marukochan Deluxe Quiz.json", inplace=True):
    
    # This will replace string "GameFolder/" with "marukodq" in each line
    line = line.replace("GameFolder/", "marukodq")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Power Instinct Matrimelee.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Power Instinct Matrimelee.json", inplace=True):
    
    # This will replace string "GameFolder/" with "matrim" in each line
    line = line.replace("GameFolder/", "matrim")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Money Puzzle Exchanger.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Money Puzzle Exchanger.json", inplace=True):
    
    # This will replace string "GameFolder/" with "miexchng" in each line
    line = line.replace("GameFolder/", "miexchng")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Minasan no Okagesamadesu! Dai Sugoroku Taikai.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Minasan no Okagesamadesu! Dai Sugoroku Taikai.json", inplace=True):
    
    # This will replace string "GameFolder/" with "minasan" in each line
    line = line.replace("GameFolder/", "minasan")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Monitor Test ROM.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Monitor Test ROM.json", inplace=True):
    
    # This will replace string "GameFolder/" with "MonitorTest" in each line
    line = line.replace("GameFolder/", "MonitorTest")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Shougi no Tatsujin - Master of Syougi.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Shougi no Tatsujin - Master of Syougi.json", inplace=True):
    
    # This will replace string "GameFolder/" with "moshougi" in each line
    line = line.replace("GameFolder/", "moshougi")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Metal Slug.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug" in each line
    line = line.replace("GameFolder/", "mslug")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Metal Slug 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug2" in each line
    line = line.replace("GameFolder/", "mslug2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Metal Slug 2 Turbo.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug 2 Turbo.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug2t" in each line
    line = line.replace("GameFolder/", "mslug2t")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('Metal Slug 3.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug 3.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug3" in each line
    line = line.replace("GameFolder/", "mslug3")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Metal Slug 3 (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug 3 (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug3h" in each line
    line = line.replace("GameFolder/", "mslug3h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Metal Slug 4.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug 4.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug4" in each line
    line = line.replace("GameFolder/", "mslug4")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Metal Slug 4 (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug 4 (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug4h" in each line
    line = line.replace("GameFolder/", "mslug4h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Metal Slug 4 Plus.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug 4 Plus.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ms4plus" in each line
    line = line.replace("GameFolder/", "ms4plus")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Metal Slug 5.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug 5.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug5" in each line
    line = line.replace("GameFolder/", "mslug5")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Metal Slug 5 (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug 5 (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug5h" in each line
    line = line.replace("GameFolder/", "mslug5h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Metal Slug 6.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug 6.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslug6" in each line
    line = line.replace("GameFolder/", "mslug6")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Metal Slug X.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Metal Slug X.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mslugx" in each line
    line = line.replace("GameFolder/", "mslugx")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Mutation Nation.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Mutation Nation.json", inplace=True):
    
    # This will replace string "GameFolder/" with "mutnat" in each line
    line = line.replace("GameFolder/", "mutnat")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('NAM-1975.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("NAM-1975.json", inplace=True):
    
    # This will replace string "GameFolder/" with "nam1975" in each line
    line = line.replace("GameFolder/", "nam1975")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Ninja Combat.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ninja Combat.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ncombat" in each line
    line = line.replace("GameFolder/", "ncombat")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Ninja Combat (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ninja Combat (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "ncombath" in each line
    line = line.replace("GameFolder/", "ncombath")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Ninja Commando.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ninja Commando.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ncommand" in each line
    line = line.replace("GameFolder/", "ncommand")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Neo Bomberman.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Neo Bomberman.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neobombe" in each line
    line = line.replace("GameFolder/", "neobombe")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Neo-Geo Cup 98 The Road to the Victory.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Neo-Geo Cup 98 The Road to the Victory.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neocup98" in each line
    line = line.replace("GameFolder/", "neocup98")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Neo Drift Out New Technology.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Neo Drift Out New Technology.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neodrift" in each line
    line = line.replace("GameFolder/", "neodrift")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Neo Fight.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Neo Fight.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neofight" in each line
    line = line.replace("GameFolder/", "neofight")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Neo Mr Do.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Neo Mr Do.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neomrdo" in each line
    line = line.replace("GameFolder/", "neomrdo")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Neo Thunder.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Neo Thunder.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neothund" in each line
    line = line.replace("GameFolder/", "neothund")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    



# open both files
with open('template.json','r') as firstfile, open('NeoTRIS.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("NeoTRIS.json", inplace=True):
    
    # This will replace string "GameFolder/" with "neotris" in each line
    line = line.replace("GameFolder/", "neotris")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Ninja Masters.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ninja Masters.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ninjamas" in each line
    line = line.replace("GameFolder/", "ninjamas")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('Nightmare in the Dark.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Nightmare in the Dark.json", inplace=True):
    
    # This will replace string "GameFolder/" with "nitd" in each line
    line = line.replace("GameFolder/", "nitd")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
      # open both files
with open('template.json','r') as firstfile, open('Nightmare in the Dark (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Nightmare in the Dark (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "nitdbl" in each line
    line = line.replace("GameFolder/", "nitdbl")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('OverTop.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("OverTop.json", inplace=True):
    
    # This will replace string "GameFolder/" with "overtop" in each line
    line = line.replace("GameFolder/", "overtop")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Panic Bomber.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Panic Bomber.json", inplace=True):
    
    # This will replace string "GameFolder/" with "panicbom" in each line
    line = line.replace("GameFolder/", "panicbom")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Puzzle Bobble 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Puzzle Bobble 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pbobbl2n" in each line
    line = line.replace("GameFolder/", "pbobbl2n")

    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('Puzzle Bobble.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Puzzle Bobble.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pbobblen" in each line
    line = line.replace("GameFolder/", "pbobblen")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





        # open both files
with open('template.json','r') as firstfile, open('Puzzle Bobble (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Puzzle Bobble (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "pbbblenb" in each line
    line = line.replace("GameFolder/", "pbbblenb")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line) 
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Pleasure Goal.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Pleasure Goal.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pgoal" in each line
    line = line.replace("GameFolder/", "pgoal")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Pochi and Nyaa.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Pochi and Nyaa.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pnyaa" in each line
    line = line.replace("GameFolder/", "pnyaa")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Pop n Bounce.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Pop n Bounce.json", inplace=True):
    
    # This will replace string "GameFolder/" with "popbounc" in each line
    line = line.replace("GameFolder/", "popbounc")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Prehistoric Isle 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Prehistoric Isle 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "preisle2" in each line
    line = line.replace("GameFolder/", "preisle2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Power Spikes II.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Power Spikes II.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pspikes2" in each line
    line = line.replace("GameFolder/", "pspikes2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    





# open both files
with open('template.json','r') as firstfile, open('Pulstar.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Pulstar.json", inplace=True):
    
    # This will replace string "GameFolder/" with "pulstar" in each line
    line = line.replace("GameFolder/", "pulstar")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Puzzle De Pon! R!.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Puzzle De Pon! R!.json", inplace=True):
    
    # This will replace string "GameFolder/" with "puzzldpr" in each line
    line = line.replace("GameFolder/", "puzzldpr")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Puzzle De Pon!.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Puzzle De Pon!.json", inplace=True):
    
    # This will replace string "GameFolder/" with "puzzledp" in each line
    line = line.replace("GameFolder/", "puzzledp")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Quiz Meitantei.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Quiz Meitantei.json", inplace=True):
    
    # This will replace string "GameFolder/" with "quizdai2" in each line
    line = line.replace("GameFolder/", "quizdai2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Quiz Daisousa Sen The Last Count Down.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Quiz Daisousa Sen The Last Count Down.json", inplace=True):
    
    # This will replace string "GameFolder/" with "quizdais" in each line
    line = line.replace("GameFolder/", "quizdais")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Quiz Salibtamjeong The Last Count Down (Korean localized Quiz Daisousa Sen).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Quiz Salibtamjeong The Last Count Down (Korean localized Quiz Daisousa Sen).json", inplace=True):
    
    # This will replace string "GameFolder/" with "quizdask" in each line
    line = line.replace("GameFolder/", "quizdask")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Quiz King of Fighters.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Quiz King of Fighters.json", inplace=True):
    
    # This will replace string "GameFolder/" with "quizkof" in each line
    line = line.replace("GameFolder/", "quizkof")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Quiz King of Fighters (Korean release).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Quiz King of Fighters (Korean release).json", inplace=True):
    
    # This will replace string "GameFolder/" with "quizkofk" in each line
    line = line.replace("GameFolder/", "quizkofk")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Ragnagard.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ragnagard.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ragnagrd" in each line
    line = line.replace("GameFolder/", "ragnagrd")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Real Bout Fatal Fury.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Real Bout Fatal Fury.json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbff1" in each line
    line = line.replace("GameFolder/", "rbff1")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Real Bout Fatal Fury (bug fix revision).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Real Bout Fatal Fury (bug fix revision).json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbff1a" in each line
    line = line.replace("GameFolder/", "rbff1a")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('Real Bout Fatal Fury 2 The Newcomers.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Real Bout Fatal Fury 2 The Newcomers.json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbff2" in each line
    line = line.replace("GameFolder/", "rbff2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Real Bout Fatal Fury 2 The Newcomers (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Real Bout Fatal Fury 2 The Newcomers (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbff2h" in each line
    line = line.replace("GameFolder/", "rbff2h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   





     # open both files
with open('template.json','r') as firstfile, open('Real Bout Fatal Fury 2 The Newcomers (Korean release).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Real Bout Fatal Fury 2 The Newcomers (Korean release).json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbff2k" in each line
    line = line.replace("GameFolder/", "rbff2k")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Real Bout Fatal Fury Special.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Real Bout Fatal Fury Special.json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbffspec" in each line
    line = line.replace("GameFolder/", "rbffspec")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Real Bout Fatal Fury Special (Korean release).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Real Bout Fatal Fury Special (Korean release).json", inplace=True):
    
    # This will replace string "GameFolder/" with "rbffspck" in each line
    line = line.replace("GameFolder/", "rbffspck")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Riding Hero.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Riding Hero.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ridhero" in each line
    line = line.replace("GameFolder/", "ridhero")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Riding Hero (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Riding Hero (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "ridheroh" in each line
    line = line.replace("GameFolder/", "ridheroh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Robo Army.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Robo Army.json", inplace=True):
    
    # This will replace string "GameFolder/" with "roboarmy" in each line
    line = line.replace("GameFolder/", "roboarmy")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Robo Army (NGM-032 ~ NGH-032).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Robo Army (NGM-032 ~ NGH-032).json", inplace=True):
    
    # This will replace string "GameFolder/" with "roboarma" in each line
    line = line.replace("GameFolder/", "roboarma")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)  
    
    
    





     # open both files
with open('template.json','r') as firstfile, open('Rage of the Dragons.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Rage of the Dragons.json", inplace=True):
    
    # This will replace string "GameFolder/" with "rotd" in each line
    line = line.replace("GameFolder/", "rotd")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
      # open both files
with open('template.json','r') as firstfile, open('Rage of the Dragons (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Rage of the Dragons (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "rotdh" in each line
    line = line.replace("GameFolder/", "rotdh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Strikers 1945 Plus.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Strikers 1945 Plus.json", inplace=True):
    
    # This will replace string "GameFolder/" with "s1945p" in each line
    line = line.replace("GameFolder/", "s1945p")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    



    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho" in each line
    line = line.replace("GameFolder/", "samsho")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samshoh" in each line
    line = line.replace("GameFolder/", "samshoh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown II.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown II.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho2" in each line
    line = line.replace("GameFolder/", "samsho2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Saulabi Spirits (Korean release of Samurai Shodown II).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Saulabi Spirits (Korean release of Samurai Shodown II).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho2k" in each line
    line = line.replace("GameFolder/", "samsho2k")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open('Saulabi Spirits (Korean release of Samurai Shodown II, set 2).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Saulabi Spirits (Korean release of Samurai Shodown II, set 2).json", inplace=True):
    
    # This will replace string "GameFolder/" with "smsho2k2" in each line
    line = line.replace("GameFolder/", "smsho2k2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown III.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown III.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho3" in each line
    line = line.replace("GameFolder/", "samsho3")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown III (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown III (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho3h" in each line
    line = line.replace("GameFolder/", "samsho3h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown IV Amakusas Revenge.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown IV Amakusas Revenge.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho4" in each line
    line = line.replace("GameFolder/", "samsho4")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Pae Wang Jeon Seol - Legend of a Warrior.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Pae Wang Jeon Seol - Legend of a Warrior.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho4k" in each line
    line = line.replace("GameFolder/", "samsho4k")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)  





    # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown V Special.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown V Special.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsh5sp" in each line
    line = line.replace("GameFolder/", "samsh5sp")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)  




     # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown V Special (2nd release, less censored).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown V Special (2nd release, less censored).json", inplace=True):
    
    # This will replace string "GameFolder/" with "smsh5sph" in each line
    line = line.replace("GameFolder/", "smsh5sph")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown V Special (1st release, censored).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown V Special (1st release, censored).json", inplace=True):
    
    # This will replace string "GameFolder/" with "smsh5spo" in each line
    line = line.replace("GameFolder/", "smsh5spo")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown V.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown V.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho5" in each line
    line = line.replace("GameFolder/", "samsho5")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)




    # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown V (bootleg).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown V (bootleg).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho5b" in each line
    line = line.replace("GameFolder/", "samsho5b")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown V (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown V (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho5h" in each line
    line = line.replace("GameFolder/", "samsho5h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
      # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown V (XBOX version hack).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown V (XBOX version hack).json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsho5x" in each line
    line = line.replace("GameFolder/", "samsho5x")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown V Special Final Edition.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown V Special Final Edition.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsh5fe" in each line
    line = line.replace("GameFolder/", "samsh5fe")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Samurai Shodown V Perfect.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Samurai Shodown V Perfect.json", inplace=True):
    
    # This will replace string "GameFolder/" with "samsh5pf" in each line
    line = line.replace("GameFolder/", "samsh5pf")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
 
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Savage Reign.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Savage Reign.json", inplace=True):
    
    # This will replace string "GameFolder/" with "savagere" in each line
    line = line.replace("GameFolder/", "savagere")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Super Bubble Pop.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Super Bubble Pop.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sbp" in each line
    line = line.replace("GameFolder/", "sbp")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Super Dodge Ball.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Super Dodge Ball.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sdodgeb" in each line
    line = line.replace("GameFolder/", "sdodgeb")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('Sengoku.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Sengoku.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sengoku" in each line
    line = line.replace("GameFolder/", "sengoku")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Sengoku (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Sengoku (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "sengokuh" in each line
    line = line.replace("GameFolder/", "sengokuh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Sengoku 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Sengoku 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sengoku2" in each line
    line = line.replace("GameFolder/", "sengoku2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Sengoku 3.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Sengoku 3.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sengoku3" in each line
    line = line.replace("GameFolder/", "sengoku3")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Shock Troopers 2nd Squad.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Shock Troopers 2nd Squad.json", inplace=True):
    
    # This will replace string "GameFolder/" with "shocktr2" in each line
    line = line.replace("GameFolder/", "shocktr2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Shock Troopers.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Shock Troopers.json", inplace=True):
    
    # This will replace string "GameFolder/" with "shocktro" in each line
    line = line.replace("GameFolder/", "shocktro")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Shock Troopers (set 2).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Shock Troopers (set 2).json", inplace=True):
    
    # This will replace string "GameFolder/" with "shcktroa" in each line
    line = line.replace("GameFolder/", "shcktroa")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Soccer Brawl.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Soccer Brawl.json", inplace=True):
    
    # This will replace string "GameFolder/" with "socbrawl" in each line
    line = line.replace("GameFolder/", "socbrawl")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Soccer Brawl (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Soccer Brawl (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "scbrawlh" in each line
    line = line.replace("GameFolder/", "scbrawlh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Aero Fighters 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Aero Fighters 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sonicwi2" in each line
    line = line.replace("GameFolder/", "sonicwi2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Aero Fighters 3.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Aero Fighters 3.json", inplace=True):
    
    # This will replace string "GameFolder/" with "sonicwi3" in each line
    line = line.replace("GameFolder/", "sonicwi3")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    

# open both files
with open('template.json','r') as firstfile, open('Spinmaster.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Spinmaster.json", inplace=True):
    
    # This will replace string "GameFolder/" with "spinmast" in each line
    line = line.replace("GameFolder/", "spinmast")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Super Sidekicks.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Super Sidekicks.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ssideki" in each line
    line = line.replace("GameFolder/", "ssideki")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Super Sidekicks 2 The World Championship.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Super Sidekicks 2 The World Championship.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ssideki2" in each line
    line = line.replace("GameFolder/", "ssideki2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Super Sidekicks 3 The Next Glory.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Super Sidekicks 3 The Next Glory.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ssideki3" in each line
    line = line.replace("GameFolder/", "ssideki3")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    


# open both files
with open('template.json','r') as firstfile, open('Ultimate 11, The The SNK Football Championship.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Ultimate 11, The The SNK Football Championship.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ssideki4" in each line
    line = line.replace("GameFolder/", "ssideki4")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Stakes Winner.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Stakes Winner.json", inplace=True):
    
    # This will replace string "GameFolder/" with "stakwin" in each line
    line = line.replace("GameFolder/", "stakwin")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Stakes Winner 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Stakes Winner 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "stakwin2" in each line
    line = line.replace("GameFolder/", "stakwin2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Street Hoop.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Street Hoop.json", inplace=True):
    
    # This will replace string "GameFolder/" with "strhoop" in each line
    line = line.replace("GameFolder/", "strhoop")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Super Spy, The.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Super Spy, The.json", inplace=True):
    
    # This will replace string "GameFolder/" with "superspy" in each line
    line = line.replace("GameFolder/", "superspy")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Tetris.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Tetris.json", inplace=True):
    
    # This will replace string "GameFolder/" with "tetrismn" in each line
    line = line.replace("GameFolder/", "tetrismn")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('SNK vs. Capcom.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("SNK vs. Capcom.json", inplace=True):
    
    # This will replace string "GameFolder/" with "svc" in each line
    line = line.replace("GameFolder/", "svc")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('SNK vs. Capcom Plus.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("SNK vs. Capcom Plus.json", inplace=True):
    
    # This will replace string "GameFolder/" with "svcplus" in each line
    line = line.replace("GameFolder/", "svcplus")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Top Hunter.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Top Hunter.json", inplace=True):
    
    # This will replace string "GameFolder/" with "tophuntr" in each line
    line = line.replace("GameFolder/", "tophuntr")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Top Hunter (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Top Hunter (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "tphuntrh" in each line
    line = line.replace("GameFolder/", "tphuntrh")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    


# open both files
with open('template.json','r') as firstfile, open('Treasure of the Caribbean.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Treasure of the Caribbean.json", inplace=True):
    
    # This will replace string "GameFolder/" with "totc" in each line
    line = line.replace("GameFolder/", "totc")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Top Players Golf.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Top Players Golf.json", inplace=True):
    
    # This will replace string "GameFolder/" with "tpgolf" in each line
    line = line.replace("GameFolder/", "tpgolf")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Thrash Rally.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Thrash Rally.json", inplace=True):
    
    # This will replace string "GameFolder/" with "trally" in each line
    line = line.replace("GameFolder/", "trally")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Neo Turf Masters.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Neo Turf Masters.json", inplace=True):
    
    # This will replace string "GameFolder/" with "turfmast" in each line
    line = line.replace("GameFolder/", "turfmast")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    





# open both files
with open('template.json','r') as firstfile, open('Twinkle Star Sprites.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Twinkle Star Sprites.json", inplace=True):
    
    # This will replace string "GameFolder/" with "twinspri" in each line
    line = line.replace("GameFolder/", "twinspri")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Tecmo World Soccer 96.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Tecmo World Soccer 96.json", inplace=True):
    
    # This will replace string "GameFolder/" with "tws96" in each line
    line = line.replace("GameFolder/", "tws96")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
   




# open both files
with open('template.json','r') as firstfile, open('Viewpoint.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Viewpoint.json", inplace=True):
    
    # This will replace string "GameFolder/" with "viewpoin" in each line
    line = line.replace("GameFolder/", "viewpoin")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Waku Waku 7.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Waku Waku 7.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wakuwak7" in each line
    line = line.replace("GameFolder/", "wakuwak7")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('World Heroes.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("World Heroes.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wh1" in each line
    line = line.replace("GameFolder/", "wh1")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('World Heroes (AES).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("World Heroes (AES).json", inplace=True):
    
    # This will replace string "GameFolder/" with "wh1h" in each line
    line = line.replace("GameFolder/", "wh1h")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)





    # open both files
with open('template.json','r') as firstfile, open('World Heroes (set 3).json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("World Heroes (set 3).json", inplace=True):
    
    # This will replace string "GameFolder/" with "wh1ha" in each line
    line = line.replace("GameFolder/", "wh1ha")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)   
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('World Heroes 2.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("World Heroes 2.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wh2" in each line
    line = line.replace("GameFolder/", "wh2")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


# open both files
with open('template.json','r') as firstfile, open('World Heroes 2 Jet.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("World Heroes 2 Jet.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wh2j" in each line
    line = line.replace("GameFolder/", "wh2j")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('World Heroes Perfect.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("World Heroes Perfect.json", inplace=True):
    
    # This will replace string "GameFolder/" with "whp" in each line
    line = line.replace("GameFolder/", "whp")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    


     # open both files
with open('template.json','r') as firstfile, open('Windjammers.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Windjammers.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wjammers" in each line
    line = line.replace("GameFolder/", "wjammers")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Windjammers Supersonic.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Windjammers Supersonic.json", inplace=True):
    
    # This will replace string "GameFolder/" with "wjammss" in each line
    line = line.replace("GameFolder/", "wjammss")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)    
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Xeno Crisis.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Xeno Crisis.json", inplace=True):
    
    # This will replace string "GameFolder/" with "XenoCrisis" in each line
    line = line.replace("GameFolder/", "XenoCrisis")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('Zed Blade.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Zed Blade.json", inplace=True):
    
    # This will replace string "GameFolder/" with "zedblade" in each line
    line = line.replace("GameFolder/", "zedblade")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    
    # open both files
with open('template.json','r') as firstfile, open('ZinTricK.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("ZinTricK.json", inplace=True):
    
    # This will replace string "GameFolder/" with "zintrckb" in each line
    line = line.replace("GameFolder/", "zintrckb")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
      
    




     # open both files
with open('template.json','r') as firstfile, open('Zupapa!.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Zupapa!.json", inplace=True):
    
    # This will replace string "GameFolder/" with "zupapa" in each line
    line = line.replace("GameFolder/", "zupapa")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
     # open both files
with open('template.json','r') as firstfile, open('Crouching Tiger Hidden Dragon 2003 Super Plus.json','w') as secondfile:
      
    # read content from first file
    for line in firstfile:
               
             # write content to second file
             secondfile.write(line)

# This for loop scans and searches each line in the file
# By using the input() method of fileinput module
for line in fileinput.input("Crouching Tiger Hidden Dragon 2003 Super Plus.json", inplace=True):
    
    # This will replace string "GameFolder/" with "ct2k3sa" in each line
    line = line.replace("GameFolder/", "ct2k3sa")
    
    # write() method of sys module redirects the .stdout is redirected to the file
    sys.stdout.write(line)
    
    
    
    
    

    
    
    


