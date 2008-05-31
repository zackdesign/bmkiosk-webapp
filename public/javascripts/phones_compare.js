function change_offset(delta, form_action)
{
	var offset_obj = document.getElementById('offset');
	if (!offset_obj)
	{
		return false;
	}

	var offset = parseInt(offset_obj.value);
	offset = offset + delta;
	offset_obj.value = offset;

	document.getElementById('compare_form').action = form_action;
	document.getElementById('compare_form').submit();
}

function compare_submit(form_action)
{
	var ids_obj = document.getElementById('compare_ids');
	if (!ids_obj)
	{
		return false;
	}

	var ids_str = ids_obj.value;
	var ids = Array();

	if (ids_str.length != 0)
	{
		ids = ids_obj.value.split(',');
	}

	if (ids.length < 2)
	{
		alert('Select either 2 or 3 phones for comparison.');
		return false;
	}

	document.getElementById('compare_form').action = form_action;
	document.getElementById('compare_form').submit();
}

function set_compare(pid, chkbx)
{
	if (!chkbx)
	{
		return;
	}

	var result = false;
	if (chkbx.checked)
	{
		result = add_compare(pid);
	}
	else
	{
		result = remove_compare(pid);
	}

	return result;
}

function add_compare(pid)
{
	var ids_obj = document.getElementById('compare_ids');
	if (!ids_obj)
	{
		return false;
	}

	var ids_str = ids_obj.value;
	var ids = Array();

	if (ids_str.length != 0)
	{
		ids = ids_obj.value.split(',');
	}

	if (ids.length > 2)
	{
		alert('Comparison limit is 3 phones at any one time. Deselect a phone before trying to add this phone.');
		return false;
	}

	ids[ids.length] = pid;
	ids_obj.value = ids.join(',');

	return true;
}

function remove_compare(pid)
{
	var ids_obj = document.getElementById('compare_ids');
	if (!ids_obj)
	{
		return false;
	}

	var ids = ids_obj.value.split(',');
	var new_ids = Array();

	while (ids.length > 0)
	{
		var current_pid = ids.shift();
		if (current_pid != pid)
		{
			new_ids[new_ids.length] = current_pid;
		}
	}

	ids_obj.value = new_ids.join(',');

	return true;
}