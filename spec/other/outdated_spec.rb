require "spec_helper"

describe "bundle outdated" do
  
  context "without Git repo" do
    before :each do
      build_repo2 do
        build_git "foo", :path => lib_path("foo")
      end
    
      install_gemfile <<-G
        source "file://#{gem_repo2}"
        gem "activesupport"
        gem "rack-obama"
        gem "foo", :git => "#{lib_path('foo')}"
      G
    end
    
    describe "with no arguments" do
      it "returns list of outdated gems" do
        update_repo2 do
          build_gem "activesupport", "3.0"
          update_git "foo", :path => lib_path("foo")
        end
    
        bundle "outdated"
        out.should include("activesupport (3.0 > 2.3.5)")
        out.should include("foo (1.0")
      end
    end

    describe "with --local option" do
      it "doesn't hit repo2" do
        FileUtils.rm_rf(gem_repo2)
    
        bundle "outdated --local"
        out.should_not match(/Fetching source index/)
      end
    end
    
    describe "with specified gems" do
      it "returns list of outdated gems" do
        update_repo2 do
          build_gem "activesupport", "3.0"
          update_git "foo", :path => lib_path("foo")
        end
    
        bundle "outdated foo"
        out.should_not include("activesupport (3.0 > 2.3.5)")
        out.should include("foo (1.0")
      end
    end
  end

end