module modfskdistmix
! This module contains subroutines for full-spectrum k-distribution of
! a CO2 and H2O mixture using full-spectrum k-distribution of each
! individule species. The total pressure of the mixture is assumed to 
! be 1 bar.
! Please see also the comments in procedures for further information.
!
! Dependency:
! This program calls the following external entities:
!   (1) subroutine fskdh2o
!   (2) subroutine fskdco2
!
! The following code segment provides the user level usage:
! !-- user code example starts --------------------------------------!
! use modfskdistmix, only : fskdistmix
! !-- variable declaration starts -----------------------------------!
! real(8) :: xCO2 ! CO2 mole fraction 
! real(8) :: xH2O ! H2O mole fraction
! real(8) :: Tg   ! Local gas temperature
! real(8) :: Tp   ! Planck function temperature
! integer :: m    ! mixing model id
!                 ! m = 1 : superposition
!                 ! m = 2 : multiplication
!                 ! m = 3 : uncorrelated mixture (Modest & Riazzi)
! integer, parameter :: fsknop = 64 
!                 ! number of points for the k-distribution
! real(8), dimension(fsknop) :: k
!                 ! a list of k values supplied to mixing routine
!                 ! k should be linear based
! real(8), dimension(fsknop) :: g
!                 ! corresponding g values calculated from fskdistmix
! integer :: errflag
!                 ! error flag
!                 ! errflag = 0 : no error
!                 ! errflag = 1 : error found, e.g. unknown mixing
!                 !               model id
! !-- variables declaration ends ------------------------------------!
! !-- calculation starts --------------------------------------------!
! call fskdistmix(xCO2, xH2O, Tg, Tp, k, g, m, errflag)
! !-- calculation ends ----------------------------------------------!
! !-- user code example ends ----------------------------------------!
!

implicit none
private
integer, parameter, private :: dp=kind(1.d0) 
	! size parameter for double precision
public:: &
	fskdistmix, & ! mixing co2 and h2o using correlation
	quadgen2	! generate quadrature values
!	MRmix, & ! Modest & Riazzi mixing model
!	linearInterpMono! linear interpolation for monotonic array
!--   Please uncomment the above two lines to make them accessible if 
!--   user intends to use the above two procedure

contains

subroutine fskdistmix(xCO2, xH2O, Tg, Tp, kq, gq, m,nop, errflag)
! finds the full spectrum cumulative k-distribution for a CO2–H2O 
! mixture, employing the correlations of Modest and Mehta for CO2 
! and Modest and Singh for H2O, using one of three mixing schemes 
! described by equations (20.162) (superposition), (20.163) 
! (multiplication), or (20.167) (uncorrelated mixture).
! Input variables:
!    xCO2: CO2 mole fraction
!    xH2O: H2O mole fraction
!    Tg: (local) gas temperature 
!    Tp: Planck function temperature
!    m: integer to specify mixing model
!		m = 1: superposition
!       m = 2: multiplication
!       m = 3: uncorrelated mixture (Modest and Riazzi)
!    nop: number of points for internal calculation
!    gq: a list of g values on which the corresponding k is
!       determined
! Output variables:
!    errflag: error flag
!       errflag = 0: no error
!       errflag = 1: error is found, e.g. unknown mixing model id
!    g: the corresponding g values for the given k, it has the
!       same size and shape as k
! Note:
! (1) If either species mole fraction is zero, no mixing is performed
! and the specified mixing id number will be ignored
! (2) To ensure accuracy of uncorrelated mixing model, k values 
! should range from sufficiently small (e.g. 1.d-9) to sufficiently 
! large (e.g. 1.d2).
! (3) If both CO2 and H2O have zero mole fraction, all output g values
! are 1. This is consistent with the k-distribution from a spectral 
! window where the absorption coefficient is zero over the spectrum.
real(dp), intent(in) :: xCO2, xH2O, Tg, Tp
integer, intent(in) :: m  ! mixing model 
integer, intent(in) :: nop  ! number of points for internal calculation
integer, intent(out) :: errflag ! error flag
real(dp), dimension(:), intent(in) :: gq
real(dp), dimension(size(gq,1)), intent(out) :: kq
! local variables
integer :: nq, ik, mix
real(dp), dimension(nop) ::k,g, gCO2, gH2O
real(dp) :: kp ! pressure based k value, not planck mean
real(dp), parameter :: kmin=1.d-9, kmax=1.d2
nq = size(kq,1) ! number of quadratures
k = kPowerLaw(kmin, kmax, nop, 0.1d0)
mix=m;gCO2=1.d0;gH2O=1.d0
if (xCO2.gt.0.d0) then
    do ik=1, nop
        kp=k(ik)/xCO2
        call fskdco2(Tg, Tp, kp, gCO2(ik))
        ! k in correlation is pressure based
    end do
else
    mix=1
    ! if single species is present, bypass mixing calculation
    ! by calling the simplest sum model
endif

if (xH2O.gt.0.d0) then
    do ik=1, nop
        kp=k(ik)/xH2O
        call fskdh2o(Tg, Tp, kp, xH2O, gH2O(ik))
        ! k in correlation is pressure based
    enddo
