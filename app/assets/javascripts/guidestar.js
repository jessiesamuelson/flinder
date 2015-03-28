console.log('guidestar.js is running');

$(function(){
	// Pulls in results from Guidstar API through Guidestar controller
	function getResults(){

<<<<<<< HEAD
<<<<<<< HEAD
	$.ajax({
		url: '/guidestar_fetch',
		dataType: 'json',
		success: function(data){
			console.log(data)
		}
	})
=======
    $.ajax({
        url: '/guidestar_fetch',
        dataType: 'json',
        success: function(data){
            console.log(data)
        }
    })
>>>>>>> 8be8e4eb8d0077a56d4c7a08c52922eeb2ade5ce
};
=======
	  $.ajax({
	    url: '/guidestar_fetch',
	    dataType: 'json',
	    success: function(data){
	      data.forEach(function(organization){
	      	renderResults(organization)
	      })
	    }
	  })
	};

	// Renders results of Guidstar API pull
	function renderResults(organization){
		$('<li></li>').text(organization['organization_name']).appendTo($('#guidestar-results'));
	}
	getResults();
})
>>>>>>> c365e0cac530c325d7280b8faa23c28864909c19
