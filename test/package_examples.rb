require 'squeak-ci/test'

TEST_TIMEOUT = 600

shared_examples "an external package" do
  context "by passing all tests" do
    before :all do
      Dir.chdir(TARGET_DIR) {
        FileUtils.cp("#{@base_image_name}.image", "#{package}.image")
        FileUtils.cp("#{@base_image_name}.changes", "#{package}.changes")
      }
      run_image_with_cmd(preferably_cog_vm, vm_args(@os_name), package, "#{SRC}/prepare-test-image.st")
      run_image_with_cmd(preferably_cog_vm, vm_args(@os_name), package, "#{SRC}/package-load-scripts/#{package}.st")
      run_image_with_cmd(preferably_cog_vm, vm_args(@os_name), package, "#{SRC}/scripts/show-manifest.st")
    end

    after :all do
      Dir.chdir(TARGET_DIR) {
        FileUtils.rm("#{package}.image") if File.exists?("#{package}.image")
        FileUtils.rm("#{package}.changes") if File.exists?("#{package}.changes")
      }
    end

    it "on Cog" do
      pending "Can't run Cog on this platform (#{identify_os})" if @cog_vm.to_s == ""
      with_copy(package, "cog") { | image_name |
        run_test_with_timeout(@cog_vm, @os_name, image_name, package, TEST_TIMEOUT)
      }
    end

    # This is not easy to ensure on slaves.
    # it "on Cog MT (HT)" do
    #   pending "Can't run Cog MT (HT) on this platform (#{identify_os})" if @cog_mtht_vm.to_s == ""
    #   with_copy(package, "cogmtht") { | image_name |
    #     run_test_with_timeout(@cog_mtht_vm, @os_name, image_name, package, TEST_TIMEOUT)
    #   }
    # end

    it "on Interpreter", :interpreter => true do
      with_copy(package, "interpreter") { | image_name |
        assert_interpreter_compatible_image(@interpreter_vm, image_name, @os_name)
        run_test_with_timeout(@interpreter_vm, @os_name, image_name, package, TEST_TIMEOUT)
      }
    end
  end
end

shared_examples "external packages" do
  Packages = Dir.glob("#{SRC}/package-load-scripts/*.st").collect { | dir | File.basename(dir, '.st') }
  Packages.each { |pkg_name|
    describe pkg_name, pkg_name.to_sym => true do
      let(:package) { pkg_name }
      it_behaves_like "an external package"
    end
  }
end
