c*********************************************************************     
c
c     m313s.f
c
c***********************************************************************
c     This file contains the subroutines called by input3 from  
c     fileset on. These can be described as all the subroutines which 
c     mostly deal with postprocessing and grid input. They are: 
c     blkfile, blocks, bplane2d, fileset, graf, gridin, ibshift, order, 
c     raninit, ranset, and seging 
c***********************************************************************
c
      subroutine blkfile (iaction) 
c
c***********************************************************************
c     Subroutine to read (iaction = ifrd) or write out (iaction = ifwrt) 
c     the block file. 
c     note that all actions open and close the file 
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'        
c
      if (iaction.eq.ifrd) then
c
c     read the block file 
c
         open(14,file=aname(14),status='old',iostat = iost(14))
         if (iost(14).ne.0) then
            write(6,3101)
            write(10,3101)
            call adios(2,0, 0)
         end if   
         ifstat(14) = 1
c   
c        read header
c        value of initialflg is used, others used as checks
c
         read (14, 9001) nettmp, nbktmp, initialflg
         if ((nettmp.ne.netot) .or. (nbktmp.ne.nblocks)) then
               write (6,3201) netot, nettmp, nblocks, nbktmp
               write (10,3201) netot, nettmp, nblocks, nbktmp
               call adios(2,0,0)
         end if 
c
         read (14, 9001) (nbkpntr(k), k = 1,nblocks+1)
         read (14, 9001) (nbkemitlist(k), k = 1,netot)
         read (14, 9001) (neblocklist(k), k = 1,netot)
         read (14, 9001) (neposlist(k), k = 1,netot)
c
         close (14, status = 'keep')
         ifstat(14) = -1
      else if (iaction.eq.ifwrt) then
         open(14,file=aname(14),status='unknown',iostat = iost(14))
         call ferrorcheck(14, 0)
c
         write (14, 9001) netot, nblocks, initialflg
         write (14, 9001) (nbkpntr(k), k = 1,nblocks+1)
         write (14, 9001) (nbkemitlist(k), k = 1,netot)
         write (14, 9001) (neblocklist(k), k = 1,netot)
         write (14, 9001) (neposlist(k), k = 1,netot)
c
         close (14, status = 'keep')
         ifstat(14) = -1
      else 
c
c     error
c
         write (6,3001) iaction
         write (10,3001) iaction
         call adios (2, 0, 0)
      end if
c
      return
