#[[
enable_std_module(<target> [<scope>])

Purpose
	Makes C++23 `import std;` work with CMake's modules support by adding the
	compiler/vendor-provided standard library module interface units to a target.

Arguments
	<target>
		CMake target name to modify.
	<scope>
		Optional: one of PRIVATE / PUBLIC / INTERFACE (defaults to PRIVATE).
		Use PUBLIC if consumers of the target also need the same std-module setup.

Behavior
	- MSVC:
			* Enables modules with /experimental:module.
			* Adds MSVC's shipped STL module units (std.ixx, std.compat.ixx) from the
				compiler's "modules" directory via a CXX_MODULES FILE_SET.

	- Clang (non-clang-cl):
			* Requires libc++ module units (std.cppm, optionally std.compat.cppm).
			* Adds -stdlib=libc++ and -fexperimental-library to compile options, and
				-stdlib=libc++ to link options, to match the produced BMIs.
			* Adds libc++'s module units via a CXX_MODULES FILE_SET.
			* Errors at configure-time if std.cppm cannot be found.

Notes
	- This function is a no-op for other compilers.
	- Clang path hints are geared toward typical LLVM/libc++ installs on Linux.

Example
	add_library(mylib)
	# ... add your own module interface units ...
	enable_std_module(mylib PUBLIC)
]]

function(enable_std_module target_name)
	set(_scope PRIVATE)
	if(ARGC GREATER 1)
		set(_scope "${ARGV1}")
	endif()

	# MSVC: build MSVC's std module from the shipped .ixx files so `import std;` works.
	if(MSVC)
		target_compile_options(${target_name} ${_scope} /experimental:module)

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
				FILE_SET std_modules TYPE CXX_MODULES
				BASE_DIRS "${_msvc_modules_dir}"
				FILES ${_stl_modules}
			)
		endif()
		return()
	endif()

	# Clang (non-MSVC): add libc++'s std module interface units so `import std;` works.
	if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
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

		target_sources(${target_name} ${_scope}
			FILE_SET std_modules TYPE CXX_MODULES
			BASE_DIRS "${_libcxx_cppm_dir}"
			FILES ${_libcxx_modules}
		)
	endif()
endfunction()
