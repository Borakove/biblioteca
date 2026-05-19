<?php

include __DIR__ . "/../model/Emprestimo.php";

class EmprestimoDAO {

    private function conectar() {
        return new mysqli("localhost", "root", "", "biblioteca", 3306);
    }

    public function listar() {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM emprestimos ORDER BY data_emprestimo DESC");
        $lista = [];
        while (($linha = $res->fetch_assoc()) != NULL) {
            $e = new Emprestimo();
            $e->id              = $linha["id"];
            $e->usuario_id      = $linha["usuario_id"];
            $e->livro_id        = $linha["livro_id"];
            $e->data_emprestimo = $linha["data_emprestimo"];
            $e->data_devolucao  = $linha["data_devolucao"];
            $e->devolvido       = $linha["devolvido"];
            array_push($lista, $e);
        }
        $con->close();
        return $lista;
    }

    public function listarPorUsuario($usuario_id) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM emprestimos WHERE usuario_id = $usuario_id ORDER BY data_emprestimo DESC");
        $lista = [];
        while (($linha = $res->fetch_assoc()) != NULL) {
            $e = new Emprestimo();
            $e->id              = $linha["id"];
            $e->usuario_id      = $linha["usuario_id"];
            $e->livro_id        = $linha["livro_id"];
            $e->data_emprestimo = $linha["data_emprestimo"];
            $e->data_devolucao  = $linha["data_devolucao"];
            $e->devolvido       = $linha["devolvido"];
            array_push($lista, $e);
        }
        $con->close();
        return $lista;
    }

    public function inserir($usuario_id, $livro_id, $data_devolucao) {
        $con = $this->conectar();
        $con->query("INSERT INTO emprestimos (usuario_id, livro_id, data_devolucao)
                     VALUES ($usuario_id, $livro_id, '$data_devolucao')");
        $con->close();
    }

    public function marcarDevolvido($id) {
        $con = $this->conectar();
        $con->query("UPDATE emprestimos SET devolvido = 1 WHERE id = $id");
        $con->close();
    }
}