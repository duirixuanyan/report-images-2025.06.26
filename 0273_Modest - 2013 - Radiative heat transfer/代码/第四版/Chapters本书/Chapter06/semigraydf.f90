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
