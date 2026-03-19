module Demo
  class WelcomeController < ApplicationController
    layout "demo/moxie"

    def show
      @items = [
        WelcomeItem.new(
          avatar: "key",
          header: '<a class="hover:text-amber-400 underline!" href="' + auth_sign_out_path + '">Sign out</a><span class="hidden sm:inline"> with <a class="hover:text-amber-400 underline!" href="https://github.com/mikker/passwordless">Passwordless</a></span>',
          hidden: current_user.nil?
        ),
        WelcomeItem.new(
          avatar: "key",
          header: '<a class="hover:text-amber-400 underline!" href="' + auth_sign_in_path + '">Sign in</a><span class="hidden sm:inline"> with <a class="hover:text-amber-400 underline!" href="https://github.com/mikker/passwordless">Passwordless</a></span>',
          byline: 'Try <span class="text-amber-200 font-semibold">user@superstack.dev</span> for a regular user or <span class="text-amber-200 font-semibold">admin@superstack.dev</span> for an admin',
          hidden: current_user.present?
        ),
        WelcomeItem.new(
          avatar: "trophy",
          header: 'Search <a class="hover:text-amber-400 underline!" href="' + demo_mac_guffins_path + '">MacGuffins</a><span class="hidden sm:inline"> defined with <a class="hover:text-amber-400 underline!" href="https://github.com/CanCanCommunity/cancancan">CanCanCan</a> access rules</span>',
          byline: 'Try visiting the page while <span class="text-amber-200 font-semibold">signed out</span>, signed in as a <span class="text-amber-200 font-semibold">regular user</span>, and signed in as an <span class="text-amber-200 font-semibold">admin</span>. You will see different items!'
        ),
        WelcomeItem.new(
          avatar: "share-nodes",
          header: '<a class="hover:text-amber-400 underline!" href="' + demo_api_path + '">Make API calls</a><span class="hidden sm:inline"> with <a class="hover:text-amber-400 underline!" href="https://rails-graphql.dev">Rails GraphQL</a></span>'
        ),
        WelcomeItem.new(
          avatar: "user-shield",
          header: 'Open the <a class="hover:text-amber-400 underline!" href="' + admin_path + '">admin dashboard</a><span class="hidden sm:inline"> with <a class="hover:text-amber-400 underline!" href="https://github.com/ThibautBaissac/super_admin">SuperAdmin</a></span>'
        ),
        WelcomeItem.new(
          avatar: "fish-fins",
          header: 'Enable <a class="hover:text-amber-400 underline!" href="' + flipper_path + '">feature flags</a><span class="hidden sm:inline"> with <a class="hover:text-amber-400 underline!" href="https://www.flippercloud.io">Flipper</a></span>'
        ),
        WelcomeItem.new(
          avatar: "bell",
          header: 'Test <a class="hover:text-amber-400 underline!" href="' + notifications_path + '">sending notifications</a><span class="hidden sm:inline"> with <a class="hover:text-amber-400 underline!" href="https://github.com/excid3/noticed">Noticed</a></span>',
          byline: 'You need to be signed in as an <span class="text-amber-200 font-semibold">admin</span> to access feature flags or send notifications'
        )
      ]
    end
  end
end
