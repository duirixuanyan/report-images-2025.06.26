!      Main program for calculation of temperature distribution
!      in a slab subjected to radiative surface heating from the top
!      Example 8.1 (Radiative Heat Transfer, 4th Edition, Modest & Mazumder)
!      Uses EXPLICIT coupling

!      Written by Sandip Mazumder
!      For queries, contact: mazumder.2@osu.edu

   program ExStoSEn1D

   IMPLICIT NONE

! User Inputs
! Physical

   REAL(8), PARAMETER :: e_slab=0.7d0, & ! Emittance of slab
                                           e_wall=0.1d0, & ! Emittance of furnace wall
                                           e_heater=0.24d0, & ! Emittance of heater patch
                                           t_inf=300.0d0, & ! Ambient temperature
                                           t_wall=350.0d0, & ! Temperature of furnace wall
                                           t_heater=2000.0d0, & ! Temperature of heater
                                           kc = 30.0d0, & ! Thermal conductivity of slab
                                           ho = 10.0d0, & ! Convective htc on slab bottom
                                           length = 0.2d0, & ! Length of slab/furnace
                                           height = 0.05d0, &  ! Height of furnace
                                           Ls = 0.001d0 ! Thickness of slab

! Numerical

   INTEGER(8), PARAMETER :: max_iter = 200 ! maximum number of Outer iterations

   REAL(8), PARAMETER ::  tol = 1.0d-6, & ! Tolerance for convergence
                                            omega = 0.3d0 ! Relaxation factor

   INTEGER(8), PARAMETER :: nx=20, & ! number of slab control volumes
                                                 nf=nx+5 ! number of surface elements used in VF analysis
   INTEGER(8) :: i,ifc1,ifc2,ifc,neq,iter
   REAL(8), PARAMETER :: zero=0.0d0,sigma=5.67d-8
   REAL(8) :: dx,side1,side2,diag1,diag2,area1,sum1,xf,yf,Li, qsum, res
   REAL(8), DIMENSION(nf,2) :: xv,yv
   REAL(8), DIMENSION(nf,nf) :: vfac,aa,cc,ccc
   REAL(8), DIMENSION(nf) :: emis,tbc,rhs,qrad,area
   REAL(8), DIMENSION(nx,nx) :: amat
   REAL(8), DIMENSION(nx) :: rmat,tnew
!-------------------------------------------------------------------------------------------------------------------------

! Files to print
  OPEN(unit=10,file="ExStoSEn1D.dat",status="unknown") ! T and Flux
  OPEN(unit=20,file="ExStoSEn1D_residual.dat",status="unknown") ! Residual

! Define grid spacing
  Li = length/nx
  dx = length/nx

! Number faces for VF analysis
! Bottom Faces
  ifc = 4
  xv(ifc,1) = zero
  xv(ifc,2) = xv(ifc,1)+dx
  DO ifc = 5,nx+4-1
    xv(ifc,1) = xv(ifc-1,2)
    xv(ifc,2) = xv(ifc,1)+dx
  ENDDO
  yv(4:nx+4-1,:) = zero
! Top faces
  xv(1,2) = 0.1d0
  xv(1,1) = xv(1,2)+dx
  xv(2,2) = zero
  xv(2,1) = 0.1d0
  xv(nf,1) = length
  xv(nf,2) = 0.1d0+dx
  yv(1:2,:) = height
  yv(nf,:) = height
! Left Faces
  ifc = 3
  yv(ifc,2) = zero
  yv(ifc,1) = yv(ifc,2)+height
  xv(ifc,:) = zero
! Right Faces
  ifc = nf-1
  yv(ifc,1) = zero
  yv(ifc,2) = yv(ifc,1)+height
  xv(ifc,:) = length

! Compute View Factors (Crossed-string method)
  DO ifc1 = 1,nf
    area1 = SQRT((xv(ifc1,2)-xv(ifc1,1))**2 + (yv(ifc1,2)-yv(ifc1,1))**2)
    DO ifc2 = 1,nf
      diag1 = SQRT((xv(ifc1,1)-xv(ifc2,1))**2 + (yv(ifc1,1)-yv(ifc2,1))**2)
      diag2 = SQRT((xv(ifc1,2)-xv(ifc2,2))**2 + (yv(ifc1,2)-yv(ifc2,2))**2)
      side1 = SQRT((xv(ifc1,1)-xv(ifc2,2))**2 + (yv(ifc1,1)-yv(ifc2,2))**2)
      side2 = SQRT((xv(ifc1,2)-xv(ifc2,1))**2 + (yv(ifc1,2)-yv(ifc2,1))**2)
      IF(ifc1 == ifc2)THEN
        vfac(ifc1,ifc2) = zero
      ELSE
        vfac(ifc1,ifc2) = ABS((diag1+diag2-side1-side2)/(2.0d0*area1))
      ENDIF
    ENDDO
  ENDDO

