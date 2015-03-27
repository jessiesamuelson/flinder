console.log('guidestar.js is running');

function getResults(){

    $.ajax({
        url: '/guidestar_fetch',
        dataType: 'json',
        success: function(data){
            console.log(data)
        }
    })
};