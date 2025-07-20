   PROGRAM BANDMXCH
   IMPLICIT NONE
   INTEGER,PARAMETER :: N=2,M=2
   DOUBLE PRECISION  :: bbfn,A(N),Bandwl(M),Fs(M,N,N),EPS(M,N),RHOs(M,N),HOs(M,N),T(N),q(N),L1,L2
   INTEGER :: id(N),iclsd,i
! Spectral band limit wavelengths
    Bandwl(1)=4.                    ! wavelength in micron
! Dimensions
    L1=0.8
    L2=0.6

! Surface 1 (bottom)
    A(1)=L1                         ! per unit depth
    HOs(1,1)=1203.5*bbfn(4.D0*5777D0);  HOs(2,1)=1203.5-HOs(1,1)  ! solar irradiation including specular reflection from A2
    EPS(1,1)=0.8; RHOs(1,1)= 0.0; EPS(2,1)=0.1; RHOs(2,1)= 0.0
    id(1)=1                         ! T specified
    T(1)=350.                       ! T in K
! Surface 2 (left)
    A(2)=L2                         ! per unit depth
    HOs(1,2)=500.*bbfn(4.D0*5777D0);  HOs(2,2)=500.-HOs(1,2)  ! direct solar irradiation
    EPS(1,2)=0.1; RHOs(1,2)= 0.9; EPS(2,2)=0.8; RHOs(2,2)= 0.2
    id(2)=0                         ! q specified
    q(2)= 0.                        ! q in W/m2
! View Factors; since configuration is open (iclsd=2), diagonal terms are also needed
    iclsd=2
! Range 1&2 are the same in this problem (no specular reflected energy hits another surface)
    Fs(1,1,1)=0.; Fs(1,1,2)=0.25; Fs(1,2,2)=0.; 
    Fs(2,1,1)=0.; Fs(2,1,2)=0.25; Fs(2,2,2)=0.; 
! Solve system of equations
    CALL BANDAPP(M,N,iclsd,A,Bandwl,EPS,RHOs,HOs,Fs,ID,q,T)
! Output
    write(*,10) 
    write(*,20) (i,T(i),q(i),q(i)*A(i),i=1,N)
 10 format('surface     T        q [W/m2]      Q [W]')
 20 format(i4,3x,f9.1,2e13.4)
    stop
    end
!
!******************************************************************************
    SUBROUTINE BANDAPP(M,N,iclsd,A,Bandwl,EPS,RHOs,HOs,Fs,ID,q,T)
! Routine to solve for missing surface temperatures/fluxes calling GRAYDIFSPEC 
! for M spectral ranges
! INPUT:
! M      = number of spectral bands
! N      = number of surfaces in enclosure
! iclsd  = closed or open configuration identifier
!          iclsd=1: configuration is closed; diagonal Fsii evaluated from summation rule
!          iclsd/=1: configuration has openings; Fsii must be specified
! A(N)   = vector containing surface areas, [m2]
! Bandwl(M-1) = vector containing wavelengths separating the M spectral bands, [micro-m]
! EPS(M,N) = matrix containing surface emittances for 2 spectral ranges
! RHOs(M,N)= vector containing surface specular reflectance components
! HOs(M,N) = vector containing external irradiation, in [W/m2]
! Fs(M,N,N)= matrix containing view factors; on input only Fsij with j>i (iclsd=1) or
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
   DOUBLE PRECISION  :: A(N),Bandwl(M),Fs(M,N,N),EPS(M,N),RHOs(M,N),HOs(M,N),T(N),q(N),qc(N)
   DOUBLE PRECISION  :: bbfn,sigma=5.670E-8,Tresset=.1 !temperature residual setpoint in K
   DOUBLE PRECISION  :: PIN(N),POUT(N),epsl(N),rhosl(N),hosl(N),FSl(N,N),Tmin,Tmax
   DOUBLE PRECISION  :: fracl(N),frach(N),Eb(N),Ttop,Tbot,Tnew,Ebtop,Ebbot,Ebnew,ebfrh,ebfrl,FZ,FZb,Tres

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
        iqsp=iqsp+1                     ! number of surfaces with q specified
        T(i)=.5*(Tmin+Tmax)
    ENDDO
    Bandwl(M)=1.e5                      ! "infinity"

