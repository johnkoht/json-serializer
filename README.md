# JsonSerializer

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'json_serializer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install json_serializer

## Usage

The gem offers two primary features, serialize ActiveRecord models and collections into JSON and providing JSON Output helpers for an API. 

### ActiveRecord Patch and Custom API Attributes

We patch ActiveRecord::Base and Array with a serializer method. You can simple call `.serialize` to see this in action. If you want to customize the attributes that are serialized, simple add an `api_attributes` method to your model:

    
    class Post < ActiveRecord::Base
      ...
      def api_attributes
        {
          id: self.id.to_s,
          title: self.title.to_s,
          body: self.body.to_s,
          created_at: self.created_at.to_s,
          author: self.user.api_attributes,
        }
      end
      ...
    end
    
Adding the `api_attributes` method will allow you to control and customize the out attributes. Also note that you can have associated models, in this case Author attribute is an associated model User. We'll need to add the `api_attributes` to that model also.


### JSON Output Helper

After you have setup your custom API attributes, you can easily output JSON with a few helper methods:

#### JSON Model
Output a model in JSON:

    post = Post.find(params[:id])
    json_model :accepted, post
    
It's that simple. This will automatically serialize and output your model as JSON. Notice the `:accepted` attribute, this will set the Header Status Code to 202. You can always modify this, take a look at (this nice list of Rails HTTP Status Codes)[http://www.codyfauser.com/2008/7/4/rails-http-status-code-to-symbol-mapping] for more details.

You can optionally pass parameters by simple adding them to your `json_model` method:

    post = Post.find(params[:id])
    json_model :accepted, post, param: "Some extra parameters", more: "And some more..."
    
You can also append full serialized objects:

  post = Post.find(params[:id])
  json_model :accepted, post, comments: post.comments.serialize

In this case we called `post.comments.serialize`, which will actually collect all the objects in the array or ActiveRecord collection and serialize each one based on the API Attributes (if available) or just to_json.


#### JSON Models

Similar to the json_model method, there is a json_models method. This is simple:

    posts = Posts.all
    json_models :accepted, posts

Similarly, you can append additional parameters:

    posts = Posts.all
    json_models :accepted, posts, categories: Category.all.serialize, tags: Tag.all.serialize


#### Success and Error

You can create simple success and errors with a few helps. To create a successful JSON response, simple call:

    # json_success message, hash={}
    json_success "Great success!", extra_params: hash
    # => { success: "true", message: "message...", ... additional params ... }
    
This will automatically send a 200 Ok response in the Header Status Code.

Error codes are similar:

    # json_error code, message, metadata={}
    json_error 404, "Post not found.", errors: "Whatever extra metadata and params"
    # => { error: { message: "Message goes here", code: 404, meta_data: "goes here..." } }

And this will automatically add your status code to the HTTP response


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
