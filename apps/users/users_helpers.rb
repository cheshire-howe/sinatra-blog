module UsersHelpers
  include Rack::Utils
  alias_method :h, :escape_html
  
  # Convert a hash to a querystring for form population
  def hash_to_query_string(hash)
    hash.delete "password"
    hash.delete "password_confirmation"
    hash.collect {|k,v| "#{k}=#{v}"}.join("&")
  end
end

# Clear out sessions
=begin
at_exit do
  session[:errors] = nil
end
=end