! Scan over spectral bands
 5  fracl=0.
! Initialize (calculated) total fluxes and emissive powers
    qc=0.
    DO i=1,N
        Eb(i)=sigma*T(i)**4
    ENDDO
    DO j=1,M
! Set local values for eps, rhos, hos, pin and Fs
      DO i=1,N
        EPSl(i)=EPS(j,i)
        RHOsl(i)=RHOs(j,i)
        HOsl(i)=HOs(j,i)
        frach(i)=bbfn(Bandwl(j)*T(i))       ! bbfn at max wavelength for band
        PIN(i)=Eb(i)*(frach(i)-fracl(i))    ! fraction of emissive power in band
        DO k=i,N
           FSl(i,k)=FS(j,i,k)
        ENDDO
      ENDDO
      fracl=frach                           ! bbfn at min wavelength for (next) band
      IDl=1                                 ! as used here ALL T's are specified
      CALL GRAYDIFSPEC(N,iclsd,A,EPSl,RHOsl,HOsl,Fsl,IDl,PIN,POUT)
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
    SUBROUTINE GRAYDIFSPEC(N,iclsd,A,EPS,RHOs,HOs,Fs,ID,PIN,POUT)
! INPUT:
! N      = number of surfaces in enclosure
! iclsd  = closed or open configuration identifier
!          iclsd=1: configuration is closed; diagonal Fsii evaluated from summation rule
!          iclsd/=1: configuration has openings; Fsii must be specified
! A(N)   = vector containing surface areas, [m2]
! EPS(N) = vector containing surface emittances
! RHOs(N)= vector containing surface specular reflectance components
! HOs(N) = vector containing external irradiation, in [W/m2]
! Fs(N,N)= vector containing view factors; on input only Fsij with j>i (iclsd=1) or
!          j>=i (iclsd/=1) are required; remainder are calculated
! ID(N)  = vector containing surface identifier:
!          ID=0: surface heat flux is specified, in [W/m2]
!          ID=1: surface temperature is specified, in [K]
! PIN(N) = vector containing surface temperatures (id=1) and fluxes (id=2)
! OUTPUT: 
! POUT(N)= vector containing unknown surface fluxes (for surfaces with id=1) and 
!           temperatures (for surfaces with id=2)
   IMPLICIT NONE
   INTEGER :: N,ID(N),iclsd,i,j,ikr
   DOUBLE PRECISION  :: A(N),Fs(N,N),EPS(N),RHOs(N),HOs(N),PIN(N),POUT(N),qm(N,N),em(N,N),pm(N,N),B(N)
! Compute missing view factors
! Lower left triangle by reciprocity
    DO i=2,N
    DO j=1,i-1
        Fs(i,j)=A(j)/A(i)*Fs(j,i)
    ENDDO
    ENDDO
! If closed configuration, need to also calculate diagonal terms by summation rule
    IF(iclsd==1) THEN
        DO i=1,N
            Fs(i,i)=1.
            DO j=1,N
                IF(j==i) CYCLE
                Fs(i,i)=Fs(i,i)-(1.-RHOs(j))*Fs(i,j)
            ENDDO
            Fs(i,i)=Fs(i,i)/(1.-RHOs(i))
        ENDDO
    ENDIF
! Fill q- and e-coefficient matrices
    DO i=1,N
    DO j=1,N
        ikr=(i/j)*(j/i)         ! Kronecker delta_ij
        qm(i,j)=ikr/EPS(j)-((1.-RHOs(j))/EPS(j)-1.)*Fs(i,j)
        em(i,j)=ikr-(1.-RHOs(j))*Fs(i,j)
    ENDDO
    ENDDO
! Fill POUT-coefficient matrix and RHS
    DO i=1,N
        B(i)=-HOs(i)
        DO j=1,N
            pm(i,j)=qm(i,j)*ID(j)-em(i,j)*(1-ID(j))
            B(i)=B(i)+(em(i,j)*ID(j)-qm(i,j)*(1-ID(j)))*PIN(j)
        ENDDO
    ENDDO
! Invert POUT-coefficient matrix and multiply by RHS to obtain POUT
    CALL GAUSS(N,pm,B,POUT)    
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
