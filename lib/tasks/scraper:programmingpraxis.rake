# WORKING!

namespace :scraper do

  desc "Scrape the Programming Praxis site,
  	but only the questions specifically
  	designated as interview questions"
  	
  task programmingpraxis: :environment do

  	require 'nokogiri'
		require 'open-uri'

    # 1. Go to URL
    browser = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'    
    main_doc = Nokogiri::HTML(open("http://programmingpraxis.com/contents/themes/", "User-Agent" => browser))

    # 2. The plan for this site will be to grab
    # all table rows with a 'tr' selector, then
    # place the Nogokiri node pointer at
    # tr:contains("Interview Questions").  The
    # first interview question is in the next
    # row, and the content we care about is all
    # contained within the td:nth-child(4) selector.

    # Would be wise to build a hash that contains
    # everything, according to how it should appear in
    # the table, like this ...

    # Array({:a => "a", :b => "b"})
    # => [[:a, "a"], [:b, "b"]]

    # Grab the table rows
    selector = 'tr'

    # End the capture at the row with "Logic" in it
    end_tr = 'Logic'
    questions = Array.new

    # Start the capture at the problem whose name
    # starts with 'Steve Yegge', just after
    # Interview Questions.  It's better to grab
    # the row than the td's within it, to simplify
    # traversal

		current_tr = main_doc.css(selector).at('tr:contains("Interview Questions")').next_element

    # Populate hash with list
    begin
    	puts "CURRENT ELEMENT:"
			puts current_tr.text

			# We only care about one of the td's in the tr
			td = current_tr.css('td:nth-child(4)')

			# The link we are concerned with is an anchor
			# tag within this current table column (td)
			href = "http://programmingpraxis.com" + td.at_css("a")[:href]

	    questions.push( { :name => td.text,
	    	:link => href, :difficulty => "",
	    	:content => "" } )

	    current_tr = current_tr.next_element
    end until !current_tr.text[end_tr].nil?

    # justthree = 0
    # Now grab each question from the linked pages
    questions.each do |question|
    	# if justthree < 3

    		# Grab the page at the link
		   	question_doc = Nokogiri::HTML(open(question[:link], "User-Agent" => browser))

		   	# Capture the children of the div with class 
		   	# .entrybody
		   	start_class = '.entrybody'
		   	current_element = question_doc.at(start_class)

		   	# Then concatenate all html up to class .wpcnt
		   	grab_html = ""
		   	end_class = '.wpcnt'

				# We only care about the p's inside of
				# the div, and not the last one
				p_tags = current_element.css('p')

				# There is a link at the bottom of this page
				# which is not necessarily needed, but I'm
				# going to leave it there.  It's not
				# particularly important

   			question[:content] = p_tags.to_s

        # Add in a scraper delay with a minimum of 5s
        sleep(5 + Random.rand(10))

        current = Post.create(question)

        # Monitor the progress
        puts current

	   # 		justthree = justthree + 1
	  	# end

	  end

	end

end
