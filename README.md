# Step 3: Using Mocks to Substitute HTTP Communication

In this stage you can see how you can use mocks to test complex behavior of dependencies. There are two layers of dependencies:
- `ConvertCurrency` codeunit depends on `ICurrencyConverter` interface
- `RESTCurrencyConverter` codeunit (implements `ICurrencyConverter`) depends on `IHttpInvoker` interface
- You want to test currency conversion with `RESTCurrencyConverter` codeunit
- This process depends on HTTP communication
- You must be able to test how currency conversion process will behave under different kinds of HTTP failures

While setup is not significantly more complicated for each individual test, you are able to write simple tests that legitimately validate the behavior of `RESTCurrencyConverter` codeunit under different scenarios that are possible (and expected) in production. At the same time, performance is still very fast.

> Note: The four different mock codeunits don't look much different than stubs, so you may wonder why are they called mocks instead of stubs. The reason is that these test examples are intentionally simple to focus your attention on the relevant content. For the same reason the IHttpInvoker interface only defines a single method (GET). In reality, you would have many more methods on this interface (POST, PUT, DELETE, etc.). Then, any of the mock codeunits would have to implement all of these methods and provide full functionality that mocks HTTP communication.
