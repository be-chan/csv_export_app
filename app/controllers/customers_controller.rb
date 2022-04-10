require 'csv'
class CustomersController < ApplicationController
  before_action :set_customer, only: %i[ show edit update destroy ]

  # GET /customers or /customers.json
  def index
    @q = Customer.search(params[:q])
    @customers = @q.result(distinct: true)
  end

  def customer_csv_export
    respond_to do |format|
      format.csv do |csv|
        head :no_content
    
        customer = Customer.find(params[:id])
        filename = customer.name + Date.current.strftime("%Y%m%d")
        
        csv_data = CSV.generate do |csv|
          csv << Customer.column_names
          csv << customer.attributes.values_at(*Customer.column_names)
        end
        File.open("#{filename}.csv", "w", encoding: "SJIS") do |file|
          file.write(csv_data)
        end
        stat = File::stat("#{filename}.csv")
        send_file("#{filename}.csv", filename: "#{filename}.csv", length: stat.size)
      end
    end
  end

  # GET /customers/1 or /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers or /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customer_url(@customer), notice: "Customer was successfully created." }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to customer_url(@customer), notice: "Customer was successfully updated." }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer.destroy

    respond_to do |format|
      format.html { redirect_to customers_url, notice: "Customer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:name, :birthday, :sex, :address)
    end

    # def create_csv(filename, csv1) 

    #   send_data()
    # end

    # def send_posts_csv(customers)
    #   csv_data = CSV.generate(encoding: Encoding::SJIS) do |csv|
    #     csv_column_names = %w(Name Birthday Sex Address)
    #     csv << csv_column_names
    #     customers.each do |customer|
    #       csv_column_values = [
    #         customer.name,
    #         customer.birthday,
    #         customer.sex,
    #         customer.address
    #       ]
    #       csv << csv_column_values
    #     end
    #   end
    #   send_data(csv_data, filename: "hoge.csv")
    # end
end
