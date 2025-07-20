c**********************************************************************     
c
c     m32s.f
c
c***********************************************************************
c     This file contains the subroutine solve3 which handles the 
c     solution phase.  It also contains the subroutines called by 
c     solve3 They are: 
c     absref, blockloop, blockset, eptinit, getang, getpntgrd, 
c     grdint, ranlf, and surfloop     
c***********************************************************************
c*                                                                     *
c*      *******    ******    *        *     *    ******     *****      *
c*      *         *      *   *        *     *    *         *     *     *
c*      *         *      *   *        *     *    *               *     *
c*      *******   *      *   *        *     *    ****         ***      *
c*            *   *      *   *         *   *     *               *     *
c*            *   *      *   *          * *      *         *     *     *
c*      *******    ******    *******     *       *******    *****      *
c*                                                                     *
c***********************************************************************
c
      subroutine solve3
c
c***********************************************************************
c* subroutine to solve for exchange factors via monte carlo            
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     open lost photon file
c 
      if ((iparflg.eq.0) .or. (mymid.ne.0)) then
         open (4,file=aname(4),status='unknown',iostat=iost( 4))
         call ferrorcheck(4, 0)
      end if 
c
c     open trace file, if required
c
      if (itraces .gt.0) then
         if ((iparflg.eq.0) .or. (mymid.ne.0)) then
            open(9,file=aname(9),status='unknown', iostat = iost(9))
            call ferrorcheck (9, 0)
         end if
      end if
c
c    initialization
c    in interc
c
      ihist = 0 
      iwarn = 0
      npntsm1 = ndivx*ndivy - 1
c
c     in evars
c
      fdx = real(ndivx)
      fdy = real(ndivy)
c
c     in soltim
c
      lost = 0
      rnump = 0.d0
c
      if (iparflg.eq.0) then
c
c     nonparallel case
c
         write (6,5000)
c
         do 200 nbk = 1, nblocks
            if (nbkfin(nbk).eq.1) then
c
c     block already done, go to the next one
c
               goto 200
            end if
c
c     obtain results for this block of surfaces
c
            call blockset (nbk)
            call blockloop (nbk)
c
c   update nbkfin and update the restart file 
c   in parallel, this is done by master only
c
            nbkfin(nbk) = 1
            call rstfile (ifwrt, nbk)
            write ( 6,5001) 
  200    continue
      else
         call parasolve
      end if   
c
c     determine time for solution phase
c         
      call timing(2)
c
c     finish up
c
c     clean up temporary files
c     14 = the .blk file 
c         
      open (14,file=aname(14), status='unknown', iostat = iost(14))
      call ferrorcheck (14, 0)
      close (14, status = 'delete')
      ifstat(14) = -1
c
c    combine the .bni files into a .nij file
c
      call nijfile (ifcom, 0)
c
      return
c
 5000 format 
     $ (18x,'band', 2x,'surf.', 2x, 'iter.', 7x,'npht.',8x, 'error',
     $  9x, 'tol.')
 5001 format (1x,'restart file written ')
c
      end 
c
c***********************************************************************
c
      subroutine absref (ib, iact)
c
c***********************************************************************
c     subroutine to determine if a photon is absorbed or reflected
c       or transmitted and how 
c     ib = band number for interaction                    
c     Returns:                                                         
c       iact - action indicator (what happens to the photon)    
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'        
c
c     reflection algorithm
c      1.  if rn .lt. alpha        - absorbed (iaab)
c      2.  else if rn .lt. rhod    - diffuse reflection (iard)
c      3.  else if rn .lt. rhos    - specular reflection (iars)
c      4.  else if rn .lt. rhoss   - semi-specular reflection (iarss)
c      5.  else if rn .lt. taud    - diffuse transmission (iatd)
c      6.  else if rn .lt. taus    - specular transmission (iats)
c      7.  else                    - semi-specular transmission (iatss)
c
c     calculate needed angle properties also used in getang
c
      if (ezlint.gt.-1.d0) then
         thetair = acos(-ezlint)
         thetaid = thetair*rtod
         ithid = thetaid
         fractid = thetaid - ithid
      else
         thetair = 0.
         ithid = 0
         fractid = 0.
      end if
c
c     select random no.
c
      rn = ranlf()
c
      mni = matnum(lint)
