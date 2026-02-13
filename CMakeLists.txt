cmake_minimum_required(VERSION 3.30)
project(ImportStdDemo LANGUAGES CXX)

add_executable(import_std_demo
    src/main.cpp
)

target_compile_features(import_std_demo PRIVATE cxx_std_23)

if(MSVC)
    target_compile_options(import_std_demo PRIVATE /std:c++latest /experimental:module)

    # Some MSVC installs ship the standard library module sources (std.ixx) but no prebuilt IFCs.
    # In that case, compile the module interface unit as part of this target so `import std;` works.
    get_filename_component(_cl_dir "${CMAKE_CXX_COMPILER}" DIRECTORY)        # .../bin/Hostx64/x64
    get_filename_component(_host_dir "${_cl_dir}" DIRECTORY)                # .../bin/Hostx64
    get_filename_component(_bin_dir "${_host_dir}" DIRECTORY)               # .../bin
    get_filename_component(_msvc_root "${_bin_dir}" DIRECTORY)              # .../MSVC/<ver>
    set(_msvc_modules_dir "${_msvc_root}/modules")
    set(_msvc_std_ixx "${_msvc_modules_dir}/std.ixx")
    set(_msvc_std_compat_ixx "${_msvc_modules_dir}/std.compat.ixx")

    if(EXISTS "${_msvc_std_ixx}")
        set(_msvc_module_files "${_msvc_std_ixx}")
        if(EXISTS "${_msvc_std_compat_ixx}")
            list(APPEND _msvc_module_files "${_msvc_std_compat_ixx}")
        endif()

        target_sources(import_std_demo PRIVATE
            FILE_SET cxx_modules TYPE CXX_MODULES
            BASE_DIRS "${_msvc_modules_dir}"
            FILES ${_msvc_module_files}
        )
    endif()
endif()
