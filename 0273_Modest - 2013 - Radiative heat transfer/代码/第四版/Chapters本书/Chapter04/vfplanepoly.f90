!      Main program for calculation of view factor between two planar triangles 
!      or two planar quadrilaterals or a combination thereof.
!      Code can be easily extended to more than 4 vertices.

!      Written by Sandip Mazumder
!      For queries, contact: mazumder.2@osu.edu

       program vfplanepoly

       IMPLICIT NONE
       INTEGER(8) :: nv_e, nv_r
       INTEGER(8) :: nodea,nodeb,noded,nodee,i,j,o1
       REAL(8), PARAMETER :: zero=0.0d0,one=1.0d0,two=2.0d0,half=0.5d0,tiny=1.0d-20
       REAL(8), POINTER, DIMENSION(:) :: xv,yv,zv
       REAL(8), DIMENSION(3) :: aa,bb,ab,dd,ee,de,ad
       REAL(8) :: l1,l2,c1,c2,c3,c4,answer,area_e,ebd,eae, currfij,pi,vf_li, &
                        nx,ny,nz
       REAL(8), DIMENSION(3) :: t1,t2
!------------------------------------------------------------------------------------------------------------

       pi = 4.0d0*ATAN(one)
       
!  User Inputs (for Example 4.15)
       nv_e = 3        ! Number of vertices on emitting face
       nv_r = 3        ! Number of vertices on receiving face

      ALLOCATE(xv(nv_e+nv_r), yv(nv_e+nv_r), zv(nv_e+nv_r))

!..Set up coordinates of emitting and receiving surfaces (User input)
! Emitting (for Example 4.15); add more vertices if necessary for other problems
       xv(1) = 0; yv(1) = 0; zv(1) = 0  ! Vertex 1
       xv(2) = 1; yv(2) = 0; zv(2) = 0  ! Vertex 2
       xv(3) = 1; yv(3) = 1; zv(3) = 0  ! Vertex 3
       
! Receiving (for Example 4.15); add more vertices if necessary for other problems
       xv(nv_e +1) = 1; yv(nv_e +1) =0; zv(nv_e +1) = 1  ! Vertex 1
       xv(nv_e +2) = 1; yv(nv_e +2) = 1; zv(nv_e +2) = 1  ! Vertex 2
       xv(nv_e +3) = 0; yv(nv_e +3) = 1; zv(nv_e +3) = 1  ! Vertex 3

! Calculate area of emitting surface
       o1 = 2
       t1(1) = xv(1)-xv(o1); t1(2) = yv(1)-yv(o1); t1(3) = zv(1)-zv(o1) ! tangent 1
       t2(1) = xv(3)-xv(o1); t2(2) = yv(3)-yv(o1); t2(3) = zv(3)-zv(o1) ! tangent 2
       ! Normal = t1 X t2
       nx = t1(2)*t2(3)-t1(3)*t2(2)
       ny = t1(3)*t2(1)-t1(1)*t2(3)
       nz = t1(1)*t2(2)-t1(2)*t2(1) 
       area_e = half*sqrt(nx*nx+ny*ny+nz*nz)
       IF(nv_e > 3)THEN  ! Compute second triangle
          o1 = 4
          t1(1) = xv(1)-xv(o1); t1(2) = yv(1)-yv(o1); t1(3) = zv(1)-zv(o1) ! tangent 1
          t2(1) = xv(3)-xv(o1); t2(2) = yv(3)-yv(o1); t2(3) = zv(3)-zv(o1) ! tangent 2
         ! Normal = t1 X t2
          nx = t1(2)*t2(3)-t1(3)*t2(2)
          ny = t1(3)*t2(1)-t1(1)*t2(3)
          nz = t1(1)*t2(2)-t1(2)*t2(1) 
          area_e = area_e + half*sqrt(nx*nx+ny*ny+nz*nz)
      ENDIF
          
