    .section  .rodata
    
# string formats
invin:    .string "invalid input!\n"

    .section  .text
    
.globl pstrlen
    .type pstrlen, @function
    
pstrlen:
    
    pushq   %rbp                # save old frame pointer
    movq    %rsp, %rbp
    
    movq    $0, %rax            # zero for safety
    movzbq  (%rdi), %rax        # move first byte (the size of the Pstring) to %rax
    
    movq    %rbp, %rsp          # restore old frame pointer
    popq    %rbp
    ret
    
.globl replaceChar
    .type replaceChar, @function

replaceChar:
    
    pushq   %rbp                # save old frame pointer
    movq    %rsp, %rbp
    pushq   %r12                # store callie save register
    
    movq    %rdi, %r12          # store address of Pstring
    call    pstrlen             # Pstring address is already in %rdi
    movq    %rax, %rcx          # store Pstring length
    movq    $1, %r8 		        # r8 is counter of for loop
    addq    $1, %rdi            # set %rdi to point to the string itself
    
								
					
.Start:	
    cmpq %rcx, %r8              # compare i to string length
    jg .End						          # case src.length < i
							
    cmpb (%rdi), %sil           # if string[i] == oldchar
    jne .Inc
							
    # swap
    movb %dl  , (%rdi)
							
.Inc:
    addq $1, %rdi
    addq $1, %r8                # i++
		jmp .Start
							
              			
.End:
      
    movq    %r12, %rax          # return Pstring address after change
    movq    -8(%rbp), %r12      # restore callie save register
    movq    %rbp, %rsp          # restore old frame pointer
    popq    %rbp
    ret

.globl pstrijcpy
    .type pstrijcpy, @function

pstrijcpy: 

    pushq   %rbp                # save old frame pointer
    movq    %rsp, %rbp
    pushq   %r12                # store callie save register
    pushq   %r13
    pushq   %r14
    
    movq    %rdi, %r14          # store dst Pstring address, which we'll return
    
    # get Pstring sizes
    movq    %rdi, %r12          # store 1st Pstring address
    movq    %rsi, %r13          # store 2nd Pstring address
    movq    %r12, %rdi          # load 1st Pstring as paramater to pstrlen
    call    pstrlen
    movq    %rax, %r8           # store 1st Pstring length
    movq    %r13, %rdi          # load 2nd Pstring as paramater to pstrlen
    call    pstrlen
    movq    %rax, %r9           # store 2nd Pstring length
    
    # checking if inputed indexes are valid
    cmpq  	$0, %rdx	          # compare i to 0
    jl      .Error					    # if x < 0
    cmpq 		%rdx, %rcx	        # compare i to j
    jl      .Error					    # if i > j
    cmpb 	  %r8b, %cl           # compare dst to j
    jge     .Error				      # if dst.length < j
    cmpb 	  %r9b , %cl 	        # compare src to j
    jge     .Error				      # if src.length < j
    cmpb 	  %r8b, %dl           # compare dst to i
    jge     .Error				      # if src.length < i
    cmpb 	  %r9b , %dl 	        # compare src to i
    jge     .Error				      # if des.length < i
    
    addq  	%rdx , %r13		      # src adress += i
    addq  	%rdx , %r12		      # des adress += i
    
.loop1:
				
    addq 	  $1, %r12   					# iterate on dst string
    addq 	  $1, %r13   					# iterate on src string
    addq 	  $1, %rdx						# i++
	
    # swap
    movq    $0, %r11            # zero for safety
	  movb	  (%r13) , %r11b      # load character from src string
	  movb 	  %r11b  , (%r12)     # insert character into dst string
				
				
	  cmpq 	  %rcx, %rdx          # compare i to j
	  jle     .loop1              # loop while i less or equal to j
    
	  jmp     .End54   
    
    
.Error:  
			   
    movq 	  $invin, %rdi	      # load format as paramater to printf
    movq 	  $0, %rax
    call    printf             	# print error message
    jmp     .End54

.End52:

    movq 	  %r14 , %rax	        # return dst Pstring adress
	  movq    -24(%rbp), %r14     # restore callie save registers
    movq    -16(%rbp), %r13 
    movq    -8(%rbp), %r12  
    movq    %rbp, %rsp          # restore old frame pointer
    popq    %rbp
    ret 
    
.globl swapCase
    .type swapCase, @function
    
