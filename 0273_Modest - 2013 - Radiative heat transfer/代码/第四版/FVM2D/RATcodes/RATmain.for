CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      PROGRAM RAT2D
C***********************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
C***********************************************************************
      CALL DEFLT
      CALL GRID
C     
      CALL SETUP1
C     
      CALL START
C     
      CALL SETUP2
C     
      CALL LC
C     
CHECK FOR SCATTERING
C     
      DO 5 I=2,L2
         DO 6 J=2,M2
            IF(SIGMA(I,J).NE.0.) KSIG=1
 6       CONTINUE
 5    CONTINUE
C     
      IF(KSIG.EQ.1) THEN
        IF(KISO.EQ.1) THEN
            CALL ISOTRP
         ELSE
            CALL ANISO
         ENDIF
      ENDIF
C     
      CALL OUTPUT
      DO 10 ITER1=1,LAST
         ITER=ITER1
         IF(KSTOP. EQ.1) STOP
         CALL GAMSOR
		CALL BNDRY
		CALL SMBM
         CALL HEART
		CALL BOUND
         CALL OUTPUT
 10   CONTINUE
C     
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE DEFLT
C***********************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
C***********************************************************************
      LAST=5
      MODE=1
C     
      EROR=1.E-6
      SMALL=1.E-10
      BIG=1.E20
C     
      PI=4.0*ATAN(1.0)
      PIBY2=PI/2.
      PI32=3.*PI/2.
      PI4=4.*PI
C     
      XL=1.0
      YL=1.0
C
	TL=PI
	PL=2.*PI
C     
      POWERX=1.0
      POWERY=1.0
      POWERP=1.0
      POWERT=1.0
C     
      NCVLX=20
      NCVLY=20
C     
      DO 10 NZ=1,NZMX
         XZONE(NZ)=1.
         YZONE(NZ)=1.
         NCVX(NZ)=5
         NCVY(NZ)=5
         POWRX(NZ)=1.
         POWRY(NZ)=1.
 10   CONTINUE

C     
      EPSJ1=1.
      EPSI1=1.
      EPSM1=1.
      EPSL1=1.
C     
      ALPHA=0.1
      SIG=0.0
C     
      STFAN=5.6696E-8
      KISO=1
C     
      KBOUND=0
C     
      DO 95 I=1,NI
         DO 96 J=1,NJ
            DO 97 L=1,NT 
               DO 98 M=1,NP
                  F(I,J,L,M)=0.
                  BM(I,J,L,M)=0.
                  SM(I,J,L,M)=0.
                  SC(I,J,L,M)=0.
                  SP(I,J,L,M)=0.
                  RIBI1(J,L,M)=0.
                  RIBL1(J,L,M)=0.
                  RIBJ1(I,L,M)=0.
                  RIBM1(I,L,M)=0.
 98            CONTINUE
 97         CONTINUE
            T(I,J)=0.
            RIB(I,J)=0.
            CAPPA(I,J)=ALPHA
            SIGMA(I,J)=SIG
            BETA(I,J)=CAPPA(I,J)+SIGMA(I,J)
            KBCI1(J)=1
            KBCL1(J)=1
            KBCJ1(I)=1
            KBCM1(I)=1
 96      CONTINUE
 95   CONTINUE 
C     
      DO 123 L=2,K2
         DO 124 M=2,J2
            DO 125 LL=2,K2
               DO 126 MM=2,J2
                  PHASE(L,M,LL,MM)=0.0
 126           CONTINUE
 125        CONTINUE
 124     CONTINUE
 123  CONTINUE
C     
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE SETUP
C***********************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
C***********************************************************************
      DC(ARGU)=0.5*ARGU-0.25*SIN(2.*ARGU)
      SIN2(ARG)=(1.-COS(2.*ARG))/2.0
      AM(ARGU)=AMAX1(ARGU,0.0)
C***********************************************************************
      ENTRY SETUP1
C
      L2=L1-1
      L3=L2-1
      M2=M1-1
      M3=M2-1
      K2=K1-1
      K3=K2-1
      J2=J1-1
      J3=J2-1
C     
COME  HERE TO CALCULATE X-DIRECTION GRID
C     
      X(1)=XU(2)
      DO 5 I=2,L2
         X(I)=0.5*(XU(I+1)+XU(I))
         XCV(I)=XU(I+1)-XU(I)
 5    CONTINUE
      X(L1)=XU(L1)
C     
COME  HERE TO CALCULATE Y-DIRECTION GRID
C     
      Y(1)=YV(2)
      DO 10 J=2,M2
         Y(J)=0.5*(YV(J+1)+YV(J))
         YCV(J)=YV(J+1)-YV(J)
 10   CONTINUE
      Y(M1)=YV(M1)
C     
CALCULATIONS OF CONTROL VOLUME VOLUMES  
C     
      DO 15 J=2,M2
         DO 16 I=2,L2
            VOL(I,J)=XCV(I)*YCV(J)
 16      CONTINUE
 15   CONTINUE
C     
CALCULATIONSOF THETA-DIRECTION GRID
C     
      THETA(1)=THETAI(2)
      DO 20 L=2,K2
         THETA(L)=0.5*(THETAI(L+1)+THETAI(L))
 20   CONTINUE
      THETA(K1)=THETAI(K1)
C     
CALCULATIONSOF PHI-DIRECTION GRID
C     
      PHI(1)=PHII(2)
      DO 30 M=2,J2
         PHI(M)=0.5*(PHII(M+1)+PHII(M))
 30   CONTINUE
      PHI(J1)=PHII(J1)      
