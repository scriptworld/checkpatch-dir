#! /bin/bash

dir_search () {

	for v in $(ls $1)
	do
		if [[ -d $1/$v ]]
		then
			echo searching for directory $1/$v
			dir_search $1/$v
		elif [[ -f $1/$v ]]
		then
			./scripts/checkpatch.pl -f $1/$v
		fi
	done
}

dir_search $1
