module PrasDevise
  class PrasDeviseController < ApplicationController

    before_action :store_user_location!, if: :storable_location?

    # Its important that the location is NOT stored if:
    # - The request method is not GET (non idempotent)
    # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an 
    #    infinite redirect loop.
    # - The request is an Ajax request as this can lead to very unexpected behaviour.
    private def storable_location?
      request.get? &&
        is_navigational_format? &&
        !is_a?(PrasDevise::PrasDeviseController) &&
        !request.xhr?
    end

    private def is_navigational_format?
      ["*/*", :html].include?(request_format)
    end

    private def request_format
      @request_format ||= request.format.try(:ref)
    end

    private def store_user_location!
      # :user is the scope we are authenticating
      #store_location_for(:user, request.fullpath)
      path = extract_path_from_location(request.fullpath)
      session[:user_return_to] = path if path
    end

    private def parse_uri(location)
      location && URI.parse(location)
    rescue URI::InvalidURIError
      nil
    end

    private def extract_path_from_location(location)
      uri = parse_uri(location)
      if uri 
        path = remove_domain_from_uri(uri)
        path = add_fragment_back_to_path(uri, path)
        path
      end
    end

    private def remove_domain_from_uri(uri)
      [uri.path.sub(/\A\/+/, '/'), uri.query].compact.join('?')
    end

    private def add_fragment_back_to_path(uri, path)
      [path, uri.fragment].compact.join('#')
    end

    private def after_sign_in_path_for(resource_or_scope)
      if is_navigational_format?
        session.delete(:user_return_to) || root_url
      else
        session[:user_return_to] || root_url
      end
    end

    def require_no_authentication
      if cookies[:remember_token]
        redirect_to root_url, alert: "Already authenticated!"
      end
    end
  end
end
