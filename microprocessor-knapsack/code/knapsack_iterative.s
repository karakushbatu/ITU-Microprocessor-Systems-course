	PRESERVE8
    THUMB
        
    AREA text, CODE, READONLY     
    ALIGN                         
    EXPORT __main

; Define constants
W_CAPACITY EQU 50                 
SIZE       EQU 3                  

; Data section for arrays
    AREA data, DATA, READWRITE   
    ALIGN                        
profit  DCD 60, 100, 120         
weight  DCD 10, 20, 30           
dp      SPACE W_CAPACITY*4       ; Initialize dp array to 0

    AREA text, CODE, READONLY    
    ALIGN                        
__main PROC
    ; Store array addresses that we need to preserve
    LDR R1, =profit             
    LDR R2, =weight             
    LDR R3, =dp                 
    
    ; Clear dp array first
    MOVS R4, #0                 ; Initialize counter
    MOVS R5, #0                 ; Value to store (0)
clear_dp
    CMP R4, #W_CAPACITY
    BGE clear_dp_end
    LSLS R6, R4, #2            ; Multiply by 4 for offset
    STR R5, [R3, R6]           ; Store 0 in dp[i]
    ADDS R4, #1
    B clear_dp
clear_dp_end

    ; Save addresses for final state
    PUSH {R1-R3}
    
    ; Initialize parameters for knapsack
    MOVS R0, #W_CAPACITY        
    MOVS R1, #SIZE              
    PUSH {R0}                   ; Push W_CAPACITY for DC compliance
    BL knapsack                 
    POP {R0}                    ; Restore R0 after knapsack call
    
    ; Restore the required register values
    POP {R1-R3}
    
endless_loop
    B endless_loop              
    ENDP

knapsack PROC
    PUSH {R4-R7, LR}           
    
    ; Initialize outer loop (i = 0 to handle array indices correctly)
    MOVS R4, #0                
    
outer_loop
    CMP R4, R1                 ; Compare i with SIZE
    BGE outer_loop_end         
    
    ; Inner loop from W down to 0
    MOV R5, R0                 ; Use R5 as local variable for W_CAPACITY
    
inner_loop
    CMP R5, #0                 
    BLT inner_loop_end         
    
    ; Get weight[i]
    LDR R6, =weight       
    LSLS R7, R4, #2           ; i * 4 for word alignment
    LDR R6, [R6, R7]          ; R6 = weight[i]
    
    ; Check if weight[i] <= w
    CMP R6, R5
    BGT skip_update          
    
    ; Calculate w - weight[i]
    SUBS R7, R5, R6         
    
    ; Get dp[w - weight[i]]
    LDR R6, =dp
    LSLS R7, R7, #2         
    LDR R7, [R6, R7]       
    
    ; Get profit[i]
    LDR R6, =profit
    LSLS R2, R4, #2        
    LDR R6, [R6, R2]      
    ADDS R7, R7, R6        ; R7 = dp[w - weight[i]] + profit[i]
    
    ; Get current dp[w]
    LDR R6, =dp
    LSLS R2, R5, #2       
    LDR R6, [R6, R2]      
    
    ; Update dp[w] if new value is larger
    CMP R7, R6
    BLE skip_update       
    LDR R6, =dp
    STR R7, [R6, R2]     
    
skip_update
    SUBS R5, #1           ; w--
    B inner_loop
    
inner_loop_end
    ADDS R4, #1           ; i++
    B outer_loop
    
outer_loop_end
    ; Load final result into R4 to preserve R0
    LDR R6, =dp
    LSLS R7, R0, #2      ; W_CAPACITY * 4
    LDR R4, [R6, R7]     ; Load final result
    
    MOV R0, R4           ; Move result to R0 for return
    POP {R4-R7, PC}     
    ENDP
    
    END
