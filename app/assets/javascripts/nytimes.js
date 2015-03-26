console.log('nytimes.js running');

// var baseURL = "http://api.nytimes.com/svc/news/v3/content/all/all.json?api-key=";

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


function renderResults(article){
	var $ul = $('#nytimes-results');
	// var $title = ("<li></li>");
	$("<li></li>").text(article['des_facet'] + ' in ' + article['geo_facet']).appendTo($ul);
	// $("<li></li>").text(article['title'] + "; " + article['abstract']).appendTo($ul);

}

getResults();