      subroutine wbkvsg(beta,kmax,kmin,n,k,g)
c this subroutine calculates the cumulative, nondimensional k-distribution for an
c exponential wide band (for S/d) combined with the Malkmus narrow band model. 
c input:
c   beta = line overlap parameter
c   kmax = maximum kappa_star desired, = k(1)
c   kmin = minimum kappa_star desired, = k(n)
c   n    = number k vs g points desired
c output:
c   k(i) = nondimensional, reordered absorption coefficient kappa_star, dimension n
c   g(i) = nondimensional cumulative k-distribution g_star, dimension n
c
c integral is evaluated by simple 1-4-1 Newton-Cotes scheme, after transforming 
c integration variable and f(k) from k to a=ln(sqrt(k)), using equally spaced points in a
c
      IMPLICIT NONE
      integer n,n1,ik,nk,nst,nd
      real*8 amax,amid,amin,beta,dela,delamin,fstar,k(n),kmax,kmin,ki,
     1  aim0,aimh,aim1,fim0,fimh,fim1,gim0,g(n)
        delamin=0.02
c
c a=ln(sqrt(kstar)), amax = max value needed for recursion formula
c                    amid = value of a corresponding to kmax
c                    amin = value of a corresponding to kmin
c if too few points are specified (n too small), more points are calculated, but only
c every nst value is recorded
      amax=.5d0*dlog(1.d5)
      IF(kmax>1.d5) THEN
        write(*,*) 'kmax set to 1.d5'
        kmax=1.d5
      ENDIF
      amid=.5d0*dlog(kmax)
      amin=.5d0*dlog(kmin)
      dela=.5*(amid-amin)/(n-1)
      nst=0.99+dela/delamin
      dela=dela/nst
      n1=.5*(amax-amid)/dela+1
      amax=amid+2*n1*dela
      nk=0
      nd=n1
c Newton-Cotes integration; aim1=a(i-1), aimh=a(i-1/2), aim0=a(i); fim1=(2k*fstar)(i-1), etc.
      aim0=amax
      ki=kmax 
      fim0=0.d0
      gim0=0.d0
      do ik=1,n1+n*nst-1
        aim1=aim0
        aimh=aim1-dela  
        aim0=aimh-dela 
        ki=exp(2.d0*aim0) 
        fim1=fim0
        fimh=fstar(beta,aimh)
        fim0=fstar(beta,aim0)
        gim0=gim0+dela/1.5d0*(fim1+4.d0*fimh+fim0)
c place into k and g arrays
        if(ik.eq.nd) then
          nd=nd+nst
          nk=nk+1
          k(nk)=ki
          g(nk)=gim0
        endif
      enddo
      return
      end
      function fstar(b,lk)
c nondimensional k-distribution, scaled by a factor of 2kappa_star, for an exponential 
c wide band (for S/d) combined with the Malkmus narrow band model. 
c input:
c   b    = line overlap parameter
c   lk   = ln(sqrt(kappa_star))
c output:
c   fstar= nondimensional, k-distribution, scaled by a factor of 2kappa_star
c
      IMPLICIT NONE
      real*8 b,lk,fstar,derfc
      fstar=(derfc(dsqrt(b)*dsinh(lk))-exp(b)*derfc(dsqrt(b)*dcosh(lk)))/2.d0
      return
      end
