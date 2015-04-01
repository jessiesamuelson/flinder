console.log('nytimes.js running');

$(function(){
  var $formDiv = $('#user-click');

  // Pulls in results from NYTimes API through NYTimes controller
  function getResults() {

    $.ajax({
      url: '/nytimes_fetch',
      dataType: 'json',
      success: function(data) {
        data.forEach(function(article){
          renderResult(article)
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
              $("<li></li>").attr('id', "organization-" + org["organization_id"]).text(org["organization_name"]).appendTo($gs_ul_4).append($("<div></div>").text(org["mission"]))
            })        
          }
          if (data[4] != null){
            data[4].forEach(function(org){
            $('#organization-' + org['organization_id']).append($("<div></div>").text("Income Total: " + org["income_total"])).append($("<div></div>").text("Revenue Total: " + org["revenue_total"]))
            })
          } 
        }
      })
    })
  };
  function getUserClick() {
    $formDiv.on('submit', 'form', function(e){
      e.preventDefault();
      $.ajax({
        url: '/user_click',
        dataType: 'json',
        data: {
          topic: this.elements.topic.value
        },
        success: function(data){
          console.log(data);
          var $ul_5 = $("#twitter-search-result-5").append("<h2></h2>").text(data[2])
          data[0].forEach(function(tweet){
            $("<li></li>").append($("<a href='https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id_str + "' target='_blank'>"+tweet['text']+"</a>")).appendTo($ul_5)
          })
          var $gs_ul_5 = $("#fifth-guidestar-results").append("<h2></h2>").text(data[2]);
          if (data[1] != null){
            data[1].forEach(function(org){
              $("<li></li>").attr('id', "organization-" + org["organization_id"]).text(org["organization_name"]).appendTo($gs_ul_5).append($("<div></div>").text(org["mission"]))
            })        
          }
          if (data[3] != null){
            data[3].forEach(function(org){
            $('#organization-' + org['organization_id']).append($("<div></div>").text("Income Total: " + org["income_total"])).append($("<div></div>").text("Revenue Total: " + org["revenue_total"]))
            })
          } 
        }
      })
    })
  };

  getUserChoice();
  getUserClick();
  
   // Renders results of NYTimes API pull
  function renderResult(article){
    var $topicOfChoice;
    
    if (article['des_facet'] != '' && article['geo_facet'] != '') {
      if (article['geo_facet'].length > 1) {
        $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['geo_facet'][0] + ' ' + article['geo_facet'][1];
      } else {
         $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['geo_facet'][0];
      }
    } else if (article['des_facet'] != '' && article['geo_facet'] == '') {
      $topicOfChoice = article['des_facet'][0].split(' ')[0];
    } else if (article['des_facet'] == '' && article['geo_facet'] != '') {
      if (article['geo_facet'].length > 1) {
        $topicOfChoice = article['geo_facet'][0] + ' ' + article['geo_facet'][1];
      } else {
       $topicOfChoice = article['geo_facet'][0];
      }
    };

    // if (article['des_facet'] != '' && article['geo_facet'] != '') {
    //   if (article['des_facet'].length > 1) {
    //     if (article['geo_facet'].length > 1) {
    //       $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['des_facet'][0].split(' ')[1] + ' ' + article['geo_facet'][0] + ' ' + article['geo_facet'][1];
    //     } else {
    //       $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['des_facet'][0].split(' ')[1] + ' ' + article['geo_facet'][0];
    //     }
    //   } else {
    //     if (article['geo_facet'].length > 1) {
    //       $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['geo_facet'][0] + ' ' + article['geo_facet'][1];
    //     } else {
    //       $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['geo_facet'][0];
    //     }
    //   }
    // } else if (article['des_facet'] != '' && article['geo_facet'] == '') {
    //   if (article['des_facet'].length > 1) {
    //     $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['des_facet'][0].split(' ')[1]
    //   } else {
    //     $topicOfChoice = article['des_facet'][0].split(' ')[0]
    //   }
    // } else if (article['des_facet'] == '' && article['geo_facet'] != '') {
    //   if (article['geo_facet'].length > 1) {
    //     $topicOfChoice = article['geo_facet'][0] + ' ' + article['geo_facet'][1];
    //   } else {
    //     $topicOfChoice = article['geo_facet'][0];
    //   }
    // } else {};

    console.log($topicOfChoice);

    var $form = $("<form>").attr("action", "/user_click").attr("method", "post");
    var $dataInput = $("<input type='hidden'>").attr('value', $topicOfChoice).attr('name','topic');
    var $submitInput = $("<input type='submit'>").attr('value', article['des_facet'] + ' in ' + article['geo_facet']);

    $form.append($dataInput).append($submitInput);
    $formDiv.append($form);
  };

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
        $('#organization-' + org['organization_id']).append($("<div></div>").text("Income Total: " + org["income_total"])).append($("<div></div>").text("Revenue Total: " + org["revenue_total"]))
        })
      }

      var $gs_ul_2 = $("#second-guidestar-results").append("<h2></h2>").text(data[4]);
        if (data[7] != null){
        data[7].forEach(function(org){
          $("<li></li>").attr('id', "organization-" + org["organization_id"]).text(org["organization_name"]).appendTo($gs_ul_2).append($("<div></div>").text(org["mission"]))
        })        
      }
      if (data[10] != null){
        data[10].forEach(function(org){
        $('#organization-' + org['organization_id']).append($("<div></div>").text("Income Total: " + org["income_total"])).append($("<div></div>").text("Revenue Total: " + org["revenue_total"]))
        })
      }

      var $gs_ul_3 = $("#third-guidestar-results").append("<h2></h2>").text(data[5]);
      if (data[8] != null){
        data[8].forEach(function(org){
          $("<li></li>").attr('id', "organization-" + org["organization_id"]).text(org["organization_name"]).appendTo($gs_ul_3).append($("<div></div>").text(org["mission"]))
        })        
      }
      if (data[11] != null){
        data[11].forEach(function(org){
        $('#organization-' + org['organization_id']).append($("<div></div>").text("Income Total: " + org["income_total"])).append($("<div></div>").text("Revenue Total: " + org["revenue_total"]))
        })
      }
    }
  })
})