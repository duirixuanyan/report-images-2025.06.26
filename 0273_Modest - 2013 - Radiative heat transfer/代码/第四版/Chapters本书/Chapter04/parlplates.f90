      FUNCTION PARLPLTF(X1,X2,X3,Y1,Y2,Y3,Z)
!  *************************************************************************
!  *  THIS SUBROUTINE EVALUATES THE VIEW FACTOR BETWEEN TWO PARALLEL,      *
!  *  RECTANGULAR PLATES OF SIZE X1xY1 AND (X3-X2)x(Y3-Y2), DISPLACED      *
!  *  FROM ANOTHER BY Z IN THE Z-DIRECTION, BY X2 IN THE X-DIRECTON, AND   *
!  *  BY Y2 IN THE Y-DIRECTION, IN TERMS OF VIEW FACTORS OF DIRECTLY       *
!  *  OPPOSITE, IDENTICAL RECTANGLES (CONFIG. 38), AS SHOWN IN FIG.4-15b   *
!  *************************************************************************
      IMPLICIT NONE 
      REAL*4        :: PARLPLTF,X1,X2,X3,Y1,Y2,Y3,Z,A,F,VIEW,ARG(3)
      INTEGER       :: NARG
      NARG=3
      ARG(1)=X3
      ARG(2)=Y3
      ARG(3)=Z
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=A*VIEW (38,NARG,ARG)
      ARG(2)=Y2
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F-A*VIEW (38,NARG,ARG)
      ARG(2)=Y3-Y1
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F-A*VIEW (38,NARG,ARG)
      ARG(2)=Y2-Y1
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F+A*VIEW (38,NARG,ARG)
      ARG(1)=X2
      ARG(2)=Y3
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F-A*VIEW (38,NARG,ARG)
      ARG(2)=Y2
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F+A*VIEW (38,NARG,ARG)
      ARG(2)=Y3-Y1
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F+A*VIEW (38,NARG,ARG)
      ARG(2)=Y2-Y1
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F-A*VIEW (38,NARG,ARG)
      ARG(1)=X3-X1
      ARG(2)=Y3
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F-A*VIEW (38,NARG,ARG)
      ARG(2)=Y2
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F+A*VIEW (38,NARG,ARG)
      ARG(2)=Y3-Y1
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F+A*VIEW (38,NARG,ARG)
      ARG(2)=Y2-Y1
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F-A*VIEW (38,NARG,ARG)
      ARG(1)=X2-X1
      ARG(2)=Y3
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F+A*VIEW (38,NARG,ARG)
      ARG(2)=Y2
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F-A*VIEW (38,NARG,ARG)
      ARG(2)=Y3-Y1
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F-A*VIEW (38,NARG,ARG)
      ARG(2)=Y2-Y1
      A=ARG(1)*ARG(2)
      IF(ABS(A).GT.1D-6) F=F+A*VIEW (38,NARG,ARG)
      PARLPLTF=F/(4.*(X1*Y1))
      RETURN
      END
