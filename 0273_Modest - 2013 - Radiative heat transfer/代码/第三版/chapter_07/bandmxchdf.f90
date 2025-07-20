   PROGRAM BANDMXCHDF
   IMPLICIT NONE
   INTEGER,PARAMETER :: N=2,M=2
   DOUBLE PRECISION :: bbfn,A(N),Bandwl(M),F(N,N),EPS(M,N),HO(M,N),T(N),q(N),L1,L2
   integer :: id(N),iclsd,i
! Spectral band limit wavelengths
    Bandwl(1)=4.                    ! wavelength in micron
! Dimensions
    L1=0.8
    L2=0.6

! Surface 1 (bottom)
    A(1)=L1                         ! per unit depth
    HO(1,1)=866.*bbfn(4.D0*5777D0);  HO(2,1)=866.-HO(1,1)   ! direct solar irradiation 
    EPS(1,1)=0.8; EPS(2,1)=0.1
    id(1)=1                         ! T specified
    T(1)=350.                       ! T in K
! Surface 2 (left)
    A(2)=L2                         ! per unit depth
    HO(1,2)=500.*bbfn(4.D0*5777D0);  HO(2,2)=500.-HO(1,2)       ! direct solar irradiation
    EPS(1,2)=0.1; EPS(2,2)=0.8
    id(2)=0                         ! q specified
    q(2)= 0.                        ! q in W/m2
! View Factors; since configuration is open (iclsd=2), diagonal terms are also needed
    iclsd=2
    F(1,1)=0.; F(1,2)=0.25; F(2,2)=0.; 
! Solve system of equations
    CALL BANDAPPDF(M,N,iclsd,A,Bandwl,EPS,HO,F,ID,q,T)
! Output
    write(*,10) 
    write(*,20) (i,T(i),q(i),q(i)*A(i),i=1,N)
 10 format('surface     T        q [W/m2]      Q [W]')
 20 format(i4,3x,f9.1,2e13.4)
    stop
    end
!
!******************************************************************************
    SUBROUTINE BANDAPPDF(M,N,iclsd,A,Bandwl,EPS,HO,F,ID,q,T)
! Routine to solve for missing surface temperatures/fluxes calling GRAYDIFF 
! for M spectral ranges
! INPUT:
! M      = number of spectral bands
! N      = number of surfaces in enclosure
! iclsd  = closed or open configuration identifier
!          iclsd=1: configuration is closed; diagonal Fsii evaluated from summation rule
!          iclsd/=1: configuration has openings; Fsii must be specified
! A(N)   = vector containing surface areas, [m2]
! Bandwl(M-1) = vector containing wavelengths separating the M spectral bands, [micro-m]
! EPS(M,N)= matrix containing surface emittances for 2 spectral ranges
! HO(M,N)= vector containing external irradiation, in [W/m2]
! F(N,N) = matrix containing view factors; on input only Fij with j>i (iclsd=1) or
!          j>=i (iclsd/=1) are required; remainder are calculated
! ID(N)  = vector containing surface identifier:
!          ID=0: surface heat flux is specified, in [W/m2]
!          ID=1: surface temperature is specified, in [K]
! q(N)   = vector containing known surface fluxes (only for surfaces with id=2)
! T(N)   = vector containing known surface temperatures (only for surfaces with id=1)
! OUTPUT: 
! q(N)   = vector containing surface fluxes (for all surfaces)
! T(N)   = vector containing surface temperatures (for all surfaces)
   IMPLICIT NONE
   INTEGER :: M,N,ID(N),IDl(N),iclsd,i,j,iqsp
   DOUBLE PRECISION :: A(N),Bandwl(M),F(N,N),EPS(M,N),HO(M,N),T(N),q(N),qc(N)
   DOUBLE PRECISION :: sigma=5.670E-8,Tresset=.1 !temperature residual setpoint in K
   DOUBLE PRECISION :: bbfn,PIN(N),POUT(N),epsl(N),hol(N),Tmin,Tmax
   DOUBLE PRECISION :: fracl(N),frach(N),Eb(N),Ttop,Tbot,Tnew,Ebtop,Ebbot,Ebnew,ebfrh,ebfrl,FZ,FZb,Tres

