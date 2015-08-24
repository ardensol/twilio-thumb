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

  def obtain_thumbtack_quote_info(quote)
  
    m = Mechanize.new

    m.get("https://www.thumbtack.com/login") do |login_page|
      loggedin_page = login_page.form_with(:id => 'login') do |form|
        username_field = form.field_with(:id => 'login_email')
        username_field.value = ENV['thumbtack_un']
        password_field = form.field_with(:id => 'login_password')
        password_field.value = ENV['thumbtack_pw']
      end.submit

      lead_page = m.get(quote.name)
      parsed_page = lead_page.parser            
      
            
      quote.type_of_home = parsed_page.css('.request-info')[1].text
      quote.recurrence = parsed_page.css('.request-info')[2].text
      quote.day_preference = parsed_page.css('.request-info')[3].text
      quote.time_preference = parsed_page.css('.request-info')[4].text
      quote.bedrooms = parsed_page.css('.request-info')[5].text
      quote.bathrooms = parsed_page.css('.request-info')[6].text
      quote.square_feet = parsed_page.css('.request-info')[7].text
      quote.cleaning_supplies = parsed_page.css('.request-info')[8].text
      # quote.eco_friendly = parsed_page.css('.request-info')[2].text
      # quote.pets = parsed_page.css('.request-info')[2].text
      # quote.qndry = parsed_page.css('.request-info')[2].text
      # quote.refrigerator = parsed_page.css('.request-info')[2].text
      # quote.oven = parsed_page.css('.request-info')[2].text
      # quote.windows = parsed_page.css('.request-info')[2].text


      quote.save
    end
  
  end

  def submit_quote(quote)

    quote = Quote.find_by_id(quote)

    if quote.bedrooms == "Studio"
      amount = 119
    elsif quote.bedrooms == "1 bedroom"
      amount = 129
    elsif quote.bedrooms == "2 bedrooms"
      amount = 139
    elsif quote.bedrooms == "3 bedrooms"
      amount = 159
    elsif quote.bedrooms == "4 bedrooms"
      amount = 189
    elsif quote.bedrooms == "5 bedrooms"
      amount = 219
    elsif quote.bedrooms == "5+ bedrooms"
      amount = 249  
    else
      break
    end

    if quote.recurrence == "Every week"
      discount = 20
    elsif quote.recurrence == "Every other week"
      discount = 15
    elsif quote.recurrence == "Once a month"
      amount = 10
    else
      amount = 100
    end

    quoted_value = amount * discount / 100

    m = Mechanize.new

    m.get("https://www.thumbtack.com/login") do |login_page|
      loggedin_page = login_page.form_with(:id => 'login') do |form|
        username_field = form.field_with(:id => 'login_email')
        username_field.value = ENV['thumbtack_un']
        password_field = form.field_with(:id => 'login_password')
        password_field.value = ENV['thumbtack_pw']
      end.submit

      lead_page = m.get(quote.name).form_with(id: "quote-on-request") do |form|
        form.field_with(:name => 'size').options[0].click
        quote_price_field = form.field_with(:id => 'estimate_fixed_price_per_unit')
        quote_price_field.value = quoted_value
        quote_message_field = form.field_with(id: 'message')
        quote_message_field.value = "Hi ,\nWe have a flat rate for a #{quote.bedrooms} bedroom, home of $#{quoted_value}.\nAnything else such as laundry, refrigerator, oven, and window cleaning is an extra $25.\nBook a cleaning by using our website at www.maidfox.com or call us at (480) 360-6243 (MAID) today.\nWe're a top rated Phoenix area service and look forward to working with you!\nThanks!\nCarlos"
      end.submit      

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
      params.require(:quote).permit(:name, :quote_type, :type_of_home, :recurrence, :day_preference, :time_preference, :bedrooms, :bathrooms, :square_feet, :cleaning_supplies, :eco_friendly, :qndry, :pets, :refrigerator, :oven, :windows, :location, :request_time)
    end
end
