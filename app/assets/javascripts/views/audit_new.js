  function standard_display(getStandardVal)
  {
      if(getStandardVal == 'Compliance')
        {
          $('#standard-compliance').show();
          $('#standard-compliance  select').attr('name', 'audit[standard_id]');
          $('#standard-topic  select').attr('name', '');
          $('#standard-topic').hide();
        }
        else if(getStandardVal == 'NonCompliance')
        {
          $('#standard-topic').show();
          $('#standard-topic  select').attr('name', 'audit[standard_id]');
          $('#standard-compliance  select').attr('name', '');
          $('#standard-compliance').hide();
        }
        else if(getStandardVal=='')
        {
          $('#standard-compliance').hide();
          $('#standard-topic').hide();
        }
  }

 $(document).ready(function(){
    standard_display($("#audit_compliance_type").val());
    $("#audit_compliance_type").change(function () {
      $('#standard-compliance  select').attr('name', '');
      $('#standard-topic  select').attr('name', '');
      standard_display(this.value)
    });

    function startChange() {
      var startDate = start.value();

      if (startDate) {
          startDate = new Date(startDate);
          startDate.setDate(startDate.getDate() + 1);
          end.min(startDate);
      }
  }

  function endChange() {
      var endDate = end.value();

      if (endDate) {
          endDate = new Date(endDate);
          endDate.setDate(endDate.getDate() - 1);
          start.max(endDate);
      }
  }

    var start = $(".datepicker").kendoDatePicker({
      change: startChange,
      min: new Date(),
      format: "dd/MM/yyyy"
  }).data("kendoDatePicker");

  var end = jQuery(".datepicker1").kendoDatePicker({
      change: endChange,
      format: "dd/MM/yyyy"
  }).data("kendoDatePicker");

  start.max(end.value());
  end.min(start.value());

    $(".datepicker").bind("focus", function() {
      $(this).data("kendoDatePicker").open();
    });
    $('.datepicker').attr('readonly', true);

    $(".datepicker1").bind("focus", function() {
      $(this).data("kendoDatePicker").open();
    });
    $('.datepicker1').attr('readonly', true);


    // $('#add_auditee').click(function(){
    //   var size = $('#auditee-list').find('.auditee-rows').size();

    //   // console.log(cd append)
    //   $("#auditee-list").append(""+"<div class='form-group clearfix auditee-dropdown'>"+$(".auditee-dropdown").html().replace('audit[audit_auditees_attributes][0][user_id]','audit[audit_auditees_attributes]['+size+'][user_id]')+"</div>"+"");
    // });

    $(".next-phase").click(function(){
      // new Messi('Planned for further phases.', {autoclose: '5000'});
      new Messi('Planned for further phases.', {title: 'Warning', titleClass: 'warning', autoclose: 2000});
    });
  });

	 function get_departments(element){
    $('.ajax-loader').show();
    var location_id = $(element).val();
    if(location_id.length>0){
      $.ajax({
        url: "/audits/department_teams_users",
        type: "GET",
        data: {"location_id" : location_id}
      });
    }
    else{
      $('#department-dropdown').hide();
      $('#teams-dropdown').hide();
    }
  }

  function get_teams(element){
    $('.ajax-loader-department').show();
    var department_id = $(element).val();
    if(department_id.length>0){
      $.ajax({
        url: "/audits/department_teams_users",
        type: "GET",
        data: {"department_id" : department_id}
      });
    }
    else {
      $('#teams-dropdown').hide();
    }
  }

  function get_auditee_users(element){
    $('.ajax-loader-team').show();
    var team_id = $(element).val();
    if(team_id.length>0){
      $.ajax({
        url: "/audits/department_teams_users",
        type: "GET",
        data: {"team_id" : team_id}
      });
    }
    else {
      $('#teams-dropdown').hide();
    }
  }