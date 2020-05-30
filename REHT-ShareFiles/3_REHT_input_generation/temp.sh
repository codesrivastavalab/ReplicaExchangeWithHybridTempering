# number of replicas
nrep=20
# "effective" temperature range
tmin=300
tmax=340

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

for temp in ${list//,/ }
do
sed 's/XXX/'$temp'/g' md.mdp > md$i.mdp
i=$(($i+1));
done

