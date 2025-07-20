!!    Program Fire_SNB_mel_1D
!!    A. Soufiani and Ph. Riviere, october 2011
!!
!!    Radiative transfer calculation in a 1D slab using
!!    Statistical narrow-band model with the parameters publishe in :
!!              Ph. Riviere, A. Soufiani, IJHMT, 2012 for CO, CO2, H2O
!!              M.Y. Perrin, A. Soufiani, JQSRT 2007 for CH4
!!    The Curtis-Godson approximation
!!
!!    The medium is a H2O-CO2-CO-CH4-transparent gas-soot mixture
!!      at temperaures in the range 300--5000K and pressures in the range 0.1--100 atm
!!    
!!    Black walls or, otherwise: uncorrelated approximation for wall relexion
!!
!!***************************
!!  Input files:
!!***************************
!!    - ETR1D_SNB.don, contains physical and chemical inputs of the 1D slab:
!!         • number of sublayers (nx), ratios frh2o,frco2,frco,frch4,frsoot,frx to be applied
!!           to the inputs for molar fractions and soot, total pressure (ptot) and
!!           number of directions (nmu) uniformly discretzed in mu=cos(theta) 
!!         • for each sublayer i:
!!            the abscissa of the central point of the sublayer (in cm)
!!            the temperature of the sublayer (K)
!!            molar fractions in the sublayer, H2O (xh2o), CO2 (xco2), CO(xco) and CH4 (xch4)
!!            soot volume fraction in the sublayer
!!         • temperatures of the two walls (1 and n)
!!         • gray emissivities of the two walls (1 and n)
!!   - SNBWN, contains the wavenumbers and associated band widths for the calculations
!!     this file must end with a negative number to stop the wave number loop
!!   - SNBH2O, SNB parameters for H2O
!!   - SNBCO2, SNB parameters for CO2
!!   - SNBCO, SNB parameters for CO
!!   - SNBCH4, SNB parameters for CH4
!!***************************
!!  Output file:
!!***************************
!!   - ETR1D_SNB.res, contains:
!!     • for each sublayer: 
!!       index, position (cm), temperature (K), total radiative source term (absorbed-emitted, in W.m-3)
!!     • for the walls: index (1 or n), temperature (K), total radiative flux (emitted-absorbed in W.m-2)
!!            
PROGRAM Fire_SNB_mel_1D 
IMPLICIT NONE
INTEGER(4) :: n,nx,nmu
INTEGER(4) :: ip,n2
INTEGER(4) :: ih2o,ico2,ico,ich4
REAL(8) :: dlo,lumtra,lumini
REAL(8) :: c1,c2,nbond,dnbond,xmin,xsootmin,frh2o,frco2,frco,frch4,frx,frsoot
REAL(8) :: ptot,em1,emn,fl1,fln,ksoot
REAL(8), dimension(:), allocatable :: t,h,xh2o,xco2,xco,xch4,xsoot
REAL(8), dimension(:), allocatable :: gamah2o,gamaco2,gamaco,gamach4
REAL(8), dimension(:), allocatable :: x,tx,xh2ox,xco2x,xcox,xch4x,xsootx,ptx
REAL(8), dimension(:), allocatable :: pt,lum
REAL(8), dimension(:,:), allocatable :: bh2omoy,bco2moy,bcomoy,bch4moy
REAL(8), dimension(:,:), allocatable :: kh2omoy,kco2moy,kcomoy,kch4moy,xksootmoy
REAL(8), dimension(:,:), allocatable :: vec,hth2o,htco2,htco,htch4,htsoot
REAL(8) :: kh2o(48,449),kco2(48,323),kco(48,194),kch4(18,248)
REAL(8) :: dh2o(48,449),dco2(48,323),dco(48,194),dch4(18,248)
REAL(8) :: bh2o(48,449),bco2(48,323),bco(48,194),bch4(18,248)
REAL(8),parameter :: pi=3.1415926535898_8
LOGICAL :: lxh2o,lxco2,lxco,lxch4,lxsoot
open(unit=1,file='ETR1D_SNB_mel.don')
open(unit=2,file='ETR1D_SNB_mel.res')
read(1,*)
read(1,*) nx,frh2o,frco2,frco,frch4,frsoot,frx,ptot,nmu
!!
!! allocate the variables
!!
allocate(t(1:nx+2)); allocate(h(1:nx)); allocate(xh2O(1:nx))
allocate(xco2(1:nx)); allocate(xco(1:nx)); allocate(xch4(1:nx)); allocate(xsoot(1:nx))
allocate(gamah2o(1:nx)); allocate(gamaco2(1:nx)); allocate(gamaco(1:nx))
allocate(gamach4(1:nx))
allocate(x(1:nx)); allocate(tx(1:nx+2)); allocate(xh2Ox(1:nx)); allocate(xch4x(1:nx))
allocate(xco2x(1:nx)); allocate(xcox(1:nx)); allocate(xsootx(1:nx))
allocate(ptx(1:nx+2)); allocate(pt(1:nx+2)); allocate(lum(1:nx+2))
allocate(bh2omoy(1:nx,1:nx)); allocate(bco2moy(1:nx,1:nx)); allocate(bcomoy(1:nx,1:nx))
allocate(bch4moy(1:nx,1:nx))
allocate(kh2omoy(1:nx,1:nx)); allocate(kco2moy(1:nx,1:nx)); allocate(kcomoy(1:nx,1:nx))
allocate(kch4moy(1:nx,1:nx))
allocate(hth2o(1:nx,1:nx)); allocate(htco2(1:nx,1:nx)); allocate(htco(1:nx,1:nx))
allocate(htch4(1:nx,1:nx))
allocate(xksootmoy(1:nx,1:nx)); allocate(htsoot(1:nx,1:nx))
allocate(vec(1:nx+2,1:nx+2))
!!
!! reading abscissae, temperature, molar fraction fields, soot volume fractions
!!
do ip=1,nx
   read(1,*) x(ip),tx(ip+1),xh2ox(ip),xco2x(ip),xcox(ip),xch4x(ip),xsootx(ip)
   xh2ox(ip)=xh2ox(ip)*frh2o
   xco2x(ip)=xco2x(ip)*frco2
   xcox(ip)=xcox(ip)*frco
   xch4x(ip)=xch4x(ip)*frch4
   xsootx(ip)=xsootx(ip)*frsoot
   x(ip)=x(ip)*frx
