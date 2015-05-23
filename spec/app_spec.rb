require 'spec_helper'

describe Spaceship::App do
  before { Spaceship.login }
  let(:client) { Spaceship::App.client }

  describe "successfully loads and parses all apps" do
    it "the number is correct" do
      expect(Spaceship::App.all.count).to eq(5)
    end

    it "parses app correctly" do
      app = Spaceship::App.all.first

      expect(app.app_id).to eq("B7JBD8LHAA")
      expect(app.name).to eq("The App Name")
      expect(app.platform).to eq("ios")
      expect(app.prefix).to eq("5A997XSHK2")
      expect(app.bundle_id).to eq("net.sunapps.151")
      expect(app.is_wildcard).to eq(false)
    end

    it "parses wildcard apps correctly" do
      app = Spaceship::App.all.last

      expect(app.app_id).to eq("L42E9BTRAA")
      expect(app.name).to eq("SunApps")
      expect(app.platform).to eq("ios")
      expect(app.prefix).to eq("5A997XSHK2")
      expect(app.bundle_id).to eq("net.sunapps.*")
      expect(app.is_wildcard).to eq(true)
    end
  end


  describe "Filter app based on app identifier" do

    it "works with specific App IDs" do
      app = Spaceship::App.find("net.sunapps.151")
      expect(app.app_id).to eq("B7JBD8LHAA")
      expect(app.is_wildcard).to eq(false)
    end

    it "works with wilcard App IDs" do
      app = Spaceship::App.find("net.sunapps.*")
      expect(app.app_id).to eq("L42E9BTRAA")
      expect(app.is_wildcard).to eq(true)
    end

    it "returns nil app ID wasn't found" do
      expect(Spaceship::App.find("asdfasdf")).to be_nil
    end
  end

  describe '#create' do
    it 'creates an app id with an explicit bundle_id' do
      expect(client).to receive(:create_app!).with(:explicit, 'Production App', 'tools.fastlane.spaceship.some-explicit-app') {
        {'isWildCard' => true}
      }
      app = Spaceship::App.create!('tools.fastlane.spaceship.some-explicit-app', 'Production App')
      expect(app.is_wildcard).to eq(true)
    end

    it 'creates an app id with a wildcard bundle_id' do
      expect(client).to receive(:create_app!).with(:wildcard, 'Development App', 'tools.fastlane.spaceship.*') {
        {'isWildCard' => false}
      }
      app = Spaceship::App.create!('tools.fastlane.spaceship.*', 'Development App')
      expect(app.is_wildcard).to eq(false)
    end
  end

  describe '#delete' do
    subject { Spaceship::App.find("net.sunapps.151") }
    it 'deletes the app by a given bundle_id' do
      expect(client).to receive(:delete_app!).with('B7JBD8LHAA')
      app = subject.delete!
      expect(app.app_id).to eq('B7JBD8LHAA')
    end
  end
end