!      Main program for calculation of nondimensional temperature distribution
!      in a 2D axisymmetric tube with coupled gray radiation + forced convection
!      with P1-approximation.
!      Example 21.4 (Radiative Heat Transfer, 4th Edition, Modest & Mazumder)
!     Uses SEMI-IMPLICIT coupling procedure.
!     Uses Alternating Direction Implicit (ADI) method for iterative solution of the
!     individual T and G equations.

!      Written by Sandip Mazumder
!      For queries, contact: mazumder.2@osu.edu
!----------------------------------------------------------------------------------------------------------------
    program CpldP1En2D

! Declaration of variables
    IMPLICIT NONE

! User Inputs
!   Physical
    REAL(8), PARAMETER :: length = 1.0d0, & ! Length of tube
                                                    diameter=0.2d0, & ! diameter of tube
                                                    em_l=1.0d0, & ! Inlet emittance
                                                    em_r=1.0d0, & ! Outlet emittance
                                                    em_t=1.0d0, & ! Wall emittance
                                                    temp_in=2000.0d0, & ! Inlet temperature
                                                    temp_top=1000.0d0, & ! Wall temperature
                                                    rho=0.22d0, & ! Density of fluid
                                                    cp=1230.0d0, & ! Specific heat capacity of fluid
                                                    con_to_rad = 1.0d-2, & ! Conduction to radiation parameter
                                                    tau_l = 1.0d0 ! Optical Thickness
!   Numerical
    INTEGER(8), PARAMETER :: n_nodes=801, & ! Number of nodes in x
                                                  m_nodes=81, & ! Number of nodes in r
                                                  loop_out=40000 ! Maximum number of outer loop iterations
    REAL(8), PARAMETER :: tol_out=1.0D-6 ! Tolerance for outer loop residual

    INTEGER(8) :: i,iter,ib,ib1,j
    
    REAL(8), PARAMETER :: one=1.0D0,two=2.0d0, zero= 0.0d0,half=0.5d0
    REAL(8), PARAMETER :: sigma=5.67d-8

    REAL(8) :: t14,res,res_g,res_t,res_total_t,res_total_g, &
                    res_total_g1,res_total_t1,sum_rr1,sum_ebp, &
                    ebib,ebw1ib,sum_kg,res1,dx,dx2,dr,dr2, &
                    emcon_l,emcon_r,emcon_t,rcp,alpha,umean,theta_avg, &
                    Pe,maxdt,tsum,area,htc_mean,cond, &
                    qcon,qrad,mint,usum,pi
    REAL(8) :: theta(n_nodes,m_nodes),grad(n_nodes,m_nodes), &
                    g_old(n_nodes,m_nodes),th_old(n_nodes,m_nodes), &
                    solgx(n_nodes),solgy(m_nodes),radius(m_nodes)
    REAL(8) :: aaa(n_nodes),rrr(n_nodes),ccc(n_nodes),ddd(n_nodes)
    REAL(8) :: absrp,gband(n_nodes,m_nodes),eb,ebp,ebw1, &
                    t_left(m_nodes),t_top(n_nodes),t_right(m_nodes), &
                    soltx(n_nodes),solty(m_nodes),vel(m_nodes), &
                    tmean(n_nodes),htc(n_nodes),Nux(n_nodes)
!---------------------------------------------------------------------------------------------------------------

!..Open Files for Writing
    OPEN(unit=10,file="CpldP1En2D.dat",status="unknown") ! Temperature
    OPEN(unit=11,file="CpldP1En2D_residual.dat",status="unknown") ! Residual
    OPEN(unit=12,file="CpldP1En2D_Nux.dat",status="unknown") ! Nusselt number

    pi = 4.0d0*atan(one)

!..Geometry and grid points
    dx = (length)/(n_nodes-1)
    dx2 = dx*dx
    dr = (half*diameter)/(m_nodes-1)
    dr2 = dr*dr

