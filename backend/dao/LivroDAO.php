<?php

include __DIR__ . "/../model/Livro.php";

class LivroDAO {

    private function conectar() {
        return new mysqli("localhost", "root", "", "biblioteca", 3306);
    }

    public function listar() {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM livros ORDER BY titulo");
        $lista = [];
        while (($linha = $res->fetch_assoc()) != NULL) {
            $l = new Livro();
            $l->id         = $linha["id"];
            $l->titulo     = $linha["titulo"];
            $l->autor      = $linha["autor"];
            $l->isbn       = $linha["isbn"];
            $l->ano        = $linha["ano"];
            $l->quantidade = $linha["quantidade"];
            $l->sinopse    = $linha["sinopse"];
            $l->criado_em  = $linha["criado_em"];
            array_push($lista, $l);
        }
        $con->close();
        return $lista;
    }

    public function buscarPorId($id) {
        $con = $this->conectar();
        $res = $con->query("SELECT * FROM livros WHERE id = $id");
        $linha = $res->fetch_assoc();
        $con->close();
        if (!$linha) return null;
        $l = new Livro();
        $l->id         = $linha["id"];
        $l->titulo     = $linha["titulo"];
        $l->autor      = $linha["autor"];
        $l->isbn       = $linha["isbn"];
        $l->ano        = $linha["ano"];
        $l->quantidade = $linha["quantidade"];
        $l->sinopse    = $linha["sinopse"];
        $l->criado_em  = $linha["criado_em"];
        return $l;
    }

    public function inserir($titulo, $autor, $isbn, $ano, $quantidade, $sinopse) {
        $con = $this->conectar();
        $con->query("INSERT INTO livros (titulo, autor, isbn, ano, quantidade, sinopse)
                     VALUES ('$titulo', '$autor', '$isbn', $ano, $quantidade, '$sinopse')");
        $con->close();
    }

    public function atualizar($id, $titulo, $autor, $isbn, $ano, $quantidade, $sinopse) {
        $con = $this->conectar();
        $con->query("UPDATE livros SET
                        titulo     = '$titulo',
                        autor      = '$autor',
                        isbn       = '$isbn',
                        ano        = $ano,
                        quantidade = $quantidade,
                        sinopse    = '$sinopse'
                     WHERE id = $id");
        $con->close();
    }

    public function deletar($id) {
        $con = $this->conectar();
        $con->query("DELETE FROM livros WHERE id = $id");
        $con->close();
    }
}