c
c     determine type of reflection
c     this system is more efficient than before because it checks for 
c     absorption first, followed by all types of reflection and all
c     types of transmittance which is similar to their odds
c
      alphai = alpha(ithid,mni,ib) + fractid*dalpha(ithid,mni,ib)
      if (rn.lt.alphai) then
         iact = iaab
      else
         rhodi = rhod(ithid,mni,ib) + fractid*drhod(ithid,mni,ib)
         if (rn.lt.rhodi) then
            iact = iard
         else   
            rhosi = rhos(ithid,mni,ib) + fractid*drhos(ithid,mni,ib)
            if (rn.lt.rhosi) then
               iact = iars
            else
            rhossi = rhoss(ithid,mni,ib) + fractid*drhoss(ithid,mni,ib)
               if (rn.lt.rhossi) then
                  iact = iarss
               else
               taudi = taud(ithid,mni,ib) + fractid*dtaud(ithid,mni,ib)
                  if (rn.lt.taudi) then
                  iact = iatd
                  else
               tausi = taus(ithid,mni,ib) + fractid*dtaus(ithid,mni,ib)
                     if (rn.lt.tausi) then
                        iact = iats
                     else
                        iact = iatss
                     end if
                  end if
               end if
            end if
         end if
      end if
c
      return
      end
c
c************************************************************************
c
      subroutine blockloop (nbk) 
c
c***********************************************************************
c     Subroutine to loop over all the surfaces in a block
c     nbk = the block number
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     fill npabs
c     
      if (initialflg.eq.1) then
c
c     initial run or crashed initial run
c
         do 100 ie = 1, nedo
            do 95 j = 1,nsptr
               npabs(j,ie) = 0
 95         continue
 100     continue 
      else
c
c     restart or crashed restart, read in photon counts and check them
c
         call nijfile(ifrdbk, nbk)
         do 490 ie = 1, nedo
            ne = nelist(ie)
            ib = (ne - 1)/nsurf + 1
            lunsplit = mod(ne - 1, nsurf) + 1
            call pcheck(lunsplit, ib, ie)
 490     continue
      end if          

      do 500 ie = 1, nedo
         ne = nelist(ie)
         ib = (ne - 1)/nsurf + 1
         lunsplit = mod(ne - 1, nsurf) + 1
         npemit = npwold(lunsplit,ib)
c
c     account for zero emissions
c
         if (isplit(lunsplit).eq.0) then
           nphot2 = 0
         else
           nphot2 = nphtn(isplit(lunsplit),ib)
         end if 
c
         if ((nphtn(lunsplit,ib).le.0) .and. (nphot2.le.0)) then
c
c     no photons emitted, restart loop for next surface
c      
            call errchk (lunsplit,ib,ie, npemit)
            write ( 6,5001) ib,lunsplit,0,npemit,error(lunsplit,ib),
     $                         errmax(lunsplit)
            goto 500
         else if ((nphtn(lunsplit,ib).le.0) .or. 
     $           ((nphot2.le.0) .and. isplit(lunsplit).ne.0)) then
              write (10,3001) lunsplit, ib
              write (6,3001) lunsplit, ib
              call adios(2, nbk, 0)
         end if
c
c        check if already converged
c
         if (npemit.gt.0) then 
            call errchk (lunsplit,ib,ie, npemit)
            if (error(lunsplit,ib).le.errmax(lunsplit)) then
c
c     already converged, restart loop for next surface
c      
               write ( 6,5001) ib,lunsplit,0,npemit,error(lunsplit,ib),
     $                         errmax(lunsplit)
               goto 500
            end if
         end if
c
c     iflags = 0 unsplit surface
c     iflags = 1 split surface
c
c     photon convergence loop
c
         do 400 nplp = 1,nploops
            lemit = lunsplit
            areaemit = area(lunsplit)
c
c     isplit(lunsplit) = 0 unsplit surface
c     isplit(lunsplit) ne 0 split surface, do first half
c
            if (isplit(lunsplit).ne.0) then
               areaemit = areaemit - area(isplit(lunsplit))
            end if 
c
c     loop over the surface or first half of surface if it has any photons
c
            call surfloop(ie, ib, nbk, nplp) 
c
c     emit from second half of split surface, if required
c
            if (isplit(lunsplit).ne.0) then
               lemit = isplit(lunsplit)
               areaemit = area(lemit)
               call surfloop(ie, ib, nbk, nplp)
            end if
c
c     combine split surfaces
c
            do 310 jj = 1,nsurf
               if (isplit(jj).ne.0) then
                  npabs(jj,ie) = npabs(jj,ie) + npabs(isplit(jj),ie)
                  npabs(isplit(jj),ie) = 0
               end if
  310       continue
