<?php

include __DIR__ . "/../model/Notificacao.php";

class NotificacaoDAO {

    private function conectar() {
        return new mysqli("localhost", "root", "", "biblioteca", 3306);
    }

    public function listarPorUsuario($usuario_id) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM notificacoes WHERE usuario_id = $usuario_id ORDER BY criado_em DESC");
        $lista = [];
        while (($linha = $res->fetch_assoc()) != NULL) {
            $n = new Notificacao();
            $n->id         = $linha["id"];
            $n->usuario_id = $linha["usuario_id"];
            $n->mensagem   = $linha["mensagem"];
            $n->lida       = $linha["lida"];
            $n->criado_em  = $linha["criado_em"];
            array_push($lista, $n);
        }
        $con->close();
        return $lista;
    }

    public function inserir($usuario_id, $mensagem) {
        $con = $this->conectar();
        $con->query("INSERT INTO notificacoes (usuario_id, mensagem)
                     VALUES ($usuario_id, '$mensagem')");
        $con->close();
    }

    public function marcarLida($id) {
        $con = $this->conectar();
        $con->query("UPDATE notificacoes SET lida = 1 WHERE id = $id");
        $con->close();
    }
}