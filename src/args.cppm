export module args;

import std;

export namespace args {
    auto to_span(int argc, const char** argv) {
        return std::span(argv, argc);
    }
}
