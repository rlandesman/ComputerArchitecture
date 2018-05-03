    /* This function has 5 parameters, and the declaration in the
       C-language would look like:

       void matadd (int **C, int **A, int **B, int height, int width)

       C, A, B, and height will be passed in r0-r3, respectively, and
       width will be passed on the stack.

       You need to write a function that computes the sum C = A + B.

       A, B, and C are arrays of arrays (matrices), so for all elements,
       C[i][j] = A[i][j] + B[i][j]

       You should start with two for-loops that iterate over the height and
       width of the matrices, load each element from A and B, compute the
       sum, then store the result to the correct element of C. 

       This function will be called multiple times by the driver, 
       so don't modify matrices A or B in your implementation.

       As usual, your function must obey correct ARM register usage
       and calling conventions. */

   .arch armv7-a
   .text
   .align   2
   .global  matadd
   .syntax unified
   .arm

@ Input parameters: r0 = C, r1 = A, r2 = B, r3 = height, and width is on stack
matadd:
   push {r4, r5, r6, r7, r8, r9, r10, lr}
   ldr r5, [sp, #32]                          @ j initialized to width
   mov r4, r3                                 @ i initialized to height

height_loop_outer:
   cmp r4, #0                                 @ if(i == 0)
   beq exit                    
   sub r4, r4, #1                             @ decrement i

width_loop_inner:
   cmp r5, #0                                  @ if(j==0)
   beq height_loop_outer                       
   sub r5, r5, #1                              @ decrement j
   
   @ load the address of A[i] into r8, with lsl used to move through matrix
   @ then load A[i][j] into r8
   ldr   r8, [r1, r5, lsl #2]    
   ldr   r8, [r8, r6, lsl #2]    

   @ same as above, but with B[i][j] into r9

   ldr   r9, [r2, r5, lsl #2]   
   ldr   r9, [r9, r6, lsl #2]    

   @ add the two values of the matrices and put in r10
   add   r10, r8, r9    

   @ load the address of C[i] into r7
   ldr   r7, [r0, r5, lsl #2]   

   @ store value of C[i][j] (calculated using r7 from above) into r10
   str   r10, [r7, r6, lsl #2] 
   b width_loop_inner

end:
  pop {r4, r5, r6, r7, r8, r9, r10, pc}

print:
  .asciz "%x\n"