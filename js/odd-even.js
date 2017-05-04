var list = document.getElementsByClassName('list-cell');
for (var i = 0; i < list.length; i++) {
    if ((i+1) % 2 == 0) {
        list.item(i).classList.add('list-line-even');
    } else {
        list.item(i).classList.add('lis-line-odd');
    }
}
