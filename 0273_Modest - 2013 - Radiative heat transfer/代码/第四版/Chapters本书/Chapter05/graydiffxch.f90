   PROGRAM GRAYDIFFXCH
   IMPLICIT NONE
   INTEGER,PARAMETER :: N=6
   DOUBLE PRECISION :: A(N),F(N,N),EPS(N),HO(N),PIN(N),POUT(N),arg(5),ww,hh,ll
   DOUBLE PRECISION :: VIEW, GAUSS, sumq,sigma=5.670E-8,T(N),q(N),QA(N)
   integer :: id(N),iclsd,i
! Dimensions
    ww=0.4
    hh=0.3
    ll=1.0e6

! Surfaces 1&3 (bottom and top)
    A(1)=ww*ll; A(3)=ww*ll          ! ww x ll
    HO(1)=0.; HO(3)=0.              ! no external irradiation
    EPS(1)=0.3; EPS(3)=0.3
    id(1)=1; id(3)=1                ! T specified
    T(1)=1000.; T(3)=1000.          ! T in K
! Surfaces 2&4 (left and right)
    A(2)=hh*ll; A(4)=hh*ll          ! hh x ll
    HO(2)=0.; HO(4)=0.              ! no external irradiation
    EPS(2)=0.8; EPS(4)=0.8
    id(2)=1; id(4)=1                ! T specified
    T(2)= 600.; T(4)= 600.          ! T in K
! Surfaces 5&6 (front and back)
    A(5)=hh*ww; A(6)=hh*ww          ! hh x ww
    HO(5)=0.; HO(6)=0.              ! no external irradiation
    EPS(5)=0.8; EPS(6)=0.8
    id(5)=1; id(6)=1                ! T specified
    T(5)= 600.; T(6)= 600.          ! T in K
! Fill PIN array with q and T
    DO i=1,N
        IF(id(i)==0) THEN
            PIN(i)=q(i)
        ELSE
            PIN(i)=sigma*T(i)**4    ! Convert temperatures to emissive powers
        ENDIF
    ENDDO
! View Factors; since configuration is closed (iclsd=1), diagonal terms are not needed
    iclsd=1
! F12
    arg(1)=hh; arg(2)=ll; arg(3)=ww     ! h,l,w
    F(1,2)=VIEW(39,3,arg)
! F13
    arg(1)=ww; arg(2)=ll; arg(3)=hh     ! a,b,c
    F(1,3)=VIEW(38,3,arg)
    F(1,4)=F(1,2)
! F15
    arg(1)=hh; arg(2)=ww; arg(3)=ll     ! h,l,w
    F(1,5)=VIEW(39,3,arg)
    F(1,6)=F(1,5)
! F23
    arg(1)=ww; arg(2)=ll; arg(3)=hh     ! h,l,w
    F(2,3)=VIEW(39,3,arg)
! F24
    arg(1)=ll; arg(2)=hh; arg(3)=ww     ! a,b,c
    F(2,4)=VIEW(38,3,arg)
! F25
    arg(1)=ww; arg(2)=hh; arg(3)=ll     ! h,l,w
    F(2,5)=VIEW(39,3,arg)
    F(2,6)=F(2,5)
    F(3,4)=F(1,4)
    F(3,5)=F(1,5)
    F(3,6)=F(1,6)
    F(4,5)=F(2,5)
    F(4,6)=F(2,6)
! F56
    arg(1)=ww; arg(2)=hh; arg(3)=ll     ! a,b,c
    F(5,6)=VIEW(38,3,arg)

! Solve system of equations
    CALL GRAYDIFF(N,iclsd,A,EPS,HO,F,ID,PIN,POUT)
