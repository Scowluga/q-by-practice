show t:([]k:1 2 3 2 3; p:`a1`a2`a1`a3`a2; v:100 200 300 400 500);

/ 1. Collect unique values of the pivot column `p` into list `P`
P:distinct t[`p]
P:exec distinct p from t

/ 2. Write a query that extracts the key-value pairs for `p` and `v` grouped by `k`
select p!v by k from t;                     / grouping (by k) and constructing custom column with dictionaries `p!v`

/ Rectangularize the dictionaries
select P#p!v by k from t;                   / fill in dictionary using `P#` - automatically fills empty with null

/ 3. Enhance query to construct pivoted table from dictionaries
/ We switch to `exec` which returns the raw table values
/ The result is a dictionary where 
/ - the keys are the distinct values of k
/ - the vals are dictionaries of the same rectangular shape
/ q magically fits this result into a keyed table by moving the dictionary keys to columns
exec P#p!v by k from t;

/ Add back the key column name by explicitly declaring it
exec P#p!v by k:k from t;

/ 4. Write the query to extract the unique values of the pivot column (step 1) in functional form
P:?[t; (); (); (distinct; `p)]

/ 5. Convert the pivot query to functional form 
bp:(enlist `k)!enlist `k;                   / by phrase: group by `k
sp:(#; `P; (!; `p; `v));                    / select phrase: exec `P#p!v`
?[t; (); bp; sp];

/ 6. Place previous functional forms in a function that takes table and column names
dopivot:{[t; kn; pn; vn]
  P:?[t; (); (); (distinct; pn)];
  ?[t; (); (enlist kn)!enlist kn; (#; `P; (!; pn; vn))] }


