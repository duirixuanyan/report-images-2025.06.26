c*********************************************************************     
c
c     m311s.f
c
c***********************************************************************
c     This file contains the subroutine input3 which handles the input
c     process.  It also contains the subroutines called by input3 up to 
c     wavin. These can be described as all the subroutines for inputting 
c     nodes, surfaces and wavelength bands and printing memory error
c     messages. They are: 
c     basememprint, nodin3, surfin3, surfinfo, and wavin  
c***********************************************************************
c*                                                                     *
c*         ***  *     *  ******   *     *   *******   *****            *
c*          *   **    *   *    *  *     *      *     *     *           *
c*          *   * *   *   *    *  *     *      *           *           *
c*          *   *  *  *   *****   *     *      *        ***            *
c*          *   *   * *   *       *     *      *           *           *
c*          *   *    **   *       *     *      *     *     *           *
c*         ***  *     *   *        *****      ***     *****            *
c*                                                                     *
c***********************************************************************
c
      subroutine input3
c
c***********************************************************************
c     subroutine to perform data input, generation and echo         
c***********************************************************************
c2 4 6 8(1)2 4 6 8(2)2 4 6 8(3)2 4 6 8(4)2 4 6 8(5)2 4 6 8(6)2 4 6 8(7)2
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      character*8  star
      data star /'********'/
c
c     istop = 1 if any generic error
c     imerr = 1 if any memory allocation problems
c
      istop = 0
      imerr = 0
c
c     input header describing the run
c
      read (1,1000) (head(i),i=1,6)
c 
      write (6,4000) (head(i),i=1,6),(head(i),i=13,15)
c
c     print title page
c
      write (10,4001) (star,k=1,9)
      write (10,4002)
      write (10,4001) (star,k=1,9)
      write (10,4003) (head(i),i=1,6),(head(i),i=11,15),
     $                   aname(1),aname(2),aname(3),aname(4),
     $                   aname(7),aname(8),aname(9),aname(10),
     $                   aname(11), aname(12), aname(13), aname(14)
      write (10,4004)
      call header
c
c     read control cards
c     cc - 1
c
      read (1,1001) ndim,numnp,nsurf,nummat,nbands,nphton,
     $              nrefs,nwarns,nlost,irstflg, inseed
c
c     correct inputted values
c     Note ndim is only used in this subroutine
c
      if (ndim.ne.3) then
         write (10,3001)
         write (6,3001)
         ndim = 3
      end if
c
      if ((numnp.le.0) .or. (nsurf.le.0) .or. (nbands.le.0)) then
         write (6,3002) numnp, nsurf, nbands
         write (10,3002) numnp, nsurf, nbands
         istop = 1
      end if
c
      if (nummat.eq.0) then 
         write (6, 3003) 
         write (10, 3003)
         istop = 1
      else if (nummat.lt.0) then
         nummat = abs(nummat)
         imform = 1
      else
         imform = 0  
      end if
c
      if (nrefs.le.0) then
         write (10,3004) nrefs
         write ( 6,3004) nrefs 
         nrefs = 100
      end if
c
      if (nwarns.le.0) then
         write (10,3005) nwarns 
         write ( 6,3005) nwarns 
         nwarns = 50
      end if
c
      if (irstflg.eq.0) then
         write (10,3006)  
         write ( 6,3006)  
         irstflg = 10
      end if
c
c     nincr has been replaced by two variables, both in common contro 
c     irstflg = determines if the run is initial or restart by sign
c     neblock = iabs(irstflg) number of surfaces in a block
c
      neblock = iabs(irstflg)   
c
c     if inseed is less than 0 it is set to a debugging value
c     if inseed = 0 it is set by the time
c
      if (inseed.lt.0) then
         write (10,3007) inseed, iseeddef 
         write ( 6,3007) inseed, iseeddef
         inseed = iseeddef
         iseed0 = iseeddef
      else if (inseed.eq.0) then
         inseed = iseed0
      else
         iseed0 = inseed
      end if
c
c     check storage vs. parameter constants
c
      if (numnp.gt.inod) then
         imerr = 1
      end if
      if (nsurf.gt.isrf) then
         imerr = 1
      end if
      if (nsurf.gt.isrfs) then
         imerr = 1
      end if    
      if (nummat.gt.imat) then
         imerr = 1
      end if
      if (nbands.gt.ibnd) then
         imerr = 1
      end if
      if (neblock.gt.iblk) then
         imerr = 1
      end if
c
c     calculate needed block variables
c     nblocks and neleft are both stored in contro
c
      netot = nsurf*nbands
      nblocks = netot/neblock
      neleft = mod(netot,neblock)
      if (neleft.ne.0) then
         nblocks = nblocks + 1
      end if
      if (nblocks.gt.itblk) then
         imerr = 1
      end if
      nlogblk = nint(log10(float(nblocks)) + 0.5)
      if (nlogblk.gt.iimag) then
         imerr = 1
      end if
c
      if (imform .eq. 1) then
         nummattmp = -nummat
      else            
         nummattmp = nummat
      end if
      write (10,2000)
      write (10,2001) ndim,numnp,nsurf,nummattmp,nbands,nphton,
     $                nrefs,nwarns,nlost,irstflg,inseed
c
c     cc - 2
c
      read(1,1002) igeom,iprnt,numcat,idata,ndivx,ndivy,nshade,itraces,
     $             nwproc, nploops, iparopt, nmacv, ndtcv
c
c      check and try to correct for inappropriate values 
c      note that numcat is only used in this subroutine 
c
      if (numcat.ne.0) then
         write ( 6,3201) numcat
         write (10,3201) numcat
         istop = 1
      end if
c
      if (ndivx.le.0) then
         write (10,3202) ndivx
         write ( 6,3202) ndivx
         ndivx = 5
      end if
      if (ndivy.le.0) then
         write (10,3203) ndivy 
         write ( 6,3203) ndivy 
         ndivy = 5
      end if
c
c     check for nwproc and iparopt problems 
c
      if (iparflg.eq.0) then
c
c     serial code
c
         if (nwproc.eq.0) then 
            nwproc = 1
         end if 
c
         if (nwproc.ne.1) then
            write (10, 3204) nwproc
            write ( 6, 3204) nwproc
            nwproc = 1
         end if
      else
c
c     parallel code
c
         if ((nwproc.gt.iwproc)) then
            imerr = 1
         else if (nwproc.lt.1) then
c
c     if nwproc less than 1 run parallel code as nonparallel
c
            write (10, 3205) 
            write ( 6, 3205) 
            iparflg = 0
         end if
c
         if ((iparopt(1).lt.0) .or. (iparopt(1).gt.3)) then
            write (10, 3206) iparopt(1)
            write ( 6, 3206) iparopt(1)
            call adios(2,0,0)
         end if
      end if  
c   
c     if new material model, check nmacv and ndtcv
c
      if (imform.eq.1) then
         if (nmacv.lt.0) then 
            write (6, 3207) nmacv
            write (10, 3207) nmacv
            istop = 1
         end if 
c
         if (ndtcv.lt.0) then 
            write (6, 3208) ndtcv
            write (10, 3208) ndtcv
            istop = 1
         end if  
      end if     
c
      write (10,2002) iprnt,idata, ndivx,ndivy, nshade
      write (10,2003) itraces, nwproc,iparopt(1), nmacv, ndtcv
c
c     cc - 3
c
      read (1,1003) xscale,xshift,yscale,yshift,zscale,zshift,delt,
     $              splitol
c
c     set default values
c
      if (abs(xscale).lt.1.e-6) then
         write (10,3301) xscale 
         write ( 6,3301) xscale
         xscale = 1.0
      end if
      if (abs(yscale).lt.1.e-6) then
         write (10,3302) yscale 
         write ( 6,3302) yscale
         yscale = 1.0
      end if
      if (abs(zscale).lt.1.e-6) then
         write (10,3303) zscale 
         write ( 6,3303) zscale
         zscale = 1.0
      end if
c
      if ((delt.lt.1.e-7).or.(delt.gt.1.e-1)) then
         write (10,3304) delt 
         write ( 6,3304) delt
         delt = 1.0e-2
      end if
c
      if (((splitol.lt.1.e-20).and.(splitol.ge.0)).or.
     $   (splitol.gt.1.e-1)) then
         write (10,3305) splitol
         write ( 6,3305) splitol
         splitol = 1.0e-4
      end if
c
      if (splitol.lt.0) then
         write (10,3306) splitol
         write ( 6,3306) splitol
      end if
c
c     print control information
c
      write (10,2004) xscale,xshift,yscale,yshift,zscale,zshift,
     $               delt, splitol
c
c     read no. of x,y, and z grids for grid shading algorithm
c
      if (nshade.lt.0) then
c
c     user has given grid values
c
         read(1,1004) igc
         ncgmax(1) = iabs(igc(1))
         ncgmax(2) = iabs(igc(2))
         ncgmax(3) = iabs(igc(3))
         if (ncgmax(1).eq.0.or.ncgmax(2).eq.0.or.ncgmax(3).eq.0) then
            write (6,3401) ncgmax
            write (10,3401) ncgmax
            istop = 1
         end if
         if (ncgmax(1).gt.incg .or. ncgmax(2).gt.incg .or. 
     $       ncgmax(3).gt.incg) then
            imerr = 1
         end if
      else
c
c     user has not given grid values, use 1 grid
c
         do 10 i = 1, 3
            igc(i) = 1
            ncgmax(i) = 1  
   10    continue   
      end if
c
      write (10,2005) igc
c
c     set nploops and errdef
c
      if (nploops.lt.0) then
c
c     invalid value of nploops
c
         write (6, 3402) nploops
         write (10, 3402) nploops
         istop = 1
      else if (nploops.eq.0) then
c
c     nploops = 0, set both nploops and errdef to their default values
c
         errdef = 1.e10 
         nploops = 1
      else if (nploops.gt.0) then 
c
c     read  error tolerance if nploops gt 0 
c
          read (1,1005) errdef
      end if
c
      write (10,2006) nploops,errdef
c
      if ((istop.eq.1) .or. (imerr.eq.1)) then
         call basememprint (6)
         call basememprint (10)
         write( 6, 3504)
         write(10, 3504)
         write( 6, 3505)
         write(10, 3505)
         if (iparflg .eq. 1) then
            write( 6, 3503) iwproc,nwproc,nint(100*real(nwproc)/iwproc)
            write(10, 3503) iwproc,nwproc,nint(100*real(nwproc)/iwproc)
         end if
         if (nsurf.gt.isrfs) then
            write (10,3506) nsurf, isrfs
            write ( 6,3506) nsurf, isrfs
         end if    
         if (imerr.eq.1) then
            write( 6, 3507)
            write(10, 3507)
         end if 
         call adios(2, 0, iemall)
      end if
