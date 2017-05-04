// slide_menu.js
// スライド・メニュー
//[jQuery] プラグインを使わずに横からスライドインするメニューを簡単に作る
// https://memocarilog.info/jquery/7551
// 講習メモ(stmemo)にスライドインメニューを導入する（My開発メモ）
// http://192.168.0.14:3000/entries/148

$(function() {
  var body, menu, menuBtn, menuWidth;
  menu = $('#slide_menu');
  menuBtn = $('#button');
  body = $(document.body);
  menuWidth = menu.outerWidth();
  menuBtn.on('click', function() {
    body.toggleClass('open');
    if (body.hasClass('open')) {
      body.animate({
        'left': menuWidth
      }, 300);
      menu.animate({
        'left': 0
      }, 300);
    } else {
      menu.animate({
        'left': -menuWidth
      }, 300);
      body.animate({
        'left': 0
      }, 300);
    }
  });
});
