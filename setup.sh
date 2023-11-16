#!/bin/sh


if ! [ -d "./A3A" ]
then
	echo "Are you sure this is the right directory?"
	echo "All scripts must be ran from the project's root directory"
	exit 1
fi


if ! [ -d "./build" ]
then
	mkdir "./build"
fi


g++ ./src/preprocessor/preprocessor.cpp -o ./build/preprocessor
gcc ./src/a3builder/a3builder.c -o ./build/a3builder


echo "If this is your first time running the setup, you're going to have to create"
echo "the a3builder config file, run the a3builder binary for instructions."
