# WORKING!

namespace :scraper do

	desc "Scrape all interview questions from https://leetcode.com/problemset/algorithms/"

	task leetcode: :environment do

  	require 'nokogiri'
		require 'open-uri'

    # 1. Go to URL
    browser = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'    
    main_doc = Nokogiri::HTML(open("https://leetcode.com/problemset/", "User-Agent" => browser))

    # 2. Collect all interview question links
    # Search for nodes by css: 
    # '#problemList tbody tr a'
    # link.content is the stuff between the tags
    # link["href"] is the href itself

    # Would be wise to build a hash that contains
    # everything, according to how it should appear in
    # the table, like this ...

    # Array({:a => "a", :b => "b"})
    # => [[:a, "a"], [:b, "b"]]

    # Grab main list
    link_selector = '#problemList td a'
    questions = Array.new

    # Populate hash with list
    main_doc.css(link_selector).each do |link|
	    questions.push( { :name => link.content,
	    	:link => "https://leetcode.com"+link["href"], :difficulty => "",
	    	:content => "" } )
    end

    # Selector determined with SelectorGadget s/w
    difficulty_selector = 'td:nth-child(5)'

    count = 0
    main_doc.css(difficulty_selector).each do |selector|

    	# Assign each selector's text to the :difficulty
    	# hash value
    	questions[count][:difficulty] = selector.text
    	count = count + 1
    end

    # 3. Each interview question is in the class
    # named .question-content at those links, so go to
    # that link

    # Testing with a limited loop of the first 3 entries,
    # but iterate over all entries once db access is set up
    # justthree = 0
    questions.each do |question|
    	# comment out the following line for production
    	# if justthree < 3

    		# Grab the page at the link
		   	question_doc = Nokogiri::HTML(open(question[:link], "User-Agent" => browser))

		   	# Questions are accessible on these pages by
		   	# looking at the paragraph tags inside of the
		   	# question-content class

	  	 	# question[:content] = question_doc.css('.question-content p').to_s

	  	 	# These should be added together to form one
	  	 	# single interview question, but not if it's a
	  	 	# spoiler

		   	# Spoilers are in a div with class "spoilers"
		   	# question_spoilers = question_doc.css('.spoilers')

		   	# This is how to access each individual spoiler,
		   	# which we will store in a Comments table

		   	# puts "SPOILERS:"
		   	# question_spoilers.each do |spoiler|
		   	# 	puts spoiler
		   	# end

		   	# Remove both the .spoilers and .showspoilers 
		   	# classes, so that they do not appear within the
		   	# interview question when they are saved to the db
	  	 	question_doc.css('.spoilers').remove
	  	 	question_doc.css('.showspoilers').remove

	  	 	puts "QUESTION CONTENT:"
	  	 	question_doc.css('.question-content p').each do |p|
		  	 		puts p.to_s
		  	 		# puts p.content.gsub(/\n/," ").strip

		  	 		question[:content] += p.to_s
	  	 	end

	  	 	# Tags are in hyperlinks in a span within the
	  	 	# question-content class
		   	question_tags = question_doc.css('.question-content span a')

		   	# This is how to access each individual tag; they
		   	# should all be added to the QuestionTag join 
		   	# table, which will have a row for each
		   	# question-tag association

		   	# Add to database
		   	current = Post.create(question)

		   	puts "TAGS:"

		   	# This site uses a lot of tags, so there will
		   	# be a list for each post
		   	question_tags.each do |tag|
		   		clean_tag = tag.text.gsub(/\n/," ").strip

		   		# First check to see if it's already in the
		   		# Tag db
			    tag_object = Tag.find_by(category: clean_tag)
			    if tag_object.nil?

			    	# If not, create it
			      tag_object = Tag.create({category: clean_tag})
			    else
			      puts "tag #{tag_object} already exists ..."
			    end

			    # Either way, associate the Tag object with
			    # the current post
			    current.tags << tag_object
		   	end

        # Add in a scraper delay with a minimum of 5s
        sleep(5 + Random.rand(10))

        # Monitor the progress
       	puts current

		   	# justthree = justthree + 1
		  # end

  	end

	end

end