! Calculation using Contour Integral
       
        currfij = zero
        DO i = nv_e,1,-1
          IF(i == 1) THEN
            nodea = 1
            nodeb = nv_e
          ELSE
            nodea = i
            nodeb = i-1
          ENDIF
          aa(1) = xv(nodea)
          aa(2) = yv(nodea)
          aa(3) = zv(nodea)
          bb(1) = xv(nodeb)
          bb(2) = yv(nodeb)
          bb(3) = zv(nodeb)
          ab(:) = bb(:) - aa(:)
          l1 = ab(1)*ab(1) + ab(2)*ab(2) + ab(3)*ab(3)
          
          DO j = nv_r,1,-1
            IF(j == 1) THEN
              noded = nv_e+1
              nodee = nv_e+nv_r
            ELSE
              noded = nv_e+j
              nodee = nv_e+j-1
            ENDIF
            ebd = SQRT((xv(nodeb)-xv(noded))**2 + (yv(nodeb)-yv(noded))**2 + &
                  (zv(nodeb)-zv(noded))**2)
            eae = SQRT((xv(nodea)-xv(nodee))**2 + (yv(nodea)-yv(nodee))**2 + &
                  (zv(nodea)-zv(nodee))**2)
            IF(ebd < tiny .and. eae < tiny) THEN ! Singularity
              currfij = currfij + l1 * ( one + half - half * log(l1) )
            ELSE ! Perform actual line integral
              dd(1) = xv(noded)
              dd(2) = yv(noded)
              dd(3) = zv(noded)
              ee(1) = xv(nodee)
              ee(2) = yv(nodee)
              ee(3) = zv(nodee)
              de(:) = ee(:) - dd(:)
              ad(:) = dd(:) - aa(:)
              c1 = ad(1)*ad(1) + ad(2)*ad(2) + ad(3)*ad(3)
              c2 = ad(1)*de(1) + ad(2)*de(2) + ad(3)*de(3)
              c3 = ab(1)*ad(1) + ab(2)*ad(2) + ab(3)*ad(3)
              c4 = ab(1)*de(1) + ab(2)*de(2) + ab(3)*de(3)
              l2 = de(1)*de(1) + de(2)*de(2) + de(3)*de(3)
              CALL lineintegrate(c1,c2,c3,c4,l1,l2,answer)
              currfij = currfij + answer 
            ENDIF
          ENDDO  ! j loop
        ENDDO ! i loop
        vf_li = ABS(currfij)/(two*pi*area_e)
        
        write(*,*) "View Factor = ", vf_li
        
       END program vfplanepoly
       
!***********************************************************************
  SUBROUTINE lineintegrate(c1,c2,c3,c4,l1,l2,answer)
!
! Purpose : performs line integration using 10-point Gaussian quadrature
!----------------------------------------------------------------------------------------------------------------------

    IMPLICIT NONE

    INTEGER(8) :: i,j
    INTEGER(8), PARAMETER :: ngauss = 10
    REAL(8), PARAMETER :: zero=0.0d0,one=1.0d0,two=2.0d0,half=0.5d0
    REAL(8),INTENT(IN) :: c1,c2,c3,c4,l1,l2
    REAL(8),INTENT(OUT) :: answer
    REAL(8) :: lamda1,lamda2,func,answer1
    REAL(8), DIMENSION(ngauss) :: xi,wi

!  10-point Gaussian quadrature nodes and weights

     xi(1) = 0.148874338981631; wi(1) = 0.295524224714753
     xi(2) = 0.433395394129247; wi(2) = 0.269266719309994
     xi(3) = 0.679409568299024; wi(3) = 0.219086362515983
     xi(4) = 0.865063366688985; wi(4) = 0.149451349150581
     xi(5) = 0.973906528517172; wi(5) = 0.066671344308688
     DO i = 1,5
       xi(5+i) = -xi(i)
       wi(5+i) = wi(i)
     ENDDO
     
! Begin Gaussian integration
    answer = zero
    DO i = 1,ngauss
       lamda1 = (one+xi(i))/two
       answer1 = zero
       DO j = 1,ngauss
          lamda2 = (one+xi(j))/two
          func = log(c1+ (lamda2**two)*l2 + (lamda1**two)*l1 + &
                     two*lamda2*c2 - two*lamda1*c3 - two*lamda1*lamda2*c4)
          answer1 = answer1 + func * wi(j)
       END DO
       answer = answer + answer1*wi(i)*half
    END DO
    answer = answer * c4 * half * half

  END SUBROUTINE lineintegrate

        