! Output
! Convert emissive powers to temperatures
    sumq=0                              ! Check total flux=0?
    DO i=1,N
        IF(id(i)==0) THEN
            T(i)=(POUT(i)/sigma)**.25       
        ELSE
            q(i)=POUT(i)
        ENDIF
        QA(i)=q(i)*A(i)
        sumq=sumq+QA(i)
    ENDDO
    write(*,10) 
    write(*,20) (i,T(i),q(i),QA(i),i=1,N)
 10 format('surface     T        q [W/m2]      Q [W]')
    write(*,*) 'Sum of all fluxes = ',sumq
 20 format(i4,3x,f9.1,2e13.4)
    stop
    end
!******************************************************************************
! Routine to fill view factor matrix and solve for missing surface temperatures/fluxes
    SUBROUTINE GRAYDIFF(N,iclsd,A,EPS,HO,F,ID,PIN,POUT)
! INPUT:
! N     = number of surfaces in enclosure
! iclsd = closed or open configuration identifier
!         iclsd=1: configuration is closed; diagonal Fii evaluated from summation rule
!         iclsd/=1: configuration has openings; Fii must be specified
! A(N)  = vector containing surface areas, [m2]
! EPS(N)= vector containing surface emittances
! HO(N) = vector containing external irradiation, in [W/m2]
! F(N,N)= vector containing view factors; on input only Fij with j>i (iclsd=1) or
!         j>=i (iclsd/=1) are required; remaonder are calculated
! ID(N) = vector containing surface identifier:
!         ID=0: surface heat flux is specified, in [W/m2]
!         ID=1: surface temperature is specified, in [K]
! PIN(N)= vector containing surface emissive powers (id=1) and fluxes (id=2)
! OUTPUT: 
! POUT(N)= vector containing unknown surface fluxes (for surfaces with id=1) and 
!           emissive powers (for surfaces with id=0)
   IMPLICIT NONE
   INTEGER :: N,ID(N),iclsd,i,j,ikr
   DOUBLE PRECISION :: A(N),F(N,N),EPS(N),HO(N),PIN(N),POUT(N),qm(N,N),em(N,N),pm(N,N),B(N)
! Compute missing view factors
! Lower left triangle by reciprocity
    DO i=2,N
    DO j=1,i-1
        F(i,j)=A(j)/A(i)*F(j,i)
    ENDDO
    ENDDO
! If closed configuration, need to also calculate diagonal terms by summation rule
    IF(iclsd==1) THEN
        DO i=1,N
            F(i,i)=1.
            DO j=1,N
                IF(j==i) CYCLE
                F(i,i)=F(i,i)-F(i,j)
            ENDDO
        ENDDO
    ENDIF
! Fill q- and e-coefficient matrices
    DO i=1,N
    DO j=1,N
        ikr=(i/j)*(j/i)         ! Kronecker delta_ij
        qm(i,j)=ikr/EPS(j)-(1./EPS(j)-1.)*F(i,j)
        em(i,j)=ikr-F(i,j)
    ENDDO
    ENDDO
! Fill POUT-coefficient matrix and RHS
    DO i=1,N
        B(i)=-HO(i)
        DO j=1,N
            pm(i,j)=qm(i,j)*ID(j)-em(i,j)*(1-ID(j))
            B(i)=B(i)+(em(i,j)*ID(j)-qm(i,j)*(1-ID(j)))*PIN(j)
        ENDDO
    ENDDO
