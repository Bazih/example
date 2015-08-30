class Search
  SEARCHING_SOURCES = %w(All Question Answer Comment User)

  def self.search(query, source)
    return unless query
    return [] if source.nil? || !SEARCHING_SOURCES.include?(source)

    escaped_query = Riddle::Query.escape(query)

    classes = source == 'All' ? nil : [source.classify.constantize]
    ThinkingSphinx.search escaped_query, classes: classes

    # classes << []
    # if source && SEARCHING_SOURCES.include?(source)
    #   #classes << source.classify.constantize
    # end
    # ThinkingSphinx.search escaped_query, classes: classes
  end
end