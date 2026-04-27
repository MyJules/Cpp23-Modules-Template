import std;
import args;

int main(int argc, const char** argv) {
    auto args = args::args_to_span(argc, argv);

    std::println("{}", args);

    return 0;
}
