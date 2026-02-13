#include <gtest/gtest.h>

import std;

import demo;

TEST(DemoModule, Add) {
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(-10, 7), -3);
}

TEST(DemoModule, Greet) {
    EXPECT_EQ(greet("World"), std::string("Hello, World"));
    EXPECT_EQ(greet(""), std::string("Hello, "));
}
