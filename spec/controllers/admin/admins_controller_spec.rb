require 'rails_helper'

describe Admin::AdminsController do
  let(:admin) do
    create :admin,
           first_name: 'Test first 1',
           last_name: 'Test last 1',
           email: 'test@email.com',
           password: '123456789',
           password_confirmation: '123456789'
  end

  before { sign_in admin }

  context 'GET #update' do
    context 'success' do
      context 'without password' do
        let(:params) do
          {
            id: admin.id,
            admin: {
              first_name: 'Test first 2', last_name: 'Test last 2', current_password: '123456789', email: admin.email
            }
          }
        end

        before { put :update, params: params }
        before { admin.reload }

        it { expect(admin.first_name).to eq 'Test first 2' }
        it { expect(admin.last_name).to eq 'Test last 2' }
      end

      context 'with password' do
        let(:params) do
          {
            id: admin.id,
            admin: {
              password: '11111111', password_confirmation: '11111111', current_password: '123456789', email: admin.email
            }
          }
        end

        before { put :update, params: params }

        it { expect(response).to redirect_to admin_admin_path(admin) }
      end
    end

    context 'failed' do
      context 'without password' do
        let(:params) do
          {
            id: admin.id,
            admin: {
              password: '', password_confirmation: '', current_password: '123456789', email: admin.email
            }
          }
        end

        before { put :update, params: params }

        it { expect(response).to redirect_to admin_admin_path(admin) }
      end
    end
  end
end
