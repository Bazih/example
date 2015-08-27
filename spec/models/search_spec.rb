require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.search' do
    let(:query) { 'test' }
    let(:all) { %w(Question Answer User Comment) }

    %w(Question Answer User Comment).each do |classes|
      it "should call ThinkingSphinx for classes #{classes}" do
          expect(ThinkingSphinx).to receive(:search).with(query, {classes: [eval(classes)]})
          Search.search(query, classes)
      end
    end

    it 'should call ThinkingSphinx for classes empty' do
      expect(ThinkingSphinx).to_not receive(:search).with(query, {classes: ''})
      Search.search(query, 'Question')
    end
  end
end