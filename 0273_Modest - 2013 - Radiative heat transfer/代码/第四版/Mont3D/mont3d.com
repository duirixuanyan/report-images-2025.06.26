c     -*-Fortran-*-
c  NOTE: Statement above makes EMACS editor open this file in FORTRAN
c  mode  
c*********************************************************************     
c
c     mont3d.com
c
c*********************************************************************
c     circle - common for radian related variables
c*********************************************************************
c
      common /circle/ pi,pi2,p2i,rtod,dtor
c
c*********************************************************************
c     contro - common for input control variables
c*********************************************************************
c
c     most of these are defined in the input section, see input3
c     icrsh = 1 if restart from crash, 0 otherwise
c     ilbtest does load balancing if 1, undocumented feature (disabled)
c     imform is 0 if the old material model is used 1 if new
c     initialflag = 1 if this is an intial or crashed intial run
c     iout, stops output if 1, not working or documented (disabled)
c     iparflgold = whether the previous run was single processor or parallel
c     nbkfin is 1 for each finished block
c     neblock = default number of emitters per block (= abs(irstflg))
c     neleft = number of emitters in th last block
c     nemitcount = number of emitting (unsplit) surfaces per band
c     netot = the total number of emitters (nbands*nsurf)
c 
      common /contro/ delt, errdef, splitol, 
     $                xscale, yscale, zscale, xshift, yshift, zshift, 
     $                icrsh, idata, ilbtest, imform, initialflg, iout,
     $                iparflg, iparflgold, iparopt(5), iprnt(5), 
     $                irstflg, itim, itraces, mymid, nbands, 
     $                nbkfin(itblk), nblocks, ndivx, ndivy, ndtcv, 
     $                neblock, neleft, nemitcount(ibnd), netot, 
     $                nlogblk, nlost, nmacv, npemit, nphton, nploops, 
     $                nrefs, nshade, nsptr, nsurf, nummat, numnp,
     $                numref, nwarns, nwproc
c
c*********************************************************************
c     coords - common holding values related to max and min values for 
c     the geometry as a whole
c*********************************************************************
c
      common /coords/ cminge(3), cmaxge(3), dcmaxge(3),  dmaxge
c
c*********************************************************************
c     evars - common for variables used by the subroutine epoint
c     fdx and fdy are set in the subroutine solve3
c     the others are set in the subroutine eptinit
c*********************************************************************
c
      dimension h(4,3)
c
      common /evars/  fdx, fdy, h, photot
c
c*********************************************************************
c     file - commons used to handle files in MONT3D
c*********************************************************************
c
      character*(isln) suffix
      character*(iflni) aname
      character*(ilarg) basename
c
      common /filestat/ ifnflg(ifil), ifstat(ifil), iost(ifil),  
     $                  lenf(ifil), lenfbase
      common /names/ aname(ifil), basename, suffix(ifil)
c
c*********************************************************************
c     grid - common for grid variables 
c*********************************************************************
c
c     cg = the grid coordinates in the ith direction
c     factg = factor used to determine the grid index in the ith direction
c     icg = flag, gt 0 use uniform grid in ith direction else user defined 
c     iptgrid = pointer to each grids segments in iseg
c     ncgmax = the number of grid cells in the ith direction 
c     ngdel = the change in the other all grid number by moving + 1 in 
c             the ith direction
c     nsegsg = a list of all surface segments in all grids
c
      common /grid/ cg(incg + 1,3), cfactg(3), factg(3),  
     $              igc(3), iptgrd(igrd + 1), ncgmax(3), ngdel(3),  
     $              nsegsg(iseg)
c
c*********************************************************************
c     id - common for the character array with ID information
c*********************************************************************
c
      character*8 head
c
      common /id/ head(15)
c
c*********************************************************************
c     interc - common for variables used in the photon interception routines
c*********************************************************************
c
c     Note: several photons are emitted from the same emission point, 
c           hence the variables ending in old that store values at the 
c           emission point
c 
c     areaemit = area of the current emitting (split) surface
c     dgrid(i) = distance to next grid cell in ith direction
c     ezlint = the z local emission direction for the intersecting surface
c     fractid = the fractional part of the interception theta (degrees) 
c     pntert = point of emission or reflection or transmittance
c     pntemit = the current emission point
c     pntint = the intersection point
c     thetair = the incident theta in radians
c     vecte, vecteinv, the emission vector and its inverse
c     igdelta = +1 if going in +ith direction, -1 if -ith
c     ihist = counter for tracing
c     ilost = flag to determine if photon lost
c     ithid = the integer part of the incedeint theta (degrees)
c     iwarn = warning counter
c     lunsplit = the number of the current emitting surface (unsplit)
c     lemit = the number of the current emitting surface (split)
c     lert = the last surface to emit/reflect or transmit the photon
c     lint = the number of the surface that the photon intersects
c     ncg = the current x, y and z grid numbers
c     ncgemit = the x, y and z grid numbers at the current point of 
c              emission
c     nedo = number of emitters to do for this block
c     nelist = the emitters in this block
c     ngrid = the current grid number
c     ngridemit = the grid number at the current point of emission
c     npend = the number of photons to do per emission point per loop
c     npntsm1 = the number of emission points on a surface - 1
c
      common /interc/ areaemit, dgrid(3), ezlint, fractid, pntert(3), 
     $                pntemit(3),  pntint(3), thetair, vecte(3),
     $                vecteinv(3),
     $                igdelta(3), ihist, ilost, ithid, iwarn, 
     $                lunsplit, lemit, lert, lint, ncg(3), 
     $                ncgemit(3), nedo, nelist(iblk), ngrid, 
     $                ngridemit, npend, npntsm1
