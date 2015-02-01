class CustomSanitize
  include Singleton

  def custom_relaxed_config
    @config ||=
    begin
      @config = Sanitize::Config::RELAXED.deep_dup
      @config[:add_attributes] = {
          'a' => {'rel' => 'nofollow'}
      }
      @config[:elements].push('span')
      @config
    end
  end
end