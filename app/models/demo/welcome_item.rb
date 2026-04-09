module Demo
  # Immutable value object representing a feature showcase item
  WelcomeItem = Data.define(:avatar, :description, :byline, :hidden, :visibility) do
    include Draper::Decoratable
    include Serializable

    json_source "lib/data/demo/welcome_items.json"

    # :reek:BooleanParameter — Data.define default value; hidden is a data attribute, not a control flag
    def initialize(byline: nil, hidden: false, visibility: "all", **args)
      super(**args, byline:, hidden:, visibility:)
    end

    # :reek:FeatureEnvy — value object checking caller-provided context; logic belongs here, not on user
    def hidden_for(user)
      case visibility
      when "signed_in_only"  then user.blank?
      when "signed_out_only" then user.present?
      else false
      end
    end
  end
end