enddo
read(1,*) tx(1),tx(nx+2)
read(1,*) em1,emn
!!
!! calling the calculation routine
!!
CALL SRACAL
write(6,*) 'Radiative power (absorbed-emitted, in W.m-3)'
write(2,*) 'Radiative power (absorbed-emitted, in W.m-3)'
do ip=2,nx+1
      write(6,*) ip,x(ip-1),tx(ip),ptx(ip)
      write(2,*) ip,x(ip-1),tx(ip),ptx(ip)
enddo
write(6,*) 'Wall flux (emitted-absorbed in W.m-2)'
write(6,*) 'wall 1',tx(1),ptx(1)
write(2,*) 'Wall flux (emitted-absorbed in W.m-2)'
write(2,*) 'wall 1',tx(1),ptx(1)
write(6,*) 'wall n',tx(nx+2),ptx(nx+2)
write(2,*) 'wall n',tx(nx+2),ptx(nx+2)
!!
!!  subroutines and functions
!!
contains
!!    **************************************************************
!!    * SUBROUTINE SRACAL
!!    * Calculation of the local emitted power 
!!    **************************************************************
SUBROUTINE SRACAL
IMPLICIT NONE
INTEGER(4) :: i,j,k
REAL(8) :: ps,flt1,fltn
ps=0.d0
!!     minimum molar fraction to be taken into account
xmin=1.0d-12
xsootmin=1.d-20
!!
do i=1,nx+2
     t(i)=tx(i)
enddo
!!     H vector contains sublayer widths 
do i=2,nx-1
    h(i)=(x(i+1)-x(i-1))/2.
