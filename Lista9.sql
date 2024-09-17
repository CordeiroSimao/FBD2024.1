-- Database: lista9

-- DROP DATABASE IF EXISTS lista9;

CREATE DATABASE lista9
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
-- Creating Tables --

CREATE TABLE Empregado
	(ENome varchar(32), 
	 CPF varchar(4), 
	 Endereço varchar(64),
	 Nasc date,
	 Sexo char,
	 Salário numeric(10,2),
	 Chefe varchar(4),
	 Cdep char	 
	);
	
CREATE TABLE Departamento
	(DNome varchar(64),
	 Código char,
	 Gerente varchar(4)
	);
	
CREATE TABLE Projeto
	(PNome varchar(64),
	 PCódigo varchar(4),
	 Cidade varchar(32),
	 Cdep char
	);

CREATE TABLE DUnidade
	(DCódigo char,
	 DCidade varchar(64)
	);
	
CREATE TABLE Tarefa
	(CPF varchar(4),
	 PCódigo varchar(4),
	 Horas numeric(4,1)
	);

DROP TABLE Empregado; 
DROP TABLE Departamento;
DROP TABLE Projeto;
DROP TABLE DUnidade;
DROP TABLE Tarefa;

--Populating the Tables

INSERT INTO Empregado (ENome, CPF, Endereço, Nasc, Sexo, Salário, Chefe, Cdep)
VALUES
('Chiquin', '1234', 'rua 1, 1', '1962-02-02', 'M', 10000, '8765', '3'),
('Helenita', '4321', 'rua 2, 2', '1963-03-03', 'F', 12000, '6543', '2'),
('Pedrin', '5678', 'rua 3, 3', '1964-04-04', 'M', 9000, '6543', '2'),
('Valtin', '8765', 'rua 4, 4', '1965-05-05', 'M', 15000, NULL, '4'),
('Zulmira', '3456', 'rua 5, 5', '1966-06-06', 'F', 12000, '8765', '3'),
('Zefinha', '6543', 'rua 6, 6', '1967-07-07', 'M', 10000, '8765', '2');

INSERT INTO Departamento
VALUES
('Pesquisa', '3', '1234'),
('Marketing', '2', '6543'),
('Administração', '4', '8765');

INSERT INTO Projeto
VALUES
('ProdutoA', 'PA', 'Cumbuco', '3'),
('ProdutoB', 'PB', 'Icapuí', '3'),
('Informatização', 'Inf', 'Fortaleza', '4'),
('Divulgação', 'Div', 'Morro Branco', '2');

INSERT INTO DUnidade
VALUES
('2', 'Morro Branco'),
('3', 'Cumbuco'),
('3', 'Prainha'),
('3', 'Taíba'),
('3', 'Icapuí'),
('4', 'Fortaleza');

INSERT INTO Tarefa
VALUES
('1234', 'PA', 30),
('1234', 'PB', 10),
('4321', 'PA', 5),
('4321', 'Div', 35),
('5678', 'Div', 40),
('8765', 'Inf', 32),
('8765', 'Div', 8),
('3456', 'PA', 10),
('3456', 'PB', 25),
('3456', 'Div', 5),
('6543', 'PB', 40);

TRUNCATE TABLE Empregado;
TRUNCATE TABLE Departamento;
TRUNCATE TABLE Projeto;
TRUNCATE TABLE DUnidade;
TRUNCATE TABLE Tarefa;


-- 1) Recupere o nome e o salário de todos os empregados.
SELECT ENome, Salário
FROM Empregado;

-- 2) Recupere o nome e o salário de todos os empregados do sexo feminino.
SELECT ENome, Salário
FROM Empregado
WHERE Sexo = 'F';

-- 3) Recupere o nome e o salário de todos os empregados do sexo feminino e que ganham salário maior que R$ 10.000,00.
SELECT ENome, Salário
FROM Empregado
WHERE Sexo = 'F' AND Salário > 10000.00;

-- 4) Recupere a quantidade de empregados.
SELECT COUNT(*) AS Quantidade_de_Empregados
FROM Empregado;

