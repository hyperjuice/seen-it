# WORKING!

namespace :scraper do

  desc "Scrape the Coding for Interviews Archive
  	of around 20 core topics that technical
  	interviewers need to be fluent in.  Access
  	to this site is behind a paywall."

  task codingforinterviews: :environment do

  	require 'nokogiri'
		require 'open-uri'

    # 1. Go to URL
    browser = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'    
    main_doc = Nokogiri::HTML(open("http://codingforinterviews.com/archive/paradigmsareconstructed@gmail.com-1bc404/", "User-Agent" => browser))

    # 2. Collect all interview question links
    # Search for nodes by css: 'b a'
    
    # Would be wise to build a hash that contains
    # everything, according to how it should appear in
    # the table, like this ...

    # Array({:a => "a", :b => "b"})
    # => [[:a, "a"], [:b, "b"]]

    # Selector created by SelectorGadget
    link_selector = 'b a'
    questions = Array.new

    # Populate hash with list
    main_doc.css(link_selector).each do |link|
	    questions.push( { :name => link.content,
	    	:link => link["href"], :difficulty => "",
	    	:content => "" } )
    end

    # Create tags that all say "algorithms", 
    # "data structures"
    algorithms = Tag.find_by(category: 'algorithms')
    if algorithms.nil?
      algorithms = Tag.create({category: 'algorithms'})
    else
      puts "algorithms already exists ..."
    end

    data_structures = Tag.find_by(category: 'data structures')
    if data_structures.nil?
      data_structures = Tag.create({category: 'data structures'})
    else
      puts "data structures already exists ..."
    end

    # Testing with a limited loop of the first 3 entries,
    # but iterate over all entries once db access is set up
    # justthree = 0

    questions.each do |question|
    	# comment out the following line for production
    	# if justthree < 3

    		# Grab the page at the link
		   	question_doc = Nokogiri::HTML(open(question[:link], "User-Agent" => browser))

		   	# Questions are accessible on these pages by
		   	# looking for an h1 that starts with "This week's 
		   	# topic" and ends with an h2 that starts with
		   	# "Submitting your answer"

		   	# start_h1 = /^This week\'s topic/
		   	end_h2 = /^Submitting your answer/

		   	# Use Nokogiri to traverse the DOM from 
		   	# h1:contains("This week\'s topic") to 
		   	# h2:contains("Submitting your answer"), moving
		   	# from one element to the next with 
		   	# .next_sibling.text.strip

		   	grab_html = ""
		   	current_element = question_doc.at('h1:contains("This week\'s topic")')

        # However, this site admin has decided to
        # change the h1 header, so I need to check
        # for each possibility
        if current_element.nil?
          current_element = question_doc.at('h1:contains("Question of the Week")')
        end

        if current_element.nil?
          current_element = question_doc.at('h1:contains("Problem of the Week")')
        end

        if current_element.nil?
          current_element = question_doc.at('h1:contains("This week\'s question")')
        end

        if current_element.nil?
          current_element = question_doc.at('h1:contains("This week\'s problem")')
        end

        if current_element.nil?
          current_element = question_doc.at('h1:contains("Topic of the week")')
        end

        if current_element.nil?
          current_element = question_doc.at('h1:contains("Topic of the Week")')
        end


        # Only grab the page if there is something that
        # says "This week's topic".  Otherwise, skip the
        # page

        if !current_element.nil?
          current_element = current_element.next_sibling

  	   		# If the start text is found, then grab all of the
  	   		# sibling nodes all the way to the h2 with end_h2
  	   		# in it

     			begin
     				# Concatenate the string output
     				grab_html += current_element.to_s

     				# Advance to next sibling until end_h2
  		   		current_element = current_element.next_sibling
     			end until !current_element.text[end_h2].nil?

  		   	question[:content] = grab_html

  		   	# On this site, last week's solution is on the same
  		   	# page as this week's problem.  So, I should be
  		   	# able to populate the spoilers on the same pass, if
  		   	# I later choose to take the time to do so (not MVP!)

  		   	# This is how to access each individual tag; they
  		   	# should all be added to the QuestionTag join 
  		   	# table, which will have a row for each
  		   	# question-tag association

          # Add in a scraper delay with a minimum of 5s
          sleep(5 + Random.rand(10))

  		   	# justthree = justthree + 1

          # Provide feedback on result as scrape occurs:
          puts "\n"
          puts question.inspect
          puts "\n"
  		  # end

        end

  	end

    # Write to the db
    puts "There are #{questions.count} questions in the question object ..."
    puts "QUESTION OBJECT:"
    questions.each do |question|
      current = Post.create(question)
      current.tags << algorithms
      current.tags << data_structures
    end

	end

end
