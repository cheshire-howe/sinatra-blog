class Post
  include DataMapper::Resource

  property :id,         Serial
  property :url,        String, format: :url, required: true
  property :body,       String, required: true
  property :created_at, DateTime

  belongs_to :user
end

DataMapper.finalize
DataMapper.auto_upgrade!

module PostsHelpers
  def format_response(data, accept)
    accept.each do |type|
      return data.to_xml  if type.downcase.eql? 'text/xml'
      return data.to_json if type.downcase.eql? 'application/json'
      return data.to_yaml if type.downcase.eql? 'text/x-yaml'
      return data.to_csv  if type.downcase.eql? 'text/csv'
      return data.to_json
    end
  end
end

class PostsController < SiteController
  helpers PostsHelpers

  get '/?' do
    login_required
    post = Post.all#(order: [:created_at.desc])
    format_response(post, request.accept)
  end

  get '/reese/?' do
    'hello world'
  end

  get '/:id/?' do
    post ||= Post.get(params[:id]) || halt(404)
    format_response(post, request.accept)
  end

  post '/' do
    login_required
    body = JSON.parse(request.body.read)
    post = Post.create(
      url:      body['url'],
      body:     body['body'],
      user_id:  current_user.id
    )
    if post.save
      status 201
    else
      status 501
    end
    format_response(post, request.accept)
  end

  put '/:id' do
    login_required
    body = JSON.parse(request.body.read)
    post ||= Post.get(params[:id]) || halt(404)
    halt 500 unless post.update(
      url:    body['url'],
      body:   body['body']
    )
    format_response(post, request.accept)
  end

  delete '/' do
    admin_required
    post ||= Post.get(params[:id]) || halt(404)
    halt 500 unless post.destroy
  end
end
