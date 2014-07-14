function get_compliance_libraries(element) {
  $('.ajax-loader').show();
  var compliance_id = $(element).val();
  if(compliance_id.length > 0) {
    $.ajax({
      url: "/risks/department_teams_users",
      type: "GET",
      data: {"compliance_id" : compliance_id}
    });
  }
}

function get_departments(element){
  $('.ajax-loader').show();
  var location_id = $(element).val();
  if(location_id.length>0){
    $.ajax({
      url: "/risks/department_teams_users",
      type: "GET",
      data: {"location_id" : location_id}
    });
  }
}

function get_teams(element){
  $('.ajax-loader-department').show();
  var department_id = $(element).val();
  if(department_id.length>0){
    $.ajax({
      url: "/risks/department_teams_users",
      type: "GET",
      data: {"department_id" : department_id}
    });
  }
}

function get_risk_owners(element){
  $('.ajax-loader-team').show();
  var team_id = $(element).val();
  if(team_id.length>0){
    $.ajax({
      url: "/risks/department_teams_users",
      type: "GET",
      data: {"team_id" : team_id}
    });
  }
}

function change_scoring_method(element){
  var scoringTypeVal = $(element).val();
  risk_scoring_attirbute(scoringTypeVal)
}

function risk_scoring_attirbute(scoringType)
{
  if (scoringType == 'ClassicScoring')
  {
    $('.scoring_model').show();
    $('.classic_scoring').show();
    $('.owasp_scoring').hide();
    $('.dread_scoring').hide();
    $('.cvss_scoring').hide();
    $('.custom_scoring').hide();
    $('.classic_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("temp[", "risk["));});
    $('.owasp_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.dread_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.cvss_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
  }
  if (scoringType == 'OwaspScoring')
  {
    $('.owasp_scoring').show();
    $('.scoring_model').hide();
    $('.dread_scoring').hide();
    $('.cvss_scoring').hide();
    $('.custom_scoring').hide();
    $('.scoring_model').hide();
    $('.classic_scoring').hide();
    $('.owasp_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("temp[", "risk["));});
    $('.dread_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.cvss_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.classic_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
  }
  if (scoringType == 'DreadScoring')
  {
    $('.dread_scoring').show();
    $('.scoring_model').hide();
    $('.owasp_scoring').hide();
    $('.cvss_scoring').hide();
    $('.custom_scoring').hide();
    $('.scoring_model').hide();
    $('.classic_scoring').hide();
    $('.dread_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("temp[", "risk["));});
    $('.owasp_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.cvss_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.classic_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
  }
  if (scoringType == 'CvssScoring')
  {
    $('.cvss_scoring').show();
    $('.scoring_model').hide();
    $('.owasp_scoring').hide();
    $('.dread_scoring').hide();
    $('.custom_scoring').hide();
    $('.scoring_model').hide();
    $('.classic_scoring').hide();
    $('.cvss_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("temp[", "risk["));});
    $('.owasp_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.dread_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.classic_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
  }
  if (scoringType == 'Custom')
  {
    $('.custom_scoring').show();
    $('.scoring_model').hide();
    $('.owasp_scoring').hide();
    $('.dread_scoring').hide();
    $('.cvss_scoring').hide();
    $('.scoring_model').hide();
    $('.classic_scoring').hide();
    $('.cvss_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.owasp_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.dread_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.classic_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
  }
  if (scoringType == '')
  {
    $('.custom_scoring').hide();
    $('.scoring_model').hide();
    $('.owasp_scoring').hide();
    $('.dread_scoring').hide();
    $('.cvss_scoring').hide();
    $('.scoring_model').hide();
    $('.classic_scoring').hide();
    $('.cvss_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.owasp_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.dread_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
    $('.classic_scoring').find('select').each(function(){$(this).attr('name',$(this).attr("name").replace("risk[", "temp["));});
  }
}

function display_selected_files(e)
{
  $(e).parent().find("#selected_files").html("<h5>Selected: " + $(e).val() + "</h5>");
}

$(document).ready(function(){
  var scoringTypeVal = $('#risk_scoring').val();
  risk_scoring_attirbute(scoringTypeVal);

  $('.risk_attachment').hide();
  $('.blue_link').css('cursor', 'pointer')
  $('.blue_link').click(function(){
    $('.risk_attachment').click();
  })

});
