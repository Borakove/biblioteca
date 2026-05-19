<?php

include __DIR__ . "/../dao/EmprestimoDAO.php";

header("Content-type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dao = new EmprestimoDAO();
$acao = $_GET["acao"] ?? "";

switch ($acao) {

    case "listar":
        $emprestimos = $dao->listar();
        echo json_encode($emprestimos);
        break;

    case "listarPorUsuario":
        $usuario_id = $_GET["usuario_id"];
        $emprestimos = $dao->listarPorUsuario($usuario_id);
        echo json_encode($emprestimos);
        break;

    case "inserir":
        $usuario_id    = $_GET["usuario_id"];
        $livro_id      = $_GET["livro_id"];
        $data_devolucao = $_GET["data_devolucao"];
        $dao->inserir($usuario_id, $livro_id, $data_devolucao);
        echo json_encode(["mensagem" => "Emprestimo registrado com sucesso!"]);
        break;

    case "devolver":
        $id = $_GET["id"];
        $dao->marcarDevolvido($id);
        echo json_encode(["mensagem" => "Devolucao registrada com sucesso!"]);
        break;

    default:
        http_response_code(400);
        echo json_encode(["erro" => "Acao invalida."]);
        break;
}