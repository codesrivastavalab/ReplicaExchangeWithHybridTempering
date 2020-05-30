# number of replicas
nrep=20
# "effective" temperature range
tmin=300
tmax=500

# build geometric progression
list=$(
awk -v n=$nrep \
    -v tmin=$tmin \
    -v tmax=$tmax \
  'BEGIN{for(i=0;i<n;i++){
    t=tmin*exp(i*log(tmax/tmin)/(n-1));
    printf(t); if(i<n-1)printf(",");
  }
}'
)
echo $list 

for((i=0;i<nrep;i++))
do

# choose lambda as T[0]/T[i]
# remember that high temperature is equivalent to low lambda
lambda=$(echo $list | awk 'BEGIN{FS=",";}{print $1/$'$((i+1))';}')
echo $lambda
# process topology
# (if you are curious, try "diff topol0.top topol1.top" to see the changes)
plumed partial_tempering $lambda < processed_.top > md$i.top

### Note: The following section should be uncommented when you use charmm36 forcefield instead of line 29  ####################
#plumed partial_tempering $lambda < processed_.top | awk -v f=$lambda '
#BEGIN {cmaptypes=0; pairtypes=0}
#{
#if (/\[ /) {cmaptypes=0; pairtypes=0};
#if (/\[ pairtypes \]/) {pairtypes=1};
#if (/\[ cmaptypes \]/) {cmaptypes=1};
#if (cmaptypes==1 && $1!=";") { 
#sub(/\\/, "", $0);
#if (NF==8) printf "%s %s %s %s %s %s %s %s\\\n",$1,$2,$3,$4,$5,$6,$7,$8;
#else if (NF==10) printf "%.9lf %.9lf %.9lf %.9lf %.9lf %.9lf %.9lf %.9lf %.9lf %.9lf\\\n",$1*f,$2*f,$3*f,$4*f,$5*f,$6*f,$7*f,$8*f,$9*f,$10*f; 
#else if (NF==6 && $1!=";name") printf "%.9lf %.9lf %.9lf %.9lf %.9lf %.9lf\n",$1*f,$2*f,$3*f,$4*f,$5*f,$6*f;
#else print $0;}
#else {print $0;}
#}'  > md$i.top

# prepare tpr file
# -maxwarn is often needed because box could be charged
gmx grompp  -maxwarn 1 -o 1md$i.tpr -f md$i.mdp -p md$i.top -c 7eq.gro
done
