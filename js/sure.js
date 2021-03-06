// sure.js -- 確認のためのウィンドウ・ボックスを表示する

// 確認処理
function disp(id){
    // 「OK」時の処理開始 ＋ 確認ダイアログの表示
    if (window.confirm('本当にいいんですね？')) {
        location.href = "delete.rb?id=" + id;
    } else {
        // window.alert('キャンセルしました');
        location.href = "list.rb";
    }
}

// 参考
// http://www.tagindex.com/javascript/window/confirm.html
