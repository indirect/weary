# Weary

_The Weary need REST_

Weary is a tiny DSL for making the consumption of RESTful web services simple. It is the little brother to [HTTParty](http://github.com/jnunemaker/httparty/ "JNunemaker's HTTParty"). It provides a thin, gossamer-like layer over the Net/HTTP library.

The things it do:

+ Quickly build an interface to your favorite REST API.
+ Parse XML and JSON with the [Crack](http://github.com/jnunemaker/crack) library.

Browse the documentation here: [http://rdoc.info/projects/mwunsch/weary](http://rdoc.info/projects/mwunsch/weary)

## Requirements

+ Crack >= 0.1.2
+ Nokogiri >= 1.3.1 (if you want to use the #search method)

## Installation

You do have Rubygems right?

	sudo gem install weary

## How it works

Create a class and `extend Weary` to give it methods to craft a resource request:

	class Foo
		extend Weary
		
		declare "foo" do |resource|
			resource.url = "http://path/to/foo"
		end
	end
	
If you instantiate this class, you'll get an instance method named `foo` that crafts a GET request to "http://path/to/foo"

Besides the name of the resource, you can also give `declare_resource` a block like:

	declare "foo" do |r|
		r.url = "path/to/foo"
		r.via = :post 				# defaults to :get
		r.format = :xml 			# defaults to :json
		r.requires = [:id, :bar] 	# an array of params that the resource requires to be in the query/body
		r.with = [:blah]			# an array of params that you can optionally send to the resource
		r.authenticates = false		# does the method require basic authentication? defaults to false
		r.follows = false			# if this is set to false, the formed request will not follow redirects.
	end
					
So this would form a method:
	
	x = Foo.new
	x.foo(:id => "mwunsch", :bar => 123)
	
That method would return a Weary::Response object that you could then parse or examine.

### Shortcuts

Of course, you don't always have to use `declare`; that is a little too ambiguous. You can also use `get`, `post`, `delete`, etc. Those do the obvious.

The `#requires` and `#with` methods can either be arrays of symbols, or a comma delimited list of strings.

### Forming URLs

There are many ways to form URLs in Weary. You can define URLs for the entire class by typing:

	class Foo
		extend Weary
		
		on_domain "http://foo.bar/"
		construct_url "<domain><resource>.<format>"
		as_format :xml
		
		get "show_users"
	end
	
The string `<domain><resource>.<format>` helps define a simple pattern for creating URLs. These will be filled in by your resource declaration. The above `get` declaration creates a url that looks like: *http://foo.bar/show_users.xml*
	
If you use the `<domain>` flag but don't define a domain, an exception will be raised.
	