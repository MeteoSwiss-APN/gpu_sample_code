PROGRAM test_derived_type_wpointer

  IMPLICIT NONE

  INTEGER :: ni, nj, nk
  INTEGER :: i, j, k
  INTEGER, ALLOCATABLE, DIMENSION(:,:,:)   :: ibl
  INTEGER, TARGET, ALLOCATABLE, DIMENSION(:,:,:,:) :: idata !data container for int
  REAL, TARGET, ALLOCATABLE, DIMENSION(:,:,:,:)    :: rdata !data container for real

  !Define derived type:
  TYPE ipointer
    INTEGER, POINTER, DIMENSION(:,:,:) :: ip
    REAL,    POINTER, DIMENSION(:,:,:) :: rp
  END TYPE ipointer
  TYPE(ipointer) :: a(2)

  ! test deeper nesting:
  TYPE ipointer_deep
    TYPE(ipointer) :: c
  END TYPE ipointer_deep
  TYPE(ipointer_deep) :: b

  REAL :: sum_1, sum_2
  REAL :: eps=1e-7

  !.. allocate and initialize array on host:

  print*, "Allocation"
  ALLOCATE(ibl(100,80,4))

  ni = SIZE(ibl, 1)
  nj = SIZE(ibl, 2)
  nk = SIZE(ibl, 3)
  
  !Allocate i/rdata on CPU and GPU
  ALLOCATE(idata(ni,nj,nk,3),rdata(ni,nj,nk,3))
  !$acc enter data create(idata,rdata)
  
  !set pointer:
  a(1)%ip=>idata(:,:,:,1)
  a(1)%rp=>rdata(:,:,:,1)
  a(2)%ip=>idata(:,:,:,2)
  a(2)%rp=>rdata(:,:,:,2)
  b%c%ip=>idata(:,:,:,3)
  b%c%rp=>rdata(:,:,:,3)


  print*, "Init"
  ! Some computation on CPU
  DO k=1, nk
    DO j=1, nj
      DO i=1, ni
        ibl(i,j,k) = i + (j-1)*ni + (k-1)*ni*nj
      END DO
    END DO
  END DO


  !init a
  a(1)%ip(:,:,:) = ibl(:,:,:)
  a(1)%rp(:,:,:) = ibl(:,:,:) + 0.5

  PRINT *, a(1)%ip(10:11,10:11,2)
  PRINT *, a(1)%rp(10:11,10:11,2) 


  print*, "GPU update"
  !update values on device
  !only a(1) is required on GPU
  !$acc update device(a(1)%ip,a(1)%rp,b%c%ip,b%c%rp)

  ! Some computation on GPU

  print*, "Compute"
  !$acc parallel present(a(1)%ip,a(1)%rp,b%c%ip,b%c%rp)
  !$acc loop gang vector
  DO j=1, nj
    DO i=1, ni
      b%c%ip(i,j,2) = a(1)%ip(i,j,2) + 5
      b%c%rp(i,j,2) = a(1)%rp(i,j,2) + 7
    END DO
  END DO
  !$acc end parallel


  print*, "Copy back to cpu"
  !.. synchronize back to host:
  !$acc update host(b%c%ip,b%c%rp)

  !.. print on host:
  PRINT *, b%c%ip(10:11,10:11,2)
  PRINT *, b%c%rp(10:11,10:11,2)

  ! Check results
  sum_1=SUM(ABS(b%c%ip(:,:,2)-a(1)%ip(:,:,2)-5))
  sum_2=SUM(ABS(b%c%rp(:,:,2)-a(1)%rp(:,:,2)-7))
  IF ( (sum_1+sum_2) < eps ) THEN
    print*, "TEST OK"
  ELSE
    print*, "TEST FAIL"
    print*, sum_1, sum_2
  END IF


END PROGRAM test_derived_type_wpointer

