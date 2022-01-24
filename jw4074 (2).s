count_char:
        li $v0, 0

count_char_top:
        lbu $t0, 0($a1)  #save char of a1 in t0
        addi $a1, $a1, 1
        beqz $t0, count_char_exit #count_char_exit  #t1 track the string
        bne $t0, $a0, count_char_top #compare char saved in t0 with char pointed by a1.
        addi $v0, $v0, 1
        j count_char_top

count_char_exit:
        jr $ra
######################################################## DO NOT REMOVE THIS SEPARATOR
minmax_chars:
        lbu $v0, 0($a0)
        lbu $v1, 0($a0)

min_max_chars_top:

        addi $a0, $a0, 1
        lbu $t1, 0($a0)         #t1 points to the first char of t0(similar to strlen2)
        beqz $t1, minmax_chars_exit
        bgt $v0, $t1, update_min
        j max_loop
max_loop:       
        blt $v1, $t1, update_max
        j min_max_chars_top
          
update_min:
        move $v0, $t1
        j max_loop 
             
update_max: 
        move $v1, $t1
        j min_max_chars_top
    
minmax_chars_exit:
        jr $ra


######################################################## DO NOT REMOVE THIS SEPARATOR
make_leaf:

        sw $a0, 0($a2)
        sw $a1, 4($a2)
        sw $zero, 8($a2)
        sw $zero, 12($a2)
        sw $zero, 16($a2)


make_leaf_exit:
        jr $ra

######################################################## DO NOT REMOVE THIS SEPARATOR
merge_roots:


        sw $zero, 0($a2)
        sw $zero, 8($a2)
        sw $a0, 12($a2)
        sw $a1, 16($a2)
        lw $t1, 4($a0)
        lw $t2, 4($a1)
        add $t0, $t1, $t2
        sw $t0, 4($a2)
        li $t1, 1
        sw $t1, 8($a0)
        sw $t1, 8($a1)

merge_roots_exit:
        jr $ra
######################################################## DO NOT REMOVE THIS SEPARATOR

count_roots:
        li $v0, 0
        beq $a0, $a1, count_roots_exit

count_roots_top:
        beq $a0, $a1, count_roots_exit
        lw $t0, 8($a0)
        beqz $t0, add_count
        addi $a0, $a0, 20
        j count_roots_top

add_count:
        addi $v0, $v0, 1
        addi $a0, $a0, 20
        j count_roots_top

count_roots_exit:
        jr $ra
######################################################## DO NOT REMOVE THIS SEPARATOR

lightest_roots:
        lbu $v0, 0($a0)
        lbu $v1, 0($a1)

find_first_root:
        lw $t0, 8($a0)
        beqz $t0, update_first_root
        addi $a0, $a0, 20
        beq $a0, $a1, lightest_roots_exit
        j find_first_root

update_first_root:
        move $v0, $a0
        j find_second_root

find_second_root:

        addi $a0, $a0, 20
        lw $t0, 8($a0)
        beqz $t0, update_second_root
        beq $a0, $a1, lightest_roots_exit
        j find_second_root

update_second_root:
        move $v1, $a0
        j check_root_value

check_root_value:

        lw $t1, 4($v0)
        lw $t2, 4($v1)
        blt $t1, $t2, lightest_roots_top
        j swap_roots
swap_roots:
        addi $sp, $sp,-4
        sw  $t0, 0($sp)
        add $t0,$v0,$zero
        add $v0,$v1,$zero
        add $v1,$t0,$zero
        lw  $t0,4($sp)
	 addi $sp,$sp,4
        j lightest_roots_top

lightest_roots_top:

        beq $a0, $a1, lightest_roots_exit
        addi $a0, $a0, 20
        lw $t3, 8($a0)
        beqz $t3, compare_min_roots
        j lightest_roots_top

compare_min_roots:
        lw $t4, 4($a0)
        lw $t5, 4($v0)
        lw $t6, 4($v1)
        blt $t4, $t5, update_min_root
        blt $t4, $t6, update_second_root
        j lightest_roots_top

update_min_root:
        blt $t5, $t6, update_secondmin_root
        j lightest_roots_top


update_secondmin_root:
        addi $sp, $sp,-4
        sw  $t0, 0($sp)
        add $t0,$v0,$zero
        add $v0,$v1,$zero
        add $v1,$t0,$zero
        lw  $t0,4($sp)
        addi $sp,$sp,4
         move $v0, $a0
         j lightest_roots_top

lightest_roots_top:

        beq $a0, $a1, lightest_roots_exit
        addi $a0, $a0, 20
        lw $t3, 8($a0)
        beqz $t3, compare_min_roots
        j lightest_roots_top

compare_min_roots:
        lw $t4, 4($a0)
        lw $t5, 4($v0)
        lw $t6, 4($v1)
        blt $t4, $t5, update_min_root
        blt $t4, $t6, update_second_root
        j lightest_roots_top

update_min_root:
        blt $t5, $t6, update_secondmin_root
        j lightest_roots_top


update_secondmin_root:
        addi $sp, $sp,-4
        sw  $t0, 0($sp)
        add $t0,$v0,$zero
        add $v0,$v1,$zero
        add $v1,$t0,$zero
        lw  $t0,4($sp)
        addi $sp,$sp,4
         move $v0, $a0
         j lightest_roots_top

lightest_roots_exit:
        jr $ra

######################################################## DO NOT REMOVE THIS SEPARATOR

build_tree:
        li $v0, 0
        addi $sp, $sp,-24
        sw $ra,0($sp)
        sw  $s0, 4($sp) #save a0 pointer of string
        sw  $s1, 8($sp) #save build_tree pointer $a1 as start of the array
        sw  $s2, 12($sp) #save build_tree pointer at end of the array(last node)
        sw  $s3, 16($sp) #save min
        sw  $s4, 20($sp) #save max

#initialize variable and save build tree pointers
        move $s0, $a0 #$s0 saves the pointer $a0 at start of the string
        move $s1, $a1 #$s1 saves the beginning pointer to the array
        move $s2, $a1 #$s2 saves the end pointer to the array

#get_minmax
        move $a0, $s0
        jal minmax_chars
        move $s3,$v0    #save returned min in s3
        move $s4,$v1  #save returned max in s4

