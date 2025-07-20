   PROGRAM SEMIGRXCHDF
   IMPLICIT NONE
   INTEGER,PARAMETER :: N=2
   DOUBLE PRECISION :: A(N),F(N,N),EPS(2,N),HO(N),T(N),q(N),L1,L2
   integer :: id(N),iclsd,i
! Dimensions
    L1=0.8
    L2=0.6

! Surface 1 (bottom)
    A(1)=L1                         ! per unit depth
    HO(1)=866.                    ! direct solar irradiation
    EPS(1,1)=0.8; EPS(2,1)=0.1
    id(1)=1                         ! T specified
    T(1)=350.                       ! T in K
! Surface2 (left)
    A(2)=L2                         ! per unit depth
    HO(2)=500.                      ! direct solar irradiation
    EPS(1,2)=0.1; EPS(2,2)=0.8
    id(2)=0                         ! q specified
    q(2)= 0.                        ! q in W/m2
! View Factors; since configuration is open (iclsd=2), diagonal terms are also needed
    iclsd=2
! Range 1&2 have same Fij for diffuse surfaces
    F(1,1)=0.; F(1,2)=0.25; F(2,2)=0.; 
! Solve system of equations
    CALL SEMIGRAYDF(N,iclsd,A,EPS,HO,F,ID,q,T)
! Output
    write(*,10) 
    write(*,20) (i,T(i),q(i),q(i)*A(i),i=1,N)
 10 format('surface     T        q [W/m2]      Q [W]')
 20 format(i4,3x,f9.1,2e13.4)
    stop
    end
!
!******************************************************************************
    SUBROUTINE SEMIGRAYdf(N,iclsd,A,EPS,HO,F,ID,q,T)
! Routine to solve for missing surface temperatures/fluxes for the special case that
! all surfaces are diffuse reflectors; calling GRAYDIFF for 2 spectral ranges
! INPUT:
! N      = number of surfaces in enclosure
! iclsd  = closed or open configuration identifier
!          iclsd=1: configuration is closed; diagonal Fii evaluated from summation rule
!          iclsd/=1: configuration has openings; Fii must be specified
! A(N)   = vector containing surface areas, [m2]
! EPS(2,N) = matrix containing surface emittances for 2 spectral ranges
! HO(N)  = vector containing external irradiation, in [W/m2]
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
   INTEGER :: N,ID(N),iclsd,id1(N),i,j
   DOUBLE PRECISION :: A(N),F(N,N),EPS(2,N),HO(N),T(N),q(N)
   DOUBLE PRECISION :: sigma=5.670E-8,PIN(N),POUT(N),epsl(N),q1(N),HO2(N)

! First calculate fluxes for external irradiation (range 1)
    id1=1           ! all surfaces have T=0
    PIN=0.
! Set local values for eps and F
    DO i=1,N
        EPSl(i)=EPS(1,i)
    ENDDO
    CALL GRAYDIFF(N,iclsd,A,EPSl,HO,F,ID1,PIN,q1)

! Calculate unknown fluxes and temperatures by setting q2=q-q1;
! the q1 terms give rise to a "negative irradiation" term
    DO i=1,N
! Set local values for eps
        EPSl(i)=EPS(2,i)
! If closed configuration, need to also calculate diagonal terms by summation rule
        HO2(i)=-q1(i)/EPS(2,i)
        DO j=1,N
            HO2(i)=HO2(i)+(1./EPS(2,j)-1.)*F(i,j)*q1(j)
        ENDDO
! Fill PIN array with q and T
        IF(id(i)==0) THEN
            PIN(i)=q(i)
        ELSE
            PIN(i)=sigma*T(i)**4    ! Convert temperatures to emissive powers
        ENDIF
    ENDDO
    CALL GRAYDIFF(N,iclsd,A,EPSl,HO2,F,ID,PIN,POUT)

! Convert emissive powers to temperatures
    DO i=1,N
        IF(id(i)==0) THEN
            T(i)=(POUT(i)/sigma)**.25       
        ELSE
            q(i)=POUT(i)
        ENDIF
    ENDDO
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
!***********************************************************************************
      SUBROUTINE GAUSS(N,A,B,X)    
      IMPLICIT NONE
      INTEGER      :: I,N,L(N),K,J,LK
      DOUBLE PRECISION  :: A(N,N),S(N),B(N),X(N)
      DOUBLE PRECISION  :: SMAX,RMAX,R,XMULT,SUM
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
