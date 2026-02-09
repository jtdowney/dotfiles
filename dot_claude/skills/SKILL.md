---
name: elixir
description: Elixir language
---

# Elixir Skill

Comprehensive assistance with Elixir development, generated from official documentation.

## When to Use This Skill

This skill should be triggered when:
- Working with Elixir code or projects
- Asking about Elixir syntax, functions, or language features
- Implementing Elixir solutions or patterns
- Debugging Elixir code or understanding error messages
- Learning about Elixir's functional programming concepts
- Working with OTP (Open Telecom Platform) applications
- Questions about Elixir's actor model and processes
- Pattern matching and guard clause questions
- Macro development and metaprogramming

## Quick Reference

### Pattern Matching and Guards

**Basic Pattern Matching:**
```elixir
def drive(%User{age: age}) when age >= 16 do
  # Function only executes if user's age is 16 or greater
  :ok
end
```

**Guard Functions:**
```elixir
iex> is_number(13)
true
```

### Module Definition and Functions

**Defining a Module with Custom Operators:**
```elixir
defmodule MyOperators do
  # Define custom operators for max and min
  def a ~> b, do: max(a, b)
  def a <~ b, do: min(a, b)
end

# Usage:
iex> import MyOperators
iex> 1 ~> 2
2
iex> 1 <~ 2
1
```

### Comparison Operators

**Equality vs Strict Equality:**
```elixir
iex> 1 == 1.0
true
iex> 1 === 1.0
false
```

### Type System and Protocol Warnings

**String Interpolation Type Checking:**
```elixir
defmodule Example do
  def my_code(first..last//step = range) do
    "hello #{range}"  # Warning: Range doesn't implement String.Chars
  end
end
```

**For-Comprehension Type Checking:**
```elixir
defmodule Example do
  def my_code(%Date{} = date) do
    for(x <- date, do: x)  # Warning: Date doesn't implement Enumerable
  end
end
```

### Parallel Compilation

**Handling Module Dependencies:**
```elixir
defmodule MyLib.SomeModule do
  list = [...]
  
  # Use ParallelCompiler.pmap for spawned processes
  Task.async_stream(list, fn item ->
    # Ensure module is compiled before use
    Code.ensure_compiled!(MyLib.SomeOtherModule)
    MyLib.SomeOtherModule.do_something(item)
  end)
end
```

### Kernel Functions

**Selective Import:**
```elixir
import Kernel, except: [if: 2, is_number: 1]
```

**Structural Comparison:**
```elixir
1 < :an_atom  # Different data types can be compared
```

## Key Concepts

### Elixir's Type System (v1.19+)
- **Protocol Dispatch Checking**: Elixir now warns when values don't implement required protocols
- **Anonymous Function Inference**: Type checking for function captures and anonymous functions
- **Compile-time Warnings**: Enhanced error detection for type mismatches

### Compilation Improvements
- **Lazy Module Loading**: Modules load on-demand for better parallel compilation
- **Dependency Resolution**: Automatic detection and handling of module dependencies
- **Performance Scaling**: Up to 4x faster builds in large codebases

### Guards and Pattern Matching
- **Truthy/Falsy Values**: Only `false` and `nil` are falsy; everything else is truthy
- **Structural Comparison**: All Elixir terms can be compared using a defined ordering
- **Guard Functions**: Predefined set of functions that can be used in `when` clauses

## Reference Files

### elixir.md
Contains comprehensive Elixir documentation including:
- **Kernel Module**: Core functions and macros available everywhere
- **Type System**: New v1.19 type checking features and protocol dispatch
- **Operators**: Complete reference of all Elixir operators and precedence
- **Compilation**: Parallel compilation improvements and performance optimizations
- **Standard Library**: Built-in types, data structures, and system modules
- **Guards**: Pattern matching enhancements and guard functions
- **Examples**: Real code examples from official documentation

### other.md
Minimal reference file for additional documentation links.

## Working with This Skill

### For Beginners
- Start with basic pattern matching and function definition examples
- Focus on understanding guards and when clauses
- Learn about Elixir's data types and structural comparison

### For Intermediate Users
- Explore the new type system features in v1.19
- Understand protocol dispatch and implementation
- Learn about parallel compilation optimizations

### For Advanced Users
- Dive into custom operators and metaprogramming
- Explore OTP patterns and process-based architecture
- Understand compilation internals and performance tuning

### For Specific Tasks
- **Type Errors**: Check protocol implementations and type compatibility
- **Performance**: Use parallel compilation features and lazy loading
- **Pattern Matching**: Leverage guards and structural comparison
- **Custom DSLs**: Create custom operators (use sparingly)

## Notes

- This skill covers Elixir v1.19.0 with the latest type system improvements
- Examples are extracted from official Elixir documentation
- Focus on practical patterns and real-world usage
- Type system warnings help catch bugs at compile time
- Performance improvements scale with codebase size and CPU cores