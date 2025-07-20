c*********************************************************************     
c
c     m312s.f
c
c***********************************************************************
c     This file contains the subroutines called by input3 matinnew and
c     matinold to cumdis. These can be described as all the subroutines which 
c     deal with material properies and material property curves. They are: 
c     coeff2, cumdis, curveset, matinnew, matinold, readcrv, readhdrnew, 
c     readhdrold, and readmatnew
c***********************************************************************
c
      subroutine coeff2 (x1,x2,x3,y1,y2,y3,a,b,c)
c
c***********************************************************************
c     subroutine to calculate coefficients a,b,c (given three points 
c       (x1,y1),(x2,y2),x3,y3)) for the parabolic equation,          
c       y=a*x**2 + b*x + c                                           
c***********************************************************************
c
      include 'mont3d.par'
c
      a = ((y1 - y3) - (x1 - x3)*(y2 - y3)/(x2 - x3))/
     $  ((x1**2 - x3**2) + (x3 - x1)*(x2 + x3))
      b = (y2 - y3 - a*(x2**2 - x3**2))/(x2 - x3)
      c = (y3 - a*x3**2 - b*x3)
c
      return
      end
c
c***********************************************************************
c
      subroutine cumdis
c
c***********************************************************************
c     subroutine to calculate cumulative distribution fcn.             
c        resulting in r vs. thetar- cone angle                         
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      write (6,1000)
      call header 
c
c     loop over materials and bands
c
      do 200 mn = 1,nummat
         do 199 ib = 1,nbands
c
c           Case of emission where alpha is everywhere 0 (no emission)
c
            if (noep(mn,ib).eq.1) then
               embar(mn,ib) = 0.0
c
c           Case of beam emission
c
            else if (ietp(mn,ib).eq.1) then
               embar(mn,ib) = 1.0
            else
c
c     Integrate curve to get average emissivity
c
               told = 0.
               eold = alpha(0,mn,ib)
               sum = 0.
c
   60          tnew = told + delt
               if (tnew.gt.90.) then
                  tnew = 90.
               end if
               it = tnew
               frac = tnew - it
               enew = alpha(it,mn,ib) + frac*dalpha(it,mn,ib)
               ebar = 0.5*(eold + enew)
               if (ebar.lt.0.) then
                  write (10,3001) mn,ib,eold,enew,tnew
                  write (6,3001) mn,ib,eold,enew,tnew
                  ebar = 0.
               end if
               dsum = ebar*(sin(tnew*dtor)**2 - sin(told*dtor)**2)
               sum = sum + dsum
               told = tnew
               eold = enew
               if (tnew.lt.90.) then
                  goto 60
               end if
c
               embar(mn,ib) = sum
c
c     if ietp = 2 (function emission) no thetar array is used       
c
               if (ietp(mn,ib).eq.2) then
c
c     goto next band
c
                  goto 199
               end if
c
c     get r (theta) vs. theta in 0.01 increments (thetar)
c
               told = 0.
               eold = alpha(0,mn,ib)
               rsave = 0.
               rsum = 0.
               iaddr = 0
               thetar(0,mn,ib) = 0.
  110          tnew = told + delt
               if (tnew.ge.90.) then
                  tnew = 90.
               end if 
               it = tnew
               frac = tnew - it
               enew = alpha(it,mn,ib) + frac*dalpha(it,mn,ib)
               ebar = 0.5*(eold+enew)
               dsum = ebar*(sin(tnew*dtor)**2 - sin(told*dtor)**2)/sum
               if (dsum.gt.0.01) then
                  write (10,3002)
                  write (10,3003) mn,ib,ebar,tnew,told,dsum
                  call adios(2, 0, 0)
               end if
               rsum = rsum+dsum
               told = tnew
               eold = enew
               if ((rsum - rsave).lt.0.01) then
                  goto 110
               end if 
c
c     get and save theta at the crossover point
c
               rsave = rsave + 0.01
               slope = delt/dsum
               iaddr = iaddr + 1
               delr = rsave - (rsum - dsum)
               th = told - delt + slope*delr
               thetar(iaddr,mn,ib) = th*dtor
               if (iaddr.eq.99) then 
                  thetar(100,mn,ib) = pi2
               else if (tnew.lt.90.) then 
                  goto 110
               else 
                  write (10,3002)
                  write (10,3004) mn,ib,rsum,iaddr,tnew
                  call adios(2, 0, 0)
               end if
            end if
  199    continue
  200 continue
c
c     write out theta vs r (cone angle vs random no.)
c
      do 400 mn = 1,nummat
         do 399 ib = 1,nbands
            r = 0.
            write (10,2000) mn,ib,embar(mn,ib)
            if (iprnt(4).ne.0) then
               write (10,2001)
            end if
            if (ietp(mn,ib).eq.2) then
               if (iprnt(4).ne.0) then 
                  write (10,2002)
               end if 
            else if (ietp(mn,ib).eq.1) then
                if (iprnt(4).ne.0) then 
                   write (10,2003)
                end if 
            else if (noep(mn,ib).eq.1) then
               if (iprnt(4).ne.0) then 
                  write (10,2004)
               end if
            else
c
c              calculate dth
c
               dth(100,mn,ib) = 0.
               do 398 k = 0,99
                  dth(k,mn,ib) = thetar(k+1,mn,ib) - thetar(k,mn,ib)
c
c                 write theta (cone angle) in degrees.
c
                  if (iprnt(4).ne.0) then
                     thdeg = thetar(k,mn,ib)*rtod
                     dthdeg = dth(k,mn,ib)*rtod
                     write (10,2005) k,r,thdeg,dthdeg
                     r = r + 0.01
                  end if
  398          continue
c
c              print last values
c
               if (iprnt(4).ne.0) then
                  thdeg = thetar(100,mn,ib)*rtod
                  dthdeg = dth(100,mn,ib)*rtod
                  write (10,2005) 100,1.0,thdeg,dthdeg
               end if
            end if             
  399    continue
  400 continue
c
      return
c
 1000 format (1x,'in cumdis')
