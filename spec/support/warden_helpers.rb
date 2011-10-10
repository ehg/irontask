module WardenHelpers
  def self.included(base)
    base.class_eval do
      setup :setup_controller_for_warden, :warden if respond_to?(:setup)
    end
  end

  # Override process to consider warden.
  def process(*)
    result = nil
    _catch_warden { result = super }
    result
  end

  # We need to setup the environment variables and the response in the controller.
  def setup_controller_for_warden #:nodoc:
    @request.env['action_controller.instance'] = @controller
  end

  # Quick access to Warden::Proxy.
  def warden #:nodoc:
    @warden ||= begin
                  manager = Warden::Manager.new(nil) do |config|
                    config.default_strategies :password
                  end
                  @request.env['warden'] = Warden::Proxy.new(@request.env, manager)
                end
  end

  # sign_in a given resource by storing its keys in the session.
  # This method bypass any warden authentication callback.
  #
  # Examples:
  #
  #   sign_in :user, @user   # sign_in(scope, resource)
  #   sign_in @user          # sign_in(resource)
  #
  def sign_in(resource_or_scope, resource=nil)
    scope    ||= Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    warden.session_serializer.store(resource, scope)
  end

  # Sign out a given resource or scope by calling logout on Warden.
  # This method bypass any warden logout callback.
  #
  # Examples:
  #
  #   sign_out :user     # sign_out(scope)
  #   sign_out @user     # sign_out(resource)
  #
  def sign_out(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    @controller.instance_variable_set(:"@current_#{scope}", nil)
    user = warden.instance_variable_get(:@users).delete(scope)
    warden.session_serializer.delete(scope, user)
  end

  protected

  def _catch_warden(&block)
    result = catch(:warden, &block)

    if result.is_a?(Hash) && !warden.custom_failure? && !@controller.send(:performed?)
      result[:action] ||= :unauthenticated

      env = @controller.request.env
      env["PATH_INFO"] = "/#{result[:action]}"
      env["warden.options"] = result
      Warden::Manager._run_callbacks(:before_failure, env, result)

      status, headers, body = Devise.warden_config[:failure_app].call(env).to_a
      @controller.send :render, :status => status, :text => body,
        :content_type => headers["Content-Type"], :location => headers["Location"]

      nil
    else
      result
    end
  end
end