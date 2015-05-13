# WORKING!

namespace :scraper do

  desc "Scrape 50 most common (non-technical) interview questions from http://www.glassdoor.com/blog/common-interview-questions/"

  task glassdoor: :environment do

  	require 'nokogiri'
		require 'open-uri'

    # 1. Go to URL
    browser = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'
    main_doc = Nokogiri::HTML(open("http://www.glassdoor.com/blog/common-interview-questions/", "User-Agent" => browser))

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
	    questions.push( { :name => link.content,
	    	:link => "http://www.glassdoor.com/blog/common-interview-questions/", :difficulty => "",
	    	:content => link.content } )
    end

    # Create tags that all say "non-technical", 
    # "general"
    non_technical = Tag.find_by(category: 'non-technical')
    if non_technical.nil?
      non_technical = Tag.create({category: 'non-technical'})
    else
      puts "non-technical already exists ..."
    end

    general = Tag.find_by(category: 'general')
    if general.nil?
      general = Tag.create({category: 'general'})
    else
      puts "general already exists ..."
    end

    # Test-print the hash array and write to the db 
    puts "There are #{questions.count} questions in the question object ..."
    puts "QUESTION OBJECT:"
    questions.each do |question|
    	puts question.inspect

      current = Post.create(question)
      current.tags << general
      current.tags << non_technical
    end

  end

end

