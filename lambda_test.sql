DECLARE

    L LAMBDA := LAMBDA('BEGIN :R := :A + :B; END;',
                       PARAMLIST('B',1));
BEGIN                                                                                                                                                          
    DBMS_OUTPUT.PUT_LINE(L.EXEC(PARAMLIST('A',3)));                                                                                                                                                                
    DBMS_OUTPUT.PUT_LINE(L.EXEC(PARAMLIST('A',9)));
	
    L.CLOSE;
END;

/