leaf_routine:
#get weight
        move $a0, $s3    #pass on min char
        move $a1, $s0  #pass on string
        jal count_char
        move $t3, $v0   #save weight in t3
#add leaf
        move $a0, $s3     #pass on the char
        move $a1, $t3     #pass on the weight
        move $a2, $s2     #put new leaf in memory
        jal make_leaf

#loop until max char
        addi $s3, $s3, 1
        bgt $s3, $s4, count_routine
        addi $s2, $s2, 20
        j leaf_routine

count_routine:
#count roots
        move $a0, $s1       #pass begin of array pointer onto $a0
        move $a1, $s2       #pass last node onto #a1
        jal count_roots
        move $t4, $v0
        bgt $t4, $zero, merge_routine  #if count_root returns >1, we merge
        j update_result

merge_routine:
#find lightest roots
        move $a0, $s1        #pass begin of array pointer onto $a0
        move $a1, $s2         #pass last node onto #a1
        jal lightest_roots
        move $t5, $v0        #save lightest root in $t5
        move $t6, $v1        #save second lightest root in $t6
#merge roots
        addi $s2, $s2, 20 #move array end pointer to the next position after the last node
        move $a0, $t5  #pass lightest root onto mrege_roots
        move $a1, $t6    #pass second  lightest root onto merge_roots
        move $a2, $s2    #pass on newly merged root at $s2
        jal merge_roots
        j count_routine

update_result:
        move $v0, $s2
        j build_tree_exit

build_tree_exit:
        move $a0, $s0
        move $a1, $s1
        lw $ra 0($sp)
        lw $s0, 4($sp)
        lw  $s1, 8($sp)
        lw  $s2, 12($sp)
        lw $s3, 16($sp)
        lw $s4, 20($sp)
        addi $sp, $sp, 24
        jr $ra


######################################################## DO NOT REMOVE THIS SEPARATOR

main:
	# save regs
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	la $a0, count_char_test1_in
	la $a1, count_char_test1_out
	jal count_char_tester
 
	la $a0, count_char_test2_in
	la $a1, count_char_test2_out
	jal count_char_tester

	la $a0, count_char_test3_in
	la $a1, count_char_test3_out
	jal count_char_tester

	la $a0, count_char_test4_in
	la $a1, count_char_test4_out
	jal count_char_tester
	
	la $a0, minmax_chars_test1_in
	la $a1, minmax_chars_test1_out 
	jal minmax_chars_tester
 
	la $a0, minmax_chars_test2_in
	la $a1, minmax_chars_test2_out
	jal minmax_chars_tester

	la $a0, minmax_chars_test3_in
	la $a1, minmax_chars_test3_out
	jal minmax_chars_tester
	
	la $a0, make_leaf_test1_in
	la $a1, make_leaf_test1_out
	jal make_leaf_tester
 
	la $a0, make_leaf_test2_in
	la $a1, make_leaf_test2_out
	jal make_leaf_tester
	
	la $a0, count_roots_test1_in
	la $a1, count_roots_test1_out
	jal count_roots_tester
 
	la $a0, count_roots_test2_in
	la $a1, count_roots_test2_out
	jal count_roots_tester
	jal print_newline
 
	la $a0, merge_roots_test1_in
	la $a1, merge_roots_test1_out	
	jal merge_roots_tester
 
	la $a0, merge_roots_test2_in
	la $a1, merge_roots_test2_out	
	jal merge_roots_tester

	la $a0, lightest_roots_test1_in
	la $a1, lightest_roots_test1_out	
 	jal lightest_roots_tester

	la $a0, lightest_roots_test2_in
	la $a1, lightest_roots_test2_out	
 	jal lightest_roots_tester

	la $a0, build_tree_test1_in
	la $a1, build_tree_test1_out
	jal build_tree_tester

	la $a0, build_tree_test2_in
	la $a1, build_tree_test2_out
	jal build_tree_tester
	
	jal print_newline
	jal print_newline

	# one last test, build the abc_string tree again and decompress a tiny string
	# should see 'cab' print to screen
	la $a0, abc_string
	la $a1, free_space
	jal build_tree
	move $a0, $v0
	la $a1, cab_message
	li $a2, 6
	jal decompress
	jal print_newline
	
	# now, build the final tree, and use to decompress message
	la $a0, english_frequency_string 
	la $a1, free_space
	jal build_tree
 	move $a0, $v0
	la $a1, final_message
	li $a2, 70
	jal decompress
	
	# restore regs
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	# and return
	jr $ra

count_char_tester:
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	# save args
	move $s0, $a0
	move $s1, $a1

	# print test case and inputs
	la $a0, count_char_tester_msg
	jal print_string
	lw $a0, 0($s0)
	jal print_char
	jal print_comma
	lw $a0, 4($s0)
	jal print_string
	jal print_newline

	# print expected output
	la $a0, tester_expecting_msg
	jal print_string
	lw $a0, 0($s1)
	jal print_int
	jal print_newline
  
	# run test!
	lw $a0, 0($s0)
	lw $a1, 4($s0)
	jal count_char
 
	# check result against expected
	lw $t0, 0($s1)
	beq $v0, $t0, count_char_tester_pass

	# error, save result
	move $s0, $v0
	
	# print error message and result
	la $a0, tester_error_msg
	jal print_string	
	move $a0, $s0
	jal print_int
	jal print_newline
 
	# exit
	li $v0, 10 
	syscall

count_char_tester_pass:
	# print pass message
	la $a0, tester_pass_msg
	jal print_string
	
	# restore regs and return
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	

minmax_chars_tester:	
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	# save args
	move $s0, $a0
	move $s1, $a1

	# print test case and inputs
	la $a0, minmax_chars_tester_msg
	jal print_string
	lw $a0, 0($s0)
	jal print_string
	jal print_newline

	# print expected result
	la $a0, tester_expecting_msg
	jal print_string
	lw $a0, 0($s1)
	jal print_char
	jal print_comma
	lw $a0, 4($s1)
	jal print_char	
	jal print_newline

	# run test!
	lw $a0, 0($s0)
	jal minmax_chars

	# check result
	lw $t0, 0($s1)
	bne $v0, $t0, minmax_chars_tester_fail
	lw $t0, 4($s1)
	bne $v1, $t0, minmax_chars_tester_fail

	# print pass message
	la $a0, tester_pass_msg
	jal print_string
	
	# restore regs and return
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra

