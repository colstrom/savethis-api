# Collection Resources contain multiple resources, and can be added to.
class CollectionResource < Webmachine::Resource
  def allowed_methods
    %w(HEAD GET POST)
  end

  def post_is_create?
    true
  end
end
