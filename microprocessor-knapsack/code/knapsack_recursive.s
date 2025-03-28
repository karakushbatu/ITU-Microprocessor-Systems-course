    AREA Knapsack, CODE, READONLY

    EXPORT __main

__main
    ; Initialize the data (profit, weight arrays, and capacity)
    LDR     R0, =W_Capacity      ; R0 = Capacity (W_Capacity = 50)
    LDR     R1, =profit          ; R1 = Address of profit array
    LDR     R2, =weight          ; R2 = Address of weight array
    MOVS	R3, #3            ; R3 = Number of items (SIZE = 3)

    ; Call knapsack function
    BL      knapsack

    ; At the end of the program, R0 will hold the value from knapsack function
    ; R1 = profit array, R2 = weight array, R3 = dp array (if used)
    
    ; Infinite loop to end the program (to avoid returning to main in Keil)
    B	.

; Knapsack recursive function
knapsack
    ; Function parameters: R0 = W (capacity), R3 = n (number of items)
    CMP     R3, #0              ; If n == 0, return 0
    BEQ     knapsack_base_case

    CMP     R0, #0              ; If W == 0, return 0
    BEQ     knapsack_base_case

	LDR     R4, [R2, R3]        ; Load weight[n-1] (weight array is indexed by n-1, R3)
	CMP     R4, R0              ; If weight[n-1] > W, skip the item
    BGT     knapsack_skip_item

    ; Recursive case: knapsack(W, n-1) and profit[n-1] + knapsack(W-weight[n-1], n-1)
    SUBS     R3, R3, #1          ; Decrement n
    BL      knapsack            ; knapsack(W, n-1)
    MOV     R5, R0              ; Store result of knapsack(W, n-1) in R5

    LDR     R4, [R1, R3]    ; Load profit[n-1]
    LDR     R4, [R2, R3]        ; Load weight[n-1] (again, just use R3 directly)
    SUBS     R0, R0, R4          ; Subtract weight[n-1] from W
    BL      knapsack            ; knapsack(W - weight[n-1], n-1)
    ADD     R0, R0, R4          ; Add profit[n-1] to the result

    ; Take the maximum of knapsack(W, n-1) and profit[n-1] + knapsack(W-weight[n-1], n-1)
    CMP     R5, R0              ; Compare knapsack(W, n-1) with profit[n-1] + knapsack(W-weight[n-1], n-1)
    MOV     R0, R5              ; Default move R5 to R0
    BGE     knapsack_end        ; If knapsack(W, n-1) >= profit[n-1] + knapsack(W-weight[n-1], n-1), skip next instruction
    MOV     R0, R5              ; If the condition is met, move R5 into R0 (optional as default move already)
    B       knapsack_end

knapsack_skip_item
    ; Skip this item because weight[n-1] > W
    SUBS     R3, R3, #1          ; Decrement n
    BL      knapsack            ; knapsack(W, n-1)

knapsack_base_case
    ; Base case: If n == 0 or W == 0, return 0
    MOVS     R0, #0
    BX      LR                  ; Return from function

knapsack_end
    BX      LR                  ; Return from function

    AREA Knapsack_Data, DATA, READWRITE, ALIGN=4

W_Capacity  DCD 50                  ; Knapsack capacity
profit      DCD 60, 100, 120         ; Profit array
weight      DCD 10, 20, 30           ; Weight array
SIZE        DCD 3                   ; Number of items

    END