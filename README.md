# Accounts Balance Calculator
The account balance calculator is a bash program used to calculate the final balance to an account after some transactions are performed with the account. The output will be displayed on the screen when it finishes to execute, and it will be composed of CSV values: __account_number,final_balace__. Here, the __account number__ can be substituted by an __client id__ for example.

The program requires **two parameters** that are **CSV files** to work.

### First Parameter
The first parameter is a **CSV file** containing the __account number__ and the __initial balance value (in cents)__ for that account. The values are separated by a coma (__,__) and there are no headers or tails on the file, only the values described.

### Second Parameter
The second parameter is a __CSV file__ containing the __account number__ and the __transaction value (in cents)__ for that account. The transaction value can be __positive__ or __negative__. __When positive__, it means that the value will be __credited__ to the account. __When negative__, the value will be __debited__ from the account. The values are separated by a coma (__,__) and there are no headers or tails on the file, only the values described.

### Rule
After a __debit__ occurs, if the current balance is a __negative value__, there must be immediately a __debit of 500 cents__ to the account current balance.

## Example:
You can execute this bash program on a linux terminal, writting `./balance_calculation.sh accounts.csv transactions.csv`. Make sure you are on the correct folder and so are your file parameters.

You can also redirect the outpput to a file, like `./balance_calculation.sh accounts.csv transactions.csv > balance_out.csv`.

If you're having some trouble with the files don't forget checking their permission. To change their permissions you can write this on the linux terminal `chmod 777 accounts.csv balance_calculation.sh transactions.csv`.
