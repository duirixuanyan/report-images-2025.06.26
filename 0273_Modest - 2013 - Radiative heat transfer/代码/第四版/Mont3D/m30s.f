c*********************************************************************     
c
c     m30s.f
c
c*********************************************************************
c     Unix compile:
c        %make
c          using Makefile provided; see Makefile for other options
c
c     Last modified: 04-15-99 - cnz
c
c     Changes: MONT3D version 2.4f1 : 04-15-99 - cnz
c        - fixed some potential errors in PVM packing and unpacking
c        - added stubs to allow clock timing and date and time for  
c          f90 compliant compilers including the IBM RS/6000 and 
c          Microsoft FORTRAN compilers
c        - reduced the parameter PDAMAX from 0.001 to 0.1, making the 
c          coplanarity test less stringent, see Section 2.3 of the 
c          manual
c        - moved ralf from m30s.f to m32s.f so that some compilers
c          can optimize the code better (also moved raninit and 
c          ibshift from m30s.f to m313s.f)
c        - initalized istop to 0 in matinold for compilers that do not 
c          automatically initialize to 0
c
c     Changes: MONT3D version 2.4b6 : 10-05-98 - cnz
c        - grid input now much faster, particular for large numbers of
c          surfaces and grids
c        - can now rename the parallel version of the code
c          + default program name is m3dpvm
c          + set by the parameter m3dparaname in mont3d.par
c          + must recompile to change name
c          + can also set the name in the Makefile
c        - timing results now in terms of clock time for parallel version 
c          of the code
c        - slight speed improvements to the solve routine
c        - better error checking of the isrfs parameter 
c          (number of total surfaces, split and unsplit)
c        - better error handling when all processes do not spawn in the 
c          parallel code
c        - check for triangular surfaces now consistant with check for 
c          coincident points
c        - fixed error where code would emit from converged surfaces in a
c          parallel restart run
c        - more robust checking for errors in exchange factor files during a
c          restart run
c        - when listing surface information in output file, the 
c          information for the first surface of a pair of split 
c          surfaces now lists its area, not the total area
c        - more grid statistics in output file 
c        - more testing/general clean up of parallel code, restart and error
c          detection
c    
c     Changes: MONT3D version 2.4b5 : 03-19-98 - cnz
c        - fixed error introduced in b3 where no photons were emitted if 
c          nploops = 0
c        - fixed error introduced in b3 where no statistics were written 
c          at the end of a successful run
c        - improved output format for grid divisions in output file when 
c          there are more than 5 grid coordinates specified along an axis
c
c     Changes: MONT3D version 2.4b4 : 03-05-98 - cnz
c        - better handling of split surfaces/concave surfaces
c        - now produces an error when zero photons are emitted from a split
c          surface
c        - general clean-up of surface and nodal input (nodin3, surfin3,
c          surfinfo) routines, particularly error messages and potential
c          array bounds problems from erroneous input
c        - fixed some potential precision problems with restart files for a
c          restart run
c        - renamed elmin3 and elinfo to surfin3 and surfinfo
c
c     Changes: MONT3D version 2.4b3 : 02-13-98 - cnz and kb
c        - new RNG
c          + better statistical properties than old RNG
c          + allows parallel RNG streams
c        - added new material model
c          + old material model still supported
c          + allows the modeling of semi-specular reflectance and transmittance
c          + new way of entering in constant curves
c          + non-constant curves read from a curve list, only enter each curve
c            once
c          + now name materials, not curves
c        - new set of parallel options, iparopt(5) 
c          + entered as 5i1 near the end of control card 2 (after nploops)
c          + iparopt(1) is defined, others reserved for future expansion
c          + if iparopt(1) = 0, workers can spawn on master CPU 
c          + if iparopt(1) = 1, workers can not spawn on master CPU
c          + if iparopt(1) = 2, a debug session xterm is created for each 
c            worker
c          + if iparopt(1) = 3, combination of iparopt(1) = 1 and 2
c          + any other value of iparopt(1) is an error
c        - put the code through a revised and expanded series of test cases
c        - restructured internal file structure again
c        - user defined grids now work properly
c        - specifying names on the command line now works as stated in manual
c        - fixed a number of potential problems with split surfaces
c        - now terminates processes properly when too many photons are lost
c          per process
c        - cleaned up screen output
c          + no lost photon messages to console unless iprnt(2) = 1
c          + screen lost photon messages are now a little more informative
c          + all worker messages stored in temporary output files for 
c            each worker
c            - temporary output files are deleted at the end of a successful 
c              run
c            - useful for debugging if terminate due to error
c        - corrected incorrect warning message about ndivx and ndivy
c          now not only is their default 5, the warning message says so
c        - split the input routines further to create the file m313s.f
c
c     Changes: MONT3D version 2.4b2 : 07-11-97 - cnz and pjb
c        - now can compile a PVM version
c        - increased the speed of solve routine
c        - removed familied file structure - only one output file and 
c          one exchange factor file created
c        - exchange factor file and restart file now ASCII not binary
c        - reorganized restart routines
c        - collected all commons into one file
c        - created stubs to allow the turning on and off of non-ANSI features:
c          the command line, timing and time and date routines
c        - no longer prevents overwrite of previously created files 
c        - split m31s.f into two files m311s.f and m312s.f
c        - exchange factor files now end in .nij
c
c     version 2.3.5 : 09-29-96 - cnz
c
c     version 2.3.4 : 06-15-96 - cnz
c
c     version 2.3.3 : 06-04-96 - cnz
c
c     version 2.3.2 : 03-07-96 - mrd
c
c     version 2.3.1 : 04-22-94 - cnz
c
c     version 2.3: 02-03-94 - cnz
c
c     version 2.2: 10-22-92 - jsd
c
c     version 2.1: 12-23-91
c
c     modified: 10-25-90  jdm
c***********************************************************************
c This file contains the main program,mont3d.  Below the main program 
c are the following miscellaneous routines which include the 
c miscillaneous routines and routines called in more than one file : 
c adios, cmdarg, errchk, errorstats, ferrorcheck, files, getdt, getint, 
c indexname, nijfile, nijheader, nstrlen, pcheck, rstfile and timing
c***********************************************************************
c*                                                                     *
c*       *     *   *****   *     *  *******   ****   *****             *
c*       **   **  *     *  **    *     *     *    *  *    *            *
c*       * * * *  *     *  * *   *     *          *  *    *            *
c*       *  *  *  *     *  *  *  *     *       ***   *    *            *
c*       *     *  *     *  *   * *     *          *  *    *            *
c*       *     *  *     *  *    **     *     *    *  *    *            *
c*       *     *   *****   *     *     *      ****   *****             *
c*                                                                     *
c***********************************************************************
c
      program mont3d
