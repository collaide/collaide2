require 'rails_helper'

RSpec.describe Permission, type: :model do
  let(:permission) { Permission.new }
  describe 'add an action' do
    subject(:actions) { permission.actions }

    context 'without a block' do
      before(:each) { permission.add(:action) }

      it { expect { to include :action } }
      it { expect(actions[:action]).to be_nil }
    end

    context 'with a block' do
      before(:each) do
        permission.add(:block) { |hello, world| hello + ' ' + world }
      end
      it { expect(actions[:block]).to respond_to :call }
      it { expect(actions[:block].call('hello', 'world')).to eq 'hello world' }
    end
  end
  describe 'authorize an action' do
    it 'is true with no block' do
      permission.add(:no_block)
      expect(permission.authorized? :no_block).to be_truthy
    end
    it 'is true with a true block without args' do
      permission.add(:block_without_args) { true }
      expect(permission.authorized? :block_without_args).to be_truthy
    end
    it 'is true with a block with args' do
      permission.add(:block_with_args) { |first_arg, second_arg| first_arg and second_arg }
      expect(permission.authorized? :block_with_args, true, true).to be_truthy
    end
    it 'is false with an action unregistred' do
      expect(permission.authorized? :qwertz).to be_falsey
    end
  end
end