c
c     set the error for each emitting surface to -1 
c
      do 50 ii = 1, nbands
         do 40 jj = 1, nsurf
            error(jj,ii) = -1.
 40      continue
 50   continue
c
c     input nodal data
c
      call nodin3 
c
c     input surface data
c
      call surfin3(imerr)
c
      if (imerr.eq.1) then
         call basememprint (6)
         call basememprint (10)
         write( 6,3501) isrfs,nsptr,nint(100*real(nsptr)/isrfs)
         write(10,3501) isrfs,nsptr,nint(100*real(nsptr)/isrfs)
         write( 6,3505) 
         write( 10,3505) 
         if (iparflg .eq. 1) then
            write( 6, 3503) iwproc,nwproc,nint(100*real(nwproc)/iwproc) 
            write(10, 3503) iwproc,nwproc,nint(100*real(nwproc)/iwproc)
         end if
         write( 6,3507)
         write(10,3507)
         call adios(2, 0, iemall)
      end if
c
      call wavin
c
c     input material data, new or old model
c
      if (imform.eq.0) then
         call matinold
      else
         call matinnew
      end if 
c
c     calculated needed curve data
c
      call curveset
c
c     zero nphtn as needed
c
      do 200 ib = 1, nbands
         nemitcount(ib) = 0
         do 199 n = 1, nsurf
            matnom = matnum(n)
            if (noep(matnom,ib).eq.1) then
               nphtn(n,ib) = 0
               if (isplit(n).ne.0) then 
                  nphtn(isplit(n),ib) = 0
               end if 
            else
               nemitcount(ib) = nemitcount(ib) + 1
            end if
 199     continue
 200  continue
c
c     calculate cumulative distributive function for emission
c
      call cumdis
c
      if ((iparflg.eq.0) .or. (mymid.eq.0)) then
         call fileset
      end if
c
c     set up RNG and exchange factor, restart and block files
c 
      call ranset
c
c     call grid shading algorithm
c
      call gridin(imerr,kountg)
c
      call basememprint (6)
      call basememprint (10)
      write( 6,3501) isrfs,nsptr,nint(100*real(nsptr)/isrfs)
      write(10,3501) isrfs,nsptr,nint(100*real(nsptr)/isrfs)
      write( 6,3502) iseg, kountg,nint(100*real(kountg)/iseg)
      write(10,3502) iseg, kountg,nint(100*real(kountg)/iseg)
      if(iparflg .eq. 1) then
         write( 6, 3503) iwproc,nwproc,nint(100*real(nwproc)/iwproc)
         write(10, 3503) iwproc,nwproc,nint(100*real(nwproc)/iwproc)
      end if
c
      if (imerr.eq.1) then
         write( 6,3507)
         write(10,3507)
         call adios(2, 0, iemall)
      end if
c
      if ((iparflg.eq.0) .or. (mymid.eq.0)) then
c
c     check enclosure for leaks
c
         call order 
c
c     generate graphics input file
c
         call graf
      end if
c
c generate 2D bounding planes
c
      call bplane2d 
c
c     input phase complete
c
      write (10,2101)
      write (6,2101) 
c
c     determine cpu time for input
c
      call timing (1)
c
      if (idata.eq.1) then
         write (6,2102)
         write (10,2102)
         call adios (1, 0, 0)
      end if 
c
      return
c
 1000 format (8a8)
 1001 format (10i5, i10)
 1002 format (i5,5i1,8i5, 5i1, 2i5)
 1003 format (8e10.0)
 1004 format (16i5)
 1005 format (8e10.0)