C     
CALCULATIONSOF CONTROL ANGLES AND "DIRECTION COSINES"
C     
      DO 40 M=2,J2
         PHIM=PHI(M)
         IF(PHIM.LT.PIBY2) MPHI2=M
         IF(PHIM.LT.PI) MPHI3=M
         IF(PHIM.LT.PI32) MPHI4=M
         TERM1=COS(PHII(M+1))-COS(PHII(M))
         TERM2=SIN(PHII(M+1))-SIN(PHII(M))
         TERM3=PHII(M+1)-PHII(M)
         DO 41 L=2,K2
            IF(THETA(L).LT.PIBY2) LTETA2=L
            TERM4=DC(THETAI(L+1))-DC(THETAI(L))
            TERM5=(SIN2(THETAI(L+1))-SIN2(THETAI(L)))/2.
            DCX(L,M)= TERM2*TERM4
            DCY(L,M)=-TERM1*TERM4
            IF(ABS(DCX(L,M)).LT.1.E-5) DCX(L,M)=0.0
            IF(ABS(DCY(L,M)).LT.1.E-5) DCY(L,M)=0.0
            DOM(L,M)=-(COS(THETAI(L+1))-COS(THETAI(L)))*TERM3
 41      CONTINUE
 40   CONTINUE
C     
	DO 50 L=2,K2
		DO 51 M=2,J2
			DO 52 J=2,M2
				AX(J,L,M)=ABS(DCX(L,M)*YCV(J))
 52			CONTINUE
			DO 53 I=2,L2
				AY(I,L,M)=ABS(DCY(L,M)*XCV(I))
 53			CONTINUE
 51		CONTINUE
 50	CONTINUE
C
      MP2P1=MPHI2+1
      MP3P1=MPHI3+1
      MP4P1=MPHI4+1
      LT2P1=LTETA2+1
C     
CAUTION**** XCV(1),XCV(L1),YCV(1),YCV(M1) ARE NOT USED.  ****
      XCV(1)=SMALL
      XCV(L1)=SMALL
      YCV(1)=SMALL
      YCV(M1)=SMALL
C     
	PRINT 2
      PRINT 55
