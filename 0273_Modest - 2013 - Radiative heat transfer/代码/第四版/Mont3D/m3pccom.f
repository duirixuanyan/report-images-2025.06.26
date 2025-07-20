c*********************************************************************     
c
c     m3pccom.f
c
c*********************************************************************
c     Subroutines required for the command line interface on Windows PCs
c*********************************************************************
c
      subroutine getcomarg(i, instring) 
c
c*********************************************************************
c     This subroutine gets the ith argument off the command line
c     it requires the function getarg
c*********************************************************************
c
      include 'mont3d.par'
      character*(*) instring
      integer*2 n
      n = i
c
      call getarg(n,instring)  
      return
      end
c
c*********************************************************************
c
      function nargcount()                                           
c
c*********************************************************************
c     This subroutine counts the number of arguments on the command line
c     it requires the function iargc
c*********************************************************************
c
      include 'mont3d.par'
c
      nargcount = iargc()  
      return
      end
