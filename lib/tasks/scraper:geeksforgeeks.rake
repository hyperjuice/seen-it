namespace :scraper do

  desc "Scrape a Top 25 List of technical q's
		from GeeksforGeeks at http://www.geeksforgeeks.org/top-25-interview-questions/"

  task geeksforgeeks: :environment do

  	require 'nokogiri'
		require 'open-uri'

    # 1. Go to URL
    main_doc = Nokogiri::HTML(open("http://www.geeksforgeeks.org/top-25-interview-questions/"))

    # 2. Collect all interview question links
    # Search for nodes by css

    # Would be wise to build a hash that contains
    # everything, according to how it should appear 
    # in the table, like this ...

    # Array({:a => "a", :b => "b"})
    # => [[:a, "a"], [:b, "b"]]

    # Selector determined with SelectorGadget s/w
    link_selector = 'pre+ p, pre, p+ p'
    questions = Array.new

    # Note that if there is a URL in the interview
    # question, then we want to automatically
    # add an href to it ...
    main_doc.css(link_selector).each do |link|

        # Remove the list number from the 
        # title        

        numbered_list = /^\d{1,2}\)\s/
        actual_text = link.text.split(numbered_list)

        # If the text looks like a numbered list,
        # then create a new question

        if link.text[numbered_list]
    	    questions.push( { :title => actual_text[1],
    	    	:difficulty => "", :link => "http://www.geeksforgeeks.org/top-25-interview-questions/",
    	    	:question => link.content } )

        # Do nothing for last two lines
        elsif link.text[/^(Thanks)|(This)/]

        # Otherwise, concatenate the content to 
        # the former question.
        else
            questions[questions.length-1][:question] += link.to_s
        end
    end

    # Create tags that all say "non-technical", 
    # "general", "opinion: top 25"

    # Test-print the hash array ...
    puts "QUESTION OBJECT:"
    questions.each do |question|
    	puts question.inspect
        puts "\n"
    end

  end

end

