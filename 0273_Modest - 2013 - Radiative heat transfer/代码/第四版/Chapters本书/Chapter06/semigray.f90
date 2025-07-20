!******************************************************************************
    SUBROUTINE SEMIGRAY(N,iclsd,A,EPS,RHOs,HOs,Fs,ID,q,T)
! Routine to solve for missing surface temperatures/fluxes calling GRAYDIFSPEC 
! for 2 spectral ranges
! INPUT:
! N      = number of surfaces in enclosure
! iclsd  = closed or open configuration identifier
!          iclsd=1: configuration is closed; diagonal Fsii evaluated from summation rule
!          iclsd/=1: configuration has openings; Fsii must be specified
! A(N)   = vector containing surface areas, [m2]
! EPS(2,N) = matrix containing surface emittances for 2 spectral ranges
! RHOs(2,N)= vector containing surface specular reflectance components
! HOs(N) = vector containing external irradiation, in [W/m2]
! Fs(2,N,N)= matrix containing view factors; on input only Fsij with j>i (iclsd=1) or
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
   INTEGER :: N,ID(N),iclsd,id1(N),i,j,ikr
   DOUBLE PRECISION :: A(N),Fs(2,N,N),EPS(2,N),RHOs(2,N),HOs(N),T(N),q(N)
   DOUBLE PRECISION :: sigma=5.670E-8,PIN(N),POUT(N),epsl(N),rhosl(N),FSl(N,N),q1(N),HOs2(N)

! First calculate fluxes for external irradiation (range 1)
    id1=1           ! all surfaces have T=0
    PIN=0.
! Set local values for eps, rhos and Fs
    DO i=1,N
        EPSl(i)=EPS(1,i)
        RHOSl(i)=RHOS(1,i)
        DO j=i,N
           FSl(i,j)=FS(1,i,j)
        ENDDO
    ENDDO
    CALL GRAYDIFSPEC(N,iclsd,A,EPSl,RHOsl,HOs,Fsl,ID1,PIN,q1)

! Calculate unknown fluxes and temperatures by setting q2=q-q1;
! the q1 terms give rise to a "negative irradiation" term
    DO i=1,N
! Set local values for eps, rhos and Fs
! Calculate missing viewfactors for determination of HOs2
        EPSl(i)=EPS(2,i)
        RHOSl(i)=RHOS(2,i)
        DO j=i,N
           FSl(i,j)=FS(2,i,j)
           Fsl(j,i)=A(i)/A(j)*Fsl(i,j)
        ENDDO
! If closed configuration, need to also calculate diagonal terms by summation rule
        IF(iclsd==1) THEN
            Fsl(i,i)=1.
            DO j=1,N
                IF(j==i) CYCLE
                Fsl(i,i)=Fsl(i,i)-(1.-RHOsl(j))*Fsl(i,j)
            ENDDO
        ENDIF
        HOs2(i)=-q1(i)/EPS(2,i)
        DO j=1,N
            HOs2(i)=HOs2(i)+((1.-RHOsl(j))/EPS(2,j)-1.)*Fsl(i,j)*q1(j)
        ENDDO
! Fill PIN array with q and T
        IF(id(i)==0) THEN
            PIN(i)=q(i)
        ELSE
            PIN(i)=sigma*T(i)**4    ! Convert temperatures to emissive powers
        ENDIF
    ENDDO
    CALL GRAYDIFSPEC(N,iclsd,A,EPSl,RHOsl,HOs2,Fsl,ID,PIN,POUT)

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