c
c     check convergence
c
            call errchk (lunsplit,ib,ie, npemit)
c
c     if converged break out of photon convergence loop
c 
            if (error(lunsplit,ib).le.errmax(lunsplit)) then
               goto 450
            end if
  400    continue 
c
c     either converged or maximum loops have been done
c
  450    if (nplp.gt.nploops) then
            write ( 6,5003) ib,lunsplit,(nplp-1),npemit,
     $                      error(lunsplit,ib), errmax(lunsplit)
         else
            write ( 6,5002) ib,lunsplit,nplp,npemit,
     $                      error(lunsplit,ib), errmax(lunsplit)
         end if   
c
c     update counters
c
         rnump = rnump + npemit - npwold(lunsplit,ib)
         npwold(lunsplit,ib) = npemit
  500 continue
c
c     write results to disk, in parallel, done by worker
c
      call nijfile(ifwrtbk, nbk)
c
      return
c
 3001 format (/10x,'- - -   ERROR termination from blockloop!!   - - -'
     $ / 3x,'One value of nphtn = 0 the other does not!! ' 
     $ / 3x,'surface, band  -',2(i5,3x))
c
 5001 format (1x,' no emissions - ',3(i5,2x), i10,2(2x,e11.4))
 5002 format (1x,'    converged - ',3(i5,2x), i10,2(2x,e11.4))
 5003 format (1x,'not converged - ',3(i5,2x), i10,2(2x,e11.4))
c
      end 
c
c***********************************************************************
c
      subroutine blockset (nbk) 
c
c***********************************************************************
c     Subroutine to initialize the block arrays for block nbk          
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     obtain results for this block of surfaces
c
       nedo = nbkpntr(nbk + 1) - nbkpntr(nbk)
c
       ie = 0
       do 150 ne = nbkpntr(nbk) + 1, nbkpntr(nbk + 1)
          ie = ie + 1
          nelist(ie) = nbkemitlist(ne) 
 150   continue
c
       return 
       end
c
c***********************************************************************
c
      subroutine eptinit (ib)
c
c***********************************************************************
c subroutine to initilize the subroutine getpntgrd for the lemitth
c element.
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'    
c
      photot = real(ndivx*ndivy*nphtn(lemit,ib))
      n1 = nodes(1,lemit)
      n2 = nodes(2,lemit)
      n3 = nodes(3,lemit)
      n4 = nodes(4,lemit)
c
c *** calculate constants for generation loop
c
      do 100 i = 1, 3
         h(1,i) = (pntnd(i,n2) - pntnd(i,n1))/fdy
         h(2,i) = pntnd(i,n1)
         h(3,i) = (pntnd(i,n3) - pntnd(i,n4))/fdy
         h(4,i) = pntnd(i,n4)
  100 continue
c
      return
      end
c
c***********************************************************************
c
      subroutine getang (jdo, ib, iact)
c
c***********************************************************************
c     subroutine to determine circumferential and cone angles for emission
c     and diffuse interaction  
c     jdo is the surface to emit/interact with
c     ib is the band number 
c     iact is 
c        0  for emissiom
c        2 for diffuse reflection
c       -2 for diffuse transmission
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'  
c
c     emission pdf for material type 2 - accept/reject
c
      fcn(t,p) = (1.-t/pi2)*(1.-p/p2i)
      fmax = 1.
c
c     Material properties for the surface
c
      mnj = matnum(jdo)
c
c     case where surface is emitting
c
      if (iact.eq.iaem) then
         ietpj = ietp(mnj,ib)
c
c       emission by emissivity curve, use surface local coordinates
c
        if (ietpj.eq.0) then
           rn = ranlf()
           phi = p2i*rn
c
           rn = ranlf()
           irn = 100.*rn
           frac = rn*100. - irn
           theta = thetar(irn,mnj,ib) + frac*dth(irn,mnj,ib)
           cost = cos(theta)
c
c       Beam emission
c
        else if (ietpj.eq.1) then
           if (imform.eq.1) then
c
c     new material model beam emission, set evect and return
c
              vecte(1) = ebx(mnj,ib)
              vecte(2) = eby(mnj,ib)
              vecte(3) = ebz(mnj,ib)
              return
           else
c
c     old material model, define phi and cost in surface local coordinates
c
              phi = phiset(mnj,ib)
              cost = costbeam(mnj,ib)
           end if
