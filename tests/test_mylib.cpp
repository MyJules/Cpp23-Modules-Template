#include <gtest/gtest.h>

import std;
import mylib;

TEST(MyLib, Add) {
    EXPECT_EQ(mylib::add(2, 3), 5);
    EXPECT_EQ(mylib::add(-10, 7), -3);
}

TEST(MyLib, Greet) {
    EXPECT_EQ(mylib::greet("World"), std::string("Hello, World"));
    EXPECT_EQ(mylib::greet(""), std::string("Hello, "));
}
