# RspecMatcher

[![Gem Version](https://badge.fury.io/rb/rspec-matcher.svg)](http://badge.fury.io/rb/rspec-matcher)
[![Code Climate GPA](https://codeclimate.com/github/pekhee/rspec-matcher.svg)](https://codeclimate.com/github/pekhee/rspec-matcher)
[![Code Climate Coverage](https://codeclimate.com/github/pekhee/rspec-matcher/coverage.svg)](https://codeclimate.com/github/pekhee/rspec-matcher)
[![Gemnasium Status](https://gemnasium.com/pekhee/rspec-matcher.svg)](https://gemnasium.com/pekhee/rspec-matcher)
[![Travis CI Status](https://secure.travis-ci.org/pekhee/rspec-matcher.svg)](https://travis-ci.org/pekhee/rspec-matcher)
[![Inch CI](https://inch-ci.org/github/pekhee/rspec-matcher.svg?branch=master)](https://inch-ci.org/github/pekhee/rspec-matcher)
[![Gitter](https://camo.githubusercontent.com/da2edb525cde1455a622c58c0effc3a90b9a181c/68747470733a2f2f6261646765732e6769747465722e696d2f4a6f696e253230436861742e737667)](https://gitter.im/pekhee/rspec-matcher)

<!-- Tocer[start]: Auto-generated, don't remove. -->

# Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
- [Tests](#tests)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

# Features
- Implementes RSpec matcher interface as a module.
- Registers matcher with RSpec.
- It is stable in contrast to RSpec::Matchers::BaseMatcher.
- Well tested and documented.

# Requirements

0. [MRI 2.1.0](https://www.ruby-lang.org)

# Setup

For a secure install, type the following (recommended):

    gem cert --add <(curl -Ls https://raw.githubusercontent.com/pekhee/rspec-matcher/master/gem-public.pem)
    gem install rspec-matcher --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification while
allowing the installation of unsigned dependencies since they are beyond the scope of this gem.

For an insecure install, type the following (not recommended):

    gem install rspec-matcher

Add the following to your Gemfile:

    gem "rspec-matcher"

# Usage
[API Reference](http://www.rubydoc.info/github/pekhee/rspec-matcher/master)

    class BeNilMatcher
      include RSpec::Matcher
      register_as "be_nil"

      def match
        actual.nil?
      end

      def failure_message
        "expected #{expected} to be nil"
      end
    end

    expect(nil).to be_nil

# Tests

To test, run:

    bundle exec rake

# Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Patch (x.y.Z) - Incremented for small, backwards compatible bug fixes.
- Minor (x.Y.z) - Incremented for new, backwards compatible public API enhancements and/or bug fixes.
- Major (X.y.z) - Incremented for any backwards incompatible public API changes.

# Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.

# Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

# License

Copyright (c) 2016 [Pooyan Khosravi](https://www.github.com/pekhee).
Read the [LICENSE](LICENSE.md) for details.

# History

Read the [CHANGELOG](CHANGELOG.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).

# Credits

Developed by [Pooyan Khosravi](https://www.github.com/pekhee) at [Pooyan Khosravi](https://www.github.com/pekhee).
