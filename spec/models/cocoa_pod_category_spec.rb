require 'spec_helper'

describe CocoaPodCategory do
  it { should have_many(:cocoa_pods) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:name) }
end
