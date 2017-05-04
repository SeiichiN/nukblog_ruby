// file_upload.js
// ファイルのアップロードで保存前の画像を表示・ファイル名も表示する

function handleFileSelect(evt){
	var files = evt.target.files;  // FileList object

	// Loop through the FileList and render image files as thumbnails.
	var f = files[0];

	// only process image files.
	if (!f.type.match('image.*')){
		return; // 以降の処理はせずに、次の繰り返し処理にすすむ
	}

	var reader = new FileReader();

	// Closure to capture the file information.
	reader.onload = (function(theFile){
		return function(e){
			document.getElementById('outputList').setAttribute("src", e.target.result);
			console.log("target : " + e.target.result);
		};
	})(f);

	// Read in the image file as a data URL.
	reader.readAsDataURL(f);

	document.getElementById('gazo_file').setAttribute("value", escape(f.name));
	document.getElementById('file_size').innerHTML = "<small>size: " + parseInt(f.size / 1000) + "k</small>";

}
document.getElementById('gazo_data').addEventListener('change', handleFileSelect, false);


