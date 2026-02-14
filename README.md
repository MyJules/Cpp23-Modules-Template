# CppModuleTemplate

A small **template** repo for a CMake-based **C++23** project using **C++ Modules** (including `import std;` on MSVC).

Targets:

- `app` (in `src/main.cpp`)
- `unit_tests` (GoogleTest in `tests/test_mylib.cpp`)

Notes:
- Requires CMake 3.30+ and a C++23 compiler. On Windows, MSVC is the easiest path for modules + `import std;`.
- On Linux with Clang, `import std;` requires libc++ and its module interface units (e.g. Ubuntu apt.llvm.org packages: `libc++-20-dev` + `libc++abi-20-dev`).
- GoogleTest is found via `find_package(GTest CONFIG)` or fetched automatically via `FetchContent`.
