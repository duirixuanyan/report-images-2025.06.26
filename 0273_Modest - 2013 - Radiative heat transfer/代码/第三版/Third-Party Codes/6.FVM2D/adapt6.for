C*******************************************************************
      SUBROUTINE USER
C*******************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
C*******************************************************************
C  PROBLEM 5: BLACK, SQUARE ENCLOSURE WITH THE MEDIUM
C             IN RADIATIVE EQUILIBRIUM
C*******************************************************************
C     
      ENTRY GRID
C     
      TITLE(1)=' G '
	OPEN(7,FILE='PROB6.DAT')
C
      NCVLP=8
      NCVLT=4
C
      CALL QUAD
C     
	NZX=2
	XZONE(1)=0.5
	POWRX(1)=1.5
	NCVX(1)=5
	XZONE(2)=0.5
	POWRX(2)=-1.5
	NCVX(2)=5
C
	NZY=2
	YZONE(1)=0.5
	POWRY(1)=1.5
	NCVY(1)=5
	YZONE(2)=0.5
	POWRY(2)=-1.5
	NCVY(2)=5
C
	CALL ZGRID	
C      
      RETURN
C*******************************************************************
C     
      ENTRY START
C     
      LAST=30
      ALPHA=0.5
	QGEN=5000
C
	DO 100 J=2,M2
		T(1,J)=800
		T(L1,J)=800
 100	CONTINUE
C
      DO 101 I=2,L2               
         T(I,1)=1200
		T(I,M1)=400
 101  CONTINUE
C
      RETURN
C*******************************************************************
C     
      ENTRY LC
C
      RETURN
C*******************************************************************
C     
      ENTRY OUTPUT
C
	DO 200 J=2,M2
		DO 201 I=2,L2
			T(I,J)=(PI*RIB(I,J)/STFAN)**0.25
 201		CONTINUE
 200	CONTINUE
C
      IF(ITER.EQ.0) WRITE(6,500)
      WRITE(6,501) ITER, T(L1/2,M1/2),DMAX
      IF(ITER.EQ.0) WRITE(7,500)
      WRITE(7,501) ITER, T(L1/2,M1/2),DMAX
C
      IF(KSTOP.EQ.1.OR.ITER.EQ.LAST) THEN
         CALL HFLUX
         CALL PRINT 
		CALL TCPLT
      ENDIF
C
 500  FORMAT(/3X,'ITER',8X,'T',12X,'DIFF-MAX'/1X,48('*'))
 501  FORMAT(3X,I3,2(3X,1PE12.3))
C
      RETURN
C*******************************************************************
      ENTRY GAMSOR
C
	CALL HFLUX
C
	DO 300 J=2,M2
		DO 301 I=2,L2     
			RIB(I,J)=(QGEN/CAPPA(I,J)+G(I,J))/(4.*PI)
 301		CONTINUE
 300	CONTINUE
C
      RETURN
      END
C*******************************************************************
      


