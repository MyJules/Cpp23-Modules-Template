import std;
import args;

int main(int argc, const char** argv) {
    auto args = args::to_span_view(argc, argv);

    std::println("{}", args);

    return 0;
}
