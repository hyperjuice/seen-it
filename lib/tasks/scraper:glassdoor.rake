namespace :scraper do

  desc "Scrape 50 most common (non-technical) interview questions from http://www.glassdoor.com/blog/common-interview-questions/"

  task glassdoor: :environment do

  	require 'nokogiri'
		require 'open-uri'

    # 1. Go to URL
    main_doc = Nokogiri::HTML(open("http://www.glassdoor.com/blog/common-interview-questions/"))

    # 2. Collect all interview question links
    # Search for nodes by css

    # link.content is the stuff between the tags
    # link["href"] is the href itself

    # Would be wise to build a hash that contains
    # everything, according to how it should appear 
    # in the table, like this ...

    # Array({:a => "a", :b => "b"})
    # => [[:a, "a"], [:b, "b"]]

    # Selector determined with SelectorGadget s/w
    link_selector = 'ol li'
    questions = Array.new

    main_doc.css(link_selector).each do |link|
	    questions.push( { :title => link.content,
	    	:link => "http://www.glassdoor.com/blog/common-interview-questions/", :difficulty => "",
	    	:question => link.content } )
    end

    # Create tags that all say "non-technical", 
    # "general"

    # Test-print the hash array ...
    puts "QUESTION OBJECT:"
    questions.each do |question|
    	puts question.inspect
    end

  end

end

