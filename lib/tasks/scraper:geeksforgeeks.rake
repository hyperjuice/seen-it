namespace :scraper do

  desc "Scrape a Top 25 List of technical q's
		from GeeksforGeeks at http://www.geeksforgeeks.org/top-25-interview-questions/"

  task geeksforgeeks: :environment do

  	require 'nokogiri'
		require 'open-uri'

    # 1. Go to URL
    # NOTE THAT SOME OF THESE PROBLEMS WILL REQUIRE DATA-
    # MASSAGING AS THE QUESTIONS ARE NOT IN THE SAME CONSISTENT
    # LOCATION

    browser = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'
    main_doc = Nokogiri::HTML(open("http://www.geeksforgeeks.org/top-25-interview-questions/", "User-Agent" => browser))

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
    	    questions.push( { :name => actual_text[1],
    	    	:difficulty => "", :link => "http://www.geeksforgeeks.org/top-25-interview-questions/",
    	    	:content => link.content } )

        # Do nothing for last two lines
        elsif link.text[/^(Thanks)|(This)/]

        # Otherwise, concatenate the content to 
        # the former question.
        else
            questions[questions.length-1][:content] += link.to_s
        end
    end

    # Create tags that all say "non-technical", 
    # "general", "opinion: top 25"

    # Create tags that all say "general", 
    # "data structures"
    general = Tag.find_by(category: 'general')
    if general.nil?
      general = Tag.create(category: 'general')
    else
      puts "general already exists ..."
    end

    non_technical = Tag.find_by(category: 'non-technical')
    if non_technical.nil?
      non_technical = Tag.create({category: 'non-technical'})
    else
      puts "non-technical already exists ..."
    end

    puts "There are #{questions.count} questions in the question object ..."

    # Test-print the hash array ...
    puts "QUESTION OBJECT:"
    questions.each do |question|
    	puts question.inspect
        puts "\n"

        current = Post.create(question)
        current.tags << general
        current.tags << non_technical
    end

  end

end

