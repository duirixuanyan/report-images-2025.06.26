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
!         j>=i (iclsd/=1) are required; remainder are calculated
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
