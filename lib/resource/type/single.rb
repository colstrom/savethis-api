# Single Resources allow specific items to be fetched/deleted/replaced.
class SingleResource < Webmachine::Resource
  def allowed_methods
    %w(HEAD GET PUT DELETE)
  end
end