enddo
h(1)=x(2)-x(1)
h(nx)=x(nx)-x(nx-1)
n=nx+2
n2=nx
lxh2o=.false.
lxco2=.false.
lxco=.false.
lxch4=.false.
lxsoot=.false.
do i=1,n2
      xh2o(i)=xh2ox(i)
      IF (xh2o(i).gt.xmin) THEN
        lxh2o=.true.
      ELSE
        xh2o(i)=xmin
      ENDIF
      xco2(i)=xco2x(i)
      IF (xco2(i).gt.xmin) THEN
        lxco2=.true.
      ELSE
        xco2(i)=xmin
      ENDIF
      xco(i)=xcox(i)
      IF (xco(i).gt.xmin) THEN
        lxco=.true.
      ELSE
        xco(i)=xmin
      ENDIF
	  xch4(i)=xch4x(i)
      IF (xch4(i).gt.xmin) THEN
        lxch4=.true.
      ELSE
        xch4(i)=xmin
      ENDIF
	  xsoot(i)=xsootx(i)
	  IF (xsoot(i).gt.xsootmin) THEN
        lxsoot=.true.
      ELSE
        xsoot(i)=xsootmin
      ENDIF	  
enddo
do i=1,n
    lum(i)=0.d0
enddo
!!     Initialisation
do i=1,n
  pt(i)=0.d0
enddo
!!
!!      Reading SNB parameters k and 1/delta
!!
CALL PARAM
!!
!!      Calculation of hth2o,htco2,htco,htch4
!!
do i=1,n2
  do j=i,n2
    hth2o(i,j)=0.d0
    htco2(i,j)=0.d0
    htco(i,j)=0.d0
	htch4(i,j)=0.d0
	htsoot(i,j)=0.d0
    do k=i,j
      hth2o(i,j)=hth2o(i,j)+h(k)*xh2o(k)*ptot
      htco2(i,j)=htco2(i,j)+h(k)*xco2(k)*ptot
      htco(i,j)=htco(i,j)+h(k)*xco(k)*ptot
	  htch4(i,j)=htch4(i,j)+h(k)*xch4(k)*ptot
	  htsoot(i,j)=htsoot(i,j)+h(k)*xsoot(k) ! in cm
    enddo
	hth2o(j,i)=hth2o(i,j)
	htco2(j,i)=htco2(i,j)
	htco(j,i)=htco(i,j)
	htch4(j,i)=htch4(i,j)
	htsoot(j,i)=htsoot(i,j)
  enddo
enddo
!!
!!      Calculation of line broadening coefficients
!!
CALL CGAMA
!!
!!     -------------------------------------------------------------
!!     ----------- Wave number loop---------------------------------
!!     -------------------------------------------------------------
OPEN(UNIT=4,FILE='SNBWN',STATUS='OLD',FORM='FORMATTED')
flt1=0.d0
fltn=0.d0
nbond=1.D0
do while(nbond.gt.0.d0)
  READ(4,*) nbond,dnbond
    IF(nbond.gt.0.d0) then
	 dlo=1./(100.*(nbond-dnbond/2.))-1./(100.*(nbond+dnbond/2.))
	 ksoot=5.5d0*nbond ! in cm-1
!!
!!   searching spectral indexes
!!
	 CALL INDICE
!!
!!    Calculating the chromatic intensities vector
      do i=1,n
        lum(i)=LUMIN(t(i),c1,c2)
      enddo
!!
!!    Calculating the matrix emissivity-transmissivity-absorptivity
      CALL TRANSM
!!
!!    Calculating the dissipated power
      CALL PUISDIP
!!
      flt1=flt1+dlo*fl1
      fltn=fltn+dlo*fln
!!    -------------------------------------------------------------
    ENDIF
enddo
CLOSE(4)
!!
do i=1,n2
  ptx(i+1)=pt(i+1)
enddo
ptx(1)=flt1
ptx(n2+2)=fltn
!!
END SUBROUTINE SRACAL
!!
!!     **************************************************************
!!     *  SUBROUTINE PARAM
!!     *  Reading SNB parameters for CO, CO2, H2O and CH4
!!     **************************************************************
SUBROUTINE PARAM
IMPLICIT NONE
INTEGER(4) :: i,j
Real(8):: xxnu
OPEN(UNIT=45,FILE='SNBCO')
OPEN(UNIT=46,FILE='SNBCO2')
OPEN(UNIT=47,FILE='SNBH2O')
OPEN(UNIT=48,FILE='SNBCH4')
!!
!!   READING THE PARAMETERS
!!
do I=1,194
   READ(45,*) xxnu,(KCO(J,I),J=1,48)
