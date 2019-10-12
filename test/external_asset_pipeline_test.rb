# frozen_string_literal: true

require 'test_helper'

class ExternalAssetPipelineTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ExternalAssetPipeline::VERSION::MAJOR
    assert_kind_of Integer, ::ExternalAssetPipeline::VERSION::MAJOR
    refute_nil ::ExternalAssetPipeline::VERSION::MINOR
    assert_kind_of Integer, ::ExternalAssetPipeline::VERSION::MINOR
    refute_nil ::ExternalAssetPipeline::VERSION::PATCH
    assert_kind_of Integer, ::ExternalAssetPipeline::VERSION::PATCH

    refute_nil ::ExternalAssetPipeline::VERSION::STRING
    assert_kind_of String, ::ExternalAssetPipeline::VERSION::STRING
  end

  def test_that_manifest_can_be_set
    assert_nil ExternalAssetPipeline.manifest

    ExternalAssetPipeline.manifest = 'foo'

    assert_equal 'foo', ExternalAssetPipeline.manifest
  end
end
