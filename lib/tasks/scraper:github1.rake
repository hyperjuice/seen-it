# WORKING!

namespace :scraper do

  desc "Scrape Frontend Developer Interview Questions at https://github.com/h5bp/Front-end-Developer-Interview-Questions"

  task github1: :environment do

  	require 'nokogiri'
		require 'open-uri'

    # 1. Go to URL
    browser = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'    
    main_doc = Nokogiri::HTML(open("https://github.com/h5bp/Front-end-Developer-Interview-Questions", "User-Agent" => browser))

    # 2. Collect all interview question links
    # Search for nodes by css

    # link.content is the stuff between the tags
    # link["href"] is the href itself

    # Would be wise to build a hash that contains
    # everything, according to how it should appear 
    # in the table, like this ...

    # Array({:a => "a", :b => "b"})
    # => [[:a, "a"], [:b, "b"]]

    # Notice that the selector specifically requires
    # that the article be the parent of the ul, which
    # in turn must be the immediate parent of the li
    link_selector = 'article > ul > li'
    questions = Array.new

    # NOTE THAT THERE ARE A HANDFUL OF ENTRIES ON
    # THIS PAGE WHICH NEED SOME MASSAGING

    main_doc.css(link_selector).each do |link|
	    questions.push( { :name => link.content,
	    	:link => "https://github.com/h5bp/Front-end-Developer-Interview-Questions", :difficulty => "",
	    	:content => link.content } )
    end

    # Questions 0-18 should be tagged "general"
    # Questions 19-31 should be tagged "html"
    # Questions 32-62 should be tagged "css"
    # Questions 63-97 should be tagged "javascript"
    # Questions 98-101 should be tagged "testing"
    # Questions 102-104 should be tagged "performance"
    # Questions 105-109 should be tagged "networking"
    # Questions 110-114 should be tagged "fun questions"

    general_tag = Tag.find_by(category: 'general')
    if general_tag.nil?
      general_tag = Tag.create({category: 'general'})
    else
      puts "general already exists ..."
    end

    html_tag = Tag.find_by(category: 'HTML')
    if html_tag.nil?
      html_tag = Tag.create({category: 'HTML'})
    else
      puts "HTML already exists ..."
    end

    css_tag = Tag.find_by(category: 'CSS')
    if css_tag.nil?
      css_tag = Tag.create({category: 'CSS'})
    else
      puts "CSS already exists ..."
    end

    javascript_tag = Tag.find_by(category: 'javascript')
    if javascript_tag.nil?
      javascript_tag = Tag.create({category: 'javascript'})
    else
      puts "javascript already exists ..."
    end

    testing_tag = Tag.find_by(category: 'testing')
    if testing_tag.nil?
      testing_tag = Tag.create({category: 'testing'})
    else
      puts "testing already exists ..."
    end

    performance_tag = Tag.find_by(category: 'performance')
    if performance_tag.nil?
      performance_tag = Tag.create({category: 'performance'})
    else
      puts "performance already exists ..."
    end

    networking_tag = Tag.find_by(category: 'networking')
    if networking_tag.nil?
      networking_tag = Tag.create({category: 'networking'})
    else
      puts "networking already exists ..."
    end

    fun_tag = Tag.find_by(category: 'fun')
    if fun_tag.nil?
      fun_tag = Tag.create({category: 'fun'})
    else
      puts "fun already exists ..."
    end

    puts "There are #{questions.count} questions in the question object ..."

    # Test-print the hash array ...
    puts "QUESTION OBJECT:"
    questions.each_with_index do |question, i|

      current = Post.create(question)

      # Assign tags based upon index i
      case i
      when 0..18
        current.tags << general_tag
      when 19..31   
        current.tags << html_tag
      when 32..62
        current.tags << css_tag
      when 63..97   
        current.tags << javascript_tag
      when 98..101   
        current.tags << testing_tag
      when 102..104  
        current.tags << performance_tag
      when 105..109 
        current.tags << networking_tag
      when 110..114 
        current.tags << fun_tag
      end

      puts "\n"
    	puts "#{i}: "
      puts question.inspect
      puts "\n"
    end

  end

end

