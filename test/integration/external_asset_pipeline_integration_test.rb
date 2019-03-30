# frozen_string_literal: true

require 'test_helper'

class ExternalAssetPipelineIntegrationTest < ActionDispatch::IntegrationTest
  test 'external asset pipeline' do
    get root_url

    assert_response :ok

    manifest_hash =
      JSON.parse(Rails.root.join('public', 'packs', 'manifest.json').read)
    script_path = "/packs/#{manifest_hash['application.js']}"

    assert_select 'script' do |elements|
      assert_equal script_path, elements[0][:src]
    end
  end
end