c
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     extra debugging info for Suns 
c
c     i = ieee_handler('set', 'common', 'hand')
c
c     initialize the parallel code or set iparflg to 0
c
      call parainit
c
c     define constants in circle.com
c
      pi = 3.1415926535
      pi2 = pi/2.
      p2i = 2.*pi
      dtor = pi/180.
      rtod = 1./dtor
c
      head(13) = 'v. 2.4f1'
      head(14) = '04-15-99'
      head(15) = '  f77  '                                              
c
c     initialize solution timing
c
      call timing (0)
c
c     set up files
c
      do 10 i = 1, ifil
        ifstat(i) = 0
        ifnflg(i) = 0
   10 continue
c
c      unit 1 - receives uncommented input file          .scr
c      unit 2 - receives restart information             .rst
c      unit 3 - receives geometry plot file              .plt
c      unit 4 - receives lost photon traces              .lst
c      unit 5 - console input
c      unit 6 - console output
c      unit 7 - input file with comment cards            .in
c      unit 8 - receives exchange numbers                .nij
c      unit 9 - receives photon traces if itraces .ne. 0 .trc
c      unit 10 - output print file                       .out
c      unit 11 - file of potential leaks used by mplot   .lks
c      unit 12 - block exchange number file (temporary)  .bni
c      unit 13 - temporary exchange number file (binary) .tni
c      unit 14 - temporary file for block info           .blk
c
      suffix( 1) = '.scr'
      suffix( 2) = '.rst'
      suffix( 3) = '.plt'
      suffix( 4) = '.lst'
      suffix( 5) = ' '
      suffix( 6) = ' '
      suffix( 7) = '.in'
      suffix( 8) = '.nij'
      suffix( 9) = '.trc'
      suffix(10) = '.out'
      suffix(11) = '.lks'
      suffix(12) = '.bni'
      suffix(13) = '.tni'
      suffix(14) = '.blk'
c
c     if file names are present on the command line use them
c     cmdarg only returns narg > 0 if there are arguments on the command line
c     and the code is compiled with comline.f or a similar file
c     otherwise use interactive mode
c
c     if statement below says if serial run or if master in parallel run..
c
      if ((iparflg.eq.0) .or. (mymid.eq.0)) then 
c
c     stub subroutine, see m3comline.f, m3nocom.f
c
         narg = nargcount()  
c    
         if (narg .gt. 0) then
            call cmdarg(narg) 
         else
            write (6,2000) ifln 
            read (5,1000) basename
c
            lenfbase = nstrlen(basename, ifln)
c
            if (lenfbase.le.2) then
               write (6,3001) lenfbase, basename
               call adios(2, 0, 0)
            end if 
         end if
c
c     name files not named in cmdarg
c
         do 20 i = 1, ifil
            if (ifnflg(i).eq.0) then
               lenf(i) = lenfbase
               aname(i) = basename (1:lenf(i)) // suffix(i)  
            end if 
  20     continue 
c
c     open output file
c
         open (10,file=aname(10),status='unknown',iostat=iost(10))  
         call ferrorcheck(10, 0)
c
c     create new input file without comment cards (& in col. 1)
c
         call files
c
c***********************************************************************
c      input phase                                                   
c***********************************************************************
c
         call input3
      end if 
c
c     if parallel code, spawn the workers
c
      if (iparflg.eq.1) then
         call paraspawn
      end if
c
c***********************************************************************
c     solution phase                                                 
c***********************************************************************
c
      call solve3
c
      call adios (1, 0, 0)
c
 1000 format (a)
