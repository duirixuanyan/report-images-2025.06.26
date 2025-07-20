C*******************************************************************
      SUBROUTINE ADAPT
C*******************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
C*******************************************************************
C  PROBLEM 1: BLACK, SQUARE ENCLOSURE WITH ABSORBING 
C                     AND ISOTHERMAL MEDIUM
C*******************************************************************
      ENTRY GRID
C     
      TITLE(1)=' G '
      OPEN(7,FILE='PROB2m.DAT')
      OPEN(8,FILE='QBOT11m.xls') 
C

      NCVLP=4
      NCVLT=2
C
      CALL QUAD
C     
      NCVLX=5
      NCVLY=5
C
      XL=0.5
      YL=0.5
C
      CALL EZGRID
C      
      RETURN
C*******************************************************************
      ENTRY START
C     
      LAST=20
      ALPHA=10. 
C
      TEM=(1./STFAN)**(1./4.)

C
      DO 110 J=2,M2
         DO 111 I=2,L2               
            T(I,J)=TEM
            KBCL1(J)=2
            KBCJ1(I)=2 
 111      CONTINUE
 110  CONTINUE
C     
      RETURN
C*******************************************************************
      ENTRY LC
C
      RETURN
C*******************************************************************
      ENTRY OUTPUT
C     
      IF(ITER.EQ.0) WRITE(6,500)
      WRITE(6,501) ITER, F(L1/2,M1/2,2,2),DMAX
      IF(ITER.EQ.0) WRITE(7,500)
      WRITE(7,501) ITER, F(L1/2,M1/2,2,2),DMAX
C
      IF(KSTOP.EQ.1.OR.ITER.EQ.LAST) THEN
         PAUSE
         CALL HFLUX
C
       DO 521 J=1,M1
          DO 522 I=1,L1
            G(I,J)=G(I,J)/4.
 522       CONTINUE
 521    CONTINUE
C
         CALL PRINT 
         PAUSE
C     
         WRITE(6,502) 
         WRITE(7,502) 
C
         DO 510  I=2,L2
           WRITE(7,503) X(I),ABS(QPY(I,M1)-QMY(I,M1)),
     1                       ABS(QPY(I,1)-QMY(I,1))
           WRITE(8,505) X(I),ABS(QPY(I,M1)-QMY(I,M1)),
     1                       ABS(QPY(I,1)-QMY(I,1)) 
            WRITE(6,503) X(I),ABS(QPY(I,M1)-QMY(I,M1)),
     1                        ABS(QPY(I,1)-QMY(I,1))
 510      CONTINUE
C     
         WRITE(6,504) 
         WRITE(7,504) 
C
         DO 511 J=2,M2
            WRITE(6,503) Y(J),ABS(QPX(1,J)-QMX(1,J)),
     1                        ABS(QPX(L1,J)-QMX(L1,J))
            WRITE(7,503) Y(J),ABS(QPX(1,J)-QMX(1,J)),
     1                        ABS(QPX(L1,J)-QMX(L1,J))
 511      CONTINUE
C     
      ENDIF
C
 500  FORMAT(/3X,'ITER',8X,'F',12X,'DIFF-MAX'/1X,48('*'))
 501  FORMAT(3X,I3,2(3X,1PE12.3))
 502  FORMAT(/8X,'X',10X,'QTOP',7X,'QBOT'/1X,39('*'))
 503  FORMAT(1X,3(1PE12.3))
 504  FORMAT(/8X,'Y',9X,'QLEFT',7X,'QRITE'/1X,39('*'))
 505  FORMAT(1X,3(F10.5))
C
      RETURN
C*******************************************************************
      ENTRY GAMSOR
C     
      RETURN
      END
C*******************************************************************
