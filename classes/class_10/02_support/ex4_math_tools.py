def fibonacci(n):
    """Calculates the n-th Fibonacci number using recursion.

    Args:
        n (int): The position in the Fibonacci sequence (starting from 0).

    Returns:
        int: The n-th Fibonacci number.

    Example:
        >>> fibonacci(6)
        8
    """
    if n <= 1:
        return n
    else:
        return fibonacci(n-1) + fibonacci(n-2)

if __name__ == "__main__":
    print(f"Fibonacci(6) = {fibonacci(6)}")
迫