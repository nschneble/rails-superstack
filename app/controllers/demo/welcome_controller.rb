module Demo
  # Builds and renders the demo welcome page with showcase items
  class WelcomeController < DemoApplicationController
    def show
      @items = build_items.reject(&:hidden).map(&:decorate)
    end

    private

    def build_items
      [
        WelcomeItem.new(
          avatar: "key",
          description: [
            { link: "Sign out", to: auth_sign_out_path },
            { hidden: [ "with", { link: "Passwordless", to: "https://github.com/mikker/passwordless" } ] }
          ],
          hidden: current_user.blank?
        ),
        WelcomeItem.new(
          avatar: "key",
          description: [
            { link: "Sign in", to: auth_sign_in_path },
            { hidden: [ "with", { link: "Passwordless", to: "https://github.com/mikker/passwordless" } ] }
          ],
          byline: [
            "Try",
            { highlight: "user@superstack.dev" },
            "for a regular user or",
            { highlight: "admin@superstack.dev" },
            "for an admin"
          ],
          hidden: current_user.present?
        ),
        WelcomeItem.new(
          avatar: "trophy",
          description: [
            "Search",
            { link: "MacGuffins", to: demo_mac_guffins_path },
            { hidden: [ "defined with", { link: "CanCanCan", to: "https://github.com/CanCanCommunity/cancancan" }, "access rules" ] }
          ],
          byline: [
            "Try visiting the page while",
            { highlight: "signed out" },
            ", signed in as a",
            { highlight: "regular user" },
            ", and signed in as an",
            { highlight: "admin" },
            ". You will see different items!"
          ]
        ),
        WelcomeItem.new(
          avatar: "share-nodes",
          description: [
            { link: "Make API calls", to: demo_api_path },
            { hidden: [ "with", { link: "Rails GraphQL", to: "https://rails-graphql.dev" } ] }
          ]
        ),
        WelcomeItem.new(
          avatar: "user-shield",
          description: [
            "Open the",
            { link: "admin dashboard", to: admin_path },
            { hidden: [ "with", { link: "SuperAdmin", to: "https://github.com/ThibautBaissac/super_admin" } ] }
          ]
        ),
        WelcomeItem.new(
          avatar: "fish-fins",
          description: [
            "Enable",
            { link: "feature flags", to: flipper_path },
            { hidden: [ "with", { link: "Flipper", to: "https://www.flippercloud.io" } ] }
          ]
        ),
        WelcomeItem.new(
          avatar: "bell",
          description: [
            "Test",
            { link: "sending notifications", to: notifications_path },
            { hidden: [ "with", { link: "Noticed", to: "https://github.com/excid3/noticed" } ] }
          ],
          byline: [
            "You need to be signed in as an",
            { highlight: "admin" },
            "to access feature flags or send notifications"
          ]
        )
      ]
    end
  end
end
