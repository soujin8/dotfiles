# Test Review Checklist

Use these lenses to review PR tests. Do not report every category; report only concrete issues found in the PR.

## Behavior Coverage

- Verify every changed behavior has at least one test that would fail before the production change and pass after it.
- Look for missing tests around new branches, flags, permissions, validation rules, error paths, retries, ordering, pagination, state transitions, and boundary values.
- Check that bug fixes include a regression test reproducing the bug, not only a happy-path confirmation.
- For refactors, check that existing behavior is preserved by tests at the correct boundary.

Good finding pattern:

`The PR changes X when Y, but the tests only cover Z. Add a test that sets up Y, invokes the public entry point, and asserts X.`

## Assertion Quality

- Prefer assertions on observable behavior over implementation details.
- Flag tests that only assert "no error", object existence, call count, or snapshot shape when the important value or side effect is unverified.
- Check negative assertions and absence conditions when the PR prevents something from happening.
- For async, queues, events, or jobs, verify the test observes completion and asserts the final effect.
- For APIs, verify status, response body, persistence, authorization, and relevant side effects as appropriate.

## Test Boundary

- Prefer the narrowest test that gives confidence, but require integration coverage when behavior depends on wiring between components, persistence, routing, serialization, permissions, or framework callbacks.
- Flag over-mocked tests that reimplement the production logic in expectations or mock away the component under review.
- Flag broad tests that are slow or brittle when the same confidence could come from focused units plus one integration test.

## Fixtures and Test Data

- Test data should express the case under review with minimal irrelevant setup.
- Flag fixtures/factories that rely on implicit defaults hiding the important condition.
- Prefer named data that makes domain meaning obvious.
- Include edge values that matter: empty, nil/null, zero, max/min, duplicate, invalid, unauthorized, timezone boundary, locale, encoding, and concurrency-adjacent states when relevant.

## Isolation and Determinism

- Check for order dependence, shared mutable state, global config leakage, clock dependence, random data without seeding, network access, filesystem leakage, and timezone or locale assumptions.
- Ensure cleanup occurs for database records, temporary files, environment variables, feature flags, mocks, and stubs.
- For parallel test suites, flag shared identifiers, static paths, and global mocks that can collide.

## Maintainability and Intent

- Test names should describe behavior and condition, not internal implementation.
- Setup should make the important preconditions visible.
- Avoid duplicating production algorithms inside tests.
- Avoid large snapshots or golden files unless the diff signal is useful and stable.
- Prefer parameterized tests when many cases share the same behavior, but avoid hiding the purpose of each case.

## CI Confidence

- Check whether new tests are wired into the normal test command or CI job.
- Flag skipped, pending, flaky-retry-only, or quarantined tests that are the only coverage for a changed behavior.
- If the PR changes build/test configuration, verify both positive and failure paths for the configuration where practical.

## Reporting Guidance

For each issue, include:

- The review lens: coverage, assertion, boundary, fixture, determinism, maintainability, or CI.
- The exact missing or weak scenario.
- Why the current tests would pass despite a plausible bug.
- A concrete test to add or edit, including the subject under test, setup, action, and assertion.

Avoid:

- Asking for 100% coverage as a goal by itself.
- Requiring unit tests when an integration test is the better confidence boundary.
- Requiring integration tests when a focused unit test covers the changed behavior and wiring is already covered nearby.
- Penalizing project conventions unless they create a real risk in this PR.
