module TeamsHelper
  def comma_list(team, email: false)
    return "none" if team.users.empty?

    team.users.map do |member|
      if email
        member.email
      else
        mail_to member.email, member.login, encode: "hex"
      end
    end.join(", ").html_safe
  end

  def team_email(team)
    comma_list(team, email: true)
  end

  # Modern alternative to legacy users_javascript
  def users_autocomplete_data
    {
      starboards: User.where("side != 'port'").pluck(:login),
      ports: User.where("side != 'stbd'").pluck(:login),
      coaches: User.where(will_coach: true).pluck(:login),
      coxswains: User.where(will_cox: true).pluck(:login)
    }
  end
end
