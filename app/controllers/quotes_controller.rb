class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:sms]
  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = Quote.all
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
  end

  # GET /quotes/new
  def new
    @quote = Quote.new
  end

  # GET /quotes/1/edit
  def edit
  end

  # POST /quotes
  # POST /quotes.json
  def create
    @quote = Quote.new(quote_params)

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/1
  # PATCH/PUT /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  def sms
    @quote = Quote.new
    text_body = request['Body']

    link = text_body.split('/').last
    thumbtack_link = "http://thmtk.com/#{link}"

    @quote.name = thumbtack_link
    @quote.save

    q = @quote

    obtain_thumbtack_quote_info(q)

  end

  def obtain_thumbtack_quote_info(q)
  
    m = Mechanize.new

    m.get(q.name) do |login_page|
      loggedin_page = login_page.form_with(:id => 'login') do |form|
        username_field = form.field_with(:id => 'login_email')
        username_field.value = ENV['thumbtack_un']
        password_field = form.field_with(:id => 'login_password')
        password_field.value = ENV['thumbtack_pw']
      end.submit

      lead_page = m.get('http://thmtk.com/Yy2XwJr2')
      parsed_page = lead_page.parser            
      
            
      q.type_of_home = parsed_page.css('.request-info')[1].text
      q.recurrence = parsed_page.css('.request-info')[2].text
      q.day_preference = parsed_page.css('.request-info')[3].text
      q.time_preference = parsed_page.css('.request-info')[4].text
      q.bedrooms = parsed_page.css('.request-info')[5].text
      q.bathrooms = parsed_page.css('.request-info')[6].text
      q.square_feet = parsed_page.css('.request-info')[7].text
      q.cleaning_supplies = parsed_page.css('.request-info')[8].text
      # q.eco_friendly = parsed_page.css('.request-info')[2].text
      # q.pets = parsed_page.css('.request-info')[2].text
      # q.laundry = parsed_page.css('.request-info')[2].text
      # q.refrigerator = parsed_page.css('.request-info')[2].text
      # q.oven = parsed_page.css('.request-info')[2].text
      # q.windows = parsed_page.css('.request-info')[2].text


      q.save
    end
  
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url, notice: 'Quote was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params.require(:quote).permit(:name, :quote_type, :type_of_home, :recurrence, :day_preference, :time_preference, :bedrooms, :bathrooms, :square_feet, :cleaning_supplies, :eco_friendly, :laundry, :pets, :refrigerator, :oven, :windows, :location, :request_time)
    end
end
