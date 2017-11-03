PROGRAM test_array_derived_pointer

  IMPLICIT NONE
  integer, parameter :: dp = kind(1.d0)
  TYPE t_ptr
    REAL(kind=dp), POINTER  :: ptr(:,:)
    INTEGER           :: idx
  END TYPE t_ptr

  INTEGER :: i, j, k
  INTEGER :: ni, nj, nk
  nk = 3
  ni = 3
  nj = 2

  CALL test1()

  CALL test2()

  CONTAINS
    SUBROUTINE test1
      IMPLICIT NONE

      REAL(kind=dp), DIMENSION(:,:,:), ALLOCATABLE, TARGET  :: all_data
      TYPE(t_ptr), DIMENSION(:), ALLOCATABLE  :: block_ptr

      ALLOCATE(all_data(ni,nj,nk))
      all_data = -999.777_dp
      ALLOCATE(block_ptr(nk))
      !$acc enter data copyin(all_data) create(block_ptr)

      !$acc data present(all_data, block_ptr)
#ifdef _OPENACC
      !$acc parallel
        !$acc loop gang vector collapse(3)
        DO k=1, nk
          DO j=1, nj
            DO i=1,ni
              all_data(i,j,k) = -777.999_dp
            END DO
          END DO
        END DO
      !$acc end parallel
#endif

      !$acc parallel
      !$acc loop gang vector
      DO k = 1, nk
        block_ptr(k)%ptr => all_data(:,:,k)
      END DO
      !$acc end parallel
      !$acc end data

      CALL init_present(block_ptr)

      PRINT *, " ---------- WITH PRESENT ON POINTERS ---------- "
      PRINT *, " ---- CPU:"
      PRINT *,all_data
      !!$acc update host(all_data)
      PRINT *, " ---------- WITH PRESENT ON POINTERS ---------- "
      PRINT *, " ---- GPU:"
      PRINT *,all_data

      !$acc exit data delete(all_data, block_ptr)
      DEALLOCATE(block_ptr)
      DEALLOCATE(all_data)
    END SUBROUTINE test1

    SUBROUTINE test2
      IMPLICIT NONE

      REAL(kind=dp), DIMENSION(:,:,:), ALLOCATABLE, TARGET  :: all_data
      TYPE(t_ptr), DIMENSION(:), ALLOCATABLE  :: block_ptr

      ALLOCATE(all_data(ni,nj,nk))
      all_data = -999.777_dp
      ALLOCATE(block_ptr(nk))
      !$acc enter data copyin(all_data)

      !$acc data present(all_data)
#ifdef _OPENACC
      !$acc parallel
        !$acc loop gang vector collapse(3)
        DO k=1, nk
          DO j=1, nj
            DO i=1,ni
              all_data(i,j,k) = -777.999_dp
            END DO
          END DO
        END DO
      !$acc end parallel
#endif

      !$acc parallel
      !$acc loop gang vector
      DO k = 1, nk
        block_ptr(k)%ptr => all_data(:,:,k)
      END DO
      !$acc end parallel
      !$acc end data

      CALL init_nopresent(block_ptr)

      PRINT *, " ---------- WITHOUT PRESENT ON POINTERS ---------- "
      PRINT *, " ---- CPU:"
      PRINT *,all_data
      !$acc update host(all_data)
      PRINT *, " ---------- WITHOUT PRESENT ON POINTERS ---------- "
      PRINT *, " ---- GPU:"
      PRINT *,all_data

      !$acc exit data delete(all_data, block_ptr)
      DEALLOCATE(block_ptr)
      DEALLOCATE(all_data)
    END SUBROUTINE test2

    SUBROUTINE init_nopresent(arr_ptr)
      IMPLICIT NONE
      TYPE(t_ptr), DIMENSION(:), INTENT(INOUT) :: arr_ptr
      INTEGER :: i, k
      !$acc data present(arr_ptr)

      !$acc parallel 
      !$acc loop gang
      DO k = 1, nk
        !$acc loop vector
          DO i = 1, ni
            arr_ptr(k)%ptr(i,1) = 13.0
          END DO
      END DO
      !$acc end parallel
      !$acc end data

    END SUBROUTINE init_nopresent

    SUBROUTINE init_present(arr_ptr)
      IMPLICIT NONE
      TYPE(t_ptr), DIMENSION(:), INTENT(INOUT) :: arr_ptr
      INTEGER :: i, k

      !$acc parallel 
      !$acc loop gang
      DO k = 1, nk
        !$acc loop vector
          DO i = 1, ni
            arr_ptr(k)%ptr(i,1) = 13.0
          END DO
      END DO
      !$acc end parallel

    END SUBROUTINE init_present

END PROGRAM test_array_derived_pointer
