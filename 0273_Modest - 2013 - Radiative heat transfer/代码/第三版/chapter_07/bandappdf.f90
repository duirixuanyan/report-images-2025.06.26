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
   INTEGER :: M,N,ID(N),IDl(N),iclsd,i,j,k,iqsp
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
