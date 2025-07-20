module modkdistmix
! This module contains subroutines for calculation of the full-spectrum
! k-distribution for an n-component mixture from a given set of 
! individual species cumulative k-distributions (narrow band, wide
! band, or full spectrum)
! Three mixing models are provided, they are specified by mixing
! model id m in the program
!     m = 1 : superposition
!     m = 2 : multiplication
!     m = 3 : uncorrelated mixture (Modest & Riazzi model)
!
! Please see also the comments in procedures for further information.
!
! Dependency:
! This program is self-contained.
!
! The following code segment provides the user level usage:
! !-- user code example starts --------------------------------------!
! use modkdistmix, only : kdistmix
! !! the following is an example of long call statement, which
! !! specifies model, mixing calculation number of points and 
! !! integratioin scheme
! call kdistmix(k1, g1, k2, g2, k, g, mixModel, mixNop, mixScheme)
! !! the following is an example of short call statement, which
! !! mixes two species using uncorrelated mixture model and the 
! !! integration uses the default quadrature scheme with 256 quadratures
! call kdistmix(k1, g1, k2, g2, k, g)
! !-- user code example ends ----------------------------------------!
	implicit none
	private
	integer, parameter, private :: dp = kind(1.d0)
	public :: kdistmix
contains
	
subroutine kdistmix(k1, g1, k2, g2, k, g, mixmodel, mixNop, mixScheme)
! Subroutine to mixing two k-distributions using different mixing models
!
! Input variables
! k1: double precision one-dimensional array for k values of the first
!     k-distribution
! g1: double precision one-dimensional array for g values of the first
!     k-distribution, must have the same size of k1
! k2: double precision one-dimensional array for k values of the second 
!     k-distribution, size could be different from k1
! g1: double precision one-dimensional array for g values of the second
!     k-distribution, size must be the same as k2, but could be different
!     from g1 or k1
! k:  double precision one-dimensional array for k values of the mixed 
!     k-distribution, size could be different from k1 or k2
! mixmodel: an optional integer scalar specifies mixing model.
!     If not given, default value is 3 (uncorrelated mixture)
!		mixmodel = 1: superposition
!       mixmodel = 2: multiplication
!       mixmodel = 3: uncorrelated mixture (Modest and Riazzi)
! mixNop: an optional integer scalar specifies number of points for
!     internal calculation. Default value is 256. This number is only 
!     used in uncorrelated mixture mixing model (mixmodel=3).
! mixScheme: an optional integer scalar specifies integration scheme
!     for uncorrelated mixture model, currently only one integration
!     model is implemented (mixScheme=0). This number is reserved for
!     future development.
!
! Output variable
! g:  double precision one-dimensional array for g values of the mixed
!     k-distribution, size must be the same as k. 
!
! Notes:
! (1) To mix more than two species, call this mixing  subroutine
!     recursively.
!
	real(dp), dimension(:), intent(in) :: k1, k2, k
	real(dp), dimension(size(k1,1)), intent(in) :: g1
	real(dp), dimension(size(k2,1)), intent(in) :: g2
	integer, intent(in), optional :: mixmodel
	integer, intent(in), optional :: mixScheme, mixNop
	  ! user-chosen scheme and number-of-points for integration
	real(dp), dimension(size(k, 1)), intent(out) :: g
	integer :: nop, scheme, mixmod
	real(dp) :: kmax, kmin
	integer, parameter :: defaultMixNop=256, defaultMixScheme=0, defaultMixmodel=3
	if (present(mixNop)) then
		nop = mixNop
	else
		nop = defaultMixNop
	endif
	if (present(mixScheme)) then
		scheme = mixScheme
	else
		scheme = defaultMixScheme
	endif
	if (present(mixmodel)) then 
		mixmod = mixmodel
	else
		mixmod = defaultMixmodel
	endif

	select case (mixmod)
		case (3) 
			g = MRmix(k1,g1,k2,g2,k,nop,scheme)
		case (2)
			g = multiplication(k1,g1,k2,g2,k)
		case (1)
			g = superposition(k1,g1,k2,g2,k)
		case default
			write(*,*) "Unknown mixing model, stop"
			stop
	end select
end subroutine kdistmix
	
	
function multiplication(k1, g1, k2, g2, k) result(g)
	! function to mixing two k-distributions using multiplication mixing models
	real(dp), dimension(:), intent(in) :: k1, k2, k
	real(dp), dimension(size(k1,1)), intent(in) :: g1
	real(dp), dimension(size(k2,1)), intent(in) :: g2
	real(dp), dimension(size(k, 1)) :: g
	real(dp), dimension(size(k, 1)) :: gq1,gq2  
	  ! g values on k after interpolation from k1, k2
	!-- local variables
	integer :: i, nk1, nk2, nop, scheme
	real(dp) :: kmax, kmin
	nk1 = size(k1,1); nk2 = size(k2,1); nop = size(k,1)
	kmin = k1(1) + k2(1)
	kmax = k1(nk1) + k2(nk2)
	
	call linearInterpMono(nk1, k1, g1, nop, k,gq1)
	call linearInterpMono(nk2, k2, g2, nop, k,gq2)
	g = gq1*gq2
	call bound(k,g,kmin, kmax)
end function multiplication
	
function superposition(k1, g1, k2, g2, k) result(g)
	! function to mixing two k-distributions using superposition mixing models
	real(dp), dimension(:), intent(in) :: k1, k2, k
	real(dp), dimension(size(k1,1)), intent(in) :: g1
	real(dp), dimension(size(k2,1)), intent(in) :: g2
	real(dp), dimension(size(k, 1)) :: g
	real(dp), dimension(size(k, 1)) :: gq1,gq2  
	  ! g values on k after interpolation from k1, k2
	!-- local variables
	integer :: i, nk1, nk2, nop, scheme
	real(dp) :: kmax, kmin
	nk1 = size(k1,1); nk2 = size(k2,1); nop = size(k,1)
	kmin = k1(1) + k2(1)
	kmax = k1(nk1) + k2(nk2)
	
	call linearInterpMono(nk1, k1, g1, nop, k,gq1)
	call linearInterpMono(nk2, k2, g2, nop, k,gq2)
	g = gq1+gq2-1.d0
	call bound(k,g,kmin, kmax)
end function superposition
	
subroutine bound(k,g, kmin, kmax)
	! ensure good bahavior of g values
	! if k < kmin, g = 0
	! if k > kmax, g =1
	real(dp), dimension(:), intent(in) :: k
	real(dp), dimension(size(k,1)), intent(inout) :: g
	real(dp), intent(in) :: kmin, kmax
	real(dp), parameter :: ZERO = 0.d0, ONE = 1.d0
	integer :: i, nop
	nop =  size(k,1)
	g = max(g, 0.d0)
	g = min(g, 1.d0)
	do i = 1, nop
		if (k(i)<kmin) then
			g(i) = ZERO
		else if (k(i)>kmax) then
			g(i) = ONE
		endif
	enddo
	end subroutine bound
	
function MRmix(k1, g1, k2, g2, k, quadNop, quadScheme) result(g)
! Subroutine to mixing two k-distributions using Modest and Riazzi model
! Input variables:
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


end module modkdistmix
