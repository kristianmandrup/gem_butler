# Gem butler

Makes it easy to divide your Gemfile into packages (or categories) of gems to include, each in a separate (smaller) gemfile.

You could put the gemfiles in a `gemfiles` folder in the root of your app.
The gemfiles should be of the form `Assets.gemfile`.

Example file structure

```
+ gemfiles
  - Assets.gemfile
  - Backend.gemfile
  + view
    - Bootstrap.gemfile
```

In your Gemfile:

```ruby
require 'butler'
butler = Butler.new
butler.base_path = File.dirname(__FILE__) + '/gemfiles'
butler.exclude = [:bootstrap]

butler.included_gemfiles.each do |gemfile|
  # puts "gemfile: #{gemfile}"
  eval(IO.read(gemfile), binding)
end
```

## Contributing to gem_butler
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2012 Kristian Mandrup. See LICENSE.txt for
further details.

