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

  // Gets user's search results and renders to the page
  function getUserChoice() {
    var $form = $('#user-search');

    $form.on('submit', function(e){
      e.preventDefault();

      $.ajax({
        url: '/user_choice',
        dataType: 'json',
        data: $(this).serialize(),
        success: function(data){
          console.log(data)

          var $ul_4 = $("#twitter-search-result-4").append("<h2></h2>").text(data[3])
          data[0].forEach(function(tweet){
            $("<li></li>").append($("<a href='https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id_str + "' target='_blank'>"+tweet['text']+"</a>")).appendTo($ul_4)
          })
          var $gs_ul_4 = $("#fourth-guidestar-results").append("<h2></h2>").text(data[3]);
          if (data[1] != null){
            data[1].forEach(function(org){
              $("<li></li>").text(org["organization_name"]).appendTo($gs_ul_4)
            })        
          } 
        }
      })
    })
  };
  getUserChoice();
  
  // Renders results of NYTimes API pull
  function renderResults(article){
    var $ul = $('#nytimes-results');
    $("<li></li>").text(article['des_facet'] + ' in ' + article['geo_facet']).appendTo($ul);
  }
  getResults();

// data = [
// @tweets_1, @tweets_2, @tweets_3, 
// @search_term_1, @search_term_2, @search_term_3, 
// @first_org, @second_org, @third_org, 
// @first_org_details, @second_org_details, @third_org_details]

  // Renders twitter and guidestar results to appropirate uls on page
  $.ajax({
    url: '/nytimes_facet',
    dataType: 'json',
    success: function(data) {
      console.log(data[9])
      console.log(data[10])
      console.log(data[11])
      var $ul_1 = $("#twitter-search-result-1").append("<h2></h2>").text(data[3])
      data[0].forEach(function(tweet){
        $("<li></li>").append($("<a href='https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id_str + "' target='_blank'>"+tweet['text']+"</a>")).appendTo($ul_1)
      })
      var $ul_2 = $("#twitter-search-result-2").append("<h2></h2>").text(data[4])
      data[1].forEach(function(tweet){
        $("<li></li>").append($("<a href='https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id_str + "' target='_blank'>"+tweet['text']+"</a>")).appendTo($ul_2)
      })
      var $ul_3 = $("#twitter-search-result-3").append("<h2></h2>").text(data[5])
      data[2].forEach(function(tweet){
        $("<li></li>").append($("<a href='https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id_str + "' target='_blank'>"+tweet['text']+"</a>")).appendTo($ul_3)
      })


      var $gs_ul_1 = $("#first-guidestar-results").append("<h2></h2>").text(data[3]);
      if (data[6] != null){
        data[6].forEach(function(org){
          $("<li></li>").attr('id', "organization-" + org["organization_id"]).text(org["organization_name"]).appendTo($gs_ul_1).append($("<div></div>").text(org["mission"]))
        })
      }
      if (data[9] != null){
        data[9].forEach(function(org){
        $('#organization-' + org['organization_id']).append($("<div></div>").text("I found you"))
        })
      }
      var $gs_ul_2 = $("#second-guidestar-results").append("<h2></h2>").text(data[4]);
        if (data[7] != null){
        data[7].forEach(function(org){
          $("<li></li>").attr('id', "organization-" + org["organization_id"]).text(org["organization_name"]).appendTo($gs_ul_2).append($("<div></div>").text(org["mission"]))
        })        
      } 
      var $gs_ul_3 = $("#third-guidestar-results").append("<h2></h2>").text(data[5]);
      if (data[8] != null){
        data[8].forEach(function(org){
          $("<li></li>").attr('id', "organization-" + org["organization_id"]).text(org["organization_name"]).appendTo($gs_ul_3).append($("<div></div>").text(org["mission"]))
        })        
      }
    }
  })
})