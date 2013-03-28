require_relative 'test_helper'
require_relative 'package_examples'
require 'fileutils'
require 'rspec'
require 'timeout'

describe "External package in" do
  context "Squeak 4.5" do
    before :all do
      squeak45_image = "Squeak4.4"
      assert_target_dir
      @os_name = identify_os
      @cog_vm = assert_cog_vm(@os_name)
      @interpreter_vm = assert_interpreter_vm(@os_name)
      FileUtils.cp("#{squeak45_image}.image", "#{TARGET_DIR}/#{squeak45_image}.image")
      FileUtils.cp("#{squeak45_image}.changes", "#{TARGET_DIR}/#{squeak45_image}.changes")
      prepare_package_image(@interpreter_vm, @os_name, squeak45_image, "update-image.st")
    end

    it_should_behave_like "all"
  end
end
