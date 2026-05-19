-- =============================================
-- DADOS DE TESTE
-- =============================================
USE biblioteca;

-- Usuários (senha: 1234 em md5 apenas para teste)
INSERT INTO usuarios (nome, email, senha, tipo) VALUES
    ('Admin Biblioteca', 'admin@biblioteca.com', MD5('admin123'), 'admin'),
    ('João Silva',       'joao@aluno.com',        MD5('1234'),     'aluno'),
    ('Maria Souza',      'maria@aluno.com',        MD5('1234'),     'aluno');

-- Livros
INSERT INTO livros (titulo, autor, isbn, ano, quantidade, sinopse) VALUES
    ('Engenharia de Software', 'Ian Sommerville', '9788543024974', 2011, 3, 'Fundamentos de engenharia de software moderna.'),
    ('Clean Code',             'Robert C. Martin', '9788576082675', 2009, 2, 'Boas práticas para escrever código limpo.'),
    ('Banco de Dados',         'Abraham Silberschatz', '9788535245356', 2006, 2, 'Conceitos fundamentais de sistemas de banco de dados.'),
    ('Algoritmos',             'Thomas Cormen',    '9788535236996', 2012, 1, 'Introdução a algoritmos e estruturas de dados.');

-- Empréstimos
INSERT INTO emprestimos (usuario_id, livro_id, data_emprestimo, data_devolucao, devolvido) VALUES
    (2, 1, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), 0),
    (3, 2, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), 0);

-- Reservas
INSERT INTO reservas (usuario_id, livro_id, status) VALUES
    (2, 4, 'pendente'),
    (3, 1, 'pendente');

-- Notificações
INSERT INTO notificacoes (usuario_id, mensagem) VALUES
    (2, 'Seu empréstimo do livro "Engenharia de Software" vence em 3 dias.'),
    (3, 'Sua reserva do livro "Engenharia de Software" está confirmada.');