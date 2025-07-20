program TRANSCK
!!
IMPLICIT NONE
!!
integer(4)::ngauss,ntemp,nnu,nvf
!! DECLARATION OF THE VARIABLES
integer(4):: IGAUSS, INU, IVF, ITEMP, I1, I2
real(8):: XCO2, L1, T, CT1, CT2, CX1, CX2
real(8),allocatable:: K1(:,:,:,:),DNU1(:),SIG1(:),STAU(:),TEMP(:),XGAZ(:),AMEGA(:),kstar(:,:)
character(len=72):: NAME1, NAME2
!! ENTERING THE DATAS
WRITE (6,*) 'ENTER XCO2, T (K), L (CM) :'
READ (5,*) XCO2, T, L1
NAME1 = 'CKCO2'
WRITE (6,*) 'ENTER THE NAME OF THE RESULT FILE :'
READ (5,'(A72)') NAME2
call readparameters
call interpol_linear(T,TEMP,NTEMP,CT1,CT2,I1,'TEMPERATURE')
I2=1
!! CALCULATING THE TRANSMITTIVITY
kstar=CT1*K1(I1,I2,:,:)+CT2*K1(I1+1,I2,:,:)
kstar=kstar*XCO2*L1/(T*QCO2(T))
stau=matmul(exp(-kstar),amega)
OPEN(UNIT=15,FILE=NAME2)
DO INU=1, NNU
   WRITE(15,'(0PF5.1,1X,0PF8.1,1X,1PE10.4)') DNU1(INU), SIG1(INU), STAU(INU)
ENDDO
CLOSE(15)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
contains
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
subroutine readparameters
implicit none
integer(4)::igauss,itemp,ivf
open(1,file=name1,status='OLD')
read(1,*)
read(1,*) nnu,ngauss,ntemp,nvf
allocate(dnu1(nnu),sig1(nnu),STAU(nnu),temp(ntemp),xgaz(nvf),amega(ngauss),k1(1:NTEMP,1:NVF,1:NNU,1:NGAUSS))
allocate(kstar(1:nnu,1:ngauss))
read(1,*)
read(1,*)(amega(igauss),igauss=1,ngauss)
read(1,*)
read(1,*)(temp(itemp),itemp=1,ntemp)
read(1,*)
read(1,*)(xgaz(ivf),ivf=1,nvf)
do inu=1,nnu
   read (1,*) SIG1(INU), DNU1(INU)
   do igauss=1,ngauss
      read(1,*)
      do ivf=1,nvf
           read(1,'(9(5(1PE12.6,1X),/),3(1PE12.6,1X))') (K1(ITEMP,IVF,INU,IGAUSS),ITEMP=1,NTEMP)
      enddo
   enddo
enddo
close(1)
end subroutine readparameters
!!!!!!!!!
subroutine interpol_linear(t,ttab,nttab,c1,c2,itab,nomvariable)
implicit none
character(len=*)::nomvariable
real(8)::t,ttab(:),c1,c2
integer(4)::nttab,itab
if(t<ttab(1).or.t>ttab(nttab))then
   write(6,*) 'ERROR : THE '//trim(nomvariable)//' IS EITHER TOO LOW'
   write(6,*) 'OR TOO HIGH'
   stop
endif
itab=1
do while(t>ttab(itab+1))
     itab=itab+1
enddo
c1=(ttab(itab+1)-t)/(ttab(itab+1)-ttab(itab))
c2=(t-ttab(itab))/(ttab(itab+1)-ttab(itab))
end subroutine interpol_linear
!!!!!!!
function QCO2(t) result(q)
implicit none
real(8)::t,q,tcm1
real(8),parameter::B=3.916e-01_8,A1=1.353e+03_8,A2=6.72e+02_8,A3=2.396e+03_8,kb=1.4387752_8
tcm1=t/kb
q=tcm1/B/2._8*1._8/(1.-exp(-A1/tcm1))    &
  *1._8/(1.-exp(-A2/tcm1))**2/(1.-exp(-A3/tcm1))
end function QCO2
!!!!!!!
end program  TRANSCK