minmax_chars_tester_fail:
	# error, save result
	move $s0, $v0
	move $s1, $v1

	# print error message and result
	la $a0, tester_error_msg
	jal print_string
	move $a0, $s0
	jal print_char
	jal print_comma
	move $a0, $s1
	jal print_char
	jal print_newline

	# exit
	li $v0, 10 
	syscall

make_leaf_tester:
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	# save args
	move $s0, $a0
	move $s1, $a1
	
	# print test case and inputs
	la $a0, make_leaf_tester_msg
	jal print_string
	lw $a0, 0($s0)
	jal print_char
	jal print_comma
	lw $a0, 4($s0)
	jal print_int
	jal print_comma
	la $a0, free_space_msg
	jal print_string
	jal print_newline

	# print expected result	
	la $a0, tester_expecting_msg
	jal print_string
	move $a0, $s1
	jal print_tree

	# run test!
	lw $a0, 0($s0)
	lw $a1, 4($s0)
	la $a2, free_space
	jal make_leaf
	
	# check result
	la $a0, free_space
	move $a1, $s1
	jal tree_match
	bnez $v0, make_leaf_tester_pass
 
	# print error
	la $a0, tester_error_msg
	jal print_string
	la $a0, free_space
	jal print_tree
	jal print_newline
 
	# exit
	li $v0, 10 
	syscall

make_leaf_tester_pass:
	# print pass message
	la $a0, tester_pass_msg
	jal print_string
	
	# restore regs and return
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra

merge_roots_tester:	
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	# save args
	move $s0, $a0
	move $s1, $a1
	
	# print test case and inputs
	la $a0, merge_roots_tester_msg
	jal print_string
	jal print_newline
	lw $a0, 0($s0)
	jal print_tree
	lw $a0, 4($s0)
	jal print_tree
	la $a0, free_space_msg
	jal print_string
	jal print_newline

	# print expected result	
	la $a0, tester_expecting_msg
	jal print_string
	jal print_newline
	lw $a0, 0($s1)
	jal print_tree

	# run test!
	lw $a0, 0($s0)
	lw $a1, 4($s0)
	la $a2, free_space
	jal merge_roots
 	
 	# check result
 	la $a0, free_space
 	lw $a1, 0($s1)
 	jal tree_match
 	bnez $v0, merge_roots_tester_pass

	# print error
	la $a0, tester_error_msg
	jal print_string
	la $a0, free_space
	jal print_tree
	jal print_newline
 
	# exit
	li $v0, 10 
	syscall

merge_roots_tester_pass:
	# print pass message
	la $a0, tester_pass_msg
	jal print_string
	
	# restore regs and return
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra

count_roots_tester:
	# save regs
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	# save args
	move $s0, $a0
	move $s1, $a1

	# print test case and inputs
	la $a0, count_roots_tester_msg
	jal print_string
	jal print_newline

	# s2: pointer to current node in array
	lw $s2, 0($s0)
count_roots_tester_loop_top:
	lw $t0, 4($s0)
	beq $s2, $t0, count_roots_tester_loop_exit
	# print node
	move $a0, $s2
	jal print_tree
	addi $s2, $s2, 20
	b count_roots_tester_loop_top

count_roots_tester_loop_exit:	
	# print expected output
	la $a0, tester_expecting_msg
	jal print_string
	lw $a0, 0($s1)
	jal print_int
	jal print_newline
  
	# run test!
	lw $a0, 0($s0)
	lw $a1, 4($s0)	
	jal count_roots
 
	# check result against expected
	lw $t0, 0($s1)
	beq $v0, $t0, count_roots_tester_pass
 
	# error, save result
	move $s0, $v0
	
	# print error message and result
	la $a0, tester_error_msg
	jal print_string	
	move $a0, $s0
	jal print_int
	jal print_newline
 
	# exit
	li $v0, 10 
	syscall
	
count_roots_tester_pass:
	# print pass message
	la $a0, tester_pass_msg
	jal print_string
	
	# restore regs and return
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 16($sp)
	addi $sp, $sp, 16
	jr $ra
lightest_roots_tester:	
	# save regs
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	# save args
	move $s0, $a0
	move $s1, $a1

	# print test case and inputs
	la $a0, lightest_roots_tester_msg
	jal print_string
	jal print_newline

	# s2: pointer to current node in array
	lw $s2, 0($s0)
lightest_roots_tester_loop_top:
	lw $t0, 4($s0)
	beq $s2, $t0, lightest_roots_tester_loop_exit
	# print node
	move $a0, $s2
	jal print_tree
	addi $s2, $s2, 20
	b lightest_roots_tester_loop_top

lightest_roots_tester_loop_exit:	
	# print expected result
	la $a0, tester_expecting_msg
	jal print_string
	jal print_newline
	lw $a0, 0($s1)
	jal print_tree
	lw $a0, 4($s1)
	jal print_tree	

	# run test!
	lw $a0, 0($s0)
	lw $a1, 4($s0)
	jal lightest_roots

	# save returned pointers 
	move $s0, $v0
	move $s2, $v1
	
	# check if lightest matches expecting
 	move $a0, $s0
 	lw $a1, 0($s1)
 	jal tree_match
 	beqz $v0, lightest_roots_tester_fail	

	# lightest matches, check second lightest
	move $a0, $s2
	lw $a1, 4($s1)
	jal tree_match
	beqz $v0, lightest_roots_tester_fail	

	# passed, so print pass message
	la $a0, tester_pass_msg
	jal print_string
	
	# restore regs and return
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
lightest_roots_tester_fail:
 
 	# print error message and result
 	la $a0, tester_error_msg
 	jal print_string
	jal print_newline
 	move $a0, $s0
 	jal print_tree
 	move $a0, $s2
 	jal print_tree

	# exit
 	li $v0, 10 
 	syscall

