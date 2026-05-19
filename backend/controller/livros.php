<?php

include __DIR__ . "/../dao/LivroDAO.php";

header("Content-type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dao = new LivroDAO();
$acao = $_GET["acao"] ?? "";

switch ($acao) {

    case "listar":
        $livros = $dao->listar();
        echo json_encode($livros);
        break;

    case "buscar":
        $id = $_GET["id"];
        $livro = $dao->buscarPorId($id);
        echo json_encode($livro);
        break;

    case "inserir":
        $titulo     = $_GET["titulo"];
        $autor      = $_GET["autor"];
        $isbn       = $_GET["isbn"] ?? "";
        $ano        = $_GET["ano"];
        $quantidade = $_GET["quantidade"] ?? 1;
        $sinopse    = $_GET["sinopse"] ?? "";
        $dao->inserir($titulo, $autor, $isbn, $ano, $quantidade, $sinopse);
        echo json_encode(["mensagem" => "Livro cadastrado com sucesso!"]);
        break;

    case "atualizar":
        $id         = $_GET["id"];
        $titulo     = $_GET["titulo"];
        $autor      = $_GET["autor"];
        $isbn       = $_GET["isbn"] ?? "";
        $ano        = $_GET["ano"];
        $quantidade = $_GET["quantidade"];
        $sinopse    = $_GET["sinopse"] ?? "";
        $dao->atualizar($id, $titulo, $autor, $isbn, $ano, $quantidade, $sinopse);
        echo json_encode(["mensagem" => "Livro atualizado com sucesso!"]);
        break;

    case "deletar":
        $id = $_GET["id"];
        $dao->deletar($id);
        echo json_encode(["mensagem" => "Livro removido com sucesso!"]);
        break;

    default:
        http_response_code(400);
        echo json_encode(["erro" => "Acao invalida."]);
        break;
}