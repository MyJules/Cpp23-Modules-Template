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

include(${CMAKE_CURRENT_LIST_DIR}/cmake/StdModules.cmake)

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
			SOURCE_DIR ${CMAKE_CURRENT_LIST_DIR}/vendor/googletest
			# URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
		)
		FetchContent_MakeAvailable(googletest)
	endif()

	add_subdirectory(tests)
endif()
