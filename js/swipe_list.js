// swipe_list.js
// スワイプリスト

$(function() {
  $('.js-swipeList').swipeList();
  $('.js-swipeList2').swipeList({
    direction: 'right'
  });
  $('.js-swipeList3').swipeList({
    speed: 1000
  });
  $('.js-swipeList4').swipeList({
    easing: 'ease-in'
  });
});
