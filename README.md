# CppModuleTemplate

A small **template** repo for a CMake-based **C++23** project using **C++ Modules** (including `import std;` on MSVC).

Targets:

- `app` (in `src/main.cpp`)
- `unit_tests` (GoogleTest in `tests/test_mylib.cpp`)

Notes:
- Requires CMake 3.30+ and a C++23 compiler. On Windows, MSVC is the easiest path for modules + `import std;`.
- On Linux with Clang, `import std;` requires libc++ and its module interface units (e.g. Ubuntu apt.llvm.org packages: `libc++-20-dev` + `libc++abi-20-dev`).
- GoogleTest is found via `find_package(GTest CONFIG)` or fetched automatically via `FetchContent`.

Build with the default preset:

```powershell
cmake --preset default
cmake --build --preset default
ctest --preset default
```

The repository default preset uses the Ninja generator and writes build files to `build/ninja`.
In VS Code with CMake Tools, the workspace is configured to use CMake presets, so the same `default` preset is used there as well.
On Windows, the preset is defined for MSVC x64 with Ninja and pins `CMAKE_C_COMPILER`/`CMAKE_CXX_COMPILER` to `cl`. VS Code and Visual Studio can source that environment automatically; from a terminal, run the commands from a Developer PowerShell for Visual Studio or after calling `vcvars64.bat`.
