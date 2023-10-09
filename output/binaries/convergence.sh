#$ -S /bin/bash
#$ -e $JOB_ID.e
#$ -o $JOB_ID.o
#$ -cwd
#$ -l h_vmem=10G
#$ -l h_cpu=15:00:00
#$ -pe sm 6
#$ -M tomwagg@mpa-garching.mpg.de
#$ -m beas # send an email at begin, ending, abortion and rescheduling of job

export TEMP="/afs/mpa/temp/tomwagg"
export PROJ_DIR="$TEMP/kavli"
export GRID_DIR="$PROJ_DIR/output/binaries"

export MESA_CACHES_DIR="$TEMP/mesa_cache"
export JOB_NAME="$1"

export OMP_NUM_THREADS=$NSLOTS
export MESA_DIR=/afs/mpa/temp/tomwagg/MESA/mesa

# move to the right directory
cd $GRID_DIR

# ensure we have access to SHMESA
source "$PROJ_DIR/shmesa.sh"

echo "Running convergence test"
DIRECTORY="$GRID_DIR/convergence-mesh_0.2-time_0.5"
if [ -d "$DIRECTORY" ]; then echo 'skipping'; exit 0; fi

cp -R ../../template_binary $DIRECTORY 
cd $DIRECTORY

mesa change "inlist1" mesh_delta_coeff 0.2
mesa change "inlist2" mesh_delta_coeff 0.2

mesa change "inlist1" time_delta_coeff 0.5
mesa change "inlist2" time_delta_coeff 0.5

./rn

cd -
