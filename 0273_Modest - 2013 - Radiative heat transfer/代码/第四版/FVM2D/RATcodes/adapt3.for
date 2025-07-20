C*******************************************************************
      SUBROUTINE USER
C*******************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
C*******************************************************************
C  PROBLEM 4: BLACK, SQUARE ENCLOSURE WITH INHOMOGENOUS MEDIUM 
C             AND HOT BOTTOM WALL   
C*******************************************************************
C     
      ENTRY GRID
C     
      TITLE(1)=' G '
	OPEN(7,FILE='PROB3.DAT')
C
      NCVLP=8
      NCVLT=4
C
      CALL QUAD
C     
      NCVLX=10
      NCVLY=10
C
      XL=1.
      YL=1.
C
      CALL EZGRID
C      
      RETURN
C*******************************************************************
C     
      ENTRY START
C     
      LAST=30
      KISO=0
      KPHASE=2
      ALPHA=0.5
      SIG=0.5
C
      TEM=(1./STFAN)**(1./4.)
C
      DO 11 I=2,L1-1               
         T(I,1)=TEM
 11   CONTINUE
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
      IF(ITER.EQ.0) WRITE(6,500)
      WRITE(6,501) ITER, F(L1/2,M1/2,2,2),DMAX
      IF(ITER.EQ.0) WRITE(7,500)
      WRITE(7,501) ITER, F(L1/2,M1/2,2,2),DMAX
C
      IF(KSTOP.EQ.1.OR.ITER.EQ.LAST) THEN
         CALL HFLUX
         CALL PRINT 
		CALL TCPLT
C     
         WRITE(6,502) 
         WRITE(7,502) 
C
         DO 510 I=2,L2
            WRITE(6,503) X(I),ABS(QPY(I,M1)-QMY(I,M1)),
     1                   ABS(QPY(I,1)-QMY(I,1))
            WRITE(7,503) X(I),ABS(QPY(I,M1)-QMY(I,M1)),
     1                   ABS(QPY(I,1)-QMY(I,1))
 510     CONTINUE
C     
         WRITE(6,504) 
         WRITE(7,504) 
C
         DO 511 J=2,M2
            WRITE(6,503) Y(J),ABS(QPX(1,J)-QMX(1,J)),
     1                   ABS(QPX(L1,J)-QMX(L1,J))
C 
            WRITE(7,503) Y(J),ABS(QPX(1,J)-QMX(1,J)),
     1                   ABS(QPX(L1,J)-QMX(L1,J))
 511     CONTINUE
C     
      ENDIF
C
 500  FORMAT(/3X,'ITER',8X,'F',12X,'DIFF-MAX'/1X,48('*'))
 501  FORMAT(3X,I3,2(3X,1PE12.3))
 502  FORMAT(/8X,'X',10X,'QTOP',7X,'QBOT'/1X,39('*'))
 503  FORMAT(1X,3(1PE12.3))
 505  FORMAT(1X,2(F10.5))
 504  FORMAT(/8X,'Y',9X,'QLEFT',7X,'QRITE'/1X,39('*'))
C
      RETURN
C*******************************************************************
      ENTRY GAMSOR
C     
      RETURN
      END
C*******************************************************************
      