! First guess temperature for surfaces for which flux is specified
    Tmin=1.e8
    Tmax=0.
    iqsp=0
    DO i=1,N
        IF(id(i)==0) CYCLE
        IF(T(i)>Tmax) Tmax=T(i)
        IF(T(i)<Tmin) Tmin=T(i)
    ENDDO
    DO i=1,N
        IF(id(i)==1) CYCLE
        iqsp=iqsp+1                         ! number of surfaces with q specified
        T(i)=.5*(Tmin+Tmax)
    ENDDO
    Bandwl(M)=1.e5

! Scan over spectral bands
 5  fracl=0.
! Initialize (calculated) total fluxes and emissive powers
    qc=0.
    DO i=1,N
        Eb(i)=sigma*T(i)**4
    ENDDO
    DO j=1,M
! Set local values for eps, ho, pin and Fs
      DO i=1,N
        EPSl(i)=EPS(j,i)
        HOl(i)=HO(j,i)
        frach(i)=bbfn(Bandwl(j)*T(i))       ! bbfn at max wavelength for band
        PIN(i)=Eb(i)*(frach(i)-fracl(i))    ! fraction of emissive power in band
      ENDDO
      fracl=frach                           ! bbfn at min wavelength for (next) band
      IDl=1                                 ! as used here ALL T's are specified
      CALL GRAYDIFF(N,iclsd,A,EPSl,HOl,F,IDl,PIN,POUT)
! Adding fluxes of all bands
      qc=qc+POUT
    ENDDO

! Update temperatures for surfaces for which flux is specified
! This is done by assuming irradiation H(r) to be correct in eq. (6.10-top; modified
! for bandmodel), ie, FZ= [q - eps*Eb]_last - [q_specified - eps*Eb(T_new)]
! (this REALLY should be in bouble precision!)
    Tres=0.             ! initialize temperature error residual
    DO i=1,N
        IF(id(i)==1) CYCLE
! Calculate unchangeable part of zero function (all except eps*Eb(T_new))
        FZb=qc(i)-q(i)
        ebfrl=0
        DO j=1,M
          ebfrh=bbfn(Bandwl(j)*T(i))
          FZb=FZb-EPS(j,i)*Eb(i)*(ebfrh-ebfrl)
          ebfrl=ebfrh
        ENDDO
        
        IF(qc(i)>q(i)) THEN
! Temperature is too high
          Ttop=T(i)
          Tbot=Ttop
 10       Tbot=Tbot-10.
! Calculate remainder of zero function via iteration with changing T_new
          FZ=FZb
          ebfrl=0
          Ebbot=sigma*Tbot**4
          DO j=1,M
            ebfrh=bbfn(Bandwl(j)*Tbot)
            FZ=FZ+EPS(j,i)*Ebbot*(ebfrh-ebfrl)
            ebfrl=ebfrh
          ENDDO
          IF(FZ>0.) GOTO 10   ! not low enough yet
        ELSE
! Temperature is too low
          Tbot=T(i)
          Ttop=Tbot
 20       Ttop=Ttop+10.
! Calculate remainder of zero function
          FZ=FZb
          ebfrl=0
          Ebtop=sigma*Ttop**4
          DO j=1,M
            ebfrh=bbfn(Bandwl(j)*Ttop)
            FZ=FZ+EPS(j,i)*Ebtop*(ebfrh-ebfrl)
            ebfrl=ebfrh
          ENDDO
          IF(FZ<0.) GOTO 20   ! not high enough yet
        ENDIF
! Find new temperature by secant method
 30     Tnew=0.5*(Ttop+Tbot)       
