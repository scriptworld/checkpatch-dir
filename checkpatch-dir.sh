#! /bin/bash

EDITOR=vim
SCRIPT=./scripts/checkpatch.pl
OUTPUT=~/.checkpatch.log
TARGET_DIR=$1
GREP_STRING="please review"

search_dir ()
{
	for v in $(ls $1)
	do
		if [[ -d $1/$v ]]
		then
			echo searching for directory $1/$v
			search_dir $1/$v
		elif [[ -f $1/$v ]]
		then
			$SCRIPT -f $1/$v
		fi
	done
}

# move for executing ./scripts/checkpatch.pl
move_root_dir ()
{
	while [ ! -d kernel -o ! -d arch -o ! -d drivers ]
	do
		cd ..
	done
}

make_target_dir ()
{
	TARGET_DIR=$(pwd)/$1
	echo "target_dir is $TARGET_DIR"
}

case $1 in
	-h|--help|"")
		echo "Usage :
		$ checkpatch-dir.sh \$TARGET_DIR"
		;;
	*)
		make_target_dir $1
		move_root_dir
		echo "Please wait.."
		search_dir $TARGET_DIR > $OUTPUT
		cat $OUTPUT | grep "$GREP_STRING"
		echo "check the file $OUTPUT : [y/n]"
		read C
		if [[ $C == 'y' ]]
		then
			$EDITOR $OUTPUT
		fi
		;;
esac