! Set Emissivities and boundary temperatures
  emis(1) = e_heater; area(1) = dx
  emis(2:3) = e_wall; area(2) = 0.1d0; area(3) = height
  emis(4:nx+4-1) = e_slab; area(4:nx+4-1) = dx
  emis(nx+4:nf) = e_wall; area(nx+4) = height; area(nf) = 0.1d0-dx
  
  tbc(1) = t_heater
  tbc(2:3) = t_wall
  tbc(4:nx+4-1) = t_inf
  tbc(nx+4:nf) = t_wall

! Compute Coeff Matrix
  DO ifc1 = 1,nf
    DO ifc2 = 1,nf
      IF(ifc1 == ifc2)THEN
        cc(ifc1,ifc2) = 1.0d0/emis(ifc2)-(1.0d0/emis(ifc2)-1.0d0)* &
                        vfac(ifc1,ifc2)
        aa(ifc1,ifc2) = 1.0d0-vfac(ifc1,ifc2)
      ELSE
        aa(ifc1,ifc2) = -vfac(ifc1,ifc2)
        cc(ifc1,ifc2) = -(1.0d0/emis(ifc2)-1.0d0)*vfac(ifc1,ifc2)
      ENDIF
    ENDDO
  ENDDO

! Start of Outer iteration loop

  DO iter = 1,max_iter

    ccc(:,:) = cc(:,:)
    DO ifc1 = 1,nf
      sum1 = 0.0d0
      DO ifc2 = 1,nf
        sum1 = sum1 + aa(ifc1,ifc2)*sigma*(tbc(ifc2)**4)
      ENDDO
      rhs(ifc1) = sum1
    ENDDO

    CALL gauss_elim(nf,ccc,rhs,qrad)

! Conduction Calculation
    amat(:,:) = zero
    rmat(:) = zero
    amat(1,1) = ho*(Li+Ls) + kc*Ls/Li
    amat(1,2) = -kc*Ls/Li
    rmat(1) = ho*t_inf*(Li+Ls)-qrad(1+3)*Li
    DO i = 2,nx-1
      amat(i,i) = ho*Li + 2.0d0*kc*Ls/Li
      amat(i,i+1) = -kc*Ls/Li
      amat(i,i-1) = -kc*Ls/Li
      rmat(i) = ho*t_inf*Li-qrad(i+3)*Li
    ENDDO
    amat(nx,nx) = ho*(Li+Ls) + kc*Ls/Li
    amat(nx,nx-1) = -kc*Ls/Li
    rmat(nx) = ho*t_inf*(Li+Ls)-qrad(nx+3)*Li

    CALL gauss_elim(nx,amat,rmat,tnew)

! Compute Residual
    qsum = zero
    DO i = 4,nx+4-1
      qsum = qsum + (tbc(i)-tnew(i-3))**2
    ENDDO
    res = SQRT(MAX(zero,qsum))
    print *, iter, res
    WRITE(20,*) iter, res
   
    IF(res < tol) EXIT

! Reset Slab Temperature
    DO i = 4,nx+4-1
      tbc(i) = omega*tnew(i-3) + (1.0d0-omega)*tbc(i)
    ENDDO

  ENDDO ! Outer Iteration loop

! Printing Heat Fluxes and Temperature
  qsum = zero
  DO ifc1 = 1,nf
    xf = (xv(ifc1,2)+xv(ifc1,1))/2.0d0
    yf = (yv(ifc1,2)+yv(ifc1,1))/2.0d0
    WRITE(10,11) xf,yf,tbc(ifc1),qrad(ifc1)
    qsum = qsum + qrad(ifc1)*area(ifc1)
  ENDDO

11 format(3(2x,F12.6),1x,E14.6)

  CLOSE(unit=10)
  CLOSE(unit=20)

  END program ExStoSEn1D 

!-----------------------------------------------------------------------
  SUBROUTINE gauss_elim(n,a,b,x)
!-----------------------------------------------------------------------
!
! Purpose: Solves a set of linear algebraic equations.
!          Using Gaussian Elimination
!
!          n = number of equations (input)
!          a = nxn coefficient matrix (input)
!          b = right hand vector (input)
!          x = solution vector (output
!
!-----------------------------------------------------------------------

   IMPLICIT NONE
   INTEGER(8) :: i,j,k
   INTEGER(8) , INTENT(IN) :: n
   REAL(8) :: sum1,xmult
   REAL(8) :: b(n),a(n,n)
   REAL(8), INTENT(OUT) :: x(n)
!-----------------------------------------------------------------------

   DO k = 1,n-1
     DO i = k+1,n
       xmult = a(i,k)/a(k,k)
       DO j=k+1,n
         a(i,j) = a(i,j)-xmult*a(k,j)
       ENDDO
       a(i,k) = xmult
       b(i) = b(i) - xmult*b(k)
     ENDDO
   ENDDO
   x(n) = b(n)/a(n,n)
   DO i = n-1,1,-1
      sum1 = b(i)
      DO j = i+1,n
         sum1 = sum1 - a(i,j)*x(j)
      ENDDO
      x(i) = sum1/a(i,i)
   ENDDO

   END SUBROUTINE gauss_elim