! Calculate remainder of zero function
          FZ=FZb
          ebfrl=0
          Ebnew=sigma*Tnew**4
          DO j=1,M
            ebfrh=bbfn(Bandwl(j)*Tnew)
            FZ=FZ+EPS(j,i)*Ebnew*(ebfrh-ebfrl)
            ebfrl=ebfrh
          ENDDO
! Check for convergence
          IF(FZ<0.) Tbot=Tnew   ! too low
          IF(FZ>0.) Ttop=Tnew   ! too high
          IF(Ttop-Tbot>Tresset) GOTO 30
          Tres=Tres+abs(T(i)-Tnew)
          T(i)=Tnew
    ENDDO ! i
    Tres=Tres/iqsp
    IF(Tres>Tresset) GOTO 5
    q=qc
    RETURN
    END
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
      REAL*4       :: VIEW,PHI,HR,RTA,RTB,XX,YY,Z,ZZ,LL,PHI1,PHI2,XY,RR1,RR2
      REAL*4       :: ARG(NARG),PI,H,W,HW,ALPHA2,R,S,X,R1,R2,RR,SS,C
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
        VIEW=(HH/X**1.5*ACOS(-HH/LL/Y)-Y*SQRT(1.-HH*HH)/X &
          -ASIN(Y/LL/LL)+PI/2.)/PI
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
      if(x<0.002 .or. y<0.002) Then
        view=0.
        return
        endif
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
      VIEW=2.*HH*(SQRT(1.+HH*HH)-H)
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
      FUNCTION PERPPLTF(X1,X2,Y1,Y2,Z1,Z2,Z3)
!  *************************************************************************
!  *  THIS SUBROUTINE EVALUATES THE VIEW FACTOR BETWEEN TWO PERPENDICULAR, *
!  *  RECTANGULAR pltf OF SIZE (X2-X1)xZ1 AND (Y2-Y1)x(Z3-Z2), DISPLACED *
!  *  FROM ANOTHER BY Z2 IN THE Z-DIRECTION, BY X1 IN THE X-DIRECTON, AND  *
!  *  BY Y1 IN THE Y-DIRECTION, IN TERMS OF VIEW FACTORS OF DIRECTLY       *
!  *  ADJACENT, IDENTICAL RECTANGLES (CONFIG. 39), AS SHOWN IN FIG.4-15a   *
!  *************************************************************************
      IMPLICIT NONE 
      REAL*4        :: PERPPLTF,X1,X2,Y1,Y2,Z1,Z2,Z3,A,F,VIEW,ARG(3)
      INTEGER       :: NARG
      NARG=3
      F=0.
      ARG(1)=Y2
      ARG(2)=Z3
      ARG(3)=X2
      A=X2*Z3
      IF(ABS(A*Y2).GT.1D-6) F=A*VIEW (39,NARG,ARG)
      ARG(1)=Y1
      A=X2*Z3
      IF(ABS(A*Y1).GT.1D-6) F=F-A*VIEW (39,NARG,ARG)
      ARG(1)=Y2
      ARG(3)=X1
      A=X1*Z3
      IF(ABS(A*Y2).GT.1D-6) F=F-A*VIEW (39,NARG,ARG)
      ARG(1)=Y1
      A=X1*Z3
      IF(ABS(A*Y1).GT.1D-6) F=F+A*VIEW (39,NARG,ARG)
      ARG(1)=Y2
      ARG(2)=Z2
      A=X1*Z2
      IF(ABS(A*Y2).GT.1D-6) F=F+A*VIEW (39,NARG,ARG)
      ARG(1)=Y1
      A=X1*Z2
      IF(ABS(A*Y1).GT.1D-6) F=F-A*VIEW (39,NARG,ARG)
      ARG(1)=Y2
      ARG(3)=X2
      A=X2*Z2
      IF(ABS(A*Y2).GT.1D-6) F=F-A*VIEW (39,NARG,ARG)
      ARG(1)=Y1
      A=X2*Z2
      IF(ABS(A*Y1).GT.1D-6) F=F+A*VIEW (39,NARG,ARG)
      ARG(1)=Y2
      ARG(2)=(Z3-Z1)
      A=X2*(Z3-Z1)
      IF(ABS(A*Y2).GT.1D-6) F=F-A*VIEW (39,NARG,ARG)
      ARG(1)=Y1
      A=X2*(Z3-Z1)
      IF(ABS(A*Y1).GT.1D-6) F=F+A*VIEW (39,NARG,ARG)
      ARG(1)=Y2
      ARG(3)=X1
      A=X1*(Z3-Z1)
      IF(ABS(A*Y2).GT.1D-6) F=F+A*VIEW (39,NARG,ARG)
      ARG(1)=Y1
      A=X1*(Z3-Z1)
      IF(ABS(A*Y1).GT.1D-6) F=F-A*VIEW (39,NARG,ARG)
      ARG(1)=Y2
      ARG(2)=(Z2-Z1)
      ARG(3)=X2
      A=X2*(Z2-Z1)
      IF(ABS(A*Y2).GT.1D-6) F=F+A*VIEW (39,NARG,ARG)
      ARG(1)=Y1
      A=X2*(Z2-Z1)
      IF(ABS(A*Y1).GT.1D-6) F=F-A*VIEW (39,NARG,ARG)
      ARG(1)=Y2
      ARG(3)=X1
      A=X1*(Z2-Z1)
      IF(ABS(A*Y2).GT.1D-6) F=F-A*VIEW (39,NARG,ARG)
      ARG(1)=Y1
      A=X1*(Z2-Z1)
      IF(ABS(A*Y1).GT.1D-6) F=F+A*VIEW (39,NARG,ARG)
      PERPPLTF=F/(2.*(X2-X1)*Z1)
      RETURN
      END