else
    mix=1
endif

select case (mix)
    case (1) ! if only one species is present, no mixing model is used. 
            !sum is sufficient, because either gH2O or gCO2 has all 1
        g=gH2O+gCO2-1.d0
    case (3) ! M&R mix model
        g=MRmix(k, gH2O, k, gCO2, k, 4*nq, 0) 
    case (2) ! multiplication 
        g=gH2O*gCO2
    case default
        errflag=1
        print*, "Unknown mixing model number"
end select
call linearInterpMono(nop, g, k, nq, gq, kq)
errflag=0

end subroutine fskdistmix

function MRmix(k1, g1, k2, g2, k, quadNop, quadScheme) result(g)
! Subroutine to mixing two k-distributions using Modest and Riazzi model
! Input variables:
!    k1: k values for the first species
!    g1: g values corresponding to k1 for the first species, must have
!        the same shape and size as k1
!    k2: k values for the second species
!    g2: g values corresponding to k2 for the second species, must have
!        the same shape and size as k2
!    k:  a list of k values on which g values are determined
!    quadNop: Optional integer to specify number of quadrature used
!        for integral. If not given, a default value of 64 is used. 
!        The default value is given by defaultQuadNop
!    quadScheme: Optional integer to specify quadrature scheme used
!        for integral. Currently only one is implemented. If not given,
!        a default value of 0 is used. The default value is given by
!        defaultQuadScheme.
! Output variables:
!    g: g values for this mixing on the given k values. g has the same
!       shape and size as k.
! Notes:
! (1) The integration is over g1, so if g1 is defined over quadrature points
! then interpolation has no errors
! (2) If multiple species are mixed and they are databased on quadrature points
! then it is possible to mix them one by one, and input previously mixed k-g as k2 g2
! (3) There are different ways to perform integration numerically, user may choose
! one by specifying "quadScheme" and "quadNop"
! (4) k1 and k2 can have different sizes
! (5) If other integration rules are needed, just add a new scheme number and a different
! set of weights
! (6) By default 64 points quadrature open at both ends will be used for integration

real(dp), dimension(:), intent(in) :: k1, k2, k
real(dp), dimension(size(k1,1)), intent(in) :: g1
real(dp), dimension(size(k2,1)), intent(in) :: g2
integer, intent(in), optional :: quadScheme, quadNop
  ! user-chosen scheme and number-of-points for integration
real(dp), dimension(size(k, 1)) :: g
real(dp), dimension(:), allocatable :: gq1,gq2, wq1 
  ! quad points and weights to perform numerical integration
real(dp), dimension(:), allocatable :: kq1, kq2 
  ! k1 and k2 interpolate at quad points
integer :: i, nk1, nk2, nop, scheme
real(dp) :: kmax, kmin
integer, parameter :: defaultQuadNop=64, defaultQuadScheme=0
if (present(quadNop)) then
  nop = quadNop
else 
  nop = defaultQuadNop
endif
if (present(quadScheme)) then
  scheme = quadScheme
else 
  scheme = defaultQuadScheme
endif
allocate(gq1(nop),gq2(nop),wq1(nop),kq1(nop),kq2(nop))
select case (scheme)
  case (0)
    call quadgen2(.false., gq1, wq1, nop)
  case default
    print*, 'Not implemented yet'; stop
end select
g = 1.d0 ! initialize g
nk1 = size(k1,1); nk2 = size(k2,1)
! interpolate g1 to quad points
call linearInterpMono (nk1, g1, k1, nop, gq1, kq1)
kmin = k1(1) + k2(1) ! assumes k1 and k2 are monotonic
kmax = k1(nk1) + k2(nk2)

do i = 1, size(k,1)
  if (k(i) .lt. kmin) then
    g(i) = 0.d0; cycle    ! k is too small, next loop
  endif
  if (k(i) .gt. kmax) exit ! k is too large, no need to loop other k's
  kq2 = k(i) - kq1
  ! kq2 is in descent order
  call linearInterpMono  (nk2, k2, g2, nop, kq2(nop:1:-1), gq2(nop:1:-1))
  gq2 =max(gq2, 0.d0) ! lower bound zero
  g(i) = sum(gq2*wq1)
enddo
deallocate(gq1, gq2, wq1, kq1, kq2)
end function MRmix

function kPowerLaw (kmin,kmax, n, pwr) result(k)
! function generate a list of k values between kmin and kmax
! according to power law with power "pwr"
integer, parameter :: dp = kind(1.d0)
real(dp),  intent(in):: kmin, kmax, pwr
integer, intent(in) :: n
real(dp), dimension(n) :: k
real(dp) :: pwrk_min, pwrk_max, pwrk_step
integer :: i
pwrk_min = kmin**pwr
pwrk_max = kmax**pwr
pwrk_step = (pwrk_max-pwrk_min)/real(n-1, dp)
k = (/(pwrk_min+real(i-1,dp)*pwrk_step, i=1, n)/)
k = k**(1.d0/pwr)
end function kPowerLaw

