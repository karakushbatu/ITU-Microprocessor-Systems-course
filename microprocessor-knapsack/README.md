# 🧠 Microprocessor Knapsack Project

This repository contains my homework for **BLG 212E – Microprocessor Systems** course at Istanbul Technical University.

## 📌 Project Description

Implementation of the **0/1 Knapsack Problem** using **ARM Cortex-M0+** architecture in **assembly language**.  
Two versions are implemented as required:

- 🔁 Recursive solution (`knapsack_recursive.s`)
- 🔂 Iterative solution (`knapsack_iterative.s`)

These implementations follow constraints and structure suitable for **Keil µVision IDE v5**.

## 📁 File Structure

```
📦 microprocessor-knapsack
├── code/
│   ├── knapsack_recursive.s           # Recursive implementation (Q1.a)
│   ├── knapsack_iterative.s           # Iterative implementation (Q1.b)
│   └── reference_readonly_code.txt    # Reference (readonly) sample
│
└── docs/
    └── microprocessor_hw1_spec.pdf    # Homework description and constraints
```

## ⚙️ Notes

- `R0` holds the final result (max profit)
- `R1`, `R2`, and `R3` point to the `profit`, `weight`, and `dp` arrays respectively
- All functions start from label `__main`
- Line-by-line comments are included for grading compliance

## 🏫 Course Info

> **Course**: BLG 212E – Microprocessor Systems  
> **Instructor**: ITU CENG Department  
> **Term**: 2024–2025 Fall  
> **Student**: Batuhan Karakuş

## 📜 License

This project is part of a university homework and is shared for personal portfolio and academic reference purposes only.
