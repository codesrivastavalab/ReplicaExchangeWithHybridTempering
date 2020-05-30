#!/bin/bash
read -p "Enter pdbname : " pdbname

gmx pdb2gmx -f $pdbname.pdb -o $pdbname\_processed.gro -water spce

gmx editconf -f $pdbname\_processed.gro -o $pdbname\_box.gro -c -d 0.9 -bt cubic

gmx solvate -cp $pdbname\_box.gro -cs spc216.gro -o $pdbname\_solv.gro -p topol.top 

cp /home/raji/work/trek1/cter/data/ions.mdp .

gmx grompp -f ions.mdp -c $pdbname\_solv.gro -p topol.top -o ions.tpr

gmx genion -s ions.tpr -o $pdbname\_solv_ions.gro -p topol.top -pname NA -nname CL -neutral

