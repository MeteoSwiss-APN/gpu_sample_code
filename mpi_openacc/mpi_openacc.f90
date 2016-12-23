! Test mpi+openacc
! usage ./mpi_openacc N
PROGRAM main
  IMPLICIT NONE
  INCLUDE 'mpif.h' 

  !Variables
  REAL*8, ALLOCATABLE :: a(:,:), aref(:,:)
  REAL*8 :: sum_a, sum_loc, sum_aref, sum_loc_ref
  INTEGER*4 :: N,nlev,i,k, nloc, n0loc, nc, nstart,iter,niter
  INTEGER*4 :: nargs
  CHARACTER*10 arg 
  INTEGER :: rank, size, ierror, tag, status(MPI_STATUS_SIZE)
  REAL*8 :: rt , rt_mean
  REAL*8 :: eps=1e-8
  INTEGER ::  icountnew, icountold, icountrate, icountmax 
  

  !MPI SETUP
  CALL MPI_INIT(ierror)   
  CALL MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)   
  CALL MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)

  !PRINT and argument read
  PRINT*,  'Hello I am '  ,  rank
  nargs = COMMAND_ARGUMENT_COUNT() 
  IF( nargs == 1 ) THEN 
     CALL getarg( 1, arg ) 
     READ(arg,'(i)') N 
  ELSE 
     STOP('usage ./mpi_openacc N') 
  ENDIF 


  !Main body
#ifdef _OPENACC
  PRINT*, "Running on GPU"
#else
  PRINT*, "Running on CPU"
#endif

  nlev=60
  niter=1000

  nloc=N/size
  n0loc=N-(N/size)*(size-1)

!Array allocation 
IF (rank==0) THEN
   ALLOCATE(a(n0loc,nlev))
   ALLOCATE(aref(n0loc,nlev))
   nc=n0loc
ELSE
   ALLOCATE(a(nloc,nlev))
   ALLOCATE(aref(nloc,nlev))
   nc=nloc
END IF

nstart=n0loc+nloc*(rank-1)
!$acc data create(a)

!iteration loop for timing
DO iter=1,niter

!skip first call
!$acc wait
IF (iter==2) CALL SYSTEM_CLOCK(COUNT=icountold,COUNT_RATE=icountrate,COUNT_MAX=icountmax) 

!Compute on CPU
DO i=1,nc
   DO k=1,nlev
      aref(i,k)=0.1D0*( 1.0D0+(1.0D0*( (i+nstart)/N+k/nlev) ) )
   END DO
END DO

! Compute on GPU
!$acc parallel
!$acc loop gang vector
DO i=1,nc
   DO k=1,nlev
      a(i,k)=0.1D0*( 1.0D0+(1.0D0*( (i+nstart)/N+k/nlev) ) )
   END DO
END DO
!$acc end parallel
CALL MPI_BARRIER(MPI_COMM_WORLD, ierror)
END DO

!$acc wait
 CALL SYSTEM_CLOCK(COUNT=icountnew)
!$acc update host(a)
!$acc end data 


rt = ( REAL(icountnew) - REAL(icountold) ) / REAL(icountrate) 

sum_loc=SUM(a)
sum_loc_ref=SUM(aref)
sum_a=0.0D0
sum_aref=0.0D0
rt_mean=0.0D0
WRITE(*,'(I4,A,F8.4)') rank, ' ,time: ' , rt*1.0e3/(niter-1) 
CALL MPI_REDUCE(sum_loc_ref,sum_aref,1,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD, ierror)
CALL MPI_REDUCE(sum_loc,sum_a,1,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD, ierror)
CALL MPI_REDUCE(rt,rt_mean,1,MPI_DOUBLE,MPI_SUM, 0, MPI_COMM_WORLD, ierror)
rt_mean=rt_mean/size


IF (rank==0) THEN
   WRITE(*,"(A,I,A,I)") 'N=', N
   WRITE(*,'(A,F8.4)') 'avg time (ms): ', rt_mean*1.0e3/(niter-1)
   IF ( ABS(sum_a-sum_aref)/sum_aref < eps ) THEN
     WRITE(*,*) 'TEST OK'
   ELSE
     WRITE(*,*) 'TEST FAIL'
     WRITE(*,*) 'sum_a, sum_aref:', sum_a, sum_aref
   END IF
END IF

CALL MPI_FINALIZE(ierror) 

END PROGRAM main
