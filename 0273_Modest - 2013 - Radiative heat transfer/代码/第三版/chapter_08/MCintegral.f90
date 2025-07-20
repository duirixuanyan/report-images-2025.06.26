    program MCint
! THIS PROGRAM FINDS THE INTEGRAL FROM A TO B OF THE FUNCTION GIVEN BELOW 
! BY THE MONTE CARLO METHOD 
    IMPLICIT NONE
    INTEGER, PARAMETER :: numsmpl=10
    INTEGER :: i,N,in,idum=12345,numsmplhf,ns1=1
    REAL    :: qd(numsmpl),qdav,stddev,varmax,x,a,b,F
    REAL, PARAMETER :: pi=3.1415927
    REAL, EXTERNAL :: RAN1

!
!    F(x)=exp(-cos(10*x))*cos(sin(10*x))    
    F(x)=sin(x)    
    a=0.
    b=pi/2.
    varmax=0.002

    WRITE(*,1)
  1 format('no. of bundles    integral    std dev   rel.err(%)')
!
    N=1000
    numsmplhf=numsmpl/2

! loop to generate numsmpl 'samples'
  5 DO i=ns1,numsmpl
! initialize integral value
      qd(i)=0.
! loop over N bundles
      DO in=1,N
        x=a+(b-a)*ran1(idum)
        qd(i)=qd(i)+F(x)
      ENDDO   !in
      qd(i)=(b-a)*qd(i)/N
    ENDDO   !i
!
! find average value and std dev
    qdav=0.
    DO i=1,numsmpl
      qdav=qdav+qd(i)
    ENDDO   !i
    qdav=qdav/numsmpl
    stddev=0.
    DO i=1,numsmpl
      stddev=stddev+(qd(i)-qdav)**2
    ENDDO   !i
    stddev=sqrt(stddev/(numsmpl*(numsmpl-1)))/qdav
    WRITE(*,2) N*numsmpl,qdav,stddev*qdav,stddev*100
  2 format(4x,i10,1p2e12.4,0pf7.2)
    IF(stddev<varmax .and. qdav>1.e-12) GOTO 20
! combine pairs of samples and double number of bundles
    DO i=1,numsmplhf
    qd(i)=0.5*(qd(i)+qd(i+numsmplhf))
    ENDDO   !i
    N=2*N
    ns1=numsmplhf+1
    GOTO 5
 20 STOP
    END


      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      REAL ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1./IM,IQ=127773,IR=2836,&
        NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2e-7,RNMX=1.-EPS)
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then
        idum=max(-idum,1)
        do 11 j=NTAB+8,1,-1
          k=idum/IQ
          idum=IA*(idum-k*IQ)-IR*k
          if (idum.lt.0) idum=idum+IM
          if (j.le.NTAB) iv(j)=idum
11      continue
        iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=min(AM*iy,RNMX)
      return
      END
