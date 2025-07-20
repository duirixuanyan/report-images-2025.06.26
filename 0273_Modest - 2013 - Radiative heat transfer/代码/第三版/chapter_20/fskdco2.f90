   SUBROUTINE Fskdco2(Tg,Tb,absco,gcal)
   ! Modest & Mehta correlation for CO2
   ! Input variables:
   ! 	Tg : double precision scalar, local gas temperature in Kelvin
   ! 	Tb : double precision scalar, Planck function temperature in Kelvin
   ! 	absco : double precision scalar, pressure based absorption coefficient 
   ! Output variables:
   !	gcal : double precision scalar, the corresponding g value
   IMPLICIT NONE
   INTEGER  :: l,m,n
   DOUBLE PRECISION :: bigp,ksai,gcal,Tg,Tb,absco
   DOUBLE PRECISION :: dlmn(0:3,0:3,0:3)
   DATA dlmn /  1.85071   ,  0.33373   ,  0.62660   , -0.12890   , & ! n=0~3, m=0, l=0
           -0.20643   , -2.57690   ,  0.30090   , -0.14090   , & ! n=0~3, m=1, l=0
            0.27664   ,  1.81420   , -0.24728   ,  0.10052   , & ! n=0~3, m=2, l=0
           -0.37435d-1, -0.37762   ,  0.53014d-1, -0.20836d-1, & ! n=0~3, m=3, l=0
            0.67523   ,  1.25760   ,  0.67523d-1, -0.39669d-1, & ! n=0~3, m=0, l=1
           -0.70897   , -3.07080   ,  1.71150   , -0.57694   , & ! n=0~3, m=1, l=1
            0.48493   ,  2.04603   , -1.20220   ,  0.40510   , & ! n=0~3, m=2, l=1
           -0.98138d-1, -0.41928   ,  0.24956   , -0.84109d-1, & ! n=0~3, m=3, l=1
            0.20690   ,  0.28500   , -0.48324d-1,  0.15174d-1, & ! n=0~3, m=0, l=2
           -0.39473   , -0.42333   ,  0.54095   , -0.23469   , & ! n=0~3, m=1, l=2
            0.29020   ,  0.21882   , -0.34748   ,  0.15857   , & ! n=0~3, m=2, l=2
           -0.61998d-1, -0.38629d-1,  0.68728d-1, -0.32314d-1, & ! n=0~3, m=3, l=2
            0.38488d-1,  0.18292d-1, -0.18958d-1,  0.61307d-2, & ! n=0~3, m=0, l=3
           -0.41013d-1, -0.59115d-2,  0.47118d-1, -0.23229d-1, & ! n=0~3, m=1, l=3
            0.37740d-1, -0.30114d-1, -0.11303d-1,  0.12140d-1, & ! n=0~3, m=2, l=3
           -0.87906d-2,  0.98357d-2, -0.53884d-4, -0.20604d-2/
   ksai=LOG10(absco)
   bigp=0d0
   DO l=0,3
     DO m=0,3
       DO n=0,3
         bigp=bigp+dlmn(n, m, l)*(Tg/1000d0)**n*(Tb/1000d0)**m*ksai**l
       ENDDO !n
     ENDDO !m
   ENDDO !l
   gcal=0.5d0*tanh(bigp)+0.5d0
   RETURN
   END SUBROUTINE Fskdco2


