cmake_minimum_required(VERSION 3.30)
project(ImportStdDemo LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(import_std_demo src/main.cpp)

if(MSVC)
    target_compile_options(import_std_demo PRIVATE /experimental:module)

    # Build MSVC's std module from the shipped .ixx files so `import std;` works.
    set(_msvc_root "${CMAKE_CXX_COMPILER}")
    foreach(_ IN ITEMS 1 2 3 4)
        get_filename_component(_msvc_root "${_msvc_root}" DIRECTORY)
    endforeach()

    set(_msvc_modules_dir "${_msvc_root}/modules")
    set(_stl_modules "")
    foreach(_f IN ITEMS std.ixx std.compat.ixx)
        if(EXISTS "${_msvc_modules_dir}/${_f}")
            list(APPEND _stl_modules "${_msvc_modules_dir}/${_f}")
        endif()
    endforeach()

    if(_stl_modules)
        target_sources(import_std_demo PRIVATE
            FILE_SET cxx_modules TYPE CXX_MODULES
            BASE_DIRS "${_msvc_modules_dir}"
            FILES ${_stl_modules}
        )
    endif()
endif()
