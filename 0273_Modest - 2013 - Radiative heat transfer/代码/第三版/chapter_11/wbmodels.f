        PROGRAM WBMCORRS
C THIS PROGRAM IS AN INTERFACE TO CALL CORRELATION FUNCTIONS TO
C CALCULATE THE NON-DIMENSIONAL TOTAL BAND ABSORPTANCE
C USING THE EDWARDS&MENARD CORRELATION, TABLE 10.2,
C THE FELSKE&TIEN CORRELATION, EQUATION 10.125, AND
C THE WANG CORRELATION, EQUATION 10.126.
        IMPLICIT REAL*8 (A-H,O-Z)
        WRITE(*,*) 'INPUT TAU0 AND BETA'
        READ(*,*) TAU0,BETA
        ASTAREM=EMWBM(TAU0,BETA)
        ASTARFT=FTWBM(TAU0,BETA)
        ASTARWG=WANGWBM(TAU0,BETA)
        WRITE(*,10) TAU0,BETA,ASTAREM,ASTARFT,ASTARWG
  10    FORMAT('TAU0 =',1PE10.2,',  BETA =',0PF7.4/
     &  'ASTAR(E&M) =',F8.4,',  ASTAR(F&T) =',F8.4,
     &  ',  ASTAR(WANG) =',F8.4)
        STOP
        END
C****************************************************************************
        FUNCTION EMWBM(TAU,BETA)
C THIS FUNCTION CALCULATES THE NON-DIMENSIONAL TOTAL BAND ABSORPTANCE
C USING THE EDWARDS&MENARD CORRELATION, TABLE 10.2
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
C****************************************************************************
        FUNCTION FTWBM(TAU,BETA)
C THIS FUNCTION CALCULATES THE NON-DIMENSIONAL TOTAL BAND ABSORPTANCE
C USING THE FELSKE-TIEN CORRELATION, EQ (10.125)
        IMPLICIT REAL*8 (A-H,O-Z)
        ARG=DSQRT(TAU/BETA/(1.D0+BETA/TAU))
        FTWBM=2.D0*EIN(BETA*ARG)+EIN(.5D0*ARG)-EIN((.5D0+BETA)*ARG)
        RETURN
        END
C****************************************************************************
        FUNCTION WANGWBM(TAU,BETA)
C THIS FUNCTION CALCULATES THE NON-DIMENSIONAL TOTAL BAND ABSORPTANCE
C USING THE WANG CORRELATION, EQ (10.126)
        IMPLICIT REAL*8 (A-H,O-Z)
        W=BETA/2.D0*(DSQRT(1.D0+4.D0*TAU/BETA)-1.D0)
        WANGWBM=DEXP(BETA)*(E1(BETA+W)-E1(BETA))
     &                  +DLOG(1.D0+W/BETA)+EIN(W)
        RETURN
        END
C****************************************************************************
      FUNCTION EIN(X)
C EIN(X)=E1(X)+LN(X)+.57721566
      IMPLICIT REAL*8 (A-H,O-Z)
      IF(X.GT.1.) GOTO 10
      A1= .99999193
      A2=-.24991055
      A3= .05519968
      A4=-.00976004
      A5= .00107857
      EIN=X*(A1+X*(A2+X*(A3+X*(A4+X*A5))))
      RETURN
   10 A1= 8.5733287401
      A2=18.0590169730
      A3= 8.6347608925
      A4=  .2677737343
      B1= 9.5733223454
      B2=25.6329561486
      B3=21.0996530827
      B4= 3.9584969228
      EIN=(X*(A3+X*(A2+X*(A1+X)))+A4)/(X*(B3+X*(B2+X*(B1+X)))+B4)
     .              *DEXP(-X)/X+DLOG(X)+.57721566
      RETURN
      END
C****************************************************************************
      FUNCTION E1(X)
      IMPLICIT REAL*8 (A-H,O-Z)
      IF(X.GT.1.) GOTO 10
      A0=-.57721566
      A1= .99999193
      A2=-.24991055
      A3= .05519968
      A4=-.00976004
      A5= .00107857
      E1=A0+X*(A1+X*(A2+X*(A3+X*(A4+X*A5))))-DLOG(X+1.D-8)
      RETURN
   10 A1= 8.5733287401
      A2=18.0590169730
      A3= 8.6347608925
      A4=  .2677737343
      B1= 9.5733223454
      B2=25.6329561486
      B3=21.0996530827
      B4= 3.9584969228
      E1=(X*(A3+X*(A2+X*(A1+X)))+A4)/(X*(B3+X*(B2+X*(B1+X)))+B4)
     .  *DEXP(-X)/X
      RETURN
      END
C****************************************************************************