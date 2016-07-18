# CRAY Specific flags

# General Flags (add to default)
SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffree -eZ -N255 -ec -eC -eI -eF -hnosecond_underscore -hflex_mp=conservative -Ofp1 -hadd_paren -ra")

# OpenACC flags
if (TARGET_GPU)
    SET (OpenACC_FLAGS "-hacc")
else()
    SET (OpenACC_FLAGS "-hnoacc")
endif()

SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenACC_FLAGS}")


# Release
SET(CMAKE_Fortran_FLAGS_RELEASE "")

# Debug Options (replace default)
if (TARGET_GPU)
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -g")
else()
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -g -eZ -eD -Rb -Rc -Rd -Rp -Rs")
endif()