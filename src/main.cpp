import std;

int main() {
    std::println("Hello, {}", "World");

    std::ranges::for_each(std::views::iota(0, 5), [](int i) {
        std::println("Number: {}", i);
    });

    return 0;
}