c
c     function emission - accept/reject method, use surface local coordinates
c
        else if (ietpj.eq.2) then
 100       rn1 = ranlf()
           rn2 = ranlf()
           rn3 = ranlf()
           phi = p2i*rn1
           theta = pi2*rn2
           test = fcn(theta,phi)/fmax
           if (rn3.gt.test) then
             goto 100
           end if
           cost = cos(theta)
        end if
c
c     case of diffuse reflection, use surface local coordinates
c
      else if (iact.eq.iard) then 
        rn = ranlf()
        phi = p2i*rn
        rn = ranlf()
        cost = rn**rfactrd(mnj,ib)
c
c     case of specular reflection, do surface local coordinate 
c     calculations and return the results
c     Calculate local surface cosines
c
      else if (iact.eq.iars) then
         exl = vecte(1)*cax(jdo) + vecte(2)*cbx(jdo) + vecte(3)*cgx(jdo)
         eyl = vecte(1)*cay(jdo) + vecte(2)*cby(jdo) + vecte(3)*cgy(jdo)
         ezl = -ezlint
c
c     Convert to global coordinates
c
         vecte(1) = exl*cax(jdo) + eyl*cay(jdo) + ezl*caz(jdo)
         vecte(2) = exl*cbx(jdo) + eyl*cby(jdo) + ezl*cbz(jdo)
         vecte(3) = exl*cgx(jdo) + eyl*cgy(jdo) + ezl*cgz(jdo)
c
c     calculations done, return
c
         return
c
c     case of diffuse transmitance, use surface local coordinates
c
      else if (iact.eq.iatd) then
        rn = ranlf()
        phi = p2i*rn
        rn = ranlf()
        cost = rn**rfacttd(mnj,ib)
c
c     do semi-specular
c
      else    
c
c   calculate incoming x and y vector components in surface-local 
c   coordinate system
c
         exl = vecte(1)*cax(jdo) + vecte(2)*cbx(jdo) + vecte(3)*cgx(jdo)
         eyl = vecte(1)*cay(jdo) + vecte(2)*cby(jdo) + vecte(3)*cgy(jdo)
c
c   calculate phip [ = phii (incident azimuthal angle)]
c
         phip = atan2(eyl,exl)
         if (phip.lt.0) then
            phip = phip + p2i
         end if 
c
c        calculate phip (preferred outgoing azimuthal angle)
c        and local phi
c
         rn = ranlf()
         phi = p2i*rn
c
c   calculate thetap and and local theta (only two parts that depend on
c   whether this is ss reflect or ss transmit)
c
         if (iact.eq.iarss) then
         thetap = thprss(ithid,mnj,ib) + fractid*dthprss(ithid,mnj,ib)
            rn = ranlf()
            theta = acos(rn**rfactrss(mnj,ib))*(1.0 - thetap/pi2)
         else if (iact.eq.iatss) then
         thetap = thptss(ithid,mnj,ib) + fractid*dthptss(ithid,mnj,ib)
            rn = ranlf()
            theta = acos(rn**rfacttss(mnj,ib))*(1.0 - thetap/pi2)
         end if 
c         
c   calculate x, y, & z components of preferred direction vector in 
c   surface-local coord system
c
         costp = cos(thetap)
         sintp = sqrt(1 - costp**2)
         cospp = cos(phip)
         sinpp = sqrt(1 - cospp**2) 
         if (phip.gt.pi) then
            sinpp = -sinpp
         end if 
c
         pxl = sintp*cospp
         pyl = sintp*sinpp
         pzl = costp
c
c   define semi-specular preferred local coordinate system
c   and normalize
c   the z axis (c?zp) is the preferred direction vector converted to global 
c   coordinates
c   the y axis is preferred local z axis cross the surface local x axis
c   the x axis is the preferred local y axis cross the preferred local z axis
c
         cazp = pxl*cax(jdo) + pyl*cay(jdo) + pzl*caz(jdo)
         cbzp = pxl*cbx(jdo) + pyl*cby(jdo) + pzl*cbz(jdo)
         cgzp = pxl*cgx(jdo) + pyl*cgy(jdo) + pzl*cgz(jdo)
c
         cayp = cbzp*cgx(jdo) - cgzp*cbx(jdo)
         cbyp = -(cazp*cgx(jdo) - cgzp*cax(jdo))
         cgyp = cazp*cbx(jdo) - cbzp*cax(jdo)
c
         cypmag = sqrt(cayp**2 + cbyp**2 + cgyp**2)
         cayp = cayp/cypmag
         cbyp = cbyp/cypmag
         cgyp = cgyp/cypmag