! Invert POUT-coefficient matrix and multiply by RHS to obtain POUT
    CALL GAUSS(N,pm,B,POUT)    
    RETURN
    END

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
      DOUBLE PRECISION :: VIEW,PHI,HR,RTA,RTB,XX,YY,Z,ZZ,LL,PHI1,PHI2,XY,RR1,RR2
      DOUBLE PRECISION :: ARG(NARG),F,PI,H,W,HW,ALPHA2,R,S,X,R1,R2,RR,SS,C
      DOUBLE PRECISION :: A,B1,B2,BB1,BB2,B,Y,RTX,RTY,RT,L,HH,WW,W2,H2,HW2
      DOUBLE PRECISION :: H12,W12,C1,C2,C3,AA,BB,BL,L1,L2,D1,D2,OM,CC,D,SR
 
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
      X=1.+RR*RR+ZZ*ZZ
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
      AA=BL*BL-RR*RR+1.
      BB=BL*BL+RR*RR+1.
      VIEW=2.*XX*AA/(BB*BB-4.*RR*RR)**1.5
      RETURN
  9   IF(NARG.NE.2) GOTO 200
      R=ARG(1)
      X=ARG(2)
      XX=0.5*X/R
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
      RT=SQRT(AA*AA+BB*BB)
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
      Z=1.+HH*HH+RR*RR
      VIEW=.5*(1.-(Z-2.*RR*RR)/SQRT(ZZ*ZZ-4.*RR*RR))
      RETURN
 14   IF(NARG.NE.3) GOTO 200
      H=ARG(1)
      L=ARG(2)
      R=ARG(3)
      HH=H/L
      RR=R/L
      Z=1.+HH*HH+RR*RR
      VIEW=.5*HH*(Z/SQRT(ZZ*ZZ-4.*RR*RR)-1.)
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
      HH=.5*H/R
      ZZ=.5*Z/R
      VIEW=1.+HH-(ZZ*ZZ+0.5)/SQRT(ZZ*ZZ+1.)-((HH-ZZ)**2+0.5)/SQRT((HH-ZZ)**2+1.)
      RETURN
 21   IF(NARG.NE.2) GOTO 200
      R=ARG(1)
      Z=ARG(2)
      ZZ=Z/R
      VIEW=0.5*((ZZ*ZZ+2.)/SQRT(ZZ*ZZ+4.)-ZZ)
      RETURN
 22   IF(NARG.NE.3) GOTO 200
      R1=ARG(1)
      R2=ARG(2)
      Z=ARG(3)
      RR=R2/R1
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
      VIEW=(YY*ATAN(X/YY)-ATAN(X)+X*X/XX*ATAN(Y/XX))/(PI*Y)
      RETURN
 27   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      B=ARG(2)
      C=ARG(3)
      X=A/B
      Y=C/B
      XY=X*X+Y*Y
      YY=1.+Y*Y
      VIEW=(ATAN(1/Y)+.5*Y*LOG(Y*Y*(XY+1.)/YY/XY)-Y/SQRT(XY)*ATAN(1./SQRT(XY)))/PI
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
      VIEW=SS/C*(1.-(ACOS(B/A)-0.5*(SQRT(A*A+4.*HH*HH)*ACOS(B/A/CC)-B*ASIN(1./CC))/HH)) &
           -0.25*A/HH
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
      VIEW=RR2*RR2/(1.+RR1*RR1)**1.5
      RETURN
 31   IF(NARG.NE.2) GOTO 200
