#!/usr/bin/env bash

WK_DIR=/scratch/cpoisson/PROJET_ANSES_2026_scratch/MetaLoRe/work

if [ ! -e "$WK_DIR" ]; then
  echo "ERROR: $WK_DIR does not exist" >&2
  exit 1
fi

read -e -p "Would you like to purge working and results files? (y/n) " choice
[[ "$choice" == [Yy]* ]] && echo "Purging files..." || exit 1

rm -rf $WK_DIR
rm -rf results
rm -f rm *.o*
rm -f rm *.e*
rm -f *.log
rm -f .nextflow.log*
rm -rf .nextflow