c
         caxp = cbyp*cgzp - cgyp*cbzp
         cbxp = -(cayp*cgzp - cgyp*cazp)
         cgxp = cayp*cbzp - cbyp*cazp
c
         cxpmag = sqrt(caxp**2 + cbxp**2 + cgxp**2)
         caxp = caxp/cxpmag
         cbxp = cbxp/cxpmag
         cgxp = cgxp/cxpmag
c
c    possible debugging, remove later
c    if coordinate system is righthanded, x cross y = z
c
c         cazptest = cbxp*cgyp - cbyp*cgxp - vectp(1)
c         cbzptest = -(caxp*cgyp - cayp*cgxp) - vectp(2)
c         cgzptest = caxp*cbyp - cayp*cbxp - vectp(3)
c         print *, 'difference in czes = ', cazptest, cbzptest, cgzptest
c
         cost = cos(theta)  
      end if   
c
c     ***  calculate local direction cosines for surface local cases not
c     finished yet
c
      sint = sqrt(1 - cost**2)
      cosp = cos(phi)
      sinp = sqrt(1 - cosp**2) 
      if (phi.gt.pi) then
         sinp = -sinp
      end if 
c
      exl = sint*cosp
      eyl = sint*sinp
      ezl = cost
c
c     correct for diffuse and semi-specular transmission
c
      if ((iact.eq.iatd) .or. iact .eq.iatss) then
         ezl = -ezl
       end if
c
c     ***  convert to global coordinates
c
      if ((iact.eq.iarss) .or. (iact.eq.iatss)) then
c
c        convert from semi-specular local coordinate system
c
         vecte(1) = exl*caxp + eyl*cayp + ezl*cazp
         vecte(2) = exl*cbxp + eyl*cbyp + ezl*cbzp
         vecte(3) = exl*cgxp + eyl*cgyp + ezl*cgzp
      else
c
c        convert from surface local coordinate system
c
         vecte(1) = exl*cax(jdo) + eyl*cay(jdo) + ezl*caz(jdo)
         vecte(2) = exl*cbx(jdo) + eyl*cby(jdo) + ezl*cbz(jdo)
         vecte(3) = exl*cgx(jdo) + eyl*cgy(jdo) + ezl*cgz(jdo)
      end if
c
      return
      end
c
c***********************************************************************
c
      subroutine getpntgrd (nd, nbk)
c
c***********************************************************************
c     subroutine to determine emission point coordinates and grid cell
c     returns the x,y,z coordinates of the nd emission point for surface 
c     lemit as pntemit, its grid indices as ncgemit and the
c     number of photons to be emitted from that point as npsub.
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'  
c
      dimension a(3),b(3), c1(3), c2(3), c3(3), c4(3), 
     $          s1(3), s2(3), s3(3), s4(3)
c
      siz(aa,bb,cc) = sqrt(aa**2 + bb**2 + cc**2)
c
c calculate the emission point
c
      ny = nd/ndivx
      yp = real(ny)
      xp = real(nd - ny*ndivx)
c
c *** emission point generation loop over dimensions
c
      do 100 i = 1, 3
         a(i) = (yp + 0.5d0)*h(1,i) + h(2,i)
         b(i) = (yp + 0.5d0)*h(3,i) + h(4,i)
         c1(i) = yp*h(1,i) + h(2,i)
         c2(i) = (yp + 1)*h(1,i) + h(2,i)
         c3(i) = (yp + 1)*h(3,i) + h(4,i)
         c4(i) = yp*h(3,i) + h(4,i)
c
         s1(i) = (xp/fdx)*(c4(i) - c1(i)) + c1(i)
         s2(i) = (xp/fdx)*(c3(i) - c2(i)) + c2(i)
         s3(i) = ((xp + 1)/fdx)*(c3(i) - c2(i)) + c2(i)
         s4(i) = ((xp + 1)/fdx)*(c4(i) - c1(i)) + c1(i)
c
         pntemit(i) = ((xp + .5d0)/fdx)*(b(i) - a(i)) + a(i)
  100 continue
c
      sz12 = siz(s1(1)-s2(1),s1(2)-s2(2),s1(3)-s2(3))
      sz13 = siz(s1(1)-s3(1),s1(2)-s3(2),s1(3)-s3(3))
      sz14 = siz(s1(1)-s4(1),s1(2)-s4(2),s1(3)-s4(3))
      sz23 = siz(s2(1)-s3(1),s2(2)-s3(2),s2(3)-s3(3))
      sz24 = siz(s2(1)-s4(1),s2(2)-s4(2),s2(3)-s4(3))
      sz34 = siz(s3(1)-s4(1),s3(2)-s4(2),s3(3)-s4(3))
