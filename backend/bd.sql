-- =============================================
-- BANCO DE DADOS: biblioteca
-- Projeto Acadêmico ADS - 5o Período
-- =============================================

CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

-- ---------------------------------------------
-- TABELA: usuarios
-- ---------------------------------------------
CREATE TABLE usuarios (
    id          INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL UNIQUE,
    senha       VARCHAR(255) NOT NULL,
    tipo        ENUM('aluno', 'admin') NOT NULL DEFAULT 'aluno',
    criado_em   DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------
-- TABELA: livros
-- ---------------------------------------------
CREATE TABLE livros (
    id          INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    titulo      VARCHAR(150) NOT NULL,
    autor       VARCHAR(100) NOT NULL,
    isbn        VARCHAR(20),
    ano         INT NOT NULL,
    quantidade  INT NOT NULL DEFAULT 1,
    sinopse     TEXT,
    criado_em   DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------
-- TABELA: emprestimos
-- ---------------------------------------------
CREATE TABLE emprestimos (
    id              INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    usuario_id      INT NOT NULL,
    livro_id        INT NOT NULL,
    data_emprestimo DATE NOT NULL DEFAULT (CURDATE()),
    data_devolucao  DATE NOT NULL,
    devolvido       TINYINT(1) NOT NULL DEFAULT 0,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (livro_id)   REFERENCES livros(id)
);

-- ---------------------------------------------
-- TABELA: reservas
-- ---------------------------------------------
CREATE TABLE reservas (
    id          INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    usuario_id  INT NOT NULL,
    livro_id    INT NOT NULL,
    data_reserva DATETIME DEFAULT CURRENT_TIMESTAMP,
    status      ENUM('pendente', 'confirmada', 'cancelada') NOT NULL DEFAULT 'pendente',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (livro_id)   REFERENCES livros(id)
);

-- ---------------------------------------------
-- TABELA: notificacoes
-- ---------------------------------------------
CREATE TABLE notificacoes (
    id          INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    usuario_id  INT NOT NULL,
    mensagem    TEXT NOT NULL,
    lida        TINYINT(1) NOT NULL DEFAULT 0,
    criado_em   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);