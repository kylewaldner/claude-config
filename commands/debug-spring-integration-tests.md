Help debug a failing Spring integration test by following this systematic debugging process

**Process Overview:**

1. **Identify the error** from the test output/logs provided by the user
   - Look for the error type: Bean conflicts, Result4k NPEs, Builder pattern issues, Assertion failures, or **500 Server Errors**
   - Note the file path and line number from the stack trace

2. **Read the failing source file** at the exact line from the stack trace
   - Understand what method call is failing
   - Identify which client/service is returning null or wrong value

3. **Determine what needs to be mocked**
   - Trace the call to identify: which client? which method? what should it return?
   - Common clients: `collectionsClient`, `stripeClient`, `invoiceClient`, `customerClient`, etc.

4. **Compare with main branch** to find the original mock configuration
   - Check `BaseIntegrationTest.kt` on main branch for `override fun createXxxClient()` methods
   - These show the original mock stubs that need to be migrated

5. **Add the missing stub** to the test's `Given...` method
   - Use pattern: `clientName.stub { onBlocking { method(any()) } doReturn Success(value) }`
   - Special case for builder pattern: use `doReturn this.mock`

6. **Verify the fix** and iterate if more errors appear

**Special Case: Debugging 500 Server Errors**

When tests fail with `500 Server Error` but no stack trace or error details:

1. **Identify the endpoint** - Look at the test to see which endpoint URL it's calling
2. **Read the endpoint source code** - Find the endpoint file and identify ALL dependencies it uses (clients, controllers, publishers)
3. **Check IntegrationTestConfiguration** - Verify each dependency has a `@Bean @Primary` mock definition
4. **Check test initialization** - Verify the test's `init` block stubs ALL methods called by the endpoint
5. **Key Insight**: **Mocked ≠ Stubbed** - A mock bean without stub behavior returns `null`, causing NPEs when code calls `.orThrow()`
6. **Solution**: Add the missing dependency to test constructor and stub it in `init` block

Example pattern for 500 errors:
```kotlin
class MyTest(
    // ... existing params
    myMissingDependency: MyDependency,  // ADD THIS
) : BaseIntegrationTest(...) {

    init {
        myMissingDependency.stub {  // ADD THIS
            onBlocking { method(any()) } doReturn Success(value)
        }
    }
}
```

**Mock State Pollution:**

If tests pass individually but fail when run together (e.g., `TooManyActualInvocations` errors):
- **For tests extending BaseIntegrationTest**: Add the mock parameter to BaseIntegrationTest constructor and add `Mockito.clearInvocations(mock)` to `cleanUp()`
- **For tests NOT extending BaseIntegrationTest**: Add `Mockito.clearInvocations(mock)` at the start of each `@Test` method

**Important Reminders:**
- Check for special cases (builder patterns, bean overriding, coroutine mocking)
- Compare with main branch factory methods to find missing stubs
- For Result4k NPEs, always look for missing mock stubs
- Use `onBlocking` for suspend functions, `on` for regular functions
- **500 errors = missing stub behavior** - trace through endpoint code to find which dependency needs stubbing

**Expected user input:**
- Test name or file path
- Error output and stack trace
- Confirmation they want to proceed with fixes

Be systematic, read the actual source files, and explain your reasoning at each step.