! Radiative properties
    absrp = tau_l/diameter
    cond = con_to_rad*(4.0d0*sigma*(temp_top**3))/absrp
    
    WRITE(*,*) "Absorption Coefficient =", absrp
    WRITE(*,*) "Thermal Conductivity =", cond

!..Thermophysical properties
    rcp = rho*cp
    alpha = cond/rcp

!..flow parameters
    Pe = 100 ! Set Peclet Number = Re*Pr
    umean = Pe*alpha/diameter
    DO j=1,m_nodes
      radius(j) = (j-1)*dr
      vel(j) = two*umean*(one-(two*radius(j)/diameter)**2)
    ENDDO

!..Boundary conditions
    emcon_l = 3.0D0*em_l/(two*(two-em_l))
    emcon_r = 3.0D0*em_r/(two*(two-em_r))
    emcon_t = 3.0D0*em_t/(two*(two-em_t))

    t_left(:) = temp_in
    t_top(:) = temp_top
    t_right(:) = temp_in ! Initial guess
    theta(:,:) = half*(temp_in+temp_top)
    theta(1,:) = t_left(:)
    theta(n_nodes,:) = t_right(:)
    theta(:,m_nodes) = t_top(:)

!   Initial guess for G
    gband(:,:) = 4.0d0*sigma*(theta(:,:)**4)

! Start of Outer Iteration Loop
    DO iter = 1,loop_out

! First solve for G using ADI

!..row-wise sweep
          DO j = 1,m_nodes
!..bottom row
            IF(j == 1)THEN
              i=1
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(i) = two/dx2+two*emcon_l*absrp/dx+ &
                       3.0d0*(absrp**2)+4.0d0/dr2
              ccc(i) = -two/dx2
              rrr(i) = 8.0d0*emcon_l*absrp*ebw1ib/dx+12.0d0*ebib* &
                    (absrp**2)+4.0d0*gband(i,j+1)/dr2
              DO i = 2,n_nodes-1
                ebib = sigma*(theta(i,j)**4)
                ddd(i) = two/dx2+4.0d0/dr2+3.0d0*(absrp**2)
                ccc(i) = -one/dx2
                aaa(i-1) = -one/dx2
                rrr(i) = 12.0d0*ebib*(absrp**2)+4.0d0*gband(i,j+1)/dr2
              ENDDO
              i=n_nodes
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(i) = two/dx2+two*emcon_r*absrp/dx+ &
                             3.0D0*(absrp**2)+4.0d0/dr2
              aaa(i-1) = -two/dx2
              ccc(i) = zero
              rrr(i) = 8.0d0*emcon_r*absrp*ebw1ib/dx+12.0d0*ebib* &
                              (absrp**2)+4.0d0*gband(i,j+1)/dr2
              CALL TRI(n_nodes,aaa,ddd,ccc,rrr,solgx)
              gband(:,j) = solgx(:)
!..top row
            ELSEIF(j == m_nodes)THEN

              i=1
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(i) = two/dx2+two*emcon_l*absrp/dx+ &
                       3.0d0*(absrp**2)+two/dr2+ &
                       (two/dr+one/radius(j))*absrp*emcon_t
              ccc(i) = -two/dx2
              rrr(i) = 8.0d0*emcon_l*absrp*ebw1ib/dx+12.0d0*ebib* &
                    (absrp**2)+two*gband(i,j-1)/dr2+ &
                    (two/dr+one/radius(j))*absrp*emcon_t*4.0d0*ebw1ib
              DO i = 2,n_nodes-1
                ebib = sigma*(theta(i,j)**4)
                ebw1ib = sigma*(theta(i,j)**4)
                ddd(i) = two/dx2+two/dr2+3.0d0*(absrp**2)+ &
                         (two/dr+one/radius(j))*emcon_t*absrp
                ccc(i) = -one/dx2
                aaa(i-1) = -one/dx2
                rrr(i) = 12.0d0*ebib*(absrp**2)+two*gband(i,j-1)/dr2+ &
                         (two/dr+one/radius(j))*emcon_t*absrp*4.0d0*ebw1ib
              ENDDO
              i=n_nodes
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(i) = two/dx2+two*emcon_r*absrp/dx+ &
                       3.0d0*(absrp**2)+two/dr2+ &
                       (two/dr+one/radius(j))*absrp*emcon_t
              ccc(i) = zero
              aaa(i-1) = -two/dx2
              rrr(i) = 8.0d0*emcon_r*absrp*ebw1ib/dx+12.0d0*ebib* &
                    (absrp**2)+two*gband(i,j-1)/dr2+ &
                    (two/dr+one/radius(j))*absrp*emcon_t*4.0d0*ebw1ib
              CALL TRI(n_nodes,aaa,ddd,ccc,rrr,solgx)
              gband(:,j) = solgx(:)
