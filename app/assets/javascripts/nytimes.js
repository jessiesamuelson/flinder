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
    url: '/nytimes_facet'
  })
})