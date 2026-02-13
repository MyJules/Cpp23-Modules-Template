# CppModuleTemplate

A small **template** repo for a CMake-based **C++23** project using **C++ Modules** (including `import std;` on MSVC).

Targets:

- `mylib` (module in `src/mylib.ixx`)
- `app` (in `src/main.cpp`)
- `unit_tests` (GoogleTest in `tests/test_mylib.cpp`)

## Build

```powershell
cmake -S . -B build -G Ninja
cmake --build build
```

## Run

```powershell
./build/src/app.exe
```

## Test

```powershell
ctest --test-dir build --output-on-failure
```

Notes:
- Requires CMake 3.30+ and a C++23 compiler. On Windows, MSVC is the easiest path for modules + `import std;`.
- GoogleTest is found via `find_package(GTest CONFIG)` or fetched automatically via `FetchContent`.
