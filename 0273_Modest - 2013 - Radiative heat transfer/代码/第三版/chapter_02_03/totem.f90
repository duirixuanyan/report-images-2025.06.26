   PROGRAM TOTEM
! Program to evaluate the total, directional-or-hemispherical emittance of an opaque material
! INPUT (by changing values in FUNCTION emlcl(y) below:
!   N       = number of data points for spectral, directional-or-hemispherical emittance
!   nrefr   = refractive index of adjoining material (=1 for vacuum and gases)
!   T       = temperature of opaque material if total emittance is desired, in K, or
!             temperature of gray radiating source if total absorptance is desired
!   eps(N)  = N values of data points for spectral, directional-or-hemispherical emittance
!   lambda(N)= corresponding N values of wavelengths, in micrometer
! OUTPUT
!   emitt   = total emittance or absorptance
! NOTE: 
! FUNCTION emlcl(y) uses linear interpolation to evaluate spectral emittances between data points
!
   IMPLICIT NONE
   INTEGER              :: i
   DOUBLE PRECISION     :: emlcl,emitt
! Gaussian quadrature weights
   DOUBLE PRECISION,PARAMETER :: w(5)=(/.2955242247,.2692667193,.2190863625, &
                                      .1494513491,.0666713443/)
! Original Gaussian quadrature values x(i) given for completeness; the y_i=n*lambda*T are the values
! corresponding to f(n*lambda*T)=x=.5*(1+-x_i)
   DOUBLE PRECISION,PARAMETER :: x(5)=(/.1488743389,.4333953941,.6794095682, &
                                      .8650633666,.9739065285/)
   DOUBLE PRECISION,PARAMETER :: y(10)=(/1503.32158713938,2004.78303570275,2495.09250579963, &     
                                         3044.62899329486,3709.12502109211,4567.40650306271, &     
                                         5762.97273448694,7613.99482631694,11045.6325211325, &
                                         20764.7554806188/)
   
   emitt=0.e0
   DO i=1,5
     emitt=emitt+w(6-i)*emlcl(y(i))+w(i)*emlcl(y(i+5))
   ENDDO
   emitt=.5e0*emitt
   write(*,10) emitt
10 format('Total emittance =',f7.4)
   stop
   end
   FUNCTION emlcl(y)
   IMPLICIT NONE
   INTEGER,PARAMETER :: N=2
   INTEGER           :: i
   DOUBLE PRECISION    :: emlcl,y,wl,nrefr=2.,T=500.
! Material of Problem 3.1,  N=2
   DOUBLE PRECISION,PARAMETER :: lambda(N)=(/4.9,5./)
   DOUBLE PRECISION,PARAMETER :: eps(N)=(/.5,.3/)
! Aluminum oxide, Fig. 1-13,  N=8
!   DOUBLE PRECISION,PARAMETER :: lambda(N)=(/1.,2.,3.,4.,5.,6.,7.,8./)
!   DOUBLE PRECISION,PARAMETER :: eps(N)=(/.12,.13,.15,.20,.33,.65,.88,.98/)
   wl=y/(nrefr*T)
   IF(wl<lambda(1)) THEN
        emlcl=eps(1)
   ELSEIF(wl>lambda(N)) THEN
        emlcl=eps(N)
   ELSE
        DO i=2,N
        IF(wl>lambda(i)) CYCLE
        emlcl=(eps(i-1)*(lambda(i)-wl)+eps(i-1)*(wl-lambda(i-1)))/(lambda(i)-lambda(i-1))
        EXIT
        ENDDO
   ENDIF
   RETURN
   END