!***********************************************************************************
      FUNCTION PARLPLTF(X1,X2,X3,Y1,Y2,Y3,C)
!  *************************************************************************
!  *  THIS SUBROUTINE EVALUATES THE VIEW FACTOR BETWEEN TWO PARALLEL,      *
!  *  RECTANGULAR pltf OF SIZE X1xY1 AND (X3-X2)x(Y3-Y2), DISPLACED      *
!  *  FROM ANOTHER BY C IN THE Z-DIRECTION, BY X2 IN THE X-DIRECTON, AND   *
!  *  BY Y2 IN THE Y-DIRECTION, IN TERMS OF VIEW FACTORS OF DIRECTLY       *
!  *  OPPOSITE, IDENTICAL RECTANGLES (CONFIG. 38), AS SHOWN IN FIG.4-15b   *
!  *************************************************************************
      IMPLICIT NONE 
      REAL*4        :: PARLPLTF,X1,X2,X3,Y1,Y2,Y3,C,A,F,VIEW,ARG(3)
      INTEGER       :: NARG
      NARG=3
      ARG(1)=X3
      ARG(2)=Y3
      ARG(3)=C
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

!***********************************************************************************
      FUNCTION BBFN(X)
!     ********************************************************************
!     *  This subroutine calculates the fractional blackbody             *
!     *  emissive power f(n*lambda*T), where X=n*lambda*T in (micro-m*K) *
!     ********************************************************************
      IMPLICIT NONE
      DOUBLE PRECISION  :: BBFN,X,PI,CC,C2,EPS,V,EX,EM,VM,BM
      INTEGER           :: M
      PI=4.e0*ATAN(1.e0)
      CC=1.5e1/PI**4
      C2=1.4388e4
      EPS=1.e-16
      BBFN=1.e0
      IF(X>1.e5) RETURN
!
      V=C2/X
      EX=EXP(V)
!
      M=0
      BBFN=0.e0
      EM=1.e0
    5 M=M+1
      VM=M*V
      BM=(6.e0+VM*(6.e0+VM*(3.e0+VM)))/M**4
      EM=EM/EX
      BBFN=BBFN+BM*EM
      IF(VM**3*EM.GT.EPS) GOTO 5
      BBFN=CC*BBFN
      RETURN
      END
