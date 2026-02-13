cmake_minimum_required(VERSION 3.30)
project(CppModuleTemplate LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(CTest)

function(msvc_enable_std_module target_name)
	if(NOT MSVC)
		return()
	endif()

	set(_scope PRIVATE)
	if(ARGC GREATER 1)
		set(_scope "${ARGV1}")
	endif()

	target_compile_options(${target_name} PRIVATE /experimental:module)

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
		target_sources(${target_name} ${_scope}
			FILE_SET msvc_std_modules TYPE CXX_MODULES
			BASE_DIRS "${_msvc_modules_dir}"
			FILES ${_stl_modules}
		)
	endif()
endfunction()

add_subdirectory(src)

if(BUILD_TESTING)
	include(FetchContent)

	find_package(GTest CONFIG QUIET)
	if(NOT GTest_FOUND)
		if(MSVC)
			set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
		endif()

		FetchContent_Declare(
			googletest
			URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
		)
		FetchContent_MakeAvailable(googletest)
	endif()

	add_subdirectory(tests)
endif()
