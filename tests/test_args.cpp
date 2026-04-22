#include <gtest/gtest.h>

import std;
import args;

TEST(ArgsTest, ToSpanView) {
    const char* argv[3] = {"program", "arg1", "arg2"};
    int argc = sizeof(argv) / sizeof(argv[0]);

    auto args = args::to_span_view(argc, argv);

    EXPECT_EQ(args.size(), 3);
    EXPECT_EQ(args[0], "program");
    EXPECT_EQ(args[1], "arg1");
    EXPECT_EQ(args[2], "arg2");
}

TEST(ArgsTest, EmptyArgs) {
    const char* argv[1] = {"program"};
    int argc = sizeof(argv) / sizeof(argv[0]);

    auto args = args::to_span_view(argc, argv);

    EXPECT_EQ(args.size(), 1);
    EXPECT_EQ(args[0], "program");
}