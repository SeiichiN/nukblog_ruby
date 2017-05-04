// page_top.js
// 最初は消えてるがすぐに現れるメニューボタンと
// スクロール・トップボタン
$(function() {
  var haba, syncTimeout;
  syncTimeout = null;
  $(window).scroll(function() {
    $('#button').fadeOut('fast');
    $('#page-top').fadeOut('fast');
    if (syncTimeout === null) {
      syncTimeout = setTimeout((function() {
        var TopScroll, visible, wnHeight;
        TopScroll = $(window).scrollTop();
        $('#button').css('top', TopScroll);
        $('#button').fadeIn('slow');
        visible = $('#page-top').is(':visible');
        wnHeight = $(window).height();
        if (TopScroll > 1000) {
          if (!visible) {
            $('#page-top').css('top', TopScroll + wnHeight - 80);
            $('#page-top').fadeIn('slow');
          }
        }
        syncTimeout = null;
      }), 1500);
    }
  });
  $('#move-page-top').click(function() {
    $('html,body').animate({
      scrollTop: 0
    }, 'slow');
  });
  if ($(window).width() > 481) {
    haba = $('.list-contents').width();
    $('.title').css('width', haba - 150);
  }
});
