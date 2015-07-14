#!/bin/bash
#Filename: GeneratePropertisConstants.sh
#Description: Generate swift class properties upper name constants

#while read line;
#do
#echo $line;
#done

sed 's/@NSManaged var \([a-zA-Z]\+\)/let k_\1 = "\1"  @NSManaged var \1/g'


