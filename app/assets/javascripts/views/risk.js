$(document).ready(function() {
	// Fancybox
	$(".fancybox").fancybox();

	// Kendo Datapicker
	$("#datepicker").kendoDatePicker();

	// Kendo Tab
	$("#tabstrip").kendoTabStrip({
		animation:  {
			open: {
				effects: "fadeIn"
			}
		}
	});

	// Kendo Panel
	$("#panelbar").kendoPanelBar();

	if ( stage.length > 0 )
	{
		var	risks_url = "/risks?stage="+stage;
	}
	else
	{
		var risks_url = "/risks"
	}

	dataSource = new kendo.data.DataSource({
		transport: {
			read: {
				url: risks_url,
				dataType: 'json',
				type: 'get'
			},
		},
		schema: {
			errors: function(response) {
			return response.errors;
		},
		data: "data",
		model: {
			id: "id",
				fields: {
					subject: { type: "string" },
					status: { type: "string" },
					risk: {type: "string"},
					owner: {type: "string"},
					days_open: {type: "string"}
				}
			}
		},
	});

	// Kendo Grid
	$("#grid").kendoGrid({
		dataSource: dataSource,
		dataBound: function(){
			updateGridForStage(stage)
			riskGridTitle()
		},
		height: 'auto',
		scrollable: true,
		sortable: true,
		filterable: true,
		pageable: false,
		columns: [
			{ field: "subject", title: "Subject", width: "40%" },
			{ field: "status", title: "Status", width: "30%" },
			{ field: "risk", title: "Risk", width: "8%" },
			{ field: "owner", title: "Owner", width: "20%" },
			{ field: "days_open", title: "Days Open", width: "13%" },
			{ field: "next_review", title: "Next Review Date", width: "20%" },
			{ command: [{text: "list", click: mitigate_file},{text: "miti", click: review_file},{text: "edit", click: edit_file}], title: "Action", width: "170px" }
		],
	//~ editable: "popup"
	});

	function modify(){
		$('.editable-input').val($('.editable-select').val());
		output();
	}

	function output(){
		$('.editable-result').text('value: ' + $('.editable-input').val());
	}

	function edit_file(e)
	{
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		window.location.href = "/risks/"+ dataItem.id + "/edit"
	}

	function mitigate_file(e)
	{
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		window.location.href = "/risks/"+ dataItem.id + "/mitigations/new"
	}

	function review_file(e)
	{
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		window.location.href = "/risks/"+ dataItem.id + "/mgmt_reviews/new"
	}

	function select_stage_class(stage_class)
	{
		if(stage_class == 'mitigate')
	  {
	    return "k-grid-list";
	  }
	  else if(stage_class == 'review')
	  {
	   	return "k-grid-miti, .k-grid-list";
	  }
	}

	function updateGridForStage(stage)
	{
		if(stage.length == 0)
		{
			status_update_all()
		}
		else
		{
			var selected_stage = select_stage_class(stage)
			$('.'+selected_stage).addClass('active');
		}
	}

	function status_update_all()
	{
		var grid = $("#grid").data("kendoGrid");
		addGridAtiveClass(grid)
  }

  function addGridAtiveClass(grid)
  {
	  var gridData = grid.dataSource.view();
	  for (var i = 0; i < gridData.length; i++) {
	    var currentUid = gridData[i].uid;
	    var currenRow = grid.table.find("tr[data-uid='" + currentUid + "']");
	    currenStatus = gridData[i].status
	    if (currenStatus == "Mitigated")
	    {
	    	var test_row = $(currenRow).find(".k-grid-list")
	    	$(test_row).addClass('active')
	    }
	    else if (currenStatus == "Reviewed" || currenStatus == "Rejected")
	    {
	    	var test_row = $(currenRow).find(".k-grid-list, .k-grid-miti")
	    	$(test_row).addClass('active')
	  	}
	  }
	}

	$('.editable-input').on('click', function(){
		$(this).select()
			}).on('blur', function(){
		output();
	})

	modify();

	// More contacts show
	$(".more-link").click(function(){
		if($(this).html() == "More")
			$(this).html("Less").parent().siblings(".more-info").show();
		else
			$(this).html("More").parent().siblings(".more-info").hide();
	});

	function riskGridTitle()
	{
		$('.k-grid-file').attr('title','File');
		$('.k-grid-list').attr('title','Mitigate');
		$('.k-grid-miti').attr('title','review');
		$('.k-grid-edit').attr('title','Edit');
	}

	function onActivate(e) {
	if($('#search-value').val() != "")
	{
		$('#search-value').val('')
		$("#grid").data("kendoGrid").dataSource.filter({});
		}
	}

	$("#tabstrip").kendoTabStrip({
		activate: onActivate
	});

	$("#search-button").click(function(){
		search_result();
	})

	$("#search-value").on('keyup', function(e) {
		if (e.which == 13) {
			e.preventDefault();
			search_result()
		}
	});

	function search_result()
	{
		var tabstrip = $("#tabstrip").kendoTabStrip().data("kendoTabStrip");
		var val = $('#search-value').val();
		$("#grid").data("kendoGrid").dataSource.filter({
			logic  : "or",
			filters: [
			{
				field: "subject",
				operator: "contains",
				value   : val
			},
			{
				field: "status",
				operator: "contains",
				value   : val
			},
			{
				field: "risk",
				operator: "contains",
				value   : val
			},
			{
				field: "owner",
				operator: "contains",
				value   : val
			},
			{
				field: "days_open",
				operator: "contains",
				value   : val
			},
			]
		});
	}

});