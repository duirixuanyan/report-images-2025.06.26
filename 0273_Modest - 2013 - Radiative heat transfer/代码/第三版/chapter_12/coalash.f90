! Code to calculate coal and ash scattering props using Buckius&Hwang and Menguc&Viskanta
   PROGRAM coalashcall
   IMPLICIT NONE
   DOUBLE PRECISION  :: n,k,x,kappa0,kappabh,betabh,kappamv,betamv
   write(*,*) 'input n, k and x'          ! ask for complex index of refraction and size parameter
   read(*,*) n,k,x
!
      call coalash(n,k,x,kappa0,kappabh,betabh,kappamv,betamv)
      write(*,10) n,k,x
      write(*,20) kappa0,kappabh,betabh,kappamv,betamv
 10     format('Index of refraction:',f7.3,'-',f5.3,'i'/    &
                   'Size parameter:     ',e12.4/)
 20     format('Rayleigh:        kappa0* =',e12.3,/   &
                   'Buckius&Hwang:    kappa* =',e12.3,',  beta* =',e12.3/     &
                   'Menguc&Viskanta:  kappa* =',e12.3,',  beta* =',e12.3)
      stop
      end
   subroutine coalash(n,k,x,kappa0,kappabh,betabh,kappamv,betamv)
   IMPLICIT NONE
! n   = refractive index
! k   = absorptive index
! x   = size parameter
! kappabh = normalized absorption coefficient using Buckius&Hwang correlation
! betabh  = normalized extinction coefficient using Buckius&Hwang correlation
! kappamv = normalized absorption coefficient using Menguc&Viskanta correlation
! betamv  = normalized extinction coefficient using Menguc&Viskanta correlation
! kappa0  = normalized Rayleigh absorption/extinction coefficient
! all 5 are normalized with f_A=total particle surface area per unit volume
   DOUBLE PRECISION  :: n,k,x,kappabh,betabh,kappamv,betamv,Fnk,kappa0,tr,r,cr,c2r,u
!
! small particle limit kappa0=beta0   
   Fnk=2.4d1*n*k/((n*n-k*k+2)**2+(2.d0*n*k)**2)
   kappa0=Fnk*x
!
! Menguc&Viskanta model   
   tr=k/(n-1.d0)
   r=atan(tr)
   cr=cos(r)
   c2r=cos(2.d0*r)
   u=2.d0*x*(n-1.d0)
   betamv=2.d0-4.d0*cr*cr/u*((sin(u-r)/cr+cos(u-2.d0*r)/u)*dexp(-u*tr)-c2r/u)
   kappamv=1.d0+dexp(-4.d0*x*k)/(2.d0*x*k)*(1.d0+1.d0/(4.d0*x*k)) &
                  -1.d0/(8.d0*(x*k)**2)
!
! Buckius&Hwang model   
   betabh=((1+6.78*kappa0**2)**(-1.2)+(3.09d0/kappa0**1.10)**(-1.2))**(-1/1.2)*kappa0
   kappabh=((1+2.30*kappa0**2)**(-1.6)+(1.66d0/kappa0**1.16)**(-1.6))**(-1/1.6)*kappa0
   return
   end
