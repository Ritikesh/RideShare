// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require jquery.datetimepicker
//= require gmaps
//= require_tree .

$(function(){ $(document).foundation(); });

$(document).ready(function() {
	$(".pageload-con").fadeOut(1500);

	$('.datetimepicker').datetimepicker({
		format:'d-m-Y H:i',
		step: 15
	});

	$('.ride-delete').bind('ajax:beforeSend', function() {
		$(".otherload-con").show();
	});

	$('.ride-delete').bind('ajax:complete', function(data) {
		if($(".disabled-ride").length)
			$(this).parent(".panel").remove().insertBefore(".disabled-ride:first");
		else
			$(this).parent(".panel").remove().insertAfter(".panel:last");
		$(this).parent(".panel").addClass("disabled-ride");
		$(this).siblings("a.edit").remove();
		$("<i class='fi-trash right margin-right'></i>").insertAfter(this);
		$(".otherload-con").fadeOut(1000);
		$(this).remove();
	});

	$(document).on("page:change", function() {
		$(".pageload-con").show();
		$(".pageload-con").fadeOut(1500);
	});
});