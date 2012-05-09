class GemButler
  attr_accessor :base_path

  attr_writer :exclude, :include_only

  def initialize path
    @base_path = path
  end

  def gemfiles
    @gemfiles ||= Dir.glob File.join(gemfiles_path, '**', '*.gemfile')
  end

  def gemfile_paths
    @gemfile_paths ||= gemfiles.map(&:to_s)
  end

  def included_gemfiles         
    return only_included if only_included?
    excluded
  end

  def excluded
    return [] if !exclude
    puts "a"
    @excluded ||= begin
      exclude_list = [exclude].flatten.inject([]) do |res, gemfile|
        res += gemfile_paths.grep(/#{Regexp.escape(gemfile)}\.gemfile$/i)
        res
      end
      puts "ex: #{exclude_list}"
      gemfile_paths - exclude_list.flatten
    end
  end

  def only_included?
    !only_included.empty?
  end

  def only_included
    return [] if !include_only
    @only_included ||= [include_only].flatten.inject([]) do |res, gemfile|
      res += gemfile_paths.grep(/#{Regexp.escape(gemfile)}\.gemfile$/i)
      res
    end
  end

  def gemfile_names
    @gemfile_names ||= gemfiles.map {|gemfile| gemfile.match(/\/(\w+)\.\w+$/)[1] }
  end

  def gemfiles_path
    File.expand_path(base_path, __FILE__)
  end

  def include_only
    @include_only ||= []    
  end

  def exclude
    @exclude ||= []
  end
end

