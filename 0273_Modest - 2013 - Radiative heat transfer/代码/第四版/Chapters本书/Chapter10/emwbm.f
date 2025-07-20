        FUNCTION EMWBM(TAU,BETA)
C THIS FUNCTION CALCULATES THE NON-DIMENSIONAL TOTAL BAND ABSORPTANCE
C USING THE FELSKE-TIEN CORRELATION, EQ (9.82)
        IMPLICIT REAL*8 (A-H,O-Z)
        IF(BETA.GE.1.D0) THEN
            IF(TAU.LE.1.D0) THEN
                EMWBM=TAU
            ELSE
                EMWBM=DLOG(TAU)+1.D0
            ENDIF
        ELSE
            EMWBM=TAU
            IF(TAU.GT.BETA) THEN
                IF(TAU.LT.1.D0/BETA) THEN
                    EMWBM=2.D0*DSQRT(TAU*BETA)-BETA
                ELSE
                    EMWBM=DLOG(TAU*BETA)+2.D0-BETA
                ENDIF
            ENDIF
        ENDIF
        RETURN
        END
