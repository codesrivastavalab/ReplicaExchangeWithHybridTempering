gmx_mpi grompp -f min.mdp -o min.tpr -c pdbname_solv_ions.gro.gro -p topol.top -maxwarn -1
mpirun gmx_mpi mdrun -v -deffnm min -ntomp 1
gmx_mpi grompp -f 1eq.mdp -o 1eq.tpr -c min.gro -p topol.top -maxwarn -1
mpirun gmx_mpi mdrun -v -deffnm 1eq -ntomp 1

for cnt in {2..7}
do
let "pcnt = $((cnt-1))"
gmx_mpi grompp -f $cnt\eq.mdp -o $cnt\eq.tpr -c $pcnt\eq.gro -p topol.top -maxwarn -1
mpirun gmx_mpi mdrun -v -deffnm $cnt\eq -ntomp 1
done