swapCase:
    
    pushq   %rbp                # save old frame pointer
    movq    %rsp, %rbp
    pushq   %r12                # store callie save register
    pushq   %r13
    
    movq    %rdi, %r12          # store Pstring address
    movq    %rdi, %r13
    movq    $1, %rdx            # loop counter = 1
    call    pstrlen             # Pstrin adress is already in %rdi
    movq    %rax, %rsi          # store Pstring length
    addq    $1, %r12            # point Pstring pointer to the string itself
    
    # run until the end of  string
.Loop_beg:
    
    cmpq 	%rsi, %rdx
    jg .End_loop
		
    # swich big to small					
.Big:
    
    cmpb   $65, (%r12)
    jl .Inc1
    cmpb  $90, (%r12)
    jg .Small
				
    addb  $32, (%r12)
    jmp .Inc1

    # swich small to big	
.Small:
    cmpb	  $97, (%r12)
    jl .Inc1
    cmpb 	$122, (%r12)
    jg .Inc1
					
    subb 	$32, (%r12)
    jmp .Inc1

    # go to next index			
.Inc1:
				
   	addq	 $1, %rdx			        # move to the next character
    addq	 $1, %r12			        # move to the next character
    jmp .Loop_beg

    # return the new string
.End_loop:
					
    movq	  %r13, %rax 	        # return the first address of the string
    movq    -16(%rbp), %r13     # restore callie save registers
    movq    -8(%rbp), %r12  
    movq    %rbp, %rsp          # restore old frame pointer
    popq    %rbp
    ret
    
.globl pstrijcmp
    .type pstrijcmp, @function

pstrijcmp: 
    
    pushq   %rbp                # save old frame pointer
    movq    %rsp, %rbp
    pushq   %r12                # store callie save register
    pushq   %r13
    
    # get Pstring sizes
    movq    %rdi, %r12          # store 1st Pstring address
    movq    %rsi, %r13          # store 2nd Pstring address
    movq    %r12, %rdi          # load 1st Pstring as paramater to pstrlen
    call    pstrlen
    movq    %rax, %r8           # store 1st Pstring length
    movq    %r13, %rdi          # load 2nd Pstring as paramater to pstrlen
    call    pstrlen
    movq    %rax, %r9           # store 2nd Pstring length
    
    # checking if inputed indexes are valid
    cmpq  	$0, %rdx	          # compare i to 0
    jl      .Error54					  # if x < 0
    cmpq 		%rdx, %rcx	        # compare i to j
    jl      .Error54					  # if i > j
    cmpb 	  %r8b, %cl           # compare 1st to j
    jge     .Error54				    # if 1st.length < j
    cmpb 	  %r9b , %cl 	        # compare 2nd to j
    jge     .Error54				    # if 2nd.length < j
    cmpb 	  %r8b, %dl           # compare 1st to i
    jge     .Error54			 	    # if 1st.length < i
    cmpb 	  %r9b , %dl 	        # compare 2nd to i
    jge     .Error54				    # if des.length < i
				
				
    addq  	%rdx , %r13		      # 2nd adress += i
    addq  	%rdx , %r12		      # 1st adress += i
				
    subq  	%rdx, %rcx  	      # compute j - i
    addq 		$1, %rcx            # increment j, to fit our needs for the beginning of the loop 
    addq		$1, %r13            # set Pstring pointers to point to the string itself
    addq		$1, %r12
					
.Loop54:		
    
    # compare characters
    cmpq 	  $0, %rcx
    jle     .Equal
    movq 	  $0, %r10            # zero for safety
    movb 	  (%r13), %r10b       # save character from 2nd Pstring
    cmpb 	  (%r12), %r10b       # compare str1[i] to str2[i]
    jl      .Big54
    jg      .Small54
					
    # case equal, continue loop
    addq 		$1, %r12            # go to next character in 1st Pstring
    addq 		$1, %r13            # go to next character in 2nd Pstring
    subq 	  $1, %rcx
    jmp     .Loop54
						
    # case small return -1	
.Small54:
						
    movq 	  $-1, %rax           # return -1
    jmp     .End54
						
    # case big return 1
.Big54:

    movq    $1, %rax            # return 1
    jmp     .End54
					
					
    # case equal return 0
.Equal:
						
    movq 	  $0, %rax            # return 0
    jmp     .End54
						
					
    # case invalid indexes were inputed
.Error54:
    movq 	  $invin, %rdi        # load format as paramater to printf
    movq 	  $0, %rax
    call    printf
    movq 	  $-2,%rax            # return -2
    jmp     .End54
    
.End54:
    
    movq    -16(%rbp), %r13     # restore callie save registers
    movq    -8(%rbp), %r12  
    movq    %rbp, %rsp          # restore old frame pointer
    popq    %rbp
    ret
    
