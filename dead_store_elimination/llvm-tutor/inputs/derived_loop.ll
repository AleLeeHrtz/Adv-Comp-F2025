; Base IV:   i = {0,+,1}<loop>
; Derived IV: j = {3,+,2}<loop>   (equiv a j = 2*i + 3)

define i32 @foo(i32* %A, i32 %n) {
entry:
  br label %loop.preheader

loop.preheader:
  br label %loop

loop:
  ; --- PHIs in loop header ---
  %i = phi i32 [ 0, %loop.preheader ], [ %i.next, %loop ]
  %j = phi i32 [ 3, %loop.preheader ], [ %j.next, %loop ]

  ; use both i and j so the pass has something to rewrite
  %idx  = getelementptr inbounds i32, i32* %A, i32 %i
  %val  = load i32, i32* %idx, align 4
  %sum  = add i32 %val, %j

  ; updates for next iter
  %i.next = add i32 %i, 1
  %j.next = add i32 %j, 2

  ; loop exit
  %cond = icmp slt i32 %i.next, %n
  br i1 %cond, label %loop, label %exit

exit:
  ret i32 %sum
}
