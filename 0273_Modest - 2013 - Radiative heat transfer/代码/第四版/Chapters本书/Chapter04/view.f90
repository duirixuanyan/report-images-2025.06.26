!******************************************************************************
! View Factor routine
!
      FUNCTION VIEW(NO,NARG,ARG)
!  *************************************************************************
!  *  THIS SUBROUTINE EVALUATES ALL VIEW FACTORS LISTED IN APPENDIX D      *
!  *  NO = CONFIGURATION NUMBER (1 THROUGH 51),                            *
!  *  NARG = NUMBER OF NON-DIMENSIONAL ARGUMENTS FOR VIEW FACTOR,          *
!  *  ARG = ARRAY CONTAINING THE NARG DIFFERENT ARGUMENTS (in alphabetical * 
!  *          order as given in App.D, angles given in degrees),           *
!  *  VIEW = VIEW FACTOR RETURNED BY THE SUBROUTINE                        *
!  *      (FOR NUMBERS 1-9, DF/DL IS GIVEN, WHERE DL IS NONDIMENSIONAL     *
!  *       INFINITESIMAL DIMENSION OF RECEIVING SURFACE).                  *
!  *************************************************************************
      IMPLICIT NONE
      INTEGER      :: NO,NARG
      REAL*4       :: VIEW,PHI,HR,RTA,RTB,XX,YY,Z,ZZ,LL,PHI1,PHI2,XY,RR1,RR2
      REAL*4       :: ARG(NARG),F,PI,H,W,HW,ALPHA2,R,S,X,R1,R2,RR,SS,C,PHIMAX
      REAL*4       :: A,B1,B2,BB1,BB2,B,Y,RTX,RTY,RT,L,HH,WW,W2,H2,HW2
      REAL*4       :: H12,W12,C1,C2,C3,AA,BB,BL,L1,L2,D1,D2,OM,CC,D,SR
 
      IF(NO.LT.1.OR.NO.GT.51) GOTO 100
      PI=3.1415926E0
      GOTO (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22, &
            23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41, &
            42,43,44,45,46,47,48,49,50,51), NO
  1   IF(NARG.NE.1) GOTO 200
      PHI=ARG(1)
      VIEW=0.5*COS(PHI*PI/180.)
      RETURN
  2   IF(NARG.NE.2) GOTO 200
      L=ARG(1)
      R=ARG(2)
      RR=R/L
      VIEW=2.*RR/(1.+RR*RR)**2
      RETURN
  3   IF(NARG.NE.2) GOTO 200
      R=ARG(1)
      X=ARG(2)
      XX=X/R
      VIEW=2.*XX/(1.+XX*XX)**2
      RETURN
  4   IF(NARG.NE.3) GOTO 200
      R1=ARG(1)
      R2=ARG(2)
      Z=ARG(3)
      RR=R2/R1
      IF(RR>1.) THEN
       PRINT *, 'R2 MUST BE LESS THAN R1'
       VIEW=0.
       RETURN
       END IF
      ZZ=Z/R1
      X=1.+RR*RR+ZZ*ZZ
      VIEW=2.*ZZ*(X-2.*RR*RR)*RR/(X*X-4.*RR*RR)**1.5
      RETURN
  5   IF(NARG.NE.3) GOTO 200
      X=ARG(1)
      Y=ARG(2)
      PHI=ARG(3)
      YY=Y/X
      PHI=PHI*PI/180.
      VIEW=0.5*YY*SIN(PHI)**2/(1.+YY*YY-2.*YY*COS(PHI))**1.5
      RETURN
  6   IF(NARG.NE.3) GOTO 200
      B=ARG(1)
      R=ARG(2)
      PHI=ARG(3)
      BB=B/R
      PHI=PHI*PI/180.
      VIEW=ATAN(BB)*COS(PHI)/PI
      RETURN
  7   IF(NARG.NE.3) GOTO 200
      L=ARG(1)
      R1=ARG(2)
      R2=ARG(3)
      RR=R1/R2
      BL=L/R1
      AA=BL*BL+RR*RR+1.
      VIEW=2.*RR*BL*BL*AA/(AA*AA-4.*RR*RR)**1.5
      RETURN
  8   IF(NARG.NE.3) GOTO 200
      R1=ARG(1)
      R2=ARG(2)
      X=ARG(3)
      RR=R1/R2
      XX=X/R2
      AA=XX*XX-RR*RR+1.
      BB=XX*XX+RR*RR+1.
      VIEW=2.*XX*AA/(BB*BB-4.*RR*RR)**1.5
      RETURN
  9   IF(NARG.NE.2) GOTO 200
      R=ARG(1)
      X=ARG(2)
      XX=0.5*X/R
      IF(XX.GT..5E6) THEN
      	VIEW=0.
	RETURN 
      	END IF
      VIEW=1.-0.5*XX*(2.*XX*XX+3.)/(XX*XX+1.)**1.5
      RETURN
 10   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      B=ARG(2)
      C=ARG(3)
      AA=A/C
      BB=B/C
      RTA=SQRT(1.+AA*AA)
      RTB=SQRT(1.+BB*BB)
      VIEW=(AA/RTA*ATAN(BB/RTA)+BB/RTB*ATAN(AA/RTB))/(2.*PI)
      RETURN
 11   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      B=ARG(2)
      C=ARG(3)
      X=A/B
      Y=C/B
      RT=SQRT(X*X+Y*Y)
      VIEW=(ATAN(1./Y)-Y/RT*ATAN(1./RT))/(2.*PI)
      RETURN
 12   IF(NARG.NE.2) GOTO 200
      H=ARG(1)
      R=ARG(2)
      HR=H/R
      VIEW=1./(1.+HR*HR)
      RETURN
 13   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      H=ARG(2)
      R=ARG(3)
      HH=H/A
      RR=R/A
      ZZ=1.+HH*HH+RR*RR
      VIEW=.5*(1.-(ZZ-2.*RR*RR)/SQRT(ZZ*ZZ-4.*RR*RR))
      RETURN
 14   IF(NARG.NE.3) GOTO 200
      H=ARG(1)
      L=ARG(2)
      R=ARG(3)
      HH=H/L
      RR=R/L
      ZZ=1.+HH*HH+RR*RR
      VIEW=.5*HH*(ZZ/SQRT(ZZ*ZZ-4.*RR*RR)-1.)
      RETURN
 15   IF(NARG.NE.3) GOTO 200
      H=ARG(1)
      L=ARG(2)
      R=ARG(3)
      HH=H/R
      LL=L/R
      X=(1.+HH)**2+LL*LL
      Y=(1.-HH)**2+LL*LL
      VIEW=LL/HH*(1./LL*ATAN(LL/SQRT(HH*HH-1.)) &
          +(X-2.*HH)/SQRT(X*Y)*ATAN(SQRT(X/Y*(HH-1.)/(HH+1.))) &
          -ATAN(SQRT((HH-1.)/(HH+1.))))/PI
      RETURN
 16   IF(NARG.NE.2) GOTO 200
      H=ARG(1)
      R=ARG(2)
      VIEW=(R/H)**2
      RETURN
 17   IF(NARG.NE.2) GOTO 200
      H=ARG(1)
      R=ARG(2)
      HH=H/R
      VIEW=(ATAN(SQRT(1./(HH*HH-1.)))-SQRT(HH*HH-1.)/HH/HH)/PI
      RETURN
 18   IF(NARG.NE.3) GOTO 200
      H=ARG(1)
      R=ARG(2)
      PHI=ARG(3)
      PHI=PHI*PI/180.
      PHIMAX=ACOS(R/H)
      IF(PHI.GT.PHIMAX) THEN
      	PRINT *, 'PHI MUST BE < ACOS(R/H),', 180.*PHIMAX/PI
	VIEW=0.
	RETURN
	END IF
      VIEW=(R/H)**2*COS(PHI)
      RETURN
 19   IF(NARG.NE.3) GOTO 200
      H=ARG(1)
      L=ARG(2)
      R=ARG(3)
      HH=H/R
      LL=L/R
      IF(HH<-1.) THEN
        VIEW=0.
      ELSEIF(HH<+1.) THEN
        X=LL*LL+HH*HH
        Y=SQRT(X-1.)
        VIEW=(HH/X**1.5*ACOS(-HH/LL*Y)-Y*SQRT(1.-HH*HH)/X &
          -ASIN(Y/LL)+PI/2.)/PI
      ELSE
        X=LL*LL+HH*HH
        VIEW=H/X**1.5
      ENDIF
      RETURN
 20   IF(NARG.NE.3) GOTO 200
      H=ARG(1)
      R=ARG(2)
      Z=ARG(3)
      IF(Z.LT.0..OR.Z.GT.H) THEN
      	PRINT *, 'INVALID Z'
	VIEW=0
	RETURN 
	END IF
      HH=.5*H/R
      ZZ=.5*Z/R
      VIEW=1.+HH-(ZZ*ZZ+0.5)/SQRT(ZZ*ZZ+1.)-((HH-ZZ)**2+0.5)/SQRT((HH-ZZ)**2+1.)
      RETURN
 21   IF(NARG.NE.2) GOTO 200
      R=ARG(1)
      Z=ARG(2)
      ZZ=Z/R
      IF(Z.LT.0.) THEN
      	PRINT *, 'INVALID Z'
	VIEW=0
	RETURN 
	END IF
      IF(ZZ.GT.1.E4) THEN
      	VIEW=ZZ**-3.
	RETURN
	END IF
      VIEW=0.5*((ZZ*ZZ+2.)/SQRT(ZZ*ZZ+4.)-ZZ)
      RETURN
 22   IF(NARG.NE.3) GOTO 200
      R1=ARG(1)
      R2=ARG(2)
      Z=ARG(3)
      RR=R2/R1
      IF(RR.GT.1.)THEN
      	PRINT *,'R2 MUST BE LESS THAN R1'
	VIEW=0
	RETURN
	END IF
      ZZ=Z/R1
      X=1.+RR*RR+ZZ*ZZ
      VIEW=0.5*ZZ*(X/SQRT(X*X-4.*RR*RR)-1.)
      RETURN
 23   IF(NARG.NE.3) GOTO 200
      L=ARG(1)
      X=ARG(2)
      XX=X/L
      PHI=ARG(3)
      PHI=PHI*PI/180.
      VIEW=0.5*(1.+(COS(PHI)-XX)/SQRT(1.+XX*XX-2.*XX*COS(PHI)))
      RETURN
 24   IF(NARG.NE.2) GOTO 200
      PHI1=ARG(1)
      PHI2=ARG(2)
      PHI1=PHI1*PI/180.
      PHI2=PHI2*PI/180.
      IF(PHI2.LT.PHI1)THEN
	PRINT *,'WARNING, PHI2 MUST BE GREATER THAN PHI1'
	PHI=PHI1
	PHI1=PHI2
	PHI2=PHI
	END IF
      IF(PHI1>90.)THEN
	PHI1=90.
	PRINT *,'PHI1 MUST BE LESS THAN 90 OR GREATER THAN -90'
	END IF
      IF(PHI1<-90.)THEN
	PHI1=-90.;
	PRINT *,'PHI1 MUST BE LESS THAN 90 OR GREATER THAN -90'
	END IF
      VIEW=0.5*(SIN(PHI2)-SIN(PHI1))
      RETURN
 25   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      B=ARG(2)
      R=ARG(3)
      AA=A/R
      BB=B/R
      VIEW=AA/(AA*AA+BB*BB)
      RETURN
 26   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      B=ARG(2)
      C=ARG(3)
      X=A/C
      Y=B/C
      XX=SQRT(1.+X*X)
      YY=SQRT(1.+Y*Y)
      VIEW=(YY*ATAN(X/YY)-ATAN(X)+X*Y/XX*ATAN(Y/XX))/(PI*Y)
      RETURN
 27   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      B=ARG(2)
      C=ARG(3)
      X=A/B
      Y=C/B
      IF(Y>1.E6) THEN  ! CORRECTION FOR MACHINE ERRORS
      	VIEW=0.
	RETURN
	END IF
      XY=X*X+Y*Y
      YY=1.+Y*Y
      VIEW=(ATAN(1/Y)+.5*Y*ALOG(Y*Y*(XY+1.)/YY/XY)-Y/SQRT(XY)*ATAN(1./SQRT(XY)))/PI
      RETURN
 28   IF(NARG.NE.4) GOTO 200
      H=ARG(1)
      R=ARG(2)
      S=ARG(3)
      X=ARG(4)
      HH=H/R
      SS=S/R
      XX=X/R
      C=SS*SS+XX*XX
      CC=SQRT(C)
      A=HH*HH+C-1.
      B=HH*HH-C+1.
      VIEW=SS/C*(1.-(1./PI)*(ACOS(B/A)-0.5*(SQRT(A*A+4.*HH*HH)*ACOS(B/A/CC)-B*ASIN(1./CC))/HH) &
           -0.25*A/HH)
      RETURN
 29   IF(NARG.NE.1) GOTO 200
      PHI=ARG(1)
      VIEW=0.5*(1.+COS(PHI*PI/180.))
      RETURN
 30   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      R1=ARG(2)
      R2=ARG(3)
      RR1=R1/A
      RR2=R2/A
      IF(RR2.GT.1.)THEN
      	PRINT*,'R2 MUST BE LESS THAN A'
	VIEW=0.
	RETURN
	END IF
      VIEW=RR2*RR2/(1.+RR1*RR1)**1.5
      RETURN
 31   IF(NARG.NE.2) GOTO 200
