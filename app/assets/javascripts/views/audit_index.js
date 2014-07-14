// Kendo Tab
	$("#tabstrip").kendoTabStrip({
		animation:  {
			open: {
				effects: "fadeIn"
			}
		}
	});

 $(document).ready(function(){

	function onActivate(e) {
     if($('#search-value').val() != "")
     {
      $('#search-value').val('')
      var tabActive = e.sender.tabGroup.children("li.k-state-active").attr("aria-controls")
      var gridForSearch = select_grid(tabActive)
      $("#"+gridForSearch).data("kendoGrid").dataSource.filter({});
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
		var tabActive = tabstrip.tabGroup.children("li.k-state-active").attr("aria-controls")
		var val = $('#search-value').val();
    var gridForSearch = select_grid(tabActive)
    $("#"+gridForSearch).data("kendoGrid").dataSource.filter({
			logic  : "or",
			filters: [
				{
					field: "title",
					operator: "contains",
					value   : val
				},
				{
					field: "client",
					operator: "contains",
					value   : val
				},
				{
					field: "audit_type",
					operator: "contains",
					value   : val
				},
				{
					field: "compliance_type",
					operator: "contains",
					value   : val
				},
				{
					field: "auditor",
					operator: "contains",
					value   : val
				},
			]
		});
	}

	function select_grid(tabActive)
		{
			if(tabActive == 'tabstrip-1')
		  {
		    return "gridforall";
		  }
		  else if(tabActive == 'tabstrip-2')
		  {
		   	return "gridforplan";
		  }
		  else if(tabActive=='tabstrip-3')
		  {
		    return "gridforprogress";
		  }
		  else if(tabActive=='tabstrip-4')
		  {
		    return "gridforpublish";
		  }
		}


});

// Function for Grid button
	function set_file(e)
	{
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		if ( dataItem.compliance_type == "Compliance")
		{
			window.location.href = "/audits/"+dataItem.id+"-"+dataItem.title+"/audit_compliances"
		}
		else
		{
			window.location.href = "/audits/"+dataItem.id+"-"+dataItem.title+"/nc_questions/new"
		}
	}

	function check_file(e)
	{
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		window.location.href = "/audits/"+dataItem.id+"-"+dataItem.title+"/checklist_recommendations/new"
	}

	function act_file(e)
	{
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		window.location.href = "/audits/"+dataItem.id+"-"+dataItem.title+"/checklist_recommendations/auditee_response"
	}

	function publish_file(e)
	{
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		window.location.href = "/audits/"+dataItem.id+"-"+dataItem.title+"/checklist_recommendations/audit_observation"
	}

	function edit_file(e)
	{
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		window.location.href = "/audits/"+ dataItem.id + "/edit"
	}

	function graph_file(e)
	{
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		window.location.href = "/audits/"+dataItem.id+"-"+dataItem.title+"/audit_dashboard"
	}

	function pdf_file(e)
	{
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		window.location.href = "/audits/"+ dataItem.id +".pdf"
	}

	function select_stage_class(stage_class)
		{
			if(stage_class == 'do')
		  {
		    return "k-grid-Set";
		  }
		  else if(stage_class == 'check')
		  {
		   	return "k-grid-tick";
		  }
		  else if(stage_class == 'act')
		  {
		    return "k-grid-tick1";
		  }
		  else if(stage_class == 'published')
		  {
		    return "k-grid-book";
		  }
		}


	function status_update_all()
	{
		var grid = $("#gridforall").data("kendoGrid");
		addGridAtiveClass(grid)
    gridTitle()
  }

  function status_update_plan()
	{
		var grid = $("#gridforplan").data("kendoGrid");
		addGridAtiveClass(grid)
    gridTitle()
  }

  function status_update_progress()
	{
		var grid = $("#gridforprogress").data("kendoGrid");
		addGridAtiveClass(grid)
    gridTitle()
  }

  function status_update_publish()
	{
		var grid = $("#gridforpublish").data("kendoGrid");
		addGridAtiveClass(grid)
    gridTitle()
  }

  function addGridAtiveClass(grid)
  {
	  var gridData = grid.dataSource.view();
	  for (var i = 0; i < gridData.length; i++) {
	    var currentUid = gridData[i].uid;
	    var currenRow = grid.table.find("tr[data-uid='" + currentUid + "']");
	    currenStatus = gridData[i].audit_status
	    if (currenStatus == "Initiated")
	    {
	    	var test_row = $(currenRow).find(".k-grid-Set")
	    	$(test_row).addClass('active')
	    }
	    else if (currenStatus == "In Progress")
	    {
	    	var test_row = $(currenRow).find(".k-grid-Set, .k-grid-tick, .k-grid-tick1")
	    	$(test_row).addClass('active')
	  	}
	  	else if (currenStatus == "Published")
	  	{
	  		var test_row = $(currenRow).find(".k-grid-Set, .k-grid-tick, .k-grid-tick1, .k-grid-book")
	  		$(test_row).addClass('active')
	  	}
	  	else if (currenStatus == "Planning")
	    {
	    	var test_row = $(currenRow).find(".k-grid-Set, .k-grid-tick, .k-grid-tick1, .k-grid-book, .k-grid-graph")
	    	$(test_row).hide()
	    }
	  }
	}

  function gridTitle()
  {
  	$('.k-grid-Set').attr('title','Do');
    $('.k-grid-tick').attr('title','Check');
    $('.k-grid-tick1').attr('title','Act');
    $('.k-grid-book').attr('title','Publish');
    $('.k-grid-pdf').attr('title','PDF');
    $('.k-grid-edit').attr('title','Edit');
    $('.k-grid-graph').attr('title','Dashboard');
  }

	$(document).ready(function(){

	Top_postion = $(window).scrollTop();

	$( ".user_login" ).mouseenter(function() {
		$(this).addClass("active");
		$(".account_header_dropdown").slideDown(100);
	})
	.mouseleave(function() {
		$(this).removeClass("active");
		$(".account_header_dropdown").hide();
	});

		if ( stage.length > 0 )
		{
			var	audits_url = "/audits/audit_all?stage="+stage;
		}
		else
		{
			var audits_url = "/audits/audit_all"
		}
		// Data source for all
		dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: audits_url,
					type: "post",
					dataType: 'json'
				}
			},
			schema: {
				errors: function(response) {
				return response.errors;
			},
			data: "data",
				total: function(response) {
			    return response.data.length;
			  },
				model: {
					id: "id",
					fields:{
						id: { type: "string" },
						title: { type: "string" },
						client: { type: "string" },
						audit_type: { type: "string" },
						compliance_type: { type: "string" },
						auditor: {type: "string"},
						audit_status: {type: "string"}
					}
				}
			}
		});

		// Kendo Grid for all
		$("#gridforstage").kendoGrid({
			dataSource: dataSource,
				dataBound: function(){
					var selected_stage = select_stage_class(stage)
					$('.'+selected_stage).addClass('active');
					gridTitle()
			},
			height: 'auto',
			scrollable: true,
			sortable: true,
			filterable: true,
			pageable: {
				input: true,
				numeric: false
			},
			columns: [
				{ field: "title", title: "Audit Title" ,width: "35%"},
				{ field: "client", title: "Client Name", width: "35%" },
				{ field: "audit_type", title: "Audit Type", width: "35%" },
				{ field: "compliance_type", title: "Compliance Type", width: "35%" },
				{ field: "auditor", title: "Auditor Name", width: "35%" },

				{command: [{text: "Set", click: set_file},{text: "tick", click: check_file},{text: "tick1", click: act_file},{text: "book", click: publish_file},{text: "pdf", click: pdf_file},{text: "edit", click: edit_file}, {text: "graph", click: graph_file}], title: "Actions", width: "216px" }
			],
		});


		// Kendo Grid for all
		$("#gridforall").kendoGrid({
			dataSource: dataSource,
				dataBound: function(){
					status_update_all()
				},
			height: 'auto',
			scrollable: true,
			sortable: true,
			filterable: true,
			pageable: {
				input: true,
				numeric: false
			},
			columns: [
				{ field: "title", title: "Audit Title" ,width: "35%"},
				{ field: "client", title: "Client Name", width: "35%" },
				{ field: "audit_type", title: "Audit Type", width: "35%" },
				{ field: "compliance_type", title: "Compliance Type", width: "35%" },
				{ field: "auditor", title: "Auditor Name", width: "35%" },

				{command: [{text: "Set", click: set_file},{text: "tick", click: check_file},{text: "tick1", click: act_file},{text: "book", click: publish_file},{text: "pdf", click: pdf_file},{text: "edit", click: edit_file},{text: "graph", click: graph_file}], title: "Actions", width: "216px" }
			],
		});

   // Datasource for plan
		dataSourceplan = new kendo.data.DataSource({
			transport: {
				read: {
					url: "/audits/audit_with_status?audit_status_id=1",
					type: "post",
					dataType: 'json'
				}
			},
			schema: {
				errors: function(response) {
				return response.errors;
			},
			data: "data",
			total: function(response) {
		    return response.data.length;
		  },
			model: {
				id: "id",
				fields: {
					id: { type: "string" },
					title: { type: "string" },
					client: { type: "string" },
					audit_type: { type: "string" },
					compliance_type: { type: "string" },
					auditor: {type: "string"}
					}
				}
			}
		});

		//grid for planned
		$("#gridforplan").kendoGrid({
			dataSource: dataSourceplan,
			dataBound: function(){
				status_update_plan()
			},
			height: 'auto',
			scrollable: true,
			sortable: true,
			filterable: true,
			pageable: {
				input: true,
				numeric: false
			},
			columns: [
				{ field: "title", title: "Audit Title" ,width: "35%"},
				{ field: "client", title: "Client Name", width: "35%" },
				{ field: "audit_type", title: "Audit Type", width: "35%" },
				{ field: "compliance_type", title: "Compliance Type", width: "35%" },
				{ field: "auditor", title: "Auditor Name", width: "35%" },

        {command: [{text: "Set", click: set_file},{text: "tick", click: check_file},{text: "tick1", click: act_file},{text: "book", click: publish_file},{text: "pdf", click: pdf_file},{text: "edit", click: edit_file}, {text: "graph", click: graph_file} ], title: "Actions", width: "216px" }			],
		});


   // Datasource for progress
		dataSourceprogress = new kendo.data.DataSource({
			transport: {
				read: {
					url: "/audits/audit_with_status?audit_status_id=3",
					type: "post",
					dataType: 'json'
				}
			},
			schema: {
				errors: function(response) {
				return response.errors;
			},
			data: "data",
			total: function(response) {
		    return response.data.length;
		  },
			model: {
				id: "id",
				fields: {
					id: { type: "string" },
					title: { type: "string" },
					client: { type: "string" },
					audit_type: { type: "string" },
					compliance_type: { type: "string" },
					auditor: {type: "string"}
					}
				}
			}
		});


		//grid for InProgress
		$("#gridforprogress").kendoGrid({
			dataSource: dataSourceprogress,
			dataBound: function(){
				status_update_progress()
			},
			height: 'auto',
			scrollable: true,
			sortable: true,
			filterable: true,
			pageable: {
				input: true,
				numeric: false
			},
			columns: [
				{ field: "title", title: "Audit Title" ,width: "35%"},
				{ field: "client", title: "Client Name", width: "35%" },
				{ field: "audit_type", title: "Audit Type", width: "35%" },
				{ field: "compliance_type", title: "Compliance Type", width: "35%" },
				{ field: "auditor", title: "Auditor Name", width: "35%" },

        {command: [{text: "Set", click: set_file},{text: "tick", click: check_file},{text: "tick1", click: act_file},{text: "book", click: publish_file},{text: "pdf", click: pdf_file},{text: "edit", click: edit_file}, {text: "graph", click: graph_file}], title: "Actions", width: "216px" }			],
		});


    // Datasource for publish
		dataSourcepublish = new kendo.data.DataSource({
			transport: {
				read: {
					url: "/audits/audit_with_status?audit_status_id=4",
					type: "post",
					dataType: 'json'
				}
			},
			schema: {
				errors: function(response) {
				return response.errors;
			},
			data: "data",
				total: function(response) {
			    return response.data.length;
			  },
				model: {
				id: "id",
				fields: {
					id: { type: "string" },
					title: { type: "string" },
					client: { type: "string" },
					audit_type: { type: "string" },
					compliance_type: { type: "string" },
					auditor: {type: "string"}
					}
				}
			}
		});

		//grid for published
		$("#gridforpublish").kendoGrid({
			dataSource: dataSourcepublish,
			dataBound: function(){
				status_update_publish()
			},
			height: 'auto',
			scrollable: true,
			sortable: true,
			filterable: true,
			pageable: {
				input: true,
				numeric: false
			},
			columns: [
				{ field: "title", title: "Audit Title" ,width: "35%"},
				{ field: "client", title: "Client Name", width: "35%" },
				{ field: "audit_type", title: "Audit Type", width: "35%" },
				{ field: "compliance_type", title: "Compliance Type", width: "35%" },
				{ field: "auditor", title: "Auditor Name", width: "35%" },

        {command: [{text: "Set", click: set_file},{text: "tick", click: check_file},{text: "tick1", click: act_file},{text: "book", click: publish_file},{text: "pdf", click: pdf_file},{text: "edit", click: edit_file}, {text: "graph", click: graph_file}], title: "Actions", width: "216px" }			],
		});

	});