enddo
do I=1,194
   READ(45,*) xxnu,(DCO(J,I),J=1,48)
enddo
close(45)
do I=1,323
   READ(46,*) xxnu,(KCO2(J,I),J=1,48)
enddo
do I=1,323
   READ(46,*) xxnu,(DCO2(J,I),J=1,48)
enddo
close(46)
do I=1,449
   READ(47,*) xxnu,(KH2O(J,I),J=1,48)
enddo
do I=1,449
   READ(47,*) xxnu,(DH2O(J,I),J=1,48)
enddo
close(47)
do I=1,248
     READ(48,*) xxnu,(KCH4(J,I),J=1,18)
enddo
do I=1,248
     READ(48,*) xxnu,(DCH4(J,I),J=1,18)
enddo
close(48)

END SUBROUTINE PARAM
!!
!!     *************************************************************************
!!     *  SUBROUTINE INDICE
!!     *  Calculation of the spectral index corresponding to a given xave number
!!     *************************************************************************     
SUBROUTINE INDICE
IMPLICIT NONE
!!
!!     Planck's function parameters
c1=(11.909D-17)*(100.*nbond)**5.
c2=(1.4388D-2)*(100.*nbond)

!!    Calculating the indexes
ih2o=-9
IF (lxh2o) then
  IF(nbond.GE.50.0.AND.nbond.LE.11250.) then
      ih2o=INT((nbond-50.)/25.)+1
  ENDIF
ENDIF
ico2=-9
IF (lxco2) then
      IF(nbond.GE.250.0.AND.nbond.LE.8300.) then
       ico2=INT((nbond-250.)/25.)+1
      ENDIF
ENDIF
ico=-9
IF (lxco) then
      IF(nbond.GE.1600.0.AND.nbond.LE.6425.) then
       ico=INT((nbond-1600.)/25.)+1
      ENDIF
ENDIF
ich4=-9
IF (lxch4) then
  IF(nbond.GE.25.0.AND.nbond.LE.6200.) then
      ich4=INT((nbond-25.)/25.)+1
  ENDIF
ENDIF
END SUBROUTINE INDICE

!!     **************************************************************
!!     *  FUNCTION LUMIN
!!     *  To calculate the chromatic intensity
!!     **************************************************************
FUNCTION LUMIN(tt,cc1,cc2)
IMPLICIT NONE
REAL(8) :: tt,cc1,cc2,lumin
      LUMIN=cc1/(DEXP(cc2/tt)-1.)
END FUNCTION LUMIN
!!
!!     **************************************************************
!!     *  SUBROUTINE CGAMA
!!     *  to calculate mean line half-widths
!!     **************************************************************
SUBROUTINE CGAMA
IMPLICIT NONE
INTEGER(4) :: i,j,k
REAL(8) :: t296,xn2
do j=1,n-2
      t296=296.d0/t(j+1)
      xn2=1.-xh2o(j)-xco2(j)-xco(j)
!!
      gamah2o(j)=0.462*xh2o(j)*t296+ &
	             (0.079*(xn2+xco(j))+0.106*xco2(j))*t296**0.5
!!
      gamaco2(j)=0.07*xco2(j)+0.058*(xn2+xco(j))+0.10*xh2o(j)
	  gamaco2(j)=gamaco2(j)*t296**0.7
!!
      gamaco(j)=0.075*xco2(j)*t296**0.6 + &
	            0.12*xh2o(j)*t296**0.82 + &
				0.06*(xco(j)+xn2)*t296**0.7
      gamach4(j)=0.051*t296**0.75
      gamah2o(j)=gamah2o(j)*ptot
      gamaco2(j)=gamaco2(j)*ptot
      gamaco(j)=gamaco(j)*ptot
      gamach4(j)=gamach4(j)*ptot
