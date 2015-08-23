require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'mechanize'

namespace :import do
    desc "Will out put CSV's for Subscribers"
    task :quotes => :environment do
        
        m = Mechanize.new

        m.get('https://www.thumbtack.com/login') do |login_page|
          loggedin_page = login_page.form_with(:id => 'login') do |form|
            username_field = form.field_with(:id => 'login_email')
            username_field.value = ENV['thumbtack_un']
            password_field = form.field_with(:id => 'login_password')
            password_field.value = ENV['thumbtack_pw']
          end.submit

        lead_page = m.get('http://thmtk.com/Yy2XwJr2')
        parsed_page = lead_page.parser            
        
        q = Quote.new        
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
        
        p q


                
        end
    end
end