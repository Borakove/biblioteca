<?php

include __DIR__ . "/../dao/UsuarioDAO.php";

header("Content-type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dao = new UsuarioDAO();
$acao = $_GET["acao"] ?? "";

switch ($acao) {

    case "listar":
        $usuarios = $dao->listar();
        echo json_encode($usuarios);
        break;

    case "login":
        $email = $_GET["email"];
        $senha = $_GET["senha"];
        $usuario = $dao->buscarPorEmail($email);
        if ($usuario && $usuario->senha === md5($senha)) {
            // não retorna a senha pro Flutter
            $usuario->senha = null;
            echo json_encode($usuario);
        } else {
            http_response_code(401);
            echo json_encode(["erro" => "Email ou senha incorretos."]);
        }
        break;

    case "cadastrar":
        $nome  = $_GET["nome"];
        $email = $_GET["email"];
        $senha = $_GET["senha"];
        if (trim($nome) == "" || trim($email) == "" || trim($senha) == "") {
            http_response_code(400);
            echo json_encode(["erro" => "Preencha todos os campos."]);
            break;
        }
        $dao->inserir($nome, $email, $senha);
        echo json_encode(["mensagem" => "Cadastro realizado com sucesso!"]);
        break;

    default:
        http_response_code(400);
        echo json_encode(["erro" => "Acao invalida."]);
        break;
}