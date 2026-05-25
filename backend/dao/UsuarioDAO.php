<?php

include __DIR__ . "/../model/Usuario.php";

class UsuarioDAO {

    private function conectar() {
        return new mysqli("localhost", "root", "", "biblioteca", 3306);
    }

    public function listar() {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM usuarios ORDER BY nome");
        $lista = [];
        while (($linha = $res->fetch_assoc()) != NULL) {
            $u = new Usuario();
            $u->id        = $linha["id"];
            $u->nome      = $linha["nome"];
            $u->email     = $linha["email"];
            $u->tipo      = $linha["tipo"];
            $u->criado_em = $linha["criado_em"];
            array_push($lista, $u);
        }
        $con->close();
        return $lista;
    }

    public function buscarPorEmail($email) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM usuarios WHERE email = '$email'");
        $linha = $res->fetch_assoc();
        $con->close();
        if (!$linha) return null;
        $u = new Usuario();
        $u->id    = $linha["id"];
        $u->nome  = $linha["nome"];
        $u->email = $linha["email"];
        $u->senha = $linha["senha"];
        $u->tipo  = $linha["tipo"];
        return $u;
    }

    public function inserir($nome, $email, $senha) {
        $con = $this->conectar();
        $senhaCriptografada = md5($senha);
        $con->query("INSERT INTO usuarios (nome, email, senha, tipo)
                     VALUES ('$nome', '$email', '$senhaCriptografada', 'aluno')");
        $con->close();
    }

    public function atualizarSenha($email, $novaSenha) {
        $con = $this->conectar();
        $senhaCriptografada = md5($novaSenha);
        $resultado = $con->query("UPDATE usuarios SET senha = '$senhaCriptografada' WHERE email = '$email'");
        $afetados = $con->affected_rows;
        $con->close();
        return $afetados > 0;
    }
}