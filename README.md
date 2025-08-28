# Erblint::Agent

Template style checking for Ruby projects aimed at AI agents.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'erb_lint', require: false
  gem 'erblint-agent', require: false
end
```

And then execute:

```bash
bundle install
```

## Usage

### Configuration

Require the lint rules from this library. Currently, the only supported way is to add a new file in `.erb-linters/erblint_agent.rb` with the line:

```ruby
require 'erblint/agent/linters'
```

Create or update your `.erb-lint.yml` configuration file:

```yaml
---
inherit_gem:
  erblint-agent:
    - config/default.yml
linters:
  Agent::NoDirectSvgTag:
    # message: "Custom error message" # Optional: customize the error message

  Agent::NoDirectEmoji:
    # message: "Custom error message" # Optional: customize the error message

  Agent::NoSpecificClasses:
    forbidden_classes:
      "card": "Use 'CardComponent' instead"
```

### Running the Linters

Run erb-lint with:

```bash
bundle exec erblint --lint-all
```

Or check specific files:

```bash
bundle exec erblint app/views/**/*.erb
```

## Available Linters

### Agent::NoDirectSvgTag

Prohibits direct use of SVG tags. Recommends using Tailwind CSS Icons instead.

**Configuration:**
```yaml
Agent::NoDirectSvgTag:
  enabled: true
  message: "Custom error message" # Optional: override default message
```

**Bad:**
```erb
<svg>...</svg>
<svg class="icon" />
```

**Good:**
```erb
<span class="i-bi-people"></span>
```

### Agent::NoDirectEmoji

Prohibits direct use of Unicode emojis. Recommends using icon classes instead.

**Configuration:**
```yaml
Agent::NoDirectEmoji:
  enabled: true
  message: "Custom error message" # Optional: override default message
```

**Bad:**
```erb
<p>Welcome! 😊</p>
```

**Good:**
```erb
<p>Welcome! <span class="i-bi-emoji-smile"></span></p>
```

### Agent::NoSpecificClasses

Prohibits the use of specific class names defined in configuration.

**Configuration:**
```yaml
Agent::NoSpecificClasses:
  enabled: true
  forbidden_classes:
    "btn-old": "Use 'btn' class instead"
    "text-bold": "Use 'font-bold' instead"
```

**Bad:**
```erb
<button class="btn-old">Click</button>
<p class="text-bold">Important</p>
```

**Good:**
```erb
<button class="btn">Click</button>
<p class="font-bold">Important</p>
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Erblint::Agent project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aki77/erblint-agent/blob/main/CODE_OF_CONDUCT.md).
