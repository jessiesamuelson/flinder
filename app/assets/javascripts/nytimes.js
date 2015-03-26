console.log('nytimes.js running');

// var baseURL = "http://api.nytimes.com/svc/news/v3/content/all/all.json?api-key=";


function getResults() {

  $.ajax({
    url: '/nytimes_fetch',
    dataType: 'json',
    error: function(data){
    	console.log(data['responseText']);
    }
  });
};

// function renderResults(data){
// 	debugger;
// }

getResults();