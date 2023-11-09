#!/bin/bash 

# Xploit Searcher : searchsploit script
# author : Kenn3y
# date : 08-11-2023
# version 1.01

searchQuery(){ 
clear
echo "---- Xploit Searcher ----"
echo "-------------------------"
    read -p "zoek: " exploitSearch
echo "-------------------------"
searchsploit -t -e "$exploitSearch" > xploit.txt 
counter=0
searchPath="/snap/searchsploit/389/opt/exploitdb/exploits/"
while read line 
do
    if [ $((counter)) -ge 3 ] ; then
      if [ ${line:0:4} = "----" ] ;then break;fi
    echo "["$((counter-2))"]" $line
    fi
    counter=$((counter+1))
done < xploit.txt
echo "-------------------------"
if [ $((counter-2)) -eq 0 ]; then 
    echo "geen treffers, bye";
    rm -f xploit.txt
    exit;
else echo " >> $((counter-3)) exploits found"
fi
}
resultQuery(){
read -p "geef nummer of q : " keuze
if [ "$keuze" = "q" -o "$keuze" = "0" ]; then 
    echo "bye";
    rm -f xploit.txt
    exit;
fi
if [ "$keuze" -le "$counter" ]; then 
    keuzeNummer=0
    while read line
    do
        if [ "$((keuzeNummer-2))" -eq "$keuze" ]; then 
         echo "["$((keuzeNummer-2))"]" $line
         break
        fi
        keuzeNummer=$((keuzeNummer+1))
    done < xploit.txt
fi 
}
fetchQuery(){
    if [ ! -d "./exploits" ] ; then mkdir exploits;fi
    for char in $line
    do
        postFix=$char
    done
    searchsploit -x -m $postFix
    fileName=$(basename $postFix)
    mv -f $fileName exploits
}
status=true
while [ status ];
do
    searchQuery
    resultQuery
    fetchQuery
    echo "##--------------------"
    read -p "## hit q for quit or any key for new search : " statusKeuze
    if [ "$statusKeuze" = "q" ] ;then 
      rm -f xploit.txt
      exit;
    fi 
done
echo "---------- END ----------"