build_tree_tester:	
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	# save args
	move $s0, $a0
	move $s1, $a1

	# print test case
	la $a0, build_tree_tester_msg
	jal print_string
	jal print_newline
	lw $a0, 0($s0)
	jal print_string
	jal print_newline
	la $a0, free_space_msg
	jal print_string
	jal print_newline

	# print expected output
	la $a0, tester_expecting_msg
	jal print_string
	jal print_newline
	lw $a0, 0($s1)
	jal print_tree
 
	# run test!
	lw $a0, 0($s0)
	la $a1, free_space
	jal build_tree
	move $s0, $v0
	
  	# check result
  	move $a0, $s0
  	lw $a1, 0($s1)
  	jal tree_match 
  	bnez $v0, build_tree_tester_pass
  
  	# print error
  	la $a0, tester_error_msg
  	jal print_string
  	jal print_newline
  	move $a0, $s0
  	jal print_tree
  
  	# exit
  	li $v0, 10 
  	syscall
  	
build_tree_tester_pass:	
  	# print pass message
  	la $a0, tester_pass_msg
  	jal print_string
	
	# restore regs and return
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	# a0 root
	# a1 other root	
	# return 0 if not matching, 1 otherwise
tree_match:	
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	# save arguments
	move $s0, $a0
	move $s1, $a1

	# if both pointers null, return true
	or $t0, $s0, $s1
	beqz $t0, tree_match_exit_true

	# know one or the other is non-null, so if either one is null, have mismatch
	beqz $s0, tree_match_exit_false
	beqz $s1, tree_match_exit_false

	# now know both are non-null, so going to recurse

	# check if left children match
	lw $a0, 12($s0)
	lw $a1, 12($s1)
	jal tree_match
	beqz $v0, tree_match_exit_false # if false, return false from whole thing

	# check if right children match
	lw $a0, 16($s0)
	lw $a1, 16($s1)
	jal tree_match
	beqz $v0, tree_match_exit_false # if false, return false from whole thing
	
	# children match, now compare contents of the node
	lw $t0, 0($s0)
	lw $t1, 0($s1)
	bne $t0, $t1, tree_match_exit_false
	lw $t0, 4($s0)
	lw $t1, 4($s1)
	bne $t0, $t1, tree_match_exit_false
	lw $t0, 8($s0)
	lw $t1, 8($s1)
	bne $t0, $t1, tree_match_exit_false

tree_match_exit_true:
	li $v0, 1
	b tree_match_exit	

tree_match_exit_false:
	li $v0, 0
	
tree_match_exit:	
	# restore regs
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12
	jr $ra	


	# a0: tree root
	# a1: pointer to compressed text
	# a2: num bits compressed
decompress:	
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	# save args
	move $s0, $a0 # s0: root of tree
	move $s1, $a1 # s1: curr spot in compressed words
	move $s2, $a2 # s2: num bits to decompress
	              # s4: going to hold word of bits
	move $s5, $a0 # s5: curr position in tree

	# load first word of bits
	lw $s4, 0($s1)
	addi $s1, $s1, 4
	
decompress_top:
	# if processed all bits, done
	beqz $s2, decompress_exit

	# decrement bits to decompress
	addi $s2, $s2, -1
	
	# t0: bitmask for this bit
	li $t0, 1
	sllv $t0, $t0, $s2

	# t1: extracted bit 
	and $t1, $s4, $t0
	
	# if that was last bit in word, need to load new word
	li $t2, 1
	bne $t2, $t0, decompress_use_extracted_bit

	# load new word
	lw $s4, 0($s1)
	addi $s1, $s1, 4

decompress_use_extracted_bit:	
	# descend left or right
	beqz $t1, decompress_descend_left

	# descend right
	lw $s5, 16($s5)
	b decompress_leaf_check
	
decompress_descend_left:	
	lw $s5, 12($s5)

decompress_leaf_check:
	# if child pointer, not at leaf
	lw $t0, 12($s5)
	bnez $t0, decompress_done_with_bit

	# else at leaf, print char and reset to root
	lw $a0, 0($s5)
	jal print_char
	move $s5, $s0
	
decompress_done_with_bit:
#	jal print_newline
	b decompress_top

decompress_exit:
	jal print_newline
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)	
	lw $s5, 24($sp)
	addi $sp, $sp, 28
	jr $ra

print_tree:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $a1, 0
	jal __print_tree
	lw $ra, 0($sp)
	addi $sp, $sp, 4
        jr $ra
	
	
	# a0 root
	# a1 depth
__print_tree:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)	

	# save arguments
	move $s0, $a0
	move $s1, $a1

	# if has right child, recurse
	lw $a0, 16($s0)
	beqz $a0, __print_tree_node
	addi $a1, $s1, 2
	jal __print_tree
	
	# print this node info
__print_tree_node:
	move $a0, $s1
	jal print_spaces
	li $a0, '*'
	jal print_char
	jal print_space
	jal print_lbracket
	lw $a0, 0($s0)
	jal print_char
	jal print_comma
	lw $a0, 4($s0)
	jal print_int
	jal print_comma
	lw $a0, 8($s0)
	jal print_int
	jal print_rbracket	
 	jal print_newline

	# if has left child, recurse
	lw $a0, 12($s0)
	beqz $a0, __print_tree_exit
	addi $a1, $s1, 2
	jal __print_tree

__print_tree_exit:	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)		
	addi $sp, $sp, 12
	jr $ra

print_int:
	li $v0, 1
	syscall
	jr $ra

print_char:
	li $v0, 11
	syscall
	jr $ra
	
print_newline:
 	li $v0, 11
 	li $a0, '\n'
 	syscall
	jr $ra

print_plus:
 	li $v0, 11
 	li $a0, '+'
 	syscall
	jr $ra

print_colon:
 	li $v0, 11
 	li $a0, ':'
 	syscall
	jr $ra
	
print_equals:
 	li $v0, 11
 	li $a0, '='
 	syscall
	jr $ra

print_comma:
 	li $v0, 11
 	li $a0, ','
 	syscall
 	li $v0, 11
 	li $a0, ' '
 	syscall
	jr $ra

print_lbracket:
 	li $v0, 11
 	li $a0, '['
 	syscall
	jr $ra