subroutine linearInterpMono(nxy, xx, yy, ni, xi, yi) 
! simple linear interpolation using closest points
! constant value for extrapolation
! assume xx and xi are monotonically increasing
! (1) It is assumed that xx is in ascendant order, which is typical for
!     linear interpolation
! (2) xi is also assumed to be in ascendant order, which improves search
!     speed
! (3) Constant extrapolation using two boundary values.
integer, intent(in) :: nxy, ni 
integer, parameter :: dp = kind(1.d0)
real(dp), dimension(nxy), intent(in) :: xx, yy
real(dp), dimension(ni), intent(in) :: xi
real(dp), dimension(ni), intent(out) :: yi
integer :: i, n 
n = 1
loopi:do i = 1, ni 
  do while (xi(i).ge.xx(n))
    ! xi(i) is not in interval xx(n-1) to xx(n)
    n = n + 1 ! then move to next interval
    if (n .gt. nxy) then ! xi(i) is larger than the largest xx
      ! out of bound and use constant value
      yi(i:ni) = yy(nxy) 
      exit loopi ! no need to perform further calculation
    end if  
  end do  
  ! now xi(i) is between xx(n-1) and xx(n), except xi(i) is smaller than xx(1)
  if (n.eq.1) then 
    ! xi(i) is smaller than the smallest of xx
    yi(i) = yy(1) 
  else 
    yi(i) = yy(n)+(yy(n-1)-yy(n))*(xi(i)-xx(n))/(xx(n-1)-xx(n))
  end if  
end do loopi
end subroutine linearInterpMono

SUBROUTINE quadgen2(Cheb2,g,w,NoP,alpha) ! quadrature open at both ends
  IMPLICIT NONE
  LOGICAL,INTENT(IN)    :: Cheb2
  INTEGER,INTENT(IN)    :: NoP  
  REAL(8),INTENT(IN),optional    :: alpha  ! transformation factor
  REAL(8),INTENT(OUT)   :: g(NoP),w(NoP)
!local variables
  REAL(8) :: gg(2*NoP),ww(2*NoP),dummy
  INTEGER(2) :: i

    CALL gaucheb2(gg,ww,2*NoP)
    g= -gg(NoP+1:2*NoP)
    w= ww(NoP+1:2*NoP)
    IF ((.not.Cheb2).and.(.not. PRESENT(alpha))) THEN
	! transformation on Gauss-Chebyshev2 quadrature
      DO i=1, NoP
        w(i)= 1.5d0*SQRT(1.d0-g(i))*w(i)
        g(i)= 1.d0-(1.d0-g(i))**1.5
      ENDDO   
    ELSEIF((.not.Cheb2).and.(PRESENT(alpha))) THEN
      DO i= 1, NoP
        w(i)= alpha*w(i)*(1.d0-g(i))**(alpha-1.d0)
        g(i)= 1.d0-(1.d0-g(i))**alpha
      ENDDO   
    ENDIF   
    dummy= SUM(w(1:NoP))
    w(1:NoP)=w(1:NoP)/dummy
END SUBROUTINE quadgen2

! Gaussian quadrature calculation subroutine 
SUBROUTINE gaucheb2(x,w,n)
IMPLICIT NONE
  INTEGER :: n
  DOUBLE PRECISION,PARAMETER :: PI= 3.1415926535897932384626
  REAL(8) :: x(n),w(n)
  DOUBLE PRECISION :: theta, sum
  INTEGER :: m,k
!xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx> By: Anquan Wang <xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!
! DISCRIPTION:                                                                                       !
!   Calculate the zeros and weights of Tchebysheff polynomial of 2nd kind                            !
!   The zeros can be used as abscissas of Gaussian quadrature which are distributed between (-1,1)   !
!   The integral can be evaluated in the form:                                                       !
!                         Integral(f(x)*dx)= Sum(Wi*f(xi))                                           !
!----------------------------------------------------------------------------------------------------!
! PARAMETERS:                                                                                        !
!   n    -> the degree of Tchebyscheff polynomial of 2nd kind                                        !
!   x(n) -> the array of abscissas                                                                   !
!   w(n) -> the array of weights                                                                     !
!----------------------------------------------------------------------------------------------------!
! MEMO:                                                                                              !
!   P. J. Davis and P. Rabinowitz, Methods of Numerical Integration, 2nd edt, pp85, eqn(2.5.5.6,.8)  !
!xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx> 2003-06-02 <xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx!
  DO k= 1,(n+1)/2
    theta= REAL(k)*PI/(n+1.d0)
    x(k)= DCOS(theta)
    sum= 0.d0
    DO m= 1,(n+1)/2
      sum= sum+DSIN((2*m-1)*theta)/(2.d0*m-1.d0)
    ENDDO   
    w(k)= 4.d0*DSIN(theta)*sum/(n+1.d0)
    x(n+1-k)= -x(k)
    w(n+1-k)= w(k)
  ENDDO
END SUBROUTINE gaucheb2


end module modfskdistmix

