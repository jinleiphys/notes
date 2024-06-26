      program spherical
      implicit none
      complex*16 :: ylm,iu
      integer :: l,m
      real*8 :: pi, theta, phi,y

      pi=acos(-1.0d0)
      iu=cmplx(0.0d0,1.0d0)
      
      write(*,*) "please enter theta and phi in degree"
      read(*,*) theta, phi


       theta=theta*pi/180.
       phi=phi*pi/180.
       
       
       do m=0,2
        write(*,*) ">m=",m
        write(*,*) ">"
        write(*,*) "> l   Ylm_exact", "  Ylm_asy"
        write(*,*) ">"
         do l=10, 100, 5
           Ylm=exp(iu*m*phi) * cos( (l+0.5)*theta - 0.25*pi
     &         +0.5*m*pi ) / pi / sqrt(sin(theta)) 
            call SPYLM(l,m,cos(theta),y)


             write(*,100)">",l,real(ylm),real(y*exp(iu*abs(m)*phi))
                     write(*,*) ">"
        end do 
       end do 
100   format(a2,I3, 4x, f7.4,4x,f7.4)
      end program
      
      
      subroutine SPYLM(L,M,cth,Y)
       implicit none
       real*8 :: theta
       integer :: L,M
       real*8 :: cth,Y
       real*8 :: YLMC
       real*8,dimension(0:l,0:l) :: PL
       call PLM(cth,l,l,l+1,PL)
       Y=YLMC(L,M)*PL(l,abs(M))

!       write(*,*) "YLMC=",YLMC(L,M)
      end subroutine
      
      
      FUNCTION YLMC(L,M)
      IMPLICIT REAL*8(A-H,O-Z)
      integer,intent(IN):: L,M
      real*8 :: pi
      PHASE(I) = (-1)**I
      pi=acos(-1d0)
      LF1 = L + 1
      MA = ABS(M)
      R =  FLOG(LF1-MA)-FLOG(LF1+MA)
      R = SQRT((2*L+1)/(4*PI)*EXP(R))* PHASE(M)
      IF(M.LT.0) R = R * PHASE(MA)
      YLMC = R
      RETURN
      END function
      
      function flog(i)
        implicit none
        integer::i,n
        real*8 :: a
        real*8:: flog,dlfac
!        real*8 :: logfac
!        flog=logfac(i-1)
        if(i==0) then
           flog=0.0d0
        else
           dlfac=0.0d0
           do n=1,i-1
            a=n
            dlfac=dlfac+log(a)
           end do 
           flog=dlfac
        end if
      end function flog
c-----------------------calculate the p_{lm}(\theta)--------------------
c from fresco
c  x: cos(\theta) -1<=x<=1
c  N:   lmax
c  M:   m_max -> lmax
c  NA:  lmax+1
      SUBROUTINE PLM(X,N,M,NA,PL)
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 PL(NA,M+1),X
      if(n==0) then
        PL=1.0d0
        return
      end if
      N1 = N+1
      M1 = M+1
      DO 10 J=1,M1
      DO 10 I=1,N1
10    PL(I,J)=0.
      PL(1,1) = 1.
      PL(2,1) = X
      SX = SQRT(1.-X*X)
      PL(2,2) = SX
      FACT=1.
      PMM=1.
      DO 15 J=2,min(M1,N1)
        mm = J-1
        PMM = PMM*FACT*SX
        FACT=FACT+2.
        PL(J,J) = PMM
        if(J+1.le.N1) PL(J+1,J) = X*(2*mm+1.) * PL(J,J)
15      CONTINUE
      DO 20 J=1,M1
       mm = J-1
      DO 20 I=J+2,N1
       ll = I-1
      PL(I,J)=((2.*ll-1.)*X*PL(I-1,J) - (ll+mm-1.)*PL(I-2,J))/(ll-mm)
20    CONTINUE
      RETURN
      END subroutine

