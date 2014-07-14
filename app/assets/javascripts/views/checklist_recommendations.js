/*validation for checklist recommendation*/
	function save_draft_checklist()
					{
						var save_draft = $("#save_draft_"+id).val()
						$("#save_draft_"+id).val('true')
					}
					function  control_checklist()
					{
					var recommendation = recommendation()
					var priority = priority()
					var reason = reason()
					var severity = severity()
					var closure_date = closure_date()
					var status = status()
					if (recommendation && priority && reason && severity && closure_date && status)
					{
					return true
					}
				else
				{
				return false
				}
					function recommendation()
					{
					$(".control_recommendation").each(function() {
						var recommendation_value = $(this).val()
						if (recommendation_value == '')
						{
						$('#'+this.id).addClass("error_input");
						$('#error_'+this.id).show()
						value = false
						}
						else
						{
						$('#'+this.id).removeClass("error_input");
						$('#error_'+this.id).hide()
						value = true
						}
					});
					return value
					}
					function priority()
					{
					$(".control_priority").each(function() {
						var priority_value = $(this).val()
						if (priority_value == '')
						{
						$('#'+this.id).addClass("error_input");
						$('#error_'+this.id).show()
						value = false
						}
						else
						{
						$('#'+this.id).removeClass("error_input");
						$('#error_'+this.id).hide()
						value = true
						}
					});
					return value
					}
					function reason()
					{
					$(".control_reason").each(function() {
						var status_value = $(this).val()
						if (status_value == '')
						{
						$('#'+this.id).addClass("error_input");
						$('#error_'+this.id).show()
						value = false
						}
						else
						{
						$('#'+this.id).removeClass("error_input");
						$('#error_'+this.id).hide()
						value = true
						}
					});
					return value
					}
					function severity()
					{
					$(".control_severity").each(function() {
						//~ var recommendation_value = $(this).val()
						if ($(this).val() == '')
						{
						$('#'+this.id).addClass("error_input");
						$('#error_'+this.id).show()
						value = false
						}
						else
						{
						$('#'+this.id).removeClass("error_input");
						$('#error_'+this.id).hide()
						value = true
						}
					});
					return value
					}
					function closure_date()
					{
					$(".control_closure_date").each(function() {
						if ($(this).val() == '')
						{
						$('#'+this.id).addClass("error_input");
						$('#error_'+this.id).show()
						value = false
						}
						else
						{
						$('#'+this.id).removeClass("error_input");
						$('#error_'+this.id).hide()
						value = true
						}
					});
					return value
					}
					function status()
					{
					$(".control_status").each(function() {
						if ($(this).val() == '')
						{
						$('#'+this.id).addClass("error_input");
						$('#error_'+this.id).show()
						value = false
						}
						else
						{
						$('#'+this.id).removeClass("error_input");
						$('#error_'+this.id).hide()
						value = true
						}
					});
					return value
					}
					}

  $(document).ready(function() {
              // create DatePicker from input HTML element


                var datepicker = $(".datepicker2").kendoDatePicker({
                	    min: new Date(),
                     format: "dd/MM/yyyy",
                    parseFormats: ["MMMM  yyyy"]
                }).data("kendoDatePicker");

                $(".datepicker2").bind("focus", function() {
                    $(this).data("kendoDatePicker").open();
                });
                $('.datepicker2').attr('readonly', true);

              $(".score_points").click(function(){
								value =$(this).data("value");
								control_id = $(this).attr("id").replace("_"+value,'')
								$("#score_" +control_id).val(value)
                $(this).parent().find(".score_points").removeClass('active')
                $(this).addClass('active')
              })
            });


	// ajax for submitting the score method
	function save_individual_score(id)
	{
			var checklist_id = $("#checklist_id_"+id).val()
			var recommendation = $("#recommendation_" +id).val()
			var recommendation_priority = $("#recommendation_priority_id_" +id).val()
			var reason = $("#reason_" +id).val()
			var recommendation_severity = $("#recommendation_severity_id_" +id).val()
			var closure_date = $("#closure_date_" +id).val()
			var recommendation_status = $("#recommendation_status_id_" +id).val()
			var recommendation_severity = $("#recommendation_severity_id_" +id).val()
			var score = $("#score_" +id).val()
			var result = score_input_check(id)
			if (result)
		{
			$.ajax({
					url: "/audits/"+audit_id+"/checklist_recommendations/update_individual_score",
					type: "POST",
					beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token',jQuery('meta[name="csrf-token"]').attr("content")); },
					data: {'checklist_recommendation[checklist_id]':  checklist_id, 'checklist_recommendation[checklist_type]': "AuditCompliance", 'checklist_recommendation[recommendation]': recommendation, 'checklist_recommendation[reason]': reason, 'checklist_recommendation[closure_date]': closure_date, 'checklist_recommendation[recommendation_priority_id]': recommendation_priority, 'checklist_recommendation[recommendation_severity_id]': recommendation_severity, 'checklist_recommendation[recommendation_status_id]': recommendation_status, 'checklist_recommendation[recommendation_completed]': true , 'checklist_recommendation[score]': score},
					}).done(function() {
			});
		}
			function score_input_check(id)
			{
					var score_recommendation = score_recommendation()
					var score_priority = score_priority()
					var score_reason = score_reason()
					var score_severity = score_severity()
					var score_closure_date = score_closure_date()
					var score_status = score_status()
					if (score_recommendation && score_priority && score_reason && score_severity && score_closure_date && score_status)
					{
					return true
					}
				else
				{
				return false
				}
				function score_recommendation()
					{
						if (recommendation == '')
						{
						$('#recommendation_'+id).addClass("error_input");
						$('#error_recommendation_'+id).show()
						return false
						}
						else
						{
						$('#recommendation_'+id).removeClass("error_input");
						$('#error_recommendation_'+id).hide()
							return true
						}
					//~ });
					return value
					}
					function score_priority()
					{
					if (recommendation_priority == '')
						{
						$('#recommendation_priority_id_'+id).addClass("error_input");
						$('#error_priority_'+id).show()
						return false
						}
						else
						{
						$('#recommendation_priority_id_'+id).removeClass("error_input");
						$('#error_priority_'+id).hide()
							return true
						}
					}
					function score_reason()
					{
					if (reason == '')
						{
						$('#reason_'+id).addClass("error_input");
						$('#error_reason_'+id).show()
						return false
						}
						else
						{
						$('#reason_'+id).removeClass("error_input");
						$('#error_reason_'+id).hide()
							return true
						}
					}
					function score_severity()
					{
					if (recommendation_severity == '')
						{
						$('#recommendation_severity_id_'+id).addClass("error_input");
						$('#error_severity_'+id).show()
						return false
						}
						else
						{
						$('#recommendation_severity_id_'+id).removeClass("error_input");
						$('#error_severity_'+id).hide()
							return true
						}
					}
					function score_closure_date()
					{
					if (closure_date == '')
						{
						$('#closure_date_'+id).addClass("error_input");
						$('#error_closure_date_'+id).show()
						return false
						}
						else
						{
						$('#closure_date_'+id).removeClass("error_input");
						$('#error_closure_date_'+id).hide()
							return true
						}
					}
					function score_status()
					{
					if (recommendation_status == '')
						{
						$('#recommendation_status_id_'+id).addClass("error_input");
						$('#error_status_'+id).show()
						return false
						}
						else
						{
						$('#recommendation_status_id_'+id).removeClass("error_input");
						$('#error_status_'+id).hide()
							return true
						}
					}
			}
	}

