; ModuleID = '../inputs/derived_loop.ll'
source_filename = "../inputs/derived_loop.ll"

define i32 @foo(ptr %A, i32 %n) {
entry:
  br label %loop.preheader

loop.preheader:                                   ; preds = %entry
  br label %loop

loop:                                             ; preds = %loop, %loop.preheader
  %i = phi i32 [ 0, %loop.preheader ], [ %i.next, %loop ]
  %idx = getelementptr inbounds i32, ptr %A, i32 %i
  %val = load i32, ptr %idx, align 4
  %iv_diff1 = sub i32 %i, 0
  %d_step_mul2 = mul i32 2, %iv_diff1
  %derived_repl3 = add i32 3, %d_step_mul2
  %sum = add i32 %val, %derived_repl3
  %i.next = add i32 %i, 1
  %iv_diff = sub i32 %i, 0
  %d_step_mul = mul i32 2, %iv_diff
  %derived_repl = add i32 3, %d_step_mul
  %j.next = add i32 %derived_repl, 2
  %cond = icmp slt i32 %i.next, %n
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %loop
  ret i32 %sum
}