!..interior rows
            ELSE
              i=1
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(i) = two/dx2+two*emcon_l*absrp/dx+ &
                       3.0d0*(absrp**2)+two/dr2
              ccc(i) = -two/dx2
              rrr(i) = 8.0d0*emcon_l*absrp*ebw1ib/dx+12.0d0*ebib* &
                    (absrp**2)+(gband(i,j+1)-gband(i,j-1))/ &
                    (two*radius(j)*dr)+(gband(i,j+1)+gband(i,j-1))/dr2
              DO i = 2,n_nodes-1
                ebib = sigma*(theta(i,j)**4)
                ddd(i) = two/dx2+two/dr2+3.0d0*(absrp**2)
                ccc(i) = -one/dx2
                aaa(i-1) = -one/dx2
                rrr(i) = 12.0d0*ebib*(absrp**2)+ &
                         (gband(i,j+1)+gband(i,j-1))/dr2 + &
                         (gband(i,j+1)-gband(i,j-1))/(two*dr*radius(j))
              ENDDO
              i=n_nodes
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(i) = two/dx2+two*emcon_r*absrp/dx+ &
                             3.0D0*(absrp**2)+two/dr2
              aaa(i-1) = -two/dx2
              ccc(i) = zero
              rrr(i) = 8.0d0*emcon_r*absrp*ebw1ib/dx+12.0d0*ebib* &
                    (absrp**2)+(gband(i,j+1)- &
                     gband(i,j-1))/(two*radius(j)*dr)+ &
                    (gband(i,j+1)+gband(i,j-1))/dr2
              CALL TRI(n_nodes,aaa,ddd,ccc,rrr,solgx)
              gband(:,j) = solgx(:)
            ENDIF
          ENDDO   ! End of row-wise sweep

!..column-wise sweep
          DO i = 1,n_nodes
!..left column
            IF(i == 1)THEN
              j=1
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(j) = two/dx2+two*emcon_l*absrp/dx+ &
                       3.0d0*(absrp**2)+4.0/dr2
              ccc(j) = -4.0/dr2
              rrr(j) = 8.0d0*emcon_l*absrp*ebw1ib/dx+12.0d0*ebib* &
                    (absrp**2)+two*gband(i+1,j)/dx2
              DO j = 2,m_nodes-1
                ebib = sigma*(theta(i,j)**4)
                ebw1ib = sigma*(theta(i,j)**4)
                ddd(j) = two/dx2+two/dr2+3.0d0*(absrp**2)+ &
                         two*emcon_l*absrp/dx
                ccc(j) = -one/dr2-half/(radius(j)*dr)
                aaa(j-1) = -one/dr2+half/(radius(j)*dr)
                rrr(j) = 12.0d0*ebib*(absrp**2)+two*gband(i+1,j)/dx2+ &
                         8.0d0*emcon_l*absrp*ebw1ib/dx
              ENDDO
              j=m_nodes
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(j) = two/dx2+two*emcon_l*absrp/dx+3.0D0*(absrp**2)+two/dr2 + &
                       (two/dr+one/radius(j))*emcon_t*absrp
              aaa(j-1) = -two/dr2
              ccc(j) = zero
              rrr(j) = 8.0d0*emcon_l*absrp*ebw1ib/dx+12.0d0*ebib* &
                              (absrp**2)+two*gband(i+1,j)/dx2 + &
                       (two/dr+one/radius(j))*emcon_t*absrp*4.0d0*ebw1ib
              CALL TRI(m_nodes,aaa,ddd,ccc,rrr,solgy)
              gband(i,:) = solgy(:)
