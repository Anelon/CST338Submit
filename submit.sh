#########################
#      Andrew Bell      #
# Input submission Prep #
#########################


#get directory name
dirName=${PWD##*/}
name="AndrewBell"
filename="$name-$dirName.txt"
#temp files for storing intermediate steps
tempFile="temp.txt"
sedFile="sedFile.txt"
#copy all of the code files
for name in *.java
do
   printf "/*------- File: $name -------*/\n" > "$filename"
   cat "$name" >> "$filename"
   #printf "/*----- End File: $name -----*/\n\n" >> "$filename"
done

#handle the executable file
printf "/* ---------- paste of run ----------\n\n" >> "$filename"
#if there is an input file
if [ -f input1 ]; then
   #get all of the input files
   for name in input*
   do
      printf "/* ---------- $name ----------*/\n\n" >> "$filename"
      echo "$name"
      java Main < "$name" > "$tempFile"
      #put input where it is supposed to go
      cat "$name" | while read line
      do
         #look for ": " and place the input line and tag for clean up
         sed -e "1 s/: /question $line endl/; t" -e "1,// s//question $line endl/" "$tempFile" > $sedFile
         cat $sedFile > $tempFile
      done
      #fix tags from the sed
      sed -i -e 's/question/:/g' "$tempFile"
      sed -i -e 's/endl/\'$'\n/g' "$tempFile"
      #put in correct file
      cat "$tempFile" >> "$filename"
      #clean up temp files
      rm temp.*
      rm sedFile.txt
      printf "\n" >> "$filename"
   done
else
   java Main >> "$filename"
fi
printf "   ---------- paste of run ----------*/\n\n" >> "$filename"