c
c *** calculate subsurface area
c
      arsb = 4*(sz24**2)*(sz13**2)
      arsb = arsb - (sz14**2 + sz23**2 - sz12**2 - sz34**2)**2
      arsb = sqrt(arsb)/4
c
c calulate npend 
c
      npend = nint((arsb/areaemit)*photot)
c
c determine grid indices for the emission point
c
      do 300 i = 1, 3 
         if (igc(i).gt.0) then
c
c     uniform grid
c
            ncgemit(i) = (pntemit(i) - cg(1,i))*factg(i) + 1
         else
c
c non-uniform grids, do bisection
c
            jl = 0
            ju = ncgmax(i) + 2
c
 200        if ((ju - jl).gt.1) then
               jm = (ju + jl)/2
               if (pntemit(i).gt.cg(jm,i)) then
                  jl = jm
               else
                  ju = jm
               end if
               goto 200
            end if
c
            ncgemit(i) = jl
         end if
c
         if ((ncgemit(i).lt.1) .or. (ncgemit(i).gt.ncgmax(i))) then 
            write (6,3001) lemit, nd, pntemit, ncgemit
            write (10,3001) lemit, nd, pntemit, ncgemit
            call adios(2, nbk, 1)
         end if
  300 continue
c
c calculate grid index
c
      ngridemit = ngdel(1)*ncgemit(1) + ngdel(2)*(ncgemit(2) - 1) +     
     $           ngdel(3)*(ncgemit(3) - 1)
c
      return
