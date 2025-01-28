def add(n1, n2):
    return n1 + n2
def subtract(n1, n2):
    return n1 - n2
def divide(n1, n2):
    return n1 / n2
def multiply(n1, n2):
    return n1 * n2

operation = {
    "+": add,
    "-": subtract,
    "*": multiply,
    "/": divide,
}

num1 = input("What is the first number?: ")
for symbol in operation:
    print (symbol)
operation_symbol = input("Pick an operation: ")
num2 = input("What is the second number?: ")
answer = operation[operation_symbol](num1,num2)
print(f"{num1} {operation_symbol} {num2} = {answer}")
input (f"Type 'y' to continue calculating with the {answer}")