print_rbracket:
 	li $v0, 11
 	li $a0, ']'
 	syscall
	jr $ra
	
print_dash:
 	li $v0, 11
 	li $a0, '-'
 	syscall
	jr $ra
	
print_space:
 	li $v0, 11
 	li $a0, ' '
 	syscall
	jr $ra

print_spaces:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	move $s0, $a0
print_spaces_top:
	beqz $s0, print_spaces_exit
	jal print_space
	addi $s0, $s0, -1
	b print_spaces_top
print_spaces_exit:	
	lw $ra, 0($sp)
	lw $s0, 4($sp)	
	addi $sp, $sp, 8
	jr $ra
	
print_string:
	li $v0, 4
	syscall
	jr $ra

print_hexword:
	# save regs
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	# s0: hexword
	move $s0, $a0
	# s1: nibble mask
	li $s1, 0xf0000000

	# print 0
	li $a0, 0
	li $v0, 1
	syscall
 
	# print x
	li $a0, 'x'
	li $v0, 11
	syscall

	# print nibble
	and $a0, $s0, $s1
	srl $a0, $a0, 28
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 24
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 20
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 16
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 12
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 8
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 4
	jal print_hexchar

	# print nibble
	srl $s1, $s1, 4
	and $a0, $s0, $s1
	srl $a0, $a0, 0
	jal print_hexchar
	
	# restore regs
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 12

 	jr $ra

print_hexchar:
	la $t0, hexchars
	add $t0, $t0, $a0
	lbu $a0, 0($t0)
	li $v0, 11
	syscall
	jr $ra
	
.data

hexchars:			.asciiz "0123456789abcdef"
tester_on_msg:			.asciiz "On: "
tester_expecting_msg:		.asciiz "Expecting: "
tester_pass_msg:		.asciiz "PASS!"
tester_error_msg:		.asciiz "ERROR! Got: "
count_char_tester_msg:		.asciiz "\n\nTesting count_char()\nOn: "
minmax_chars_tester_msg:	.asciiz "\n\nTesting minmax_chars()\nOn: "
count_roots_tester_msg:		.asciiz "\n\nTesting count_roots()\nOn: "
merge_roots_tester_msg:		.asciiz "\n\nTesting merge_roots()\nOn: "
make_leaf_tester_msg:		.asciiz "\n\nTesting make_leaf()\nOn: "
lightest_roots_tester_msg:	.asciiz "\n\nTesting lightest_roots()\nOn: "
build_tree_tester_msg:		.asciiz "\n\nTesting build_tree()\nOn: "
free_space_msg:			.asciiz "<pointer to free space>"
				 
abc_string:			.asciiz "aaaaabbbbccd"
some_good_string:		.asciiz "There is some good in this world, and it's worth fighting for."

array_of_nodes1_begin:	
array_of_nodes1_first:
	.word 'a', 120, 0, 0, 0
	.word 'b', 220, 1, 0, 0
array_of_nodes1_second:
	.word 'y', 320, 0, 0, 0
	.word 'c', 420, 1, 0, 0
	.word 'x', 520, 0, 0, 0
array_of_nodes1_end:	

array_of_nodes2_begin:	
	.word 'm', 20, 1, 0, 0
	.word '0', 20, 0, 0, 0
	.word ',', 20, 1, 0, 0
	.word '-', 20, 0, 0, 0
array_of_nodes2_end:	

array_of_nodes3_begin:
	.word 'm', 45, 1, 0, 0
	.word 'p', 93, 0, 0, 0
array_of_nodes3_second:
	.word 'x', 23, 0, 0, 0
	.word 'q', 25, 1, 0, 0
array_of_nodes3_first:	
	.word 'y', 18, 0, 0, 0
array_of_nodes3_end:	
	
count_char_test1_in:	.word 'a', abc_string
count_char_test1_out:	.word 5

count_char_test2_in:	.word 'i', some_good_string
count_char_test2_out:	.word 6

count_char_test3_in:	.word 'A', english_frequency_string
count_char_test3_out:	.word 519

count_char_test4_in:	.word 'R', english_frequency_string
count_char_test4_out:	.word 463

minmax_chars_test1_in:	.word abc_string
minmax_chars_test1_out:	.word 'a', 'd'

minmax_chars_test2_in:	.word some_good_string
minmax_chars_test2_out:	.word ' ', 'w'

minmax_chars_test3_in:	.word english_frequency_string
minmax_chars_test3_out:	.word 'A', 'Z'
	
make_leaf_test1_in:	.word 'b', 200, 0
make_leaf_test1_out:	.word 'b', 200, 0, 0, 0

make_leaf_test2_in:	.word 'x', 125, 0
make_leaf_test2_out:	.word 'x', 125, 0, 0, 0

count_roots_test1_in: 	.word array_of_nodes1_begin, array_of_nodes1_end
count_roots_test1_out:	.word 3

count_roots_test2_in: 	.word array_of_nodes2_begin, array_of_nodes2_end
count_roots_test2_out:	.word 2

lightest_roots_test1_in:	.word array_of_nodes1_begin, array_of_nodes1_end
lightest_roots_test1_out:	.word array_of_nodes1_first, array_of_nodes1_second

lightest_roots_test2_in:	.word array_of_nodes3_begin, array_of_nodes3_end
lightest_roots_test2_out:	.word array_of_nodes3_first, array_of_nodes3_second
	
test_node1:	.word 'b', 200, 0, 0, 0
test_node2:	.word 'c', 300, 0, 0, 0	

test_tree1:		.word 0, 500, 0, test_tree1_left, test_tree1_right
test_tree1_left:	.word 'b', 200, 1, 0, 0
test_tree1_right:	.word 'c', 300, 1, 0, 0	

merge_roots_test1_in:	.word test_node1, test_node2
merge_roots_test1_out:	.word test_tree1
	
abc_string_subtree_5: .word 'a', 5, 1, 0, 0
abc_string_subtree_4: .word 'b', 4, 1, 0, 0
abc_string_subtree_2: .word 'c', 2, 1, 0, 0
abc_string_subtree_1: .word 'd', 1, 1, 0, 0
abc_string_subtree_3: .word 0, 3, 1, abc_string_subtree_1, abc_string_subtree_2
abc_string_subtree_7: .word 0, 7, 1, abc_string_subtree_3, abc_string_subtree_4