enddo
!
END SUBROUTINE CGAMA
!!
!!     *******************************************************************
!!     *  SUBROUTINE TRANSM
!!     *  Calculation of the matrix emissivity-transmissivity-absorptivity
!!     *******************************************************************
SUBROUTINE TRANSM
IMPLICIT NONE
INTEGER(4) :: i,j,k
INTEGER(4) :: n1,it,itch4,i1,j1,ll,i2
REAL(8) :: rt,rtch4,sb,sv,sk,valh2o,valco2,valco,valch4,mu2,dmu
REAL(8) :: x1h2o,x2h2o,x1co2,x2co2,x1co,x2co,x1ch4,x2ch4
REAL(8) :: ssi,F
REAL(8), dimension(:), allocatable :: xkh2o,xkco2,xkco,xkch4
REAL(8), dimension(:), allocatable :: xbh2o,xbco2,xbco,xbch4
REAL(8), dimension(:), allocatable :: xdh2o,xdco2,xdco,xdch4
REAL(8), dimension(:,:), allocatable :: emis
n1=n-1
n2=n-2
allocate(xkh2o(n2)); allocate(xkco2(n2)); allocate(xkco(n2)); allocate(xkch4(n2))
allocate(xbh2o(n2)); allocate(xbco2(n2)); allocate(xbco(n2)); allocate(xbch4(n2))
allocate(xdh2o(n2)); allocate(xdco2(n2)); allocate(xdco(n2)); allocate(xdch4(n2))
allocate(emis(n2+2,n2+2))
!!                    
!!     --------------------------------------------------------------
!!     * Vector of avraged SNB barameters 
do j=1,n2                                                    
      CALL INTERPOL(t(j+1),rt,it)
	  CALL INTERPOLCH4(t(j+1),rtch4,itch4)
	  
      IF (ih2o.GT.0) THEN
        xkh2o(j)=kh2o(it,ih2o)+rt*(kh2o(it+1,ih2o)-kh2o(it,ih2o))
        xdh2o(j)=dh2o(it,ih2o)+rt*(dh2o(it+1,ih2o)-dh2o(it,ih2o))
        xbh2o(j)=2.*pi*gamah2o(j)*xdh2o(j)
      ENDIF

      IF (ico2.GT.0) THEN
        xkco2(j)=kco2(it,ico2)+rt*(kco2(it+1,ico2)-kco2(it,ico2))
        xdco2(j)=dco2(it,ico2)+rt*(dco2(it+1,ico2)-dco2(it,ico2))
        xbco2(j)=2.*pi*gamaco2(j)*xdco2(j)
      ENDIF

      IF (ico.GT.0) THEN
        xkco(j)=kco(it,ico)+rt*(kco(it+1,ico)-kco(it,ico))
        xdco(j)=dco(it,ico)+rt*(dco(it+1,ico)-dco(it,ico))
        xbco(j)=2.*pi*gamaco(j)*xdco(j)
      ENDIF
	  
	  IF (ich4.GT.0) THEN
        xkch4(j)=kch4(itch4,ich4)+rtch4*(kch4(itch4+1,ich4)-kch4(itch4,ich4))
        xdch4(j)=dch4(itch4,ich4)+rtch4*(dch4(itch4+1,ich4)-dch4(itch4,ich4))
        xbch4(j)=2.*pi*gamach4(j)*xdch4(j)
      ENDIF
enddo                                                         
!!     * Matrix of avraged SNB parameters
IF (ih2o.GT.0) THEN
do i=1,n2
	kh2omoy(i,i)=xkh2o(i)
	bh2omoy(i,i)=xbh2o(i)
	IF (i.eq.n2) cycle
	do j=i+1,n2
       sk=0.d0
       sb=0.d0
       sv=hth2o(i,j)
      do k=i,j
       sk=sk+h(k)*xkh2o(k)*xh2o(k)*ptot
       sb=sb+h(k)*xkh2o(k)*xbh2o(k)*xh2o(k)*ptot
      enddo
       kh2omoy(i,j)=sk/sv
       kh2omoy(j,i)=kh2omoy(i,j)
       bh2omoy(i,j)=sb/sk
       bh2omoy(j,i)=bh2omoy(i,j)
	enddo
