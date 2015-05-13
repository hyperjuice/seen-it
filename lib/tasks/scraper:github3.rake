namespace :scraper do

  desc "Scrape Frontend Developer Interview Questions at https://github.com/khan4019/front-end-Interview-Questions"

  task github3: :environment do

  	require 'nokogiri'
		require 'open-uri'

    # 1. Go to URL
    browser = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36'    
    main_doc = Nokogiri::HTML(open("https://github.com/khan4019/front-end-Interview-Questions", "User-Agent" => browser))

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
    link_selector = 'article > ol > li'
    questions = Array.new

    # NOTE THAT THERE ARE A HANDFUL OF ENTRIES ON
    # THIS PAGE WHICH NEED SOME MASSAGING

    main_doc.css(link_selector).each do |link|
	    questions.push( { :name => link.content,
	    	:link => "https://github.com/khan4019/front-end-Interview-Questions", :difficulty => "",
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

    # Test-print the hash array ...
    puts "QUESTION OBJECT:"
    questions.each do |question|
    	puts question.inspect
    end

  end

end

