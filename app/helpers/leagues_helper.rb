module LeaguesHelper
  def result_rule_collection
    League::RESULT_RULES.map{|rule| [rule.humanize, rule]}
  end
end