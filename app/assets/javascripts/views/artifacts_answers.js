function attachment_check()
{
var file = $('#file_tag').val()
if (file == '')
{
	$('#error_file').show()
	return false
}
else
{
	$('#error_file').hide()
	return true
}
}