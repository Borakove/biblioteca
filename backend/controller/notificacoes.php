<?php

include __DIR__ . "/../dao/NotificacaoDAO.php";

header("Content-type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dao = new NotificacaoDAO();
$acao = $_GET["acao"] ?? "";

switch ($acao) {

    case "listarPorUsuario":
        $usuario_id = $_GET["usuario_id"];
        $notificacoes = $dao->listarPorUsuario($usuario_id);
        echo json_encode($notificacoes);
        break;

    case "inserir":
        $usuario_id = $_GET["usuario_id"];
        $mensagem   = $_GET["mensagem"];
        $dao->inserir($usuario_id, $mensagem);
        echo json_encode(["mensagem" => "Notificacao enviada!"]);
        break;

    case "marcarLida":
        $id = $_GET["id"];
        $dao->marcarLida($id);
        echo json_encode(["mensagem" => "Notificacao marcada como lida."]);
        break;

    default:
        http_response_code(400);
        echo json_encode(["erro" => "Acao invalida."]);
        break;
}