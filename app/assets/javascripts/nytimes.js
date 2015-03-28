console.log('nytimes.js running');

$(function(){
  // Pulls in results from NYTimes API through NYTimes controller
  function getResults() {

    $.ajax({
      url: '/nytimes_fetch',
      dataType: 'json',
      success: function(data) {
        data.forEach(function(article){
          renderResults(article)
        })
      }
    });
  };

  // Renders results of NYTimes API pull
  function renderResults(article){
  	var $ul = $('#nytimes-results');
    $("<li></li>").text(article['des_facet'] + ' in ' + article['geo_facet']).appendTo($ul);
  }
  getResults();

  $.ajax({
    url: '/nytimes_facet',
    dataType: 'json',
    success: function(data) {
      // console.log(data[0][0].id)
      // console.log(data[0][0].user.screen_name)
      var $ul_1 = $("#twitter-search-result-1")
      data[0].forEach(function(tweet){
        $("<li></li>").append($("<a href='https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id_str + "' target='_blank'>"+tweet['text']+"</a>")).appendTo($ul_1)
      })

      'https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id + "'
      var $ul_2 = $("#twitter-search-result-2")
      data[1].forEach(function(tweet){
        $("<li></li>").append($("<a href='https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id_str + "' target='_blank'>"+tweet['text']+"</a>")).appendTo($ul_2)
      })
      var $ul_3 = $("#twitter-search-result-3")
      data[2].forEach(function(tweet){
        $("<li></li>").append($("<a href='https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id_str + "' target='_blank'>"+tweet['text']+"</a>")).appendTo($ul_3)
      })
    }
  })
})