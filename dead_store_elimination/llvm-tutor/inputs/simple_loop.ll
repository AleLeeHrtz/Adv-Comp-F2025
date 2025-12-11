; Un loop simple con una instrucción invariante: %cst = add i32 %n, 1
; LICM debería mover %cst al preheader.

define i32 @sum(i32* %A, i32 %n) {
entry:
  br label %loop.preheader

loop.preheader:
  br label %loop

loop:
  %i = phi i32 [0, %loop.preheader], [%i.next, %loop]
  %s = phi i32 [0, %loop.preheader], [%s.next, %loop]

  ; INVARIANTE: depende sólo del argumento %n
  %cst = add i32 %n, 1

  ; NO invariante: depende de %i (IV)
  %gep = getelementptr inbounds i32, i32* %A, i32 %i
  %v = load i32, i32* %gep, align 4

  %s.next = add i32 %s, %v
  %i.next = add i32 %i, 1
  %cond = icmp slt i32 %i.next, %n
  br i1 %cond, label %loop, label %exit

exit:
  ret i32 %s.next
}
