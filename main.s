    .section  .rodata
    
# string formats
invin:    .string "invalid input!\n"
inpsize:  .string "%d"
inpchar:  .string "%c"

    .section  .text
    
.globl  main
    .type main, @function 
main:
    
    pushq   %rbp            # save old frame pointer
    movq    %rsp, %rbp
    pushq   %r12            # save callie save registers
    pushq   %r13
    pushq   %r14
    pushq   %r15
    pushq   %rbx
    
    # getting the size of 1st Pstring
    subq    $8, %rsp        # allocating a quad for putting the input from scanf
    movq    $0, (%rsp)      # zero for safety
    movq    %rsp, %rsi      # loading the address to the 2nd paramater to scanf
	  movq	  $inpsize, %rdi  # loading the format to the 1st paramater to scanf
	  movq	  $0, %rax
	  call	  scanf
    movq    $0, %r14        # zero for safety
    movq    (%rsp), %r14    # move inputed size to %r14 for convinence
    movq    %rsp, %rsi      # loading address to the 2nd paramater to scanf
    movq    $inpchar, %rdi  # loading format to the 1st paramater to scanf
    movq    $0, %rax
    call    scanf           # get the dummy
    cmpq    $254, %r14      # decide if valid size for the Pstring (max size defined in the struct (255) - 1 because of '/0')
    ja      .invalid        # case invalid (using unsigned for all cases)
    
    # building the 1st Pstring
    subq    %r14, %rsp      # allocating the string size to be inputed
    subq    $2, %rsp        # two extra bytes for '/0' and the size of the string
    movq    %rsp, %r12      # save pointer to 1st Pstring 
    movq    %r14, (%rsp)    # put the size at the beginning of the Pstring
    movq    %rsp, %r15      # store begin adress Pstring for LOOP
    movq    $0, %rbx        # set counter to zero
    cmpq    $0, %r14        # case a zero size was entered, indicating empty string
    je      .FLOOP_END
    
.FLOOP:
    
    cmpq    %rbx, %r14      # compare counter to size
    jle     .FLOOP_END
    
    addq    $1, %r15        # increase address by one
    movq    %r15, %rsi      # load address as 2nd paramater to scanf
    movq    $inpchar, %rdi  # load format as 1st paramater to scanf
    movq    $0, %rax
    call    scanf
    addq    $1, %rbx        # increase counter by one
    jmp     .FLOOP
    
.FLOOP_END:
    
    addq    $1, %r15        # put '/0' instead of '\n'
    movq    $0, (%r15)      # put '/0' at the end of the string
    
    # getting the size of 2nd Pstring
    subq    $8, %rsp        # allocating a quad for putting the input from scanf
    movq    $0, (%rsp)      # zero for safety
    movq    %rsp, %rsi      # loading the address to the 2nd paramater to scanf
	  movq	  $inpsize, %rdi  # loading the format to the 1st paramater to scanf
	  movq	  $0, %rax
	  call	  scanf
    movq    $0, %r14        # zero for safety
    movq    (%rsp), %r14    # move inputed size to %r14 for convinence
    movq    %rsp, %rsi      # loading address to the 2nd paramater to scanf
    movq    $inpchar, %rdi  # loading format to the 1st paramater to scanf
    movq    $0, %rax
    call    scanf           # get the dummy
    cmpq    $254, %r14      # decide if valid size for the Pstring (max size defined in the struct (255) - 1 because of '/0')
    ja      .invalid        # case invalid (using unsigned for all cases)
    
    # building the 2nd Pstring
    subq    %r14, %rsp      # allocating the string size to be inputed
    subq    $2, %rsp        # two extra bytes for '/0' and the size of the string
    movq    %rsp, %r13      # save pointer to 1st Pstring 
    movq    %r14, (%rsp)    # put the size at the beginning of the Pstring
    movq    %rsp, %r15      # store begin adress Pstring for LOOP
    movq    $0, %rbx        # set counter to zero
    cmpq    $0, %r14        # case a zero size was entered, indicating empty string
    je      .SLOOP_END
    
.SLOOP:

    cmpq    %rbx, %r14      # compare counter to size
    jle     .SLOOP_END
    
    addq    $1, %r15        # increase address by one
    movq    %r15, %rsi      # load address as 2nd paramater to scanf
    movq    $inpchar, %rdi  # load format as 1st paramater to scanf
    movq    $0, %rax
    call    scanf
    addq    $1, %rbx        # increase counter by one
    jmp     .SLOOP
    
.SLOOP_END:
    
    addq    $1, %r15        # put '/0' instead of '\n'
    movq    $0, (%r15)      # put '/0' at the end of the string    
    
    # getting the option number
    subq    $8, %rsp        # allocating a quad for putting the input from scanf
    movq    $0, (%rsp)      # zero for safety
    movq    %rsp, %rsi      # loading the address to the 2nd paramater to scanf
	  movq	  $inpsize, %rdi  # loading the format to the 1st paramater to scanf
	  movq	  $0, %rax
	  call	  scanf
    movq    $0, %r14        # zero for safety
    movq    (%rsp), %r14    # move inputed size to %r14 for convinence
    movq    %rsp, %rsi      # loading address to the 2nd paramater to scanf
    movq    $inpchar, %rdi  # loading format to the 1st paramater to scanf
    movq    $0, %rax
    call    scanf           # get the dummy
    
    # calling run_func
    movq    %r14, %rdi      # loading the inputed number as the 1st paramater to run_func
    movq    %r12, %rsi      # loading the 1st Pstring as the 2nd paramater to run_func
    movq    %r13, %rdx      # loading the 2nd Pstring as the 3rd paramater to run_func
    call    run_func
    jmp     .END
    
    # case an invlid Pstring size (<0 || >254) was inputed
.invalid:
    
    movq    $invin, %rdi    # load format as paramater to printf
    movq    $0, %rax
    call    printf
    jmp     .END
    
.END:
        
    movq    $0,  %rax       # return 0
    movq    -40(%rbp), %rbx # restoring callie save registers
    movq    -32(%rbp), %r15
    movq    -24(%rbp), %r14
    movq    -16(%rbp), %r13 
    movq    -8(%rbp), %r12  
    movq    %rbp, %rsp      # restore old frame pointer
    popq    %rbp
    ret
