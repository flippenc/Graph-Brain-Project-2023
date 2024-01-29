#/bin/bash
n=$1
let maxE=$n\*$n
#echo $maxE
for e in $(seq 0 2 $maxE)
do
   /usr/local/sage-9.4/sage generateHadamardGraphsE.sage $n $e &
done

wait
echo "Finished"
mailx -s "hadamard code finished" flippenc@vcu.edu <<< "hadamard code finished"
