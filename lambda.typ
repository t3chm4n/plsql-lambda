CREATE OR REPLACE TYPE LAMBDA AS OBJECT (

    C NUMBER,
    
    CONSTRUCTOR FUNCTION LAMBDA (P_SQL       IN VARCHAR2,
                                 V_PARAMLIST IN PARAMLIST DEFAULT PARAMLIST('R')) RETURN SELF AS RESULT,
                                 
    MEMBER PROCEDURE BIND (SELF        IN LAMBDA,
                           V_PARAMLIST IN PARAMLIST),
                           
    MEMBER PROCEDURE EXEC (SELF IN LAMBDA),
    
    MEMBER FUNCTION EXEC (SELF        IN LAMBDA,
                          V_PARAMLIST IN PARAMLIST DEFAULT PARAMLIST('R')) RETURN VARCHAR2,
                          
    MEMBER FUNCTION VALUE (SELF IN LAMBDA,
                           P_N  IN VARCHAR2) RETURN VARCHAR2,
                           
    MEMBER PROCEDURE CLOSE (SELF IN LAMBDA)
)
/
CREATE OR REPLACE TYPE BODY LAMBDA AS
    -- The type PARAMLIST must be created in order to lambda work
    CONSTRUCTOR FUNCTION LAMBDA (P_SQL       IN VARCHAR2,
                                 V_PARAMLIST IN PARAMLIST DEFAULT PARAMLIST('R')) RETURN SELF AS RESULT IS
    BEGIN
      C := DBMS_SQL.OPEN_CURSOR;
      DBMS_SQL.PARSE(C,P_SQL,DBMS_SQL.NATIVE);
      SELF.BIND(V_PARAMLIST);
      RETURN;
    END;
    
    MEMBER PROCEDURE BIND (SELF        IN LAMBDA,
                           V_PARAMLIST IN PARAMLIST) IS
    BEGIN
      /* BIND of parameters. Must be in pais. Examples
         parameter_1 = variable name
         parameter_2 = value for the variable in parameter_1
         parameter_3 = variable name
         parameter_4 = value for the variable in parameter_4
         and so on...
      */
      FOR I IN 1 .. V_PARAMLIST.COUNT LOOP
        IF MOD(I,2) <> 0 AND V_PARAMLIST.COUNT > 1 THEN
          DBMS_SQL.BIND_VARIABLE(SELF.C,V_PARAMLIST(I),V_PARAMLIST(I+1),32767);
        ELSE
          DBMS_SQL.BIND_VARIABLE(SELF.C,'R',NULL,32767);
        END IF;
      END LOOP;
    END;
    
    MEMBER PROCEDURE EXEC (SELF IN LAMBDA) IS
      L_NUM_PROCESSED NUMBER;
    BEGIN
      L_NUM_PROCESSED := DBMS_SQL.EXECUTE(C);
    END;
    
    MEMBER FUNCTION EXEC (SELF        IN LAMBDA,
                          V_PARAMLIST IN PARAMLIST DEFAULT PARAMLIST('R')) RETURN VARCHAR2 IS
    BEGIN
      SELF.BIND(V_PARAMLIST);
      SELF.EXEC;
      RETURN SELF.VALUE('R');
    END;
    
    MEMBER FUNCTION VALUE (SELF IN LAMBDA,
                           P_N  IN VARCHAR2) RETURN VARCHAR2 IS
      L_VAL VARCHAR2(32767);
    BEGIN
      DBMS_SQL.VARIABLE_VALUE(SELF.C,P_N,L_VAL);
      RETURN L_VAL;
    END;
    
    MEMBER PROCEDURE CLOSE (SELF IN LAMBDA) IS
      L_C NUMBER := SELF.C;
    BEGIN
      DBMS_SQL.CLOSE_CURSOR(L_C);
    END;
    
END;
/
