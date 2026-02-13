export module mylib;

import std;

export namespace mylib {

int add(int a, int b) {
    return a + b;
}

std::string greet(std::string_view name) {
    return std::format("Hello, {}", name);
}

}
