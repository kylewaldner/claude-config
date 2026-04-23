---
description: Review code changes in current branch against main, focusing on bugs and missing test coverage
---

You are performing a thorough code review of the changes in the current branch compared to the main branch.

## PR Context

${args}

## Your Task

1. **Get the diff**: Run `git diff main...HEAD` to see all changes in this branch
2. **Analyze the changes** for:
   - **Bugs and Logic Errors**: Look for off-by-one errors, null pointer issues, incorrect conditionals, race conditions, etc.
   - **Missing Test Coverage**: Identify new functions, classes, or edge cases that lack unit tests
   - **Error Handling**: Check if error cases are properly handled and tested
   - **Security Issues**: Look for potential vulnerabilities like SQL injection, improper input validation, exposed secrets
   - **Performance Issues**: Identify potential performance bottlenecks, N+1 queries, inefficient algorithms
   - **Code Quality**: Check adherence to SOLID principles, DDD patterns, and the project's architectural guidelines
   - **Edge Cases**: Identify boundary conditions that may not be handled
   - **Resource Leaks**: Check for unclosed connections, streams, or other resources
   - **Concurrency Issues**: Look for race conditions, deadlocks, or improper synchronization
   - **Integration Points**: Ensure external service calls have proper error handling and timeouts

3. **Review Tests**: For any test files changed or added:
   - Check if tests cover both happy paths and error cases
   - Verify that tests are meaningful and not just testing the obvious
   - Look for missing edge case tests
   - Ensure mocks are used appropriately

4. **Feedback**: Create a structured review with:
   - Critical issues (bugs, security vulnerabilities)
   - Missing test coverage (specific test cases that should be added)
   - Potential improvements (performance, maintainability)


## Output Format

Structure your review as:

### Critical Issues
- [List any bugs or security issues with file paths and line numbers]

### Missing Test Coverage
- [List specific test cases that should be added, organized by file]

### Potential Improvements
- [Suggest refactorings or optimizations with rationale]

Be specific with file paths and line numbers when referencing code. Focus on actionable feedback.
