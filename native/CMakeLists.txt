# Set minimum required version of CMake
cmake_minimum_required(VERSION 3.10)

# Set the project name and version
project(CrosshairEngine VERSION 1.0.0 LANGUAGES CXX)

# Specify the C++ standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Include directories
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

# Add source files to the target
add_library(crosshair_engine SHARED
    crosshair_engine.cpp
)

# Set output name based on platform
if(WIN32)
    set_target_properties(crosshair_engine PROPERTIES
        OUTPUT_NAME "crosshair_engine"
        PREFIX ""
    )
elseif(APPLE)
    set_target_properties(crosshair_engine PROPERTIES
        OUTPUT_NAME "crosshair_engine"
        PREFIX "lib"
        SUFFIX ".dylib"
    )
else()
    set_target_properties(crosshair_engine PROPERTIES
        OUTPUT_NAME "crosshair_engine"
        PREFIX "lib"
        SUFFIX ".so"
    )
endif()

# Set position independent code property
set_target_properties(crosshair_engine PROPERTIES
    POSITION_INDEPENDENT_CODE ON
)

# Define EXPORT macro for Windows DLL export if needed
if(WIN32)
    target_compile_definitions(crosshair_engine PRIVATE BUILDING_DLL)
endif()

# Set compiler flags
if(MSVC)
    target_compile_options(crosshair_engine PRIVATE /W4)
else()
    target_compile_options(crosshair_engine PRIVATE -Wall -Wextra -pedantic)
endif()

# Install the library to the bin directory
install(TARGETS crosshair_engine
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

# Install header files
install(FILES crosshair_engine.h
    DESTINATION include
)

# Add a debug message to show the library being compiled
message(STATUS "Configuring CrosshairEngine library")
