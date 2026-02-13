add_executable(import_std_demo_tests
	test_demo.cpp
)

set(_gtest_main_target "")
if(TARGET GTest::gtest_main)
	set(_gtest_main_target GTest::gtest_main)
elseif(TARGET gtest_main)
	set(_gtest_main_target gtest_main)
endif()

if(NOT _gtest_main_target)
	message(FATAL_ERROR "Could not find gtest_main target (neither GTest::gtest_main nor gtest_main).")
endif()

target_link_libraries(import_std_demo_tests PRIVATE demo_lib ${_gtest_main_target})

if(MSVC)
	target_compile_options(import_std_demo_tests PRIVATE /experimental:module)
endif()

include(GoogleTest)
gtest_discover_tests(import_std_demo_tests)