abc_string_tree_5: .word 'a', 5, 1, 0, 0
abc_string_tree_4: .word 'b', 4, 1, 0, 0
abc_string_tree_2: .word 'c', 2, 1, 0, 0
abc_string_tree_1: .word 'd', 1, 1, 0, 0
abc_string_tree_3: .word 0, 3, 1, abc_string_tree_1, abc_string_tree_2
abc_string_tree_7: .word 0, 7, 1, abc_string_tree_3, abc_string_tree_4
abc_string_tree_12: .word 0, 12, 0, abc_string_tree_5, abc_string_tree_7

merge_roots_test2_in:	.word abc_string_subtree_5, abc_string_subtree_7
merge_roots_test2_out:	.word abc_string_tree_12
	
build_tree_test1_in:	.word abc_string
build_tree_test1_out:	.word abc_string_tree_12

build_tree_test2_in:	.word english_frequency_string
build_tree_test2_out:	.word english_frequency_6101
	
cab_message:	.word 0x0000002b

final_message:	.word 0x0000003f, 0x725e14d8, 0x5e63b1da
	
free_space: .space 20000
	
english_frequency_string:	.asciiz "LOOCAIESPNNOCIDTASAPGISAATLBYUCICFODPADSIINLIARVWOHHPOCEYLSLASIMEIIRBNDPAEHOAKEELUZUDTHERTAERGEAANWYLAGRSOEMLOEUTDETEULPPEEEOOCTIEIVNOTURINTRNGHRNAPTRTTMRIBHFTOMNCMPIEIFOCBFOROTHAYIDOGEGTAHEEIETLODKNSEISSYMRYOOUMOGPYLHECEMEAYETNISTFCOYNRINEIHHIRDEEULASSRHPECSSESYEADDPEDYFSNBOLILORLNJNIILOETLSWTOIINRSCABAAAECWNTYPTAEYKERIMFEANTURTHETNOAEKPRRGHSUKDNYHEHNCLTPEIBPNYMNMHEGUFLIDIEFHGTEFOILNAOBERUODIYREDNNNKTVTHIGOPELOLONOGEASRYXSCRIEEIAACECCRHKNTCESSVLYDSULRELSBNDRRNIAKGVATLMRWYVRHSARLNTEIRPWQOSNGEACATXNCTLURRTEHNEMOPVPEPIDANGBKIFMLLTSESETAEUNOECTADIROTPISEUTSNIDEABISSLOIPOTROMDIICDIDNETOLTHDTSNNCLCEMDEOISCASXOLCUUSVELEUEACETRZIARYDIRDASWUCEEISRLADEPSAFTCAESEOCTCMORITHSSTBEOXEPIAAAESNRTHONOARCINOREEOATEHEODCACNTAIFEFBIETCSOTUOEWTNOCPLADTNTTOFICDIUVCTBAIAOOTSZHHARATNTTRSOLNIRLLHNLSOTOEIKUACTMCLRIEMHIDNFTIYSTAWBSPEOLIUINNANNRLLCDRURCGMAIPGDYSBVNULNDESDIVOROMLALIOGBGPIUAEEIBZVAEIMPAURINECASRIMINATCLMRMDPGLOSBIERWROHONTECPGENSTNEOOOLBYBLSEINNYHRNCNRLREERECCRWDODMALOIMBIOFOLOOEPPHNHLEIERTMIICMITICMOFCSMEULDRNEWAELRHSETPFEILSBLNLCRHKRCXHMEEELERRNYPLWRBORGEARDAAINSTARWURPNSASAHLITIENAEMIAIRSNFTWOMOGRSSRFEROLKAKAITLCEOLUSASNLMRAIELIVOXWKCRYISOSXIHSLYKMEONREMKETTOUEEKIPASOOAUVSENEARBSHPWRTCACLSAFAELDOEVGOAOARISIMNCTRDETNSASBIIESTOEERUARRDIPEEABLIPHEFCINCLSTELBBSNLIEOIONEOTLZRLDTOECKGNCYRCSUBCEICLEXONHEILNWACRTUBOOTEAEIHAADOROIEPTLTRIENRDFUOAOEBAHHCNCRRTATIEUGTSRNMUHSLESOALNSISENNUAMEBPEWTSELUNCEOITHGAOPTSLMSEPSYARAEPIIUIBAEENSLERSERSELSTICAAOUMNTIAALASEOEVMCRPRLCDSGMDIRUSCTARACRTOUEPGLNEEGENOLANNRTPTIDRGIEIGDURADGLTOSPAEERADOWVAEELVLEDAATOETODFOAETUPPSUETTOEOCIPNNCEYNDIRLEAECIIAPOREPACEUATNLGLMHELNALFREANIGONEAISIAYSCNUBSDSENUODENEAHDLECNXCDHWRGACTTIREIRRSOLFNDRDSUDATVHPEBCNHNPHAORTINSAPGVOSGTTUHYBLCSNAYMORIEAONEEPEUDLNELILCNRSSSROTLOPRUTRIUOKOPAEPRRTLGUPOEKPFFPIUSBSOMERRRRHDLYGNALCNSEVDPHBETEUSLALCHNENAEARROMDTIUANOYTNSPPCSLSKCOERNTRDGMBPRNSTIACAPRTOADAITIEMILLDAERVNAITFRPNMNOOMLAERRARUARSLDDNEMBETRHNHREATEESPHHDTETWBDEANEULLWTTEVNNNYIPYTSRTTOIEIRILLIECUAENNTQEVRIZOEEARRAGBHARGNDRIEOITTTDUCJROISTQRDTUTEASETCNCEQRATTTISROAIDARTLOCLCEOIMRUADNNSHAUMEDCMHTPYFTUTOLRLPMSLELTIPSPOICCCEERIECUIBIPSPNBNECGNIROCMLOOIIRUYMRIEIEROUEPLAOASSNEAEIEAERLPNHRRNIHLTRRBSLESEBAEEMSNYDTNOUCJSNNDREEENEUTLUFIMRIERATAWTERWLICETTCNAIRETEUMNLONEAASYGVUEDARCRESULTTNNSKODLHOGNEAGEAECNTGRESIOISTRUDNGLRMUEAPATTKNKMIREULTNUEIYPTLPIKDAGESSOHMLICEVNMRCISNZOOILBNNIRORLIIHOELIRESCGFRUEBFOTEIISASELTMIINBSSXTKUKTRODYOGAEOEWTDNCLASEEOOUERFCCLILZDPGRTKAITCEOONTATEOGOIINGESNEUARNEAZEPHOOREPNWYNWKNSODEETCLEOSYOSPAATHHARCORCNZOIMEDSEISASVRIVETADPLEDCIAPANHTATEOITCPRKSMCILIOFAOLOUTELLEIGLSONLNINRSORRHMSACMRRAJENLAREAMEOEOTCOGURCLLOICSIREBUTIIKHANEORUEGEWFDMMEOIELAIUUUATSTHUOIAASTSCAUNURSSCEPNOTUAPNPTTACNANPFCBTCETLILEETSMCKIALUCCEIPRSPUETMTRDADYLNBDHOAAECYVRRCESHZKAUOCYMEMTENBEMWIIAUAEIHIMDASRNPCIDTCTCLDBSMLEAROSNRGADLFCNIITDGPIOWLNEFREALUOSCUBPOFRESIYLTORNETICSREETEEMITFUWSLIAINEDSLAIAEAHTEGATBRETOOBCCPTORRUBBOTOPSMAFNOKPOGAEANTTAGAHNDJDORUHCGOPMSTRAASBNIEIEUPLWRIIECNTDTSNAESHLOOLMNNRLCAEAADAFOGITEMTAIPNORLONCEEUORPNTDWNAGOOHRDSUUTINNUUATTCRNENSIONMIORTEKCCIOTLEIZREIWTLDNIZGOANUAXORTPAMTRAEMNHVQERJGPSARTHACMATSSMCRAYAINOCPICEFUONSRRNCFVSUOCEIDNSEGUEAUELONLERUHWUHLPSLELBSDCGHDEORPOSTFIKPCRRAMOSNNERONLANPHIFELFELEGASGTUNYOBPFAUOSEISGURRTEINRSIOTCAEOWLRNIOWETUUAETONUTXERYTRORLBEIMMENXHAFAIERLIRIIOIUOEAERENDTRHULNRTLEELSCEOEKIBIARIBKPOCPIUCTARUENPLEOEDRCEDWYDRHHASNICEWHREITIMDOIWADATAYOLAOEHDEPEELNUOFPYBVEFAOHOISAMRKARATOUGIORRTAETJOCIRGRVIIUEDLIRARIEOCAELIINATRSOELNSUYASLAEFOWORELNVGWETTRLUIUNUNHCTEEENAOTCNDAEALMRAIIIUABFIEADSVEEIWSHOOTDIGNIFTBORHEONMNCSCETARPGOUDTTANGESMBISLLHTCBEAEIMUISUSLIAETCNDSRNEHBEPCTTRFMTYILSAUAPAHEOAOAAAUGNENIFRTSIGONCEEELDGETFPTEGCSLOEEFVURFUINTHAAPEMDEUINAMSUUAIAPAUACBLOPEIATCLBMMAHEEDEYAYAORAYIMELNDLDEGEGIAMNMTFELEDSLASSLEAYLREAJAITSEYRAJPSTTETNTIOBCSRWERODDCOFUAINWDSENOAOHURYIIFYGGRAHRORSFEHAANITTERAMEWRLHHDMASRBAAPEYSPIUYECLARCRRDIOTRITDMTNBCVLDSEOEENPNYDNESPLNTTHSADULTPTALVSOIOIAAGOCNAYNIAVNORMMNYRAGHHLSGEEDVRWOEUOIINSAINSIAMMLPEATRRISBOECUXRLAIUENTKALDTTMRESATUFRLMTBAWVUEPOGBLGSHUOEAHYLRCARGOSKTRTGURGEACYOCYLKAHMEONISETENBRRGAEASGEEACUFMASOSIMESSLNSRCURMTSUIVOSDIBLLLEUSLUETEBTRURAGAFYONELKEUONSVEMAEBLDTHTDETNHPHITRNPTGONYCIAOVONEVAIEIEDPETHLROWICECLEEIOHEITMIIENEAYDAEEHRMELISSIONOSUSNPTRLSNAAIAVOAIPRANARLBETCSIASMTGEKMSUNOPAULCIYIRWMSMBLINEEWOETOKWEYNLHARSEBLFLWACOITAERIYGRGAGANNODEAZGAORRTTKGANLTNENNYEUMTNKITUNIOLOSSASGEGEENDCSLMRIRRCRNNOEPTMIUUILWAWDTAETAGPEHVENNERINEKNLKIAAIATNMOANWBNOEMTMKOOTOLMNBNUERONIDLTEIHDREEAIRHSENRBARTIDCIOEAYATMUCNOYEOINEAERYEEELUNCMAFYIIAEMSMSEREREFSBGNOCAHHYTWINIINYFRGPFADIOWTEERTNIODRIULRSSDFRGKNGTHRSLSARITARWEOTBCHERLOPCNEHESOEVTTNWPNTNATIEREIRHURYVNAODIISSBRRAATMHMAUGAGUPTNRMSNRILBNXCTHMLRUARRDNEINOAOTSIECUDBEEIOCLETRXNMIGTGAMRSGGDNIYOCIERTHNTIRRBSEWEPIATLAEODCRMLDGPSSSTRTIOTCRLMOSLCPIUOULDEESINFTROUDBMMMLTDKIDOOGHLGCPRECEMADLRTUOPCWEBDLUCIUAANUESEAMAHRAYMPCAPNOCAIIAKAPAGNBRANREFTEEATCAGANBNOEPNDBLRLRCETDAHOWGOESGJYIPHNOFSALMEEYCLIOAEOIGMATLIAERLLACRWRWTLFDTRDTOHFGAGEPGROLUCARBEIUSEENTEEELLTLIEEOTHSARINKGAFAWFVYAAACBNLEMLMFEEOFPEFTXLRCRATERECBCLDFSARVRCLSHGEMRFAICOOASAEBEFHOEMTMEHUNOTAESRURIEOSDHOAICNOVTOENRLLITIIVLAEOCSTFSIIRBCTYBEITSONFBILTYPPCPENLCRHEUGBDIECTPIGFATIGEARPPIHGGEEMSICNIPRKFMOBCHSRNONAHTORANTERFRIAPPDCPRNLNFRCCLMCETIRNLEAWSRQAOSOEAEHSVOAILHLNOKCSREIENYHIETOBHFMGSEALNOAAICOANLCNHRLUOAOANETARDMNIIRNHMVETPALDISQCHIHRASTWGEEIWNHGTAGEEHPRSINSOIAIINIIPAOCETNONTITAEODPNLOTRHICWNVREEETNLETVIAEICCYAEEEEUTMTSRFNCRYPOTMCIINOALRUIDMEOPYDMOREEASTROBNODSTTEBGREYDPITYEONUIOSRAUSLEMTABRSWOEOORLOOFETSFSYOCSAOOLNAEAZNLNTHRSTFDEAOBHCTONAFCONIELHRTGAHOEEHORTERRSSHCINJCREEATUEBAEIEORICTRMNNACNENREEWDDAERLIVILRRTCTOHRFBENAORAYCHBTAEUBRAEEEASRODROIIUSGESAARRNUFHDADIBNVNRICPYRINPEOREMNLNDINATIUCDAMKEDCNCTIJUTTZESLERKEMAKNFRAISHUDMRISFOEEQTTLVMLERTASTLHIOIKBRPSENPPSEUGIFRUOSESRKTWSDOATIHSBBEPEDAVUGALOSHHOSCMODOTSALHSOYTDNCEOCLSNIRNATOTORRETELRALSTIANHAIDHSEUOLSIEGATITCUAOERIFRSOTEHRTAEWLTEEATKPHOUESRFISAODUAAOUAAPOFBAMPAREULNEAEASUAYEURWATDLEADOOPMSOCHEALTONEDPKAMOIGONIILACLTSDHWPOECBKAGFARGPLTECRSDKORYIOFEUNWOPLOSAPREEULMUYITNOCROPRCIOUCORFQTMHRESRYILNOIITBCKIOLSLYKUAUHDGCERRAEMAAGONLAEPE"

