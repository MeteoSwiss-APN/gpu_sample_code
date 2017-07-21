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

# Remove "-rdynamic" from the link options
SET(CMAKE_SHARED_LIBRARY_LINK_Fortran_FLAGS)

# Debug Options (replace default)
if (TARGET_GPU)
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -g")
else()
    set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -g -eZ -eD -Rb -Rc -Rd -Rp -Rs")
endif()
