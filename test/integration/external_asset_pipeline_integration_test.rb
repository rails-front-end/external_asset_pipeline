# frozen_string_literal: true

require 'test_helper'

class ExternalAssetPipelineIntegrationTest < ActionDispatch::IntegrationTest
  test 'external asset pipeline' do
    get root_url

    assert_response :ok

    manifest_hash =
      JSON.parse(Rails.root.join('public', 'packs', manifest_filename).read)
    script_path = "/packs/#{manifest_hash['application.js']}"

    assert_select 'script' do |elements|
      assert_equal script_path, elements[0][:src]
    end

    assert_select 'link' do |elements|
      assert_match stylesheet_href_matcher, elements[0][:href]
    end
  end

  test 'external asset pipeline with dev server running' do
    skip unless app_has_dev_server_enabled?

    Rails.application.config.external_asset_pipeline.cache_manifest = false
    dev_server_thread = create_server_thread(9000)
    dev_server_host = ENV.fetch('DEV_SERVER_HOST', 'localhost')
    wait_for_server(dev_server_host, 9000)

    get root_url

    assert_response :ok

    manifest_hash =
      JSON.parse(Rails.root.join('public', 'packs', 'manifest.json').read)
    script_path =
      "http://#{dev_server_host}:9000/packs/#{manifest_hash['application.js']}"

    assert_select 'script' do |elements|
      assert_equal script_path, elements[0][:src]
    end

    assert_select 'link' do |elements|
      assert_match %r[^/assets/application-.{64}\.css$], elements[0][:href]
    end
  ensure
    dev_server_thread&.kill
  end

  private

  def app_uses_sprockets?
    defined?(Sprockets::Railtie)
  end

  def app_has_dev_server_enabled?
    Rails.application.config.external_asset_pipeline.dev_server.enabled
  end

  def manifest_filename
    if Rails.root.to_s.include?('demo_app-gulp-alt')
      'webpack-manifest.json'
    else
      'manifest.json'
    end
  end

  def stylesheet_href_matcher
    if app_uses_sprockets?
      %r[^/assets/application-.{64}\.css$]
    else
      %r[^/packs/application-.{10}\.css$]
    end
  end

  def create_server_thread(port)
    Thread.new do
      Rack::Handler::WEBrick.run(
        lambda do |_|
          response = Rails.root.join('public', 'packs', 'manifest.json').read
          [200, { 'Content-Type' => 'application/json' }, [response]]
        end,
        AccessLog: [],
        Logger: Logger.new(nil),
        Port: port
      )
    end
  end

  def wait_for_server(host, port)
    loop do
      begin
        response = Net::HTTP.start(host, port) { |http| http.get('/') }
      rescue Errno::ECONNREFUSED
        next
      end
      break if response.is_a?(Net::HTTPSuccess)
    end
  end
end