c
 3001 format (
     $ ///10x,'error termination from getpntgrd, grid not found'/ 
     $ / 5x,'lemit, nd, x,y,z, nx,ny,nz',2i5, 3(2x,e12.5),3(2x,i5)//)
c
      end
c
c***********************************************************************
c
      subroutine grdint (n, nd, nbk, ib, nplp)
c
c***********************************************************************
c subroutine implementing grid shading technique 
c 
c Parameters: 
c n - Number of photons emitted so far 
c nd - Emission division number (starts from 0) 
c nbk = blk number 
c ib = band number
c nplp = loop number
c 
c If the photon is lost, ilost=1 and lost is incremented. 
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'  
c
       dimension ngriddelta(3), ngbound(3)
       dimension delgrid(3), pntd(3)
c
c     interaction flag
c
      int = 0
c
c     set up grid tracing
c
      do 10 i = 1, 3
         if (vecte(i).gt.0.) then
            vecteinv(i) = 1./vecte(i)
            dgrid(i) = (cg(ncg(i) + 1, i) - pntert(i))*vecteinv(i)
            igdelta(i) = 1
            ngbound(i) = ncgmax(i) + 1
            ngriddelta(i) = ngdel(i)
            if (igc(i).gt.0) then
               delgrid(i) = cfactg(i)*vecteinv(i)
            end if
         else if (vecte(i).lt.0.) then
            vecteinv(i) = 1./vecte(i)
            dgrid(i) = (cg(ncg(i), i) - pntert(i))*vecteinv(i)
            igdelta(i) = -1
            ngbound(i) = 0
            ngriddelta(i) = -ngdel(i)
            if (igc(i).gt.0) then
               delgrid(i) = -cfactg(i)*vecteinv(i)
            end if
         else 
            vecteinv(i) = 1d30
            dgrid(i) = 1d30
            igdelta(i) = 0
         end if
  10  continue
c 
c     finding the minimum distance to the next grid cell here means we do not 
c     have to compare interception points to grid boundaries
c     interception points past grid boundaries are automatically rejected
c     *** photon traveling to next grid starts here
c
   50 icg = 1
      dold = dgrid(1)
      do 110 i = 2,3
         if (dgrid(i).lt.dold) then
            icg = i
            dold = dgrid(i)
         end if
  110 continue 
c
c     loop over segments  to find intersection
c
      do 200 ll = iptgrd(ngrid) + 1,iptgrd(ngrid + 1) 
         l = nsegsg(ll)
c
c     backface culling
c
         ezl = vecte(1)*caz(l) + vecte(2)*cbz(l) + vecte(3)*cgz(l)
         if (ezl.ge.0.) then
            goto 200
          end if
c
c     check for reverse travel
c
         dot0 = distp(l) - pntert(1)*caz(l) - pntert(2)*cbz(l) - 
     $          pntert(3)*cgz(l)
         if (dot0.ge.0.) then
            goto 200
         end if 
c
c        check if intersection distance is less than current distance
c
         dnew = dot0/ezl
         if (dnew.gt.dold) then
            goto 200 
         end if
c
c     calculate interception point with plane and see if within polygon
c     note that test is now only done in two dimensions. The two coordinate 
c     indices used are stored in ja(l) and jb(l) all a, b and d variables 
c     are redefined from 3D to 2D in the subroutine bplane2d
c 
         pntija = pntert(ja(l)) + dnew*vecte(ja(l)) 
         pntijb = pntert(jb(l)) + dnew*vecte(jb(l))    
c
         if (pntija*a41(l) + pntijb*b41(l).gt.d41(l)) then
            goto 200
         end if
         if (pntija*a12(l) + pntijb*b12(l).gt.d12(l)) then
            goto 200
         end if
         if (pntija*a23(l) + pntijb*b23(l).gt.d23(l)) then
            goto 200
         end if
         if (pntija*a34(l) + pntijb*b34(l).gt.d34(l)) then 
            goto 200
         end if
c
c     new test required for transmittance.  If the photon is transmitted
c     then the intersection test with itself does not fail because of the
c     backface culling test, and may actually pass it with a very small
c     d due to round off error. Check for l = j, this only occurs if 
c     photon was transmitted and there is positive round off error 
c
      if (l.eq.lert) then
         goto 200
      end if
c
c     valid intersection has occurred, update variables
c
         int = 1
         dold = dnew
         lint = l
         pntint(ja(l)) = pntija
         pntint(jb(l)) = pntijb       
         ezlint = ezl
  200 continue  
c
      if (int.eq.1) then
c
c     intersection found, exit
c     Calculate final intersection point coordinate
c
         pntint(jc(lint)) = pntert(jc(lint)) + dold*vecte(jc(lint))
c
         return
      end if
c
c move to next grid
c
      ncg(icg) = ncg(icg) + igdelta(icg)
c
c check to see if out of bounds
c
      if (ncg(icg).eq.ngbound(icg)) then
c
c lost photon if this point is reached
c
         ilost = 1
         lost = lost + 1
c
c write the lost photon to the .lst file, the console,
c and if iprnt(2) ne 0 to unit 10
c
         write (4,4001) lost,1,2,nd,lert
         write (4,4002) pntert
         do 310 i = 1, 3
            pntd(i) = pntert(i) + vecte(i)*dmaxge
  310    continue          
         write (4,4002) pntd
c
         if (iprnt(2).ne.0) then
            write (6,3001) lost, lert
            write (10,3001) lost,  lert
            write (10,3002) ib, lemit, nplp, nd, n, ncg, pntert, vecte
         end if
c
         if (lost.ge.nlost) then
           write (6,3003) nlost
           write (10,3003) nlost
           call adios (2, nbk, ieplost)
         end if
c
         return
      end if
c
c   update grid information 
c
      ngrid = ngrid + ngriddelta(icg)
      if (igc(icg).gt.0) then
         dgrid(icg) = dgrid(icg) + delgrid(icg)
      else if (igdelta(icg).gt.0) then 
      dgrid(icg) = (cg(ncg(icg) + 1, icg) - pntert(icg))*vecteinv(icg)
      else 
         dgrid(icg) = (cg(ncg(icg), icg) - pntert(icg))*vecteinv(icg)
      end if 
c
c   search next grid
c
      goto 50 
c
 3001 format (2x,'lost photon no. = ',i8, 
     $ / 5x, 'last surface emitting/reflecting/transmitting =',i5)
 3002 format ( 
     $   5x, 'band, emitting surface =', 2i5
     $ / 5x, 'loop,  division,  photon  =', 3i5
     $ / 5x, 'nx,ny,nz =',3i5,  
     $ / 5x, 'last position x,y,z =',  3(2x,e14.7),
     $ / 5x, 'ex,ey,ez =', 3(2x,f10.7)//)
 3003 format (/10x,
     $ 'you have exceeded the maximum no. of lost photons =', i5,  
     $ /10x,'--- error termination---'/)
c
 4001 format (5(3x,i7))
 4002 format (3(2x,e10.4))
c
      end
c
c***********************************************************************
c
      function ranlf ()
c
c***********************************************************************
c     function to generate lagged Fibonacci pseudo-random numbers
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     get new seed
c
      iseed(it1) = iseed(it1) + iseed(it2)
      iseed(it1) = iand(iseed(it1), modulus)
c
c     generate random integer
c
      ranlf = iseed(it1)*rmult
c
c     cyclic permutation of taps
c
      it1 = it1 - 1
      it2 = it2 - 1
      if (it1 .lt. 1) then
        it1 = lflen
      else if (it2 .lt. 1) then
        it2 = lflen
      end if
c
      return
      end
c
c***********************************************************************
c
      subroutine surfloop (ie, ib, nbk, nplp) 
c
c***********************************************************************
c     Subroutine to loop over one surface (or one split surface)  
c     ie = the surface number within the block
c     ib = the band number
c     nbk = the block number         
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     initialize emission point calculations
c
      call eptinit (ib)
      ilost = 0
c
c     loop over emission divisions for one element
c
      do 500 nd = 0,npntsm1
c
c     get coordinates and grid cell of emission point 
c
         call getpntgrd(nd, nbk)
c
c     loop over number of photons emitted per emission point
c
         do 400 n = 1,npend
            ihist = ihist + 1
            npemit = npemit + 1
c
c     *** lost photons start here
c 
  100       lert = lemit
            ievent = 1
            numref = 0
            do 110 i = 1, 3
               pntert(i) = pntemit(i)
               ncg(i) = ncgemit(i)
  110       continue 
            ngrid = ngridemit      
c
c     Subroutine to determine circumferential angle and
c     cone angle for photon emission.
c
            call getang (lemit, ib, iaem)
c
c     Find surface which photon strikes - repeat until absorbed
c     find intersecting surface
c     ****reflected photon starts here
c
 200        call grdint (n, nd, nbk, ib, nplp)
c
c      write the trajectory to the traces file
c
            if (itraces.gt.0) then
               write (9,1002) ihist, ievent, 2, matnum(lunsplit), ib
               write (9,1003) pntert
               write (9,1003) pntint
               ievent = ievent + 1
            end if
c
            if (ilost.eq.1) then
               ilost = 0
c
c      photon lost
c      go back to around top of loop
c
                goto 100
            end if             
c
c     determine if photon is reflected and if so, how
c     result is stored in iact
c
            call absref (ib, iact)
c
c     handle the photon interaction, note that nothing happens to a 
c     specularly transmitted photon, it travels the same path as before
c
            if (iact.eq.iaab) then
c
c     photon absorbed, go onto next photon
c 
              npabs(lint,ie) = npabs(lint,ie) + 1
            else
c
c     handle reflected-transmitted photon
c
               if (iact.ne.iats) then
c
c     if specular transmission (iats) then the path of the photon is 
c     unaltered, else determine the new direction with getang
c
                  call getang (lint, ib, iact)
               end if 
c
c     define intersection point as new emission point
c
               lert = lint
               do 250 i = 1, 3
                  pntert(i) = pntint(i)
  250          continue
c
c     'bookkeeping' of reflected photon
c
               numref = numref + 1
               if (numref.ge.nrefs) then
                  iwarn = iwarn + 1
                  if (iwarn.ge.nwarns) then
                     write(6,3001) nwarns, nrefs, lemit, nd, n
                     write(10,3001) nwarns, nrefs, lemit, nd, n
                     call adios (2, nbk, ieref)
                  else
                     write(6,3002) n, nrefs, iwarn, nwarns, lemit, nd
                     write(10,3002) n, nrefs, iwarn, nwarns, lemit, nd 
c
c     start loop over for lost photon
c
                     goto 100  
                  end if
               end if 
c
c     start over for reflected photon
c
               goto 200
            end if
  400    continue   
  500 continue 
c
      return
c
 1002 format (5(1x,i5))
 1003 format (3(2x,e10.4))
c
 3001 format (/10x,'- - -   error termination from surfloop!!   - - -'
     $ / 3x,'maximum number of warnings (= ', i5, ') ' 
     $ / 3x,'about too many reflections (limit = ',  i5, ') reached',
     $ / 3x,'surface, surface division, photon number -',3(i5,3x))
 3002 format (/10x,'- - - warning from surfloop - - -'
     $ / 3x,'reflections of no.= ',i5,' has occurred',i5,' times'
     $ / 3x,'this is warning ', i5, ' out of ', i5, ', re-emitting'
     $ / 3x,'surface, surface division -',2(i5,3x))
c
      end
