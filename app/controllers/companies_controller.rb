class CompaniesController < ApplicationController
  def index
    per = 10
    params[:page] ||= 1
    companies = Company.order(id: :desc).page(params[:page]).per(per)

    render json: {
      companies: companies,
      pagination: {
        current: params[:page].to_i,
        display: per,
        total: companies.total_pages
      }
    }
  end

  def create
    company = Company.new(ad_params)

    if company.save
      render json: company, status: :created
    else
      render json: {errors: company.errors.messages}, status: :unprocessable_entity
    end
  end

  def generate
    companies_attrs = 100.times.map { {name: Faker::Company.name} }
    Company.bulk_insert(values: companies_attrs)

    head :created
  end

  private
    def ad_params
      params.require(:company).permit(:name)
    end
end