enddo
ENDIF
!!
IF (ico2.GT.0) THEN
do i=1,n2
	kco2moy(i,i)=xkco2(i)
	bco2moy(i,i)=xbco2(i)
	IF (i.eq.n2) cycle
	do j=i+1,n2
       sk=0.d0
       sb=0.d0
       sv=htco2(i,j)
	  do k=i,j
       sk=sk+h(k)*xkco2(k)*xco2(k)*ptot
       sb=sb+h(k)*xkco2(k)*xbco2(k)*xco2(k)*ptot
      enddo
       kco2moy(i,j)=sk/sv
       kco2moy(j,i)=kco2moy(i,j)
       bco2moy(i,j)=sb/sk
       bco2moy(j,i)=bco2moy(i,j)
	enddo
enddo
ENDIF
!!
IF (ico.GT.0) THEN
do i=1,n2
    kcomoy(i,i)=xkco(i)
    bcomoy(i,i)=xbco(i)
    IF (i.eq.n2) cycle
    do j=i+1,n2
       sk=0.d0
       sb=0.d0
       sv=htco(i,j)
	  do k=i,j
       sk=sk+h(k)*xkco(k)*xco(k)*ptot
       sb=sb+h(k)*xkco(k)*xbco(k)*xco(k)*ptot
      enddo
       kcomoy(i,j)=sk/sv
       kcomoy(j,i)=kcomoy(i,j)
       bcomoy(i,j)=sb/sk
       bcomoy(j,i)=bcomoy(i,j)
    enddo
enddo
ENDIF
IF (ich4.GT.0) THEN
do i=1,n2
	kch4moy(i,i)=xkch4(i)
	bch4moy(i,i)=xbch4(i)
	IF (i.eq.n2) cycle
	do j=i+1,n2
       sk=0.d0
       sb=0.d0
       sv=htch4(i,j)
      do k=i,j
       sk=sk+h(k)*xkch4(k)*xch4(k)*ptot
       sb=sb+h(k)*xkch4(k)*xbch4(k)*xch4(k)*ptot
      enddo
       kch4moy(i,j)=sk/sv
       kch4moy(j,i)=kch4moy(i,j)
       bch4moy(i,j)=sb/sk
       bch4moy(j,i)=bch4moy(i,j)
	enddo
enddo
ENDIF

!! case of soots
!!
xksootmoy(:,:)=htsoot(:,:)*ksoot
!!
!!     Calculation of the borders of emissivity-transmissivity-absorptivity matrix
!!
do i=1,n                                                    
      emis(1,i)=0.d0                                                  
      emis(i,1)=0.d0                                                 
      emis(i,n)=0.d0                                                
      emis(n,i)=0.d0                                               
enddo
!!
!!     Calculation of current elements of emissivity-transmissivity-absorptivity matrix
!!
do i=2,n1
  i1=i-1
  do j=2,i
      j1=j-1
!!
!!    SNB parameters
      IF (ih2o.GT.0) THEN
      x1h2o=bh2omoy(i1,j1)/pi
      x2h2o=2.*kh2omoy(i1,j1)*hth2o(i1,j1)
      valh2o=x2h2o/x1h2o
      ELSE
      valh2o=0.d0
      ENDIF
      IF (ico2.GT.0) THEN
      x1co2=bco2moy(i1,j1)/pi
      x2co2=2.*kco2moy(i1,j1)*htco2(i1,j1)
      valco2=x2co2/x1co2
      ELSE
      valco2=0.d0
      ENDIF
      IF (ico.GT.0) THEN
      x1co=bcomoy(i1,j1)/pi
      x2co=2.*kcomoy(i1,j1)*htco(i1,j1)
      valco=x2co/x1co
      ELSE
      valco=0.d0
      ENDIF
	  IF (ich4.GT.0) THEN
      x1ch4=bch4moy(i1,j1)/pi
      x2ch4=2.*kch4moy(i1,j1)*htch4(i1,j1)
      valch4=x2ch4/x1ch4
      ELSE
      valch4=0.d0
      ENDIF