-- 5) Recupere o maior salário, o menor salário e a média salarial da empresa.
SELECT MAX(Salário) AS Maior_Salário,
       MIN(Salário) AS Menor_Salário,
       AVG(Salário) AS Média_Salarial
FROM Empregado;

-- 6) Recupere o nome e o salário de todos os empregados que trabalham em Marketing.
SELECT E.ENome, E.Salário
FROM Empregado E
JOIN Departamento D ON E.Cdep = D.Código
WHERE D.DNome = 'Marketing';

-- 7) Recupere o CPF dos empregados que possuem alguma tarefa.
SELECT DISTINCT CPF
FROM Tarefa;

-- 8) Recupere o CPF dos empregados que não possuem tarefa.
SELECT CPF
FROM Empregado
WHERE CPF NOT IN (SELECT CPF FROM Tarefa);

-- 9) Recupere o nome dos empregados que possuem alguma tarefa.
SELECT DISTINCT E.ENome
FROM Empregado E
JOIN Tarefa T ON E.CPF = T.CPF;

-- 10) Recupere o nome dos empregados que não possuem tarefa.
SELECT ENome
FROM Empregado
WHERE CPF NOT IN (SELECT CPF FROM Tarefa);

-- 11) Recupere o CPF dos empregados que possuem pelo menos uma tarefa com mais de 30 horas.
SELECT DISTINCT CPF
FROM Tarefa
WHERE Horas > 30;

-- 12) Recupere o nome dos empregados que possuem pelo menos uma tarefa com mais de 30 horas.
SELECT DISTINCT E.ENome
FROM Empregado E
JOIN Tarefa T ON E.CPF = T.CPF
WHERE T.Horas > 30;

-- 13) Recupere para cada departamento o seu nome e o nome do seu gerente.
SELECT D.DNome, E.ENome AS Gerente
FROM Departamento D
JOIN Empregado E ON D.Gerente = E.CPF;

-- 14) Recupere o CPF de todos os empregados que trabalham em Pesquisa ou que diretamente gerenciam um empregado que trabalha em Pesquisa.
SELECT E.CPF
FROM Empregado E
JOIN Departamento D ON E.Cdep = D.Código
WHERE D.DNome = 'Pesquisa'
UNION
SELECT E.CPF
FROM Empregado E
JOIN Empregado Sub ON E.CPF = Sub.Chefe
JOIN Departamento D ON Sub.Cdep = D.Código
WHERE D.DNome = 'Pesquisa';

-- 15) Recupere o nome e a cidade dos projetos que envolvem (contêm) pelo menos um empregado que trabalha mais de 30 horas nesse projeto.
SELECT DISTINCT P.PNome, P.Cidade
FROM Projeto P
JOIN Tarefa T ON P.PCódigo = T.PCódigo
WHERE T.Horas > 30;

-- 16) Recupere o nome e a data de nascimento dos gerentes de cada departamento.
SELECT E.ENome, E.Nasc
FROM Empregado E
JOIN Departamento D ON E.CPF = D.Gerente;

-- 17) Recupere o nome e o endereço de todos os empregados que trabalham para o departamento "Pesquisa".
SELECT E.ENome, E.Endereço
FROM Empregado E
JOIN Departamento D ON E.Cdep = D.Código
WHERE D.DNome = 'Pesquisa';

-- 18) Para cada projeto localizado em Icapuí, recupere o código do projeto, o nome do departamento que o controla e o nome do seu gerente.
SELECT P.PCódigo, D.DNome, E.ENome AS Gerente
FROM Projeto P
JOIN Departamento D ON P.Cdep = D.Código
JOIN Empregado E ON D.Gerente = E.CPF
WHERE P.Cidade = 'Icapuí';

-- 19) Recupere o nome e o sexo dos empregados que são gerentes.
SELECT DISTINCT E.ENome, E.Sexo
FROM Empregado E
JOIN Departamento D ON E.CPF = D.Gerente;

-- 20) Recupere o nome e o sexo dos empregados que não são gerentes.
SELECT E.ENome, E.Sexo
FROM Empregado E
WHERE CPF NOT IN (SELECT Gerente FROM Departamento);