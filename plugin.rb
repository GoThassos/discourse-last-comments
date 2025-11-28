# coding: utf-8
# frozen_string_literal: true

# name: discourse-last-comments
# about: Embeds the last comments of a topic for external sites
# version: 0.0.4
# authors: anthony0030
# url: https://github.com/GoThassos/discourse-last-comments
# required_version: 2.7.0

after_initialize do
  # Make sure Rails can find your plugin's views/layouts
  ::ActionController::Base.prepend_view_path File.expand_path("../app/views", __FILE__)

  # Define your plugin namespace
  module ::DiscourseLastComments
    class Engine < ::Rails::Engine
      engine_name "discourse_last_comments"
      isolate_namespace DiscourseLastComments
    end
  end

  # Define plugin routes
  DiscourseLastComments::Engine.routes.draw do
    # get "/:topic_id" => "last_comments#show"
    get "last_posts" => "last_comments#show"
  end

  Discourse::Application.routes.append do
    # mount ::DiscourseLastComments::Engine, at: "/embed_last_posts"
    mount ::DiscourseLastComments::Engine, at: "/embed"
  end

  # Define your controller inside after_initialize
  module ::DiscourseLastComments
    class LastCommentsController < ::ApplicationController
      requires_plugin ::DiscourseLastComments

      before_action :prepare_embeddable

      # Skip all auth / XHR checks for anonymous access
      skip_before_action :check_xhr, raise: false
      skip_before_action :redirect_to_login_if_required, raise: false
      skip_before_action :verify_authenticity_token, raise: false

      layout "discourse_last_comments/application"

      def show
        topic_id = params[:topic_id]&.to_i
        raise Discourse::NotFound unless topic_id

        @topic_view = TopicView.new(
          topic_id,
          nil, # or current_user if you want auth
          limit: 20,
          only_regular: true,
          exclude_first: true,
          exclude_deleted_users: true,
          exclude_hidden: true
        )

        @posts = @topic_view.recent_posts

        raise Discourse::NotFound if @topic_view.blank?
        @posts_left = 0
        @second_post_url = "#{@topic_view.topic.url}/2"
        @reply_count = @topic_view.filtered_posts.count - 1
        @reply_count = 0 if @reply_count < 0
        @posts_left = @reply_count - SiteSetting.embed_post_limit if @reply_count > SiteSetting.embed_post_limit

        render :show
      end

      private

        def prepare_embeddable
          response.headers.delete("X-Frame-Options")


          embeddable_host = EmbeddableHost.record_for_url(request.referer)

          @embeddable_css_class =
            if params[:class_name]
              " class=\"#{CGI.escapeHTML(params[:class_name])}\""
            elsif embeddable_host.present? && embeddable_host.class_name.present?
              Discourse.deprecate(
                "class_name field of EmbeddableHost has been deprecated. Prefer passing class_name as a parameter.",
                since: "3.1.0.beta1",
                drop_from: "3.2",
              )

              " class=\"#{CGI.escapeHTML(embeddable_host.class_name)}\""
            else
              ""
            end

          @data_referer =
            if SiteSetting.embed_any_origin? && @data_referer.blank?
              "*"
            else
              request.referer
            end
        end
    end
  end
end