!!
      dmu=1.d0/dfloat(nmu)
      ssi=0.d0
      do k=1,nmu
        mu2=(k-0.5)*dmu
        ssi=ssi+2.*pi*mu2*dmu* &
        emm(kh2omoy(i1,j1),bh2omoy(i1,j1),hth2o(i1,j1)/mu2, &
        kco2moy(i1,j1),bco2moy(i1,j1),htco2(i1,j1)/mu2, &
		kcomoy(i1,j1),bcomoy(i1,j1),htco(i1,j1)/mu2, &
		kch4moy(i1,j1),bch4moy(i1,j1),htch4(i1,j1)/mu2, &
		xksootmoy(i1,j1)/mu2)
      enddo
      emis(i,j)=ssi
      emis(j,i)=ssi
  enddo
enddo
!!
!!     * Matrix VEC
do i=1,n                                            
    vec(i,i)=emis(i,i)
enddo                                    
	vec(2,1)=vec(2,2)                                    
	vec(n,n1)=vec(n1,n1)                                
do i=3,n1                                       
    vec(i,1)=emis(i,2)-emis(i-1,2) 
enddo                   
do i=2,n2                                     
    vec(n,i)=emis(n1,i)-emis(n1,i+1)    
enddo            
do i=3,n1                                   
    vec(i,i-1)=emis(i-1,i-1)+emis(i,i)-emis(i,i-1)
enddo
do i=4,n1                                 
      i1=i-1                                      
      i2=i-2                                     
   do j=2,i2                              
      vec(i,j)=emis(i1,j)+emis(i,j+1)-emis(i1,j+1)-emis(i,j)           
   enddo                                                        
enddo                                                       
vec(n,1)=pi-emis(n1,2)                                        
do i=1,n                                                  
  do j=i,n                                                 
      vec(i,j)=vec(j,i)                                          
  enddo                                              
enddo
deallocate(xkh2o); deallocate(xkco2); deallocate(xkco); deallocate(xkch4)
deallocate(xbh2o); deallocate(xbco2); deallocate(xbco); deallocate(xbch4)
deallocate(xdh2o); deallocate(xdco2); deallocate(xdco); deallocate(xdch4)
END SUBROUTINE TRANSM
!!
!!     **************************************************************
!!     *  SUBROUTINE INTERPOL
!!     *  rt and it values for temperature interpolation
!!     **************************************************************
SUBROUTINE INTERPOL(tt,rt,it)
IMPLICIT NONE
INTEGER(4) :: it
REAL(8) :: tt,rt
      IF(tt.GE.300.0) THEN
         IF(tt.LT.5000.0) THEN
            rt=(tt-300.0)/100.0
            it=INT(rt+1.0E-6)
            rt=rt-it
            it=it+1
         ELSE
            rt=1.0
            it=47
         ENDIF
      ELSE
         rt=0.d0
         it=1
      ENDIF
END SUBROUTINE INTERPOL
!!     **************************************************************
!!     *  SUBROUTINE INTERPOLCH4
!!     *  rt and it values for temperature interpolation
!!     **************************************************************
SUBROUTINE INTERPOLCH4(tt,rtch4,itch4)
IMPLICIT NONE
INTEGER(4) :: itch4
REAL(8) :: tt,rtch4
      IF(tt.GE.300.0) THEN
         IF(tt.LT.2000.0) THEN
            rtch4=(tt-300.0)/100.0
            itch4=INT(rtch4+1.0D-10)
            rtch4=rtch4-itch4
            itch4=itch4+1
         ELSE
            rtch4=1.0
            itch4=17
         ENDIF
      ELSE
         rtch4=0.d0
         itch4=1
      ENDIF
END SUBROUTINE INTERPOLCH4
!!
!!     **************************************************************
!!     *  SUBROUTINE PUISDIP
!!     *  Calculation of the volumetric source term
!!     **************************************************************
SUBROUTINE PUISDIP
IMPLICIT NONE
INTEGER(4) :: i,j,k
INTEGER i1,i2,n1,ij
REAL(8) :: ps,ss1,ssn,som1,somn,dnom,rad1,radn
REAL(8) :: p(1:nx+2)
n1=n-1
!!
!!    * calculation of wall radiosity
!!
dnom=1.-(1.-em1)*(1.-emn)*vec(n,1)*vec(n,1)/(pi*pi)
!!     write(6,*) 'c1',em1,emn,dnom
if(dnom.eq.0.d0) then
  rad1=0.d0
  radn=0.d0
  fl1=0.d0
  fln=0.d0
