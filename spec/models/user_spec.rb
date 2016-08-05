require 'spec_helper'
require './models/dm_user'
require './models/dm_report'

RSpec.describe DmUser do
  describe 'validations' do
    describe 'validate presence of email' do
      let(:user_password) { 'passwword' }

      it 'when downcase email before create' do
        user = DmUser.create(email: 'tEst@exAMPLe.com', password: user_password)
        expect(user).to be_valid
        expect(user.email).not_to eq 'tEst@exAMPLe.com'
      end

      it 'when blank' do
        user = DmUser.create(password: user_password)
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Email must not be blank')
      end

      it 'when invalid format' do
        user = DmUser.create(email: 'test@examplecom', password: user_password)
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Email has an invalid format')

        user = DmUser.create(email: 'testexample.com', password: user_password)
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Email has an invalid format')

        user = DmUser.create(email: 'testexample@com', password: user_password)
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Email has an invalid format')
      end

      it 'when not uniq' do
        DmUser.create(email: 'test@example.com', password: user_password)
        expect(DmUser.create(
          email: 'test@example.com',
          password: user_password
        )).not_to be_valid
      end

      it 'when valid' do
        user = DmUser.create(email: 'test@example.com', password: user_password)
        expect(user).to be_valid
      end
    end # email

    describe 'validate presence of password' do
      user = DmUser.create(email: 'test@example.com')

      it 'when blank' do
        expect(user).not_to be_valid
        expect(user.errors.full_messages)
          .to include('Password hash must not be blank')
      end
    end # password

    describe 'validate presence of storage' do
      it 'when blank' do
        user = DmUser.create(
          email:    'test@example.com',
          password: 'password',
          storage:  ''
        )
        expect(user).not_to be_valid
        expect(user.errors.full_messages).to include('Storage must not be blank')
      end
    end # storage
  end # validations

  describe 'reports associations' do
    let(:user) { create(:user) }

    it { expect(user).to respond_to(:dm_reports) }
    it { expect(user).to respond_to(:se_reports) }
    it { expect(user).to respond_to(:sql_reports) }
    it { expect(user).to respond_to(:file_reports) }
  end # reports associations

  describe '#authenticate' do
    let(:user) { create(:user) }
    it { expect(user).to respond_to(:authenticate).with(1).argument }
    it { expect(user).to eq user.authenticate('password') }
  end # authenticate
end # DmUser
