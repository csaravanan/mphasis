	$(document ).ready(function() {
	$('#privilege_modular_id').addClass("multiselect");
	$('.multiselect').multiselect();
});

	dataSource = new kendo.data.DataSource({
		transport: {
			read: {
				url: '/admin/privileges/role_privileges?role_id='+role_id,
				dataType: 'json',
				type: 'POST'
			},
			destroy: {
				url: function (privilege) {
	         return '/admin/privileges/'+ privilege.id
	      },
				dataType: 'json',
				type: 'DELETE'
			}
		},
		schema: {
	    errors: function(response) {
	     return response.errors;
	  	},
			total: function(response) {
	      return response.data.length;
	    },
			data: "data",
			model: {
				id: "id",
				fields: {
					id: { type: "string" },
					role_name: { type: "string" },
					model_name: { type: "string" },
					action_name: {type: "string"}
				}
			}
		}
	});

	$(document).ready(function(){
		$("#grid").kendoGrid({
			dataSource: dataSource,
	    pageSize: 5,
		 	height: 300,
	    sortable: true,
			pageable: true,
		 	columns: [
		 		{ field:"role_name", title: "Role"},
		 		{ field:"model_name", title: "Modal"},
		 		{ field:"action_name", title: "Action"},
		 		{ command: ["destroy"], title: "", width: "160px" }
		 	],
		 	editable: "inline"
		});
	});

	function previlege_add(element)
	{
		var modal_id = $(element).val();
		//~ var selected_div = $($(element).closest('.previleges')).children('#previlege_modular_id');
		$('#privilege_modular_id').attr('disabled', false);
		$("#privilege_modular_id").multiselect('destroy');
		//~ $('.multiselect dropdown-toggle btn btn-default').empty();
		$('#privilege_modular_id option[value]').remove();
		$.ajax({url: "/admin/privileges/modal_previlege", type: 'post', data: {modal_id: modal_id },	success: function(data){
			if(data.actions.length > 0)
			{
				var option="";
				for (var i=0;i<data.actions.length;i++)
				{
					option=option+"<option value="+data.actions[i]["id"]+">"+data.actions[i]["model_name"]+"/"+data.actions[i]["action_name"]+"</option>";
				}
				$('#privilege_modular_id').append(option);
				//~ $('#privilege_modular_id').addClass("multiselect");
				$('.multiselect').multiselect();
				}
			}
		});
	}

	function privilege_params_check()
	{
		var action = $('#privilege_modular_id').val();
		if (action == null)
		{
			new Messi(privilege_error, {title: 'Error', titleClass: 'anim error', autoclose: 1500});
			return false;
		}
		else
		{
			return true;
		}
	}