/* validation for auditee_response*/
function auditee_response(id)
{
var corrective = corrective_check()
var preventive = preventive_check()
var status = status_check()
var priority = priority_check()
var severity = severity_check()
if(corrective && preventive && status && priority && severity)
{
	return true;
}
else
{
	return false
}
function corrective_check()
{
corrective_value = $('#corrective_'+id).val()
if (corrective_value == '')
{
$('#corrective_'+id).addClass("error_input");
$('#error_corrective_'+id).show()
return false
}
else
{
$('#corrective_'+id).removeClass("error_input");
$('#error_corrective_'+id).hide()
return true
}
}
function preventive_check()
{
preventive_value = $('#preventive_'+id).val()
if (preventive_value == '')
{
$('#preventive_'+id).addClass("error_input");
$('#error_preventive_'+id).show()
return false
}
else
{
$('#preventive_'+id).removeClass("error_input");
$('#error_preventive_'+id).hide()
return true
}
}
function status_check()
{
status_value = $('#response_status_id_'+id).val()
if (status_value == '')
{
$('#response_status_id_'+id).addClass("error_input");
$('#error_status_'+id).show()
return false
}
else
{
$('#response_status_id_'+id).removeClass("error_input");
$('#error_status_'+id).hide()
return true
}
}
function priority_check()
{
priority_value = $('#response_priority_id_'+id).val()
if (priority_value == '')
{
$('#response_priority_id_'+id).addClass("error_input");
$('#error_priority_'+id).show()
return false
}
else
{
$('#response_priority_id_'+id).removeClass("error_input");
$('#error_priority_'+id).hide()
return true
}
}
function severity_check()
{
severity_value = $('#response_severity_id_'+id).val()
if (severity_value == '')
{
$('#response_severity_id_'+id).addClass("error_input");
$('#error_severity_'+id).show()
return false
}
else
{
$('#response_severity_id_'+id).removeClass("error_input");
$('#error_severity_'+id).hide()
return true
}
}
}

