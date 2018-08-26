class IncomingSearchQueryService
  
  # Just passing values to initialize, then calling .call method
  def self.call(search_query, request_ip)
    new(search_query, request_ip).call
  end
  
  # Handles incoming search query: saves it, updates Analytic and Session accordingly.
  def call
    session = Session.get_or_create(@request_ip)        
    @old_query = session.lastpartial
    session.update_attribute(:lastpartial, @new_query)     
    SearchQuery.create(body: @new_query, session: session) unless @new_query.blank?
    Analytic.update_for_last_two_queries(@new_query, @old_query)
  end

  private
  
  # Initialize instance variables
  def initialize(search_query, request_ip)
    @new_query = search_query
    @request_ip = request_ip
  end

end