english_frequency_519: .word 'A', 519, 1, 0, 0
english_frequency_126: .word 'B', 126, 1, 0, 0
english_frequency_277: .word 'C', 277, 1, 0, 0
english_frequency_207: .word 'D', 207, 1, 0, 0
english_frequency_682: .word 'E', 682, 1, 0, 0
english_frequency_110: .word 'F', 110, 1, 0, 0
english_frequency_151: .word 'G', 151, 1, 0, 0
english_frequency_183: .word 'H', 183, 1, 0, 0
english_frequency_461: .word 'I', 461, 1, 0, 0
english_frequency_12: .word 'J', 12, 1, 0, 0
english_frequency_67: .word 'K', 67, 1, 0, 0
english_frequency_335: .word 'L', 335, 1, 0, 0
english_frequency_184: .word 'M', 184, 1, 0, 0
english_frequency_407: .word 'N', 407, 1, 0, 0
english_frequency_438: .word 'O', 438, 1, 0, 0
english_frequency_193: .word 'P', 193, 1, 0, 0
english_frequency_9: .word 'Q', 9, 1, 0, 0
english_frequency_463: .word 'R', 463, 1, 0, 0
english_frequency_350: .word 'S', 350, 1, 0, 0
english_frequency_425: .word 'T', 425, 1, 0, 0
english_frequency_222: .word 'U', 222, 1, 0, 0
english_frequency_61: .word 'V', 61, 1, 0, 0
english_frequency_78: .word 'W', 78, 1, 0, 0
english_frequency_17: .word 'X', 17, 1, 0, 0
english_frequency_108: .word 'Y', 108, 1, 0, 0
english_frequency_16: .word 'Z', 16, 1, 0, 0
english_frequency_21: .word 0, 21, 1, english_frequency_9, english_frequency_12
english_frequency_33: .word 0, 33, 1, english_frequency_16, english_frequency_17
english_frequency_54: .word 0, 54, 1, english_frequency_21, english_frequency_33
english_frequency_115: .word 0, 115, 1, english_frequency_54, english_frequency_61
english_frequency_145: .word 0, 145, 1, english_frequency_67, english_frequency_78
english_frequency_218: .word 0, 218, 1, english_frequency_108, english_frequency_110
english_frequency_241: .word 0, 241, 1, english_frequency_115, english_frequency_126
english_frequency_296: .word 0, 296, 1, english_frequency_145, english_frequency_151
english_frequency_367: .word 0, 367, 1, english_frequency_183, english_frequency_184
english_frequency_400: .word 0, 400, 1, english_frequency_193, english_frequency_207
english_frequency_440: .word 0, 440, 1, english_frequency_218, english_frequency_222
english_frequency_518: .word 0, 518, 1, english_frequency_241, english_frequency_277
english_frequency_631: .word 0, 631, 1, english_frequency_296, english_frequency_335
english_frequency_717: .word 0, 717, 1, english_frequency_350, english_frequency_367
english_frequency_807: .word 0, 807, 1, english_frequency_400, english_frequency_407
english_frequency_863: .word 0, 863, 1, english_frequency_425, english_frequency_438
english_frequency_901: .word 0, 901, 1, english_frequency_440, english_frequency_461
english_frequency_981: .word 0, 981, 1, english_frequency_463, english_frequency_518
english_frequency_1150: .word 0, 1150, 1, english_frequency_519, english_frequency_631
english_frequency_1399: .word 0, 1399, 1, english_frequency_682, english_frequency_717
english_frequency_1670: .word 0, 1670, 1, english_frequency_807, english_frequency_863
english_frequency_1882: .word 0, 1882, 1, english_frequency_901, english_frequency_981
english_frequency_2549: .word 0, 2549, 1, english_frequency_1150, english_frequency_1399
english_frequency_3552: .word 0, 3552, 1, english_frequency_1670, english_frequency_1882
english_frequency_6101: .word 0, 6101, 0, english_frequency_2549, english_frequency_3552
