!WSGG subroutine developed by Felipe Ramos Coelho, augmented by Michael Modest
!Retrieves the WSGG parameters from Kangwanpongpan et al. 2012 correlations
!Last updated on May 2020
!INPUT: T=temperature [K]
        p=total pressure [bar]
        pco2=partial pressure of CO2 [bar]
        ph2o=partial pressure of H2O [bar]
!OUTPUT: wsgg parameters a(ns), k(ns)

subroutine wsggKng(T,p,pco2,ph2o,a,k)

implicit none
integer :: i, j, ng, np
double precision :: T, p, pco2, ph2o, suma, MR
double precision :: k(0:ng), a(0:ng)
double precision, allocatable, dimension(:) :: kp, ck1, ck2, ck3
double precision, allocatable, dimension(:,:) :: c, c1, c2, c3

!WSGG model parameters
ng=4				!Number of gray gases excluding the transparent window
np=5				!Degree of the temperature polynomial fitting

!Allocating 1d arrays
allocate(kp(0:ng))
allocate(ck1(ng))
allocate(ck2(ng))
allocate(ck3(ng))

!Allocating 2d arrays
allocate(c(ng,np+1))
allocate(c1(ng,np+1))
allocate(c2(ng,np+1))
allocate(c3(ng,np+1))

!WSGG coefficients - Kangwanpongpan et al. 2012 for variable MR (Tables 3 and 4)
!Polynomial coefficients for the absorption coefficients kp(i) based on MR (Table 3)
ck1(1)=0.0429d0; ck2(1)=0.0093d0; ck3(1)=-0.0018d0
ck1(2)=0.3647d0; ck2(2)=0.0790d0; ck3(2)=-0.0150d0
ck1(3)=3.7144d0; ck2(3)=0.2565d0; ck3(3)=-0.0509d0
ck1(4)=105.3100d0; ck2(4)=-39.2650d0; ck3(4)=6.0877d0
		
!Polynomial coefficients for the coefficients c(i,j) based on MR (Table 4)
c1(1,1)=0.3947d0; c2(1,1)=-0.1214d0; c3(1,1)=0.0243d0
c1(1,2)=-0.4512d0; c2(1,2)=1.1420d0; c3(1,2)=-0.2296d0
c1(1,3)=0.1492d0; c2(1,3)=-5.2222d0; c3(1,3)=1.0115d0
c1(1,4)=1.8824d0; c2(1,4)=9.1820d0; c3(1,4)=-1.7493d0
c1(1,5)=-2.3284d0; c2(1,5)=-6.9298d0; c3(1,5)=1.3038d0
c1(1,6)=0.7698d0; c2(1,6)=1.9063d0; c3(1,6)=-0.3549d0
c1(2,1)=-0.4974d0; c2(2,1)=0.1092d0; c3(2,1)=-0.0179d0
c1(2,2)=6.8986d0; c2(2,2)=-2.3198d0; c3(2,2)=0.4077d0
c1(2,3)=-19.9880d0; c2(2,3)=8.0021d0; c3(2,3)=-1.4482d0
c1(2,4)=26.2080d0; c2(2,4)=-11.0070d0; c3(2,4)=2.0311d0
c1(2,5)=-16.4400d0; c2(2,5)=7.1199d0; c3(2,5)=-1.3278d0
c1(2,6)=3.9847d0; c2(2,6)=-1.7876d0; c3(2,6)=0.3349d0
c1(3,1)=0.3189d0; c2(3,1)=-0.0720d0; c3(3,1)=0.0158d0
c1(3,2)=-0.7222d0; c2(3,2)=1.0304d0; c3(3,2)=-0.2478d0
c1(3,3)=1.5053d0; c2(3,3)=-1.9350d0; c3(3,3)=0.5931d0
c1(3,4)=-1.8378d0; c2(3,4)=1.6332d0; c3(3,4)=-0.6619d0
c1(3,5)=1.0337d0; c2(3,5)=-0.7798d0; c3(3,5)=0.3857d0
c1(3,6)=-0.2107d0; c2(3,6)=0.1782d0; c3(3,6)=-0.0933d0
c1(4,1)=0.1648d0; c2(4,1)=0.0329d0; c3(4,1)=-0.0095d0
c1(4,2)=-0.6012d0; c2(4,2)=0.6942d0; c3(4,2)=-0.0687d0
c1(4,3)=2.0308d0; c2(4,3)=-3.0960d0; c3(4,3)=0.3691d0
c1(4,4)=-3.4361d0; c2(4,4)=4.7494d0; c3(4,4)=-0.5919d0
c1(4,5)=2.5803d0; c2(4,5)=-3.1714d0; c3(4,5)=0.4017d0
c1(4,6)=-0.7069d0; c2(4,6)=0.7869d0; c3(4,6)=-0.1003d0

!Calculating the mole ratio MR between H2O and CO2
MR=ph2o/pco2

!Calculating the pressure absorption coefficients kp(i) of the gray gases for this MR
do i=1,ng
	kp(i)=ck1(i)+ck2(i)*MR+ck3(i)*MR**2.d0
enddo

!Calculating the temperature dependent coefficients c(i,j) of the gray gases for this MR
do i=1,ng
	do j=1,np+1
		c(i,j)=c1(i,j)+c2(i,j)*MR+c3(i,j)*MR**2.d0
	enddo
enddo

!Calculating the coefficients a(i) using the temperature dependent coefficients c(i,j)
do i=1,ng
	a(i)=0.d0						!Initializing the summation
	do j=1,np+1
		a(i)=a(i)+c(i,j)*(T/2000.d0)**(j-1)	!Summation of the temperature polynomial terms
	enddo
enddo

!Transparent window
kp(0)=0.d0				!Pressure absorption coefficient of the transparent window is zero
suma=0.d0				!Initializing the summation
do i=1,ng
	suma=suma+a(i)		!Summation of the coefficients a from the gray gases along the domain
enddo
a(0)=1.d0-suma		!The coefficient a of the transparent window is given by 1 minus the summation

!Calculating the absorption coefficient ki of each gray gas
do i=0,ng
	k(i)=kp(i)*(ph2o+pco2)
enddo

end subroutine
