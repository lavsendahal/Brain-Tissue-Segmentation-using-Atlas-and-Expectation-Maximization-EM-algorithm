#!/bin/bash
STRING="Start of Registration MIRA/MISA Lab Part1"
echo $STRING

PATH=/Applications/elas/bin:$PATH
export DYLD_LIBRARY_PATH=/Applications/elas/lib:$DYLD_LIBRARY_PATH



elastix -f 1000.nii.gz -m 1001.nii.gz -out resultsTraining/1001 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1002.nii.gz -out resultsTraining/1002 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1006.nii.gz -out resultsTraining/1006 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1007.nii.gz -out resultsTraining/1007 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1008.nii.gz -out resultsTraining/1008 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1009.nii.gz -out resultsTraining/1009 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1010.nii.gz -out resultsTraining/1010 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1011.nii.gz -out resultsTraining/1011 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1012.nii.gz -out resultsTraining/1012 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1013.nii.gz -out resultsTraining/1013 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1014.nii.gz -out resultsTraining/1014 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1015.nii.gz -out resultsTraining/1015 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1017.nii.gz -out resultsTraining/1017 -p ParameterRigid.txt

elastix -f 1000.nii.gz -m 1036.nii.gz -out resultsTraining/1036 -p ParameterRigid.txt
