require 'rails_helper'

describe ServiceModel do
  describe '.new' do
    it 'sets the id and errors' do
      id = 1
      errors = {}
      model = ServiceModel.new(id, errors)
      expect(model.id).to eq(id)
      expect(model.errors).to eq(errors)
    end
  end

  describe '#valid?' do
    it 'Returns true if there are errors' do
      expect(ServiceModel.new(1, {a: '1'}).valid?).to eq(false)
    end

    it 'Returns false if there are no errors' do
      expect(ServiceModel.new(1, {}).valid?).to eq(true)
    end
  end
end
