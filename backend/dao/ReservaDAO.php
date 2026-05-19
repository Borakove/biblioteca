<?php

include __DIR__ . "/../model/Reserva.php";

class ReservaDAO {

    private function conectar() {
        return new mysqli("localhost", "root", "", "biblioteca", 3306);
    }

    public function listar() {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM reservas ORDER BY data_reserva DESC");
        $lista = [];
        while (($linha = $res->fetch_assoc()) != NULL) {
            $r = new Reserva();
            $r->id           = $linha["id"];
            $r->usuario_id   = $linha["usuario_id"];
            $r->livro_id     = $linha["livro_id"];
            $r->data_reserva = $linha["data_reserva"];
            $r->status       = $linha["status"];
            array_push($lista, $r);
        }
        $con->close();
        return $lista;
    }

    public function listarPorUsuario($usuario_id) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM reservas WHERE usuario_id = $usuario_id ORDER BY data_reserva DESC");
        $lista = [];
        while (($linha = $res->fetch_assoc()) != NULL) {
            $r = new Reserva();
            $r->id           = $linha["id"];
            $r->usuario_id   = $linha["usuario_id"];
            $r->livro_id     = $linha["livro_id"];
            $r->data_reserva = $linha["data_reserva"];
            $r->status       = $linha["status"];
            array_push($lista, $r);
        }
        $con->close();
        return $lista;
    }

    public function inserir($usuario_id, $livro_id) {
        $con = $this->conectar();
        $con->query("INSERT INTO reservas (usuario_id, livro_id)
                     VALUES ($usuario_id, $livro_id)");
        $con->close();
    }

    public function atualizarStatus($id, $status) {
        $con = $this->conectar();
        $con->query("UPDATE reservas SET status = '$status' WHERE id = $id");
        $con->close();
    }
}