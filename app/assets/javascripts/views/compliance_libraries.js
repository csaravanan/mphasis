window.onload = function()
{
dataSource = new kendo.data.DataSource({
		transport: {
			read: {
				url: '/admin/compliance_libraries/compliance_domains',
				type: "post",
				dataType: 'json'
			},
			destroy: {
				url: function (compliance_library) {
            		return '/admin/compliance_libraries/'+ compliance_library.id
        		},
				dataType: 'json',
				type: 'DELETE'
			}
		},
		schema: {
	        errors: function(response) {
	         return response.errors;
	      	},
			data: "data",
			model: {
				id: "id",
				fields: {
					id: { type: "string" },
					compliance_id: { type: "string" },
					name: { type: "string" },
					is_leaf: {type: "boolean"},
					parent_id: {type: "integer"},
					action_name: {type: "string"}
				}
			}
		}
	});

var element = $("#grid").kendoGrid({
		dataSource: dataSource,
		editable: "inline",
    height    : 450,
    sortable  : true,
    pageable  : true,
    detailInit: detailInit,
    columns   : [
	 		{ field:"name", title: "name"},
	 		//~ { field:"is_leaf", title: "is_leaf"},
			{field: "Add",template:"<a href='/admin/compliance_libraries/new?compliance_library_id=${id}'>Add Next</a>"},
			{field: "Edit",template:"<a href='/admin/compliance_libraries/${id}/edit'>Edit</a>"},
			{ command: ["destroy"], title: "", width: "160px" }
			]
});

function detailInit(e) {
						$("<div/>").appendTo(e.detailCell).kendoGrid({
						dataSource: {
											transport: {
															read: {
																	url: '/admin/compliance_libraries/compliance_control_objectives?id='+ e.data.id,
																	type: "post",
																	dataType: 'json'
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
																		id: { type: "string" },
																		compliance_id: { type: "string" },
																		name: { type: "string" },
																		is_leaf: {type: "boolean"},
																		parent_id: {type: "integer"},
																		action_name: {type: "string"}
																	}
															}
											}
										 },
						scrollable: false,
						sortable  : true,
						pageable  : true,
						detailInit: childInit,
						columns   : [
								{ field:"name", title: "name"},
								{field: "Add",template:"<a href='/admin/compliance_libraries/new?control_objective_id=${id}'>Add Next control</a>"},
								{field: "Edit",template:"<a href='/admin/compliance_libraries/${id}/edit'>Edit</a>"},
								{command: [{ name:"Destroy parent",text: "Destroy",click: delete_compliane_parent }]}
						]
				});
}

function childInit(e) {
		console.log(e.data.id);
			var control_objectives = [];
						$("<div/>").appendTo(e.detailCell).kendoGrid({
							dataSource: {
											transport: {
															read: {
																	url: '/admin/compliance_libraries/compliance_controls?id='+ e.data.id,
																	type: "post",
																	dataType: 'json'
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
																		id: { type: "string" },
																		compliance_id: { type: "string" },
																		name: { type: "string" },
																		is_leaf: {type: "boolean"},
																		parent_id: {type: "integer"},
																		action_name: {type: "string"}
																	}
																	}
															}
										 },
						scrollable: false,
						sortable  : true,
						pageable  : true,
						columns   : [
								{ field:"name", title: "name"},
								{field: "Edit",template:"<a href='/admin/compliance_libraries/${id}/edit'>Edit</a>"},
								{command: [{ name:"Destroy child",text: "Destroy",click: delete_compliane }]}
						]
				});
}
  function delete_compliane(e) {
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		if (confirm('Are you sure you want to delete this record ?')) {
				$.ajax({
				url: "/admin/compliance_libraries/"+dataItem.id,
				type: 'delete',
				dataType: 'json',
				success:function(result){
				}
				});
			}
			$('#grid').data('kendoGrid').dataSource.read();
			$('#grid').data('kendoGrid').refresh();
 }

function delete_compliane_parent(e) {
		var dataItem = this.dataItem(jQuery(e.currentTarget).closest("tr"));
		if (confirm('Are you sure you want to delete this record ?')) {
				$.ajax({
				url: "/admin/compliance_libraries/"+dataItem.id,
				type: 'delete',
				dataType: 'json',
				success:function(result){
				}
				});
			}
			$('#grid').data('kendoGrid').dataSource.read();
			$('#grid').data('kendoGrid').refresh();
 }
 }