!..right column
            ELSEIF(i == n_nodes)THEN
              j=1
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(j) = two/dx2+two*emcon_r*absrp/dx+3.0d0*(absrp**2)+4.0/dr2
              ccc(j) = -4.0/dr2
              rrr(j) = 8.0d0*emcon_r*absrp*ebw1ib/dx+12.0d0*ebib* &
                    (absrp**2)+two*gband(i-1,j)/dx2
              DO j = 2,m_nodes-1
                ebib = sigma*(theta(i,j)**4)
                ebw1ib = sigma*(theta(i,j)**4)
                ddd(j) = two/dx2+two/dr2+3.0d0*(absrp**2)+two*emcon_r*absrp/dx
                ccc(j) = -one/dr2-half/(radius(j)*dr)
                aaa(j-1) = -one/dr2+half/(radius(j)*dr)
                rrr(j) = 12.0d0*ebib*(absrp**2)+two*gband(i-1,j)/dx2+ &
                         8.0d0*emcon_r*absrp*ebw1ib/dx
              ENDDO
              j=m_nodes
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(j) = two/dx2+two*emcon_r*absrp/dx+3.0d0*(absrp**2)+two/dr2+ &
                       (two/dr+one/radius(j))*absrp*emcon_t
              ccc(j) = zero
              aaa(j-1) = -two/dr2
              rrr(j) = 8.0d0*emcon_r*absrp*ebw1ib/dx+12.0d0*ebib* &
                    (absrp**2)+two*gband(i-1,j)/dx2+ &
                    (two/dr+one/radius(j))*absrp*emcon_t*4.0d0*ebw1ib
              CALL TRI(m_nodes,aaa,ddd,ccc,rrr,solgy)
              gband(i,:) = solgy(:)
!..interior columns
            ELSE
              j=1
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(j) = two/dx2+3.0d0*(absrp**2)+4.0d0/dr2
              ccc(j) = -4.0d0/dr2
              rrr(j) = 12.0d0*ebib*(absrp**2)+(gband(i+1,j)+gband(i-1,j))/dx2 
              DO j = 2,m_nodes-1
                ebib = sigma*(theta(i,j)**4)
                ddd(j) = two/dx2+two/dr2+3.0d0*(absrp**2)
                ccc(j) = -one/dr2-half/(radius(j)*dr)
                aaa(j-1) = -one/dr2+half/(radius(j)*dr)
                rrr(j) = 12.0d0*ebib*(absrp**2)+(gband(i+1,j)+gband(i-1,j))/dx2 
              ENDDO
              j=m_nodes
              ebib = sigma*(theta(i,j)**4)
              ebw1ib = sigma*(theta(i,j)**4)
              ddd(j) = two/dx2+(two/dr+one/radius(j))*emcon_t*absrp+ &
                             3.0D0*(absrp**2)+two/dr2
              aaa(j-1) = -two/dr2
              ccc(j) = zero
              rrr(j) = (two/dr+one/radius(j))*emcon_t*absrp*4.0d0*ebw1ib+ &
                       12.0d0*ebib*(absrp**2)+(gband(i+1,j)+gband(i-1,j))/dx2
              CALL TRI(m_nodes,aaa,ddd,ccc,rrr,solgy)
              gband(i,:) = solgy(:)
            ENDIF
          ENDDO   ! End of column-wise sweep

! Next solve for T

!..row-wise sweep
        DO j=1,m_nodes