c
 3001 format (//10x,' ERROR from subroutine blkfile'
     $ / 12x,'Invalid value of iaction ' 
     $ / 12x,'Value entered  - ',i10
     $ / 15x,'------ STOPPING ------'//)
 3101 format (///8x,'ERROR - block file (.blk) needed'/
     $  11x,'for restart from is missing'
     $ / 15x,'------ STOPPING ------'//)
 3201 format (//10x,' ERROR from subroutine blkfile'
     $ / 12x,'Invalid value of header ' 
     $ / 12x,'netot =  ',i10
     $ / 12x,'value read from .blk file =  ',i10
     $ / 12x,'nblocks =  ',i10
     $ / 12x,'value read from .blk file =  ',i10
     $ / 15x,'------ STOPPING ------'//)
c
 9001 format (7(i10,1x))
c   
      end
c
c***********************************************************************
c
      subroutine blocks(nsorti)
c
c***********************************************************************
c     subroutine to distribute emitters evenly 
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      integer nsorti(netot)
c
      nchunks =  int(1 + netot/(neblock*nwproc))
c
c     fill nbkpntr array
c
        nbkpntr(1) = 0
        do 200 i=2,nwproc*nchunks+1
           nbkpntr(i) = (i-1)*neblock
 200    continue
c
c     if neblock is even: just zigzag back & forth
c   
      if (mod(neblock,2).eq.0) then
         nbcount = 0   
         do 440 l = 1,nchunks
            do 430 k = 1,(neblock/2)
               do 410 i = 1,nwproc
                  index1 = 1 + (i-1)*neblock + 2*(k-1) +
     $                         (l-1)*neblock*nwproc
                  index2 = i + 2*(k-1)*nwproc + (l-1)*neblock*nwproc
                  nbkemitlist(index1) =  nsorti(index2)
                  nbcount = nbcount + 1
                  if (nbcount.ge.netot) then
                     return
                  end if
 410           continue
c
               do 420 j = 1,nwproc
                  index1 = (j-1)*neblock +2*k +(l-1)*neblock*nwproc
                  index2 = (2*nwproc+1-j)+ 2*(k-1)*nwproc +
     $                     (l-1)*neblock*nwproc
                  nbkemitlist(index1) =  nsorti(index2)
                  nbcount = nbcount + 1
                  if (nbcount.ge.netot) then
                     return
                  end if
 420           continue
 430        continue
 440     continue
      
      else
c
c     if neblock is odd: things get hairy!
c    
         nbcount = 0  
         do 580 m = 1,nchunks + 1,2   
            l = m
c
            do 520 k = 1,(neblock-1)/2
               do 500 i = 1,nwproc
                  index1 = 1 + (i-1)*neblock + 2*(k-1) +
     $                         (l-1)*neblock*nwproc
                  index2 = i + 2*(k-1)*nwproc + (l-1)*neblock*nwproc
                  nbkemitlist(index1) =  nsorti(index2)
                  nbcount = nbcount + 1
                  if (nbcount.ge.netot) then
                     return
                  end if
 500           continue
c
               do 510 j = 1,nwproc
                  index1 = (j-1)*neblock +2*k +(l-1)*neblock*nwproc
                  index2 = (2*nwproc+1-j)+ 2*(k-1)*nwproc +
     $                     (l-1)*neblock*nwproc
                  nbkemitlist(index1) =  nsorti(index2)
                  nbcount = nbcount + 1
                  if (nbcount.ge.netot) then
                     return
                  end if
 510           continue
 520        continue
c
            do 530 i = 1,nwproc
               index1 = 1 + (i-1)*neblock + 2*(k-1) +
     $                         (l-1)*neblock*nwproc
               index2 = i + 2*(k-1)*nwproc + (l-1)*neblock*nwproc
               nbkemitlist(index1) =  nsorti(index2)
               nbcount = nbcount + 1
               if (nbcount.ge.netot) then
                  return
               end if
 530        continue
c
            l = m + 1
            do 570 k = 1,(neblock-1)/2
               do 540 j = 1,nwproc
                  index1 = 1+(j-1)*neblock +2*(k-1) +
     $                     (l-1)*neblock*nwproc
                  index2 = (nwproc+1-j)+ 2*(k-1)*nwproc +
     $                     (l-1)*neblock*nwproc
                  nbkemitlist(index1) =  nsorti(index2)
                  nbcount = nbcount + 1
                  if (nbcount.ge.netot) then
                     return
                  end if
 540           continue
c
               do 550 i = 1,nwproc
                  index1 = (i-1)*neblock + 2*k +
     $                     (l-1)*neblock*nwproc
                  index2 = i + nwproc + 2*(k-1)*nwproc + 
     $                     (l-1)*neblock*nwproc
                  nbkemitlist(index1) = nsorti(index2)
                  nbcount = nbcount + 1
                  if (nbcount.ge.netot) then
                     return
                  end if
 550           continue
 570        continue
            do 560 j = 1,nwproc
               index1 = -1 + (j-1)*neblock +2*k +(l-1)*neblock*nwproc
               index2 = (nwproc+1-j)+ 2*(k-1)*nwproc +
     $                  (l-1)*neblock*nwproc
               nbkemitlist(index1) =  nsorti(index2)
               nbcount = nbcount + 1
               if (nbcount.ge.netot) then
                  return
               end if
 560        continue
c                  
 580     continue
      end if
c
      end
c        
c***********************************************************************
c
      subroutine bplane2d()
c
c***********************************************************************
c     subroutine to define the 2D bounding planes used in the solve routine
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      write (6,1000) 
c
      do 500 l = 1, nsptr
c
c   determine the coordinate of the surface normal with the greatest absolute
c   value, this is the coordinate not used in the bounding plane calculations
c
         valmax = abs(caz(l))
         imax = 1
         tmp = abs(cbz(l))
         if (tmp.gt.valmax) then
            valmax = tmp
            imax = 2
         end if
         tmp = abs(cgz(l))
         if (tmp.gt.valmax) then
            imax = 3
         end if
c
c  determine the two coordinates to use (ja and jb) remaining coordinate
c  is jc
c
         if (imax.eq.1) then
            ja(l) = 2
            jb(l) = 3
            jc(l) = 1
         else if (imax.eq.2) then
            ja(l) = 1
            jb(l) = 3
            jc(l) = 2
         else
            ja(l) = 1
            jb(l) = 2
            jc(l) = 3
         end if  
c
         k1 = nodes(1,l)
         k2 = nodes(2,l)
         k3 = nodes(3,l)
         k4 = nodes(4,l)
c
         j1 = ja(l)
         j2 = jb(l)
c
c   make sure sytem is right handed
c
         if ((pntnd(j1,k1)-pntnd(j1,k2))*(pntnd(j2,k2)-pntnd(j2,k3)).gt. 
     $   (pntnd(j2,k1)- pntnd(j2,k2))*(pntnd(j1,k2)-pntnd(j1,k3))) then
            ja(l) = j2
            jb(l) = j1
            j1 = ja(l)
            j2 = jb(l)
         end if 
c
c   calculate a, b and d values for the four planes 
c   note that results are not normalized
c
         a41(l) = pntnd(j2,k4) - pntnd(j2,k1)
         b41(l) = pntnd(j1,k1) - pntnd(j1,k4)  
         d41(l) = a41(l)*pntnd(j1,k4) +  b41(l)*pntnd(j2,k4)     
c
         a12(l) = pntnd(j2,k1) - pntnd(j2,k2)
         b12(l) = pntnd(j1,k2) - pntnd(j1,k1)  
         d12(l) = a12(l)*pntnd(j1,k1) +  b12(l)*pntnd(j2,k1)  
c
         a23(l) = pntnd(j2,k2) - pntnd(j2,k3)
         b23(l) = pntnd(j1,k3) - pntnd(j1,k2)   
         d23(l) = a23(l)*pntnd(j1,k2) +  b23(l)*pntnd(j2,k2) 
c
         if (k3.ne.k4) then
            a34(l) = pntnd(j2,k3) - pntnd(j2,k4)
            b34(l) = pntnd(j1,k4) - pntnd(j1,k3)  
            d34(l) = a34(l)*pntnd(j1,k3) +  b34(l)*pntnd(j2,k3)
         else
            a34(l) = 0.
            b34(l) = 0.
            d34(l) = 1.
         end if
  500 continue
c
      return
c
 1000 format (1x,'in bplane2d')
c
      end
c
c***********************************************************************
c
      subroutine fileset 
c
c***********************************************************************
c     subroutine to set up the .nij, .rst and .blk files for an initial
c     or restart run. Also does all the error checks for a restart run.  
c     Note that all file reading and writing, and maintainence is handled 
c     handled by the subroutines nijfile, rstfile (both in m30s.f) and
c     blk file (in m312s.f) 
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     variables only required for sort which is not currently supported
c     dimension nsorti(itne),nisort(itne)
c
      write (6,1000) 
      call header
c
c    check to see if crash occurred, check for .blk file (unit 14)
c    icrsh = 1 if crash, initalflg = 1 if this is an initial run 
c    (crash or no crash, if crash, set in blkfile)
c
      if (irstflg.lt.0) then
         open (14,file=aname(14),status='new',iostat=iost(14))
         if (iost(14).ne.0) then 
c
c     crash occurred, read in .blk file to determine layout of blocks
c
            close (14, status='keep')
            icrsh = 1
            call blkfile(ifrd)
         else 
            close (14, status='delete')
            icrsh = 0
            initialflg = 0
         end if
      else
         icrsh = 0
         initialflg = 1
      end if 
c
      if (icrsh.eq.0) then
c
c     if no crash, all blocks need to be done
c
         do 100 ii = 1, nblocks
            nbkfin(ii) = 0
100      continue
      end if        
c
      if (icrsh.eq.1) then
         write (10, 2003)
      else if (irstflg.gt.0) then
         write (10, 2001)
      else
         write (10, 2002)
      end if   
c
      if (irstflg.ge.0) then
c
c     initial run, 0 npwold
c
            do 120 i = 1, nbands
               do 110 j = 1, nsurf
                  npwold(j,i) = 0
 110           continue
 120        continue
      else
c
c     restart, read the restart file
c
         call rstfile(ifrd, 0)
      end if
c
c     define needed values; if restart define errors,check data and
c     create .tni temporary binary file
c
      call nijfile(ifinit, 0) 
c
c     define required block arrays
c
      if (icrsh.ne.1) then
         nedo = neblock
         ne = 0
         nbkpntr(1) = 0
c
         do 250 nbk = 1, nblocks
            if ((nbk.eq.nblocks) .and. (neleft.ne.0)) then
               nedo = neleft
            end if
c
            do 200 nloop = 1, nedo
               ne = ne + 1
               nbkemitlist(ne) = ne
               neblocklist(ne) = nbk
               neposlist(ne) = nloop
 200        continue
c
            nbkpntr(nbk+1) = ne
 250     continue
c
c        store the block information in the block file
c
         call blkfile(ifwrt)
c
         if ((irstflg.lt.0) .and. (icrsh.eq.0)) then
c
c     restart from a completed run, split nij file into bni files
c
            call nijfile(ifsplit, 0)
         end if
      end if
c
      return 
c
 1000 format (1x,'in fileset')
c
 2001 format (//8x,'This is an initial run')
 2002 format (//8x,'This is a restart run')
 2003 format (//8x,'This is a restart run from a crash')
c
      end
c
c***********************************************************************
c
      subroutine graf 
c
c***********************************************************************
c     subroutine to construct graphics input file                       
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      dimension curvtmp(0:90)
      write (6,2000)
c
c     open plot file
c
      open (3,file=aname(3),status='unknown',iostat=iost( 3))  
      call ferrorcheck(3, 0)
c
c     write control information
c
      write (3,1002) (head(i),i=1,6),(head(j),j=13,15)
      write (3,1000) nsptr,nummat,nbands
c 
c     calculate the min and max coordinates
c
      xlo = cminge(1) - 0.05*dcmaxge(1)
      xhi = cmaxge(1) + 0.05*dcmaxge(1)
      ylo = cminge(2) - 0.05*dcmaxge(2)
      yhi = cmaxge(2) + 0.05*dcmaxge(2)
      zlo = cminge(3) - 0.05*dcmaxge(3)
      zhi = cmaxge(3) + 0.05*dcmaxge(3)
      write (3,1001) xlo,xhi,ylo,yhi,zlo,zhi
c
c     write outline
c
      do 100 i = 1,nsptr
         write (3,1000) i,matnum(i)
         do 50 j = 1,4
            k = nodes(j,i)
            write (3,1001) pntnd(1,k),pntnd(2,k),pntnd(3,k)
 50      continue
 100  continue
c
c     write properties, use old format
c     note that semi-specular curves are not written
c     curvtmp is used to output the old material cumlative curves
c     not all of matname is print out because the old specification 
c     for names is shorter (imnl in length instead of inmnl)  
c
      do 300 ib = 1,nbands
         do 290 mn = 1,nummat
            write (3,1014) matname(1,mn,ib)(1:imnl)
            do 250 l = 0,90
               curvtmp(l) = taus(l,mn,ib) - taud(l,mn,ib)
               write (3,1003) curvtmp(l)
  250       continue
c
            write (3,1014) matname(2,mn,ib)(1:imnl)
            do 260 l = 0,90
               curvtmp(l) = curvtmp(l) + taud(l,mn,ib) - rhoss(l,mn,ib)
               write (3,1003) curvtmp(l)
  260       continue
c
            write (3,1014) matname(3,mn,ib)(1:imnl)
            do 270 l = 0,90
               curvtmp(l) = curvtmp(l) + rhos(l,mn,ib) - rhod(l,mn,ib)
               write (3,1003) curvtmp(l)
  270       continue
c
            write (3,1014) matname(4,mn,ib)(1:imnl)
            do 280 l = 0,90
               curvtmp(l) = curvtmp(l) + rhod(l,mn,ib) - alpha(l,mn,ib)
               write (3,1003) curvtmp(l)
  280       continue
  290    continue
  300 continue
c   
c     Calculate the size of record for the exchange files 
c     no longer relevent since exchange factor files are now ASCII
c
      write(3,1015) 1
c
      close (3,status='keep')                                           
      ifstat(3) = -1
c
      return
c
 1000 format (16i5)
 1001 format (6(1x,f12.7))
 1002 format (10a8)
 1003 format (f10.7)
 1006 format ('SPECULAR MIRROR TAU SPECULAR')
 1007 format ('SPECULAR MIRROR TAU DIFFUSE')
 1008 format ('SPECULAR MIRROR RHO SPECULAR')
 1009 format ('SPECULAR MIRROR RHO DIFFUSE')
 1010 format ('DIFFUSE MIRROR TAU SPECULAR')
 1011 format ('DIFFUSE MIRROR TAU DIFFUSE')
 1012 format ('DIFFUSE MIRROR RHO SPECULAR')
 1013 format ('DIFFUSE MIRROR RHO DIFFUSE')
 1014 format (a16)
 1015 format (i10)
c
 2000 format (1x,'in graf')
c
      end
c
c**********************************************************************
c
      subroutine gridin(imerr,kountg)
c
c***********************************************************************
c     A subroutine to define grid system-grids,grid segments,nodes,    
c     coordinates. Gridin also calls seging to determine real          
c     enclosure segments that lie on or in each grid section.          
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      dimension ncp(3)
c
      imerr = 0
c
      write (6,1000)
      call header
      write (10,2000)
c
c     calculate no. of grids
c
      ngrids = ncgmax(1)*ncgmax(2)*ncgmax(3)
      ncp(1) = ncgmax(1) + 1
      ncp(2) = ncgmax(2) + 1
      ncp(3) = ncgmax(3) + 1
c
c     ngdel is the change in ng for each coordinate
c 
      ngdel(1) = 1
      ngdel(2) = ncgmax(1)
      ngdel(3) = ncgmax(1)*ncgmax(2)
c
c     Define nodal coordinates, note that uniform and user defined
c     are now defined for each coordinate
c
      do 500 i = 1, 3
         if (igc(i).gt.0) then
c
c        Create a standard grid for that direction
c
            delcg = 1.05*dcmaxge(i)/ncgmax(i)
            c0 = cminge(i) - 0.023465718764*dcmaxge(i)
            do 100 j = 1,ncp(i)
               cg(j,i) = c0 + (j - 1)*delcg
  100       continue
c
            cfactg(i) = cg(2,i) - cg(1,i)
         else
c
c        Read the grid coordinates from user input
c
            read (1,1001) (cg(j,i),j=1,ncp(i))
         end if
c
c     factor used to calculate the grid indices in getpntgrd
c
         factg(i) = ncgmax(i)/(cg(ncp(i), i) - cg(1, i))
  500 continue
c
c     check for valid grid bounds
c
      if (cg(1,1).ge.cminge(1) .or. cg(ncp(1), 1).le.cmaxge(1) .or.
     $    cg(1, 2).ge.cminge(2) .or. cg(ncp(2), 2).le.cmaxge(2) .or.
     $    cg(1,3).ge.cminge(3) .or. cg(ncp(3), 3).le.cmaxge(3)) then
         write (10,3001) cminge(1), cmaxge(1), cminge(2), cmaxge(2),
     $                   cminge(3), cmaxge(3)
         write (10,2001) (cg(i,1),i=1,ncp(1))
         write (10,2002) (cg(i,2),i=1,ncp(2))
         write (10,2003) (cg(i,3),i=1,ncp(3))
         call adios(2, 0 , 0)
      end if
c
c     write grid locations
c
      write (10,2001) 
      write (10,2004) (cg(i,1),i=1,ncp(1))
      write (10,2002)
      write (10,2004) (cg(i,2),i=1,ncp(2))
      write (10,2003)
      write (10,2004) (cg(i,3),i=1,ncp(3)) 
c
c     now find real segments that lie on or within each grid section
c
      kountg = 0
      npts = 0
      do 600 nz = 1,ncgmax(3)
         do 590 ny = 1,ncgmax(2)
            do 580 nx = 1,ncgmax(1)
               call seging (nx,ny,nz, ngrids, kountg,npts,imerr)
 580        continue
 590     continue
 600  continue
c
c     exceeded memory for grid segments, return
c
      if (imerr.eq.1) then
         return
      end if
c
c     write to output-grid information
c
      if (iprnt(5).ne.0) then
         write (10,2101)
         iadd = 0
      end if 
c
      ngused = 0
c
      do 750 ng = 1,ngrids
         ncount = iptgrd(ng + 1) - iptgrd(ng)
         if (iprnt(5).ne.0) then
            write (10,2102) ng,ncount,iptgrd(ng)
         end if
         if (ncount.ne.0) then
            ngused = ngused + 1
            if (ncount.gt.ncmax) then
               ncmax = ncount
               ncmaxcount = 1
            else if (ncount.eq.ncmax) then
               ncmaxcount = ncmaxcount + 1
            end if  
            if (iprnt(5).ne.0) then
               do 700 j = 1, ncount
                  iadd = iadd + 1
                  write (10,2103) iadd,nsegsg(iadd)
 700           continue
            end if 
         end if
 750  continue
c
c    statistics on grid population
c
      ngempty = ngrids - ngused
      gcave = iptgrd(ngrids + 1)/real(ngrids)
      gnecave = iptgrd(ngrids + 1)/real(ngused)
      write (10, 2201) kountg, ngrids, ngempty, gcave, gnecave, ncmax, 
     $                 ncmaxcount
c
      return
c
 1000 format (1x,'in gridin')
 1001 format (8e10.0)
c
 2000 format (////
     $ / 7x,'g r i d   i n f o . ( s h a d i n g )'//
     $ / 5x,'grid  locations')
 2001 format (///2x,'x - locations'/)
 2002 format (///2x,'y - locations'/)
 2003 format (///2x,'z - locations'/)
 2004 format (5(/2x,e12.5)/) 
 2101 format (/7x,'grid  and  segments'//)
 2102 format (/7x,'grid no. =',i10,2x,'no. segments in grid =',i5,2x,
     $ 'starting address =',i10/
     $ / 9x,'address',2x,'segment no.')
 2103 format (7x,i5,4x,i5)
 2201 format (
     $ / 7x, 'grid statistics' //
     $ / 7x, 'total number of segments found =                 ', i10
     $ / 7x, 'total number of grid cells =                     ', i10 
     $ / 7x, 'total number of EMPTY grid cells =               ', i10  
     $ / 7x, 'average number of surfaces per cell =            ', f12.5
     $ / 7x, 'average number of surfaces per NONempty cell =   ', f12.5
     $ / 7x, 'maximum number of surfaces per cell =            ', i10
     $ / 7x, 'number of grid cells having the maximum number = ', i10//)
c
 3001 format (/10x,'error termination - bad grid coordinates'/
     $ / 2x,'the bounding x values are ',2(5x,e14.7)/
     $ / 2x,'the bounding y values are ',2(5x,e14.7)/
     $ / 2x,'the bounding z values are ',2(5x,e14.7)/
     $ / 2x,'your bounding grid coordinates must lie outside! these')
c
      end
c
c***********************************************************************
c
      function ibshift (jseed)
c
c***********************************************************************
c     function to accomplish binary shift register 
c     see Burns and Pryor, Surface Radiative Transport at Large Scale 
c     via Monte Carlo (to be published) for more details
c     each call potentially changes one bit in the argument jseed
c     the function returns the latest value of the potentially 
c     changed bit
c     This function is used to intialize the RNG
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      integer*4 jseed, ibits(6), ibshft(6)
c
c     get bits at tap points
c     note that ishft(i,j) shifts bits in i by j places
c     if j is positive, the shift is to the left otherwise it is to the 
c     right. 0 are shifted in from the oppisite end
c     four byte integer is 32 bits with first bit a sign bit and 
c     most significant bits are to the left
c     mask(0) = 1 so ibits(i) is the rightmost bit after each shift
c
      do 10 i = 1,6
        ibshft(i) = ishft(jseed, -itaps(i))
        ibits(i) = iand(ibshft(i), mask(0))
   10 continue
c
c     sum selected bits and return the value of the least significant bit
c
      isum = ibits(1)
      do 50 i = 2, 6
        isum = isum + ibits(i)
   50 continue
c
      ibshift = iand(isum, mask(0))
c
c     put bit back into jseed
c
      if (ibshift .ne. 0) then 
        jseed = ior(mask(itaps(6)), jseed)
      else
        jseed = iand(maskc(itaps(6)), jseed)
      end if    
c
c     shift taps
c
      do 100 i = 1,6
        itaps(i) = itaps(i) - 1
  100 continue
      if (itaps(1) .lt. 0) then
        itaps(1) = 31
      else if (itaps(2).lt.0) then
        itaps(2) = 31
      else if (itaps(3).lt.0) then
        itaps(3) = 31
      else if (itaps(4).lt.0) then
        itaps(4) = 31
      else if (itaps(5).lt.0) then
        itaps(5) = 31
      else if (itaps(6).lt.0) then
        itaps(6) = 31
      end if
c
      return
      end
c
c***********************************************************************
c
      subroutine order 
c
c***********************************************************************
c      subroutine to check boundaries for leaks and to compute
c        areas of surfaces. check is first done by node number,
c        to see if each side of a surface matches a side of another
c        surface.  if this test fails, a search is made over nodal
c        point coordinates also.  finally, tests are made to see
c        if the side is coplanar and within bounds of another surface.
c        three levels of errors are generated:
c 
c        error 1 - two sides are connected in reversed order, indicating
c                  a reversed surface.
c        error 2 - no match was found with any other surface.
c        error 3 - both nodes of a side were coplanar with another
c                  surface, one of the nodes was within bounds, and
c                  both nodes are collinear with one of the surface
c                  edges.  this is called a slip surface.
c 
c        only warnings are generated, so no error termination will result
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      dimension ntemp(15),jtemp(15)
c
      data small /1.0d-6/
      data nwrt1,nwrt2,nwrt3,nwrt4 /1,2,3,4/
c
c     open leaks file
c
      open (11,file=aname(11),status='unknown',iostat=iost(11)) 
      call ferrorcheck(11, 0)
c
      write (6,1000)
      call header
      write (10,2000)
c
c     initialize error counters
c
      ierrs = 0
      ierr1 = 0
      ierr2 = 0
      ierr3 = 0
c
c     outer loop over surfaces
c
      do 100 i = 1,nsptr
         ierrt = 0
c
c        inner loop over sides of one surface
c
         do 95 k1 = 1, 4
            k2 = k1 + 1
            if (k2.eq.5) then
               k2 = 1
            end if 
            n10 = nodes(k1,i)
            n20 = nodes(k2,i)
c
c           check for valid triangular surfaces
c
            if (n10.eq.n20) then
               goto 95
            end if
c
c           loop over other surfaces
c
            do 80 j = 1,nsptr
               if (i.eq.j) then
                  goto 80
               end if 
c
c              loop over sides of other surface
c
               do 70 l1 = 1,4
                  l2 = l1 + 1
                  if (l2.eq.5) then
                     l2 = 1
                  end if
c
c                 check for match of nodes at both sides of edge
c
                  if (n10.eq.nodes(l2,j).and.
     $                n20.eq.nodes(l1,j)) then
                     goto 95
                  end if 
 70            continue
 80         continue
c
c           If no match found, search by nodal point coordinates
c           Get coordinates of current edge nodes
c
            x10 = pntnd(1,n10)
            y10 = pntnd(2,n10)
            z10 = pntnd(3,n10)
            x20 = pntnd(1,n20)
            y20 = pntnd(2,n20)
            z20 = pntnd(3,n20)
c
c           loop over other surfaces
c
            do 84 j = 1,nsptr
               if (i.eq.j) then
                  goto 84
               end if
c
c              loop over sides of other surface
c
               do 82 l1 = 1,4
                  l2 = l1 + 1
                  if (l2.eq.5) then
                     l2 = 1
                  end if
c
                  n1test = nodes(l1,j)
                  n2test = nodes(l2,j)
c
                  x1t = pntnd(1,n1test)
                  y1t = pntnd(2,n1test)
                  z1t = pntnd(3,n1test)
                  x2t = pntnd(1,n2test)
                  y2t = pntnd(2,n2test)
                  z2t = pntnd(3,n2test)
c
c Check for forward match of coordinates at both sides of edge.
c If detected, side is ok
c
                  if (abs(x10 - x2t) .lt. small .and.
     $                abs(y10 - y2t) .lt. small .and.
     $                abs(z10 - z2t) .lt. small .and.
     $                abs(x20 - x1t) .lt. small .and.
     $                abs(y20 - y1t) .lt. small .and.
     $                abs(z20 - z1t) .lt. small) then
                     goto 95
                  end if 
c
c check for reversed match of coordinates at both sides of edge
c if detected, print error 1 message
c
                  if (abs(x10 - x1t) .lt. small .and.
     $                abs(y10 - y1t) .lt. small .and.
     $                abs(z10 - z1t) .lt. small .and.
     $                abs(x20 - x2t) .lt. small .and.
     $                abs(y20 - y2t) .lt. small .and.
     $                abs(z20 - z2t) .lt. small) then
                     write (10,3011) i,k1,j,l1
                     write (11,4000) nwrt1, i, k1
                     write (11,4000) nwrt4, j, l1
                     ierr1 = ierr1 + 1
                     ierrt = ierrt + 1
                     goto 95
                  end if
 82            continue
 84         continue
c
c     if no match, check for butting surfaces where test surface
c     entirely encloses the present search surface
c
            isflag = 0
            iscnt = 0
            do 89 j = 1, nsptr
               if (i.eq.j) then
                  goto 89
               end if
c
c              see if test surface contains both nodes
c
               test1 = x10*caz(j) + y10*cbz(j) + z10*cgz(j) - distp(j)
               test2 = x20*caz(j) + y20*cbz(j) + z20*cgz(j) - distp(j)
c
               if (abs(test1) .gt. small .or.
     $             abs(test2) .gt. small) then
                  goto 89
               end if
c
c              check if both nodes are within element bounds
c
               nfind = 0
c
         if (x10*a41(j)+y10*b41(j)+z10*c41(j).lt.d41(j) - small) then
            goto 86
         end if
         if (x10*a12(j)+y10*b12(j)+z10*c12(j).lt.d12(j) - small) then
            goto 86
         end if
         if (x10*a23(j)+y10*b23(j)+z10*c23(j).lt.d23(j) - small) then
            goto 86
         end if 
         if (x10*a34(j)+y10*b34(j)+z10*c34(j).lt.d34(j) - small) then
            goto 86
         end if 
c
               nfind = 1
c
 86      if (x20*a41(j)+y20*b41(j)+z20*c41(j).lt.d41(j) - small) then
            goto 87
         end if 
         if (x20*a12(j)+y20*b12(j)+z20*c12(j).lt.d12(j) - small) then
            goto 87
         end if
         if (x20*a23(j)+y20*b23(j)+z20*c23(j).lt.d23(j) - small) then 
            goto 87
         end if
         if (x20*a34(j)+y20*b34(j)+z20*c34(j).lt.d34(j)  -small) then
            goto 87
         end if
c
               nfind = nfind + 1
c
c  if both are within bounds, a match has been found - next surface
c
 87            if (nfind .eq. 2) then
                  goto 95
               end if 
c
c              If one was found, boundary may be a slip boundary
c              Print error 3 message - potential slip surface

               if (nfind .eq. 1) then
c
c  test if both test nodes are collinear with any of sides of surface
c
                  t112 = x10*a12(j) + y10*b12(j) + z10*c12(j) - d12(j)
                  t212 = x20*a12(j) + y20*b12(j) + z20*c12(j) - d12(j)
                  itside = 1
                  if (abs(t112).lt.small.and.abs(t212).lt.small) then
                     goto 88
                  end if
c
                  t123 = x10*a23(j) + y10*b23(j) + z10*c23(j) - d23(j)
                  t223 = x20*a23(j) + y20*b23(j) + z20*c23(j) - d23(j)
                  itside = 2
                  if (abs(t123).lt.small.and.abs(t223).lt.small) then
                     goto 88
                  end if 
c
                  t134 = x10*a34(j) + y10*b34(j) + z10*c34(j) - d34(j)
                  t234 = x20*a34(j) + y20*b34(j)  +z20*c34(j) - d34(j)
                  itside = 3
                  if (abs(t134).lt.small.and.abs(t234).lt.small) then 
                     goto 88
                  end if 
c
                  t141 = x10*a41(j) + y10*b41(j) + z10*c41(j) - d41(j)
                  t241 = x20*a41(j) + y20*b41(j) + z20*c41(j) - d41(j)
                  itside = 4
                  if (abs(t141).ge.small.or.abs(t241).ge.small) then
                     goto 89
                  end if
c
c     slip has been found if this point has been reached - set flag
c
 88               isflag = 1
                  if (iscnt.lt.15) then
                     iscnt = iscnt + 1
                  end if 
                  ntemp(iscnt) = itside
                  jtemp (iscnt) = j
               end if
 89         continue
c
c     if slip flag is set, print error 3 - potential slip surface
c
            if (isflag .eq. 1) then
               write (10,3013) i, k1
               write (11,4000) nwrt3, i, k1
               do 90 iii = 1,iscnt
                  write (10,3014) jtemp(iii), ntemp(iii)
                  write (11,4000) nwrt4, jtemp(iii), ntemp(iii)
 90            continue
               ierr3 = ierr3 + 1
               ierrt = ierrt + 1
               go to 95
            endif
c
c           if this point is reached, no match has been found.
c           print error 2 message - no match found
c
            write (10,3012) i, k1, n10, n20
            write (11,4000) nwrt2, i, k1
            ierr2 = ierr2 + 1
            ierrt = ierrt + 1
c
 95      continue
         if (ierrt .gt. 0) then
            write (10,3015) ierrt, i
         end if
 100  continue
c
      ierrs = ierr1 + ierr2 + ierr3
      if (ierrs.eq.0) then
c
c        no errors - return
c
         write (10,2001)
         return
      endif
c
c     print number of errors
c
      write (6,3001) ierrs,ierr1,ierr2,ierr3
      write (10,3001) ierrs,ierr1,ierr2,ierr3
c
      close (11,status='keep')                                          
      ifstat(11) = -1
c
      return
c
 1000 format (//1x,'in order')
c
 2000 format (////
     $ 7x,'e n c l o s u r e  l e a k  c h e c k i n g'///)
 2001 format (//5x,'no enclosure leaks detected')
c
 3001 format (//5x,'warning- error from enclosure check'/
     $        5x,i7,' total potential leaks detected'/
     $        5x,i7,' type 1  reversed edge'/
     $        5x,i7,' type 2  no match found'/
     $        5x,i7,' type 3  slip surface'//)
 3011 format (5x,'error 1 - reversed edge    *********************'/
     $        5x,'from surface ',i5,' side ',i2,
     $            ' to surface ',i5,' side ',i2)
 3012 format (5x,'error 2 - no match found   **************'/
     $        5x,'surface no. ',i5,' side ',i2,
     $        ' nodes 1, 2  ',i5,2x,i5)
 3013 format (5x,'error 3 - slip surface     *******'/
     $        5x,'surface no. ',i5,' side ',i2)
 3014 format (8x,' to surface ',i5,' side ',i2)
 3015 format (5x,i2,' errors found for surface ',i5/)
c
 4000 format (1x,i2,1x,i5,1x,i2)
c
      end
c     
c***********************************************************************
c     
      subroutine raninit (iaction)
c     
c***********************************************************************
c      Subroutine to initialize pseudo-random number generator   
c      iaction = ircont if this continues from a previous state
c              = irstart if this starts a new random sequence
c***********************************************************************
c     
      include 'mont3d.par'
      include 'mont3d.com'
c
      integer*4 iones, iseedt, mask32
c
      data iones /z'ffffffff'/
c
      rmult = 1.d0/modulus
c
c     continuation case no further initializing needed
c     state already read in rstfile
c
      if (iaction.eq.ircont) then 
         return
      end if 
c
      mask32 = iones
c
c    fill masks
c    mask(m) has 1 in the mth bit
c    maskc(m) has 1 in all bits except the mth bit
c
      do 100 m = 0, 31
        mask(m)  = 2**m
        maskc(m) = mask32 - mask(m)
  100 continue
c
c     initialize initial seed array to zero
c
      do 300 n = 1, lflen
        iseed(n) = 0
  300 continue
c
c    set taps for binary shift register
c
      itaps(1) = 0
      itaps(2) = 1
      itaps(3) = 2
      itaps(4) = 4
      itaps(5) = 6
      itaps(6) = 31
c
c     shift 64 times to start, this insures no large "flat spot" in the 
c     sequence
c
      iseedt = iseed0
      do 310 n = 1, 64
        i = ibshift(iseedt)
  310 continue
c
c     generate initial fill of the seed array using binary shift register
c
      do 500 m = 1,31
        do 400 n = 1, lflen - 1
           i = ibshift(iseedt)
c
c     put bit into iseed - only if 1
c
           if (i .ne. 0) then 
            iseed(n) = ior(mask(m), iseed(n))
           end if    
  400   continue
  500 continue
c
c     By specifying a "canonical" form of seed array, it can be insured
c     that each initial seed leads to a totally different sequence of 
c     random numbers from any other seeds.  No seed will start in a different
c     place in the sequence used by another seed 
c     see Pryor, Cuccaro, Mascagni and Robinson, 1994 for more details
c     in the canonical from, only 1 or 2 of the seeds have a nonzero 
c     least significant bit which one(s) this is given in a table in the 
c     reference above for several lagged Fib RNGs 
c
      ii = lfs + 1
      do 600 i = 1, lfl
         iseed(ii) = ior(iseed(ii), 1)
         ii = ii + 1
 600  continue
c
c     set initial taps for lagged fibonacci rng
c
      it1 = lflen
      it2 = lflag
c
      return
      end
c
c***********************************************************************
c
      subroutine ranset
c
c***********************************************************************
c     subroutine to set up the RNG                                           
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     set up rng
c
      if (iparflg.eq.0) then
c
c     single processor
c
         if ((irstflg.lt.0) .and. (iparflgold.eq.0)) then
c
c     restart from a completed or crashed run previously in single processor
c     version
c               
            call raninit (ircont)
         else
c
c     restart from a completed or crashed run previously on multiple 
c     processors
c 
            call raninit (irstart)
         end if
      else if (mymid.ne.0) then
c
c     set up RNG on parallel worker
c     since seed state never stored, always have to start generator from scratch
c     if NWPROC = 1 use iseed0 so that it will match single processor results
c     (if no restart)
c
         if (nwproc.gt.1) then
c
c     if NWPROC > 1 mask seed
c     calculate the number of bits required to store nwproc workers
c     master does not use RNG, only gives base seed (iseed0)
c
            rbits = log(real(nwproc))/log(2.)
            nclear = 2**nint(rbits)
            if (nclear.lt.nwproc) then
               nclear = 2*nclear
            end if
c
            isfact = iseed0/nclear
            if (isfact.gt.0) then 
               iseed0 = isfact*nclear + mymid - 1
            else 
               iseed0 = mymid
            end if 
         end if
c
         call raninit (irstart)
      end if
c
      return
      end          
c
c***********************************************************************
c
      subroutine seging (nx,ny,nz,ngrids,kountg,npts,imerr)
c
c***********************************************************************
c     subroutine to determine the real segments that lie on or in a   
c      grid section ng.                                              
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      dimension co(3,4),gb(2,3)
c
      data small/1.d-6/
c
c     fill grid boundary array
c
      gb(1,1) = cg(nx,1)
      gb(2,1) = cg(nx + 1,1)
      gb(1,2) = cg(ny, 2)
      gb(2,2) = cg(ny + 1, 2)
      gb(1,3) = cg(nz, 3)
      gb(2,3) = cg(nz + 1, 3)
      xmin = cg(nx, 1)
      xmax = cg(nx + 1, 1)
      ymin = cg(ny, 2)
      ymax = cg(ny + 1, 2)
      zmin = cg(nz, 3)
      zmax = cg(nz + 1, 3)
      xminms = xmin - small
      yminms = ymin - small
      zminms = zmin - small
      xmaxps = xmax + small
      ymaxps = ymax + small
      zmaxps = zmax + small
c
      ng = (nz-1)*ncgmax(1)*ncgmax(2) + (ny-1)*ncgmax(1) + nx
c
c     loop over all radiating segments of enclosure.
c
      npt = 0
      iptgrd(ng) = npts
c
      do 700 l = 1,nsptr
c
c        eliminate those real segments which have all nodes to the
c        outside and to the 'side' of the grid.
c
         if (xmins(l).gt.xmaxps) then
            goto 700
         end if
         if (xmaxs(l).lt.xminms) then
            goto 700
         end if
         if (ymins(l).gt.ymaxps) then
            goto 700
         end if
         if (ymaxs(l).lt.yminms) then
            goto 700
         end if
         if (zmins(l).gt.zmaxps) then
            goto 700
         end if
         if (zmaxs(l).lt.zminms) then
            goto 700
         end if
c
c       initialize variables 
c
         do 50 i = 1,4
            nnum = nodes(i,l)
            co(1,i) = pntnd(1, nnum)
            co(2,i) = pntnd(2,nnum)
            co(3,i) = pntnd(3,nnum)
  50     continue
c
c        check for type of radiating element where any of four nodes
c        lie in grid section ng.
c
         do 100 i = 1,4
            if (co(1,i).le.xmax.and.co(1,i).ge.xmin.and.
     $         co(2,i).le.ymax.and.co(2,i).ge.ymin.and.
     $         co(3,i).le.zmax.and.co(3,i).ge.zmin) then
                  goto 600
            end if 
  100    continue
c
c        check for intersection of element side with grid boundry
c        loop over element sides
c
         do 220 i1 = 1,4
            i2 = i1 + 1
            if (i2.eq.5) then
               i2 = 1
            end if
c
c           loop over dimensions
c
            do 210 j1 = 1,3
               j2 = j1 + 1
               if (j2.eq.4) then
                  j2 = 1
               end if 
               j3 = j1 - 1
               if (j3.eq.0) then 
                  j3 = 3
               end if
c
c              check for side parallel to axis
c
               if (abs(co(j1,i2) - co(j1,i1)).lt.small) then 
                  goto 210
               end if 
c
c              loop over min and max
c
               do 200 m = 1,2
                  p2 = ((gb(m,j1)-co(j1,i1))*(co(j2,i2)-co(j2,i1)))/
     $               (co(j1,i2)-co(j1,i1))+co(j2,i1)
                  p3 = ((gb(m,j1)-co(j1,i1))*(co(j3,i2)-co(j3,i1)))/
     $               (co(j1,i2)-co(j1,i1))+co(j3,i1)
                  if (p2.gt.gb(2,j2).or.p2.lt.gb(1,j2).or.
     $               p3.gt.gb(2,j3).or.p3.lt.gb(1,j3)) then 
                     goto 200
                  end if 
                  if ((co(j1,i1)-gb(m,j1))*(gb(m,j1)-co(j1,i2)).ge.0.)
     $               then 
                     goto 600
                  end if 
 200           continue
 210        continue
 220     continue
c
c        check if grid cell edges intersect element boundaries
c        edges parallel to x-axis
c
         if (abs(caz(l)).lt.small) then
            goto 300
         end if 
         xint = -(ymin*cbz(l) + zmin*cgz(l) - distp(l))/caz(l)                
         if (xint*a41(l)+ymin*b41(l)+zmin*c41(l).ge.d41(l).and.
     $      xint*a12(l)+ymin*b12(l)+zmin*c12(l).ge.d12(l).and.
     $      xint*a23(l)+ymin*b23(l)+zmin*c23(l).ge.d23(l).and.
     $      xint*a34(l)+ymin*b34(l)+zmin*c34(l).ge.d34(l)) then
            goto 600
         end if
c
         xint = -(ymin*cbz(l) + zmax*cgz(l) - distp(l))/caz(l)                
         if (xint*a41(l)+ymin*b41(l)+zmax*c41(l).ge.d41(l).and.
     $      xint*a12(l)+ymin*b12(l)+zmax*c12(l).ge.d12(l).and.
     $      xint*a23(l)+ymin*b23(l)+zmax*c23(l).ge.d23(l).and.
     $      xint*a34(l)+ymin*b34(l)+zmax*c34(l).ge.d34(l)) then
            goto 600
         end if 
c
         xint = -(ymax*cbz(l)  +zmin*cgz(l) - distp(l))/caz(l)                
         if (xint*a41(l)+ymax*b41(l)+zmin*c41(l).ge.d41(l).and.
     $      xint*a12(l)+ymax*b12(l)+zmin*c12(l).ge.d12(l).and.
     $      xint*a23(l)+ymax*b23(l)+zmin*c23(l).ge.d23(l).and.
     $      xint*a34(l)+ymax*b34(l)+zmin*c34(l).ge.d34(l)) then
            goto 600
         end if
c
         xint = -(ymax*cbz(l) + zmax*cgz(l) - distp(l))/caz(l)                
         if (xint*a41(l)+ymax*b41(l)+zmax*c41(l).ge.d41(l).and.
     $      xint*a12(l)+ymax*b12(l)+zmax*c12(l).ge.d12(l).and.
     $      xint*a23(l)+ymax*b23(l)+zmax*c23(l).ge.d23(l).and.
     $      xint*a34(l)+ymax*b34(l)+zmax*c34(l).ge.d34(l)) then
            goto 600
         end if
c
c        edges parallel to y-axis
c
  300    if (abs(cbz(l)).lt.small) then
            goto 400
         end if
         yint = -(xmin*caz(l) + zmin*cgz(l) - distp(l))/cbz(l)               
         if (xmin*a41(l)+yint*b41(l)+zmin*c41(l).ge.d41(l).and.
     $      xmin*a12(l)+yint*b12(l)+zmin*c12(l).ge.d12(l).and.
     $      xmin*a23(l)+yint*b23(l)+zmin*c23(l).ge.d23(l).and.
     $      xmin*a34(l)+yint*b34(l)+zmin*c34(l).ge.d34(l)) then
            goto 600
         end if 
c
         yint = -(xmin*caz(l) + zmax*cgz(l) - distp(l))/cbz(l)                
         if (xmin*a41(l)+yint*b41(l)+zmax*c41(l).ge.d41(l).and.
     $      xmin*a12(l)+yint*b12(l)+zmax*c12(l).ge.d12(l).and.
     $      xmin*a23(l)+yint*b23(l)+zmax*c23(l).ge.d23(l).and.
     $      xmin*a34(l)+yint*b34(l)+zmax*c34(l).ge.d34(l)) then
            goto 600
         end if
c
         yint = -(xmax*caz(l) + zmin*cgz(l) - distp(l))/cbz(l)                
         if (xmax*a41(l)+yint*b41(l)+zmin*c41(l).ge.d41(l).and.
     $      xmax*a12(l)+yint*b12(l)+zmin*c12(l).ge.d12(l).and.
     $      xmax*a23(l)+yint*b23(l)+zmin*c23(l).ge.d23(l).and.
     $      xmax*a34(l)+yint*b34(l)+zmin*c34(l).ge.d34(l)) then 
            goto 600
         end if 
c
         yint = -(xmax*caz(l) + zmax*cgz(l) - distp(l))/cbz(l)               
         if (xmax*a41(l)+yint*b41(l)+zmax*c41(l).ge.d41(l).and.
     $      xmax*a12(l)+yint*b12(l)+zmax*c12(l).ge.d12(l).and.
     $      xmax*a23(l)+yint*b23(l)+zmax*c23(l).ge.d23(l).and.
     $      xmax*a34(l)+yint*b34(l)+zmax*c34(l).ge.d34(l)) then
            goto 600
         end if
c
c        edges parallel to z-axis
c
  400    if (abs(cgz(l)).lt.small) then
            goto 700
         end if 
         zint = -(xmin*caz(l) + ymin*cbz(l) - distp(l))/cgz(l)                
         if (xmin*a41(l) + ymin*b41(l) + zint*c41(l).ge.d41(l).and.
     $      xmin*a12(l)+ymin*b12(l)+zint*c12(l).ge.d12(l).and.
     $      xmin*a23(l)+ymin*b23(l)+zint*c23(l).ge.d23(l).and.
     $      xmin*a34(l)+ymin*b34(l)+zint*c34(l).ge.d34(l)) then
            goto 600
         end if
c
         zint = -(xmin*caz(l) + ymax*cbz(l) - distp(l))/cgz(l)                
         if (xmin*a41(l)+ymax*b41(l)+zint*c41(l).ge.d41(l).and.
     $      xmin*a12(l)+ymax*b12(l)+zint*c12(l).ge.d12(l).and.
     $      xmin*a23(l)+ymax*b23(l)+zint*c23(l).ge.d23(l).and.
     $      xmin*a34(l)+ymax*b34(l)+zint*c34(l).ge.d34(l)) then
            goto 600
         end if 
c
         zint = -(xmax*caz(l) + ymin*cbz(l) - distp(l))/cgz(l)                
         if (xmax*a41(l)+ymin*b41(l)+zint*c41(l).ge.d41(l).and.
     $      xmax*a12(l)+ymin*b12(l)+zint*c12(l).ge.d12(l).and.
     $      xmax*a23(l)+ymin*b23(l)+zint*c23(l).ge.d23(l).and.
     $      xmax*a34(l)+ymin*b34(l)+zint*c34(l).ge.d34(l)) then
            goto 600
         end if 
c
         zint = -(xmax*caz(l) + ymax*cbz(l) - distp(l))/cgz(l)                
         if (xmax*a41(l)+ymax*b41(l)+zint*c41(l).ge.d41(l).and.
     $      xmax*a12(l)+ymax*b12(l)+zint*c12(l).ge.d12(l).and.
     $      xmax*a23(l)+ymax*b23(l)+zint*c23(l).ge.d23(l).and.
     $      xmax*a34(l)+ymax*b34(l)+zint*c34(l).ge.d34(l)) then
            goto 600
         end if 
c
c        not inside grid if this point is reached
c
         goto 700
c
  600 continue
c
c     Segment l lies on or within grid ng.  Store no. l
c
      kountg = kountg + 1
      if (kountg.gt.iseg) then
c
c     ran out of allocation for grid segments set memory error
c     do not store results, this will lead to an array bounds error
c     keep kcountg so can tell user how much memory is needed
c
         imerr = 1
      else
         nsegsg(kountg) = l
      end if
      npt = npt + 1
c
c     npt counts the no. of grid segments in grid ng.
c
  700 continue
c
c     update number of cumulative points
c
      npts = npts + npt
      if (ng.eq.ngrids) then
        iptgrd(ng+1) = iptgrd(ng) + npt
      end if 
c
      return
c
      end
