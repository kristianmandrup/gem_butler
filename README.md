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

GemButler comes with the following main API:

* `include_only :folders => {...}, :names => {...}`
* `exclude :folders => {...}, :names => {...}`
* `select *names`

The method `include_only` takes an option hash with the keys `:folders` and `:names`. Butler will then select only the Gemfiles which are in the listed folders and have the given names.

The method `exclude` is similar to `include_only` but instead excludes any Gemfiles either in any of the given folders or matching the given names.

The `select` method take as list of names and will additionally select Gemfiles matching these names unless specifically listed in the set of excluded names. 

This logic should be powerful enough to support most usage situations.

In your Gemfile:

```ruby
require 'butler'
butler = GemButler.new File.dirname(__FILE__) + '/gemfiles'

# include/exclude certain gemfiles
# this would include only gemfiles living in the /view or /back_end folder named Test (or test)
# additionally it would also select (include) the Facebook gemfile wherever it is, even if Facebook is not matched by the include_only logic.

butler.include_only :folders => [:view, :back_end], :names => :test
butler.select :facebook

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