!..bottom row
          IF(j==1)THEN
            i=1
            ddd(i) = one
            ccc(i) = zero
            rrr(i) = t_left(j)
            DO i = 2,n_nodes-1
              eb = sigma*(theta(i,j)**4)
              ebp = 4.0d0*sigma*(theta(i,j)**3)
              sum_ebp = absrp*ebp
              sum_rr1 = 4.0D0*absrp*(eb-theta(i,j)*ebp)
              sum_kg = absrp*gband(i,j)
              ddd(i) = two*alpha/dx2 + 4.0d0*alpha/dr2 + vel(j)/dx + &
                       4.0d0*sum_ebp/rcp
              ccc(i) = -alpha/dx2
              aaa(i-1) = -alpha/dx2 - vel(j)/dx
              rrr(i) = -sum_rr1/rcp + sum_kg/rcp +  &
                        4.0d0*alpha*theta(i,j+1)/dr2
            ENDDO 
            i=n_nodes
            eb = sigma*(theta(i,j)**4)
            ebp = 4.0d0*sigma*(theta(i,j)**3)
            sum_ebp = absrp*ebp
            sum_rr1 = 4.0D0*absrp*(eb-theta(i,j)*ebp)
            sum_kg = absrp*gband(i,j)
            ddd(i) = two*alpha/dx2 + vel(j)/dx + 4.0d0*alpha/dr2 + &
                     4.0d0*sum_ebp/rcp
            ccc(i) = zero
            aaa(i-1) = -two*alpha/dx2 - vel(j)/dx
            rrr(i) = -sum_rr1/rcp + sum_kg/rcp +  &
                        4.0d0*alpha*theta(i,j+1)/dr2
            CALL TRI(n_nodes,aaa,ddd,ccc,rrr,soltx)
            theta(:,j) = soltx(:)
!..top row
          ELSEIF(j==m_nodes)THEN
            theta(:,j) = t_top(:)
            theta(1,j) = half*(t_left(j)+t_top(1))
!..Interior rows
          ELSE
            i=1
            ddd(i) = one
            ccc(i) = zero
            rrr(i) = t_left(j)
            DO i = 2,n_nodes-1
              eb = sigma*(theta(i,j)**4)
              ebp = 4.0d0*sigma*(theta(i,j)**3)
              sum_ebp = absrp*ebp
              sum_rr1 = 4.0D0*absrp*(eb-theta(i,j)*ebp)
              sum_kg = absrp*gband(i,j)
              ddd(i) = two*alpha/dx2 + two*alpha/dr2 + vel(j)/dx + &
                       4.0d0*sum_ebp/rcp
              ccc(i) = -alpha/dx2
              aaa(i-1) = -alpha/dx2 - vel(j)/dx
              rrr(i) = -sum_rr1/rcp + sum_kg/rcp +  &
                        (alpha/dr2+half*alpha/(radius(j)*dr))*theta(i,j+1) + &
                        (alpha/dr2-half*alpha/(radius(j)*dr))*theta(i,j-1) 
            ENDDO 
            i=n_nodes
            eb = sigma*(theta(i,j)**4)
            ebp = 4.0d0*sigma*(theta(i,j)**3)
            sum_ebp = absrp*ebp
            sum_rr1 = 4.0D0*absrp*(eb-theta(i,j)*ebp)
            sum_kg = absrp*gband(i,j)
            ddd(i) = two*alpha/dx2 + vel(j)/dx + two*alpha/dr2 + &
                     4.0d0*sum_ebp/rcp
            ccc(i) = zero
            aaa(i-1) = -two*alpha/dx2 - vel(j)/dx
            rrr(i) = -sum_rr1/rcp + sum_kg/rcp +  &
                      (alpha/dr2+half*alpha/(radius(j)*dr))*theta(i,j+1) + &
                      (alpha/dr2-half*alpha/(radius(j)*dr))*theta(i,j-1) 
            CALL TRI(n_nodes,aaa,ddd,ccc,rrr,soltx)
            theta(:,j) = soltx(:)
          ENDIF
        ENDDO     ! End of row-wise sweep

