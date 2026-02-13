export module mylib;

import std;

export int add(int a, int b) {
    return a + b;
}

export std::string greet(std::string_view name) {
    return std::format("Hello, {}", name);
}
