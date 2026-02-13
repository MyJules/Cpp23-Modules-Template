add_library(mylib)
target_sources(mylib PUBLIC
    FILE_SET cxx_modules TYPE CXX_MODULES
    BASE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}"
    FILES
        mylib.ixx
)

add_executable(app main.cpp)
target_link_libraries(app PRIVATE mylib)


if(MSVC)
    msvc_enable_std_module(mylib PUBLIC)
endif()

