// console.log('guidestar.js is running');

// $(function(){
//     // Pulls in results from Guidstar API through Guidestar controller
//     function getResults(){

//       $.ajax({
//         url: '/guidestar_fetch',
//         dataType: 'json',
//         success: function(data){
//           data.forEach(function(organization){
//               renderResults(organization)
//           })
//         }
//       })
//     };

//     // Renders results of Guidstar API pull
//     function renderResults(organization){
//         $('<li></li>').text(organization['organization_name']).appendTo($('#guidestar-results'));
//     }
//     getResults();
// })