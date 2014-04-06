app.factory('Post', function($resource) {

  return $resource('/api/v1/posts/:id', { id: '@id' });

});

app.controller('PostCtrl', function($scope, Post) {
  $scope.posts = Post.query();

  $scope.save = function() {
    Post.save($scope.post, function(newPost) {
      $scope.posts.push(newPost);
    });
    $scope.post = "";
  };
});
