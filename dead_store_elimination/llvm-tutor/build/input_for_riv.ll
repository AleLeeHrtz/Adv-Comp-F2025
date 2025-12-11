; ModuleID = '../inputs/input_for_riv.c'
source_filename = "../inputs/input_for_riv.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo(i32 noundef %0, i32 noundef %1, i32 noundef %2) #0 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i32 %0, ptr %4, align 4
  store i32 %1, ptr %5, align 4
  store i32 %2, ptr %6, align 4
  %12 = load i32, ptr %4, align 4
  %13 = add nsw i32 123, %12
  store i32 %13, ptr %7, align 4
  %14 = load i32, ptr %4, align 4
  %15 = icmp sgt i32 %14, 0
  br i1 %15, label %16, label %41

16:                                               ; preds = %3
  %17 = load i32, ptr %4, align 4
  %18 = load i32, ptr %5, align 4
  %19 = mul nsw i32 %17, %18
  store i32 %19, ptr %8, align 4
  %20 = load i32, ptr %5, align 4
  %21 = load i32, ptr %6, align 4
  %22 = sdiv i32 %20, %21
  store i32 %22, ptr %9, align 4
  %23 = load i32, ptr %8, align 4
  %24 = load i32, ptr %9, align 4
  %25 = icmp eq i32 %23, %24
  br i1 %25, label %26, label %34

26:                                               ; preds = %16
  %27 = load i32, ptr %8, align 4
  %28 = load i32, ptr %9, align 4
  %29 = mul nsw i32 %27, %28
  store i32 %29, ptr %10, align 4
  %30 = load i32, ptr %7, align 4
  %31 = load i32, ptr %10, align 4
  %32 = mul nsw i32 2, %31
  %33 = sub nsw i32 %30, %32
  store i32 %33, ptr %7, align 4
  br label %40

34:                                               ; preds = %16
  store i32 987, ptr %11, align 4
  %35 = load i32, ptr %11, align 4
  %36 = load i32, ptr %6, align 4
  %37 = mul nsw i32 %35, %36
  %38 = load i32, ptr %9, align 4
  %39 = mul nsw i32 %37, %38
  store i32 %39, ptr %7, align 4
  br label %40

40:                                               ; preds = %34, %26
  br label %42

41:                                               ; preds = %3
  store i32 321, ptr %7, align 4
  br label %42

42:                                               ; preds = %41, %40
  %43 = load i32, ptr %7, align 4
  ret i32 %43
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
