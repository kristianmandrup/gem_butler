class GemButler
  attr_accessor :base_path

  attr_writer :excluded_names, :include_only_names
  attr_writer :include_only_folders, :excluded_folders
  attr_writer :selected_names

  def initialize path
    @base_path = path
  end

  def gemfiles
    @gemfiles ||= Dir.glob File.join(gemfiles_path, '**', '*.gemfile')
  end

  def gemfile_names mode = :included
    list = case mode
    when :included
      filtered
    else
      gemfiles
    end
    list.map {|gemfile| gemfile.match(/\/(\w+)\.\w+$/i)[1] }
  end

  def gemfile_paths
    @gemfile_paths ||= gemfiles.map(&:to_s)
  end

  def filtered
    selected + (name_filtered & folder_filtered)
  end

  def name_filtered
    return only_included if only_included?
    after_exclude
  end

  def after_exclude
    return [] if !excluded_names
    @after_excluded ||= begin      
      gemfile_paths - exclude_list.flatten
    end
  end

  def exclude_list
    @exclude_list ||= [excluded_names].flatten.inject([]) do |res, gemfile|
      res += gemfile_paths.grep(/#{prepare gemfile}\.gemfile$/i)
      res
    end
  end    

  def exclude_folders_list
    @exclude_folders_list ||= [excluded_folders].flatten.inject([]) do |res, folder|
      res += gemfile_paths.grep(/#{folder}\//i)
      res
    end
  end

  def after_exclude_folders
    return [] if !excluded_folders
    @after_excluded_folders ||= begin      
      gemfile_paths - exclude_folders_list.flatten
    end
  end

  def only_included?
    !only_included.empty?
  end

  def folder_filtered
    return only_included_folders if only_included_folders?
    after_exclude_folders
  end

  def only_included_folders?
    !only_included_folders.empty?
  end

  def only_included_folders
    return [] if !include_only_folders
    @only_included_folders ||= [include_only_folders].flatten.inject([]) do |res, folder|
      res += gemfile_paths.grep(/#{folder}\//i)
      res
    end
  end

  def only_included
    return [] if !include_only_names
    @only_included ||= [include_only_names].flatten.inject([]) do |res, gemfile|
      res += gemfile_paths.grep(/#{prepare gemfile}\.gemfile$/i)
      res
    end
  end

  def gemfiles_path
    File.expand_path(base_path, __FILE__)
  end

  def include_only options = {}
    self.include_only_names   = options.delete(:names)
    self.include_only_folders = options.delete(:folders)
  end

  def exclude options = {}
    self.excluded_names   = options.delete(:names)
    self.excluded_folders = options.delete(:folders)
  end

  def include_only_names
    @include_only_names ||= []    
  end

  def excluded_names
    @excluded_names ||= []
  end

  def include_only_folders
    @include_only_folders ||= []    
  end

  def excluded_folders
    @excluded_folders ||= []
  end

  def selected
    return [] if !include_only_folders
    @selected ||= [select_list].flatten.inject([]) do |res, gemfile|
      res += gemfile_paths.grep(/#{prepare gemfile}\.gemfile$/i)
      res
    end        
  end

  def select_list
    [selected_names].flatten - [excluded_names].flatten
  end

  def select *names
    self.selected_names = names.flatten.compact.uniq
  end

  def selected_names
    @selected_names ||= []
  end

  protected

  def prepare gemfile
    Regexp.escape GemButler.camelize(gemfile)
  end

  def self.underscore(camel_cased_word)
    word = camel_cased_word.to_s.dup
    word.gsub!(/::/, '/')
    word.gsub!(/(?:([A-Za-z\d])|^)(#{inflections.acronym_regex})(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

  def self.camelize(term, uppercase_first_letter = true)
    string = term.to_s
    if uppercase_first_letter
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
    else
      string = string.sub(/^(?:#{inflections.acronym_regex}(?=\b|[A-Z_])|\w)/) { $&.downcase }
    end
    string.gsub(/(?:_|(\/))([a-z\d]*)/i) { $2.capitalize }.gsub('/', '::')
  end    
end

