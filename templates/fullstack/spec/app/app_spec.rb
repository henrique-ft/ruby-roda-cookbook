require_relative '../spec_helper'

describe 'hello' do
  it 'test models' do
    Food.create(name: 'hello')
    Food.create(name: 'world')
    debugger

    _(Food.count).must_equal 2
  end

  it 'test requests' do
  end
end