! IDENTICAL TO #21
      R=ARG(1)
      X=ARG(2)
      XX=0.5*X/R
      VIEW=(XX*XX+0.5)/SQRT(1.+XX*XX)-XX
      RETURN
 32   IF(NARG.NE.2) GOTO 200
      H=ARG(1)
      W=ARG(2)
      HW=H/W
      VIEW=SQRT(1.+HW*HW)-HW
      RETURN
 33   IF(NARG.NE.2) GOTO 200
      H=ARG(1)
      W=ARG(2)
      HW=H/W
      VIEW=0.5*(1.+HW-SQRT(1.+HW*HW))
      RETURN
 34   IF(NARG.NE.1) GOTO 200
      IF(ALPHA2.GT.180.)THEN
      	VIEW=0.
	RETURN
	END IF
      ALPHA2=ARG(1)*PI/360.
      VIEW=1.-SIN(ALPHA2)
      RETURN
 35   IF(NARG.NE.2) GOTO 200
      R=ARG(1)
      S=ARG(2)
      X=1+0.5*S/R
      VIEW=(ASIN(1./X)+SQRT(X*X-1.)-X)/PI
      RETURN
 36   IF(NARG.NE.3) GOTO 200
      R1=ARG(1)
      R2=ARG(2)
      S=ARG(3)
      RR=R2/R1
      SS=S/R1
      C=1.+RR+SS
      VIEW=(PI+SQRT(C*C-(RR+1.)**2)-SQRT(C*C-(RR-1.)**2) &
             +(RR-1)*ACOS((RR-1.)/C)-(RR+1)*ACOS((RR+1.)/C))/(2.*PI)
      RETURN
 37   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      B1=ARG(2)
      B2=ARG(3)
      BB1=B1/A
      BB2=B2/A
      VIEW=(ATAN(BB1)-ATAN(BB2))/(2.*PI)
      RETURN
 38   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      B=ARG(2)
      C=ARG(3)
      X=A/C
      Y=B/C
      IF (X<0.002.OR.Y<0.002) THEN  !CORRECTION FOR MACHINE ERRORS
      	VIEW=0.0
	RETURN 
	END IF
      RTX=SQRT(1.+X*X)
      RTY=SQRT(1.+Y*Y)
      RT=SQRT(1.+X*X+Y*Y)
      VIEW=(LOG(RTX*RTY/RT)+X*RTY*ATAN(X/RTY)+Y*RTX*ATAN(Y/RTX) &
                         -X*ATAN(X)-Y*ATAN(Y))*2./(PI*X*Y)
      RETURN
 39   IF(NARG.NE.3) GOTO 200
      H=ARG(1)
      L=ARG(2)
      W=ARG(3)
      HH=H/L
      WW=W/L
      W2=WW*WW
      H2=HH*HH
      HW2=H2+W2
      HW=SQRT(H2+W2)
      H12=H2+1.
      W12=W2+1.
      C1=W12*H12/(H12+W2)
      C2=W2*(H12+W2)/W12/HW2
      C3=H2*(H12+W2)/H12/HW2
      VIEW=(WW*ATAN(1./WW)+HH*ATAN(1./HH)-HW*ATAN(1./HW) &
         +.25*(ALOG(C1)+W2*ALOG(C2)+H2*ALOG(C3)))/(PI*WW)
      RETURN
 40   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      R1=ARG(2)
      R2=ARG(3)
      RR1=R1/A
      RR2=R2/A
      X=1.+(1.+RR2*RR2)/(RR1*RR1)
      VIEW=0.5*(X-SQRT(X*X-4.*(R2/R1)**2))
      RETURN
 41   IF(NARG.NE.3) GOTO 200
      L=ARG(1)
      R1=ARG(2)
      R2=ARG(3)
      RR=R1/R2
      IF(RR>1.) THEN
       PRINT *, 'R2 MUST BE LESS THAN R1'
       VIEW=0.
       RETURN
       END IF
      BL=L/R2
      IF(BL>1000.) THEN
       VIEW=0.
       RETURN
       END IF
      AA=BL*BL+RR*RR-1.
      BB=BL*BL-RR*RR+1.
      VIEW=BB/(8.*RR*BL)+(ACOS(AA/BB) &
        -SQRT(((AA+2.)/RR)**2-4.)/(2.*BL)*ACOS(AA*RR/BB) &
        -AA/(2.*RR*BL)*ASIN(RR))/(2.*PI)
      RETURN
 42   IF(NARG.NE.2) GOTO 200
      H=ARG(1)
      R=ARG(2)
      HH=0.5*H/R
      VIEW=1.+HH-SQRT(1.+HH*HH)
      RETURN
 43   IF(NARG.NE.2) GOTO 200
      H=ARG(1)
      R=ARG(2)
      HH=0.5*H/R
      VIEW=2.*HH*(SQRT(1.+HH*HH)-HH)
      RETURN
 44   IF(NARG.NE.3) GOTO 200
      H=ARG(1)
      R1=ARG(2)
      R2=ARG(3)
      RR=R2/R1
      IF(RR<1.) THEN
       PRINT *, 'R2 MUST BE GREATER THAN R1'
       VIEW=0.
       RETURN
       END IF
      HH=H/R1
      AA=HH*HH+4.*RR*RR
      BB=4.*(RR*RR-1.)
      VIEW=1.-1./RR-(SQRT(AA)-HH)/(4.*RR)+(2./RR*ATAN(SQRT(BB)/HH) &
        -HH/(2.*RR)*(SQRT(AA)/HH*ASIN((HH*HH*(1.-2./RR/RR)+BB)/(AA-4.)) &
        -ASIN((RR*RR-2.)/RR/RR)))/PI
      RETURN
 45   IF(NARG.NE.3) GOTO 200
      H=ARG(1)
      R1=ARG(2)
      R2=ARG(3)
      RR=R2/R1
      IF(RR<1.) THEN
       PRINT *, 'R2 MUST BE GREATER THAN R1'
       VIEW=0.
       RETURN
       END IF
      HH=H/R1
      IF(HH.GT.6250)THEN
      	VIEW=1.
	RETURN
	END IF
      AA=HH*HH+RR*RR-1.
      BB=HH*HH-RR*RR+1.
      CC=HH*HH+RR*RR+1.
      VIEW=1.-AA/(4.*HH)-(ACOS(BB/AA) &
        -SQRT(CC*CC-4.*RR*RR)/(2.*HH)*ACOS(BB/RR/AA) &
        -BB/(2.*HH)*ASIN(1./RR))/PI
      RETURN
 46   IF(NARG.NE.3) GOTO 200
      H=ARG(1)
      R1=ARG(2)
      R2=ARG(3)
      RR=R1/R2
      IF(RR>1.) THEN
       PRINT *, 'R1 MUST BE GREATER THAN R2'
       VIEW=0.
       RETURN
       END IF
      HH=H/R1
      AA=1.-RR*RR-HH*HH
      BB=1.-RR*RR+HH*HH
      CC=1.+HH*HH+RR*RR
      X=SQRT(1.-RR*RR)
      Y=RR*AA/BB
      VIEW=(RR*(ATAN(X/HH)-ATAN(2.*X/HH))+0.25*HH*(ASIN(2.*RR*RR-1.)-ASIN(RR)) &
        +0.25*X*X/HH*(0.5*PI+ASIN(RR))-0.25*SQRT(CC*CC-4.*RR*RR)/HH*(0.5*PI+ASIN(Y)) &
        +0.25*SQRT(4.+HH*HH)*(0.5*PI+ASIN(1.-2.*RR*RR*HH*HH/(4.*X*X+HH*HH))))/PI
      RETURN
 47   IF(NARG.NE.3) GOTO 200
      D=ARG(1)
      L1=ARG(2)
      L2=ARG(3)
      D1=D/L1
      D2=D/L2
      VIEW=0.25*ATAN(1./SQRT(D1*D1+D2*D2+D1*D1*D2*D2))/PI
      RETURN
 48   IF(NARG.NE.2) GOTO 200
      A=ARG(1)
      R=ARG(2)
      RR=R/A
      VIEW=0.5*(1.-1./SQRT(1.+RR*RR))
      RETURN
 49   IF(NARG.NE.2) GOTO 200
      A=ARG(1)
      R=ARG(2)
      RR=R/A
      VIEW=1./SQRT(1.+RR*RR)
      RETURN
 50   IF(NARG.NE.4) GOTO 200
      R1=ARG(1)
      R2=ARG(2)
      S=ARG(3)
      OM=ARG(4)
      SS=S/R1
      RR=R2/R1
      A=ASIN(1./(SS+1.))*180./PI
      IF(OM<A) WRITE(*,*) 'Formula only valid for OM > ',A,'deg'
      OM=OM*PI/180.
      SR=1.+SS+RR/TAN(OM)
      VIEW=0.5*(1.-SR/SQRT(SR*SR+RR*RR))
      RETURN
 51   IF(NARG.NE.2) GOTO 200
      D=ARG(1)
      S=ARG(2)
      SS=D/S
      IF(SS.GT.1.)THEN
      	PRINT *,'D MUST BE LESS THAN S'
	VIEW=0.
	RETURN
	END IF
      VIEW=SS*ACOS(SS)+1.-SQRT(1.-SS*SS)
      RETURN
100   WRITE(*,101) NO
101   FORMAT(1X,'*** ILLEGAL VALUE FOR NO (NO =',I2, &
                '), MUST BE 32<=NO>=51 ***')
      VIEW=0.
      RETURN
200   WRITE(*,201) NARG,NO
201   FORMAT(1X,'*** WRONG VALUE OF NARG (NARG =',I2,') FOR NO =',I3, &
               ' ***')
      VIEW=0.
      RETURN
      END
