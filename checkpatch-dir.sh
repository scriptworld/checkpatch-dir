#! /bin/bash

EDITOR=vim
SCRIPT=./scripts/checkpatch.pl
OUTPUT=~/.checkpatch.log

dir_search () {
	for v in $(ls $1)
	do
		if [[ -d $1/$v ]]
		then
			echo searching for directory $1/$v
			dir_search $1/$v
		elif [[ -f $1/$v ]]
		then
			$SCRIPT -f $1/$v
		fi
	done
}

if [[ $1 == '-h' || $1 == '--help' ]]
then
	vim -c $OPTION $OUTPUT
	echo "Usage :
	$ cd \$ROOT_PATH_OF_KERNEL_SOURCE
	$ checkpatch-dir.sh \$TARGET_DIR"
elif [[ $# -eq 0 ]]
then
	echo "No arguments provided"
	exit 1
else
	echo "Please wait.."
	dir_search $1 > $OUTPUT
	cat $OUTPUT | grep "please review"
	echo "check the file $OUTPUT : [y/n]"
	read C
	if [[ $C == 'y' ]]
	then
		$EDITOR $OUTPUT
	fi	
fi