c
c*********************************************************************
c     mat - commons for the material properties 
c*********************************************************************
c
      character*(inmnl) matname
c
      common /mat/ alpha(0:90,imat,ibnd),dalpha(0:90,imat,ibnd),
     $             rhod(0:90,imat,ibnd),drhod(0:90,imat,ibnd),
     $             rhos(0:90,imat,ibnd),drhos(0:90,imat,ibnd),
     $             rhoss(0:90,imat,ibnd),drhoss(0:90,imat,ibnd), 
     $             taud(0:90,imat,ibnd),dtaud(0:90,imat,ibnd),
     $             taus(0:90,imat,ibnd),dtaus(0:90,imat,ibnd),
     $             tauss(0:90,imat,ibnd), 
     $             thprss(0:90,imat,ibnd),dthprss(0:90,imat,ibnd),
     $             thptss(0:90,imat,ibnd),dthptss(0:90,imat,ibnd),
     $             ebx(imat,ibnd), eby(imat,ibnd), ebz(imat,ibnd),
     $             costbeam(imat,ibnd),phiset(imat,ibnd),
     $             rfactrd(imat,ibnd), rfactrss(imat,ibnd),
     $             rfacttd(imat,ibnd), rfacttss(imat,ibnd),
     $             thetar(0:100,imat,ibnd),dth(0:100,imat,ibnd),
     $             embar(imat,ibnd),wavlth(0:ibnd), 
     $             ietp(imat,ibnd), nctrack(8,imat,ibnd), 
     $             noep(imat, ibnd)   
      common /matnam/ matname (4,imat, ibnd)   
c
c*********************************************************************
c     random - common for variables for the random number generator 
c*********************************************************************
c
c     real*8 rmult
      integer*4 iseed0, iseed, it1, it2, itaps, mask, maskc
c
      common /rancom/ rmult, iseed(lflen), iseed0, it1, it2
      common /bshift/ itaps(6), mask(0:31), maskc(0:31)       
c
c*********************************************************************
c     soltim - common for variables used for timing 
c*********************************************************************
c
      common /soltim/ cpuio(3), rnump, tp, lost
c
c***********************************************************************
c     surf - common for variables describing surfaces, nodes and 
c            photon counts 
c***********************************************************************
c
c     area = the area of the surface for a split surface, the first part 
c            holds the entire area and the second part hold the area of the
c            second peice of the surface
c     error, errmax, = the error and maximum error for each emitter
c     pntnd = the node points 
c     cij is a direction cosine, i = the global coordinates as alpha, 
c         beta and gamma, j = local coordinates as x, y and z
c     anm, bnm, cnm and dmn are the a, b, c and d values for the 
c         boundiong planes n and m are node numbers for the surface
c         bounding planes are 3D in the input phase and become 2D in 
c         subroutine bplane2d for use in the solve3 routine
c     isplit = other split surface if surface is split, 0 otherwise
c     ja, jb, jc defines a, b, c for 2D bounding equations in solve3
c     matnum = the material number for the surface
c     node = the nodes of a surface
c     npabs = the number of photons emitted by a surface in the block
c             (iblk) and absorbed by each surface (isrfs)
c     nphtn = the number of photons emitted per emission point
c     npwold = the number of photons emitted from a surface previously
c      
      common /surf/ area(isrfs), distp(isrfs),               
     $              errmax(isrf), error(isrf,ibnd), pntnd(3, inod),
     $              cax(isrfs), cbx(isrfs), cgx(isrfs),
     $              cay(isrfs), cby(isrfs), cgy(isrfs),
     $              caz(isrfs), cbz(isrfs), cgz(isrfs),
     $              a41(isrfs), b41(isrfs), c41(isrfs), d41(isrfs),
     $              a12(isrfs), b12(isrfs), c12(isrfs), d12(isrfs),
     $              a23(isrfs), b23(isrfs), c23(isrfs), d23(isrfs),
     $              a34(isrfs), b34(isrfs), c34(isrfs), d34(isrfs),
     $              xmins(isrfs), xmaxs(isrfs), 
     $              ymins(isrfs), ymaxs(isrfs),
     $              zmins(isrfs), zmaxs(isrfs),
     $              isplit(isrf), ja(isrfs), jb(isrfs), jc(isrfs), 
     $              matnum(isrfs), nbkpntr(itblk+1), 
     $              nbkemitlist(ibkel), nodes(4,isrfs), 
     $              npabs(isrfs,iblk), nphtn(isrfs,ibnd), 
     $              npwold(isrf,ibnd), neblocklist(itne), 
     $              neposlist(itne) 
c
