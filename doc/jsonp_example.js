$.getJSON('http://localhost:3000/search/title.json?query=ja&callback=?', function(data) {
  // Define your own processing of the JSON...
  process(data);
});
