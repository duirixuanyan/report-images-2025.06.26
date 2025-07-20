    FUNCTION WANGWBM(TAU,BETA)
C THIS FUNCTION CALCULATES THE NON-DIMENSIONAL TOTAL BAND ABSORPTANCE
C USING THE WANG CORRELATION, EQ (9.83)
      IMPLICIT REAL*8 (A-H,O-Z)
       W=BETA/2.D0*(DSQRT(1.D0+4.D0*TAU/BETA)-1.D0)
       WANGWBM=DEXP(BETA)*(E1(BETA+W)-E1(BETA))
     &  +DLOG(1.D0+W/BETA)+EIN(W)
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