!..column-wise sweep
        DO i=1,n_nodes

!..left column
          IF(i==1)THEN
            theta(i,:) = t_left(:)
            theta(i,m_nodes) = half*(t_left(m_nodes)+t_top(i))
!..right column
          ELSEIF(i==n_nodes)THEN
            j=1
            eb = sigma*(theta(i,j)**4)
            ebp = 4.0d0*sigma*(theta(i,j)**3)
            sum_ebp = absrp*ebp
            sum_rr1 = 4.0D0*absrp*(eb-theta(i,j)*ebp)
            sum_kg = absrp*gband(i,j)
            ddd(j) = two*alpha/dx2 + vel(j)/dx + 4.0d0*alpha/dr2 + &
                     4.0d0*sum_ebp/rcp
            ccc(j) = -4.0d0*alpha/dr2
            rrr(j) = -sum_rr1/rcp + sum_kg/rcp +  &
                        (two*alpha/dx2+vel(j)/dx)*theta(i-1,j)
            DO j = 2,m_nodes-1
              eb = sigma*(theta(i,j)**4)
              ebp = 4.0d0*sigma*(theta(i,j)**3)
              sum_ebp = absrp*ebp
              sum_rr1 = 4.0D0*absrp*(eb-theta(i,j)*ebp)
              sum_kg = absrp*gband(i,j)
              ddd(j) = two*alpha/dx2 + two*alpha/dr2 + vel(j)/dx + &
                       4.0d0*sum_ebp/rcp
              ccc(j) = -(alpha/dr2+half*alpha/(radius(j)*dr))
              aaa(j-1) = -(alpha/dr2-half*alpha/(radius(j)*dr))
              rrr(j) = -sum_rr1/rcp + sum_kg/rcp +  &
                        (two*alpha/dx2 + vel(j)/dx)*theta(i-1,j)
            ENDDO 
            j=m_nodes
            ddd(j) = one
            ccc(j) = zero
            aaa(j-1) = zero
            rrr(j) = t_top(i)
            CALL TRI(m_nodes,aaa,ddd,ccc,rrr,solty)
            theta(i,:) = solty(:)
!..Interior column
          ELSE
            j=1
            eb = sigma*(theta(i,j)**4)
            ebp = 4.0d0*sigma*(theta(i,j)**3)
            sum_ebp = absrp*ebp
            sum_rr1 = 4.0D0*absrp*(eb-theta(i,j)*ebp)
            sum_kg = absrp*gband(i,j)
            ddd(j) = vel(j)/dx + two*alpha/dx2 + 4.0*alpha/dr2 + &
                     4.0d0*sum_ebp/rcp
            ccc(j) = -4.0d0*alpha/dr2
            rrr(j) = -sum_rr1/rcp + sum_kg/rcp +  &
                        (alpha/dx2+vel(j)/dx)*theta(i-1,j) + &
                        alpha*theta(i+1,j)/dx2 
            DO j = 2,m_nodes-1
              eb = sigma*(theta(i,j)**4)
              ebp = 4.0d0*sigma*(theta(i,j)**3)
              sum_ebp = absrp*ebp
              sum_rr1 = 4.0D0*absrp*(eb-theta(i,j)*ebp)
              sum_kg = absrp*gband(i,j)
              ddd(j) = two*alpha/dx2 + two*alpha/dr2 + vel(j)/dx + &
                       4.0d0*sum_ebp/rcp
              ccc(j) = -alpha/dr2-half*alpha/(radius(j)*dr)
              aaa(j-1) = -alpha/dr2+half*alpha/(radius(j)*dr)
              rrr(j) = -sum_rr1/rcp + sum_kg/rcp +  &
                        (alpha/dx2)*theta(i+1,j) + &
                        (alpha/dx2+vel(j)/dx)*theta(i-1,j) 
            ENDDO 
            j=m_nodes
            ddd(j) = one
            ccc(j) = zero
            aaa(j-1) = zero
            rrr(j) = t_top(i)
            CALL TRI(m_nodes,aaa,ddd,ccc,rrr,solty)
            theta(i,:) = solty(:)
          ENDIF
        ENDDO     ! End of column-wise sweep

