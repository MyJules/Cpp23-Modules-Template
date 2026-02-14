cmake_minimum_required(VERSION 3.30)
project(CppModuleTemplate LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_SCAN_FOR_MODULES ON)

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND NOT MSVC)
	add_compile_options(-stdlib=libc++ -fexperimental-library)
	add_link_options(-stdlib=libc++)
endif()

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

function(clang_enable_std_module target_name)
	if(NOT CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
		return()
	endif()

	if(MSVC)
		return()
	endif()

	# Clang needs libc++'s std module interface units to make `import std;` work.
	# The apt.llvm.org packages install these under /usr/lib/llvm-<major>/share/libc++/v1.
	string(REGEX MATCH "^[0-9]+" _clang_major "${CMAKE_CXX_COMPILER_VERSION}")
	set(_hints
		"/usr/lib/llvm-${_clang_major}/share/libc++/v1"
		"/usr/lib/llvm-${_clang_major}/share/libc++"
		"/usr/local/lib/llvm-${_clang_major}/share/libc++/v1"
		"/usr/share/libc++/v1"
	)

	find_file(_libcxx_std_cppm
		NAMES std.cppm
		HINTS ${_hints}
		NO_CACHE
	)
	find_file(_libcxx_std_compat_cppm
		NAMES std.compat.cppm
		HINTS ${_hints}
		NO_CACHE
	)

	if(NOT _libcxx_std_cppm)
		message(FATAL_ERROR
			"Clang build is using `import std;` but libc++'s std module interface unit (std.cppm) was not found.\n"
			"On Ubuntu with apt.llvm.org LLVM 20 packages, install: libc++-20-dev and libc++abi-20-dev.\n"
			"Expected to find it under something like /usr/lib/llvm-20/share/libc++/v1/std.cppm."
		)
	endif()

	get_filename_component(_libcxx_cppm_dir "${_libcxx_std_cppm}" DIRECTORY)

	# Ensure the whole target (and its direct consumers) builds/links against
	# libc++ with the same feature set as the generated std BMIs.
	target_compile_options(${target_name} PUBLIC -stdlib=libc++ -fexperimental-library)
	target_link_options(${target_name} PUBLIC -stdlib=libc++)

	# Avoid noisy warnings coming from libc++'s own module units.
	target_compile_options(${target_name} PRIVATE -Wno-reserved-module-identifier)

	set(_libcxx_modules "${_libcxx_std_cppm}")
	if(_libcxx_std_compat_cppm)
		list(APPEND _libcxx_modules "${_libcxx_std_compat_cppm}")
	endif()

	# Add the libc++ module interface units to this target so `import std;` works.
	target_sources(${target_name} PUBLIC
		FILE_SET clang_std_modules TYPE CXX_MODULES
		BASE_DIRS "${_libcxx_cppm_dir}"
		FILES ${_libcxx_modules}
	)
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