else
  ss1=0.
  ssn=0.
  do i=2,n1
      ss1=ss1+lum(i)*vec(1,i)
      ssn=ssn+lum(i)*vec(i,n)
  enddo
  som1=ss1+(emn*lum(n)*pi+(1.-emn)*ssn)*vec(n,1)/pi
  somn=ssn+(em1*lum(1)*pi+(1.-em1)*ss1)*vec(n,1)/pi
  rad1=(em1*lum(1)*pi+(1.-em1)*som1)/dnom
  radn=(emn*lum(n)*pi+(1.-emn)*somn)/dnom
  fl1=rad1-ss1-radn*vec(n,1)/pi
  fln=radn-ssn-rad1*vec(n,1)/pi
endif
!!   
!!     * exchanges between volumes
do i=2,n1                                        
  i1=i-1                                           
  i2=i+1                                          
!!                                                        
!!     Exchange of layer I with the walls
  p(i)=(rad1*vec(i,1)+radn*vec(i,n))/pi
  ps=ps+lum(i)*vec(1,i)*dlo*10.
!!                                                   
!!     Exchange of layer I with layers J
  IF(i.NE.2) then                     
   do j=2,i1                            
      p(i)=p(i)+lum(j)*vec(j,i)           
   enddo                                
  ENDIF
  IF(i.NE.n1) then              
    do j=i2,N1                      
      p(i)=p(i)+lum(j)*vec(j,i)      
    enddo                          
  ENDIF       
!!                                      
!!     Flux emitted by I
      p(i)=p(i)-2.*lum(i)*vec(i,i)                           
enddo                                                      
!!
!!    Chromatic balance for the layer I
do ij=2,n1
    pt(ij)=pt(ij)+p(ij)*dlo*100./h(ij-1)
enddo
!!
END SUBROUTINE PUISDIP
!!
!!     **************************************************************
!!     *  FUNCTION EMM
!!     *  Column emissivity from mean (Curtis-Godson) SNB parameters
!!     **************************************************************
FUNCTION emm(kkh2o,bbh2o,xxh2o,kkco2,bbco2,xxco2, &
kkco,bbco,xxco,kkch4,bbch4,xxch4,xksoot)
IMPLICIT NONE
REAL(8) :: kkh2o,bbh2o,xxh2o,kkco2,bbco2,xxco2,kkco,bbco,xxco, &
kkch4,bbch4,xxch4,xksoot
REAL(8) :: emm
REAL(8) :: v1,v2,vh2o,vco2,vco,vch4,vsuie
!!write(6,*) kkh2o,bbh2o,xxh2o,kkco2,bbco2,xxco2,kkco,bbco,xxco,kkch4,bbch4,xxch4,xksoot
IF (ih2o.GT.0) THEN
       v1=1.+2.*pi*kkh2o*xxh2o/bbh2o
       v2=v1**0.5 
       vh2o=bbh2o*(v2-1.)/pi
ELSE
       vh2o=0.
ENDIF
IF (ico2.GT.0) THEN
       v1=1.+2.*pi*kkco2*xxco2/bbco2
       v2=v1**0.5
       vco2=bbco2*(v2-1.)/pi
ELSE
       vco2=0.
ENDIF
IF (ico.GT.0) THEN
       v1=1.+2.*pi*kkco*xxco/bbco
       v2=v1**0.5
       vco=bbco*(v2-1.)/pi
ELSE
       vco=0.
ENDIF
IF (ich4.GT.0) THEN
       v1=1.+2.*pi*kkch4*xxch4/bbch4
       v2=v1**0.5 
       vch4=bbch4*(v2-1.)/pi
ELSE
       vch4=0.
ENDIF
IF (lxsoot) THEN
       vsuie=xksoot
ELSE
       vsuie=0.d0
ENDIF
      emm=1.-DEXP(-vh2o-vco2-vco-vch4-vsuie)
END FUNCTION emm
!!
END PROGRAM Fire_SNB_mel_1D 
