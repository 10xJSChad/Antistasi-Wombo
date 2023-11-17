#!/bin/sh
addons_dir="$(pwd)/A3A/addons"
build_dir="$(pwd)/build/@A3U/addons"
a3builder="./build/a3builder"
preprocessor="./build/preprocessor"
wombo_dir="./src/antistasi-wombo"


if ! [ -d "./A3A" ]
then
	echo "Are you sure this is the right directory?"
	echo "All scripts must be ran from the project's root directory"
	exit 1
fi


find "$wombo_dir" -type f -name "*.sqf" -exec "$preprocessor" "{}" \;

if [ "$1" = "-p" ]
then
	exit 0;
fi

"$a3builder" "$addons_dir" "$build_dir"


while [ ! -d  "$build_dir" ];
do
	sleep 1
done


echo "Copying mod.cpp"
cp "$addons_dir/../mod.cpp" "$build_dir/.."
