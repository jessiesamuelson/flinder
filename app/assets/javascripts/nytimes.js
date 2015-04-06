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
    var $spinner = $('.spinner');
    var $form = $('#user-search');

    $form.on('submit', function(e){
      e.preventDefault();

      // places spinner on the middle of the page
      $spinner.append("<img src='/spinner.gif' />")
        .css("top", Math.max(0, (($(window).height()) / 2) + $(window).scrollTop()) + "px")
        .css("left", Math.max(0, (($(window).width() - 375) / 2) + $(window).scrollLeft()) + "px").hide().fadeIn(200);

      $.ajax({
        url: '/user_choice',
        dataType: 'json',
        data: $(this).serialize(),
        success: function(data){
          $spinner.empty();
          $('#my-search').ScrollTo();

          // var $tw_ul = $("#my-twitter-search-result");
          var $tw_ul = $("<ul></ul>");
          var $tw_div = $("#tw-search-result");
          var $tw_h1 = ("<h1>Tweets About " + data[3] + "</h1>");

          $tw_ul.empty();
          $tw_div.empty();

          $tw_div.append($tw_ul);
          $tw_div.prepend($tw_h1);
          data[0].forEach(function(tweet){
            $("<li></li>")
              .attr('class', 'tw-result')
              .append($("<a href='https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id_str + "' target='_blank'>"+tweet['text']+"</a>"))
              .appendTo($tw_ul)
          })
          // var $gs_ul = $("#my-guidestar-results");
          var $gs_ul = $("<ul></ul>");
          var $gs_div = $("#gs-search-result");
          var $gs_h1 = ("<h1>GuideStar Results for " + data[3] + "</h1>");
          $gs_ul.empty();
          $gs_div.empty();

          $gs_div.append($gs_ul);
          $gs_div.prepend($gs_h1);
          if (data[1] != null){
            data[1].forEach(function(org){
              $("<li></li>").attr('id', "organization-" + org["organization_id"])
                .attr('class', 'gs-result')
                .append("<h3>" + org["organization_name"] + "</h3>")
                .appendTo($gs_ul)
                .append($("<div></div>")
                .append("<p class='mission'>" + org["mission"] + "</p>"))
            })        
          }
          if (data[4] != null){
            data[4].forEach(function(org){
              var $statsArray = [{value: org["revenue_total"], type: "revenue total"}, {value: org["income_total"], type: "income total"}];
              var organization_id = "svg-" + org['organization_id'];
              
              var revenue = org["revenue_total"];
              console.log(revenue)
              if (revenue == undefined || revenue == 0){
                var formattedRevenue = "Information unavailable";
              } else {
                revenue = "$" + org["revenue_total"];
                var formattedRevenue = (revenue).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
              }
              var income = org["income_total"];
              if (income == undefined || income == 0){
                var formattedIncome = "Information unavailable";
              } else {
                income = "$" + org["income_total"];
                var formattedIncome = (income).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
              } 

              if (formattedIncome == "Information unavailable" && formattedRevenue == "Information unavailable") {
                $('#organization-' + org['organization_id'])
                .append($("<p class='stats'></p>").text("Revenue Total: " + formattedRevenue))
                .append($("<p class='stats'></p>").text("Income Total: " + formattedIncome))
              } else {
                $('#organization-' + org['organization_id'])
                .append($("<p class='stats'></p>").text("Revenue Total: " + formattedRevenue))
                .append($("<p class='stats'></p>").text("Income Total: " + formattedIncome))
                .append('<svg class="stats-field" id='+ organization_id+ '></svg>');
              };

              var setUpStats = function(stats){
                  var height = 150;
                  var width = 480;

                  var minStat = d3.min(stats, function(d){return d.value;
                  });                  
                  var maxStat = d3.max(stats, function(d){return d.value;
                  });

                  var scaleX = d3.scale.linear()
                    .domain([0, maxStat])
                    .range([0, maxStat/500])


                  var svg = d3.select('#' + organization_id)
                    .attr('width', width)
                    .attr('height', height)
                  
                  svg.selectAll('rect')
                    .data(stats)
                    .exit()
                    .remove();

                  svg.selectAll('rect')
                    .data(stats)
                    .enter()
                    .append('rect')

                  svg.selectAll('rect')
                    .attr('height', 30)
                    .attr('width', function(d) { return scaleX(d.value)})
                    .attr('x', function(d) { return -(scaleX(d.value))})
                    .attr('y', function(d, i){ return 35 + (50 * i) })
                    .style('fill', '#C7D353')
                    .text(function(d) {return d.type})
                  .transition()
                    .duration(1000)
                    .attr('x', 0)

                  svg.selectAll('text')
                    .data(stats)
                    .exit()
                    .remove();

                  svg.selectAll('text')
                    .data(stats)
                    .enter()
                    .append('text')

                  svg.selectAll('text')
                    .attr('height', 30)
                    .attr('width', function(d) { return d.value /300})
                    .attr('x', 0)
                    .attr('y', function(d, i){ return 35 + (50 * i) })
                    
                    .text(function(d) {return d.type})
                    .attr('font-family', 'Roboto')
                    .style('fill', '#FFFFFF')

                }
                setUpStats($statsArray);
            })
          } 
        }
      })
    })
  };

  // gets topic from nytimes top stories
  function getUserClick() {
    var $spinner = $('.spinner');

    $formDiv.on('submit', 'form', function(e){
      e.preventDefault();

      // places spinner on the middle of the page
      $spinner.append("<img src='/spinner.gif' />")
        .css("top", Math.max(0, (($(window).innerHeight() - 500) / 2) + $(window).scrollTop()) + "px")
        .css("left", Math.max(0, (($(window).width() - 375) / 2) + $(window).scrollLeft()) + "px").hide().fadeIn(200);

      $.ajax({
        url: '/user_click',
        dataType: 'json',
        data: {
          topic: this.elements.topic.value
        },
        success: function(data){
          $spinner.empty();
          $('#topic-search').ScrollTo();

          // var $tw_ul = $("#topic-twitter-search-result");
          var $tw_ul = $("<ul></ul>");
          var $tw_div = $("#tw-click-result");
          var $tw_h1 = ("<h1>Tweets About " + data[2] + "</h1>");
          $tw_ul.empty();
          $tw_div.empty();

          $tw_div.append($tw_ul);
          $tw_div.prepend($tw_h1);

          data[0].forEach(function(tweet){
            $("<li></li>")
              .attr('class', 'tw-result')
              .append($("<a href='https://twitter.com/"+ tweet.user.screen_name + "/status/" + tweet.id_str + "' target='_blank'>"+tweet['text']+"</a>"))
              .appendTo($tw_ul)
          })
          // var $gs_ul = $("#topic-guidestar-results");
          var $gs_ul = $("<ul></ul>");
          var $gs_div = $("#gs-click-result");
          var $gs_h1 = ("<h1>GuideStar Results for " + data[2] + "</h1>");

          $gs_ul.empty();
          $gs_div.empty();

          $gs_div.append($gs_ul);
          $gs_div.prepend($gs_h1);
          if (data[1] != null){
            data[1].forEach(function(org){
              $("<li></li>").attr('id', "organization-" + org["organization_id"])
                .attr('class', 'gs-result')
                .append("<h3>" + org["organization_name"] + "</h3>")
                .appendTo($gs_ul).append($("<div></div>")
                .append("<p class='mission'>" + org["mission"] + "</p>"))
            })        
          }
          if (data[3] != null){
            data[3].forEach(function(org){
              var $statsArray = [{value: org["revenue_total"], type: "revenue total"}, {value: org["income_total"], type: "income total"}];
              var organization_id = "svg-" + org['organization_id'];
              
              var revenue = org["revenue_total"];

              if (revenue == undefined || revenue == 0){
                var formattedRevenue = "Information unavailable";
              } else {
                revenue = "$" + org["revenue_total"];
                var formattedRevenue = (revenue).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
              }
              var income = org["income_total"];
              if (income == undefined || income == 0){
                var formattedIncome = "Information unavailable";
              } else {
                income = "$" + org["income_total"];
                var formattedIncome = (income).replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
              }; 
              if (formattedIncome == "Information unavailable" && formattedRevenue == "Information unavailable") {
                $('#organization-' + org['organization_id'])
                .append($("<p class='stats'></p>").text("Revenue Total: " + formattedRevenue))
                .append($("<p class='stats'></p>").text("Income Total: " + formattedIncome))
              } else {
                $('#organization-' + org['organization_id'])
                .append($("<p class='stats'></p>").text("Revenue Total: " + formattedRevenue))
                .append($("<p class='stats'></p>").text("Income Total: " + formattedIncome))
                .append('<svg class="stats-field" id='+ organization_id+ '></svg>');
              };

                var setUpStats = function(stats){
                  var height = 150;
                  var width = 480;

                  var minStat = d3.min(stats, function(d){return d.value;
                  });                  
                  var maxStat = d3.max(stats, function(d){return d.value;
                  });

                  var scaleX = d3.scale.linear()
                    .domain([0, maxStat])
                    .range([0, maxStat/500])           

                  var svg = d3.select('#' + organization_id)
                    .attr('width', width)
                    .attr('height', height)
                  
                  svg.selectAll('rect')
                    .data(stats)
                    .exit()
                    .remove();

                  svg.selectAll('rect')
                    .data(stats)
                    .enter()
                    .append('rect')

                  svg.selectAll('rect')
                    .attr('height', 30)
                    .attr('width', function(d) { return scaleX(d.value)})
                    .attr('x', function(d) { return -(scaleX(d.value))})
                    .attr('y', function(d, i){ return 35 + (50 * i) })
                    .style('fill', '#C7D353')
                  .transition()
                    .duration(1000)
                    .attr('x', 0)

                  svg.selectAll('text')
                    .data(stats)
                    .exit()
                    .remove();

                  svg.selectAll('text')
                    .data(stats)
                    .enter()
                    .append('text')

                  svg.selectAll('text')
                    .attr('height', 30)
                    .attr('width', function(d) { return d.value /300})
                    .attr('x', 0)
                    .attr('y', function(d, i){ return 35 + (50 * i) })
                    .text(function(d) {return d.type})
                    .attr('font-family', 'Roboto')
                    .style('fill', '#FFFFFF')
                }
                setUpStats($statsArray);

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
      if (article['des_facet'][0].split(' ').length > 1) {
        if (article['geo_facet'][0].split(' ').length > 1) {
          $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['des_facet'][0].split(' ')[1] + ' ' + article['geo_facet'][0].split(' ')[0] + ' ' + article['geo_facet'][0].split(' ')[1];
        } else {
          $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['des_facet'][0].split(' ')[1] + ' ' + article['geo_facet'][0].split(' ')[0];
        }
      } else {
        if (article['geo_facet'][0].split(' ').length > 1) {
          $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['geo_facet'][0].split(' ')[0] + ' ' + article['geo_facet'][0].split(' ')[1];
        } else {
          $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['geo_facet'][0].split(' ')[0];
        }
      }
    } else if (article['des_facet'] != '' && article['geo_facet'] == '') {
      if (article['des_facet'][0].split(' ').length > 1) {
        $topicOfChoice = article['des_facet'][0].split(' ')[0] + ' ' + article['des_facet'][0].split(' ')[1]
      } else {
        $topicOfChoice = article['des_facet'][0].split(' ')[0]
      }
    } else if (article['des_facet'] == '' && article['geo_facet'] != '') {
      if (article['geo_facet'][0].split(' ').length > 1) {
        $topicOfChoice = article['geo_facet'][0].split(' ')[0] + ' ' + article['geo_facet'][0].split(' ')[1];
      } else {
        $topicOfChoice = article['geo_facet'][0].split(' ')[0];
      }
    };

    var $text;
    if (article['des_facet'] != '' && article ['geo_facet'] != '') {
      $text = article['des_facet'] + ' in ' + article ['geo_facet'];
    } else if (article['des_facet'] != '' && article ['geo_facet'] == '') {
      $text = article['des_facet'];
    } else if (article['des_facet'] == '' && article ['geo_facet'] != '') {
      $text = article['geo_facet'];
    }

    var $form = $("<form>").attr("action", "/user_click")
      .attr("method", "post")
      .attr('class', 'nyt-topic');
    var $dataInput = $("<input type='hidden'>")
      .attr('value', $topicOfChoice)
      .attr('name','topic');

    if ($text === undefined) {
      var $submitInput = $("<div></div>")
        .append("<p></p>")
        .attr('class', 'green-form');
    } else {
      var $submitInput = $("<input type='submit'>")
        .attr('value', $text)
        .attr('class', 'nyt-topic-btn');
    };

    $form.append($dataInput).append($submitInput);
    $formDiv.append($form);
  };

  getResults();

});