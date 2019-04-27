    .section  .rodata
    
     .align 8                   # set up jump table by multiple of eight
.deter:
     .quad  .case1              # case 50
     .quad  .case2              # case 51
     .quad  .case3              # case 52
     .quad  .case4              # case 53
     .quad  .case5              # case 54
     .quad  .defcase            # def case 
    
# string formats
f50:     .string "first pstring length: %d, second pstring length: %d\n"
f51:     .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
f523:    .string "length: %d, string: %s\n"
f54:     .string "compare result: %d\n"
def:     .string "invalid option!\n"
inpchar: .string "%c"
inpint:  .string "%d"

    .section  .text
    
.globl run_func
    .type run_func, @function
    
run_func:
    
    pushq   %rbp                # save old frame pointer
    movq    %rsp, %rbp
    pushq   %r12                # save callie save registers
    pushq   %r13
    pushq   %r14
    pushq   %r15
    pushq   %rbx
    
    leaq    -50(%rdi), %rcx
    cmpq    $4, %rcx            # by substracting 50 we decide the case
    ja      .defcase            # case bigger or smaller (using unsigned for all cases)
    jmp     *.deter(,%rcx,8)    # jump according to the jump table 
    
    # case "50"
    .case1:  
        
        movq	  %rdx, %r12      # store 2nd Pstring address
        movq	  %rsi, %rdi      # load 1st Pstring as paramater for pstrlen
        call    pstrlen
        movq    %rax, %r8       # store ret val of pstrlen for 1st Pstring
        
        movq    %r12, %rdi      # load 2nd Pstring as paramater for pstrlen
        call    pstrlen
        movq    %rax, %r9       # store ret val for pstrlen for 2nd Pstring
        
        movq    $f50, %rdi      # load format as 1st paramater to printf
        movq    %r8, %rsi       # load 1st Pstring size as 2nd paramater to printf
        movq    %r9, %rdx       # load 2nd Pstring size as 3rd paramater to printf
        movq    $0, %rax
        call    printf
        jmp     .retlabel
     
    # case "51"    
    .case2:  
        
        movq    %rsi, %r12      # store both Pstrings
        movq    %rdx, %r13
        
        # getting old char
        leaq		-9(%rbp), %rax  # allocate memory for old char
        movq	  %rax, %rsi      # move address as 2nd paramater to scanf
        movl		$inpchar, %edi  # move format as 1st paramater to scanf
        movl    $0, %eax
        call    scanf
        movzbl	-9(%rbp), %eax  # take char from stack
        movsbl	%al, %eax       # take 1st byte
        movq	  $0, %r14				# zero for safety
			  movb	  %al, %r14b	    # move char to %r14
        
        # getting backSpace
        leaq		-9(%rbp), %rax  # allocate memory for new char
        movq	  %rax, %rsi        # move address as 2nd paramater to scanf
        movl		$inpchar, %edi  # move format as 1st paramater to scanf
        movl    $0, %eax
        call    scanf
        
        # getting new char
        leaq		-9(%rbp), %rax  # allocate memory for new char
        movq	  %rax, %rsi        # move address as 2nd paramater to scanf
        movl		$inpchar, %edi  # move format as 1st paramater to scanf
        movl    $0, %eax
        call    scanf
        movzbl	-9(%rbp), %eax  # take char from stack
        movsbl	%al, %eax       # take 1st byte
        movq	  $0, %r15				# zero for safety
			  movb	  %al, %r15b	    # move char to %r15
        
        # call replaceChar on 1st Pstring
        movq %r12 , %rdi        # load 1st Pstring as 1st paramater to replaceChar      
			  movq %r14 , %rsi        # load old char as 2nd paramater to replaceChar
			  movq %r15 , %rdx        # load new char as 3rd paramater to replaceChar
        call replaceChar
        
        # call replaceChar on 2nd Pstring
        movq %r13 , %rdi        # load 2nd Pstring as 1st paramater to replaceChar           
			  movq %r14 , %rsi        # load old char as 2nd paramater to replaceChar
			  movq %r15 , %rdx        # load new char as 3rd paramater to replaceChar
        call replaceChar
        
        # printing result        
        movq   $f51, %rdi       # load format as 1st paramater to printf
		    movq   %r14 , %rsi      # load old char as 2nd paramater to printf
			  movq   %r15 , %rdx      # load new char as 3rd paramater to printf
			  movq   %r12, %rcx       # load 1st Pstring as 4th paramater to printf, and increment its pointer to point to the string itself
			  addq   $1, %rcx
			  movq   %r13, %r8        # load 2nd Pstring as 5th paramater to printf, and increment its pointer to point to the string itself
			  addq   $1, %r8
        movq   $0, %rax
        call   printf
        jmp    .retlabel

    # case "52"
    .case3:  
        
        movq    %rsi, %r12      # store both Pstrings
        movq    %rdx, %r13
        
        subq		$8, %rsp        # allocate memory for inputed index
        movq	  $0 , (%rsp)     # zero for safety
        
        # get 1st index
        movq 	  %rsp , %rsi     # load address as 2nd paramater to scanf         		      
				movq 	  $inpint , %rdi  # load format as 1st paramater to scanf     		
				movq  	$0 , %rax
				call    scanf
        movq    $0, %r14        # zero for safety
				movq 		(%rsp) , %r14   # store index at %r14
        
        # get 2nd index
        movq    $0, (%rsp)      # zero for safety
        movq 	  %rsp , %rsi     # load address as 2nd paramater to scanf         		      
				movq 	  $inpint , %rdi  # load format as 1st paramater to scanf     		
				movq  	$0 , %rax
				call    scanf
        movq    $0, %r15        # zero for safety
				movq 		(%rsp) , %r15   # store index at %r15          
        
        # call pstrijcpy
       	movq 	  %r12 , %rdi     # load 1st Pstring as 1st paramater to pstrijcpy            
				movq 	  %r13 , %rsi     # load 2nd Pstring as 2nd paramater to pstrijcpy
				movq 	  %r14 , %rdx     # load 1st index as 3rd paramater to pstrijcpy
				movq 	  %r15 , %rcx     # load 2nd index as 4th paramater to pstrijcpy
				call   pstrijcpy
        
        # print 1st Pstring
        movq 	  %r12, %rdx      # load 1st Pstring 3rd paramater to printf        
				addq 	  $1 , %rdx       # increment the pString address so it will point to the string itself
				movq 	  %r12 , %rdi     # load 1st Pstring as paramater to pstrlen
				call    pstrlen 
				movq 	  %rax , %rsi     # load length as 2nd paramater to printf
				movq 	  $f523 , %rdi    # load format as 1st paramater to printf
        movq    $0, %rax
        call    printf
        
        # print 2nd Pstring
        movq 	  %r13, %rdx      # load 1st Pstring 3rd paramater to printf        
				addq 	  $1 , %rdx       # increment the pString address so it will point to the string itself
				movq 	  %r13 , %rdi     # load 1st Pstring as paramater to pstrlen
				call    pstrlen 
				movq 	  %rax , %rsi     # load length as 2nd paramater to printf
				movq 	  $f523 , %rdi    # load format as 1st paramater to printf
        movq    $0, %rax
        call    printf
        
        jmp     .retlabel
    
    # case "53"   
    .case4:  
        
        movq    %rsi, %r12      # store both Pstrings
        movq    %rdx, %r13
        
        # switch 1st Pstring
        movq    %r12, %rdi      # load 1st Pstring as paramater to swapCase
        call    swapCase
        
        # switch 2nd Pstring
        movq    %r13, %rdi      # load 2nd Pstring as paramater to swapCase
        call    swapCase
        
        # get Pstring sizes
        movq    %r12, %rdi      # load 1st Pstring as paramater to pstrlen
        call    pstrlen
        movq    %rax, %r8       # store 1st Pstring size
        movq    %r13, %rdi      # load 2nd Pstring as paramater to pstrlen
        call    pstrlen
        movq    %rax, %r9       # store 2nd Pstring size
        
        # print result
        movq 	  %r12, %rdx      # load 1st Pstring as 3rd paramater to printf
				addq    $1, %rdx        # increment Pstring address so that it points to the string itself
				movq 	  %r8, %rsi       # load its length as the 2nd paramater to printf
				movq 	  $f523, %rdi     # load format as 1st paramater to printf
        movq    %r9, %r12       # save 2nd Pstring size
				movq 	  $0, %rax
				call printf
        movq 	  %r13, %rdx      # load 2nd Pstring as 3rd paramater to printf
				addq    $1, %rdx        # increment Pstring address so that it points to the string itself
				movq 	  %r12, %rsi      # load its length as the 2nd paramater to printf
				movq 	  $f523, %rdi     # load format as 1st paramater to printf
				movq 	  $0, %rax
				call printf

        jmp     .retlabel

    # case "54"  
    .case5:  
        
        movq    %rsi, %r12      # store both Pstrings
        movq    %rdx, %r13
        
        subq		$8, %rsp        # allocate memory for inputed index
        movq	  $0 , (%rsp)     # zero for safety
        
        # get 1st index
        movq 	  %rsp , %rsi     # load address as 2nd paramater to scanf         		      
				movq 	  $inpint , %rdi  # load format as 1st paramater to scanf     		
				movq  	$0 , %rax
				call    scanf
        movq    $0, %r14        # zero for safety
				movq 		(%rsp) , %r14   # store index at %r14
        
        # get 2nd index
        movq    $0, (%rsp)      # zero for safety
        movq 	  %rsp , %rsi     # load address as 2nd paramater to scanf         		      
				movq 	  $inpint , %rdi  # load format as 1st paramater to scanf     		
				movq  	$0 , %rax
				call    scanf
        movq    $0, %r15        # zero for safety
				movq 		(%rsp) , %r15   # store index at %r15
        
        # call pstrijcmp
        movq   %r12 , %rdi      # load 1st Pstring as 1st paramater to pstrijcmp
				movq   %r13 , %rsi      # load 2nd Pstring as 2nd paramater to pstrijcmp
				movq   %r14 , %rdx      # load 1st index as 3rd paramater to pstrijcmp
				movq   %r15 , %rcx      # load 2nd index as 4th paramater to pstrijcmp
        call   pstrijcmp
        
        # print result
        movq    $f54, %rdi      # load format as 1st paramater to printf
        movq    %rax, %rsi      # load compare result as 2nd paramater to printf
        movq    $0, %rax
        call    printf

        jmp     .retlabel
    
    # default case
    .defcase:  
    
        movq    $def, %rdi
        movq    $0, %rax
        call    printf
        jmp     .retlabel
    
    .retlabel:
    
        movq    $0,  %rax       # return 0
        movq    -40(%rbp), %rbx # restoring callie save registers
        movq    -32(%rbp), %r15
        movq    -24(%rbp), %r14
        movq    -16(%rbp), %r13 
        movq    -8(%rbp), %r12  
        movq    %rbp, %rsp      # restore old frame pointer
        popq    %rbp
        ret
        