/*selection for blocking and dependent recommendation*/
function dependent_recommendation_select()
{
id = $('#cheklist_id').val()
recommendation_id = $('#dependent_recommendation_id').val()
$('#dependent_recommendation_'+id).val(recommendation_id)
 $('#myModal').modal('hide');
}
function blocking_recommendation_select()
{
id = $('#cheklist_id').val()
recommendation_id = $('#blocking_recommendation_id').val()
$('#blocking_recommendation_'+id).val(recommendation_id)
 $('#myModal1').modal('hide');
}
function recommendation(id)
{
$('#cheklist_id').val(id)
}

function audit_observation(id)
{
	var observation = observation_check()
	var remarks = remarks_check()
	if (observation && remarks )
	{
	return true
	}
	else
	{
	return false
	}
	function observation_check()
	{
		var observation_value = $('#observation_'+id).val()
		if (observation_value == '')
		{
			$('#observation_'+id).addClass("error_input");
			$('#error_observation_'+id).show()
			return false
		}
		else
		{
			$('#observation_'+id).removeClass("error_input");
			$('#error_observation_'+id).hide()
			return true
		}
	}
	function remarks_check()
	{
		var remarks_value = $('#remarks_'+id).val()
		if (remarks_value == '')
		{
			$('#remarks_'+id).addClass("error_input");
			$('#error_remarks_'+id).show()
			return false
		}
		else
		{
			$('#remarks_'+id).removeClass("error_input");
			$('#error_remarks_'+id).hide()
			return true
		}
	}

}

function check_observed(status_id)
{
	if (status_id != audit_status && observed_status && publish)
	{
		if (confirm('Still some observations are pending. Are you sure to publish this audit?')) {
			return true
		}
		else
		{
			return false
		}
	}
	else
	{
		return true
	}
	return false
}

$(function() {
    $( "#Accordion1" ).accordion();
});

  function display_selected_files(e)
{
$(e).parent().find("#selected_files").html("<h5>selected: " + $(e).val() + "</h5>");
}

function artifact_modal(id)
{
  $('#artifact_modal').modal({
    remote: "/audits/"+audit_id+"/checklist_recommendations/list_artifacts_and_comments?id=" + id
  });
}

$('body').on('hidden.bs.modal', '.modal', function () {
  $(this).removeData('bs.modal');
});

