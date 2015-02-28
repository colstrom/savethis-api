require 'oj'

# Mixin to add JSON support to resources
module JSONSupport
  def content_types_provided
    [['application/json', :json_out]]
  end

  def content_types_accepted
    [['application/json', :json_in]]
  end

  def json_in
    input
  end

  def payload
    @payload ||= Oj.load request.body.to_s
  end

  def json_out
    Oj.dump output
  end
end
 