//JSP 의 id로 파일 입력칸과 이미지를 찾는다

const fileInput = document.getElementById('product-image-file');
const previewImage = document.getElementById('product-image-preview');
let previewUrl;

// 사진 선택이 바뀔 떄마다 미리 보기를 새로 표시한다.
fileInput.addEventListener('change', function () {
    if (previewUrl) {
        //이전 사진의 일시 주소를 해체 한다.
        URL.revokeObjectURL(previewUrl);
        previewUrl = null;
    }
    // 새로 선택한 사진이 없으면 이전 미리보기를 숨긴다.
    previewImage.removeAttribute('src');
    previewImage.hidden = true;
    // 파일 선택 칸에서  첫 번쨰 사진을 가져온다.
    const file = fileInput.files[0];
    if (file) {
        // 브라우저에서 사진을 바로 보여줄 수 있는 임시 주소를 만든다.
        previewUrl = URL.createObjectURL(file);
        previewImage.src = previewUrl;
        previewImage.hidden = false;
    }
})