C     
 2    FORMAT(//15X,
     1     'COMPUTATION IN  TWO-DIMENSIONAL  CARTESIAN COORDINATES')
 55   FORMAT(14X,56(1H*),//)
C     
      RETURN
C***********************************************************************
      ENTRY SETUP2
C     
COME  HERE TO SPECIFY BOUNDARY EMISSION FROM THE EAST AND WEST WALLS
C     
      DO 60 J=2,M2
		IF(KBCI1(J).EQ.1) THEN
			DO 62 L=2,K2
				DO 63 M=2,MPHI2
                  RIBI1(J,L,M)=STFAN*T(1,J)**4/PI
 63            CONTINUE
				DO 64 M=MP4P1,J2
                  RIBI1(J,L,M)=STFAN*T(1,J)**4/PI
 64            CONTINUE
 62         CONTINUE
		ENDIF
		IF(KBCL1(J).EQ.1) THEN
			DO 65 L=2,K2
				DO 66 M=MP2P1,MPHI4
                  RIBL1(J,L,M)=STFAN*T(L1,J)**4/PI
 66            CONTINUE
 65         CONTINUE
		ENDIF
 60   CONTINUE
C     
COME HERE TO SPECIFY BOUNDARY EMISSIONS FROM THE NORTH AND SOUTH WALLS
C     
      DO 70 I=2,L2
		IF(KBCJ1(I).EQ.1) THEN
            DO 72 L=2,K2
               DO 73 M=2,MPHI3
                  RIBJ1(I,L,M)=STFAN*T(I,1)**4/PI
 73            CONTINUE
 72         CONTINUE
		ENDIF
		IF(KBCM1(I).EQ.1) THEN
            DO 75 L=2,K2
               DO 76 M=MP3P1,J2
                  RIBM1(I,L,M)=STFAN*T(I,M1)**4/PI
 76            CONTINUE
 75         CONTINUE
		ENDIF
 70   CONTINUE
C     
COME  HERE TO SPECIFY EMISSION FROM THE MEDIUM
C     
      DO 90 I=2,L2
         DO 91 J=2,M2
            RIB(I,J)=STFAN*T(I,J)**4/PI
            CAPPA(I,J)=ALPHA
            SIGMA(I,J)=SIG
            BETA(I,J)=CAPPA(I,J)+SIGMA(I,J)               
 91      CONTINUE
 90   CONTINUE
C     
COME  HERE TO UPDATE REFLECTIVITIES
C     
      RHOJ1=1-EPSJ1
      RHOI1=1-EPSI1
      RHOM1=1-EPSM1
      RHOL1=1-EPSL1
C     
      RETURN
	END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE HEART
C***********************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
C***********************************************************************
      AM(ARGU)=AMAX1(ARGU,0.0)
C***********************************************************************
      KSTOP=1
      DMAX=-1000.
C
COME HERE TO START FROM THE SOUTH-WEST CORNER (I=2, J=2)
	DO 10 J=2,M2
		DO 11 I=2,L2
			DO 12 L=2,K2
				DO 13 M=2,MPHI2
                  VOLM=VOL(I,J)*DOM(L,M)
					RNUM=AX(J,L,M)*F(I-1,J,L,M)+
     1					  AY(I,L,M)*F(I,J-1,L,M)+
     2                 VOLM*SM(I,J,L,M)
			DENO=AX(J,L,M)+AY(I,L,M)+BM(I,J,L,M)*VOLM
					FOLD=F(I,J,L,M)
                  F(I,J,L,M)=RNUM/(DENO+SMALL)
                  DIFF=ABS(F(I,J,L,M)-FOLD)/(F(I,J,L,M)+SMALL)
                  DMAX=AMAX1(DMAX,DIFF)
                  IF(DMAX.GT.EROR) KSTOP=0
 13            CONTINUE
 12         CONTINUE
 11      CONTINUE
 10   CONTINUE
C
COME HERE TO START FROM THE SOUTH-EAST CORNER (I=L2, J=2)
	DO 20 J=2,M2
		DO 21 I=L2,2,-1
			DO 22 L=2,K2
				DO 23 M=MP2P1,MPHI3
                  VOLM=VOL(I,J)*DOM(L,M)
					RNUM=AX(J,L,M)*F(I+1,J,L,M)+
     1					  AY(I,L,M)*F(I,J-1,L,M)+
     2                 VOLM*SM(I,J,L,M)
			DENO=AX(J,L,M)+AY(I,L,M)+BM(I,J,L,M)*VOLM
					FOLD=F(I,J,L,M)
                  F(I,J,L,M)=RNUM/(DENO+SMALL)
                  DIFF=ABS(F(I,J,L,M)-FOLD)/(F(I,J,L,M)+SMALL)
                  DMAX=AMAX1(DMAX,DIFF)
                  IF(DMAX.GT.EROR) KSTOP=0
 23            CONTINUE
 22         CONTINUE
 21      CONTINUE
 20   CONTINUE
C
COME HERE TO START FROM THE NORTH-WEST CORNER (I=2, J=M2)
	DO 110 J=M2,2,-1
		DO 111 I=2,L2
			DO 112 L=2,K2
				DO 113 M=MP4P1,J2
                  VOLM=VOL(I,J)*DOM(L,M)
					RNUM=AX(J,L,M)*F(I-1,J,L,M)+
     1					  AY(I,L,M)*F(I,J+1,L,M)+
     2                 VOLM*SM(I,J,L,M)
			DENO=AX(J,L,M)+AY(I,L,M)+BM(I,J,L,M)*VOLM
					FOLD=F(I,J,L,M)
                  F(I,J,L,M)=RNUM/(DENO+SMALL)
                  DIFF=ABS(F(I,J,L,M)-FOLD)/(F(I,J,L,M)+SMALL)
                  DMAX=AMAX1(DMAX,DIFF)
                  IF(DMAX.GT.EROR) KSTOP=0
 113           CONTINUE
 112        CONTINUE
 111     CONTINUE
 110  CONTINUE
C
COME HERE TO START FROM THE NORTH-EAST CORNER (I=L2, J=M2)
	DO 120 J=M2,2,-1
		DO 121 I=L2,2,-1
			DO 122 L=2,K2
				DO 123 M=MP3P1,MPHI4
                  VOLM=VOL(I,J)*DOM(L,M)
					RNUM=AX(J,L,M)*F(I+1,J,L,M)+
     1					  AY(I,L,M)*F(I,J+1,L,M)+
     2                 VOLM*SM(I,J,L,M)
			DENO=AX(J,L,M)+AY(I,L,M)+BM(I,J,L,M)*VOLM
					FOLD=F(I,J,L,M)
                  F(I,J,L,M)=RNUM/(DENO+SMALL)
                  DIFF=ABS(F(I,J,L,M)-FOLD)/(F(I,J,L,M)+SMALL)
                  DMAX=AMAX1(DMAX,DIFF)
                  IF(DMAX.GT.EROR) KSTOP=0
 123           CONTINUE
 122        CONTINUE
 121     CONTINUE
 120  CONTINUE
C
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE SMBM
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     
      DO 11 J=2,M2
         DO 12 I=2,L2
            DO 13 L=2,K2
               DO 14 M=2,J2
                  SMSUM=0.
                  IF(SIGMA(I,J).NE.0.) THEN
                     DO 15 LL=2,K2
                        DO 16 MM=2,J2
                           SMSUM=SMSUM+PHASE(LL,MM,L,M)
     1                          *DOM(LL,MM)*F(I,J,LL,MM)
 16                     CONTINUE
 15                  CONTINUE
                     SMSUM=SMSUM-PHASE(L,M,L,M)*DOM(L,M)
     1                    *F(I,J,L,M)
                  ENDIF
                  BM(I,J,L,M)=CAPPA(I,J)+SIGMA(I,J)*
     1                 (1.-PHASE(L,M,L,M)*DOM(L,M)/PI4)
                  SM(I,J,L,M)=CAPPA(I,J)*RIB(I,J)
     1                 +SIGMA(I,J)*SMSUM/PI4
 14            CONTINUE
 13         CONTINUE
 12      CONTINUE
 11   CONTINUE
C     
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE BNDRY
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     
      DO 100 I=2,L2
         IF(KBCJ1(I).EQ.1) THEN 
            CALL WLSUM(I,1,K2,J2,-1,DCY,F,SSUM)
            DO 102 L=2,K2
               DO 103 M=2,MPHI3
                  F(I,1,L,M)=EPSJ1*RIBJ1(I,L,M)+RHOJ1*SSUM/PI
 103           CONTINUE
 102        CONTINUE
         ELSEIF(KBCJ1(I).EQ.2) THEN
            DO 104 L=2,K2
               DO 105 M=2,MPHI3
                  MM=J2-(M-2)
                  F(I,1,L,M)=F(I,1,L,MM)
 105           CONTINUE
 104        CONTINUE
         ENDIF
C     
         IF(KBCM1(I).EQ.1) THEN
            CALL WLSUM(I,M1,K2,J2,1,DCY,F,RNSUM)
            DO 412 L=2,K2
               DO 413 M=MP3P1,J2
                  F(I,M1,L,M)=EPSM1*RIBM1(I,L,M)+RHOM1*RNSUM/PI
 413           CONTINUE
 412        CONTINUE
         ELSEIF(KBCM1(I).EQ.2) THEN
            DO 414 L=2,K2
               DO 415 M=MP3P1,J2
                  MM=MPHI3-(M-MP3P1)
                  F(I,M1,L,M)=F(I,M1,L,MM)
 415           CONTINUE
 414        CONTINUE
         ENDIF
 100  CONTINUE
C     
      DO 500 J=2,M2
         IF(KBCI1(J).EQ.1) THEN
            CALL WLSUM(1,J,K2,J2,-1,DCX,F,WSUM)
            DO 501 L=2,K2
               DO 502 M=2,MPHI2
                  F(1,J,L,M)=EPSI1*RIBI1(J,L,M)+RHOI1*WSUM/PI
 502           CONTINUE
               DO 503 M=MP4P1,J2
                  F(1,J,L,M)=EPSI1*RIBI1(J,L,M)+RHOI1*WSUM/PI
 503           CONTINUE
 501        CONTINUE
         ELSEIF(KBCI1(J).EQ.2) THEN
            DO 504 L=2,K2
               DO 505 M=2,MPHI2
                  MM=MPHI3-(M-2)
                  F(1,J,L,M)=F(1,J,L,MM)
 505           CONTINUE
               DO 515 M=MP4P1,J2
                  MM=MPHI4-(M-MP4P1)
                  F(1,J,L,M)=F(1,J,L,MM)
 515           CONTINUE
 504        CONTINUE
         ENDIF
C     
         IF(KBCL1(J).EQ.1) THEN
            CALL WLSUM(L1,J,K2,J2,1,DCX,F,ESUM)
            DO 508 L=2,K2
               DO 509 M=MP2P1,MPHI4
                  F(L1,J,L,M)=EPSL1*RIBL1(J,L,M)+RHOL1*ESUM/PI
 509           CONTINUE
 508        CONTINUE
         ELSEIF(KBCL1(J).EQ.2) THEN
            DO 1510 L=2,K2
               DO 1511 M=MP2P1,MPHI3
                  MM=MPHI2-(M-MP2P1)
                  F(L1,J,L,M)=F(L1,J,L,MM)
 1511          CONTINUE
               DO 1514 M=MP3P1,MPHI4
                  MM=J2-(M-MP3P1)
                  F(L1,J,L,M)=F(L1,J,L,MM)
 1514          CONTINUE
 1510       CONTINUE
         ENDIF
 500  CONTINUE
C     
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE BOUND
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      DO 10 J=2,M2
         DO 11 L=2,K2
            DO 12 M=MP2P1,MPHI4
               F(1,J,L,M)=F(2,J,L,M)
 12			CONTINUE
			DO 13 M=2,MPHI2
               F(L1,J,L,M)=F(L2,J,L,M)
 13         CONTINUE
			DO 14 M=MP4P1,J2
               F(L1,J,L,M)=F(L2,J,L,M)
 14         CONTINUE
 11      CONTINUE
 10   CONTINUE
C     
      DO 20 I=2,L2
         DO 21 L=2,K2
            DO 22 M=2,MPHI3
				F(I,M1,L,M)=F(I,M2,L,M)
 22			CONTINUE
            DO 23 M=MP3P1,J2
               F(I,1,L,M)=F(I,2,L,M)
 23         CONTINUE
 21      CONTINUE
 20   CONTINUE
C     
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE WLSUM(I,J,K2,J2,INDX,DC,FC,SUM)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      INCLUDE 'PARAM.FOR'
      DIMENSION DC(NT,NP),FC(NI,NJ,NT,NP)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     
      SUM=0.
      IF(INDX.GT.0) THEN
         DO 10 L=2,K2
            DO 20 M=2,J2
               SUM=SUM+FC(I,J,L,M)*AMAX1(DC(L,M),0.0)
 20         CONTINUE
 10      CONTINUE
      ELSE
         DO 30 L=2,K2
            DO 40 M=2,J2
               SUM=SUM+FC(I,J,L,M)*AMAX1(-DC(L,M),0.0)
 40         CONTINUE
 30      CONTINUE
      ENDIF
C     
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE PHASEF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
      DIMENSION PSUB(NP,NPSUB),TSUB(NT,NPSUB),
     1          PSUBI(NP,NPSUB),TSUBI(NT,NPSUB)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     
      ENTRY ISOTRP
C     
      DO 10 L=2,K2
         DO 20 M=2,J2
            DO 30 LL=2,K2
               DO 40 MM=2,J2
                  PHASE(LL,MM,L,M)=1.0
 40            CONTINUE
 30         CONTINUE
 20      CONTINUE
 10   CONTINUE
C
      RETURN
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      ENTRY ANISO
C     
      NSUB=5
      CALL PCOEF
C     
      DO 2000 M=2,J2
         PLOW=PHII(M)
         PHIGH=PHII(M+1)
         CALL PHISUB(PLOW,PHIGH,NSUB,PSUB,PSUBI,M)
         DPHI=(PHIGH-PLOW)/NSUB
         DO 2100 L=2,K2
            TLOW=THETAI(L)
            THIGH=THETAI(L+1)
            CALL TETASUB(TLOW,THIGH,DPHI,NSUB,TSUB,TSUBI,L)
 2100     CONTINUE
 2000  CONTINUE
C     
      DO 2200 M=2,J2
         PHIL=PHI(M)
         DO 2210 L=2,K2
            TETAK=THETA(L)
            DO 2300 MM=2,J2
               DO 2310 LL=2,K2
                  SUMLL=0.0
                  DO 2220 MS=2,NSUB+1
                     PLSSUB=PSUB(M,MS)
                     TERMA=PSUBI(M,MS+1)-PSUBI(M,MS)
                     DO 2230 LS=2,NSUB+1
                        TKSSUB=TSUB(L,LS)
                        TERMB=COS(TSUBI(L,LS+1))-COS(TSUBI(L,LS))
                        DOMA=-TERMA*TERMB
                        XMU=SIN(TKSSUB)*COS(PLSSUB)
                        PSI=SIN(TKSSUB)*SIN(PLSSUB)
                        ETA=COS(TKSSUB)
                        DO 2410 MMS=2,NSUB+1
                           PLSUB=PSUB(MM,MMS)
                           TERM1=PSUBI(MM,MMS+1)-PSUBI(MM,MMS)
                           DO 2420 LLS=2,NSUB+1
                              TKSUB=TSUB(LL,LLS)
                              XMUL=SIN(TKSUB)*COS(PLSUB)
                              PSIL=SIN(TKSUB)*SIN(PLSUB)
                              ETAL=COS(TKSUB)
                              ANG=XMU*XMUL+PSI*PSIL+ETA*ETAL
                              SUM=1.0
                              DO 2500 MO=1,MORDER
                                 SUM=SUM+A(MO)*PLCOS(MO,ANG,SMALL)
 2500                          CONTINUE
                              TERM2=COS(TSUBI(LL,LLS+1))-
     1                            COS(TSUBI(LL,LLS))
                              DOMS=-TERM1*TERM2
                              SUMLL=SUMLL+SUM*DOMS*DOMA
 2420                      CONTINUE
 2410                   CONTINUE
 2230                CONTINUE
 2220             CONTINUE
                  PHASE(LL,MM,L,M)=SUMLL/DOM(LL,MM)/DOM(L,M)
 2310          CONTINUE
 2300        CONTINUE
 2210     CONTINUE
 2200  CONTINUE
C     
       CALL PNORM
C
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE PHISUB(PLOW,PHIGH,NSUB,PSUB,PSUBI,L)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      INCLUDE 'PARAM.FOR'
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      DIMENSION PSUBI(NP,NPSUB),PSUB(NP,NPSUB)
C
      NSUBK=NSUB+2
      PSUBI(L,2)=PLOW
      PSUBI(L,NSUBK)=PHIGH
      DPHI=(PHIGH-PLOW)/FLOAT(NSUB)
C
      DO 10 LL=3,NSUBK-1
         PSUBI(L,LL)=PSUBI(L,LL-1)+DPHI
 10   CONTINUE
C     
      PSUB(L,1)=PSUBI(L,2)
      DO 20 LL=2,NSUBK-1
         PSUB(L,LL)=0.5*(PSUBI(L,LL)+PSUBI(L,LL+1))
 20   CONTINUE
      PSUB(L,NSUBK)=PSUBI(L,NSUBK)
C     
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE TETASUB(TLOW,THIGH,DPHI,NSUB,TSUB,TSUBI,K)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      INCLUDE 'PARAM.FOR'
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      DIMENSION TSUBI(NT,NPSUB),TSUB(NT,NPSUB)
C
      NSUBL=NSUB+2
      TSUBI(K,2)=TLOW
      TSUBI(K,NSUBL)=THIGH
      DPHI=(THIGH-TLOW)/FLOAT(NSUB)
      DO 10 KK=3,NSUBL-1
         TSUBI(K,KK)=TSUBI(K,KK-1)+DPHI
 10   CONTINUE
C
      TSUB(K,1)=TSUBI(K,2)
      DO 20 KK=2,NSUBL-1
         TSUB(K,KK)=0.5*(TSUBI(K,KK)+TSUBI(K,KK+1))
 20   CONTINUE
      TSUB(K,NSUBL)=TSUBI(K,NSUBL)
C     
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE PCOEF
C******************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
      COMPLEX IOR
C***********************************************************************
C
C   KPHASE     PHASE FUNCTION
C -------------------------------
C
C     2             F1
C     3             F2
C     6             B1
C     7             B2
C
C      
         IF(KPHASE.EQ.1) IPH=0
         IF(KPHASE.EQ.2) IPH=2
         IF(KPHASE.EQ.3) IPH=4
         IF(KPHASE.EQ.4) IPH=5
         IF(KPHASE.EQ.5) IPH=6
         IF(KPHASE.EQ.6) IPH=10
         IF(KPHASE.EQ.7) IPH=20

C--- FORWARD SCATTERING PHASE FUNCTIONS.
      IF(IPH.EQ.100)THEN
      MORDER =1
c      A(0)  =1.0
      A(1)  =3.*0.30
      ENDIF
C-----
      IF(IPH.EQ.0) THEN
      XSIZ  = 999.
      IOR   = (999.,999.)
      QSCA  = 999.
      QABS  = 999.
      MORDER = 26
c      A(0)  = 1.0
      A(1)  = 2.78197
      A(2)  = 4.25856
      A(3)  = 5.38653
      A(4)  = 6.19015
      A(5)  = 6.74492
      A(6)  = 7.06711
      A(7)  = 7.20999
      A(8)  = 7.20063
      A(9)  = 7.03629
      A(10) = 6.76587
      A(11) = 6.35881
      A(12) = 5.83351
      A(13) = 5.22997
      A(14) = 4.47918
      A(15) = 3.69000
      A(16) = 2.81577
      A(17) = 1.92305
      A(18) = 1.11502
      A(19) = 0.50766
      A(20) = 0.20927
      A(21) = 0.07138
      A(22) = 0.02090
      A(23) = 0.00535
      A(24) = 0.00120
      A(25) = 0.00024
      A(26) = 0.00004
      ENDIF
C -----
      IF(IPH.EQ.1) THEN
      XSIZE =10.0
      IOR =(1.33,0.0)
      QSCA=2.20654869
      QABS=0.0
      GFAC=0.71245915
      MORDER=20
c      A(0)=1.0000000
      A(1)=2.1373777
      A(2)=2.9336057
      A(3)=2.8347003
      A(4)=2.7405264
      A(5)=2.6281443
      A(6)=2.5408404
      A(7)=2.6078286
      A(8)=2.7392752
      A(9)=2.9413168
      A(10)=3.2081311
      A(11)=3.4706223
      A(12)=3.7823384
      A(13)=4.1312394
      A(14)=4.2848716
      A(15)=4.7362566
      A(16)=4.4471574
      A(17)=4.3439150
      A(18)=3.3834202
      A(19)=2.2265594
      A(20)=1.3012373
      ENDIF
C -----
      IF(IPH.EQ.2) THEN
      XSIZE =   5.0
      IOR   =  (1.33,0.0)
      QSCA  =   3.59103251
      QABS  =   0.0
      GFAC  =   0.84534043
      MORDER =   12
c      A(0)  =   1.0
      A(1)  =   2.5360217
      A(2)  =   3.5654900
      A(3)  =   3.9797626
      A(4)  =   4.0029206
      A(5)  =   3.6640084
      A(6)  =   3.0160117
      A(7)  =   2.2330437
      A(8)  =   1.3025078
      A(9)  =   0.5346286
      A(10) =   0.2013563
      A(11) =   0.0547964
      A(12) =   0.0109929
      ENDIF
C-----
      IF(IPH.EQ.3) THEN
      XSIZE =3.0
      IOR =(1.33,0.0)
      QSCA=1.75339794
      QABS=0.0
      GFAC=0.78320068
      MORDER=9
c      A(0)  =   1.0000000
      A(1)  =   2.3496020
      A(2)  =   2.7382560
      A(3)  =   2.3145776
      A(4)  =   1.3907945
      A(5)  =   0.5534959
      A(6)  =   0.1744258
      A(7)  =   0.0401137
      A(8)  =   0.0069153
      A(9)  =   0.0008899
      ENDIF
C-----
      IF(IPH.EQ.4) THEN
      XSIZE =  2.0
      IOR   = (1.33,0.0)
      QSCA  =  0.71294856
      QABS  =  0.0
      MORDER =  8
c      A(0)  =  1.0
      A(1)  =  2.0091653
      A(2)  =  1.5633900
      A(3)  =  0.6740690
      A(4)  =  0.2221484
      A(5)  =  0.0472529
      A(6)  =  0.0067132
      A(7)  =  0.0006743
      A(8)  =  0.0000494
      ENDIF
C-----
      IF(IPH.EQ.5) THEN
      XSIZE =1.0
      IOR =(1.33,0.0)
      QSCA=9.39240903E-02
      QABS=0.0
      GFAC=0.18451715
      MORDER=6
c      A(0)  =   1.0000000
      A(1)  =   0.5535514
      A(2)  =   0.5600496
      A(3)  =   0.1157242
      A(4)  =   0.0107823
      A(5)  =   0.0005812
      A(6)  =   0.0000230
      ENDIF
C-----
      IF(IPH.EQ.6) THEN
      XSIZE = 999.
      IOR   =(999.,999.)
      QSCA  = 999.
      QABS  = 999.
      MORDER = 2
c      A(0)  = 1.0
      A(1)  = 1.2
      A(2)  = 0.5
      ENDIF
C
C-----
      IF(IPH.EQ.7) THEN
      XSIZE = 999.
      IOR   =(999.,999.)
      QSCA  = 999.
      QABS  = 999.
      MORDER = 1
c      A(0)  = 1.0
      A(1)  = 1.0
      ENDIF
C
C-----------------------------------------------------------
C--- BACKWARD SCATTERING PHASE FUNCTIONS.
      IF(IPH.EQ.10) THEN
         XSIZE = 999.
         IOR   =(999.,999.)
         QSCA  = 999.
         QABS  = 999.
         MORDER = 5
c         A(0)  = 1.0
         A(1)  =-0.56524
         A(2)  = 0.29783
         A(3)  = 0.08571
         A(4)  = 0.01003
         A(5)  = 0.00063
      ENDIF
C-----
      IF(IPH.EQ.20) THEN
         XSIZE = 999.
         IOR   =(999.,999.)
         QSCA  = 999.
         QABS  = 999.
         MORDER = 2
c         A(0)  = 1.0
         A(1)  =-1.2
         A(2)  = 0.5
      ENDIF
C
C-----
      IF(IPH.EQ.30) THEN
         XSIZE = 999.
         IOR   =(999.,999.)
         QSCA  = 999.
         QABS  = 999.
         MORDER = 1
c         A(0)  = 1.0
         A(1)  = -1.0
      ENDIF
C
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE PNORM
C******************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
      DIMENSION PHOLD(NT,NP,NT,NP)
C***********************************************************************
C     
      DO 10 L=2,K2
         DO 20 M=2,J2
            SUM=0.0
            DO 30 LL=2,K2
               DO 40 MM=2,J2
                  SUM=SUM+PHASE(LL,MM,L,M)*DOM(LL,MM)
 40            CONTINUE
 30         CONTINUE
C     
            FACT=SUM/(4.*PI)
C     
            DO 50 LL=2,K2
               DO 60 MM=2,J2
                  PHOLD(LL,MM,L,M)=PHASE(LL,MM,L,M)
                  PHASE(LL,MM,L,M)=PHASE(LL,MM,L,M)/(FACT+SMALL)
 60            CONTINUE
 50         CONTINUE
 20      CONTINUE
 10   CONTINUE
C
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      FUNCTION PLCOS(L,X,SMALL)
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C     
C     COMPUTES THE LEGENDRE POLYNOMIAL P-SUB-L.
C     X IS IN THE RANGE FROM -1 TO +1.
C     
C     MODIFIED FROM "NUMERICAL RECIPES, THE ART OF SCIENTIFIC COMPUTING' BY
C     W. H. PRESS, B. P. FLANNERY, S. A. TEUKOLSKY, W. T. VETTERLING
C     ORIGINAL FUNCTION NAME = PLGNDR
C     
cc      IF(L.LT.1.OR.ABS(X).GT.1.+SMALL) PRINT*,'CHECK ANG',X
C     
      PMM=1.
      PMMP1=X
      IF(L.EQ.1) THEN
         PLCOS=PMMP1
C     
      ELSE
         DO 12 LL=2,L
            PLL=(X*(2*LL-1)*PMMP1-(LL-1)*PMM)/(LL)
            PMM=PMMP1
            PMMP1=PLL
 12      CONTINUE
         PLCOS=PLL
      ENDIF
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE SUPPLY
C******************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
C******************************************************************
    7 FORMAT(/1X,6(1H*),3X,A18,3X,6(1H*)/9X,20(1H-))
    8 FORMAT(/'  I =',I6,6I9) 
    9 FORMAT('  J') 
   10 FORMAT(26(1H*),3X,A10,3X,26(1H*))
   20 FORMAT(4H I =,I6,6I9)
   30 FORMAT(1HJ)
   40 FORMAT(1X,I2,3X,1P7E9.2)
   50 FORMAT(1H )
   51 FORMAT(1X,'I =',2X,7(I4,5X))
   52 FORMAT(1X,'X =',1P7E9.2)
   53 FORMAT(1X,'TH =',1P7E9.2)
   54 FORMAT(1X,'J =',2X,7(I4,5X))
   55 FORMAT(1X,'Y =',1P7E9.2)
   62 FORMAT(1X,'XU=',1P7E9.2)
   65 FORMAT(1X,'YV=',1P7E9.2)
 56   FORMAT(1X,'K =',2X,7(I4,5X))
 57   FORMAT(1X,'Z =',1P7E9.2)
 58   FORMAT(1X,'L =',2X,7(I4,5X))
 59   FORMAT(1X,'TH =',1P7E9.2)
 60   FORMAT(1X,'M =',2X,7(I4,5X))
 61   FORMAT(1X,'PH =',1P7E9.2)
C******************************************************************
      ENTRY EZGRID
C
CONSTRUCT THE X-DIRECTION GRID
      L1=NCVLX+2
      XU(1)=XU(2)
      XU(L1)=XL+XU(2)
      L2=L1-1
      FCVLX=FLOAT(NCVLX)
      DO 21 I=3,L2
      DD=FLOAT(I-2)/FCVLX
      IF(POWERX.GT.0.) THEN
      XU(I)=XL*DD**POWERX+XU(2)
      ELSE
      XU(I)=XL*(1.-(1.-DD)**(-POWERX))+XU(2)
      ENDIF
 21   CONTINUE
CONSTRUCT THE Y-DIRECTION GRID
      M1=NCVLY+2
      YV(2)=0.
      YV(M1)=YL
      M2=M1-1
      FCVLY=FLOAT(NCVLY)
      DO 31 J=3,M2
      DD=FLOAT(J-2)/FCVLY
      IF(POWERY.GT.0.) THEN
      YV(J)=YL*DD**POWERY
      ELSE
      YV(J)=YL*(1.-(1.-DD)**(-POWERY))
      ENDIF
 31   CONTINUE   
C     
      RETURN
C*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
      ENTRY ZGRID
CONSTRUCT THE GRID ZONE-BY-ZONE
C
CONSIDER THE X DIRECTION
      XU(1)=XU(2)
      I2=2
      DO 1101 NZ=1,NZX
      FCVLX=FLOAT(NCVX(NZ))
      ILAST=I2
      I1=ILAST+1
      I2=ILAST+NCVX(NZ)
      DO 1101 I=I1,I2
      DD=FLOAT(I-ILAST)/FCVLX
      IF(POWRX(NZ).GT.0.) THEN
      XU(I)=XU(ILAST)+XZONE(NZ)*DD**POWRX(NZ)
      ELSE
      XU(I)=XU(ILAST)+XZONE(NZ)*(1.-(1.-DD)**(-POWRX(NZ)))
      ENDIF
 1101 CONTINUE
      L1=I2
C
CONSIDER THE Y DIRECTION
      YV(2)=0.
      JJ2=2
      DO 1100 NZ=1,NZY
      FCVLY=FLOAT(NCVY(NZ))
      JLAST=JJ2
      JJ1=JLAST+1
      JJ2=JLAST+NCVY(NZ)
      DO 1100 J=JJ1,JJ2
      DD=FLOAT(J-JLAST)/FCVLY
      IF(POWRY(NZ).GT.0.) THEN
      YV(J)=YV(JLAST)+YZONE(NZ)*DD**POWRY(NZ)
      ELSE
      YV(J)=YV(JLAST)+YZONE(NZ)*(1.-(1.-DD)**(-POWRY(NZ)))
      ENDIF
 1100 CONTINUE
      M1=JJ2
      RETURN  
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      ENTRY QUAD
C     
CONSTRUCT THE PHI-DIRECTION GRID
      J1=NCVLP+2
      PHII(2)=0.
      PHII(J1)=PL
      J2=J1-1
      FCVLP=FLOAT(NCVLP)
      DO 4 M=3,J2
      DD=FLOAT(M-2)/FCVLP
      IF(POWERP.GT.0.) THEN
      PHII(M)=PL*DD**POWERP
      ELSE
      PHII(M)=PL*(1.-(1.-DD)**(-POWERP))
      ENDIF
 4    CONTINUE
C     
CONSTRUCT THE THETA-DIRECTION GRID      
C     
      K1=NCVLT+2
      THETAI(2)=0.
      THETAI(K1)=TL
      K2=K1-1
      FCVLT=FLOAT(NCVLT)
      DO 5 L=3,K2
         DD=FLOAT(L-2)/FCVLT
         IF(POWERT.GT.0.) THEN
            THETAI(L)=TL*DD**POWERT
         ELSE
            THETAI(L)=TL*(1.-(1.-DD)**(-POWERT))
         ENDIF
 5    CONTINUE
C
      RETURN  
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      ENTRY PRINT
C     
      PRINT 50
      WRITE(7,50)
      IEND=0
 301  IF(IEND.EQ.L1) GO TO 310
      IBEG=IEND+1
      IEND=IEND+7
      IEND=MIN0(IEND,L1)
      PRINT 50
	WRITE(7,50)
      PRINT 51,(I,I=IBEG,IEND)
      WRITE(7,51)(I,I=IBEG,IEND)
      IF(MODE.EQ.3) GO TO 302
      PRINT 52,(X(I),I=IBEG,IEND)
      PRINT 62,(XU(I),I=IBEG,IEND)
      WRITE(7,52)(X(I),I=IBEG,IEND)
      WRITE(7,62)(XU(I),I=IBEG,IEND)
      GO TO 303
 302  PRINT 53,(X(I),I=IBEG,IEND)
	WRITE(7,53)(X(I),I=IBEG,IEND)
 303  GO TO 301
 310  JEND=0
      PRINT 50
	WRITE(7,50)
 311  IF(JEND.EQ.M1) GO TO 320
      JBEG=JEND+1
      JEND=JEND+7
      JEND=MIN0(JEND,M1)
      PRINT 50
      PRINT 54,(J,J=JBEG,JEND)
      PRINT 55,(Y(J),J=JBEG,JEND)
      PRINT 55,(YV(J),J=JBEG,JEND)
      WRITE(7,50)
      WRITE(7,54)(J,J=JBEG,JEND)
      WRITE(7,55)(Y(J),J=JBEG,JEND)
      WRITE(7,65)(YV(J),J=JBEG,JEND)
      GO TO 311
 320  JEND=0
      PRINT 50
      WRITE(7,50)
 331  IF(JEND.EQ.K1) GO TO 340
      JBEG=JEND+1
      JEND=JEND+7
      JEND=MIN0(JEND,K1)
      PRINT 50
      PRINT 58,(J,J=JBEG,JEND)
      PRINT 59,(THETA(J),J=JBEG,JEND)
      WRITE(7,50)
      WRITE(7,58)(J,J=JBEG,JEND)
      WRITE(7,59)(THETA(J),J=JBEG,JEND)
      GO TO 331
 340  JEND=0
      PRINT 50
      WRITE(7,50)
 341  IF(JEND.EQ.J1) GO TO 350
      JBEG=JEND+1
      JEND=JEND+7
      JEND=MIN0(JEND,J1)
      PRINT 50
      PRINT 60,(J,J=JBEG,JEND)
      PRINT 61,(PHI(J),J=JBEG,JEND)
      WRITE(7,50)
      WRITE(7,60)(J,J=JBEG,JEND)
      WRITE(7,61)(PHI(J),J=JBEG,JEND)
      GO TO 341
 350  CONTINUE
C
      WRITE(6,7) TITLE(1)
      WRITE(7,7) TITLE(1)
      IBEG=1
      JBEG=1
      IEND=l1
      JEND=m1
      IREP=(IEND-IBEG+7)/7
      DO 551 KP=1,IREP
         INCR=MIN(6,IEND-IBEG)
         ISTOP=IBEG+INCR
         WRITE(6,8) (I,I=IBEG,ISTOP)
         WRITE(6,9)
         WRITE(7,8) (I,I=IBEG,ISTOP)
         WRITE(7,9)
         DO 552 J=JEND,JBEG,-1
            WRITE(6,40) J,(G(I,j),I=IBEG,ISTOP)
            WRITE(7,40) J,(G(I,j),I=IBEG,ISTOP)
 552      CONTINUE
         IBEG=ISTOP+1
 551   CONTINUE
C     
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE HFLUX
C******************************************************************
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
C******************************************************************
C     
      DO 500 I=1,L1
         DO 510 J=1,M1
            SQPY=0.
            SQMY=0.
            SQPX=0.
            SQMX=0.
            DO 520 L=2,K2
               DO 530 M=2,J2
                  ADCY=ABS(DCY(L,M))
                  ADCX=ABS(DCX(L,M))
                  IF(I.GT.1.AND.I.LT.L1) THEN
                     IF(DCY(L,M).GT.0.0) THEN
                        SQPY=SQPY+ADCY*F(I,J,L,M)
                     ELSE
                        SQMY=SQMY+ADCY*F(I,J,L,M)
                     ENDIF
                  ENDIF
                  IF(J.GT.1.AND.J.LT.M1) THEN
                     IF(DCX(L,M).GT.0.0) THEN                     
                        SQPX=SQPX+ADCX*F(I,J,L,M)
                     ELSE
                        SQMX=SQMX+ADCX*F(I,J,L,M)
                     ENDIF
                  ENDIF
 530           CONTINUE
 520        CONTINUE
            QPY(I,J)=SQPY
            QMY(I,J)=SQMY
            QPX(I,J)=SQPX
            QMX(I,J)=SQMX
 510     CONTINUE
 500  CONTINUE   
C     
      DO 540 I=1,L1
         DO 550 J=1,M1
            GSUM=0.
            DO 560 L=2,K2
               DO 570 M=2,J2
                  GSUM=GSUM+F(I,J,L,M)*DOM(L,M)
 570           CONTINUE
 560        CONTINUE
            G(I,J)=GSUM

 550     CONTINUE
 540  CONTINUE
C     
      DO 580 J=1,M1
         IF(KBCI1(J).EQ.2) THEN
            QPY(1,J)=QPY(2,J)
            QMY(1,J)=QMY(2,J)
            G(1,J)  =G(2,J)
         ENDIF
         IF(KBCL1(J).EQ.2) THEN
            QPY(L1,J)=QPY(L2,J)
            QMY(L1,J)=QMY(L2,J)
            G(L1,J)  =G(L2,J)
         ENDIF
 580  CONTINUE
C     
      DO 600 I=1,L1
         IF(KBCJ1(I).EQ.2) THEN
            QPX(I,1)=QPX(I,2)
            QMX(I,1)=QMX(I,2)
            G(I,1)  =G(I,2)
         ENDIF
         IF(KBCM1(I).EQ.2) THEN
            QPX(I,M1)=QPX(I,M2)
            QMX(I,M1)=QMX(I,M2)
            G(I,M1)  =G(I,M2)
         ENDIF
 600  CONTINUE
C
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      SUBROUTINE TCPLT
C-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
      INCLUDE 'PARAM.FOR'
      INCLUDE 'COMMON.FOR'
C-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
	OPEN(31,FILE='tcplt.dat')
      WRITE(31,*) ' VARIABLES = "X","Y","G","T"'
C
      WRITE(31,360) L1,M1
       DO 350 J=1,M1
         DO 351 I=1,L1
               XX=X(I)
               YY=Y(J)
               WRITE(31,353) XX,YY,G(I,J),T(I,J)
 351     CONTINUE
 350  CONTINUE
      CLOSE(31)
C
 360  FORMAT(1X,' ZONE T="SS"   I=',I3,' J=',I3,' F=POINT')
 353  FORMAT(1X,12E11.3)
      RETURN
      END
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC





