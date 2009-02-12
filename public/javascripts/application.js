$().ready(function() {
  $("#message_recipients").autocomplete("/recipients.txt", {selectFirst: true, multiple: true, multipleSeparator: ", "});
  $("#contact_number").autocomplete("/telephone_numbers.txt", {selectFirst: true});
  $(".pagination a").click(function() {
    $("#messages").load($(this).attr("href"));
      return false;
    });
});
