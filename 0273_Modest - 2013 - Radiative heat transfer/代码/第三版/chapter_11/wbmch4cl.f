      PROGRAM PHIRATIO
C THIS PROGRAM CALCULATES THE LINE OVERLAP FUNCTION GAMMA (PHI/SQRT(T))
C AND STRENGTH FUNCTION ALPHA (PSI*) AS FUNCTION OF
C TEMPERATURE, THEN NORMALIZES THEM WITH THE VALUE AT 100K
C *** METHANE ***
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION ETA(4),DELTA(4),G(4),A0(4),B0(4),U(4),
     1          PHIE(4),PSIE(4)
	CHARACTER*12 BAND(4)
C
      WRITE(6,1)
    1 FORMAT('WBM FUNCTIONS FOR CH4: please input temperature (in K)'/)
	READ(5,*) TEMP
	WRITE(6,2)TEMP
    2	FORMAT(/'GAS TEMPERATURE = ',F6.0,'K'//
     >'   BAND       PSI*/PSI0*    GAM/GAM0'/)
C
C SET UP BASIC PARAMETERS FOR DIFFERENT BANDS
C
      M=4
      ETA(1)=2914.D0
      ETA(2)=1526.D0
      ETA(3)=3020.D0
      ETA(4)=1306.D0
      G(1)=1.D0
      G(2)=2.D0
      G(3)=3.D0
      G(4)=3.D0
C
C SCAN OVER THE 4 IMPORTANT BANDS
C
      DO 2000 IB=1,4
C
C  INITIAL VALUES OF SUM ARGUMENTS (A=NUMERATOR, B=DENOMINATOR)
C
      DO 9 K=1,M
      B0(K)=1.D0
    9 A0(K)=1.D0
C *** 7.7MUM BAND ****
      IF(IB.EQ.1) THEN
      		BAND(IB)='7.7MUM BAND ' 
      		DELTA(1)=0.D0
      		DELTA(2)=0.D0
      		DELTA(3)=0.D0
      		DELTA(4)=1.D0
      		A0(4)=G(4)
      		ENDIF
C *** 3.3MUM BAND ****
      IF(IB.EQ.2) THEN
      		BAND(IB)='3.3MUM BAND ' 
      		DELTA(1)=0.D0
      		DELTA(2)=0.D0
      		DELTA(3)=1.D0
      		A0(3)=G(3)
      		DELTA(4)=0.D0
      		ENDIF
C *** 2.4MUM BAND ****
      IF(IB.EQ.3) THEN
      		BAND(IB)='2.4MUM BAND ' 
      		DELTA(1)=1.D0
      		DELTA(2)=0.D0
      		DELTA(3)=0.D0
      		DELTA(4)=1.D0
      		A0(4)=G(4)
      		ENDIF
C *** 1.7MUM BAND ****
      IF(IB.EQ.4) THEN
      		BAND(IB)='1.7MUM BAND ' 
      		DELTA(1)=1.D0
      		DELTA(2)=1.D0
      		A0(2)=G(2)
      		DELTA(3)=0.D0
      		DELTA(4)=1.D0
      		A0(4)=G(4)
      		ENDIF
C
C CALCULATE PHIRATIO AND PSIRATIO AT SET OF TEMPERATURES
C
      DO 1000 IT=1,2
      T=100.D0*(1/IT)+(IT-1)*TEMP
      PHIT=1.D0
      PSIT=1.D0
      DO 100 K=1,M
      A=A0(K)
      B=B0(K)
      U(K)=1.4388D0*ETA(K)/T
      EX1=DEXP(-U(K))
      PHIN=DSQRT(A)
      PHID=A
      PHIB=B
      EX=1.D0
      VC=G(K)+DELTA(K)-1D0
      VB=G(K)-1D0
      V=0.D0
  10  V=V+1.D0
      A=A*(1.D0+VC/V)
      B=B*(1.D0+VB/V)
      EX=EX*EX1
      AEX=A*EX
      BEX=B*EX
      PHIN=PHIN+DSQRT(AEX)
      PHID=PHID+AEX
      PHIB=PHIB+BEX
      IF(AEX.GT.1.D-12) GOTO 10
      PHI=PHIN*PHIN/PHID
      PSI=PHID/PHIB
      PSIT=PSIT*PSI
  100 PHIT=PHIT*PHI
      FAC=0.D0
      DO 110 K=1,M
  110 FAC=FAC+U(K)*DELTA(K)
      PSIT=PSIT*(1.D0-DEXP(-FAC))
C
      IF(IT.EQ.1) THEN
          PHIT0=PHIT
          PSIT0=PSIT
         ELSE
          PHIE(IB)=PHIT/PHIT0*DSQRT(1.D2/T)
          PSIE(IB)=PSIT/PSIT0
         ENDIF
 1000 CONTINUE
      WRITE(6,200) BAND(IB),PSIE(IB),PHIE(IB)
  200 FORMAT(A12,2F12.5)
 2000 CONTINUE
      STOP
      END