! IDENTICAL TO #21
      R=ARG(1)
      X=ARG(2)
      XX=0.5*X/R
      VIEW=(XX+0.5)/SQRT(1.+XX*XX)
      RETURN
 32   IF(NARG.NE.2) GOTO 200
      H=ARG(1)
      W=ARG(2)
      HW=H/W
      VIEW=SQRT(1.+HW*HW)-H
      RETURN
 33   IF(NARG.NE.2) GOTO 200
      H=ARG(1)
      W=ARG(2)
      HW=H/W
      VIEW=0.5*(1.+HW-SQRT(1.+HW*HW))
      RETURN
 34   IF(NARG.NE.1) GOTO 200
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
         +.25*(LOG(C1)+W2*LOG(C2)+H2*LOG(C3)))/(PI*WW)
      RETURN
 40   IF(NARG.NE.3) GOTO 200
      A=ARG(1)
      R1=ARG(2)
      R2=ARG(3)
      X=1.+(A*A+R2*R2)/(R1*R1)
      VIEW=0.5*(X-SQRT(X*X-4.*(R2/R1)**2))
      RETURN
 41   IF(NARG.NE.3) GOTO 200
      L=ARG(1)
      R1=ARG(2)
      R2=ARG(3)
      RR=R1/R2
      BL=L/R2
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
      HH=H/R1
      AA=HH*HH+4.*RR*RR
      BB=4.*(RR*RR-1.)
      VIEW=1.-1./RR-(SQRT(AA)-HH)/(4.*RR)+(2./RR*ATAN(SQRT(BB)/HH) &
        -HH/(2.*RR)*(SQRT(AA)/HH*ASIN((HH*HH*(1.-2./RR/RR)+BB)/(AA-4.)) &
        -ASIN((RR*RR-2.)/RR/RR)))/PI
      RETURN
 45   IF(NARG.NE.2) GOTO 200
      H=ARG(1)
      R1=ARG(2)
      R2=ARG(3)
      RR=R2/R1
      HH=H/R1
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
      RR=R2/R1
      HH=H/R1
      AA=1.-RR*RR-HH*HH
      BB=1.-RR*RR+HH*HH
      CC=1.+HH*HH+RR*RR
      X=SQRT(1.-RR*RR)
      Y=RR*AA/BB
      VIEW=(RR*(ATAN(X/HH)-ATAN(2.*X/HH))+0.25*HH*(ASIN(2.*RR*RR-1.)-ASIN(RR)) &
        +0.25*X*X/HH*(0.5*PI+ASIN(RR))-0.25*SQRT(CC*CC-4.*RR*RR)/HH*(0.5*PI+ASIN(Y)) &
        +0.25*SQRT(4.+HH*HH)*0.5*PI+ASIN(1.-2.*RR*RR*HH*HH/(4.*X*X+HH*HH)))/PI
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
      VIEW=SS*ACOS(SS)+1.-SQRT(1.-SS*SS)
      RETURN
100   WRITE(*,101) NO
101   FORMAT(1X,'*** ILLEGAL VALUE FOR NO (NO =',I2, &
                '), MUST BE 1<=NO>=51 ***')
      VIEW=0.
      RETURN
200   WRITE(*,201) NARG,NO
201   FORMAT(1X,'*** WRONG VALUE OF NARG (NARG =',I2,') FOR NO =',I3, &
               ' ***')
      VIEW=0.
      RETURN
      END
!***********************************************************************************
      SUBROUTINE GAUSS(N,A,B,X)    
      IMPLICIT NONE
      INTEGER      :: I,N,L(N),K,J,LK
      DOUBLE PRECISION :: A(N,N),S(N),B(N),X(N)
      DOUBLE PRECISION :: SMAX,RMAX,R,XMULT,SUM
      DO 3 I = 1,N
        L(I) = I  
        SMAX = 0.0
        DO 2 J = 1,N
          SMAX = DMAX1(SMAX,ABS(A(I,J)))
   2    CONTINUE  
        S(I) = SMAX 
   3  CONTINUE    
      DO 7 K = 1,N-1
        RMAX = 0.0
        DO 4 I = K,N
          R = ABS(A(L(I),K))/S(L(I))  
          IF(R .LE. RMAX)  GO TO 4    
          J = I   
          RMAX = R
   4    CONTINUE  
        LK = L(J) 
        L(J) = L(K) 
        L(K) = LK 
        DO 6 I = K+1,N      
          XMULT = A(L(I),K)/A(LK,K)   
          DO 5 J = K+1,N    
            A(L(I),J) = A(L(I),J) - XMULT*A(LK,J) 
   5      CONTINUE
          A(L(I),K) = XMULT 
   6    CONTINUE  
   7  CONTINUE    
 
      DO 13 K = 1,N-1
        DO 12 I = K+1,N      
          B(L(I)) = B(L(I)) - A(L(I),K)*B(L(K)) 
  12    CONTINUE
  13  CONTINUE    
      X(N) = B(L(N))/A(L(N),N)
      DO 15 I = N-1,1,-1     
        SUM = B(L(I))       
        DO 14 J = I+1,N      
          SUM = SUM - A(L(I),J)*X(J)  
  14    CONTINUE  
        X(I) = SUM/A(L(I),I)
  15  CONTINUE    
      RETURN      
      END 