! Calculate Global Residual
      res_total_g = zero
      res_total_t = zero
!..interior nodes
      DO j=2,m_nodes-1
        DO i=2,n_nodes-1
          eb = sigma*(theta(i,j)**4)
          sum_rr1 = absrp*(4.0d0*eb-gband(i,j))
          res_g = (gband(i+1,j)-two*gband(i,j)+gband(i-1,j))/dx2+ &
                  (gband(i,j+1)-two*gband(i,j)+gband(i,j-1))/dr2+ &
                  (gband(i,j+1)-gband(i,j-1))*half/(radius(j)*dr) + &
                  3.0d0*(4.0d0*eb-gband(i,j))*(absrp**2)
          res_total_g = res_total_g + res_g*res_g
          res_t = alpha*(theta(i+1,j)-two*theta(i,j)+theta(i-1,j))/dx2 + &
                  alpha*(theta(i,j+1)-two*theta(i,j)+theta(i,j-1))/dr2 + &
                  half*alpha*(theta(i,j+1)-theta(i,j-1))/(radius(j)*dr)- &
                  sum_rr1/rcp - vel(j)*(theta(i,j)-theta(i-1,j))/dx
          res_total_t = res_total_t + res_t*res_t
        ENDDO
      ENDDO
!..bottom boundary
      j=1
      DO i=2,n_nodes-1
        eb = sigma*(theta(i,j)**4)
        sum_rr1 = absrp*(4.0d0*eb-gband(i,j))
        res_g = (gband(i+1,j)-two*gband(i,j)+gband(i-1,j))/dx2+ &
                two*(gband(i,j+1)-two*gband(i,j)+gband(i,j+1))/dr2+ &
                3.0d0*(4.0d0*eb-gband(i,j))*(absrp**2)
        res_total_g = res_total_g + res_g*res_g
        res_t = alpha*(theta(i+1,j)-two*theta(i,j)+theta(i-1,j))/dx2 + &
                two*alpha*(theta(i,j+1)-two*theta(i,j)+theta(i,j+1))/dr2 - &
                sum_rr1/rcp - vel(j)*(theta(i,j)-theta(i-1,j))/dx
        res_total_t = res_total_t + res_t*res_t
      ENDDO
!..Left boundary
      i=1
      DO j=2,m_nodes-1
        eb = sigma*(theta(i,j)**4)
        res_g = two*(gband(i+1,j)-gband(i,j)+emcon_l*absrp* &
                dx*(4.0d0*eb-gband(i,j)))/dx2+ &
                (gband(i,j+1)-two*gband(i,j)+gband(i,j-1))/dr2+ &
                (gband(i,j+1)-gband(i,j-1))*half/(radius(j)*dr) + &
                3.0d0*(4.0d0*eb-gband(i,j))*(absrp**2)
        res_total_g = res_total_g + res_g*res_g
      ENDDO
!..right boundary
      i=n_nodes
      DO j=2,m_nodes-1
        eb = sigma*(theta(i,j)**4)
        sum_rr1 = absrp*(4.0d0*eb-gband(i,j))
        res_g = two*(gband(i-1,j)-gband(i,j)+emcon_r*absrp* &
                dx*(4.0d0*eb-gband(i,j)))/dx2+ &
                (gband(i,j+1)-two*gband(i,j)+gband(i,j-1))/dr2+ &
                (gband(i,j+1)-gband(i,j-1))*half/(radius(j)*dr) + &
                3.0d0*(4.0d0*eb-gband(i,j))*(absrp**2)
        res_total_g = res_total_g + res_g*res_g
        res_t = alpha*(theta(i,j+1)-two*theta(i,j)+theta(i,j-1))/dr2 + &
                half*alpha*(theta(i,j+1)-theta(i,j-1))/(radius(j)*dr)- &
                sum_rr1/rcp - (vel(j)/dx+two*alpha/dx2)*(theta(i,j)-theta(i-1,j))
        res_total_t = res_total_t + res_t*res_t
      ENDDO
