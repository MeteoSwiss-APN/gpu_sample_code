! Test Openacc + GPU-GPU communication
! Test scatter gather with openacc using host_data
module fmpi
  !DEC$ NOFREEFORM
  include "mpif.h"
  !DEC$ FREEFORM
end module fmpi
! This program shows how to use fmpi_Scatter and MPI_Gather
! Each processor gets different data from the root processor
! by way of mpi_scatter.  The data is summed and then sent back
! to the root processor using MPI_Gather.  The root processor
! then prints the global sum. 
module global
  integer numnodes,myid,mpi_err
  integer, parameter :: my_root=0
  logical, parameter :: ldebug=.FALSE.
end module global

subroutine initAccDevice()
#ifdef _OPENACC
use openacc
use global, only : ldebug
implicit none

character(len=256) :: snumid
character(len=256) :: smyid
integer :: numid,myid

! get rank of this MPI task from environment since
! CUDA setup needs to be done _before_ MPI init
call getenv("MV2_COMM_WORLD_SIZE", snumid)
call getenv("MV2_COMM_WORLD_RANK", smyid)

if (len_trim(snumid) == 0 .OR. len_trim(smyid) == 0 ) then
  call getenv("SLURM_NPROCS", snumid)
  call getenv("SLURM_PROCID", smyid)
  if (len_trim(snumid) == 0 .OR. len_trim(smyid) == 0 ) then
    write(0,'(a)') 'WARNING: cannot read MV2_COMM_WORLD_SIZE and MV2_COMM_WORLD_RANK'
    write(0,'(a)') '         or SLURM_NPROCS and SLURM_PROCID'
    write(0,'(a)') '   -->   no cudaSetDevice() called before MPI_Init()'
  return
  endif
endif

read(snumid,'(i8)') numid
read(smyid,'(i8)') myid
if (ldebug) print*, numid, myid
call acc_set_device_num(myid, acc_device_nvidia)
call acc_init(acc_device_nvidia)
if (myid==0) print*, "Running with OpenACC"
#endif
end subroutine initAccDevice


subroutine init
  use fmpi
  use global
  implicit none
  ! do the mpi init stuff
  call MPI_INIT( mpi_err )
  call MPI_COMM_SIZE( MPI_COMM_WORLD, numnodes, mpi_err )
  call MPI_Comm_rank(MPI_COMM_WORLD, myid, mpi_err)
end subroutine init

program test1
  use fmpi
  use global
  implicit none
  integer, allocatable :: myray(:),send_ray(:),back_ray(:)
  integer count
  integer size,mysize,i,k,j,total

#ifdef MPI_MVAPICH
!It is required to set the device before mpi init with mvapich
  call initAccDevice
#endif
  call init

  ! each processor will get count elements from the root
  count=4
  allocate(myray(count))
  ! create the data to be sent on the root
  if(myid == my_root)then
    size=count*numnodes	
    allocate(send_ray(0:size-1))
    allocate(back_ray(0:numnodes-1))
    do i=0,size-1
      send_ray(i)=i
    enddo
  endif

  !$acc data create(send_ray,back_ray,myray)

  !$acc update device(send_ray) if(myid == my_root)

  ! send different data to each processor 
  !$acc host_data use_device(send_ray,myray)
  call MPI_Scatter(	send_ray, count,  MPI_INTEGER, &
       myray,    count,  MPI_INTEGER, &
       my_root,                      &
       MPI_COMM_WORLD,mpi_err)
  !$acc end host_data

  total=0
  !$acc parallel loop gang vector reduction(+:total)
  DO i=1,count
    total=total+myray(i)
  END DO

  if (ldebug) write(*,*)"myid= ",myid," total= ",total
  
  ! send the local sums back to the root
  !$acc data copyin(total)
  !$acc host_data use_device(back_ray,total)
  call MPI_Gather(	total,    1,  MPI_INTEGER, &
       back_ray, 1,  MPI_INTEGER, &
       my_root,                  &
       MPI_COMM_WORLD,mpi_err)
  !$acc end host_data
  !$acc end data

  !$acc update host(back_ray)
  ! the root prints the global sum
  if(myid == my_root)then
    IF (sum(send_ray)-sum(back_ray)==0) THEN
      print*, 'TEST OK'
    ELSE
      print*, 'TEST FAIL'
      write(*,*)"results from processor 0= ",sum(send_ray)
      write(*,*)"results from all processors= ",sum(back_ray)
    END IF
  endif

  !$acc end data

  call mpi_finalize(mpi_err)

end program test1

