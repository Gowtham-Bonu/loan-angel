class RoleConstraint
  def initialize
  end

  def matches?(request)
    if user = request.env['warden'].user
      user.role
    else
      false
    end
  end
end