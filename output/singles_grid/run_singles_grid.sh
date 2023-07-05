#!/bin/bash
source ../../shmesa.sh

INLIST="inlist_project"
OUTPUT="./"

single () {
    local M=$1
    local os=$2
    
    PARAMS="os_"$os
    echo "Running mass $M" with $PARAMS
    DIRECTORY=$OUTPUT/"M_"$M"-"$PARAMS 
    if [ -d "$DIRECTORY" ]; then echo 'skipping'; return 0; fi
    
    cp -R ../../template $DIRECTORY 
    cd $DIRECTORY 
    
    if [[ $os == 1 ]]; then
        mesa change $INLIST overshoot_scheme "'exponential'"
        mesa change $INLIST overshoot_zone_type "'burn_H'"
        mesa change $INLIST overshoot_zone_loc "'core'"
        mesa change $INLIST overshoot_bdy_loc "'top'"
        mesa change $INLIST overshoot_f 0.01
        mesa change $INLIST overshoot_f0 0.005
    fi
    mesa change $INLIST initial_mass $M
    
    # ./rn

    # rm star
    # rm -rf photos
    
    cd -
}

for M in `seq 3 5`; do
    for os in 0 1; do
        single $M $os
    done
done