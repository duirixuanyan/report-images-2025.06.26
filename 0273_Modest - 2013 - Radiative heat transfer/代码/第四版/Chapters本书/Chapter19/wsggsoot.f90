!WSGG soot subroutine written by Michael Modest based on input from Felipe Ramos Coelho
!Retrieves the soot WSGG parameters for gray soot and from Cassol et al. 2014 correlations for 2-4 gray gases
!Last updated on May 2020
!INPUT: ns=number of soot gray gases; T=temperature [in K]
!OUTPUT: wsgg parameters a(ns), k(ns)

subroutine wsggsoot(ns,T,a,k)

implicit none
integer,parameter :: np=4
integer :: i, j, ns
double precision :: T, suma
double precision :: k(ns), a(ns)
double precision :: b(ns,np+1)

!WSGG model parameters
!ns				    Number of soot gray gases
!np=4				Degree of the temperature polynomial fitting

! choosing level
if(ns==1) then
! gray soot
k=0
b=0
k(1)=258.5*T
b(1,1)=1.d0

elseif (ns==2) then
! 2 gray gases

!WSGG coefficients for soot - Cassol et al. 2014 considering 2 gray gases (Table 4)
!Soot volume fraction based absorption coefficients kfv of the gray gases
k(1)=22313.49d0			
k(2)=466624.8d0						
!Polynomial coefficients b of the gray gases
b(1,1)=0.95552d0			
b(1,2)=-1.431d-3			
b(1,3)=9.871d-7		
b(1,4)=-3.390d-10		
b(1,5)=4.555d-14		
b(2,1)=0.08010d0			
b(2,2)=1.290d-3			
b(2,3)=-7.874d-7		
b(2,4)=2.322d-10		
b(2,5)=-3.084d-14		

elseif (ns==3) then
! 3 gray gases

!WSGG coefficients for soot - Cassol et al. 2014 considering 3 gray gases (Table 5)
!Soot volume fraction based absorption coefficients kfv of the gray gases
k(1)=1251.56d0			
k(2)=50470.6d0			
k(3)=460361.0d0			
!Polynomial coefficients b of the gray gases
b(1,1)=0.02812d0			
b(1,2)=-1.271d-4			
b(1,3)=1.395d-7		
b(1,4)=-5.672d-11		
b(1,5)=8.068d-15		
b(2,1)=1.25626d0			
b(2,2)=-18.74d-4			
b(2,3)=12.09d-7		
b(2,4)=-39.89d-11		
b(2,5)=52.85d-15		
b(3,1)=-0.25179d0			
b(3,2)=18.55d-4			
b(3,3)=-11.39d-7		
b(3,4)=34.46d-11
b(3,5)=-45.58d-15

elseif (ns==4) then
! 4 gray gases

!WSGG coefficients for soot - Cassol et al. 2014 considering 4 gray gases (Table 6)
!Soot volume fraction based absorption coefficients kfv of the gray gases
k(1)=2875.86d0			
k(2)=39234.9d0			
k(3)=160748.0d0			
k(4)=495898.0d0			
!Polynomial coefficients b of the gray gases
b(1,1)=0.00129d0			
b(1,2)=-0.545d-5			
b(1,3)=0.123d-7		
b(1,4)=-0.847d-11		
b(1,5)=1.6807d-15		
b(2,1)=1.26110d0			
b(2,2)=-319.2d-5			
b(2,3)=27.72d-7		
b(2,4)=-100.5d-11		
b(2,5)=132.8d-15		
b(3,1)=-0.25757d0			
b(3,2)=362.1d-5			
b(3,3)=-40.12d-7		
b(3,4)=154.9d-11
b(3,5)=-207.8d-15
b(4,1)=0.07980d0
b(4,2)=-72.08d-5
b(4,3)=15.87d-7
b(4,4)=-70.89d-11
b(4,5)=97.69d-15

else
write(*,*) 'illegal ns'
endif

!Calculating the coefficients a
do i=1,ns
	a(i)=0.d0		!Initializing the summation
	do j=1,np+1
		a(i)=a(i)+b(i,j)*T**(j-1)	!Summation of the polynomial terms
	enddo
enddo

end subroutine
