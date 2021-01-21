#!/bin/bash

export KERNELNAME="issac"

<<<<<<< HEAD
export LOCALVERSION=1.0
=======
export LOCALVERSION=3.1-Nightly
>>>>>>> 0486d0fb0468728385ea1ecb3bb8f45a17cd8f4b

export KBUILD_BUILD_USER=issacc

export KBUILD_BUILD_HOST=DroneCI

export TOOLCHAIN=clang

export DEVICES=whyred

source helper

gen_toolchain

send_msg "Start building ${KERNELNAME} ${LOCALVERSION} for ${DEVICES}..."

START=$(date +"%s")

for i in ${DEVICES//,/ }
do
	build ${i} -oldcam

	build ${i} -newcam
done

send_msg "Building OC version..."

git apply oc.patch

for i in ${DEVICES//,/ }
do
	if [ $i == "whyred" ] || [ $i == "tulip" ]
	then
		build ${i} -oldcam -overclock

		build ${i} -newcam -overclock
	fi
done

send_msg "Building Little OC version..."

git apply little.patch

for i in ${DEVICES//,/ }
do
	if [ $i == "whyred" ] || [ $i == "tulip" ]
	then
		build ${i} -oldcam -littleoverclock

		build ${i} -newcam -littleoverclock
	fi
done

END=$(date +"%s")

DIFF=$(( END - START ))

send_msg "Build succesfully in $((DIFF / 60))m $((DIFF % 60))s"