c
 2000 format (2x,'****** mont3d ******' 
     $ / 2x,'Enter prefix for disk files - ', i5, ' characters or less' 
     $ // 5x,'input file MUST have extension .in')
c
 3001 format (1x,'ERROR from main program - Invalid name specified.'/
     $         'valid names must have at least two characters'         
     $ / 5x,'length - ',i2
     $ / 5x,'name   - ', a)
      end
c
c***********************************************************************
c
      subroutine adios (ns, nbk, ierval)
c
c***********************************************************************
c     subroutine to clean up files, report statistics  and exit program
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     standard closing only for nonparallel code or master
c
      if ((iparflg.eq.0) .or. (mymid.eq.0)) then
         call header
c
         if (ns.eq.2) then
            write (6,2001)
            write (10,2002)
         else
            write (10,2000)
            write (6,2000)
         end if 
C
c     calculate errors in results if done some calculating 
c     that is not doing a data check (idata.ne.1) and either
c     crashed during execution (nbk ne 0) or finished successfully
c     (ns.ne.2)
c
         if ((idata.ne.1) .and. ((nbk.ne.0) .or. ns.ne.2))  then 
            call errorstats 
         end if       
c
c     calculate and print solution time log
c     what is printed depends on what itim is set to
c     1 = clock time
c     0 = cpu time
c    -1 = no timing
c     the value of itim depends on which timing function is compiled into 
c     MONT3D
c     timing results also differ for the serial and parallel codes
c
         if (itim.ne.-1) then
c
c     print timing results
c
            call timing (3)
            sum = 0.
            do 100 i = 1,3
               sum = sum + cpuio(i)
  100       continue 
c
            if (sum.le.0.) then
               timepert = 0.
            else
               timepert = rnump/sum
            end if  
c
            if (iparflg.eq.0) then  
c
c     serial timing results
c
               if (cpuio(2).le.0.) then
                  timepers = 0.
               else
                  timepers = rnump/cpuio(2)
               end if     
c   
               write (10, 2020) cpuio, sum, rnump, lost, timepers, 
     $                          timepert
               write (6,  2020) cpuio, sum, rnump, lost, timepers, 
     $                          timepert
            else
c
c     parallel timing results
c
               write (10, 2021) sum, rnump, lost, timepert
               write (6,  2021) sum, rnump, lost, timepert
            end if 
c
c      tell whether timing is CPU or wall clock
c

            if (itim.eq.0) then
               write (10, 2022) 
               write (6,  2022)
            else if (itim.eq.1) then 
               write (10, 2023) 
               write (6,  2023)
            end if                        
         else
            write (10, 2024) rnump, lost
            write (6,  2024) rnump, lost
         end if 
c
c     clean up files before exit
c
         if (ns.eq.2) then 
            do 190 i = 1, ifil                                                
               if (ifstat(i) .gt. 0) then                                      
                  close (i,status='keep') 
               end if
 190        continue  
         else         
            if (ifstat(1) .gt. 0) then                                        
               close (1,status='delete')                                      
            end if                                                             
            do 200 i = 2, ifil                                                
               if (ifstat(i) .gt. 0) then                                      
                  close (i,status='keep') 
               end if
  200       continue
         end if
      end if
c
c     special handling of parallel code       
c
      if (iparflg.eq.1) then
         call paradios (ns, nbk, ierval)
      else                                                           
         stop
      end if
c
 2000 format (////5x,'normal termination'////)
 2001 format (////10x,'ERROR termination, see output file'////)
 2002 format (//10x,'- - -   ERROR termination   - - -'/
     $ / 10x,'timing information may not be accurate'/)
 2020 format (19x,' s o l u t i o n   t i m e   l o g '//
     $ / 5x,'time for input phase                    = ',e12.5,' secs'
     $ / 5x,'time for solution phase                 = ',e12.5,' secs'
     $ / 5x,'time for cleaning up                    = ',e12.5,' secs'
     $ / 5x,'total run time                          = ',e12.5,' secs'
     $ / 5x,'total number of photons emitted         = ',e12.5,
     $ / 5x,'total number of photons lost            = ',i10, 
     $ / 5x,'photons per second (solution phase)     = ',f12.3,
     $ / 5x,'photons per second (total run)          = ',f12.3)
 2021 format (19x,' s o l u t i o n   t i m e   l o g '//
     $ / 5x,'total run time                          = ',e12.5,' secs'
     $ / 5x,'total number of photons emitted         = ',e12.5,
     $ / 5x,'total number of photons lost            = ',i10, 
     $ / 5x,'photons per second (total run)          = ',f12.3)
 2022  format (
     $ / 5x, 'all results are given in CPU time')
 2023  format (
     $ / 5x, 'all results are given in wall clock time')
 2024  format (
     $ / 5x,'total number of photons emitted         = ',e12.5
     $ / 5x,'total number of photons lost            = ',i10)
c
      end
c
c***********************************************************************
c
      subroutine cmdarg(narg)
c
c***********************************************************************
c     This subroutine parses the command line to extract file names
c     specified there. Uses the stub getcomarg, if no command line 
c     parcing commands are supported by the compiler, narg is always set
c     to 0 and this function is not used. See comline.f and nocom.f
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'                                  
c    
      character*(ilarg) argv                                               
c
      i = 1                                                             
  100 continue
c
c     stub subroutine, see m3comline.f, m3nocom.f
c                                                          
      call getcomarg(i,argv)                                               
      nch = nstrlen(argv,ilarg)                                                
c
c     check for proper usage
c
      if (nch .lt. 2) then                                              
        write(6,3001)                                                   
        call adios(2, 0, 0) 
      end if                                                             
c
c     find which file is being specified
c     check restart file
c
      if( (argv(1:2) .eq. '-r') .or. (argv(1:2) .eq. '-R') .or.         
     $   (argv(1:2) .eq. 'r=') .or. (argv(1:2) .eq. 'R=') ) then        
        nfile = 2                                                       
        ifnflg(2) = 1                                                     
c
c     check plot file
c
      else if( (argv(1:2) .eq. '-p') .or. (argv(1:2) .eq. '-P') .or.    
     $   (argv(1:2) .eq. 'p=') .or. (argv(1:2) .eq. 'P=') ) then        
        nfile = 3                                                       
        ifnflg(3) = 1                                                     
c
c     check lost photon trajectories file
c
      else if( (argv(1:2) .eq. '-m') .or. (argv(1:2) .eq. '-M') .or.    
     $   (argv(1:2) .eq. 'm=') .or. (argv(1:2) .eq. 'M=') ) then        
        nfile = 4                                                       
        ifnflg(4) = 1                                                     
c
c     check input file
c
      else if( (argv(1:2) .eq. '-i') .or. (argv(1:2) .eq. '-I') .or.    
     $   (argv(1:2) .eq. 'i=') .or. (argv(1:2) .eq. 'I=') ) then        
        nfile = 7                                                       
        ifnflg(7) = 1                                                     
c
c     check exchange factor file
c
      else if( (argv(1:2) .eq. '-e') .or. (argv(1:2) .eq. '-E') .or.    
     $   (argv(1:2) .eq. 'e=') .or. (argv(1:2) .eq. 'E=') ) then        
        nfile = 8                                                       
        ifnflg(8) = 1                                                     
c
c     check traces file
c
      else if( (argv(1:2) .eq. '-t') .or. (argv(1:2) .eq. '-T') .or.    
     $   (argv(1:2) .eq. 't=') .or. (argv(1:2) .eq. 'T=') ) then        
        nfile = 9                                                       
        ifnflg(9) = 1                                                     
c
c     check output file
c
      else if( (argv(1:2) .eq. '-o') .or. (argv(1:2) .eq. '-O') .or.     
     $   (argv(1:2) .eq. 'o=') .or. (argv(1:2) .eq. 'O=') ) then        
        nfile = 10                                                      
        ifnflg(10) = 1                                                    
c
c     check leaks file
c
      else if( (argv(1:2) .eq. '-l') .or. (argv(1:2) .eq. '-L') .or.     
     $   (argv(1:2) .eq. 'l=') .or. (argv(1:2) .eq. 'L=') ) then        
        nfile = 12                                                      
        ifnflg(12) = 1                                                    
c
c     check family name
c
      else if( (argv(1:2) .eq. '-f') .or. (argv(1:2) .eq. '-F') .or.   
     $   (argv(1:2) .eq. 'f=') .or. (argv(1:2) .eq. 'F=') ) then        
        nfile = 5                                                       
        ifnflg(5) = 1                                                     
c
c     if none of the above - error
c
      else                                                              
        write(6,3002)                                                   
        call adios(2, 0, 0) 
      end if                                                             
c
c    read file name
c
      if (nch .eq. 2) then                                              
        i = i + 1                                                       
        if (i .gt. narg) then                                          
          write(6,3003)                                                 
          call adios(2, 0 , 0)
        end if                                                           
        call getcomarg(i,argv)                                             
        aname(nfile) = argv                                             
      else                                                              
        aname(nfile) = argv(3:nch)                                      
      end if   
c
      lenf(nfile) = nstrlen(aname(nfile), ifln) 
c 
      i = i + 1                                                         
      if (i .le. narg) then
         goto 100
       end if                                          
c
c     sort out this mess, specify base name for unspecified files
c
      if (ifnflg(5) .eq. 1) then                                          
        basename = aname(5) 
        lenfbase = lenf(5)                                   
      else if ((ifnflg(7).eq.1) .and. (ifnflg(8).eq.1)                      
     $         .and. (ifnflg(10).eq.1)) then                              
        basename = aname(7)  
        lenfbase = lenf(7)                                  
      else                                                              
        write(6,3004)                                                   
        call adios(2, 0, 0) 
      end if                                                             
c
      return                                                            
c
 3001 format (' ERROR - Command line cannot be correctly parsed,'       
     $     ,/,' please refer to the manual for correct usage')          
 3002 format (' ERROR - Invalid file type specifer on command line,'    
     $     ,/,' please refer to the manual for correct usage')   
 3003 format (1x,'ERROR from commandarg - Invalid name specified.'/
     $         'valid names must have at least two characters')              
 3004 format (' ERROR - No name for MONT3D input file specified,'       
     $     ,/,' file name must be explictly specified, or infered'     
     $     ,/,' from specified family name')
      end   
c
c***********************************************************************
c
      subroutine errchk (jch,ibch, ie, nptot)
c
c***********************************************************************
c     subroutine to calculate the error in an exchange fraction matrix.
c     npemit for the surface for which the error is determined.
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'    

      if (nptot.eq.0) then
         error(jch,ibch) = 0.0
         return
      end if
c
      sum = 0.0
      totinv = 1./nptot
c
c     main loop over all fractions, generate errors and sums
c        - error is confidence interval * frac sub i
c
      do 10 i = 1, nsurf
         efrac = npabs(i,ie)*totinv
         deltat = sqrt(efrac * (1.0 - efrac))
         sum = sum + deltat
   10 continue
c
c     average absolute error
c
      error(jch,ibch) = zee*sum/(nsurf*sqrt(float(nptot)))
c
      return
      end 
c
c***********************************************************************
c
      subroutine errorstats 
c
c***********************************************************************
c    Subroutine to calculate statistics on the errors for the surfaces
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      parameter (small = 1d-10)
c
c     counters over all bands
c
      itotconverged = 0
      itotdone = 0
      itotnemit = 0
c
c     get statistics for each band
c
      do 1000 ib = 1,nbands
         eravg = 0.
         ermax = -1.d30
         ermin = 1.d30
         minsurf = 1
         maxsurf = 1
         ndcount = 0
         necount = 0
         numconverged = 0
c
         do 500 ns = 1, nsurf
c
c  count surfaces not done yet 
c  (surfaces not done are less than within machine precision below 0) 
c
            if (error(ns,ib).le.-small) then
               ndcount = ndcount + 1
c
c   count surfaces that are not emitting 
c   the only other time error is 0 is when all photons go to 1 surface
c
            else if (error(ns,ib).le.small) then
               necount = necount + 1
            else
               eravg = eravg + error(ns,ib)
c
               if (error(ns,ib).le.errmax(ns)) then
                  numconverged = numconverged + 1
               end if
c
               if (error(ns,ib).lt.ermin) then
                  ermin = error(ns,ib)
                  minsurf = ns
               end if
               if (error(ns,ib).gt.ermax) then
                  ermax = error(ns,ib)
                  maxsurf = ns
               end if
            end if
  500    continue 
c
         if (ndcount.gt.0) then
            write (6,2000) ib, ndcount, nsurf
            write (10,2000) ib, ndcount, nsurf
            ndone = nsurf - ndcount
         else
            ndone = nsurf
         end if  
c
         nemitting = ndone - necount
         if (nemitting.eq.0) then
            eravg = 0
         else
            eravg = eravg/nemitting
         end if  
c
         itotconverged = itotconverged + numconverged
         itotdone = itotdone + ndone
         itotnemit = itotnemit + necount
c
c     write results for a single band
c
         write ( 6,2001) ib, necount, ndone, numconverged,nemitting,
     $                    eravg, ermin, minsurf,ermax,maxsurf
         write ( 10,2001) ib, necount, ndone, numconverged,nemitting,
     $                    eravg, ermin, minsurf,ermax,maxsurf
 1000 continue
c
c     write results over all bands
c
      if (nbands.gt.1) then
         write ( 6,2002) nsurf*nbands , itotdone, itotconverged,
     $                   itotnemit 
         write (10,2002) nsurf*nbands, itotdone, itotconverged, 
     $                   itotnemit
      end if
c
      return
c
 2000 format (/1x,'WARNING for band ',i3 
     $ /5x, 'results for ', i5,' out of ',i5,' surfaces ' 
     $ /5x,' have NOT been calculated yet!'/)
 2001 format (/1x,'Convergence information for band ',i3, 
     $ /5x, i5, ' out of the ', i5, ' completed surfaces did not emit ' 
     $ /5x,'and ', i5, ' out of the', i5, 
     $ ' emitting  surfaces converged.' 
     $ /5x, 'for the emitting surfaces: ' 
     $ /5x,'   Average error = ',e10.4 
     $ /5x,'   Minimum error = ',e10.4,'   on surface',i5 
     $ /5x,'   Maximum error = ',e10.4,'   on surface',i5/)
 2002 format (/1x,'In all bands, out of the ',i6,' surfaces,' 
     $ /5x, i6,' are completed, ',i6,' converged, '  
     $ /5x, 'and ', i6 ,' did not emit.'/)
c
      end
c
c***********************************************************************
c
      subroutine ferrorcheck (iunit, nbk)
c
c***********************************************************************
c     subroutine to check for a file error and exit if needed 
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c error handling for files
c
      if (iost(iunit).ne.0) then 
         write (6,3000) iunit, aname(iunit), iost(iunit)
         call adios (2, nbk, 0)
      end if
c
      ifstat(iunit) = 1
      return
c
 3000 format (1x,'error opening file no - ',i2,': name - ',a/  
     $   5x,'iostatus = ',i5 )
c
      end 
c
c***********************************************************************
c
      subroutine files
c
c***********************************************************************
c     subroutine to prep input file                                  
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      character*1 kard
      dimension kard(80)
c
c     open required files
c
      open (7,file=aname(7),status='old',iostat=iost( 7))       
      call ferrorcheck(7, 0)
      open (1,file=aname(1),status='unknown',iostat=iost( 1))   
      call ferrorcheck(1, 0)
c
c     create new input file 'name.scr' without
c     comment cards (those with '&' in column 1)
c
  100 read (7,1000,end=200) kard 
      if (kard(1).eq.'&') then
         goto 100
      end if
      write (1,1000) kard
      goto 100
  200 close (7,status='keep')
      ifstat(7) = -1
c
      rewind 1
c
      return
c
 1000 format (80a1)
c
      end
c
c***********************************************************************
c
      subroutine getdt (atim,adat)
c
c***********************************************************************
c     get atim and adat from system. Uses stub, getdate, which allows  
c     it to run on systems with no date function but then date and time  
c     picked intial seed are constant, see m3fdate.f, m3f90date.f, and 
c     nodate.f for details
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      character*2 amon,aday,amin,ahour,asec
      character*4 ayear                         
      character*8 atim, adat
      character*24 adate                                          
c
c     stub subroutine, see m3fdate.f, m3f90date.f, and m3nodate.f
c
      call getdate(asec, amin, ahour, aday, amon, ayear)                       
c
c     creation of adat and atim
c
      adat(1:2) = amon(1:2)                                             
      adat(3:3) = '/'                                                   
      adat(4:5) = aday(1:2)                                             
      adat(6:6) = '/'                                                   
      adat(7:8) = ayear(3:4)
c
      atim(1:2) = ahour(1:2)
      atim(3:3) = ':'                                                   
      atim(4:5) = amin(1:2)                                             
      atim(6:6) = ':'                                                   
      atim(7:8) = asec(1:2)                                            
c
c     get integers from ascii 
c
      call getint (ayear(3:4),iyear,2)  
      if ((iyear.lt.0) .or. (iyear.gt.100)) then
         iyear = 1
         print *,'error: invalid integer value for the year - set to 1'
      end if                                  
      call getint (amon(1:2),imon,2) 
      if ((imon.lt.1) .or. (imon.gt.12)) then
         imon = 1
      print *,'error: invalid integer value for the month - set to 1'
      end if                                     
      call getint (aday(1:2),iday,2) 
      if ((iday.lt.1) .or. (iday.gt.31)) then
         iday = 1
         print *,'error: invalid integer value for the day - set to 1'
      end if                                    
      call getint (ahour(1:2),ihour,2)  
      if ((ihour.lt.0) .or. (ihour.gt.23)) then
         ihour = 1
         print *,'error: invalid integer value for the hour - set to 1'
      end if                                      
      call getint (amin(1:2),imin,2)  
      if ((imin.lt.0) .or. (imin.gt.59)) then
         imin = 1
      print *,'error: invalid integer value for the minute - set to 1'
      end if                                    
      call getint (asec(1:2),isec,2)
      if ((isec.lt.0) .or. (isec.gt.59)) then
         isec = 1
      print *,'error: invalid integer value for the second - set to 1'
      end if                                      
c
c     set initial seed max unsigned integer = 2147483647
c     max value = 2011037599
c
      iseed0 =  mod(iyear,2**5) + imon*2**5 + iday*2**9 + 
     $             ihour*2**14 + imin*2**19 + isec*2**25
c
      return
      end
c
c***********************************************************************
c
      subroutine getint (a,ia,nchars)
c
c***********************************************************************
c     subroutine to get integer from ascii
c***********************************************************************
c
      include 'mont3d.par'
c
      character*(*) a
      integer*4 i,ia,mult
c
      ia = 0
      mult = 1
c
      do 100 n = nchars,1,-1
         if (a(n:n).eq.'0' .or. a(n:n).eq.' ') then
            i = 0
         else if (a(n:n).eq.'1') then
            i = 1
         else if (a(n:n).eq.'2') then
            i = 2
         else if (a(n:n).eq.'3') then
            i = 3
         else if (a(n:n).eq.'4') then
            i = 4
         else if (a(n:n).eq.'5') then
            i = 5
         else if (a(n:n).eq.'6') then
            i = 6
         else if (a(n:n).eq.'7') then
            i = 7
         else if (a(n:n).eq.'8') then
            i = 8
         else if (a(n:n).eq.'9') then
            i = 9
         else 
            write (6, 3001) a(n:n), mult
            write (10, 3001) a(n:n), mult 
            i = 0
         end if
         ia = ia + i*mult
         mult = mult*10
  100 continue
c
      return
c
 3001 format (//2x,'warning from getint ---'
     $ / 5x,'nonnumeric character, ', a1, ', in the  ',i5, ' place '
     $ / 5x,'setting digit to 0 and continuing'/)
       end
c
c***********************************************************************
c
      subroutine header
c
c***********************************************************************
c     print page heading                                             
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      character*8 star
c
      data star/'********'/
c
      write (10,2000) (star,k=1,9)
      write (10,2001) (head(i),i=1,6),(head(i),i=13,15)
      write (10,2002) (star,k=1,9)
c
      return
c
 2000 format (//3x,'***',9a8)
 2001 format (3x,6a8,3(1x,a8))
 2002 format (3x,'***',9a8//)
c
      end
c
c***********************************************************************
c
      subroutine indexname(i,k)
c
c***********************************************************************
c     form the file name , fname, for member i of file with suffix, k, 
c     number of digits in the index controled by the parameter, iimag
c     input arguments:                                                 
c            i        family member index for member i                  
c            k        unit number for suffix                       
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      character*1 ni
      character*(iimag) indexpart
c
      dimension ni(0:9)
      data ni/'0','1','2','3','4','5','6','7','8','9'/
c
      if (i.ge.10**iimag - 1) then
        write (6,3000) aname(k)
        call adios(2, i, 0)
      end if
c
      ii = i
      do 100 l = 1, iimag
         jj = iimag + 1 - l
         ll = mod(ii,10**l)
         ii = ii - ll
         indexpart(jj:jj) = ni(ll/(10**(l - 1)))
 100  continue
c  
      if (ifnflg(k).eq.1) then
         aname(k) = aname(k)(1:lenf(k))//indexpart
      else     
         aname(k) = aname(k)(1:lenf(k))//indexpart//suffix(k)
      end if
c
      return
c
 3000 format (1x,'error termination from indexname'
     $ / 5x,'family member index exceeds 10**(iimag) - 1 for file - ', 
     $ a,
     $ / 12x,'you must increase the parameter iimag in'
     $ / 12x,'the file mont3d.par and recompile all source files'
     $ / 15x,'------ STOPPING ------'//)
c
      end
c
c***********************************************************************
c
      subroutine nijfile (iaction, nbk) 
c
c***********************************************************************
c     Subroutine to initialize the nij files (iaction.eq.ifinit), or read 
c     or write a block of results to the block .bni files (iaction = 
c     (ifrdbk, ifwrtbk) or combine or split the nij file (iaction =
c     (ifcom, ifsplit)
c     Note: exchange numbers are written to the .out file with action
c              ifcom, if that is what the user wants
c           subroutine should be called with ifinit before called
c              by any other fashion
c           all .nij, .bni and .tni files are only opened or closed 
c              in this subroutine
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     small is the fractional error allowed between inputted values and
c           exchange factor values     
c
      parameter (small = 1.d-4)
c
      dimension icntrl(ncntrl), icntrl_temp(ncntrl)
      dimension tmparr(isrf)
c
      save icntrl, lrec13
c
      if (iaction.eq.ifinit) then
c
c     intialize values needed for the exchange number file head
c     integer control values
c
         icntrl(1) = 3
         icntrl(2) = nsurf
         icntrl(3) = 2
         icntrl(4) = nbands
         icntrl(5) = nummat
c
         lrec13 = 4*nsurf
c
c    initialization specific to restart (crashed or noncrashed)
c

         if (irstflg.lt.0) then
c 
c     check information from the previous run
c     read the information from the previous exchange factor file
c     for a crashed run, this contains only header information
c     check that exchange number file exists
c
            open (8,file=aname(8),status='old',iostat=iost(8))
            if (iost(8).ne.0) then
               write(6,3101) aname(8)
               write(10,3101) aname(8)
               call adios(2,0, 0)
            end if  
            ifstat(8) = 1       
c
c     read and check control info
c
            read (8,9001) icntrl_temp
            do 220 i = 1, ncntrl
               if (icntrl(i).ne.icntrl_temp(i)) then
                  write(6,3201) i, icntrl(i), icntrl_temp(i)
                  write(10,3201) i, icntrl(i), icntrl_temp(i)
                  call adios(2, 0, 0)
               end if
  220       continue
c
c     check areas
c
            read (8,9002) (tmparr(i), i = 1, nsurf)
            do 230 i = 1, nsurf
               if ((abs(area(i) - tmparr(i))/area(i)).gt.small) then
                  write(6,3202) i, area(i), tmparr(i)
                  write(10,3202) i, area(i), tmparr(i)
                  call adios(2, 0, 0)
               end if
  230       continue
c
c     check emittances
c
            do 260 ib = 1, nbands
               read (8,9002) (tmparr(i), i = 1, nsurf)
               do 250 i = 1, nsurf
                  if (abs((tmparr(i)-embar(matnum(i),ib))
     $               /embar(matnum(i),ib)).gt. small) then 
                  write (6,3203) ib, i, embar(matnum(i),ib), tmparr(i)
                  write(10,3203) ib, i, embar(matnum(i),ib), tmparr(i)
                     call adios(2, 0, 0)
                  end if
 250           continue
 260        continue
c

            if (icrsh.eq.1) then
c
c     restart from a crash 
c     close nij file holding the header information
c
               close (8, status = 'keep')
               ifstat(8) = -1
c
c     check existance of other block exchange number files
c     and check photon counts
c 
               do 400 nn = 1, nblocks
                  if ((initialflg.eq.1) .and. (nbkfin(nn).eq.0)) then
c
c     block not done in crashed initial run, skip checking it
c
                     goto 400 
                  end if
c
c     check current block exchange number file and calculate the errors
c
                  call indexname(nn, 12)
                  open (12,file=aname(12),status='old',iostat=iost(12))
                  if (iost(12).ne.0) then
                     write(6,3102)  aname(12)
                     write(10,3102) aname(12)
                     call adios(2,0, 0)
                  end if  
                  ifstat(12) = 1  
                  do 330 ie = nbkpntr(nn) + 1, nbkpntr(nn+1)
                     ne = nbkemitlist(ie)
                     ib = (ne - 1)/nsurf + 1
                     jemit = mod(ne - 1, nsurf) + 1
                     read (12,9001) (npabs(i,1), i = 1,nsurf)
                     call pcheck(jemit,ib, 1)
                     call errchk(jemit, ib, 1, npwold(jemit,ib))
 330              continue
c
                  close (12, status = 'keep')
                  ifstat(12) = -1
 400           continue
            else if (icrsh.eq.0) then
c
c     restart not from a crash, prep files
c     create temporary file
c
               open(13,file=aname(13),access='direct',status='unknown',
     $              iostat = iost(13), form='unformatted',recl=lrec13)
               call ferrorcheck(13, 0) 
c
c     read from .nij file check photon count 
c     write to binary temp file and calc past errors
c
               do 320 ne = 1, netot
                  ib = (ne - 1)/nsurf + 1
                  jemit = mod(ne - 1, nsurf) + 1
c
                  read (8,9001) (npabs(i,1), i = 1, nsurf)
                  call pcheck(jemit, ib, 1)
                  write (13,rec=ne) (npabs(i,1), i = 1, nsurf)
c
c     NOTE THIS DOES NOT CARRY OVER WHEN DONE IN PARALLEL, NEED TO IGNORE THIS 
c     IN SOLVE
c
                  if (npwold(jemit,ib).gt.0) then
c
c     photons have been emitted, check error
c
                     call errchk(jemit, ib, 1, npwold(jemit,ib))
                     if (error(jemit,ib).le.errmax(jemit)) then
c
c     already converged, no photons left to do
c
                         nphtn(jemit,ib) = 0
                      else if (nphtn(jemit,ib).gt.0) then
c
c     surface not converged, if it is emitting photons, 
c     set error negative to suggest this
c
                         error(jemit,ib) = -error(jemit,ib)
                      end if  
                  else if (nphtn(jemit,ib).le.0) then
c
c     surface not emitted in past or future, set error to 0
c     to denote nonemitting
c
                     error (jemit,ib) = 0.
                  end if
 320           continue
c
               close (13, status = 'keep')
               ifstat(13) = -1
               close (8, status = 'delete')
               ifstat(8) = -1              
            end if
         end if
c
c     end restart (crash or no crash) specific initialization
c
         if (icrsh.eq.0) then
c
c     writing header of .nij file 
c     used for check in case of crash
c     do for any case where no crash
c
            open (8,file=aname(8), status='unknown', iostat = iost(8))
            call ferrorcheck(8, 0)
c
            call nijheader (icntrl)
c           
            close (8, status = 'keep')
            ifstat(8) = -1
         end if
      else if (iaction.eq.ifrdbk) then
c
c     read a block bni file
c
         call indexname(nbk, 12)
         open (12,file=aname(12), status='old', iostat = iost(12))
         call ferrorcheck(12, 0)

         do 500 n = 1, nedo            
            read (12, 9001) (npabs(i,n), i = 1, nsurf)
 500     continue
c
         close (12, status='keep') 
         ifstat(12) = -1 
      else if (iaction.eq.ifwrtbk) then
c
c     write a block bni file
c
         call indexname(nbk, 12)
         open (12,file=aname(12), status='unknown', iostat = iost(12))
         call ferrorcheck(12, 0)

         do 600 n = 1, nedo            
            write (12, 9001) (npabs(i,n), i = 1, nsurf)
 600     continue
c
         close (12, status='keep') 
         ifstat(12) = -1 
      else if (iaction.eq.ifcom) then
c
c     write out a combined .nij file
c     first combine into a temporary binary file (unit 13)
c
         open(13, file=aname(13), access='direct', status='unknown',
     $        iostat = iost(13), form='unformatted', recl=lrec13)
         call ferrorcheck(13, 0)
c
c     write each emitter into the binary file from the block exchange 
c     number files
c
         write (6,2100)
         do 700 nn = 1, nblocks
            call indexname(nn, 12)
            open (12,file=aname(12),status='old',iostat=iost(12))
            call ferrorcheck(12, 0)
            do 650 ie = nbkpntr(nn) + 1, nbkpntr(nn+1)
               ne = nbkemitlist(ie)
               read (12,9001) (npabs(i,1), i = 1,nsurf)
               write (13, rec=ne) (npabs(i,1), i = 1,nsurf)
 650        continue
c
            close (12, status = 'keep')
            ifstat(12) = -1
 700     continue  
c
c        all bni files read correctly, now delete them before create nij
c
         do 720 nn = 1, nblocks
            call indexname(nn, 12)
            open (12,file=aname(12),status='unknown',iostat=iost(12))
            call ferrorcheck(12, 0)  
            close (12, status='delete')
            ifstat(12) = -1
 720     continue
c
c     now write out nij file
c     
         write (6,2101)          
         open (8,file=aname(8), status='unknown', iostat = iost(8))
         call ferrorcheck(8, 0)
c 
c     write header
c
         call nijheader (icntrl)        
c
c     write out results
c
         do 740 ne = 1, netot
            read (13,rec=ne) (npabs(i,1), i = 1,nsurf)
            write (8,9001) (npabs(i,1), i = 1,nsurf)
            if (iprnt(1).ne.0) then 
c
c     write results to .out file if the user wants to
c
               ib = (ne - 1)/nsurf + 1
               jdo = mod(ne - 1, nsurf) + 1
c
               if (npwold(jdo,ib).eq.0) then 
                  write (10,2000) ib, jdo, area(jdo)   
               else 
                  if (error(jdo,ib).gt.errmax(jdo)) then
                     write (10,2001) ib, jdo, npwold(jdo,ib), 
     $               embar(matnum(jdo),ib), area(jdo), error(jdo,ib)
                  else
                     write (10,2002) ib, jdo, npwold(jdo,ib),
     $               embar(matnum(jdo),ib), area(jdo), error(jdo,ib)
                  end if
c
                  odenom = 1.d0/real(npwold(jdo,ib))         
                  write (10,2010) (kk,npabs(kk,1)*odenom, kk=1,nsurf)
c                 write (10,2011) (kk, npabs(kk,1), kk=1,nsurf) 
               end if 
           end if           
 740     continue 
c
c     close the files, tni file no longer needed
c
         close (8, status='keep')
         ifstat(8) = -1
         close (13, status='delete')
         ifstat(13) = -1
      else if (iaction.eq.ifsplit) then
c
c     split into ascii files, open tni file first
c
         open (13,file=aname(13),access='direct',status='old',
     $         iostat = iost(13), form='unformatted',recl=lrec13)
         call ferrorcheck(13, 0) 
c
         do 900 nn = 1, nblocks
            call indexname(nn, 12)
            open (12,file=aname(12),status='unknown',iostat=iost(12))
            call ferrorcheck(12, 0)    
            do 880 ie = nbkpntr(nn) + 1, nbkpntr(nn+1)
               ne = nbkemitlist(ie) 
               read (13, rec=ne) (npabs(i,1), i = 1,nsurf)
               write (12, 9001) (npabs(i,1), i = 1,nsurf)
 880        continue
c
            close (12, status='keep')
            ifstat(12) = -1
 900     continue
c
         close (13, status='delete')
         ifstat(13) = -1
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
 2000 format (/20x,'e x c h a n g e   f r a c t i o n s'/  
     $  2x,'band ',i2,'  surface ',i5,  2x,'area ',e12.5,2x, 
     $  ' - no emissions')
 2001 format (/20x,'e x c h a n g e   f r a c t i o n s'/  
     $  2x,'band ',i2,'  surface ',i5,'  tot phtns ',i10,  
     $  '  embar ',f8.5,/,2x,'area ',e12.5,2x,'error ',e11.4,  
     $  ' - not converged',/,2x,'8( j  fabs(i,j) )')
 2002 format (/20x,'e x c h a n g e   f r a c t i o n s'/  
     $  2x,'band ',i2,'  surface ',i5,'  tot phtns ',i10,  
     $  '  embar ',f8.5,/,2x,'area ',e12.5,2x,'error ',e11.4,  
     $  ' - converged',/,2x,'8( j  fabs(i,j) )')
c
 2010 format (8(1x,i4,1x,f7.5))
 2011 format ('photons:',8(1x,i4,1x,i8))  
c
 2100 format (/
     $ 'Now writing exchange numbers from each block nij file (.bni)',
     $ / 'to a temporary binary file (.tni)')
 2101 format (/
     $ 'Now writing the exchange numbers from the temporary ',
     $ / 'binary file (.tni) to the .nij file'/)
c
 3001 format (//10x,' ERROR from subroutine nijfile'
     $ / 12x,'Invalid value of iaction ' 
     $ / 12x,'Value entered  - ',i10
     $ / 15x,'------ STOPPING ------'//)
c
 3101 format (///8x,'error - exchange number file', a40, ' needed'/
     $  11x,'for restart is missing!'
     $ / 15x,'------ STOPPING ------'//)
 3102 format (///8x,'error - block exchange number file',a40,' needed'/
     $  11x,'for restart is missing!'
     $ / 15x,'------ STOPPING ------'//)
c
 3201 format (1x,'--- control parameter error from subroutine nijfile',
     $  ' ---', 
     $  / 5x,'icntrl(',i1,') = ',i10, 
     $  / 5x,'value read from exchange factor file = ',i10, 
     $  / 5x,'these numbers don''t agree and they must!' 
     $ / 15x,'------ STOPPING ------'//)
 3202 format (1x,'--- area error from subroutine nijfile ---' 
     $  / 2x,'surface no. ',i5 
     $  / 5x,'area calculated = ',e12.5, 
     $  / 5x,'area read from exchange factor file = ',e12.5, 
     $  / 5x,'these numbers don''t agree and they must!' 
     $ / 15x,'------ STOPPING ------'//)
 3203 format (1x,'--- emittance error from subroutine nijfile ---' 
     $  / 2x,'band ',i5,5x,'surface no. ',i5 
     $  / 5x,'emittance calculated = ',e12.5, 
     $  / 5x,'emittance read from exchange factor file = ',e12.5, 
     $  / 5x,'these numbers don''t agree and they must!' 
     $ / 15x,'------ STOPPING ------'//)
c
 9001 format (7(i10,1x))
 9002 format (6(e12.5,1x))
 9003 format (a1)
c
      end
c
c***********************************************************************
c
      subroutine nijheader (icntrl)
c
c***********************************************************************
c     subroutine to write out the .nij file header to the .nij file (unit 8)
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
      dimension icntrl(ncntrl)
c
      write (8, 9001) icntrl
      write (8, 9002) (area(i), i = 1, nsurf) 
      do 300 ib = 1, nbands
         write (8,9002) (embar(matnum(i), ib), i = 1, nsurf)
 300  continue  
c
      return
 9001 format (7(i10,1x))
 9002 format (6(e12.5,1x))
      end
c  
c***********************************************************************
c
      function nstrlen(instring, maxlen) 
c
c***********************************************************************
c     This subroutine counts the number of nonblank characters in a string
c     it checks up to length maxstring although any length string can 
c     be used
c***********************************************************************
c
      include 'mont3d.par'
c
      character*(*) instring
c
      do 100 n = 1,maxlen
         if (instring(n:n).eq.' '.or.instring(n:n).eq.'\0') then
            goto 200
         end if
  100 continue
c
  200 nstrlen = n - 1  
c
      return
      end
c
c***********************************************************************
c
      subroutine pcheck (jtest, ibd, ie)
c
c***********************************************************************
c     subroutine to check photons stored in npabs(.,ie)                      
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c    compare values read to npwold
c
      npsum = 0
      do 350 i = 1, nsurf
         npsum = npsum + npabs(i,ie)
  350 continue
c
      if (npsum.ne.npwold(jtest,ibd)) then
         write ( 6,3001) ibd,jtest,npwold(jtest,ibd),npsum
         write (10,3001) ibd,jtest,npwold(jtest,ibd),npsum
         call adios (2, 0, 0)
      end if
c
      return
c
 3001 format (1x,'--- photon no. error from subroutine pcheck ---' 
     $  / 2x,'band ',i5,5x,'surface no. ',i5 
     $  / 5x,'number of photons read from restart file = ',i10 
     $  / 5x,'number of photons read from exchange file = ',i10 
     $  / 5x,'these numbers don''t agree and they must!' 
     $ / 15x,'------ STOPPING ------'//)
c
      end
c
c***********************************************************************
c
      subroutine rstfile (iaction, nbk) 
c
c*********************************************************************** 
c     Subroutine to read (iaction = ifrd), or write (iaction = ifwrt) 
c     the restart file
c     nbk is the current block being processed
c     File is opened and closed in the subroutine
c     note that the variable iparflgold is stored in the common contro
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     note that the state of the RNG is only read/written if the single
c     processor version is used
c
      if (iaction.eq.ifrd) then
c
c     read the restart information
c
         open(2,file=aname(2),status='old',iostat = iost(2))
         if (iost(2).ne.0) then
            write(6,3101)
            write(10,3101)
            call adios(2,0, 0)
         end if   
c
         read (2,9001) iparflgold               
         read (2,9001) ((npwold(j,i), j = 1, nsurf), i = 1,nbands)
c
         if (iparflgold.eq.0) then
c
c        read in the RNG state if previously a single processor run
c        if it is not needed, it will be set in ranset later
c
            read (2,9001) iseed, it1, it2 
         end if
c
         if (icrsh.eq.1) then
            read (2, 9001) (nbkfin(k), k = 1,nblocks)
         end if 
c
         close (2, status = 'keep')
         ifstat(2) = -1
      else if (iaction.eq.ifwrt) then
c
c     write out the restart information
c 
         open(2,file=aname(2),status='unknown',iostat = iost(2))
         call ferrorcheck(2, nbk)
c
         write (2,9001) iparflg               
         write (2,9001) ((npwold(j,i), j = 1, nsurf), i = 1,nbands)
c
         if (iparflg.eq.0) then
            write (2,9001) iseed, it1, it2 
         end if
c
         write (2, 9001) (nbkfin(k), k = 1,nblocks)
c
         close (2, status='keep')
         ifstat(2) = -1
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
 3001 format (//10x,' ERROR from subroutine rstfile'
     $ / 12x,'Invalid value of iaction ' 
     $ / 12x,'Value entered  - ',i10
     $ / 15x,'------ STOPPING ------'//)
 3101 format (///8x,'ERROR - restart file (.rst) needed'/
     $  11x,'for restart is missing'
     $ / 15x,'------ STOPPING ------'//)
c
 9001 format (7(i10,1x))
c
      end
c
c***********************************************************************
c
      subroutine timing (k)
c
c***********************************************************************
c     subroutine to accumulate cpu or clock time. Uses stub, 
c     nonstandtiming, which determines if CPU or clock timing is done.
c     if compiler supports no timing routines, no timing is done.
c      see m3etiming.f, m3ctiming.f m3f0timing. and m3notiming.f
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'                                             
c
      character*8 tstr, dstr                                            
c
c     initialize if k = 0
c
      if (k.eq.0) then
         do 100 i = 1,3
            cpuio(i) = 0.
 100     continue
c
         call getdt (tstr,dstr)                                         
         head(11)(1:8) = tstr(1:8)
         head(12)(1:8) = dstr(1:8)
c
      end if
c
c     stub subroutine, see m3etiming.f, m3ctiming.f m3f0timing.f, m3notiming.f
c
      call nonstandtiming(k)
c
      return
      end
