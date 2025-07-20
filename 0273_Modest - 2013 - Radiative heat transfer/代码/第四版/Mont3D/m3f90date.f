c*********************************************************************     
c
c     m3f90date.f
c
c*********************************************************************
c     Subroutine required for obtaining the time and date for fortran 90
c     compliant compilers. Machines that can not support this subroutine
c     should either use m3nodate.f which disables timing or 
c     another machine specific version of this file.
c     This subroutine is used in the subroutine getdt.
c***********************************************************************
c
      subroutine getdate (asec, amin, ahour, aday, amon, ayear)
c
c***********************************************************************
c     get date and time from system
c     requires the function date_and_time                                     
c***********************************************************************
c
      include 'mont3d.par'
c
      character*2 amon,aday,amin,ahour,asec
      character*4 ayear   
      character*5 zone
      character*8 date
      character*10 time   
      integer itime(8)                                       
c
      call date_and_time(date, time, zone, itime)
c
      ayear(1:4) = date(1:4)
      amon(1:2) = date(5:6)
      aday(1:2) = date(7:8)
      ahour(1:2) = time(1:2)
      amin(1:2) = time(3:4)
      asec(1:2) = time(5:6)
c
      return 
      end            
