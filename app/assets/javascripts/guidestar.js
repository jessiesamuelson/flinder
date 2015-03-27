console.log('guidestar.js is running');

function getResults(){

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