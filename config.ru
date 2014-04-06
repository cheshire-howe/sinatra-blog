require "sass/plugin/rack"
require "./sitewide_helpers"
require "./site"

# require local apps
["./apps/users/users",
  "./apps/users/users_helpers",
  "./apps/users/users_controller",
  "./apps/posts/posts",
  "./apps/socket/chat"].each do |app|
  require app
end

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

map('/chat') {run ChatController}
map('/api/v1/posts') {run PostsController}
map('/') {run UsersController}
run SiteController
