var selected;
var currentPage;
var mouseOut = true;

$(document).ready(function()
{
  currentPage = $("#selected");
  selected = currentPage;

  $("#menu li").bind("mouseover", function()
  {
    mouseOut = false;

    selected.removeClass("selected");

    selected = $(this);

    selected.addClass("selected");
  });

  $("#menu").bind("mouseleave", function()
  {
    mouseOut = true;
    
    setTimeout(function()
    {
      if (mouseOut)
      {
        selected.removeClass("selected");

        selected = currentPage;

        selected.addClass("selected");
      }
    }, 300);
  })
});