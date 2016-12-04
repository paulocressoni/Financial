#!/bin/bash

# @author: Paulo A Cressoni
# @version: 1.0

# Usage: balance_calculation.sh ACCOUNTS TRANSACTIONS
# Calculates the accounts balance after the transactions occur and prints the result on the screen.
#
	

# Function that displays the help menu
help() {
	echo "Usage: $0 ACCOUNTS TRANSACTIONS"
	echo ""
	echo "Calculates the accounts balance after the transactions occur and prints the result on the screen."
	echo ""
	echo "Example:"
	echo "	$0 accounts.csv transactions.csv"
	echo "	$0 /home/paulo/Desktop/accounts.csv ~/Desktop/transactions.csv"
}


if [[ $1 =~ '--help' ]]
then
	# displays the help menu
	help
	exit 0
fi

# reference execution date
DATE="$(date "+%y%m%d%H%M%S%N")"

# process id
PID="$$"

# used to keep track of the output
OUT="/tmp/.${DATE}_${PID}_output.csv"

# csv file representing the accounts initial balance
ACCOUNTS="/tmp/.${DATE}_${PID}_${1}"

# csv file representing the accounts transactions
TRANSACTIONS="/tmp/.${DATE}_${PID}_${2}"

if [ ! -z $2 ] && [ -f $1 -a -f $2 ]
then
	# copy the files given as temporary new ones for more secure manipulation
	cp $1 $ACCOUNTS 2>/dev/null
	cp $2 $TRANSACTIONS 2>/dev/null

else
	# the files given do not exist or there are missing parameters
	echo "Error: Make sure there are two parameters and their names and paths are written correctly."
	echo "Type '$0 --help' to display the help menu."
	exit 99
fi


# iterate through the accounts initial balance file
while read acc_line 
do
	# account
	ACC="$(echo $acc_line | sed -r 's/^(.+),.+/\1/')"

	# account's initial balance
	BALANCE="$(echo $acc_line | sed -r 's/^.+,(.+)/\1/' | sed -r 's/^0+/0/' | sed -r 's/^(-)0+(.+)/\1\2/' | sed -r 's/^-0+$/0/' | sed -r 's/^0(.+)/\1/')"

	# file to manipulate transactions for a specific account
	ACC_TRANS="/tmp/.${DATE}_${PID}_acc_spec_trans.csv"

	# transaction values of the same account
	cat $TRANSACTIONS | sed -nr "/^${ACC},.+/ p"| sed -r "s/^${ACC},(.+)/\1/" | sed -r "s/^0+/0/" | sed -r 's/^(-)0+(.+)/\1\2/' | sed -r 's/^-0+$/0/' | sed -r "s/^0(.+)/\1/" > $ACC_TRANS

	# iterate through the transaction values for a specific account
	while read trans_value
	do
		# calculating the new balance
		BALANCE=$(($BALANCE + $trans_value))

		# when the balance is negative and a debit occur, a sum of R$5,00 (500 centavos de real) is subtracted from the account
		[[ $trans_value -lt 0 && $BALANCE -lt 0 ]] && let BALANCE-=500
	
	done < $ACC_TRANS
	
	# concatenate the result into a file
	echo "${ACC},${BALANCE}" >> $OUT
done < $ACCOUNTS

# display the result on the screen
cat $OUT

# delete temporary files
rm -f $ACCOUNTS $TRANSACTIONS $ACC_TRANS $OUT 2>/dev/null

exit 0
