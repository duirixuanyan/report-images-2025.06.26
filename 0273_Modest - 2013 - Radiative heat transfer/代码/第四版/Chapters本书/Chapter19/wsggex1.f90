   PROGRAM Main
   IMPLICIT NONE
   INTEGER    :: i,il,ilo,j,nl=20
   DOUBLE PRECISION  :: a(0:3)=(/.466,.337,.159,.038/),k(0:3)=(/0.,.267,4.65,71.7/)
   DOUBLE PRECISION  :: psiex,psip1,L,psisex,psisp1,en,fac
   DOUBLE PRECISION  :: as(4,2)= RESHAPE((/.348,.246,.143,.034,.118,.091,.016,.004/),(/4,2/))
   DOUBLE PRECISION  :: ks(4,2)= RESHAPE((/5.41,5.68,10.05,77.11,27.49,27.76,32.14,99.19/),(/4,2/))
   open(unit=8,file='wsggex1.dat',status='unknown')
   write(8,1)
 1  format(1x,'TITLE = "WSGG"'/ &
     1x,'VARIABLES = L,psiex,psisex,psip1,psisp1'/ &
     1x,'ZONE')
   fac=sqrt(3.)/2.
   do ilo=-2,0
   do il=0,nl-1
    L=(1.+9.*il/nl)*10.**ilo
! NO SOOT
    psiex=0.
    psip1=0.
    do i=1,3
     psiex=psiex+a(i)*(1-2.*en(3,k(i)*L))
     psip1=psip1+a(i)*2./(1.+fac/dtanh(fac*k(i)*L))
    enddo
! SOOT
    psisex=0.
    psisp1=0.
    do i=1,4
    do j=1,2
      psisex=psisex+as(i,j)*(1-2.*en(3,ks(i,j)*L)) 
      psisp1=psisp1+as(i,j)*2./(1.+fac/dtanh(fac*ks(i,j)*L))
    enddo
    enddo
    write(8,10) L,psiex,psisex,psip1,psisp1
10	format(5f10.5)
   enddo
   enddo
    stop
    end
	FUNCTION E1(X)
      IMPLICIT REAL*8 (A-H,O-Z)
      IF(X.GT.1.) GOTO 10
      A0=-.57721566
      A1= .99999193
      A2=-.24991055
      A3= .05519968
      A4=-.00976004
      A5= .00107857
      E1=A0+X*(A1+X*(A2+X*(A3+X*(A4+X*A5))))-DLOG(X+1.D-8)
      RETURN
   10 A1= 8.5733287401
      A2=18.0590169730
      A3= 8.6347608925
      A4=  .2677737343
      B1= 9.5733223454
      B2=25.6329561486
      B3=21.0996530827
      B4= 3.9584969228
      E1=(X*(A3+X*(A2+X*(A1+X)))+A4)/(X*(B3+X*(B2+X*(B1+X)))+B4)*DEXP(-X)/X
      RETURN
      END
      FUNCTION EN(N,X)
      IMPLICIT REAL*8 (A-H,O-Z)
         EN=E1(X)
      IF(N.GT.1) THEN
         EX=DEXP(-X)
         DO 10 I=2,N
  10     EN=(EX-X*EN)/(I-1.D0)
         ENDIF
      RETURN
      END
 