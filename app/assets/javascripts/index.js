console.log('guidestar.js is running');

$(function(){
	var $upperLogo = $('.logo');
	var $about = $('.about');
	$about.hide();

	$upperLogo.on('mouseover', function() {
		$about.show();
		// $about.fadeIn('slow');
	});

	$upperLogo.on('mouseout', function() {
		$about.hide();
		// $about.fadeOut('slow');
	});
})
