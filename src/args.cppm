export module args;

import std;

export namespace args {
    auto to_span_view(int argc, const char** argv) {
        return std::span(argv, argc)
              | std::views::transform([](const char* s) {
                    return std::string_view(s);
                });
    }
}
