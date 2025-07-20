c*********************************************************************     
c
c     m3f90timing.f
c
c*********************************************************************
c     Subroutine required for the timing MONT3D for f90 compliant 
c     compilers using clock time. Mainly used in the parallel 
c     version of the code. Machines that can not support this subroutine
c     should either use m3notiming.f which disables timing or 
c     another machine specific version of this file.
c     This subroutine is used in the subroutine timing.
c*********************************************************************
c
      subroutine nonstandtiming (k)
c
c*********************************************************************
c    subroutine to accumulate clock time
c    requires the function date_and_time     
c    itim set to 1 which means results are clock time
c    tp is a real*8 used by all timing routines to store the previous
c    time                         
c*********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'                                             
c
      character*5 zone
      character*8 date
      character*10 time     
      integer*4 itimes(8)
      integer jdays(12)   
c
      data (jdays(i),i=1,12)/0,31,59,90,120,151,181,212,243,273,304,334/ 
c
      call date_and_time(date, time, zone, itimes)
c
      iyear  = itimes(1)
      imon = itimes(2)
      iday = itimes(3)
      ihour  = itimes(5)
      imin = itimes(6)
      isec = itimes(7)
      imil = itimes(8)
      idays = iday + jdays(imon)
c
c     correction for leap year
c     note every year divisible by 100 but not 400 (i.e. 1700, 1800, 2100)
c     is not a leap year. 
c
      if ((mod(iyear,4).eq.0 .and. mod(iyear,100).ne.0) .or.
     $   (mod(iyear,400).eq.0)) then 
         if (imon.gt.2) then
            ndays = ndays + 1
         end if
      end if
c
c     compute number from the beginning of the year 
c
      isecs = isec + 60*(imin + 60*(ihour + 24*idays))
c
c     initialize if k=0
c
      if (k.eq.0) then
         itim = 1
         tp = isecs
      else
         t = isecs
c
         if (t.ge.tp) then
            cpuio(k) = cpuio(k) + t - tp
            tp = t
         else
c
c    new year started, add seconds from previous year
c    account for leap years
c
            ipyr = iyear - 1
            if ((mod(ipyr,4).eq.0 .and. mod(ipyr,100).ne.0) .or.
     $         (mod(ipyr,400).eq.0)) then
               ndays = 366
            else 
               ndays = 365
            end if 
            nsecs = 60*60*24*ndays
c
            cpuio(k) = cpuio(k) + t - tp + nsecs
            tp = t            
         end if
      end if
c
      return
      end
