<?php
    header("Content-type: application/json; charset=utf-8");
    // 配置文件需要上传到服务器的路径，需要允许所有用户有可写权限，否则无法上传！
    $uploaddir = 'images/';
    // file表单名称，应与客户端一致
    $uploadfile = $uploaddir . basename($_FILES['file']['name']);
    
    move_uploaded_file($_FILES['file']['tmp_name'], $uploadfile);
    
    echo json_encode($_FILES);
?>