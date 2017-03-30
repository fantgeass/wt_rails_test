require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  describe 'GET index' do
    let!(:companies) { create_list :company, 5 }

    it 'return status 200' do
      get :index
      expect(response).to have_http_status :ok
    end

    it 'return document types' do
      get :index
      expect(json['companies'].size).to eq 5
      expect(json['pagination']['current']).to eq 1
      expect(json['pagination']['display']).to eq 10
      expect(json['pagination']['total']).to be 1
    end
  end

  describe 'POST create' do
    context 'when data is valid' do
      let!(:params) { {company: {name: Faker::Company.name}} }

      it 'return status 201' do
        post :create, params: params
        expect(response).to have_http_status :created
      end

      it 'return valid data' do
        post :create, params: params
        expect(json).to be_a Hash
      end
    end

    context 'when data is invalid' do
      let!(:params) { {company: {name: ''}} }

      it 'return status 422' do
        post :create, params: params
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'return errors' do
        post :create, params: params
        expect(json['errors']['name']).to be_a Array
      end
    end

  end

  describe 'POST generate' do
    it 'return status 201' do
      post :generate
      expect(response).to have_http_status :created
    end

    it 'generate 100 companies' do
      post :generate
      expect(Company.count).to be 100
    end
  end
end
