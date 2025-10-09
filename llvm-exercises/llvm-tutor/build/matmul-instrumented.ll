; ModuleID = '/home/ale/Homeworks/llvm-pass-skeleton/inputs/matmul-canonical.ll'
source_filename = "inputs/matmul.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@CounterFor_matmul = common global i32 0, align 4
@0 = private unnamed_addr constant [7 x i8] c"matmul\00", align 1
@CounterFor_main = common global i32 0, align 4
@1 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@ResultFormatStrIR = global [14 x i8] c"%-20s %-10lu\0A\00"
@ResultHeaderStrIR = global [225 x i8] c"=================================================\0ALLVM-TUTOR: dynamic analysis results\0A=================================================\0ANAME                 #N DIRECT CALLS\0A-------------------------------------------------\0A\00"
@llvm.global_dtors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 0, ptr @printf_wrapper, ptr null }]

; Function Attrs: noinline nounwind uwtable
define dso_local void @matmul(ptr noundef %0, ptr noundef %1, ptr noundef %2) #0 {
  %4 = load i32, ptr @CounterFor_matmul, align 4
  %5 = add i32 1, %4
  store i32 %5, ptr @CounterFor_matmul, align 4
  br label %6

6:                                                ; preds = %32, %3
  %.037 = phi i32 [ 0, %3 ], [ %33, %32 ]
  br label %7

7:                                                ; preds = %28, %6
  %.026 = phi i32 [ 0, %6 ], [ %29, %28 ]
  br label %8

8:                                                ; preds = %20, %7
  %.05 = phi i32 [ 0, %7 ], [ %21, %20 ]
  %.014 = phi double [ 0.000000e+00, %7 ], [ %19, %20 ]
  %9 = sext i32 %.037 to i64
  %10 = getelementptr inbounds [512 x double], ptr %0, i64 %9
  %11 = sext i32 %.05 to i64
  %12 = getelementptr inbounds [512 x double], ptr %10, i64 0, i64 %11
  %13 = load double, ptr %12, align 8
  %14 = sext i32 %.05 to i64
  %15 = getelementptr inbounds [512 x double], ptr %1, i64 %14
  %16 = sext i32 %.026 to i64
  %17 = getelementptr inbounds [512 x double], ptr %15, i64 0, i64 %16
  %18 = load double, ptr %17, align 8
  %19 = call double @llvm.fmuladd.f64(double %13, double %18, double %.014)
  br label %20

20:                                               ; preds = %8
  %21 = add nsw i32 %.05, 1
  %22 = icmp slt i32 %21, 512
  br i1 %22, label %8, label %23, !llvm.loop !6

23:                                               ; preds = %20
  %.01.lcssa = phi double [ %19, %20 ]
  %24 = sext i32 %.037 to i64
  %25 = getelementptr inbounds [512 x double], ptr %2, i64 %24
  %26 = sext i32 %.026 to i64
  %27 = getelementptr inbounds [512 x double], ptr %25, i64 0, i64 %26
  store double %.01.lcssa, ptr %27, align 8
  br label %28

28:                                               ; preds = %23
  %29 = add nsw i32 %.026, 1
  %30 = icmp slt i32 %29, 512
  br i1 %30, label %7, label %31, !llvm.loop !8

31:                                               ; preds = %28
  br label %32

32:                                               ; preds = %31
  %33 = add nsw i32 %.037, 1
  %34 = icmp slt i32 %33, 512
  br i1 %34, label %6, label %35, !llvm.loop !9

35:                                               ; preds = %32
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 {
  %1 = load i32, ptr @CounterFor_main, align 4
  %2 = add i32 1, %1
  store i32 %2, ptr @CounterFor_main, align 4
  %3 = alloca [512 x [512 x double]], align 16
  %4 = alloca [512 x [512 x double]], align 16
  %5 = alloca [512 x [512 x double]], align 16
  br label %6

6:                                                ; preds = %24, %0
  %.013 = phi i32 [ 0, %0 ], [ %25, %24 ]
  br label %7

7:                                                ; preds = %20, %6
  %.02 = phi i32 [ 0, %6 ], [ %21, %20 ]
  %8 = add nsw i32 %.013, %.02
  %9 = sitofp i32 %8 to double
  %10 = sext i32 %.013 to i64
  %11 = getelementptr inbounds [512 x [512 x double]], ptr %3, i64 0, i64 %10
  %12 = sext i32 %.02 to i64
  %13 = getelementptr inbounds [512 x double], ptr %11, i64 0, i64 %12
  store double %9, ptr %13, align 8
  %14 = sub nsw i32 %.013, %.02
  %15 = sitofp i32 %14 to double
  %16 = sext i32 %.013 to i64
  %17 = getelementptr inbounds [512 x [512 x double]], ptr %4, i64 0, i64 %16
  %18 = sext i32 %.02 to i64
  %19 = getelementptr inbounds [512 x double], ptr %17, i64 0, i64 %18
  store double %15, ptr %19, align 8
  br label %20

20:                                               ; preds = %7
  %21 = add nsw i32 %.02, 1
  %22 = icmp slt i32 %21, 512
  br i1 %22, label %7, label %23, !llvm.loop !10

23:                                               ; preds = %20
  br label %24

24:                                               ; preds = %23
  %25 = add nsw i32 %.013, 1
  %26 = icmp slt i32 %25, 512
  br i1 %26, label %6, label %27, !llvm.loop !11

27:                                               ; preds = %24
  %28 = getelementptr inbounds [512 x [512 x double]], ptr %3, i64 0, i64 0
  %29 = getelementptr inbounds [512 x [512 x double]], ptr %4, i64 0, i64 0
  %30 = getelementptr inbounds [512 x [512 x double]], ptr %5, i64 0, i64 0
  call void @matmul(ptr noundef %28, ptr noundef %29, ptr noundef %30)
  %31 = getelementptr inbounds [512 x [512 x double]], ptr %5, i64 0, i64 511
  %32 = getelementptr inbounds [512 x double], ptr %31, i64 0, i64 511
  %33 = load double, ptr %32, align 8
  %34 = call i32 (ptr, ...) @printf(ptr noundef @.str, double noundef %33)
  ret i32 0
}

; Function Attrs: nounwind
declare i32 @printf(ptr nocapture noundef readonly, ...) #2

define void @printf_wrapper() {
enter:
  %0 = call i32 (ptr, ...) @printf(ptr @ResultHeaderStrIR)
  %1 = load i32, ptr @CounterFor_main, align 4
  %2 = call i32 (ptr, ...) @printf(ptr @ResultFormatStrIR, ptr @1, i32 %1)
  %3 = load i32, ptr @CounterFor_matmul, align 4
  %4 = call i32 (ptr, ...) @printf(ptr @ResultFormatStrIR, ptr @0, i32 %3)
  ret void
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