c
 2000 format (/
     $ / 7x,'t h e t a    v s.   r ( t h e t a ) '/
     $ / 2x,'mat. no.',i5,7x,'band no.',i5,7x,'embar ',f9.6/)
 2001 format (/
     $ / 7x,'point no.',4x,'r(theta)',3x,'theta(deg)',5x,'delta'//)
 2002 format (/7x, 'emission type = 2 (function emittance)' /
     $        /7x,  'no r(theta) array calculated')
 2003 format (/7x, 'emission type = 1 (beam emittance)' /
     $        /7x,  'no r(theta) array calculated')
 2004 format (/7x, 'material has 0 emittance (no photons emitted)' /
     $        /7x,  'no r(theta) array calculated') 
 2005 format (6x,i5,'.',7x,f7.4,2(4x,f10.6))
c
 3001 format (10x,'warning from cumdis - emissivity < 0.'/
     $ 2x,'material #, band, eold, enew,  theta ='/
     $ 2(2x,i5),3(2x,f10.6)/
     $ 2x,'see manual on the definition of material properties'/)
 3002 format (//7x,'error termination - from cumdis - ')
 3003 format (2x,'too large a value for delt input,reduce it'/
     $ / 2x,'mat. no.',i5,'   band no.',i5/
     $ / 2x,'ebar,tnew,told,dsum=',4(e12.5,2x))
 3004 format (10x,'integration of eps(theta) not consistent'/
     $ / 2x,'material,band,rsum,iaddr,tnew'/
     $ / 2x,2i5,e14.7,i5,e14.7)
c
      end
c
c***********************************************************************
c
      subroutine curveset
c
c***********************************************************************
c     subroutine to calculate needed curve quantities       
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      parameter (small = 1.d-7)
c
      write ( 6,1000) 
c
      istop = 0
c
c     Add properties and check for materials with 0 emittance at all points
c     If this is the case, noep remains set to 1.
c
      do 500 mn = 1,nummat
         do 450 ib = 1,nbands
            noep(mn,ib) = 1
c
c     note alpha must NEVER have other curve values added to it, it
c     is used by cumdis later on
c
            do 400 i = 0,90
      alpha(i,mn,ib) = 1. - rhod(i,mn,ib) - rhos(i,mn,ib) - 
     $   rhoss(i,mn,ib) -  taud(i,mn,ib) - taus(i,mn,ib) - 
     $   tauss(i,mn,ib)
c
c     after this, no need for tauss, since it is last of cumlative sum
c     it is always 1
c     no need for dtauss either
c
               if (alpha(i,mn,ib).lt.-small) then
                  write (6, 3001) mn, ib, alpha(i,mn,ib), i
                  write (10, 3001) mn, ib, alpha(i,mn,ib), i 
                  istop = 1
               else if (alpha(i,mn,ib).lt.0.) then
                  alpha(i,mn,ib) = 0.
               end if

               if (alpha(i,mn,ib).gt.small) then
                  noep(mn,ib) = 0
               end if
 
               rhod(i,mn,ib) = rhod(i,mn,ib) + alpha(i,mn,ib)
               rhos(i,mn,ib) = rhos(i,mn,ib) + rhod(i,mn,ib)
               rhoss(i,mn,ib) = rhoss(i,mn,ib) + rhos(i,mn,ib) 
               taud(i,mn,ib) = taud(i,mn,ib) + rhoss(i,mn,ib)
               taus(i,mn,ib) = taus(i,mn,ib) + taud(i,mn,ib)
  400       continue

            if (noep(mn,ib).eq.1) then
               if ((ietp(mn,ib).eq.1) .or. (ietp(mn,ib).eq.2)) then
                  write(6, 3002) mn,ib
                  write(10,3002) mn,ib
                  noep(mn,ib) = 0
               else
                  write(6, 3003) mn,ib
                  write(10,3003) mn,ib
               end if
            end if
  450    continue
  500 continue
c
c     obtain delta's
c
      do 555 mn = 1,nummat
         do 554 ib = 1,nbands
            do 552 i = 0,89
               dalpha(i,mn,ib) = alpha(i+1,mn,ib) - alpha(i,mn,ib)
               drhod(i,mn,ib) = rhod(i+1,mn,ib) - rhod(i,mn,ib)
               drhos(i,mn,ib) = rhos(i+1,mn,ib) - rhos(i,mn,ib)
               drhoss(i,mn,ib) = rhoss(i+1,mn,ib) - rhoss(i,mn,ib)
               dtaud(i,mn,ib) = taud(i+1,mn,ib) - taud(i,mn,ib)
               dtaus(i,mn,ib) = taus(i+1,mn,ib) - taus(i,mn,ib)
               dthprss(i,mn,ib) = thprss(i+1,mn,ib) - thprss(i,mn,ib)
               dthptss(i,mn,ib) = thptss(i+1,mn,ib) - thptss(i,mn,ib)
  552       continue
c
            dalpha(90,mn,ib) = 0.
            drhod(90,mn,ib) = 0.
            drhos(90,mn,ib) = 0.
            drhoss(90,mn,ib) = 0.
            dtaud(90,mn,ib) = 0.
            dtaus(90,mn,ib) = 0.
            dthprss(90,mn,ib) = 0.
            dthptss(90,mn,ib) = 0.
  554    continue
  555 continue
c
c     write out generated properties from 0 to 90 degrees.
c
      if (iprnt(4).ne.0) then
         call header
         write (10,2001)
         do 900 mn = 1,nummat
c
c     put divider between materials when listing curves
c
            call header
c
            if (imform.eq.1) then 
               write (10,2002)  mn, matname(1,mn,1)
            end if 
c
            do 800 ib = 1,nbands
               write (10,2003) mn,ib
c
               write (10,2004) 
               write (10,2005) mn,ib
               theta = 0.0
               do 610 l = 0,90
                  write (10,2006) l,theta,alpha(l,mn,ib),dalpha(l,mn,ib)
                  theta = theta + 1.
 610           continue
c
               if (imform.eq.0) then
                  write (10,2007) matname(4,mn,ib)
               else
                  write (10,2008) 
               end if
               write (10,2005) mn,ib
               theta = 0.0
               do 620 l = 0,90
                  write (10,2006) l,theta,rhod(l,mn,ib),drhod(l,mn,ib)
                  theta = theta + 1.
 620           continue
c
               if (imform.eq.0) then 
                  write (10,2009) matname(3,mn,ib)
               else 
                  write (10,2010)
               end if 
               write (10,2005) mn,ib
               theta = 0.0
               do 630 l = 0,90
                  write (10,2006) l,theta,rhos(l,mn,ib),drhos(l,mn,ib)
                  theta = theta + 1.
 630           continue
c
               if (imform.eq.1) then
                  write (10,2011) 
                  write (10,2005) mn,ib
                  theta = 0.0
                  do 640 l = 0,90
                  write (10,2006) l,theta,rhoss(l,mn,ib),drhoss(l,mn,ib)
                     theta = theta + 1.
 640              continue
               end if
c
               if (imform.eq.0) then
                  write (10,2012) matname(2,mn,ib)
               else 
                  write (10,2013)
               end if
               write (10,2005) mn,ib               
               theta = 0.0
               do 650 l = 0,90
                  write (10,2006) l,theta,taud(l,mn,ib),dtaud(l,mn,ib)
                  theta = theta + 1.
 650           continue
c
               if (imform.eq.0) then
                  write (10,2014) matname(1,mn,ib), mn, ib
               else
                  write (10,2015)
                  write (10,2005) mn,ib
                  theta = 0.0
                  do 660 l = 0,90
                  write (10,2006) l,theta,taus(l,mn,ib),dtaus(l,mn,ib)
                     theta = theta + 1.
 660              continue
               end if
c
               if (imform.eq.1) then
                  write (10,2016) mn, ib 
c
                  write (10,2017) 
                  write (10,2005) mn,ib
                  theta = 0.0
                  do 680 l = 0,90
                     write (10,2006) l,theta,thprss(l,mn,ib)*rtod,
     $                  dthprss(l,mn,ib)*rtod
                     theta = theta + 1.
 680              continue
c
                  write (10,2018)
                  write (10,2005) mn,ib
                  theta = 0.0
                  do 690 l = 0,90
                     write (10,2006) l,theta,thptss(l,mn,ib)*rtod,
     $                  dthptss(l,mn,ib)*rtod
                     theta = theta + 1.
 690              continue
               end if 
 800        continue
 900     continue
      end if
c
c     if error, stop
c
      if (istop.eq.1) then 
         call adios(2,0,0)
      end if
c
      return
c
 1000 format (1x,'in curveset')
c
 2001 format (///7x,
     $ 'p i e c e w i s e   l i n e a r   c u r v e   d a t a'/
     $ 8x,'generated curve vs.cone angle (theta)'/)
 2002 format (//8x,'material no. - ',i5, 5x, 'name - ', a20/)
 2003 format (//8x,'material no. - ',i5,5x,'band no. - ',i5/)
 2004 format (
     $ / 5x,'emittance/absorptance curve follows')
 2005 format (
     $   5x,'material no. - ',i5,5x,'band no. - ',i5, 
     $ / 5x,'point no.',4x,'theta (deg)',11x,'value',11x,'delta'/)
 2006 format (8x,i5,'.',6x,f10.7, 2(6x, f10.7))
 2007 format (
     $ / 5x,'diffuse reflectance curve follows, name = ', a16)
 2008 format (
     $ / 5x,'diffuse reflectance curve follows')
 2009 format (
     $ / 5x,'specular reflectance curve follows, name = ', a16)
 2010 format (
     $ / 5x,'specular reflectance curve follows')
 2011 format (
     $ / 5x,'semi-specular reflectance curve follows')
 2012 format (
     $ / 5x,'diffuse transmittance curve follows, name = ', a16)
 2013 format (
     $ / 5x,'diffuse transmittance curve follows')
 2014 format (
     $ / 5x,'specular transmittance curve, name = ', a16
     $ / 5x,' = 1 for all angles (cumlative sum of all properties)'
     $ / 5x, 'material no. - ',i5,5x,'band no. - ',i5)
 2015 format (
     $ / 5x,'specular transmittance curve follows')
 2016 format (
     $ / 5x,'semi-specular transmittance curve = 1 for all angles'
     $ / 5x,'(cumlative sum of all properties)'
     $ / 5x, 'material no. - ',i5,5x,'band no. - ',i5)
 2017 format (
     $ / 5x,'semi-specular reflectance outgoing angle curve follows')
 2018 format (
     $ / 5x,'semi-specular transmittance outgoing angle curve follows')
c
 3001 format ( 
     $ / 10x, '--- ERROR --- from curveset'
     $ / 12x, 'material number - ',i5, ' for band number -', i5, 
     $ / 12x, 'has negative emittance - ', e12.5, ' at ', i5, ' degrees'
     $ / 12x, 'emittance should always be greater than or equal to 0'
     $ / 15x, '------ STOPPING ------'/) 
 3002 format ( 
     $ / 5x, '--- warning --- '
     $ / 7x, 'material number - ',i5, ' for band number -', i5, 
     $ / 7x, ' has 0 emittance for all points',
     $ // 7x, 'Since ietp does NOT equal 0 (standard emission),' 
     $ / 7x, 'it WILL emit photons'/)  
 3003 format ( 
     $ / 5x, '--- warning --- '
     $ / 7x, 'material number - ',i5, ' for band number -', i5, 
     $ / 7x, ' has 0 emittance for all points',
     $ // 7x, 'Since ietp does equal 0 (standard emission),' 
     $ / 7x, 'it will NOT emit photons'/)    
c
      end
c
c***********************************************************************
c
      subroutine matinnew 
c
c***********************************************************************
c     subroutine to input material data for new material model 
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      parameter (small = 1.d-7)
c
      dimension curvtmp(0:90)           
c
      write (6,1000)
      call header
      write (10,2000)
c
      istop = 0
c
c  **** read material properties and write constant curves(inside readmat) ****
c
      do 200 mn = 1,nummat
c
c     read the material number and name
c
         read (1,1001) n, matname(1,mn,1)
         if (n.ne.mn) then
            write (6,3001) n, mn
            write (10,3001) n, mn
            call adios (2,0,0)
         end if
c
         write (10, 2001) mn
c
c    define material name for all curves and bands
c
         do 110 ib = 1, nbands
            do 105 i = 1,4
               matname(i,mn,ib) = matname(1,mn,1)
 105        continue
 110     continue       
c
         ib = 1
         call readmatnew(mn,ib,ibtmp, istop)
c
         if (ibtmp.eq.0) then
c
c     ibtmp = 0, properties the same for all bands
c
            do 150 ib = 2,nbands
               ietp(mn,ib) = ietp(mn,1)
               ebx(mn,ib) = ebx(mn,1)
               eby(mn,ib) = eby(mn,1)
               ebz(mn,ib) = ebz(mn,1)
               rfactrd(mn,ib) = rfactrd(mn,1)
               rfactrss(mn,ib) = rfactrss(mn,1)
               rfacttd(mn,ib) = rfacttd(mn,1)
               rfacttss(mn,ib) = rfacttss(mn,1)
c
               nctrack(icrd,mn,ib) = nctrack(icrd,mn,1)
               if (nctrack(icrd,mn,1).eq.0) then
                  do 121 j = 0,90
                     rhod(j,mn,ib) = rhod(1,mn,1)
 121              continue
               end if
c
               nctrack(icrs,mn,ib) = nctrack(icrs,mn,1)
               if (nctrack(icrs,mn,1).eq.0) then
                  do 122 j = 0,90
                     rhos(j,mn,ib) = rhos(1,mn,1)
 122              continue
               end if
c
               nctrack(icrss,mn,ib) = nctrack(icrss,mn,1)
               if (nctrack(icrss,mn,1).eq.0) then
                  do 123 j = 0,90
                     rhoss(j,mn,ib) = rhoss(1,mn,1)
 123              continue
               end if
c
               nctrack(ictd,mn,ib) = nctrack(ictd,mn,1)
               if (nctrack(ictd,mn,1).eq.0) then
                  do 124 j = 0,90
                     taud(j,mn,ib) = taud(1,mn,1)
 124              continue
               end if
c
               nctrack(icts,mn,ib) = nctrack(icts,mn,1)
               if (nctrack(icts,mn,1).eq.0) then
                  do 125 j = 0,90
                     taus(j,mn,ib) = taus(1,mn,1)
 125              continue
               end if
c
               nctrack(ictss,mn,ib) = nctrack(ictss,mn,1)
               if (nctrack(ictss,mn,1).eq.0) then
                  do 126 j = 0,90
                     tauss(j,mn,ib) = tauss(1,mn,1)
 126              continue
               end if
c
c    note that a constant offset angle curve does not lead to 
c    a constant thp array.  Currently the only constant 
c    offset angle curve allowed is 0.
c
               nctrack(icdtr,mn,ib) = nctrack(icdtr,mn,1)
               if (nctrack(icdtr,mn,1).eq.0) then
                  do 127 j = 0,90
                     thprss(j,mn,ib) = thprss(j,mn,1)
 127              continue
               end if
c
               nctrack(icdtt,mn,ib) = nctrack(icdtt,mn,1)
               if (nctrack(icdtt,mn,1).eq.0) then
                  do 128 j = 0,90
                     thptss(j,mn,ib) = thptss(j,mn,1)
 128              continue
               end if
 150        continue
         else
            do 170 ib = 2,nbands
               call readmatnew(mn,ib,ibtmp, istop)
 170        continue
         end if
 200  continue
c
c     check that beam emission surfaces are emitting in the proper direction
c
      do 300 l = 1, nsptr
         mnl = matnum(l)
         do 250 ib = 1,nbands
            if (ietp(mnl,ib).eq.1) then 
               dotpt = ebx(mnl,ib)*caz(l) + eby(mnl,ib)*cbz(l) + 
     $                 ebz(mnl,ib)*cgz(l)
c
               if (dotpt.lt.small) then 
               write (6,3002) l, matnum(l), ib,caz(l), cbz(l), cgz(l), 
     $               ebx(mnl,ib), eby(mnl,ib), ebz(mnl,ib), dotpt
               write (10,3002) l, matnum(l), ib, caz(l), cbz(l), cgz(l), 
     $               ebx(mnl,ib), eby(mnl,ib), ebz(mnl,ib), dotpt
                  istop = 1
               end if
            end if
 250     continue
 300  continue         
c
      if (istop.eq.1) then
         write (6, 3003)
         write (10, 3003)
         call adios(2,0,0)
      end if
c
c **** read material property curves ****
c
      if (nmacv.gt.0) then
         write (6,2101)
         call header
         write (10, 2100)
c
         do 600 nc = 1,nmacv
            call readhdrnew(1,nc,np)
            call readcrv(1,np,curvtmp,istop)
c
c        loop over materials, bands, and curve types and write the curve 
c        where it is needed
c
            do 500 mn = 1,nummat
               do 400 ib = 1,nbands
                  if (nctrack(icrd,mn,ib).eq.nc) then
                     do 310 j = 0,90
                        rhod(j,mn,ib) = curvtmp(j)
 310                 continue
                  end if
c
                  if (nctrack(icrs,mn,ib).eq.nc) then
                     do 320 j = 0,90
                        rhos(j,mn,ib) = curvtmp(j)
 320                 continue
                  end if
c
                  if (nctrack(icrss,mn,ib).eq.nc) then
                     do 330 j = 0,90
                        rhoss(j,mn,ib) = curvtmp(j)
 330                 continue
                  end if
c
                  if (nctrack(ictd,mn,ib).eq.nc) then
                     do 340 j = 0,90
                        taud(j,mn,ib) = curvtmp(j)
 340                 continue
                  end if
c
                  if (nctrack(icts,mn,ib).eq.nc) then
                     do 350 j = 0,90
                        taus(j,mn,ib) = curvtmp(j)
 350                 continue
                  end if
c
                  if (nctrack(ictss,mn,ib).eq.nc) then
                     do 360 j = 0,90
                        tauss(j,mn,ib) = curvtmp(j)
 360                 continue
                  end if 
 400           continue
 500        continue
 600     continue
      end if
c     
c **** read del theta curves ****
c
      if (ndtcv.gt.0) then
         write (6,2201)
         call header
         write (10,2200)
c
         do 900 nc = 1,ndtcv
            call readhdrnew(2,nc,np)
            call readcrv(2,np,curvtmp,istop)
c
c        loop over materials, bands, and curve types and write the curve 
c        where it is needed
c
            do 850 mn = 1,nummat
               do 800 ib = 1,nbands
                  if (nctrack(icdtr,mn,ib).eq.nc) then
                     do 710 j = 0,90
                        thprss(j,mn,ib) = curvtmp(j)
 710                 continue
                  end if
c
                  if (nctrack(icdtt,mn,ib).eq.nc) then
                     do 720 j = 0,90
                        thptss(j,mn,ib) = curvtmp(j)
 720                 continue
                  end if 
 800           continue
 850        continue
 900     continue
      end if
c
      if (istop.eq.1) then 
         write (6, 3003)
         write (10, 3003)
         call adios(2,0,0)
      end if  
c
      return
c
 1000 format (1x,'in matinnew')
 1001 format(i5,a20)
c
 2000 format (/////8x,
     $ 'NEW material model   Emission types (ietp) are:'
     $ /10x,'type     emission '
     $ /10x,'  2  -   function '
     $ /10x,'  1  -       beam '
     $ /10x,'  0  - eps(theta) '
     $ / 8x, 'constant curves have values greater than or equal to 0 '
     $ / 8x, 'negative curve values give index of curve to be used' //)
 2001 format (// 8x, 'material properties for material ', i5, ':')
c
 2100 format (//8x,
     $ 'm a t e r i a l   p r o p e r t y   c u r v e s'//)
 2101 format(3x, 'reading material property curves')
 2200 format (//8x,
     $ 'o f f s e t    a n g l e    c u r v e s'//)
 2201 format(3x, 'reading offset angle curves')
c
 3001 format (/2x, '- - -  error termination from matinnew  - - -'
     $ / 5x, 'material number mismatch',
     $ / 5x, 'material number read in = ',i5
     $ / 5x, 'material number should  = ',i5)
 3002 format (/2x, '- - -  error termination from matinnew  - - -'
     $ / 5x, 'improper beam emission for element ', i5,
     $ / 5x, 'material number =', i5, ' band number =', i5,     
     $ / 5x, 'surface normal for the element = ' ,3(e12.5, 3x)
     $ / 5x, 'beam emission direction  = ', 3(e12.5, 3x)
     $ / 5x, 'their dot product  = ', e12.5
     $ / 5x, 'the dot product should be positive')
 3003 format (/2x,'- - -  error(s) from matinnew  - - -'
     $ / 5x,'STOPPING')
c
      end
c
c***********************************************************************
c
      subroutine matinold 
c
c***********************************************************************
c     subroutine to input material data for the old material model 
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'           
c
      character*12 title(4)
      dimension jindex(4), mtype(isrf,ibnd)
      dimension curvtmp(0:90) 
c            
      data title 
     $  /'Tau Specular','Tau Diffuse ','Rho Specular','Rho Diffuse '/
c
c     this is equivilent to the old matin subroutine
c
      write ( 6,1000)
      call header
      write (10,2000)
c
c     zero error flag
c
      istop = 0
c
c     loop over all materials and bands
c
      do 200 mn = 1,nummat
         do 100 ib = 1,nbands
c
c           Read in the information
c
            read (1,1001) mtype(mn,ib),costbeam(mn,ib),phiset(mn,ib),
     $                    rfactrd(mn,ib), rfacttd(mn,ib), mntmp, ibtmp 
c
c           Check valid mtype
c   
            if (mtype(mn, ib).gt.2.or.mtype(mn, ib).lt.-4) then
               write (6,3000)
               write (6,3001) mn,ib, mtype(mn, ib)
               write (10,3000)
               write (10,3001) mn,ib, mtype(mn, ib)
               call adios (2, 0, 0)
            end if
c
c           check values of mn and ib
c
            if (ibtmp.eq.0.and.ib.eq.1) then
c
c              In a pre-2.3 input file, the rfacts, mntmp and ibtmp
c              are undefined (0). In this case all rfacts should be
c              1.0 and all the  parameters read in above should be the
c              same for all bands of a material   
c
               if (mntmp.eq.0) then
                  rfactrd(mn,1) = 1.0
                  rfacttd(mn,1) = 1.0
c
c                 If ibtmp is equal to 0 for the first band then the
c                 properties for this material are constant across the
c                 bands       
c
               else if (mn.eq.mntmp) then
                  if (rfactrd(mn,ib).eq.0.) then
                     rfactrd(mn,ib) = 1.
                  else if (rfactrd(mn,ib).lt.0.) then
                     rfactrd(mn,ib) = 0.0
                  end if
                  if (rfacttd(mn,ib).eq.0.) then
                     rfacttd(mn,ib) = 1.
                  else if(rfacttd(mn,ib).lt.0.) then
                     rfacttd(mn,ib) = 0.
                  end if
c
c              if ibtmp eq 0 and mntmp ne 0 or mn there is an error
c
               else
                  line = (mn - 1)*nbands + ib
                  write (6,3000)
                  write (6,3002) line,mtype(mn,ib),mntmp,ibtmp,mn,ib
                  write (10,3000)
                  write (10,3002) line,mtype(mn,ib),mntmp,ibtmp,mn,ib
                  call adios(2, 0, 0)
               end if
c
               do 50 ib2 = 2, nbands
                  mtype(mn,ib2) = mtype(mn,1)
                  costbeam(mn,ib2) = costbeam(mn,1)
                  phiset(mn,ib2) = phiset(mn,1)
                  rfactrd(mn,ib2) = rfactrd(mn,1)
                  rfacttd(mn,ib2) = rfacttd(mn,1)
   50          continue
c
c     properties defined for each band, goto next material
c
               goto 200                   
c
c    otherwise make sure that the material and band numbers match
c
            else if (mntmp.ne.mn) then
               line = (mn - 1)*nbands + ib
               write (6,3000)
               write (6,3002) line, mtype(mn, ib), mntmp, ibtmp, mn, ib
               write (10,3000)
               write (10,3002) line, mtype(mn, ib), mntmp, ibtmp, mn, ib
               call adios(2, 0, 0)
            else if (ibtmp.ne.ib) then
               line = (mn - 1)*nbands + ib
               write (6,3000)
               write (6,3003) line, mtype(mn, ib), mntmp, ibtmp, mn, ib
               write (10,3000)
               write (10,3003) line, mtype(mn, ib), mntmp, ibtmp, mn, ib
               call adios(2, 0, 0)
            else
c
c           set rfacts to default values for 0 and negative numbers
c
               if (rfactrd(mn,ib).eq.0.) then
                  rfactrd(mn,ib) = 1.
               else if (rfactrd(mn,ib).lt.0.) then
                  rfactrd(mn,ib) = 0.0
               end if
               if (rfacttd(mn,ib).eq.0.) then
                  rfacttd(mn,ib) = 1.
               else if (rfacttd(mn,ib).lt.0.) then
                  rfacttd(mn,ib) = 0.
               end if
            end if
  100    continue
  200 continue
c
c     write out values to the output file and convert 
c     phiset to radians
c     costbeam to cos(costbeam*dtor)
c     the rdiffs to 1/(1 + rdiff)
c
      write (10,2001)
      do 400 mn = 1,nummat
         do 300 ib = 1,nbands
            write (10,2002) mn,ib,mtype(mn,ib),costbeam(mn,ib),
     $                  phiset(mn,ib), rfactrd(mn,ib), rfacttd(mn,ib)
c
            costbeam(mn,ib) = cos(costbeam(mn,ib)*dtor)
            phiset(mn,ib) = phiset(mn,ib)*dtor
            rfactrd(mn,ib) = 1./(1. + rfactrd(mn,ib))
            rfacttd(mn,ib) = 1./(1. + rfacttd(mn,ib))
  300    continue
  400 continue
c
c     now start reading the material property curves
c     this section is equivilent to the first part of curvin in the old code
c
      write (6, 1100)
      call header 
      write (10,2100)
c
      do 700 mn = 1,nummat
         do 600 ib = 1,nbands
c
c           mirror cases
c
            if (mtype(mn,ib).le.-3) then
               write(10,2101) mtype (mn,ib)
c
               matname(1,mn,ib) = 'ZERO TAU SPEC'
               matname(2,mn,ib) = 'ZERO TAU DIFF'
               if (mtype(mn,ib).eq.-3) then 
                  matname(3,mn,ib) = 'SPEC REFLECTOR'
                  matname(4,mn,ib) = 'ZERO RHO DIFF'
               else if (mtype(mn,ib).eq.-4) then
                  matname(3,mn,ib) = 'ZERO RHO DIFF'
                  matname(4,mn,ib) = 'DIFF REFLECTOR'
               end if
c
c     goto next band
c
               goto 600
c
c           case of four input curves ep(theta)
c
            else if (mtype(mn,ib).eq.-2) then
               jindex(1) = 1
               jindex(2) = 2
               jindex(3) = 3
               jindex(4) = 4
c
c           three input curve cases
c
            else if (mtype(mn,ib).eq.-1) then
               jindex(1) = 0
               matname(1,mn,ib) = 'UNREAD TAU SPEC'
               jindex(2) = 1
               jindex(3) = 2
               jindex(4) = 3
            else
               jindex(1) = 1
               jindex(2) = 0
               matname(2,mn,ib) = 'UNREAD TAU DIFF'
               jindex(3) = 2
               jindex(4) = 3
            end if
c
c           Read in the curves for the specified band material
c
            do 500 j = 1,4
               write(10,2102) title(j) 
c
               if (jindex(j).eq.0) then
                  write(10,2103)
                  if (j.eq.1) then
                     do 450 k = 0,90
                        taus(k,mn,ib) = 0.
 450                 continue
                  else if (j.eq.2) then
                     do 460 k = 0,90
                        taud(k,mn,ib) = 0.
 460                 continue
                  end if
               else
                  call readhdrold (mn,jindex(j),j,ib,np)
                  call readcrv (1,np,curvtmp,istop)
                  do 480 i = 0,90
                     if (j.eq.1) then
                        taus(i,mn,ib) = curvtmp(i)
                     else if (j.eq.2) then
                        taud(i,mn,ib) = curvtmp(i)
                     else if (j.eq.3) then
                        rhos(i,mn,ib) = curvtmp(i)
                     else if (j.eq.4) then
                        rhod(i,mn,ib) = curvtmp(i)
                     end if
 480              continue      
               end if
  500       continue
  600    continue
  700 continue 
c
      if (istop.eq.1) then
         call adios(2,0,0)
      end if      
c
c     generate values of ietp and curves needed for the new material model
c
      do 900 mn = 1, nummat
         do 800 ib = 1, nbands
            if (mtype(mn,ib).eq.2) then
               ietp(mn,ib) = 2
            else if (mtype(mn,ib).eq.1) then 
               ietp(mn,ib) = 1
            else 
               ietp(mn,ib) = 0
            end if
c
            do 750 i = 0, 90 
               rhoss(i,mn,ib) = 0.
               tauss(i,mn,ib) = 0.
               thprss(i,mn,ib) = 0.
               thptss(i,mn,ib) = 0.
c
               if (mtype(mn,ib).eq.-3) then
                  rhos(i,mn,ib) = 1.
                  rhod(i,mn,ib) = 0.
                  taus(i,mn,ib) = 0.
                  taud(i,mn,ib) = 0.
               else if (mtype(mn,ib).eq.-4) then
                  rhos(i,mn,ib) = 0.
                  rhod(i,mn,ib) = 1.
                  taus(i,mn,ib) = 0.
                  taud(i,mn,ib) = 0.
               end if     
 750        continue 
 800     continue
 900  continue
c
      return
c
 1000 format (1x,'in matinold')
 1001 format (i5,4e10.4, 2i5)
 1100 format (1x,'reading material property curves')
c
 2000 format (/////8x,
     $ 'OLD material model   material types are:'
     $ /10x,'type     emission   transmission            reflection'
     $ /10x,'  2  -   function       specular    specular & diffuse'
     $ /10x,'  1  -       beam       specular    specular & diffuse'
     $ /10x,'  0  - eps(theta)       specular    specular & diffuse'
     $ /10x,' -1  - eps(theta)        diffuse    specular & diffuse'
     $ /10x,' -2  - eps(theta) spec & diffuse    specular & diffuse'
     $ /10x,' -3  -       none           none      perfect specular'
     $ /10x,' -4  -       none           none      perfect diffuse'//)
 2001 format (/
     $ / 7x,'mat',2x,'band',2x,'type ',1x,'thset  ',3x,
     $ 'phiset ', 3x,'r(diff refl)', 3x,'r(diff trans)'/)
 2002 format (3x,i5,'.',2(3x,i3),2(3x,f6.3),4x,f6.3,9x,f6.3)
 2003 format (/11x,'this curve not read, set to zero')
c
 2100 format (//8x,
     $ 'm a t e r i a l   p r o p e r t y   c u r v e s'//)
 2101 format (/8x,'material type -',i5,
     $       /11x,'no curves read for this material type')
 2102 format (//8x,a12)
 2103 format (/11x,'this curve not read, set to zero')
c
 3000 format (///7x,'- - -  error termination from matinold - - -'/
     $ / 5x,'bad data inputting material type data')
 3001 format (2x,'error in material type for material number - ',i5,
     $ 'for band number', i5
     $ / 5x,'material type read        = ',i5
     $ / 5x,'material type must be between 2 and -4, inclusive')
 3002 format (/7x,'material number does not agree'/
     $ / 5x, 'for the ', i5,'th line containing mtype = ', i5, 
     $ / 5x,'given material number - ',i5,5x,'band number - ',i5, 
     $ / 5x,'should be material number - ', i5,5x,'band number - ',i5)
 3003 format (/7x,'band numbers do not agree'/
     $ / 5x, 'for the ', i5,'th line containing mtype = ', i5, 
     $ / 5x,'given material number - ',i5,5x,'band number - ',i5, 
     $ / 5x,'should be material number - ', i5,5x,'band number - ',i5)
c
      end
c
c***********************************************************************
c
      subroutine readcrv(nctype, np, curvtmp, istop) 
c
c***********************************************************************
c     subroutine to read material property curves and deltheta curves       
c***********************************************************************
c     nctype  -  curve type (1 for mat'l prop. curve; 2 for del theta curve)
c     curvtmp -  tempoary array holding the curve
c     np      - the number of points to interpolate the curve from
c     istop is set to 1 if there is an error during the input process  
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'           
c
      parameter (small = 1.d-7)
c
      dimension th(3), val(3), curvtmp(0:90)
c
c     check for valid nctype (1 or 2) 
c     if 1, material (property curve) set min and max vals
c
      if (nctype.eq.1) then
         valmax = 1.0
         valmin = 0.0
      else if (nctype.eq.2) then 
         valmax = pi2
         valmin = 0.
      else 
         write (6,3000)
         write (6,3001) nctype
         write (10,3000)
         write (10,3001) nctype
         call adios (2,0,0)
      end if
c
c  check if the number of points are within the allowed limits
c
      if ((np.lt.3) .or. (np.gt.91)) then
        write (6,3000)
        write (6,3002) np
        write (10,3000)
        write (10,3002) np
        call adios (2, 0, 0)
      end if
c
c  ****** read in the curve ******
c
      j = 0
      theta = 0.
      lstart = 0
c
c     read and interpolate values
c
      do 100 k = 1, np 
         j = j + 1
         read (1,1001) th(j), val(j)
         write (10,2011) k, th(j), val(j)
c
c     check if theta is between 0 and 90
c
         if ((th(j).lt.0.) .or. (th(j).ge.90.001)) then
            write ( 6,3000)
            write ( 6,3011) k,th(j)
            write (10,3000)
            write (10,3011) k,th(j)
            call adios (2, 0, 0)
         end if
c
c     check that first point entered is at 0 degrees 
c     and last point entered is at 90 degrees
c
         if (((k.eq.1).and.(abs(th(j)).gt.small)) .or.
     $      ((k.eq.np).and.(abs(th(j)-90.).gt.small))) then 
            write (6,3000) 
            write (6,3012) k, th(j)
            write (10,3000) 
            write (10,3012) k, th(j)
            call adios(2, 0, 0)
         end if    
c
c     define value for del theta curve
c
         if (nctype.eq.2) then
            val(j) = (val(j) + th(j))*dtor
         end if
c
c     check if the read value is within the allowed range
c
         if ((val(j).lt.(valmin-small)) .or. 
     $       (val(j).gt.(valmax+small))) then
            write (10,3000)
c
            if (nctype.eq.1) then
               write (10,3013) k, th(j), val(j)
            else if (nctype.eq.2) then
               write (10,3014) k, th(j), val(j)
            end if
c
            istop = 1
         end if
c
c     Generate values based on input values curve fitted
c     for 1 degree (0.0174533 rad) increments.
c
         if (j.ne.3) then
            goto 100
         end if
c
         if (k .eq. np) then
            lend = 90
         else
            lend = th(j) + small
         end if
c  
c     call subroutine to calculate coefficients a1,b,c, to curve fit
c        three points to the parabola y=a1*x**2 + b*x + c
c
         call coeff2 (th(1),th(2),th(3),val(1),val(2),val(3),a1,b,c)
c
c     generating loop for values
c
         do 80 l = lstart, lend
c
c     parabolic equation calculation of values
c
            curv = a1*theta**2 + b*theta + c
c
            if (curv.le.valmin) then
               curv = valmin
            else if (curv.gt.valmax) then
               curv = valmax
            end if
c
            curvtmp(l) = curv
            theta = theta + 1.0
   80    continue
c
         lstart = lend + 1
c
         if (k.eq.(np - 1)) then
            th(1) = th(2)
            val(1) = val(2)
            th(2) = th(3)
            val(2) = val(3)
            j = 2
         else
            th(1) = th(3)
            val(1) = val(3)
            j = 1
         end if
  100 continue
c 
      return
c         
 1000 format (2i5)
 1001 format (2e10.0)
c
 2011 format (5x,i5,'.',8x,f11.7,7x,f11.7)
c
 3000 format (///7x,'- - -  error termination  - - -'/
     $ / 5x,'bad data inputting curves in readcrv')
 3001 format (7x,'invalid value of nctype - ', i5/
     $ / 5x, 'nctype must be equal to 1 or 2')
 3002 format (/7x,'no. of points (np) input should be .ge. 3 and',
     $ ' .le. 91'/
     $ / 5x,'np = ',i5)
c
 3011 format (
     $ / 7x, 'th(j) (cone angle) should be .ge. 0. and .le. 90.'
     $ / 5x,'point no.(k) - ',i5, ' th(j) = ',e12.4)
 3012 format (
     $ / 7x, 'first point entered should be at 0 degrees'
     $ / 7x, 'last point entered should be at 90 degrees'
     $ / 7x, 'you entered:'
     $ / 5x,'point no.(k) - ',i5, ' th(j) = ',e12.4)
 3013 format (
     $ / 7x,'materal property val(j) should be between 0. and 1.',
     $ / 5x,'point no.(k) - ',i5, ' th(j) = ',e12.4, ' val(j) = ',e12.4)
 3014 format (
     $ / 7x,'deltheta val(j) + theta(j) should be between 0 and 90'
     $ / 5x,'for point no. (k) - ', i5,
     $ / 5x,'th(j), val(j) + th(j) =', 2(e12.4, 3x))
c
      end   
c
c***********************************************************************
c
      subroutine readhdrnew (nctype,nc,np) 
c
c***********************************************************************
c     subroutine to read curve header for new material model            
c***********************************************************************
c     nctype -  curve type (1 for mat'l prop. curve; 2 for del theta curve)
c     nc     -  expected curve number
c     np     -  number of points in the curve 
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'           
c
c  ****** read in curve header ******
c
      read (1,1000) ncurvtmp,np
c
c  check if the expected curve number matches the read curve number
c
      if (nc.ne.ncurvtmp) then
        if (nctype.eq.1) then
           write (6,3001) nc,ncurvtmp
           write (10,3001) nc,ncurvtmp
        else 
           write (6,3002) nc,ncurvtmp
           write (10,3002) nc,ncurvtmp
        end if 
        call adios (2, 0, 0)
      end if
c
c  write curve number
c
      if (nctype.eq.1) then
         write (10,2001) nc
      else 
         write (10,2002) nc
      end if 
c
      return
c         
 1000 format (2i5)
c
 2001 format (//2x,'material curve number - ',i5)
 2002 format (//2x,'specular offset angle curve number - ',i5)
c
 3001 format (
     $ / 10x,'--- ERROR --- in matinnew-readhdrnew - - -'
     $ / 12x,'material curve numbers do not agree'
     $ / 12x,'value read in ', i5, ' value expected ', i5
     $ / 15x, '------ STOPPING ------'/)
 3002 format (
     $ / 10x,'--- ERROR --- in matinnew-readhdrnew - - -'
     $ / 12x,'semi-specular offset angle curve numbers do not agree'
     $ / 12x,'value read in ', i5, ' value expected ', i5
     $ / 15x, '------ STOPPING ------'/)
c
      end                          
c
c***********************************************************************
c
      subroutine readhdrold(n,jcrv,j,ib,np)
c
c***********************************************************************
c     subroutine to read the header of a material property curve
c***********************************************************************
c     important variables:
c        n      - material number
c        jcrv   - the curve number for this material curve j
c        j      - curve type
c        ib     - the band number
c        np     - the number of points to be read
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     read in information about the curve
c
      read (1,1001) matname(j,n,ib),nn,nb,nj,np
c
c     check if information read in matches passed information
c
      istop = 0
c
      if (nn.ne.n) then
        write (10,3000)
        write (10,3001) matname(j,n,ib),nn,nb,nj,n
        istop = 1
      end if
c
      if (nb.ne.ib) then
        write (10,3000)
        write (10,3002) matname(j,n,ib),n,nb,nj,ib
        istop = 1
      end if
c
      if (nj.ne.jcrv) then
        write (10,3000)
        write (10,3003) matname(j,n,ib),n,nb,nj,jcrv
        istop = 1
      end if
c
      if (istop.eq.1) then
         call adios(2,0,0)
      end if 
c
      write (10,2003) jcrv,matname(j,n,ib),nb,n 
c
      return
c
 1001 format (a16,8i5)
c
 2003 format (//7x,'curve number - ',i5,5x,'name - ',a16,5x,
     $ / 7x,'band number - ',i5,5x,'material number - ',i5//)
c
 3000 format (///7x,'- - -  error termination  - - -'/
     $ / 5x,'bad data inputting property curves in matinold-readhdr')
 3001 format (7x,'material number does not agree'
     $ / 2x,'for curve ',a16,'- material, band, specifier =',3(1x,i5)/
     $ / 2x,'mat. no. should be =',i5/2x,'error termination!')
 3002 format (7x,'band numbers do not agree'
     $ / 2x,'for curve ',a16,'- material, band, specifier =',3(1x,i5)/
     $ / 2x,'band number should be =',i5/2x,'error termination!')
 3003 format (7x,'property specifier does not agree'
     $ / 2x,'for curve ',a16,'material, band, specifier =',3(1x,i5)/
     $ / 2x,'prop. specifier should be =',i5/2x,'error termination!')
c
      end
c
c***********************************************************************
c
      subroutine readmatnew(mn,ib,ibtmp,istop) 
c
c***********************************************************************
c     subroutine to read material data and fill constant curves for the 
c     new material model
c     mn is the current material number being read
c     ib is the current band being read
c     ibtmp holds the band number read from input
c     istop is set to 1 if there is an error during the input process  
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'           
c
      parameter (small = 1.d-7)
c
c     read material information of the band
c
      read (1,1001) ibtmp,ietp(mn,ib),ebx(mn,ib),eby(mn,ib),
     $   ebz(mn,ib), rrhod, rrhoss, rtaud,rtauss
      read (1,1002) refdiff,refspec,refsemi,trandiff,transpec,
     $   transemi,delthref,delthtran
c
c     check validity of band number read in, ibtmp, 
c     it must match the current band number ib
c     only exception if properties constant across bands
c     ibtmp can be 0 if ib = 1 (first band read)
c
      if ((ibtmp.ne.ib) .and. ((ibtmp.ne.0) .or. (ib.ne.1))) then
         write (6,3001) mn, ibtmp, ib
         write (10,3001) mn, ibtmp, ib
         call adios (2,0,0)
      end if
c
      if ((ietp(mn,ib).eq.1) .or. (ietp(mn,ib).eq.2)) then
c
c     beam or function emission
c     check for valid emission vector (non-zero) if valid, normalize
c
         if ((abs(ebx(mn,ib)).lt.small) .and. (abs(eby(mn,ib)).lt.small)
     $      .and. (abs(ebz(mn,ib)).lt.small)) then
            write (6,3002) mn, ib
            write (10,3002) mn, ib
            istop = 1
         else
            vlen = sqrt(ebx(mn,ib)**2 + eby(mn,ib)**2 + ebz(mn,ib)**2)
            vleninv = 1./vlen
            ebx(mn,ib) = ebx(mn,ib)*vleninv
            eby(mn,ib) = eby(mn,ib)*vleninv
            ebz(mn,ib) = ebz(mn,ib)*vleninv
         end if
      else if (ietp(mn,ib).ne.0) then
c
c     invalid value of ietp
c
         write (6,3003) mn, ib, ietp(mn,ib)
         write (10,3003) mn, ib, ietp(mn,ib)
         istop = 1
      end if
c
c     change r values if needed
c     if r = 0, then default value r = 1 is used
c     else if r less than 0, r = 0 is used
c
      if (abs(rrhod).lt.small) then 
         rrhod = 1.
      else if (rrhod.lt.0) then
         rrhod = 0.
      end if
c
      if (abs(rrhoss).lt.small) then 
         rrhoss = 1.
      else if (rrhoss.lt.0) then
         rrhoss = 0.
      end if
c
      if (abs(rtaud).lt.small) then 
         rtaud = 1.
      else if (rtaud.lt.0) then
         rtaud = 0.
      end if
c
      if (abs(rtauss).lt.small) then 
         rtauss = 1.
      else if (rtauss.lt.0) then
         rtauss = 0.
      end if
c
c  **** material property curves:  ****
c  if given value ge small make sure in bounds (le 1) and fill curve with
c  constant value, else save curve index to use in nctrack array
c
      if (refdiff.ge.-small) then
         if (refdiff.gt.1.) then
            write (6, 3101) mn, ib, 'rhod',refdiff
            write (10, 3101) mn, ib, 'rhod', refdiff
            istop = 1
         else if (refdiff.lt.0) then
            refdiff = 0.
         end if
c
         nctrack(icrd,mn,ib) = 0
         do 110 i = 0,90
            rhod(i,mn,ib) = refdiff
 110     continue
      else
         irefd = -nint(refdiff)
         refdiff = -irefd
         nctrack(icrd,mn,ib) = irefd
c
         if ((irefd.lt.1) .or. (irefd.gt.nmacv)) then 
            write (6, 3102) mn, ib, 'rhod', irefd, nmacv
            write (10, 3102) mn, ib, 'rhod', irefd, nmacv
            istop = 1
         end if 
      end if
c
      if (refspec.ge.-small) then
         if (refspec.gt.1) then
            write (6, 3101) mn, ib, 'rhos',refspec
            write (10, 3101) mn, ib, 'rhos', refspec
            istop = 1
         else if (refspec.lt.0) then
            refspec = 0.
         end if
c
         nctrack(icrs,mn,ib) = 0
         do 120 i = 0,90
               rhos(i,mn,ib) = refspec
 120     continue
      else
         irefs = -nint(refspec)
         refspec = -irefs
         nctrack(icrs,mn,ib) = irefs
c
         if ((irefs.lt.1) .or. (irefs.gt.nmacv)) then 
            write (6, 3102) mn, ib, 'rhos', irefs, nmacv
            write (10, 3102) mn, ib, 'rhos', irefs, nmacv
            istop = 1
         end if 
      end if
c
      if (refsemi.ge.-small) then
         if (refsemi.gt.1) then
            write (6, 3101) mn, ib, 'rhoss',refspec
            write (10, 3101) mn, ib, 'rhoss', refspec
            istop = 1
         else if (refsemi.lt.0) then
            refsemi = 0.
         end if
c
         nctrack(icrss,mn,ib) = 0
         do 130 i = 0,90
            rhoss(i,mn,ib) = refsemi
 130     continue
      else
         irefss = -nint(refsemi)
         refsemi = -irefss
         nctrack(icrss,mn,ib) = irefss
c
         if ((irefss.lt.1) .or. (irefss.gt.nmacv)) then 
            write (6, 3102) mn, ib, 'rhoss', irefss, nmacv
            write (10, 3102) mn, ib, 'rhoss', irefss, nmacv
            istop = 1
         end if 
      end if
c
      if (trandiff.ge.-small) then
         if (trandiff.gt.1) then
            write (6, 3101) mn, ib, 'taud',trandiff
            write (10, 3101) mn, ib, 'taud', trandiff
            istop = 1
         else if (trandiff.lt.0) then
            trandiff = 0.
         end if
c
         nctrack(ictd,mn,ib) = 0
         do 140 i = 0,90
            taud(i,mn,ib) = trandiff
 140     continue
      else
         itrand = -nint(trandiff)
         trandiff = -itrand
         nctrack(ictd,mn,ib) = itrand
c
         if ((itrand.lt.1) .or. (itrand.gt.nmacv)) then 
            write (6, 3102) mn, ib, 'taud', itrand, nmacv
            write (10, 3102) mn, ib, 'taud', itrand, nmacv
            istop = 1
         end if 
      end if
c
      if (transpec.ge.-small) then
         if (transpec.gt.1) then
            write (6, 3101) mn, ib, 'taus',transpec
            write (10, 3101) mn, ib, 'taus', transpec
            istop = 1
         else if (transpec.lt.0) then
            transpec = 0.
         end if
c
         nctrack(icts,mn,ib) = 0
         do 150 i = 0,90
            taus(i,mn,ib) = transpec
 150     continue
      else
         itrans = -nint(transpec)
         transpec = -itrans
         nctrack(icts,mn,ib) = itrans
c
         if ((itrans.lt.1) .or. (itrans.gt.nmacv)) then 
            write (6, 3102) mn, ib, 'taus', itrans, nmacv
            write (10, 3102) mn, ib, 'taus', itrans, nmacv
            istop = 1
         end if 
      end if
c
      if (transemi.ge.-small) then
         if (transemi.gt.1) then
            write (6, 3101) mn, ib, 'tauss',transemi
            write (10, 3101) mn, ib, 'tauss', transemi
            istop = 1
         else if (transemi.lt.0) then
            transemi = 0.
         end if
c
         nctrack(ictss,mn,ib) = 0
         do 160 i = 0,90
            tauss(i,mn,ib) = transemi
 160     continue
      else
         itranss = -nint(transemi)
         transemi = -itranss
         nctrack(ictss,mn,ib) = itranss
c
         if ((itranss.lt.1) .or. (itranss.gt.nmacv)) then 
            write (6, 3102) mn, ib, 'tauss', itranss, nmacv
            write (10, 3102) mn, ib, 'tauss', itranss, nmacv
            istop = 1
         end if 
      end if
c
c  **** del theta curves: ****
c
      if (delthref.ge.-small) then
         if (delthref.gt.small) then
            write (6, 3103) mn, ib, 'dthrss',delthref
            write (10, 3103) mn, ib, 'dthrss', delthref
            istop = 1
         else
            delthref = 0.
            nctrack(icdtr,mn,ib) = 0
            do 210 i = 0,90
               thprss(i,mn,ib) = i*dtor
 210        continue
         end if 
      else
         idelthrss = -nint(delthref)
         delthref = -idelthrss
         nctrack(icdtr,mn,ib) = idelthrss
c
         if ((idelthrss.lt.1) .or. (idelthrss.gt.ndtcv)) then 
            write (6, 3104) mn, ib, 'dthrss', idelthrss, ndtcv
            write (10, 3104) mn, ib, 'dthrss', idelthrss, ndtcv
            istop = 1
         end if 
      end if
c
      if (delthtran.ge.-small) then
         if (delthtran.gt.small) then
            write (6, 3103) mn, ib, 'dthtss',delthtran
            write (10, 3103) mn, ib, 'dthtss', delthtran
            istop = 1
         else
            delthtran = 0.
            nctrack(icdtt,mn,ib) = 0
            do 220 i = 0,90
               thptss(i,mn,ib) = i*dtor
 220        continue
         end if 
      else
         idelthtss = -nint(delthtran)
         delthtran = -idelthtss
         nctrack(icdtt,mn,ib) = idelthtss
c
         if ((idelthtss.lt.1) .or. (idelthtss.gt.ndtcv)) then 
            write (6, 3104) mn, ib, 'dthtss', idelthtss, ndtcv
            write (10, 3104) mn, ib, 'dthtss', idelthtss, ndtcv
            istop = 1
         end if 
      end if
c
c     write material information to output file
c
      if (ibtmp.eq.0) then
         write (10, 2101)
      end if
      write (10,2102)
      write (10,2103) ibtmp,ietp(mn,ib),ebx(mn,ib),eby(mn,ib),
     $   ebz(mn,ib), rrhod, rrhoss, rtaud,rtauss
      write (10,2104)
      write (10,2105) refdiff,refspec,refsemi,trandiff,transpec,
     $   transemi,delthref,delthtran
c
c     define r factors
c
      rfactrd(mn,ib) = 1./(1. + rrhod)
      rfactrss(mn,ib) = 1./(1. + rrhoss)
      rfacttd(mn,ib) = 1./(1. + rtaud)
      rfacttss(mn,ib) = 1./(1. + rtauss)
c
      return
c
 1001 format (2i5,7e10.0)
 1002 format (8e10.0)
c
 2101 format (8x, 'material properties are the same for all bands')
 2102 format (
     $ // 1x,'band',1x, 'ietp',7x,'ebx',7x,'eby',7x, 'ebz', 5x, 
     $      'rrhod', 4x, 'rrhoss', 5x,'rtaud', 4x,'rtauss')
 2103 format (2(1x, i4), 3(2x,f8.5), 4(2x,g8.2)/)
 2104 format (6x, 'rhod', 6x, 'rhos', 5x, 'rhoss', 6x,
     $        'taud', 6x, 'taus', 5x, 'tauss', 4x,
     $        'dthrss', 4x, 'dthtss')
 2105 format (2x, 8(f8.5, 2x)/)
c
 3001 format (
     $ /2x,'- - -  error termination from matinnew (readmat)  - - -'
     $ / 5x,'band number mismatch for material', i5,
     $ / 5x,'band number read in = ',i5
     $ / 5x,'band number should  = ',i5)
 3002 format (
     $ /2x,'- - -  error termination from matinnew (readmat)  - - -'
     $ / 5x,'For material number ', i5, ' and band ', i5, 
     $ / 5x,'beam emission vector (ebx, eby, ebz) entered is 0'
     $ / 5x,'and ietp is 1 (beam emission) or 2 (function emission) '
     $ / 5x,'beam emission vector must be nonzero in these cases')
 3003 format (
     $ /2x,'- - -  error termination from matinnew (readmat)  - - -'
     $ / 5x,'For material number ', i5, ' and band ', i5,
     $ / 5x,'invalid value of ietp entered'
     $ / 5x,'ietp read in = ',i5
     $ / 5x,'ietp should be between 0 and 2, inclusive')
c
 3101 format (
     $ / 2x, '- - -  error termination from matinnew (readmat)  - - -'
     $ / 5x, 'For material number ', i5, ' and band ', i5,
     $ / 5x, 'constant ', a, ' curve = ', e12.5
     $ / 5x, 'which is greater than 1 ')
 3102 format (
     $ / 2x, '- - -  error termination from matinnew (readmat)  - - -'
     $ / 5x, 'For material number ', i5, ' and band ', i5,
     $ / 5x, a, ' curve index  = ', i5
     $ / 5x, 'curve index should be between 1 and nmacv (= ', i5,') ')
 3103 format (
     $ / 2x, '- - -  error termination from matinnew (readmat)  - - -'
     $ / 5x, 'For material number ', i5, ' and band ', i5,
     $ / 5x, 'constant ', a, ' curve = ', e12.5
     $ / 5x, 'constant offset angle curves must = 0 ')
 3104 format (
     $ / 2x, '- - -  error termination from matinnew (readmat)  - - -'
     $ / 5x, 'For material number ', i5, ' and band ', i5,
     $ / 5x, a, ' curve index  = ', i5
     $ / 5x,'curve index should be between 1 and ndtcv (= ', i5,') ')
c
      end
