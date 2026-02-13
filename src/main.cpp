import std;
import demo;

int main() {
    std::println("{}", greet("World"));
    std::println("2 + 3 = {}", add(2, 3));

    std::ranges::for_each(std::views::iota(0, 5), [](int i) {
        std::println("Number: {}", i);
    });

    return 0;
}
