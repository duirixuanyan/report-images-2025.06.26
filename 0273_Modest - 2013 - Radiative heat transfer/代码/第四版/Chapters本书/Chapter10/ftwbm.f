    FUNCTION FTWBM(TAU,BETA)
C THIS FUNCTION CALCULATES THE NON-DIMENSIONAL TOTAL BAND ABSORPTANCE
C USING THE FELSKE-TIEN CORRELATION, EQ (9.82)
      IMPLICIT REAL*8 (A-H,O-Z)
      ARG=DSQRT(TAU/BETA/(1.D0+BETA/TAU))
      FTWBM=2.D0*EIN(BETA*ARG)+EIN(.5D0*ARG)-EIN((.5D0+BETA)*ARG)
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
     .   *DEXP(-X)/X+DLOG(X)+.57721566
      RETURN
      END
C****************************************************************************
