dirName=${PWD##*/}
filename="AndrewBell-$dirName.txt"
tempFile="temp.txt"
sedFile="sedFile.txt"
arr=(*.java)
#copy all of the code files
for name in *.java
do
    printf "/*------- File: $name -------*/\n" > "$filename"
    cat "$name" >> "$filename"
    #printf "/*----- End File: $name -----*/\n\n" >> "$filename"
done

#handle the a.out file
printf "/* ---------- paste of run ----------\n\n" >> "$filename"
if [ -f input1 ]; then
    for name in input*
    do
        printf "/* ---------- $name ----------*/\n\n" >> "$filename"
        echo "$name"
        java Main < "$name" > "$tempFile"
        #put input where it is supposed to go
        cat "$name" | while read line
        do
            sed -e "1 s/: /question $line endl/; t" -e "1,// s//question $line endl/" "$tempFile" > $sedFile
            cat $sedFile > $tempFile
        done
        sed -i -e 's/question/:/g' "$tempFile"
        sed -i -e 's/endl/\'$'\n/g' "$tempFile"
        cat "$tempFile" >> "$filename"
        rm temp.*
        rm sedFile.txt
        printf "\n" >> "$filename"
    done

else
    java Main >> "$filename"
fi
printf "   ---------- paste of run ----------*/\n\n" >> "$filename"
