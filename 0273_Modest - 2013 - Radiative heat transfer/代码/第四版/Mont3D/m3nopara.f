c*********************************************************************     
c
c     m3nopara.f
c
c***********************************************************************
c     This file contains the parallel dummy routines for MONT3D
c     that are required for the code to compile a nonparallel 
c     version of the code.  Included are:
c     paradios, parainit, parasolve and paraspawn
c***********************************************************************
c
      subroutine paradios (ns, nb, ierval)
c
c***********************************************************************
c     exit routine for parallel code 
c***********************************************************************
c
      include 'mont3d.par'
c
c     use the arguments in dummy statements to prevent warnings 
c     from the compiler
c
      idummy1 = ns
      idummy2 = nb
      idummy3 = ierval
c
      return
      end
c
c***********************************************************************
c
      subroutine parainit
c
c***********************************************************************
c  subroutine to set iparflg to 0 (= nonparallel version of the code)
c***********************************************************************
c
      include 'mont3d.par'
      include 'mont3d.com'
c
c     set parallel code flag
c
      iparflg = 0
c
      return
      end
c
c***********************************************************************
c
      subroutine parasolve
c
c***********************************************************************
c     solve routine for parallel code 
c***********************************************************************
c
      include 'mont3d.par'
c
      return
      end
c
c***********************************************************************
c
      subroutine paraspawn
c
c***********************************************************************
c     subroutine to spawn the worker processes and set them up
c***********************************************************************
c
      include 'mont3d.par'
c
      return
      end 
