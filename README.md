A little of closures in PL/SQL

First version saw in http://unclechrisblog.blogspot.com.br/2011/07/closures-in-plsql.html

How to install:

- Compile PARAMLIST.TPS and Lambda.typ on your Oracle database with SQL*Plus (or other tool like PL/SQL Developer)
- Enjoy it!

Example of use:

DECLARE

    L LAMBDA := LAMBDA('BEGIN :R := :A + :B; END;',
                       PARAMLIST('B',1));
BEGIN                                                                                                                                                          
    DBMS_OUTPUT.PUT_LINE(L.EXEC(PARAMLIST('A',3)));                                                                                                                                                                
    DBMS_OUTPUT.PUT_LINE(L.EXEC(PARAMLIST('A',9)));
	
    L.CLOSE;
END;