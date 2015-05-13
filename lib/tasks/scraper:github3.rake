# WORKING!

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

    # Questions 0-20 should be tagged "javascript"
    # Questions 21-50 should be tagged "CSS"
    # Questions 51-70 should be tagged "javascript" "algorithms"
    # Questions 71-91 should be tagged "javascript" "DOM"
    # Questions 92-106 should be tagged "HTML"

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

    dom_tag = Tag.find_by(category: 'DOM')
    if dom_tag.nil?
      dom_tag = Tag.create({category: 'DOM'})
    else
      puts "DOM already exists ..."
    end

    html_tag = Tag.find_by(category: 'HTML')
    if html_tag.nil?
      html_tag = Tag.create({category: 'HTML'})
    else
      puts "HTML already exists ..."
    end

     algorithms_tag = Tag.find_by(category: 'algorithms')
    if algorithms_tag.nil?
      algorithms_tag = Tag.create({category: 'algorithms'})
    else
      puts "algorithms already exists ..."
    end

    # Test-print the hash array ...
    puts "QUESTION OBJECT:"
    questions.each_with_index do |question,i|
      puts "\n"
    	puts question.inspect
      puts "\n"

      # Questions 0-20 should be tagged "javascript"
      # Questions 21-50 should be tagged "CSS"
      # Questions 51-70 should be tagged "javascript" "algorithms"
      # Questions 71-91 should be tagged "javascript" "DOM"
      # Questions 92-106 should be tagged "HTML"

      case i
      when 0..20
        current = Post.create(question)
        current.tags << javascript_tag
      when 21..50
        current = Post.create(question)
        current.tags << css_tag
      when 51..70
        current = Post.create(question)
        current.tags << javascript_tag
        current.tags << algorithms_tag
      when 71..91
        current = Post.create(question)
        current.tags << javascript_tag
        current.tags << dom_tag
      when 92..106
        current = Post.create(question)
        current.tags << html_tag
      end

    end

  end

end

