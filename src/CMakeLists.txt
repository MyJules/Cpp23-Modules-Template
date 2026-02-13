add_library(demo_lib)
target_sources(demo_lib PUBLIC
    FILE_SET cxx_modules TYPE CXX_MODULES
    BASE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}"
    FILES
        demo.ixx
)

add_executable(import_std_demo main.cpp)
target_link_libraries(import_std_demo PRIVATE demo_lib)

msvc_enable_std_module(demo_lib PUBLIC)

if(MSVC)
    target_compile_options(import_std_demo PRIVATE /experimental:module)
endif()

