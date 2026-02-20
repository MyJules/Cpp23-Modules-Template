add_library(mylib STATIC)
target_sources(mylib PUBLIC
    FILE_SET cxx_modules TYPE CXX_MODULES
    BASE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}"
    FILES
        mylib.cppm
)

add_executable(app main.cpp)
target_link_libraries(app PRIVATE mylib)

# enable_std_module(mylib PUBLIC)