c
 2000 format (15x,'c o n t r o l   i n f o r m a t i o n'//)
 2001 format (//
     $ / 8x,'number of dimensions (ndim)                          =',i5/
     $ / 8x,'number of node points (numnp)                        =',i5/
     $ / 8x,'number of radiating surfaces (nsurf)                 =',i5/
     $ / 8x,'number of materials (nummat)                         =',i5
     $ /11x,'if negative, use the new material input model'
     $ /11x,'otherwise use the old material input model'/
     $ / 8x,'number of radiative bands (nbands)                   =',i5/
     $ / 8x,'default no. photons emitted per subsurface (nphton)  =',i5/
     $ / 8x,'max. no. reflections (nrefs)                         =',i5/
     $ / 8x,'max. no. of warnings that max. no. reflections' 
     $ / 8x,'occured (nwarns)                                     =',i5/
     $ / 8x,'max. no. of lost photons (nlost)                     =',i5/
     $ / 8x,'surf. (emitter) increment for writing restart info. '
     $ / 8x,'(neblock)                                            =',i5
     $ /11x,'neblock > 0 : initial run'
     $ /11x,'neblock < 0 : restart from old restart file'
     $ /11x,'restart information written every abs(neblock) surfaces' /
     $ / 8x,'initial seed for Random Number Generator (RNG)       =',i10
     $ /11x, 'seed value meaningless for a restart run'/)
 2002 format (/
     $ / 8x,'print flags (iprnt): 0 - not printed, 1 - printed',
     $ / 8x,'   iprnt (1) - exchange factors                      =',i5
     $ / 8x,'   iprnt (2) - lost photons                          =',i5
     $ / 8x,'   iprnt (3) - reserved for future use               =',i5
     $ / 8x,'   iprnt (4) - calculated material property curves   =',i5
     $ / 8x,'   iprnt (5) - grid segments                         =',i5/
     $ / 8x,'data check code (idata)                              =',i5
     $ /11x,'normal execution     - idata = 0'
     $ /11x,'data check only      - idata = 1'/
     $ / 8x,'no. of subsurface divisions in x per surface         =',i5/
     $ / 8x,'no. of subsurface divisions in y per surface         =',i5/
     $ / 8x,'shading or no shading                                =',i5
     $ /11x,'shading- distance algorithm      - nshade => 0'
     $ /11x,'shading- grid algorithm          - nshade < 0' )
 2003 format (
     $ / 8x,'debugging option (itraces)                           =',i5
     $ /11x,'normal-photon trace file not produced - itraces = 0 '
     $ /11x,'debug-photon trace file produced      - itraces = (+) ' /
     $ / 8x,'number of worker processes (nwproc)                  =',i5/
     $ / 8x,'parallel option flags (iparopt):                       '
     $ / 8x,'   iparopt (1) - worker spawning options             =',i5
     $ /11x,'other members of the iparopt array are reserved for ',
     $ /11x,'future use'/
     $ /11x,'iparopt(1) = 0 : workers CAN spawn on master''s cpu',
     $ /11x,'iparopt(1) = 1 : workers can NOT spawn on master''s cpu',
     $ /11x,'iparopt(1) = 2 : debug session xterm for each worker'
     $ /11x,'iparopt(1) = 3 : same as iparopt(1) = 1 and 2' /
     $ / 8x,'number of material property curves entered (nmacv)   =',i5/
     $ / 8x,'number of delta theta curves entered (ndtcv)         =',i5)
 2004 format (//
     $ / 8x,'scale for x - axis (xscale)',26x,'=',e12.5/
     $ / 8x,'shift for x - axis (xshift)',26x,'=',e12.5/
     $ / 8x,'scale for y - axis (yscale)',26x,'=',e12.5/
     $ / 8x,'shift for y - axis (yshift)',26x,'=',e12.5/
     $ / 8x,'scale for z - axis (zscale)',26x,'=',e12.5/
     $ / 8x,'shift for z - axis (zshift)',26x,'=',e12.5/
     $ / 8x,'increment of theta (cone angle) for integration'
     $ /11x,'in cumulative distribution function - r(theta)'
     $ /11x,'increment (delt - deg)                        =',e14.7/
     $ / 8x,'tolerance for non-coplanar surfaces (splitol)    =',e14.7/)
 2005 format ( 
     $  /8x,'grid dimensions'/
     $  8x, 'uniform grid coordinates for positive values, '/
     $  8x,  'user-defined coordinates for negative values '//
     $  8x,'ngx',50x,'=',i5//
     $  8x,'ngy',50x,'=',i5//
     $  8x,'ngz',50x,'=',i5/)
 2006 format (
     $  8x,'maximum no. of photon convergence loops (nploops) =',i5
     $ /8x,'default error tol. - photon conver. (errdef)      =',e14.7)
c
 2101 format (///8x,' i n p u t   p h a s e   c o m p l e t e'/////)
 2102 format (//5x,'d a t a   c h e c k   o n l y -- d a t a   ',
     $             'c h e c k   c o m p l e t e'////)
c
 3001 format (
     $ / 5x, '--- warning --- setting number of dimensions', 
     $        '(ndim) to 3!'/)
 3002 format (
     $ / 10x,'--- ERROR --- number of nodes, surfaces, and bands must ',
     $        'be > 0'
     $ / 12x, 'yours are numnp - ', i5,', nsurf - ',i5,',  nbands - ',i5
     $ / 15x, '------ STOPPING ------'/)
 3003 format (
     $ / 10x, '--- ERROR --- number of materials (nummat) must not = 0'
     $ / 15x, '------ STOPPING ------'/)
 3004 format (
     $ / 5x, '--- warning --- nrefs must be greater than 0 '
     $ / 7x, 'you entered ', i5
     $ / 7x,'setting nrefs to 100 and continuing'/)
 3005 format (
     $ / 5x, '--- warning --- nwarns must be greater than 0 '
     $ / 7x, 'you entered ', i5
     $ / 7x, 'setting nwarns to 50 and continuing'/)
 3006 format (
     $ / 5x, '--- warning --- neblock must not equal 0 '
     $ / 7x, 'setting neblock to 10 and continuing'/)
 3007 format (
     $ / 5x, '--- warning --- initial seed (inseed) must be >= 0'
     $ / 7x, 'you entered ', i10
     $ / 7x, 'setting initial seed to ', i10, ' and continuing'/)
c
 3201 format (
     $ / 10x, '--- ERROR --- concatenation disallowed!'/
     $ / 12x, 'numcat must be zero in this version.  you entered ',i5
     $ / 12x, 'for numcat'
     $ / 15x, '------ STOPPING ------'/)
 3202 format (
     $ / 5x, '---warning--- ndivx must be greater than 0 '
     $ / 7x, 'you entered ', i5
     $ / 7x, 'setting ndivx to 5 and continuing'/)
 3203 format (
     $ / 5x, '---warning--- ndivy must be greater than 0 '
     $ / 7x, 'you entered ', i5
     $ / 7x, 'setting ndivy to 5 and continuing'/)
 3204 format (
     $ / 5x, '---warning--- for serial code, nwproc must be 1 '
     $ / 7x, 'you entered ', i5
     $ / 7x, 'setting nwproc to 1 and continuing'/)
 3205 format ( 
     $ / 10x, '--- ERROR --- number of workers less than 0'
     $ / 12x, 'for the parallel code, nwproc must be greater than 0' 
     $ / 12x, 'you entered ',i5,  'for nwproc'
     $ / 15x, 'Code will run serial on the current processor only'/)
 3206 format (
     $ / 10x, '--- ERROR --- invalid value of iparopt(1)'
     $ / 15x, 'you entered iparopt(1) = ', i5     
     $ / 15x, 'iparopt(1) must be between 0 and 3, inclusive'
     $ / 15x, '------ STOPPING ------'/)
 3207 format ( 
     $ / 10x, '--- ERROR --- number of material property curves < 0'
     $ / 12x, 'for the new material model, nmacv must >= 0' 
     $ / 12x, 'you entered ',i5,  'for nmacv'
     $ / 15x, '------ STOPPING ------'/)
 3208 format ( 
     $ / 10x, '--- ERROR --- number of semi-specular del theta curves ',
     $        '< 0'
     $ / 12x, 'for the new material model, ndtcv must be >= 0'
     $ / 12x, 'you entered ',i5,  'for ndtcv'
     $ / 15x, '------ STOPPING ------'/)
c
 3301 format (
     $ / 5x, '--- warning --- abs(xscale) must be => 1e-6'
     $ / 7x, 'you entered ', e12.5
     $ / 7x, 'setting xscale to 1 and continuing'/)
 3302 format (
     $ / 5x, '--- warning --- abs(yscale) must be => 1e-6'
     $ / 7x, 'you entered ', e12.5
     $ / 7x, 'setting yscale to 1 and continuing'/)
 3303 format (
     $ / 5x, '--- warning --- abs(zscale) must be => 1e-6'
     $ / 7x, 'you entered ', e12.5
     $ / 7x, 'setting zscale to 1 and continuing'/)
 3304 format (
     $ / 5x, '--- warning --- increment of cone angle (delt)'
     $ / 7x, 'must be between 1e-7 and 1e-1 '
     $ / 7x, 'you entered ', e12.5
     $ / 7x, 'setting delt to 1e-2 and continuing'/)
 3305 format (/5x,'--- warning --- tolerance for non-coplanar surfaces '
     $ / 5x, ' (splitol) must be between 1e-20 and 1e-1 or negative '
     $ / 7x, 'you entered ', e12.5
     $ / 7x, 'setting splitol to 1e-4 and continuing'/)
 3306 format (
     $  / 5x, '--- warning --- tolerance for non-coplanar surfaces '
     $  / 7x, ' (splitol) is negative. '
     $  / 7x, 'you entered ', e12.5
     $  / 7x, ' ALL surfaces will be split into triangles. '/)
c
 3401 format (
     $ / 10x, '--- ERROR ---- number of grids must be = 0'
     $ / 12x, 'yours are x - ',i5,'     y - ',i5,'     z - ',i5
     $ / 15x, '------ STOPPING ------'/)
 3402 format ( 
     $ / 10x, '--- ERROR --- number of photon loops (nploops) < 0'
     $ / 12x, 'nploops must >= 0' 
     $ / 12x, 'you entered ',i5,  'for nploops'
     $ / 15x, '------ STOPPING ------'/)
c
 3501 format (' 9. Surfaces including split surfaces (isrfs)   ',
     $                 t48,i6,' words ',i6,' words (',i3,'%)')
 3502 format ('10. Surface segments in grid cells (iseg)   ',
     $                 t48,i6,' words ',i6,' words (',i3,'%)')
 3503 format ('11. Worker processes (iwproc)',
     $                 t48,i6,' words ',i6,' words (',i3,'%)')
 3504 format 
     $ (' 9. WARNING - Required value for total surfaces including ',
     $  'split surfaces '
     $ / 14x, '(isrfs) unknown (range: nsurf <= isrfs <= 2*nsurf)')
 3505 format 
     $ ('10. WARNING - Required value for surface segments in ',
     $  'grid cells (iseg) unknown')
 3506 format (//
     $ / 10x, '--- ERROR --- the parameter isrfs must be at least', 
     $ / 12x, 'equal to nsurf if not greater'
     $ / 12x, 'nsurf - ', i5, ', isrfs - ',i5)
 3507 format (/ 10x,'--- ERROR -- memory storage exceeded' 
     $ / 12x,'Increase appropriate parameter(s) in the file mont3d.par'
     $ / 12x,'and recompile all source files'
     $ / 15x, '------ STOPPING ------'/)
c
 4000 format (1x,7a8,1x,2a8/)
 4001 format (/5x,15a8)
 4002 format (/
     $ / 8x,' *     *    ***    **    *  *******   ****   *****  '
     $ / 8x,' **   **   *   *   **    *     *     *    *  *    * '
     $ / 8x,' * * * *  *     *  * *   *     *          *  *    * '
     $ / 8x,' *  *  *  *     *  *  *  *     *      ****   *    * '
     $ / 8x,' *     *  *     *  *   * *     *          *  *    * '
     $ / 8x,' *     *   *   *   *    **     *     *    *  *    * '
     $ / 8x,' *     *    ***    *    **     *      ****   *****  '/)
 4003 format (//8x,'title - ',6a8 /
     $ / 8x,'time - ',a8/8x,'date - ',a8/8x,'version - ',a8/
     $ / 8x,'monte version compiled - ',a8 /
     $ / 8x,'machine - ',a8 /
     $ / 8x,'filenames follow:'
     $ /11x,' 1. scratch (temporary)                         = ',a
     $ /11x,' 2. restart                                     = ',a
     $ /11x,' 3. plot                                        = ',a
     $ /11x,' 4. lost photon trace                           = ',a
     $ /11x,' 7. input                                       = ',a
     $ /11x,' 8. exchange matrix                             = ',a
     $ /11x,' 9. traces (if traces run)                      = ',a
     $ /11x,'10. output                                      = ',a
     $ /11x,'11. potential leaks                             = ',a
     $ /11x,'12. block exchange number (familied, temporary) = ',a
     $ /11x,'13. temporary exchange number (binary)          = ',a
     $ /11x,'14. block info (temporary)                      = ',a)
 4004  format(/
     $ / 8x, 'ref: Charles N. Zeeb, Patrick J. Burns & Klem Branner'
     $ / 8x, '     Department of Mechanical Engineering'
     $ / 8x, '     Colorado State University'
     $ / 8x, '     Fort Collins, CO 80523'
     $ / 8x, '     phone: (970) 491-7479, 5778 & 7479'
     $ / 8x, '     e-mail: czeeb@lamar.colostate.edu' 
     $ / 8x, '             pburns@yuma.colostate.edu'
     $ / 8x, '             klem@lamar.colostate.edu'
     $ / 8x, '          and'
     $ / 8x, '     John Dolaghan'
     $ / 8x, '     Lawrence Livermore National Laboratory'
     $ / 8x, '     e-mail: dolaghan@llnl.gov' //)
c
      end
c
c***********************************************************************
c
      subroutine basememprint (iunit)
c
c***********************************************************************
c     subroutine to print memory allocation information for the base 
c     parameters, inod, isrf, imat, ibnd, itblk, iimag, incg         
c***********************************************************************
c
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      write( iunit,3500) inod,numnp,nint(100*real(numnp)/inod),
     $               isrf,nsurf,nint(100*real(nsurf)/isrf),
     $               imat,nummat,nint(100*real(nummat)/imat),
     $               ibnd,nbands,nint(100*real(nbands)/ibnd),
     $               iblk,neblock,nint(100*real(neblock)/iblk),
     $               itblk,nblocks,nint(100*real(nblocks)/itblk),
     $               iimag,nlogblk,nint(100*real(nlogblk)/iimag),
     $               incg,max(ncgmax(1),ncgmax(2),ncgmax(3)),
     $               nint(100*real(max(ncgmax(1),ncgmax(2),
     $               ncgmax(3)))/incg)
c 
      return
 3500 format (///8x,'M e m o r y   A l l o c a t i o n   a n d',
     $ '   U s a g e'
     $ //'Category',t48,'Allocated',t64,'Used'/
     $ /' 1. Nodes (inod)   ',
     $         t48,i6,' words ',i6,' words (',i3,'%)'
     $ /' 2. Surfaces (isrf)',
     $         t48,i6,' words ',i6,' words (',i3,'%)'
     $ /' 3. Materials (imat)',
     $         t48,i6,' words ',i6,' words (',i3,'%)'
     $ /' 4. Wavelength bands (ibnd)',
     $         t48,i6,' words ',i6,' words (',i3,'%)'
     $ /' 5. Restart surface block size (iblk)',
     $         t48,i6,' words ',i6,' words (',i3,'%)'
     $ /' 6. Restart blocks (itblk)',
     $         t48,i6,' words ',i6,' words (',i3,'%)'
     $ /' 7. Index digits for filename (iimag)',
     $         t48,i6,' words ',i6,' words (',i3,'%)'
     $ /' 8. Grid divisions per axis (incg)',
     $         t48,i6,' words ',i6,' words (',i3,'%)')
      end
c
c**********************************************************************
c
      subroutine nodin3
c
c***********************************************************************
c     subroutine to input nodal data                                   
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     ilerrn is the number of type of errors the node input routine keeps 
c     count for the error report below
c
      parameter (ilerrn = 4)
c
c     idumlin tell which node was read in on each node input line
c     idumnod tells the node input line the node was entered on, 
c         if 0, node was not entered
c     lerrn tells if errors of type 1 to 4 have occurred on each line of node 
c        input if 0, the error has not occurred. If positive it tells the 
c        some sort of error information.  To understand the error, see the 
c        format statements for the error messages below. 
c     nlerrn is a counter of how many errors of type x there are
c
      dimension idumlin(inod), idumnod(inod), lerrn(inod, ilerrn)
      dimension nlerrn(ilerrn)
c
      write (6,1000)
      call header
c
c     0 node tracking array and other counters
c
      do 50 nn = 1,numnp
         idumnod(nn) = 0
         idumlin(nn) = 0
         do 45 ii = 1, ilerrn
            lerrn(nn,ii) = 0
 45      continue
 50   continue
c
      do 55 ii = 1, ilerrn
         nlerrn(ii) = 0
 55   continue
c
c     ie1inc is a flag that is set to one if inc > 0 on the first line of node
c       input which is an error
c     inodes counts how many nodes have been entered
c     istop is set to 1 if there is an error and the code needs to exit at 
c        the end of the subroutine
c     nline counts which line of node input the code is currently on
c
      ie1inc = 0
      inodes = 0
      istop = 0
      nline = 0
c
c     read nodal data input from input file and generate any missing data
c
  100 read (1, 1001, iostat = ireaderr) nn, inc, xnew, ynew, znew
c
      nline = nline + 1
c
c     can not read the last line, terminate program and print errors
c
      if (ireaderr.ne.0) then
         istop = 1
         goto 550
      end if
c
      inodes = inodes + 1
      idumlin(nline) = nn
c
c     check for good node number
c
      if (nn.lt.1.or.nn.gt.numnp) then
c
c     stop here for this node to prevent potential array bounds problems
c     if 0 entered as node number, store 1 in lerrn since 0 means no error
c
         istop = 1
         if (nn.eq.0) then
            lerrn(nline, 1) = 1
         else     
            lerrn(nline, 1) = nn
         end if
         nlerrn(1) = nlerrn(1) + 1
      else 
         if (idumnod(nn).gt.0) then 
c
c     duplicate of a node already done
c
            istop = 1
            lerrn(nline, 2) = nn
            nlerrn(2) = nlerrn(2) + 1
         else
            idumnod(nn) = nline
         end if
c
c     scale and shift the node
c
         pntnd(1,nn) = xscale*xnew + xshift
         pntnd(2,nn) = yscale*ynew + yshift
         pntnd(3,nn) = zscale*znew + zshift
c
         if ((inc.ge.1) .and. (inodes.le.1)) then
c
c     can't generate data from 1st line
c
            ie1inc = 1
            istop = 1   
         else if ((inc.ge.1) .and. (inodes.gt.1)) then
c
c     generate any missing data
c
            nmiss = (nn - nnold)/inc - 1
         if ((nmiss.le.0) .or. ((nmiss + 1)*inc.ne.(nn - nnold))) then
c
c     bad generation information
c
               istop = 1
               lerrn (nline,3) = nn  
               nlerrn(3) = nlerrn(3) + 1
            else
               delx = (xnew - xold)/real(nmiss + 1)
               dely = (ynew - yold)/real(nmiss + 1)
               delz = (znew - zold)/real(nmiss + 1)
c 
               do 300 i = 1,nmiss
                  k = nnold + i*inc
c
                  if (idumnod(k).gt.0) then 
                     write (10,3013) k, idumnod(k), nline
c
c    duplicate node numbers
c    keep count of how many errors generated on this line (not currently used)
c    error count itself (nlerrs) is only incremented by 1
c
                     lerrn(nline,4) = lerrn(nline,4) + 1
                     if (lerrn(nline,4).eq.1) then
                        istop = 1  
                        nlerrn(4) = nlerrn(4) + 1
                     end if 
                  else
                     idumnod(k) = nline
                  end if
c
                  pntnd(1,k) = xold + real(i)*delx
                  pntnd(1,k) = xscale*pntnd(1,k) + xshift
                  pntnd(2,k) = yold+real(i)*dely
                  pntnd(2,k) = yscale*pntnd(2,k) + yshift
                  pntnd(3,k) = zold+real(i)*delz
                  pntnd(3,k) = zscale*pntnd(3,k) + zshift
c
                  inodes = inodes + 1
 300          continue
            end if
         end if
      end if
c
c    store value from node if needed for incrementing to next node
c
      nnold = nn
      xold = xnew
      yold = ynew
      zold = znew
c
c     if any nodes left to read, repeat the loop
c
      if (inodes.lt.numnp) then 
         goto 100
      end if 
c
c     check node tracking array to find which nodes are missing
c
      nmisserr = 0
      do 500 nn = 1,numnp
         if (idumnod(nn).eq.0) then
            nmisserr = nmisserr + 1
            istop = 1
         end if
  500 continue
c
c     write nodal information, read error starts here (line 550)
c
 550  write (10,2000)
      do 600 k = 1,numnp
         write (10,2001) k,pntnd(1,k),pntnd(2,k),pntnd(3,k)
  600 continue 
c
c     see format statements for a description of errors
c
      if (ireaderr.ne.0) then
         write (10, 3021) nline
      end if
c
      if (nlerrn(1).gt.0) then
         write (10, 3001) numnp, nlerrn(1)
         do 710 ll = 1, numnp
            if (lerrn(ll,1).ne.0) then
               if (lerrn(ll,1).eq.1) then
                  lerr = 0
               else 
                  lerr = lerrn(ll,1)
               end if
               write (10,3000) ll, lerr
            end if
 710     continue
         write (10,*) ' '
      end if
c
      if (nlerrn(2).gt.0) then
         write (10, 3002) nlerrn(2)
         do 720 ll = 1, numnp
            if (lerrn(ll,2).gt.0) then
               write (10,3000) lerrn(ll,2), idumnod(lerrn(ll,2)), ll
            end if
 720     continue
         write (10,*) ' '
      end if 
c
      if (nlerrn(4).gt.0) then
         write (10, 3004) nlerrn(4)
         do 730 ll = 1, numnp
            if (lerrn(ll,4).gt.0) then
               write (10,3000) ll, idumlin(ll) 
            end if
 730     continue
         write (10,*) ' '
      end if
c
      if (nlerrn(3).gt.0) then
         write (10, 3003) nlerrn(3)
         do 740 ll = 1, numnp
            if (lerrn(ll,3).gt.0) then
               write (10,3000) ll, lerrn(ll,3)
            end if
 740     continue
         write (10,*) ' '
      end if
c
c     only write out missing nodes if we have not stopped because of a read error
c
      if ((nmisserr.gt.0) .and. (ireaderr.eq.0))then
         write (10, 3022) nmisserr
         do 750 ll = 1, numnp
            if (idumnod(ll).eq.0) then
               write (10,3000) ll
            end if
 750     continue
         write (10,*) ' '
      end if
c
      if (ie1inc.eq.1) then
         write (10, 3023)
      end if
c
      if (istop.ne.0) then
         write (10,3031)
         write ( 6,3032)
         call adios (2, 0, 0)
      end if
c
      return
c
 1000 format (1x,'in nodin3')
 1001 format (2i5,3e20.0)
c
 2000 format (////
     $ 7x,'n o d a l   i n f o r m a t i o n'//
     $ / 8x,'node no.',10x,'x',14x,'y',14x,'z'//)
 2001 format (9x,i5,'.',3(5x,e12.4))
c
c  summary error messages to output file for errors in lerrn array
c  an error of type x uses the format statement 3000 + x
c  format statement 3000 is used when  listing any type of node error
c
 3000 format (12x, 4(10x,i5))
 3001 format (
     $ / 10x, 'ERROR from nodin3: bad node number(s) input'
     $ / 12x, 'Valid node nos. are between 1 and numnp ( = ', i5, ') ',
     $        'inclusive.'
     $ / 12x, 'Invalid node nos. have been entered for the ', i5
     $ / 12x, 'node input lines listed below: '
     $ // 12x, 'node input line', 7x,'node no.'/ )
 3002 format (
     $ / 10x, 'ERROR from nodin3: duplicate node(s) input'
     $ / 12x,'Previously specified nodes have been re-entered for the',
     $        i5
     $ / 12x, 'node input lines listed below: '
     $ // 12x, 7x, 'node no.', 2x, 'first entered', 5x, 're-entered'/)
 3003 format (
     $ /10x,'ERROR from nodin3: bad node increment(s) for generation ',
     $      'of data',
     $ / 12x, 'Bad node increment data are given for the ', i5 
     $ / 12x, 'node input lines listed below: ' 
     $ // 12x, 'node input line', 7x,'node no.'/ )
 3004 format (
     $ / 10x, 'ERROR from nodin3: duplicate node(s) generated'
     $ / 12x, 'Previously specified nodes have been re-generated for ',
     $        'the ', i5
     $ / 12x, 'node input lines listed below. '
     $ / 12x, '"generating node no." is the generating node no. that' 
     $ / 12x, 'causes the problem.'
     $ / 12x, 'More detail can be found in the error messages above.'
     $ // 12x, 'node input line', 2x, 'generating node no.'/)
c
c     formats used to give messages for lerrn during input reading
c     only used for errors in generated quantities 
c     for error of type x, format 3010 + x is used
c
 3013 format (
     $ / 10x, 'ERROR from nodin3: duplicate node generated'
     $ / 12x, 'node - ',i5, ', first entered/generated on node input ',
     $        'line ', i5, 
     $ / 12x, ' is generated a second time on node input line - ', i5/)
c
c    other type of errors for which the lerrn array is not used
c
 3021 format (
     $ / 10x, 'ERROR from nodin3: read error during input',
     $ / 12x, 'MONT3D encountered an error attempting to read '
     $ / 12x, 'node input line', i5, '.'
     $ / 12x, 'Input file processing terminated on that line.' /)
 3022 format (
     $ / 10x, 'ERROR from nodin3: node number(s) missing'
     $ / 12x, 'Nodal information is missing for the following', i5
     $ / 12x, 'nodes:',
     $ // 12x, 7x,  'node no.' /)
 3023 format (
     $     / 10x, 'ERROR from nodin3: invalid use of INC'
     $ / 12x, 'INC must be 0 on the first node input line. '/)
c
 3031 format (//10x,'ERROR termination from nodin3.'//)
 3032 format (//10x,'ERROR termination from nodin3.',
     $ / 12x, 'See output file for details.'//)
c
      end
c
c***********************************************************************
c
      subroutine surfin3(imerr)
c
c***********************************************************************
c     subroutine to input surface data  
c     imerr set to  1 if there is an array allocation problem
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     idumlin tell which surface was read in on each surface input line
c     idumsrf tells the surface input line the surface was entered on, 
c         if 0, surface was not entered
c     itri is 1 if the surface is a triangle, 0 if it is not
c     lerrs tells if errors (or warnings) of type x have occurred on 
c        each line of surface input. If 0, the error has not occurred. If 
c        positive, it gives some error information. To understand the 
c        errors, see the error messages below.  There are two different
c        sets of errors that lerrs is used to keep track of input and
c        preprocessing errors. The lerrs is reused for the preprocessing
c        errors. 
c     nlerrs is a counter of how many errors of type x there are
c     ilerrs is defined in mont3d.par
c
c     pda is the percent difference in the area of a surface depending
c        on how it is calculated (used in convexity test)
c     testco is the test condition for non-planarity
c
      dimension idumlin(inod), idumsrf(isrf), itri(isrfs)  
      dimension lerrs(isrf, ilerrs), nlerrs(ilerrs)
      dimension pda(isrf), testco(isrf)
c
      write (6,1000)
      call header
c
c     0 surface tracking array and other counters
c
      do 50 ns = 1,nsurf
         idumsrf(ns) = 0
         idumlin(ns) = 0
         do 45 ii = 1, ilerrs
            lerrs(ns,ii) = 0
 45      continue
 50   continue
c
      do 55 ii = 1, ilerrs
         nlerrs(ii) = 0
 55   continue
c
c     iensurf is a flag that is set to one when more than nsurf surfaces have 
c        been entered
c     isurfs counts how many surfaces have been entered
c     istop is set to 1 if there is an error and the code needs to exit at 
c        the end of the subroutine
c     nline counts which line of surface input the code is currently on
c
      iensurf = 0
      istop = 0
      isurfs = 0
      nline = 0
c
c     read surface data input from input file and generate any missing data
c     lerrs keeps track of input errors here. Error format statements are 
c     form 30xx, see below.
c
  100 read (1, 1001, iostat = ireaderr) ns, n1, n2, n3, n4, nmiss, inc, 
     $                                  mn, npht, incp, ermax
c
      nline = nline + 1
c
c     can not read the last line, terminate program and print errors
c
      if (ireaderr.ne.0) then
         istop = 1
         goto 380
      end if
c
      isurfs = isurfs + 1
      idumlin(nline) = ns
c
c     error check for the surface
c
      if (n1.gt.numnp .or. n2.gt.numnp .or. n3.gt.numnp .or. 
     $    n4.gt.numnp .or. n1.le.0 .or. n2.le.0 .or. n3.le.0 .or. 
     $    n4.le.0) then
         lerrs(nline, 1) = ns
         nlerrs(1) = nlerrs(1) + 1
         istop = 1
      end if
c
      if (mn.gt.nummat.or.mn.le.0) then
         lerrs(nline, 2) = ns
         nlerrs(2) = nlerrs(2) + 1
         istop = 1
      end if
c
      if ((ns.gt.nsurf) .or. (ns.le.0)) then 
c
c     stop here for this surface to prevent array bounds problems
c     if 0 entered as surface number, store 1 in lerrs since 0 means no error
c
         if (ns.eq.0) then
            lerrs(nline, 3) = 1
         else     
            lerrs(nline, 3) = ns
         end if
         nlerrs(3) = nlerrs(3) + 1
         istop = 1
      else
         if (idumsrf(ns).ne.0) then 
c
c     surface already been entered before
c
            lerrs(nline, 4) = ns
            nlerrs(4) = nlerrs(4) + 1
            istop = 1
         else
            idumsrf(ns) = nline
         end if
c
c     define the surface and its properties
c
         nodes(1,ns) = n1
         nodes(2,ns) = n2
         nodes(3,ns) = n3
         nodes(4,ns) = n4
c
         matnum(ns) = mn
         if (npht.eq.0) then 
            npht = nphton
         end if 
         do 211 ib = 1,nbands
            nphtn(ns,ib) = npht
  211    continue
         if (ermax.le.0.) then
            ermax = errdef
         end if 
         errmax(ns) = ermax
c
         if (nmiss.ge.1) then
c
c     generate any missing data
c
            do 300 i = 1,nmiss
               k = ns + i
               if (k.gt.nsurf) then 
                     write (10, 3025) nsurf, nline, k
c
c    stop processing this surface here to avoid array bounds problems
c    keep count of how many errors generated on this line (not currently used)
c    error count itself (nlerrs) is only incremented by 1
c
                     lerrs (nline,5) = lerrs(nline,5) + 1
                     if (lerrs(nline,5).eq.1) then
                        istop = 1  
                        nlerrs(5) = nlerrs(5) + 1
                     end if  
               else
                  if (idumsrf(k).gt.0) then
                     write (10, 3026) k, idumsrf(k), nline
c
c    surface generated before
c    keep count of how many errors generated on this line (not currently used)
c    error count itself (nlerrs) is only incremented by 1
c
                     lerrs (nline,6) = lerrs(nline,6) + 1
                     if (lerrs(nline,6).eq.1) then
                        istop = 1  
                        nlerrs(6) = nlerrs(6) + 1
                     end if  
                  else
                     idumsrf(k) = nline
                  end if
c
                  nodes(1,k) = n1 + i*inc
                  nodes(2,k) = n2 + i*inc
                  nodes(3,k) = n3 + i*inc
                  nodes(4,k) = n4 + i*inc
                  matnum(k) = mn
                  do 311 ib = 1, nbands
                     nphtn(k,ib) = npht + i*incp
 311              continue
                  errmax(k) = ermax
c
                  isurfs = isurfs + 1
c
                  if ((nodes(1,k).gt.numnp) .or. (nodes(2,k).gt.numnp) 
     $  .or. (nodes(3,k).gt.numnp) .or. (nodes(4,k).gt.numnp) .or. 
     $  (nodes(1,k).le.0) .or. (nodes(2,k).le.0) .or. (nodes(3,k).le.0)
     $  .or. (nodes(4,k).le.0)) then
                     write (10,3027) numnp, nline, 
     $                              (nodes(ii,k), ii = 1,4), k 
c
c    generating invalid node numbers
c    keep count of how many errors generated on this line (not currently used)
c    error count itself (nlerrs) is only incremented by 1
c
                     lerrs (nline,7) = lerrs(nline,7) + 1
                     if (lerrs(nline,7).eq.1) then
                        istop = 1  
                        nlerrs(7) = nlerrs(7) + 1
                     end if  
                  end if
               end if
  300       continue
         end if
      end if
c
      if (isurfs.lt.nsurf) then
c
c    if any surfaces remain, repeat the input loop
c
         goto 100
      else if (isurfs.gt.nsurf) then 
         iensurf = 1
         istop = 1
      end if 
c
c     check that all surface numbers have been specified
c
      nmisserr = 0
      do 320 ns = 1,nsurf
         if (idumsrf(ns).eq.0) then
            nmisserr = nmisserr + 1
            istop = 1
         end if
  320 continue
c
c     if one or more errors, print them and exit
c     code goes here if there is a read error (statement 380)
c
 380  if (istop.ne.0) then
c
c     write an abbreviated from of the surface information
c
         write (10,2000)
         write (10,2101)
         do 400 ns = 1, nsurf
            write (10,2102) ns,(nodes(ii,ns),ii=1,4),matnum(ns),
     $              nphtn(ns,1), errmax(ns) 
 400     continue
c
c     for a description of the errors, see the format statements below
c
         if (ireaderr.ne.0) then
            write (10, 3101) nline
         end if
c
         write (10,3102)
c
         if (nlerrs(2).gt.0) then
            write (10, 3002) nummat, nlerrs(2)
            do 410 ll = 1, nsurf
               if (lerrs(ll,2).gt.0) then
                  write (10,3012) lerrs(ll,2), ll, matnum(lerrs(ll,2))
               end if
 410        continue
            write (10,*) ' '
         end if
c
         if (nlerrs(1).gt.0) then
            write (10, 3001) numnp, nlerrs(1)
            do 420 ll = 1, nsurf
               if (lerrs(ll,1).gt.0) then
                  nerr = lerrs(ll,1)
                  write (10,3011) nerr, ll, (nodes(ii,nerr), ii = 1,4)
               end if
 420        continue
            write (10,*) ' '
         end if
c
         if (nlerrs(3).gt.0) then
            write (10, 3003) nsurf, nlerrs(3)
            do 430 ll = 1, nsurf
               if (lerrs(ll,3).ne.0) then
                  if (lerrs(ll,3).eq.1) then
                     lerr = 0
                  else 
                     lerr = lerrs(ll,3)
                  end if
                  write (10,3013) ll, lerr
               end if
 430        continue
            write (10,*) ' '
         end if
c
         if (nlerrs(4).gt.0) then
            write (10, 3004) nlerrs(4)
            do 440 ll = 1, nsurf
               if (lerrs(ll,4).gt.0) then
                  write (10,3014) lerrs(ll,4), idumsrf(lerrs(ll,4)), ll
               end if
 440        continue
            write (10,*) ' '
         end if
c
         if (nlerrs(7).gt.0) then
            write (10, 3007) numnp, nlerrs(7)
            do 450 ll = 1, nsurf
               if (lerrs(ll,7).gt.0) then
                  write (10,3017) ll, idumlin(ll)
               end if
 450        continue
            write (10,*) ' '
         end if
c
         if (nlerrs(5).gt.0) then
            write (10, 3005) nsurf, nlerrs(5)
            do 460 ll = 1, nsurf
               if (lerrs(ll,5).gt.0) then
                  write (10,3015) ll, idumlin(ll)
               end if
 460        continue
            write (10,*) ' '
         end if
c
         if (nlerrs(6).gt.0) then
            write (10, 3006) nlerrs(6)
            do 470 ll = 1, nsurf
               if (lerrs(ll,6).gt.0) then
                  write (10,3016) ll, idumlin(ll)
               end if
 470        continue
            write (10,*) ' '
         end if
c
c        only list missing surfaces if we have not encountered a read error
c
         if ((nmisserr.gt.0) .and. (ireaderr.eq.0)) then
            write (10, 3103) nmisserr
            do 480 ll = 1, nsurf
               if (idumsrf(ll).eq.0) then
                  write (10,3104) ll
               end if
 480        continue
            write (10,*) ' '
         end if
c
         if (iensurf.eq.1) then
            write (10, 3105) isurfs, nsurf
         end if
c
         write (10,3201)
         write ( 6,3202)
         call adios (2, 0, 0)
      end if
c
c     clear and initialize array for split surface storage
c     note that the nlerrs and lerrs arrays have not been used up this  
c     point or istop would = 1 and the code would have exited
c     therefore, we re-use them
c     preprocessing errors use 33xx format statements
c
      do 510 ns = 1, nsurf
         isplit(ns) = 0
 510  continue
      iflags = 0
      nsptr = nsurf
c
c    preprocess the surfaces
c
      do 600 norig = 1, nsurf
         ns = norig
         k1 = nodes(1,ns)
         k2 = nodes(2,ns)
         k3 = nodes(3,ns)
         k4 = nodes(4,ns)
c
         call surfinfo (ns, k1, k2, k3, k4, lerrs, nlerrs, testco, pda, 
     $                  itri, iflags, istop, a134)
c
c        iflags = 1 for the first half of a split surface (set in surfinfo)
c        iflags = 2 for the second half of a split surface (set below)
c        otherwise iflags = 0
c
         if (iflags.eq.1) then
c
c        split triangle
c
            nsptr = nsptr + 1
            if (nsptr .gt. isrfs) then
c
c    store nothing else if we have run out of storage space
c
               imerr = 1
            else
c
c    define the two split triangles
c
               iflags = 2
               ns = nsptr
               isplit(norig) = nsptr
c
c     make original surface a triangle
c
               nodes(4,norig) = k3
c
c     generate new surface at nsptr
c
               k2 = k3
               k3 = k4
               nodes(1,nsptr) = k1
               nodes(2,nsptr) = k2
               nodes(3,nsptr) = k3
               nodes(4,nsptr) = k4
c
c     define surface properties
c
               matnum(nsptr) = matnum(norig)
c         
               afrac = 1. - 0.999999*(a134/area(norig))
               if (nphtn(norig,1).le.0) then
                  nphtn(norig, 1) = 0
                  nphtn(nsptr, 1) = 0
               else
                  nptemp = nphtn(norig,1)
                  nphtn(norig, 1) = int(afrac*real(nptemp))
                  nphtn(nsptr, 1) = nptemp - nphtn(norig,1)
c
c     can't have 0 photons per subsurface for an emitting surface
c
                  if ((nphtn(norig, 1).le.0) .or.
     $               (nphtn(nsptr, 1).le.0)) then
                     lerrs(norig, 5) = ns
                     nlerrs(5) = nlerrs(5) + 1
                     istop = 1
                  end if
               end if 
c
               do 520 ib = 2, nbands
                  nphtn(norig, ib) = nphtn(norig,1)
                  nphtn(nsptr, ib) = nphtn(nsptr,1)                 
 520           continue
c
c     check second split surface (triangle) and create needed variables
c
               call surfinfo (ns, k1, k2, k3, k4, lerrs, nlerrs, testco,
     $                        pda, itri, iflags, istop, a134)
            end if 
c
c     reset iflags 
c
            iflags = 0
         end if
  600 continue
c
c     print surface info
c
      write (10,2000)
      write (10, 2200)
      do 700 ns = 1, nsurf
         if (itri(ns).eq.1) then
c
c    triangle
c
            write (10,2201) ns,(nodes(ii,ns),ii=1,4),matnum(ns),
     $                      nphtn(ns,1), area(ns), errmax(ns)   
         else if (isplit(ns).eq.0) then
c
c    unsplit surface
c
            write (10,2202) ns,(nodes(ii,ns),ii=1,4),matnum(ns),
     $                      nphtn(ns,1), area(ns),testco(ns),errmax(ns)  
         else
c  
c    split surface
c
            nss = isplit(ns)
            write (10,2202) ns,(nodes(ii,ns),ii=1,4),matnum(ns),
     $                      nphtn(ns,1), area(ns) - area(nss),
     $                      testco(ns),errmax(ns)
c
c     second half of a split surface
c 
            write (10,2203) nss,(nodes(ii,nss),ii=1,4),matnum(nss),
     $                         nphtn(nss,1), area(nss)            
         end if
 700  continue
c
c     print split surface information
c
      nw = nsptr - nsurf
      write (10,2204) nsurf,nw,nsptr
      if (nw.ne.0) then
         write (6,2204) nsurf,nw,nsptr
      end if    
c
      if (istop.ne.0) then
c
c     errors occurred, see format statments for information
c
         if (nlerrs(1).gt.0) then
            write (10, 3301) nlerrs(1)
            do 710 ll = 1, nsurf
               if (lerrs(ll,1).gt.0) then
                  write (10,3300) ll
               end if
 710        continue
            write (10,*) ' '
         end if
c
         if (nlerrs(2).gt.0) then
            write (10, 3302) nlerrs(2)
            do 720 ll = 1, nsurf
               if (lerrs(ll,2).gt.0) then
                  write (10,3300) ll, testco(ll)
               end if
 720        continue
            write (10,*) ' '
         end if
c
         if (nlerrs(4).gt.0) then
            write (10, 3304) nlerrs(4)
            do 730 ll = 1, nsurf
               if (lerrs(ll,4).gt.0) then
                  write (10,3300) ll, testco(ll), pda(ll)
               end if
 730        continue
            write (10,*) ' '
         end if
c
         if (nlerrs(5).gt.0) then
            write (10, 3305) nlerrs(5)
            do 740 ll = 1, nsurf
               if (lerrs(ll,5).gt.0) then
                  write (10,3300) ll
               end if
 740        continue
            write (10,*) ' '
         end if
      end if
c
      if (nlerrs(3).gt.0) then
         write (10, 3303) nlerrs(3)
         do 750 ll = 1, nsurf
            if (lerrs(ll,3).gt.0) then
               write (10,3300) ll, testco(ll), pda(ll)
            end if
 750     continue
         write (10,*) ' '
         write (6,3313) 
      end if
c
c     no matter how terminate, print error message
c         
      if (istop.eq.1) then
         write (10,3201)
         write (6,3202)
      end if
c
      if (imerr.eq.1) then
c
c     ran out of memory to allocate split surfaces
c     return so error message can be printed
c
         return
      end if
c
c     terminate because of errors
c
      if (istop.ne.0) then
         call adios (2, 0, 0)
      end if    
c
c     calculate bounding nodal coordinates 
c     this loops over all surfaces, split and unsplit better than looping 
c     over all nodes because all nodes may not be used
c
      cminge(1) = 1.e30
      cminge(2) = cminge(1)
      cminge(3) = cminge(1)
      cmaxge(1) = -cminge(1)
      cmaxge(2) = cmaxge(1)
      cmaxge(3) = cmaxge(1)
c
      do 900 ns = 1,nsptr
         xmins(ns) = 1.e30
         ymins(ns) = xmins(ns)
         zmins(ns) = xmins(ns)
         xmaxs(ns) = -xmins(ns)
         ymaxs(ns) = xmaxs(ns)
         zmaxs(ns) = xmaxs(ns)
c
         do 880 i = 1,4
            nn = nodes(i,ns)
c
            xmins(ns) = min(xmins(ns),pntnd(1, nn))
            ymins(ns) = min(ymins(ns),pntnd(2, nn))
            zmins(ns) = min(zmins(ns),pntnd(3, nn))
            xmaxs(ns) = max(xmaxs(ns),pntnd(1, nn))
            ymaxs(ns) = max(ymaxs(ns),pntnd(2, nn))
            zmaxs(ns) = max(zmaxs(ns),pntnd(3, nn))
  880    continue
c
         cminge(1) = min(cminge(1),xmins(ns))
         cminge(2) = min(cminge(2),ymins(ns))
         cminge(3) = min(cminge(3),zmins(ns))
         cmaxge(1) = max(cmaxge(1),xmaxs(ns))
         cmaxge(2) = max(cmaxge(2),ymaxs(ns))
         cmaxge(3) = max(cmaxge(3),zmaxs(ns))
  900 continue
c
      do 910 i = 1, 3
         dcmaxge(i) = cmaxge(i) - cminge(i)
  910 continue
c
      dmaxge = sqrt(dcmaxge(1)**2 + dcmaxge(2)**2 + dcmaxge(3)**2)
c
      write (10,2301) cminge,cmaxge,dcmaxge
c
      return
c
 1000 format (1x,'in surfin3')
 1001 format (5i5,5x,2i5,5x,i5,10x,2i5,e10.0)
c
 2000 format (///// 27x,'s u r f a c e    d a t a')
c
c     statements written if error in first part of surfin3
c
 2101 format (
     $ // ' surface  n1    n2    n3    n4   mat  photons',
     $   '      errmax'//)
 2102 format (7(1x,i5),3x,e12.5)
c
c    statements written at the end of surfin3, whether there
c    are errors in part 2 or not
c
 2200 format (
     $ // 10x, 'Surfaces input as triangles are marked with a "#."',
     $ / 10x, 'Surfaces marked with a "*" are the second halves of ',
     $ / 10x, 'non-planar surfaces that have been split in two ',
     $        'triangles.'
     $ / 10x, 'The first part of the split surface is listed directly', 
     $ / 10x, 'above the second part. ',
     $ / 10x,'Quadrilateral surfaces with TESTCO greater than or equal',
     $ / 10x, 'to SPLITOL are split.'
     $ / 10x,'TESTCO is 1 minus the dot product of the surface normals',
     $ / 10x, 'of the two triangles into which a surface may be split.',
     $ / 10x, 'The larger the value of TESTCO (range 0 to 2),',
     $ / 10x, 'the greater the chance the split surface approximation ',
     $ / 10x, 'is poor.',
     $ // ' surface  n1    n2    n3    n4   mat  photons',
     $   '     area      TESTCO      errmax'/)
 2201 format ('#',i5, 6(1x,i5), e12.5, 12x, e12.5)
 2202 format (7(1x,i5),3e12.5)
 2203 format ('*',i5,6(1x,i5),3e12.5)
 2204 format (//10x,'split surfaces information '/
     $ / 5x,'original number of surfaces       = ',i5
     $ / 5x,'number of split surfaces          = ',i5
     $ / 5x,'number of total surfaces now      = ',i5//)  
c
 2301 format (/5x,'coordinate bounding values follow'
     $ / 2x,'xmin             =',e14.7
     $ / 2x,'ymin             =',e14.7
     $ / 2x,'zmin             =',e14.7
     $ / 2x,'xmax             =',e14.7
     $ / 2x,'ymax             =',e14.7
     $ / 2x,'zmax             =',e14.7
     $ / 2x,'dxmax            =',e14.7
     $ / 2x,'dymax            =',e14.7
     $ / 2x,'dzmax            =',e14.7//)
c
c     error messages for first batch of errors from surfin3
c     for error type x, format 3000 + x is used
c
 3001 format(
     $ / 10x, 'ERROR from surfin3: bad node number(s) input'
     $ / 12x, 'Valid node nos. are between 1 and numnp ( = ', i5, ') ',
     $        'inclusive.'
     $ / 12x, 'Invalid node nos. have been entered for the ', i5
     $ / 12x, 'surface input lines listed below: '
     $ // 12x, 4x, 'surface no.', 2x, 'surface input line', 6x,'n1', 6x,
     $        'n2', 6x, 'n3', 6x, 'n4'/)
 3002 format(
     $ / 10x, 'ERROR from surfin3: bad material number(s) input'
     $ / 12x, 'Valid material nos. are between 1 and nummat ',
     $        '( = ', i5, ') inclusive.'
     $ / 12x, 'Invalid material nos. have been entered for the ', i5
     $ / 12x, 'surface input lines listed below: '
     $ // 12x, 4x, 'surface no.', 2x, 'surface input line', 3x,
     $             'material no.'/)
 3003 format(
     $ / 10x, 'ERROR from surfin3: bad surface number(s) input'
     $ / 12x,'Valid surface nos. are between 1 and nsurf ( = ', i5, ')',
     $        ' inclusive.'
     $ / 12x, 'Invalid surface nos. have been entered for the ', i5
     $ / 12x, 'surface input lines listed below: '
     $ // 12x, 'surface input line', 4x,'surface no.'/)
 3004 format(
     $ / 10x, 'ERROR from surfin3: duplicate surface(s) input'
     $ / 12x, 'Previously specified surfaces have been re-entered for ',
     $        'the ', i5
     $ / 12x, 'surface input lines listed below: '
     $ // 12x,4x, 'surface no.', 2x, 'first entered', 5x, 're-entered'/)
 3005 format(
     $ / 10x, 'ERROR from surfin3: bad surface number(s) generated'
     $ /12x, 'Valid surface nos. are between 1 and nsurf ( = ', i5, ')',
     $        ' inclusive.'
     $ / 12x, 'Invalid surface nos. have been generated for the ', i5 
     $ / 12x, 'surface input lines listed below. '
     $ / 12x, '"generating surface no." is the generating surface no. ',
     $ / 12x, 'that causes the problem.'
     $ / 12x, 'More detail can be found in the error messages above.'
     $ //12x,'surface input line', 2x, 'generating surface no.'/)
 3006 format(
     $ /10x,'ERROR from surfin3: duplicate surface(s) generated'
     $ / 12x,'Previously specified surfaces have been re-generated ',
     $        'for the ', i5 
     $ / 12x, 'surface input lines listed below. ',
     $ / 12x, '"generating surface no." is the generating surface no. ',
     $ / 12x, 'that causes the problem.'
     $ / 12x, 'More detail can be found in the error messages above.'
     $ // 12x, 'surface input line', 2x, 'generating surface no.', /)
 3007 format(
     $ / 10x, 'ERROR from surfin3: bad node number(s) generated'
     $ / 12x, 'Valid node nos. are between 1 and numnp ( = ', i5, ')',
     $        ' inclusive'
     $ / 12x, 'Invalid node nos. have been generated for the ', i5 
     $ / 12x, 'surface input lines listed below. '
     $ / 12x, '"generating surface no." is the generating surface no. ',
     $ / 12x, 'that causes the problem.'
     $ / 12x, 'More detail can be found in the error messages above.'
     $ //12x, 'surface input line', 2x, 'generating surface no.'/)
c
c     formats used for listing the first batch of errors from surfin3
c     for error type x, format 3010 + x is used
c
 3011 format (12x, 10x, i5, 15x, i5, 4(3x, i5))
 3012 format (12x, 10x, i5, 15x, i5, 10x, i5)
 3013 format (12x, 13x, i5, 10x, i5)
 3014 format (12x, 3(10x, i5))
 3015 format (12x, 13x, i5, 19x, i5)
 3016 format (12x, 13x, i5, 19x, i5)
 3017 format (12x, 13x, i5, 19x, i5) 
c
c     formats used to give errors during input reading
c     only used for errors in generated quantities 
c     for error of type x, format 3020 + x is used
c
 3025 format(
     $ /10x,'ERROR from surfin3: bad surface number generated'
     $ / 12x, 'Valid surface nos. are between 1 and nsurf ( = ', i5, 
     $        ') inclusive.'
     $ /12x, 'generating surface input line, surface no. - ', 2(i5,2x)/)
 3026 format(
     $ /10x,'ERROR from surfin3: duplicate surface generated'
     $ / 12x, 'surface - ',i5, ' first entered/generated on line ', i5, 
     $ / 12x, 'is generated a second time from surface input line - ', 
     $        i5 /)
 3027 format(
     $ / 10x, 'ERROR from surfin3: bad node number generated'
     $ / 12x, 'Valid node nos. are between 1 and numnp ( = ', i5, ')',
     $        ' inclusive.'
     $ / 12x,'generating surface input line - ', i5
     $ / 12x,'node1,node2,node3,node4, surface no. =',
     $ / 12x, 5(i5,2x)/)
c
c    other errors that can occur in the first part of surfin3
c
 3101 format (
     $ / 10x, 'ERROR from surfin3: read error during input',
     $ / 12x, 'MONT3D encountered an error attempting to read ',
     $ / 12x, 'surface input line', i5, '.'
     $ / 12x, 'Input file processing terminated on that line.' /)
 3102 format (
     $ / 10x, 'Note: if duplicate surfaces or out of bounds surface'
     $ / 12x, 'nos. are entered, then some values (nodes, ',
     $ / 12x, 'material no., etc.) in the error messages below may '
     $ / 12x, 'be incorrect.')   
 3103 format (
     $ / 10x, 'ERROR from surfin3: surface number(s) missing'
     $ / 12x, 'surface information is missing for the following ', i5
     $ / 12x, 'surfaces:'
     $ // 12x, 4x,  'surface no.' /)
 3104 format (12x, 10x, i5)
 3105 format ( 
     $ / 10x,'ERROR from surfin3: number of surfaces too large'
     $ / 12x,'Number of surfaces read in/generated = ',i5, '.'
     $ / 12x,'Only nsurf (= ', i5, ') surfaces should be created.'/)
c
c    termination messages
c
 3201 format (//10x,'ERROR termination from surfin3.'//)
 3202 format (//10x,'ERROR termination from surfin3.'
     $ / 12x, 'See output file for details.'//)
c
c     error messages for the second batch of errors from surfin3
c     for error type x, format 3300 + x is used
c
 3300 format (12x, 10x, i5, 2(3x,e12.5))
 3301 format(
     $ / 10x,'ERROR from surfin3: coincident points'
     $ / 12x, 'Coincident points have been found in the ', i5, 
     $ / 12x, 'surfaces listed below. '
     $ / 12x,'Note, for a triangle, nodes 3 and 4 should be coincident,'
     $ / 12x, 'which is not considered an error.'
     $ // 12x, 4x, 'surface no.'/)
 3302 format (
     $ / 10x, 'ERROR from surfin3: failed first convexity test'
     $ / 12x, 'The first convexity test was failed by the ', i5
     $ / 12x, 'surfaces listed below. '
     $ / 12x, 'To avoid this error, either try redefining the surface ',
     $        'nodes'  
     $ / 12x, 'or split the quadrilateral into two trianglar surfaces.'
     $ / 12x, 'TESTCO is defined at the top of the surface list above.'
     $ / 12x, 'See the MONT3D manual for more details.'
     $ // 12x, 4x, 'surface no.', 9x, 'TESTCO'/)
 3303 format (
     $ / 5x, 'warning from surfin3: potential non-coplanar surface ',
     $       'problems'
     $ / 7x, 'The second convexity test was failed by the ', i5,
     $ / 7x, 'non-planar surfaces listed below. '
     $ / 7x, 'The value "PDA" gives the percent difference in the area'
     $ / 7x, 'of the surface depending on how the surface is divided ',
     $ / 7x, 'into triangles.' 
     $ / 7x, 'TESTCO is defined at the top of the surface list above.'
     $ / 7x,'Since these surfaces are non-planar, they WILL be split.'
     $ / 7x, 'This can lead to overlapping triangles or other '
     $ / 7x, 'improperly defined surfaces.'
     $ / 7x, 'See the MONT3D manual for more details.'
     $ // 12x, 4x, 'surface no.',  9x, 'TESTCO', 12x, 'PDA'/ )
 3304 format (
     $ / 10x, 'ERROR from surfin3: failed second convexity test'
     $ / 12x, 'The second concavity test was failed by the ', i5,
     $ / 12x, 'planar surfaces listed below. '
     $ / 12x, 'The value "PDA" gives the percent difference in the area'
     $ / 12x, 'of the surface depending on how the surface is divided '
     $ / 12x, 'into triangles.' 
     $ / 12x, 'TESTCO is defined at the top of the surface list above.'
     $ / 12x, 'Since these surface(s) are planar, this means these ',
     $ / 12x, 'surface(s) are concave. ',
     $ / 12x, 'See the MONT3D manual for more details.'
     $ // 12x, 4x, 'surface no.', 9x, 'TESTCO', 12x, 'PDA'/ )
 3305 format (
     $ /10x, 'ERROR from surfin3: - no photons emitted from split ',
     $       'surface(s)',
     $ / 12x, 'One of the split surfaces from the ', i5, 
     $ / 12x, 'non-planar surfaces listed below emits no photons. ',
     $ / 12x, 'In other words, photons per subsurface area ("photons" ',
     $ / 12x, 'in surface list above) is 0 for a split surface. ',
     $ / 12x, 'To fix this problem, increase the number of photons per'
     $ / 12x, 'subsurface area until the "photons" listed in the '
     $ / 12x, 'surface table above is approximately proportional to ',
     $ / 12x, 'the "areas" listed in the table above. To prevent round '
     $ / 12x, 'off error, try to set "photons" to 100 or more for each '
     $ / 12x, 'surface.'
     $ / 12x, 'See the MONT3D manual for more details.'
     $ // 12x, 4x, 'surface no.'/ ) 
c
c    error messages to write to the screen for second batch of errors
c    for error type x, format = 3310 + x
c
 3313 format (
     $ // 5x, 'warning from surfin3: potential non-planar surface ',
     $       'problems'
     $ / 7x, 'See output file for details.'//)
c
      end
c
c***********************************************************************
c
      subroutine surfinfo (ns, k1, k2, k3, k4, lerrs, nlerrs, testco, 
     $                     pda, itri, iflags, istop, a134)
c
c***********************************************************************
c     subroutine to calculate the direction cosine array associated   
c     with each surface, the surface area, the equation of the plane  
c     containing the surface, and the equations of the surface        
c     boundaries.  
c     ns is the current surface under consideration (may be a split surface)
c     k1, k2, k3 and k4 are the node numbers for the surface
c     iflags is set to 1 in surfinfo if a surface is split 
c            = 2 if this is the second part of a split surface 
c            otherwise it is 0 
c     istop is set to 1 if an error occurs
c     a134 is the area of the triangle made with the 1, 3 and 4 nodes
c     other variables defined at the top of surfin3
c     note that the second half of a split surface is automatically considered
c        a triangle                        
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     small determines how small the distance between points should be 
c     before they are considered co-incident.  A setting of 1e-10 should 
c     ensure that they are considered coincident only if they differ by 
c     little more than computer round off.  All calculations for 
c     coincidence normalize the distances to a relative value, see below 
c
      parameter (small = 1.d-10) 
c
c     all these variables are described at the top of surfin3
c
      dimension itri(isrfs), lerrs(isrf, ilerrs), nlerrs(ilerrs)
      dimension pda(isrf), testco(isrf)
c
c     functions used by surfinfo
c
      det2(a1,a2,b1,b2) = a1*b2 - b1*a2
      det3(a1,a2,a3,b1,b2,b3,c1,c2,c3) = a1*(b2*c3 - c2*b3) -
     $      a2*(b1*c3 - c1*b3) + a3*(b1*c2 - c1*b2)
      size(a,b,c) = sqrt(a**2 + b**2 + c**2)
c
      x1 = pntnd(1, k1)
      y1 = pntnd(2, k1)
      z1 = pntnd(3, k1)
      x2 = pntnd(1, k2)
      y2 = pntnd(2, k2)
      z2 = pntnd(3, k2)
      x3 = pntnd(1, k3)
      y3 = pntnd(2, k3)
      z3 = pntnd(3, k3)
      x4 = pntnd(1, k4)
      y4 = pntnd(2, k4)
      z4 = pntnd(3, k4)
c
c     calculate distances between points
c
      sz12 = size(x1-x2,y1-y2,z1-z2)
      sz13 = size(x1-x3,y1-y3,z1-z3)
      sz14 = size(x1-x4,y1-y4,z1-z4)
      sz23 = size(x2-x3,y2-y3,z2-z3)
      sz24 = size(x2-x4,y2-y4,z2-z4)
      sz34 = size(x3-x4,y3-y4,z3-z4)
c
c     relative value used to determine if coincident
c
      relval = (sz12 + sz13 + sz14 + sz23 + sz24 + sz34)/6.  
c
c  itri = 1 if triangle, 0 if not; 
c  triangles have nodes 3 and 4 coincident
c
      if (sz34/relval.le.small) then 
         itri(ns) = 1
      else
         itri(ns) = 0
      end if
c
c   ***  check for other coincident points
c
      if ((sz12/relval.le.small) .or. (sz13/relval.le.small) .or.
     $    (sz14/relval.le.small) .or. (sz23/relval.le.small) .or.
     $    (sz24/relval.le.small)) then
         lerrs(ns, 1) = 1
         nlerrs(1) = nlerrs(1) + 1
         istop = 1
         return
      end if 
c
c   ***  calculate surface area
c
      st = (sz12+sz24+sz14)/2
      a124 = sqrt(st*(st - sz12)*(st - sz24)*(st - sz14))
      st = (sz23 + sz34 + sz24)/2
      a234 = sqrt(st*(st - sz23)*(st - sz34)*(st - sz24))
      st = (sz12 + sz13 + sz23)/2
      a123 = sqrt(st*(st - sz12)*(st - sz13)*(st - sz23))
      st = (sz13 + sz14 + sz34)/2
      a134 = sqrt(st*(st - sz13)*(st - sz14)*(st - sz34))
c
      area(ns) = a123 + a134
c
c   ***  calculate dir cosines of z-axis: surface normal
c   creation of v1 variable allows the program to compile on 
c   compilers that are stringent about the difference between
c   real*4 and real*8 arguments whether the code is single or 
c   double precision 
c
      v1 = 1.
      tmpx = det3(y1,z1,v1,y2,z2,v1,y3,z3,v1)
      tmpy = -det3(x1,z1,v1,x2,z2,v1,x3,z3,v1)
      tmpz = det3(x1,y1,v1,x2,y2,v1,x3,y3,v1)
      tmpdistp = det3(x1,y1,z1,x2,y2,z2,x3,y3,z3)
c
c   ***  normalize
c
      dee = size(tmpx,tmpy,tmpz)
      caz(ns) = tmpx/dee
      cbz(ns) = tmpy/dee
      cgz(ns) = tmpz/dee
      distp(ns) = tmpdistp/dee
c
c      coplanarity test
c        calc dir. cosines at 4
c
      if (itri(ns).eq.0) then
         ex34 = (x3-x4)/sz34
         ey34 = (y3-y4)/sz34
         ez34 = (z3-z4)/sz34
c
         ex14 = (x1-x4)/sz14
         ey14 = (y1-y4)/sz14
         ez14 = (z1-z4)/sz14
c
c        - calc. normal at 4 via cross product
c
         enx4 = ey14*ez34 - ez14*ey34
         eny4 = ez14*ex34 - ex14*ez34
         enz4 = ex14*ey34 - ey14*ex34
         sizen4 = size(enx4,eny4,enz4)
         enx4 = enx4/sizen4
         eny4 = eny4/sizen4
         enz4 = enz4/sizen4
c
         dotp = enx4*caz(ns) + eny4*cbz(ns) + enz4*cgz(ns)
         testco(ns) = abs(1. - dotp)
c         
c        SPLIT
c
         if (testco(ns) .gt. splitol) then
            iflags = 1
            x4 = x3
            y4 = y3
            z4 = z3
         end if
      end if
c
c     check for concave polygons, only for quadrilaterals 
c     and the first time through for a split surface
c
      if (itri(ns).eq.0) then
         if (((sz12 + sz34).gt.(sz24 + sz13)) .or.
     $      ((sz14 + sz23).gt.(sz24 + sz13))) then
c
c     these two concave tests are assumed to be valid for non-coplanar 
c     as well as coplanar surfaces, if this test fails, reject the surface
c
            lerrs(ns, 2) = 1
            nlerrs(2) = nlerrs(2) + 1
            istop = 1
            return
         end if
c
c     next test may fail because surface is non-coplanar even if surface is
c     "convex" 
c
         pda(ns) = 100.*abs(area(ns) - (a124 + a234))/area(ns)
         if (pda(ns).gt.pdamax) then
            if (iflags.eq.1) then 
               lerrs(ns, 3) = 1
               nlerrs(3) = nlerrs(3) + 1        
            else
c
c     coplanar surface, reject surface as concave
c
               lerrs(ns, 4) = 1
               nlerrs(4) = nlerrs(4) + 1
               istop = 1
               return
            end if
         end if
      end if
c
c   ***  calculate dir cosines for y-axis: line from node 1 to 2
c
      cay(ns) = (x2-x1)/sz12
      cby(ns) = (y2-y1)/sz12
      cgy(ns) = (z2-z1)/sz12
c
c   ***  calculate dir cosines for x-axis: y cross z
c
      cax(ns) = det2(cby(ns),cgy(ns),cbz(ns),cgz(ns))
      cbx(ns) = -det2(cay(ns),cgy(ns),caz(ns),cgz(ns))
      cgx(ns) = det2(cay(ns),cby(ns),caz(ns),cbz(ns))
c
c   ***  calculate bounding plane from 4 to 1
c
      a41(ns) = det2(cbz(ns),cgz(ns),(y1-y4),(z1-z4))
      b41(ns) = -det2(caz(ns),cgz(ns),(x1-x4),(z1-z4))
      c41(ns) = det2(caz(ns),cbz(ns),(x1-x4),(y1-y4))
      d41(ns) = x4*a41(ns) + y4*b41(ns) + z4*c41(ns)
c
c   ***  plane 12
c
      a12(ns) = det2(cbz(ns),cgz(ns),(y2-y1),(z2-z1))
      b12(ns) = -det2(caz(ns),cgz(ns),(x2-x1),(z2-z1))
      c12(ns) = det2(caz(ns),cbz(ns),(x2-x1),(y2-y1))
      d12(ns) = x1*a12(ns) + y1*b12(ns) + z1*c12(ns)
c
c   ***  plane23
c
      a23(ns) = det2(cbz(ns),cgz(ns),(y3-y2),(z3-z2))
      b23(ns) = -det2(caz(ns),cgz(ns),(x3-x2),(z3-z2))
      c23(ns) = det2(caz(ns),cbz(ns),(x3-x2),(y3-y2))
      d23(ns) = x2*a23(ns) + y2*b23(ns) + z2*c23(ns)
c
c   ***  plane 34 - clear array and skip if figure is a triangle or 
c        split surface
c
      if(itri(ns).eq.1 .or. iflags.eq.1) then
         a34(ns) = 0.
         b34(ns) = 0.
         c34(ns) = 0.
         d34(ns) = 0.
      else
         a34(ns) = det2(cbz(ns),cgz(ns),(y4-y3),(z4-z3))
         b34(ns) = -det2(caz(ns),cgz(ns),(x4-x3),(z4-z3))
         c34(ns) = det2(caz(ns),cbz(ns),(x4-x3),(y4-y3))
         d34(ns) = x3*a34(ns) + y3*b34(ns) + z3*c34(ns)
      end if
c 
      return
      end
c
c***********************************************************************
c
      subroutine wavin
c
c***********************************************************************
c     subroutine to input wavelength breakpoints                       
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'         
c
      istop = 0
c
      write (6,1000)
      call header
      write (10,2000)
c
      wavlth(0) = 0.
      wavlth(nbands) = 1.d10
      if (nbands.gt.1) then
         read (1,1001) (wavlth(i),i=1,(nbands-1))
      end if 
c
c     write wavelength breakpoints
c
      do 200 i = 0,nbands
         write (10,2001) i,wavlth(i)
 200  continue
c
      do 300 i = 1,nbands
        if (wavlth(i).le.0.) then
          write(10, 3001) i, wavlth(i)
          write (6, 3001) i, wavlth(i)
          istop = 1
        end if
  300 continue
c
      if (istop.eq.1) then
        call adios(2, 0, 0)
      end if
c
      return
c
 1000 format (1x,'in wavin')
 1001 format (8e10.0)
c
 2000 format (////
     $ 7x,'b a n d   w a v e l e n g t h   d a t a'////
     $ 2x,'breakpoint no.  wavelength'/
     $ 2x,'               (micrometers)'//)
 2001 format (5x,i5,'.',4x,e12.4)
c
 3001 format (///7x,'- - -  error termination  - - -'/
     $ / 5x,'negative or zero wavelength entered'/
     $ 'wavelength(',i2,') = ',e10.0)
c
      end
