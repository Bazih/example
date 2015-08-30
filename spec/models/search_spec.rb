require 'rails_helper'

RSpec.describe Search, type: :model do
  describe '.search' do
    let(:query) { 'test' }

    %w(Question Answer User Comment).each do |classes|
      it "should call ThinkingSphinx for classes #{classes}" do
          expect(ThinkingSphinx).to receive(:search).with(query, {classes: [classes.constantize]})
          Search.search(query, classes)
      end
    end

    it 'should call ThinkingSphinx for classes empty' do
      expect(ThinkingSphinx).to receive(:search).with(query, {classes: nil})
      Search.search(query, 'All')
    end

    it 'should call ThinkingSphinx for classes NoName' do
      expect(ThinkingSphinx).to_not receive(:search).with(query, {classes: ['NoName']})
      expect(Search.search(query, 'NoName')).to eq []
    end
  end
end