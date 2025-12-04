# Testing Notes & Learnings

## Test Coverage Achievement

**Date**: December 2024  
**Final Coverage**: 97.36% (221/227 lines)  
**Target**: 95%+

## Key Learnings

### 1. Abstract Method Testing Pattern

When testing abstract base classes like `TrackableEntriesController`, we discovered that the abstract methods (which raise `NotImplementedError`) were not being covered. 

**Solution**: Create minimal test subclasses that intentionally don't implement required methods, then test that calling those methods raises the expected error:

```ruby
controller_class = Class.new(TrackableEntriesController) do
  def model_class
    FoodEntry
  end
  # Don't implement entry_params
end

expect {
  controller_class.new.send(:entry_params)
}.to raise_error(NotImplementedError)
```

This pattern ensures all abstract method definitions are covered.

### 2. Edge Case Coverage

Common uncovered areas we identified and fixed:

- **Early return paths**: Methods with `return unless condition` - test the path where condition is false
- **View conditionals**: Test empty states, nil value handling, conditional rendering branches
- **Error handling**: Test rescue blocks by triggering the error conditions
- **Parameter handling**: Test nil, empty string, and invalid values for all parameters

### 3. Request Specs vs Controller Specs

We found that request specs provide better integration testing and are preferred for testing controller actions. Controller specs are still useful for:
- Testing abstract base classes
- Testing private methods
- Testing shared concerns

### 4. Referer Fallback Testing

When testing `request.referer` fallback logic, use the `headers` parameter in request specs:

```ruby
get new_food_entry_path, headers: { 'HTTP_REFERER' => timeline_path }
```

### 5. View Testing Patterns

Views have many conditional branches that need coverage:
- Empty state messages (`if collection.any?`)
- Conditional links (`if !is_today`)
- Nil value handling (`item[:entry].severity.present?`)
- Different entry type rendering

Test these by creating data in different states (empty collections, nil values, different dates, etc.).

### 6. Coverage Gaps to Watch For

When adding new code, ensure you test:
1. **Abstract methods** - If creating a base class, test that unimplemented methods raise errors
2. **Private method early returns** - Test all conditional return paths
3. **View conditionals** - Test both branches of if/else statements
4. **Error paths** - Test rescue blocks and error handling
5. **Parameter validation** - Test nil, empty, and invalid inputs
6. **Fallback logic** - Test default values and fallback paths

## Test Organization

### Spec File Structure

```
spec/
├── models/              # Model specs (validations, scopes, methods)
├── controllers/          # Controller specs (abstract classes, concerns)
├── requests/            # Request specs (integration tests, routing)
└── factories/           # FactoryBot factories
```

### Naming Conventions

- Model specs: `spec/models/{model_name}_spec.rb`
- Request specs: `spec/requests/{controller_name}_spec.rb`
- Controller specs: `spec/controllers/{controller_name}_spec.rb`

## Maintaining High Coverage

1. **Run tests frequently**: `bundle exec rspec` after each change
2. **Check coverage report**: Review `coverage/index.html` to identify gaps
3. **Test edge cases first**: These are often the uncovered lines
4. **Follow TDD**: Write tests before code to ensure coverage from the start
5. **Review PRs for coverage**: Ensure new code doesn't decrease overall coverage

## Tools Used

- **RSpec**: Testing framework
- **FactoryBot**: Test data generation
- **SimpleCov**: Coverage measurement
- **Shoulda Matchers**: Model validation testing

## Coverage History

- Initial: ~30% (estimated)
- After TDD implementation: 94.71% (215/227)
- Final: 97.36% (221/227)

## Remaining Uncovered Lines (6 lines)

The remaining 6 uncovered lines are likely:
- Rare error conditions
- Edge cases in view rendering
- Unused code paths

These should be addressed as they're encountered or when refactoring.

