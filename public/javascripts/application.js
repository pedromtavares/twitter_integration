$(document).ready(function() {

	$('#twitter').NobleCount('#count',{
		on_negative: 'go_red',
		on_positive: 'go_green',
		on_update: function(t_obj, char_area, c_settings, char_rem){
				if (char_rem < 0)
					$('input[type=submit]').attr('disabled', 'disabled');
				else
					$('input[type=submit]').removeAttr('disabled');
		},
		max_chars: 140,
		block_negative: true
	});

});