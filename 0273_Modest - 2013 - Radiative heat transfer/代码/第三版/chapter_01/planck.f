      PROGRAM PLANCK
C     ********************************************************************
C     *  This program calculates the spectral and fractional blackbody   *
C     *  emissive powers E_blambda/n^3T^5, E_beta/nT^3 and f(n*lambda*T),* 
C     *  Input: ID = 1 -- use wavelength in micro-m		  	           *
C     *            = 2 -- use wavenumber in cm^-1			               *
C     *         WL/WN wavelength or wavenumber				           *
C     *         T  = temperature in K					                   *
C     ********************************************************************
      IMPLICIT REAL*8 (A-H,O-Z)
      PI=4.D0*DATAN(1.D0)
      CC=1.5D1/PI**4
      C1=3.7404D8
      C2=1.4388D4
      EPS=1.D-16
C
    3 WRITE(6,1)
    1 FORMAT(2X,'ID (1 FOR WL, 2 FOR WN), WLorWN, T ?')
      READ(5,*) ID,XX,T
C  X = lambda*T (mum*K), XN = eta/T (cm^-1/K)
      IF(ID.EQ.1) THEN
      		X=XX*T
      		XN=1.D4/X
      	ELSE
      		IF(ID.EQ.2) THEN
      			XN=XX/T
      			X=1.D4/XN
      		ELSE
      			WRITE(6,*) 'ILLEGAL ID'
      			GOTO 3
      		ENDIF
      	ENDIF				
C  V = C_2/lambdaT = C_2*eta/T
C  EL = E_blambda/n^3T^5
C  EN = E_beta/nT^3
      V=C2/X
      EX=DEXP(V)
      EL=C1/(X**5*(EX-1.D0))*1.D11
      EN=EL*X*X*1.D-7
C
C Evaluation of f(n*lambda*T) in terms of an infinite series
C FL = f(n*lambda*T)
C
      M=0
      FL=0.D0
      EM=1.D0
    5 M=M+1
      VM=M*V
      BM=(6.D0+VM*(6.D0+VM*(3.D0+VM)))/FLOAT(M)**4
      EM=EM/EX
      FL=FL+BM*EM
      IF(VM**3*EM.GT.EPS) GOTO 5
      FL=CC*FL
C
C Print result to screen
C
      WRITE(6,20) X,XN,EL,EN,FL
   20 FORMAT(5X,'WL*T       WN/T        EBL/T5          EBN/T3       F'/
     1       5X,'(umK)     (cm K)  (E-11 W/m2umK5) (E-8 W/m2cm-1K3)   '/
     2       2X,F8.1,2F12.5,3X,2F12.5)
      STOP
      END