!..top boundary
      j=m_nodes
      DO i=2,n_nodes-1
        eb = sigma*(theta(i,j)**4)
        res_g = (gband(i+1,j)-two*gband(i,j)+gband(i-1,j))/dx2+ &
                two*(gband(i,j-1)-gband(i,j))/dr2+ &
                (two/dr+one/radius(j))*emcon_t*absrp*(4.0d0*eb-gband(i,j)) + &
                3.0d0*(4.0d0*eb-gband(i,j))*(absrp**2)
        res_total_g = res_total_g + res_g*res_g
      ENDDO

      res_total_t = SQRT(res_total_t)
      res_total_g = SQRT(res_total_g)
      IF(iter == 1)THEN
        res_total_g1 = res_total_g
        res_total_t1 = res_total_t
      ENDIF
      res_total_g = res_total_g/res_total_g1
      res_total_t = res_total_t/res_total_t1
      WRITE(*,*) iter*2,res_total_t,res_total_g
      WRITE(11,*) iter*2,res_total_t,res_total_g
      IF(res_total_t < tol_out .AND. res_total_g < tol_out)EXIT

    ENDDO  ! Outer iteration

! Post-process Results for Tecplot
! Non-dimensional T
    WRITE(10,*) 'VARIABLES = "X", "R", "TEMP"'
    WRITE(10,*) 'ZONE I=', n_nodes, ', J=', m_nodes, ', DATAPACKING=POINT'
    maxdt = temp_in-temp_top
    mint = MIN(temp_top,temp_in)
    DO j=1,m_nodes
      DO i=1,n_nodes
        WRITE(10,*)(i-1)*dx/diameter,radius(j)/diameter,DABS((theta(i,j)-mint)/maxdt)
      ENDDO
    ENDDO

! Heat Transfer Coefficient and Nusselt Number at top wall
    DO i = 2,n_nodes
      tsum = 2.0d0*umean*theta(i,1)*pi*((half*dr)**2)
      usum = 2.0d0*umean*pi*((half*dr)**2)
      DO j = 2,m_nodes-1
        area = pi*((radius(j)+half*dr)**2 - (radius(j)-half*dr)**2)
        tsum = tsum + vel(j)*theta(i,j)*area
        usum = usum + vel(j)*area
      ENDDO
      tmean(i) = tsum/usum
      qcon = -cond*((4.0d0*theta(i,m_nodes-1)-theta(i,m_nodes-2)- &
                3.0d0*theta(i,m_nodes))/(two*dr))
      qrad = -((4.0d0*gband(i,m_nodes-1)-gband(i,m_nodes-2)- &
                3.0d0*gband(i,m_nodes))/(two*dr))/(3.0d0*absrp)
      htc(i) = (qcon+qrad)/(temp_top-tmean(i))
      Nux(i) = htc(i)*diameter/cond

      WRITE(12,*) (i-1)*dx/(diameter*Pe), tmean(i), Nux(i)
    ENDDO

  END Program CpldP1En2D

!--------------------------------------------------------------------------

! Tridiagonal solver (uses Thomas Algorithm)

    SUBROUTINE TRI(n,a,d,c,b,x)

    INTEGER(8), INTENT(in) :: n
    INTEGER(8) :: i
    REAL(8) :: xmult
    REAL(8), DIMENSION(n) :: a,b,c,d,x

    DO i = 2,n
      xmult = a(i-1)/d(i-1)
      d(i) = d(i) - xmult*c(i-1)
      b(i) = b(i) - xmult*b(i-1)
    ENDDO

    x(n) = b(n)/d(n)
    DO i = n-1,1,-1
      x(i) = (b(i)-c(i)*x(i+1))/d(i)
    ENDDO

    END SUBROUTINE TRI
