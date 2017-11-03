PROGRAM test_array_derived_pointer
  use iso_c_binding, ONLY:c_loc, c_ptr

  IMPLICIT NONE
  integer, parameter :: dp = kind(1.d0)
  TYPE t_ptr
    REAL(kind=dp), POINTER  :: ptr(:,:)
    REAL(kind=dp), POINTER :: huge_ptr(:,:)
    INTEGER           :: idx
  END TYPE t_ptr
  INTERFACE
      SUBROUTINE print_a( x ) bind( c )
        use, intrinsic :: iso_c_binding
        type( c_ptr ), value :: x
      END SUBROUTINE print_a
  END INTERFACE

  INTEGER :: i, j, k
  INTEGER :: ni, nj, nk
  INTEGER :: hugeNI, hugeNJ, hugeNK
  ni = 3
  nj = 2
  nk = 3
  hugeNI = 3
  hugeNJ = 2
  hugeNK = 3

  CALL test()

  CONTAINS
    SUBROUTINE test
      IMPLICIT NONE

      ! Data for all blocks
      REAL(kind=dp), DIMENSION(:,:,:), ALLOCATABLE, TARGET  :: all_data
      ! Huge dataset that should not be on GPU
      REAL(kind=dp), DIMENSION(:,:,:), ALLOCATABLE, TARGET  :: huge_data
      ! Access to blocks
      TYPE(t_ptr), DIMENSION(:), ALLOCATABLE  :: block_ptr

      !------------------------------------------
      ! Initialize data
      ALLOCATE(all_data(ni,nj,nk))
      all_data = -999.777_dp
      !$acc enter data copyin(all_data)

      ALLOCATE(huge_data(hugeNI,hugeNJ,hugeNK))
      huge_data = 3.141592653589_dp
      !$acc enter data copyin(huge_data)

      ALLOCATE(block_ptr(nk))

#ifdef _OPENACC
      !------------------------------------------
      ! Initialize GPU data with different value
      !$acc data present(all_data)
      !$acc parallel
        !$acc loop gang vector collapse(3)
        DO k=1, nk
          DO j=1, nj
            DO i=1,ni
              all_data(i,j,k) = 777.999_dp
            END DO
          END DO
        END DO
      !$acc end parallel
      !$acc end data
#endif

      !------------------------------------------
      ! Assign pointers to blocks in all_data
      DO k = 1, nk
        block_ptr(k)%ptr => all_data(:,:,k)
      END DO

      !$acc data
      !$acc parallel 
      !$acc loop gang
      DO k = 1, nk
        !$acc loop vector
          DO i = 1, ni
            block_ptr(k)%ptr(i,1) = 13.0_dp
          END DO
      END DO
      !$acc end parallel
      !$acc end data

      PRINT *, "CPU addresses"
      CALL print_a(C_LOC(all_data(1,1,1)))
      CALL print_a(C_LOC(block_ptr(1)%ptr(1,1)))
      CALL print_a(C_LOC(block_ptr(2)%ptr(1,1)))

#ifdef _OPENACC
      PRINT *, "GPU addresses"
      !$acc data present(all_data)
      !$acc host_data use_device(all_data, block_ptr(1)%ptr)
      CALL print_a(C_LOC(all_data(1,1,1)))
      CALL print_a(C_LOC(block_ptr(1)%ptr(1,1)))
      CALL print_a(C_LOC(block_ptr(2)%ptr(1,1)))
      !$acc end host_data
      !$acc end data
#endif

      !------------------------------------------
      ! Print host data
      PRINT *, " ---- CPU all_data:"
      PRINT *,all_data

#ifdef _OPENACC
      !------------------------------------------
      ! Print GPU data
      !$acc update host(all_data)
      PRINT *, " ---- GPU all_data:"
      PRINT *,all_data
#endif

      !------------------------------------------
      ! Cleanup
      !$acc exit data delete(all_data)
      DEALLOCATE(block_ptr)
      DEALLOCATE(huge_data)
      DEALLOCATE(all_data)
    END SUBROUTINE test

END PROGRAM test_array_derived_pointer
