;; extends
; ((task_list_marker_unchecked)
;  @text.todo.unchecked
;  (#offset! @text.todo.unchecked 0 -2 0 0)
;  (#set! conceal "✘"))
; ((task_list_marker_checked)
;  @text.todo.checked
;  (#offset! @text.todo.checked 0 -2 0 0)
;  (#set! conceal "✔"))
; (list_item (task_list_marker_checked) (_) @comment.syntax)

; @org.checkbox.checked
; (checkbox (_) @comment.syntax)
((listitem (checkbox status: (expr "str"))) @comment.syntax)

