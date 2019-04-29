require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    url = Nokogiri::HTML(open(index_url))
    # url = Nokogiri::HTML(open("./fixtures/student-site/index.html"))
    students=[]
    url.css("div.student-card").each do |student|
      name = student.css("h4.student-name").text
      location = student.css("p.student-location").text
      profile_url = student.css("a").attribute("href").value
      student_attributes = {:name => name,
        :location => location,
        :profile_url => profile_url}
      students << student_attributes
    end
    students
  end


  def self.scrape_profile_page(profile_url)
    url = Nokogiri::HTML(open(profile_url))
    scraped_student = {}
    url.css("div.social-icon-container a").each do |link|
      if link.attribute("href").value.include?("twitter")
        scraped_student[:twitter] = link.attribute("href").value
      elsif link.attribute("href").value.include?("github")
        scraped_student[:github] = link.attribute("href").value
      elsif link.attribute("href").value.include?("linkedin")
        scraped_student[:linkedin] = link.attribute("href").value
      elsif link.attribute("href").value.include?(".com")
        scraped_student[:blog] = link.attribute("href").value
                # binding.pry
      end
    end
    scraped_student[:bio] = url.css("div.description-holder p").text
    scraped_student[:profile_quote] = url.css("div.profile-quote").text
    scraped_student
  end
end
