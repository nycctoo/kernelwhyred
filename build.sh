#!/bin/bash

export KERNELNAME="Prooholic-Kranul"

export LOCALVERSION=-v3.0

export KBUILD_BUILD_USER=Peter

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
