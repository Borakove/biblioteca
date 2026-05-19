<?php

include __DIR__ . "/../dao/ReservaDAO.php";

header("Content-type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dao = new ReservaDAO();
$acao = $_GET["acao"] ?? "";

switch ($acao) {

    case "listar":
        $reservas = $dao->listar();
        echo json_encode($reservas);
        break;

    case "listarPorUsuario":
        $usuario_id = $_GET["usuario_id"];
        $reservas = $dao->listarPorUsuario($usuario_id);
        echo json_encode($reservas);
        break;

    case "inserir":
        $usuario_id = $_GET["usuario_id"];
        $livro_id   = $_GET["livro_id"];
        $dao->inserir($usuario_id, $livro_id);
        echo json_encode(["mensagem" => "Reserva realizada com sucesso!"]);
        break;

    case "atualizarStatus":
        $id     = $_GET["id"];
        $status = $_GET["status"];
        $dao->atualizarStatus($id, $status);
        echo json_encode(["mensagem" => "Status da reserva atualizado!"]);
        break;

    default:
        http_response_code(400);
        echo json_encode(["erro" => "Acao invalida."]);
        break;
}