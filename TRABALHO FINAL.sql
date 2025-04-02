/* PROJETO FINAL DA DISCIPLINA de DB:
*	GRUPO 4:
* 		Caroline Brand Barreto
* 		Hugo Martins da Silva Braga
* 		Jhonatan Savio Martins Cardoso
* 		Leorick Aguiar Felippe
* 		Maria Vitória Martelli Borges
		Miguel Cardoso Tavares */

-- ################################################################################################################################################################## 

-- CRIAÇÃO DA BASE DE DADOS:
CREATE DATABASE Clinica_Odontologica_sorriDentes;

-- ################################################################################################################################################################## 

-- CRIAÇÃO DE TABELAS:

-- Tabela Pacientes:
CREATE TABLE pacientes (
	id_paciente SERIAL PRIMARY KEY,
	nome_completo VARCHAR(100) NOT NULL,
	CPF VARCHAR(14) UNIQUE NOT NULL,
	telefone VARCHAR(15),
	email VARCHAR(100) UNIQUE NOT NULL,
	endereco VARCHAR(200) NOT NULL,
	data_nascimento DATE NOT NULL
);

-- Tabela Atendentes:
CREATE TABLE atendentes (
	id_atendente SERIAL PRIMARY KEY,
	nome_atendente VARCHAR(100) NOT NULL,
	email_atendente VARCHAR(100) UNIQUE NOT NULL,
	CPF VARCHAR(14) UNIQUE NOT NULL,
	senha VARCHAR(100) NOT NULL
);

-- Tabela Dentistas:
CREATE TABLE dentistas (
	id_dentista SERIAL PRIMARY KEY,
	CPF VARCHAR(14) UNIQUE NOT NULL,
	CRO VARCHAR(20) UNIQUE NOT NULL,
	nome_completo_dentista VARCHAR(100) NOT NULL,
	especialidade_dentista VARCHAR(100) NOT NULL
);

-- Tabela Consultas:
CREATE TABLE consultas (
	id_consulta SERIAL PRIMARY KEY,
	id_dentista SERIAL,
	data_horario_consulta TIMESTAMP NOT NULL,
	especialidade VARCHAR(200) NOT NULL,
	prescricao VARCHAR(200),
	descricao_do_atendimento VARCHAR(200) NOT NULL,
	FOREIGN KEY (id_dentista) REFERENCES dentistas(id_dentista) ON DELETE CASCADE
);

-- Tabela Horários(dos dentistas)
CREATE TYPE decisao AS ENUM ('sim', 'nao');

CREATE TABLE horarios (
	id_horario SERIAL PRIMARY KEY,
	id_dentista SERIAL,
	hora_inicio TIME NOT NULL,
	hora_fim TIME NOT NULL,
	domingo decisao NOT NULL,  
	segunda decisao NOT NULL,  
	terca decisao NOT NULL,  
	quarta decisao NOT NULL,  
	quinta decisao NOT NULL,  
	sexta decisao NOT NULL,  
	sabado decisao NOT NULL,
	FOREIGN KEY (id_dentista) REFERENCES dentistas(id_dentista) ON DELETE CASCADE
);

-- Tabela de Procedimentos Odontológicos:
CREATE TABLE procedimentos_odontologicos (
	id_procedimento SERIAL PRIMARY KEY,
	id_dentista SERIAL,
	nome_procedimento VARCHAR(60) NOT NULL,
	descricao VARCHAR(200) NOT NULL,
	duracao_media TIME NOT NULL,
	FOREIGN KEY (id_dentista) REFERENCES dentistas(id_dentista) ON DELETE CASCADE
);

-- Tabela Agendamentos:
CREATE TABLE agendamentos( 
	id_agendamento SERIAL PRIMARY KEY,
	id_atendente SERIAL,
	id_consulta SERIAL,
	id_paciente SERIAL,
	FOREIGN KEY (id_atendente) REFERENCES atendentes(id_atendente) ON DELETE CASCADE,
	FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
	FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta) ON DELETE CASCADE
);

-- Tabela Cancelamentos:
CREATE TABLE cancelamentos( 
	id_cancelamento SERIAL PRIMARY KEY,
	id_atendente SERIAL,
	id_consulta SERIAL,
	id_paciente SERIAL,
	FOREIGN KEY (id_atendente) REFERENCES atendentes(id_atendente) ON DELETE CASCADE,
	FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
	FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta) ON DELETE CASCADE
);

-- Tabela Atualizações:
CREATE TABLE atualizacoes( 
	id_atualizacao SERIAL PRIMARY KEY,
	id_atendente SERIAL,
	id_consulta SERIAL,
	id_paciente SERIAL,
	FOREIGN KEY (id_atendente) REFERENCES atendentes(id_atendente) ON DELETE CASCADE,
	FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente) ON DELETE CASCADE,
	FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta) ON DELETE CASCADE
);

-- Histórico de consultas:
CREATE VIEW historico_consultas_pacientes AS
        SELECT
            p.nome_completo AS Nome_paciente,
            c.data_horario_consulta AS Data_consulta,
            d.nome_completo_dentista AS Nome_dentista,
            c.especialidade AS Especialidade,
            c.descricao_do_atendimento AS descricao_dos_atendimentos
                FROM pacientes p
                JOIN agendamentos a ON p.id_paciente = a.id_paciente
                JOIN consultas c ON a.id_consulta = c.id_consulta
                JOIN dentistas d ON c.id_dentista = d.id_dentista
                ORDER BY p.nome_completo, c.data_horario_consulta DESC;

SELECT * FROM historico_consultas_pacientes;

-- ##################################################################################################################################################################

-- ALIMENTANDO AS TABELAS:

-- Tabela Pacientes:
INSERT INTO pacientes (nome_completo, CPF, telefone, email, endereco, data_nascimento) VALUES
('João Silva', '123.456.789-00', '(11) 98765-4321', 'joao.silva@gmail.com', 'Rua A, 123, Centro, São Paulo', '1985-01-15'),
('Maria Oliveira', '234.567.890-11', '(11) 97654-3210', 'maria.oliveira@hotmail.com', 'Rua B, 456, Vila Progresso, São Paulo', '1990-07-22'),
('Carlos Souza', '345.678.901-22', '(21) 98876-5432', 'carlos.souza@gmail.com', 'Rua C, 789, Jardim das Flores, Rio', '1987-03-30'),
('Ana Pereira', '456.789.012-33', '(61) 99345-6789', 'ana.pereira@outlook.com', 'Rua D, 321, Asa Sul, Brasília', '1992-05-12'),
('Pedro Santos', '567.890.123-44', '(21) 98987-6543', 'pedro.santos@yahoo.com.br', 'Rua E, 654, Barra da Tijuca, Rio', '1980-10-05'),
('Beatriz Costa', '678.901.234-55', '(41) 99543-2109', 'beatriz.costa@gmail.com', 'Rua F, 987, Centro, Curitiba', '1995-11-30'),
('Lucas Almeida', '789.012.345-66', '(11) 95432-1098', 'lucas.almeida@icloud.com', 'Rua G, 321, Moema, São Paulo', '2000-02-20'),
('Fernanda Rocha', '890.123.456-77', '(51) 98123-9876', 'fernanda.rocha@gmail.com', 'Rua H, 654, Bom Jesus, Porto Alegre', '1983-08-18'),
('Rodrigo Pereira', '901.234.567-88', '(31) 99765-4321', 'rodrigo.pereira@outlook.com', 'Rua I, 123, Lourdes, Belo Horizonte', '1989-12-10'),
('Juliana Lima', '012.345.678-99', '(11) 98123-4567', 'juliana.lima@gmail.com', 'Rua J, 876, Vila Mariana, São Paulo', '1998-04-28');

-- Tabela Atendentes:
INSERT INTO atendentes (nome_atendente, email_atendente, CPF, senha) VALUES
('Sofia Costa', 'sofia.costa@empresa.com', '123.456.789-00', 'senha123'),
('Marcelo Oliveira', 'marcelo.oliveira@empresa.com', '234.567.890-11', 'senha456'),
('Juliana Martins', 'juliana.martins@empresa.com', '345.678.901-22', 'senha789'),
('Ricardo Souza', 'ricardo.souza@empresa.com', '456.789.012-33', 'senha321'),
('Fernanda Lima', 'fernanda.lima@empresa.com', '567.890.123-44', 'senha654'),
('Lucas Pereira', 'lucas.pereira@empresa.com', '678.901.234-55', 'senha987'),
('Ana Beatriz Silva', 'ana.silva@empresa.com', '789.012.345-66', 'senha111'),
('Carolina Rocha', 'carolina.rocha@empresa.com', '890.123.456-77', 'senha222'),
('Vitor Costa', 'vitor.costa@empresa.com', '901.234.567-88', 'senha333'),
('Eduardo Almeida', 'eduardo.almeida@empresa.com', '012.345.678-99', 'senha444');

-- Tabela Dentistas:
INSERT INTO dentistas (CPF, CRO, nome_completo_dentista, especialidade_dentista) VALUES
('123.456.789-00', '1234SP', 'Dr. Ana Santos', 'Ortodontia'),
('234.567.890-11', '5678SP', 'Dr. Felipe Rocha', 'Endodontia'),
('345.678.901-22', '6789RJ', 'Dra. Carla Costa', 'Periodontia'),
('456.789.012-33', '2345MG', 'Dr. Roberto Lima', 'Prótese Dentária'),
('567.890.123-44', '8901RS', 'Dra. Juliana Almeida', 'Implantodontia'),
('678.901.234-55', '4567PR', 'Dr. Lucas Pereira', 'Cirurgia Oral'),
('789.012.345-66', '3456SP', 'Dra. Beatriz Silva', 'Odontopediatria'),
('890.123.456-77', '5678GO', 'Dr. Marcos Souza', 'Estética Dental'),
('901.234.567-88', '6789BA', 'Dra. Fernanda Lima', 'Endodontia'),
('012.345.678-99', '1234CE', 'Dr. Daniel Martins', 'Periodontia');

-- Tabela Consultas:
INSERT INTO consultas (id_dentista, data_horario_consulta, especialidade, prescricao, descricao_do_atendimento) VALUES
(1, '2023-11-15 09:00:00', 'Ortodontia', 'Aparelho ortodôntico superior', 'Avaliação inicial para colocação de aparelho'),
(6, '2023-11-16 10:30:00', 'Endodontia', 'Tratamento de canal no dente 26', 'Paciente com dor intensa, iniciado tratamento de canal'),
(4, '2023-11-17 14:00:00', 'Periodontia', 'Raspagem e alisamento radicular', 'Tratamento periodontal para gengivite avançada'),
(5, '2023-11-18 11:00:00', 'Prótese Dentária', 'Confecção de prótese parcial removível', 'Moldagem para prótese na arcada inferior'),
(3, '2023-11-20 08:30:00', 'Implantodontia', 'Implante dentário no dente 36', 'Cirurgia para colocação de implante osseointegrado'),
(2, '2023-11-21 15:30:00', 'Cirurgia Oral', 'Extração do siso inferior direito', 'Paciente com pericoronarite, siso incluso removido'),
(10, '2023-11-22 10:00:00', 'Odontopediatria', 'Aplicação de flúor', 'Consulta de rotina para paciente adolescente'),
(8, '2023-11-23 13:15:00', 'Estética Dental', 'Clareamento dental caseiro', 'Moldagem para confecção de moldeira de clareamento'),
(9, '2023-11-24 16:45:00', 'Endodontia', 'Retratamento de canal no dente 11', 'Remoção de material obturador antigo e recanal'),
(7, '2023-11-25 09:30:00', 'Periodontia', 'Manutenção periodontal', 'Controle de placa e profilaxia profissional'),
(1, '2023-11-27 10:00:00', 'Ortodontia', 'Troca de fios ortodônticos', 'Manutenção periódica do aparelho'),
(1, '2023-12-04 14:30:00', 'Ortodontia', 'Ajuste de braquetes', 'Correção do alinhamento dental'),
(2, '2023-11-28 09:30:00', 'Endodontia', 'Tratamento de canal dente 45', 'Paciente com abscesso periapical'),
(2, '2023-12-05 11:00:00', 'Endodontia', 'Medicação intracanal', 'Tratamento em duas sessões'),
(3, '2023-11-29 08:30:00', 'Periodontia', 'Aplicação de antibiótico local', 'Bolsas periodontais profundas'),
(3, '2023-12-06 13:00:00', 'Periodontia', 'Controle de placa', 'Acompanhamento pós-tratamento'),
(4, '2023-11-30 15:00:00', 'Prótese Dentária', 'Prova da prótese total', 'Ajuste de oclusão'),
(4, '2023-12-07 10:30:00', 'Prótese Dentária', 'Reparo de prótese removível', 'Conserto do grampo'),
(5, '2023-12-01 08:00:00', 'Implantodontia', 'Reabertura de implante', 'Colocação do cicatrizador gengival'),
(5, '2023-12-08 12:00:00', 'Implantodontia', 'Consulta pós-operatória', 'Avaliação da osseointegração'),
(6, '2023-12-02 09:00:00', 'Cirurgia Oral', 'Extração de dente 37', 'Dente com grande destruição coronária'),
(6, '2023-12-09 14:00:00', 'Cirurgia Oral', 'Remoção de cisto', 'Cirurgia para enucleação de cisto'),
(7, '2023-12-03 10:30:00', 'Odontopediatria', 'Aplicação de selante', 'Prevenção em primeiro molar permanente'),
(7, '2023-12-10 09:15:00', 'Odontopediatria', 'Orientação de higiene', 'Paciente com alto índice de placa'),
(8, '2023-12-04 16:00:00', 'Estética Dental', 'Polimento dental', 'Remoção de manchas extrínsecas'),
(8, '2023-12-11 11:45:00', 'Estética Dental', 'Prova da faceta', 'Ajuste de cor e formato'),
(9, '2023-12-05 13:30:00', 'Endodontia', 'Tratamento de canal dente 21', 'Trauma dental'),
(9, '2023-12-12 15:15:00', 'Endodontia', 'Obturação do canal', 'Finalização do tratamento'),
(10, '2023-12-06 08:45:00', 'Periodontia', 'Raspagem supragengival', 'Paciente com cálculo dental'),
(10, '2023-12-13 10:00:00', 'Periodontia', 'Acompanhamento periodontal', 'Controle de sangramento gengival'),
(1, '2023-12-14 11:30:00', 'Ortodontia', 'Colocação de elásticos', 'Correção da mordida'),
(2, '2023-12-15 14:45:00', 'Endodontia', 'Retratamento endodôntico', 'Dente com lesão periapical'),
(3, '2023-12-16 09:15:00', 'Periodontia', 'Enxerto gengival', 'Recobrimento radicular'),
(4, '2023-12-17 13:00:00', 'Prótese Dentária', 'Moldagem para coroa', 'Dente pós-tratamento endodôntico'),
(5, '2023-12-18 08:30:00', 'Implantodontia', 'Cirurgia de implante', 'Instalação de implante unitário'),
(6, '2023-12-19 16:30:00', 'Cirurgia Oral', 'Exodontia de dente decíduo', 'Dente de leite retido'),
(7, '2023-12-20 10:45:00', 'Odontopediatria', 'Aplicação de flúor', 'Consulta preventiva'),
(8, '2023-12-21 12:15:00', 'Estética Dental', 'Clareamento em consultório', 'Sessão de ativação'),
(9, '2023-12-22 09:30:00', 'Endodontia', 'Tratamento de canal em pré-molar', 'Dor espontânea'),
(10, '2023-12-23 11:00:00', 'Periodontia', 'Manutenção periodontal', 'Paciente em acompanhamento');

-- Tabela Horários(dos dentistas)
INSERT INTO horarios (id_dentista, hora_inicio, hora_fim, domingo, segunda, terca, quarta, quinta, sexta, sabado) values
(1, '08:30:00', '18:00:00', 'nao', 'sim', 'sim', 'nao', 'sim', 'sim', 'nao'),
(2, '08:00:00', '17:00:00', 'nao', 'sim', 'sim', 'sim', 'sim', 'sim', 'nao'),
(3, '08:00:00', '16:30:00', 'nao', 'sim', 'sim', 'nao', 'sim', 'sim', 'nao'),
(4, '09:00:00', '18:00:00', 'nao', 'nao', 'sim', 'sim', 'sim', 'sim', 'nao'),
(5, '08:00:00', '13:00:00', 'nao', 'sim', 'sim', 'sim', 'sim', 'sim', 'sim'),
(6, '08:00:00', '16:00:00', 'nao', 'sim', 'sim', 'nao', 'nao', 'sim', 'nao'),
(7, '09:00:00', '17:00:00', 'nao', 'sim', 'sim', 'sim', 'sim', 'sim', 'sim'),
(8, '10:00:00', '19:00:00', 'nao', 'sim', 'nao', 'sim', 'sim', 'sim', 'nao'),
(9, '08:30:00', '17:30:00', 'nao', 'sim', 'sim', 'sim', 'sim', 'nao', 'nao'),
(10, '08:00:00', '12:00:00', 'nao', 'sim', 'sim', 'sim', 'sim', 'sim', 'sim');

-- Tabela de Procedimentos Odontológicos:
INSERT INTO procedimentos_odontologicos (id_dentista, nome_procedimento, descricao, duracao_media) VALUES
(1, 'Colocação de aparelho fixo', 'Instalação de braquetes e fios ortodônticos', '01:00:00'),
(1, 'Manutenção de aparelho', 'Ajuste e troca de ligaduras e fios', '00:30:00'),
(2, 'Tratamento de canal', 'Remoção da polpa dental e obturação do canal', '01:30:00'),
(2, 'Retratamento endodôntico', 'Retirada do material obturador e novo tratamento', '02:00:00'),
(3, 'Raspagem e alisamento radicular', 'Remoção de tártaro subgengival', '01:00:00'),
(3, 'Cirurgia periodontal', 'Correção de defeitos ósseos', '01:30:00'),
(4, 'Prótese total acrílica', 'Confecção de dentadura completa', '02:00:00'),
(4, 'Prótese parcial removível', 'Prótese com estrutura metálica', '01:30:00'),
(5, 'Implante dentário', 'Instalação de pino de titânio no osso', '02:00:00'),
(5, 'Prótese sobre implante', 'Coroa sobre implante osseointegrado', '01:30:00'),
(6, 'Extração de siso incluso', 'Remoção cirúrgica de terceiro molar', '01:00:00'),
(6, 'Enxerto ósseo', 'Reposição de estrutura óssea', '02:00:00'),
(7, 'Aplicação de flúor', 'Prevenção de cárie em crianças', '00:30:00'),
(7, 'Selante de fissuras', 'Proteção de sulcos dentários', '00:30:00'),
(8, 'Clareamento dental', 'Clareamento com moldeira caseira', '01:00:00'),
(8, 'Faceta de porcelana', 'Laminado estético dental', '01:30:00'),
(9, 'Pulpotomia', 'Remoção parcial da polpa dental', '01:00:00'),
(9, 'Apicectomia', 'Cirurgia para remoção do ápice radicular', '01:30:00'),
(10, 'Gengivoplastia', 'Remodelagem do tecido gengival', '01:00:00'),
(10, 'Enxerto gengival', 'Recobrimento de raiz exposta', '01:30:00');

-- Tabela Agendamentos:
INSERT INTO agendamentos (id_atendente, id_consulta, id_paciente) VALUES
(3, 1, 1), (5, 2, 2), (2, 3, 3), (7, 4, 4), (1, 5, 5),
(4, 6, 6), (9, 7, 7), (6, 8, 8), (8, 9, 9), (10, 10, 10),
(1, 11, 1), (3, 12, 2), (4, 13, 3), (5, 14, 4), (2, 15, 5),
(7, 16, 6), (6, 17, 7), (10, 18, 8), (8, 19, 9), (9, 20, 10),
(2, 21, 1), (5, 22, 2), (1, 23, 3), (3, 24, 4), (4, 25, 5), 
(7, 26, 6), (6, 27, 7), (8, 28, 8), (10, 29, 9), (9, 30, 10),
(3, 31, 1), (4, 32, 2), (5, 33, 3), (1, 34, 4), (2, 35, 5), 
(7, 36, 6), (6, 37, 7), (8, 38, 8), (10, 39, 9), (9, 40, 10);

-- Tabela Cancelamentos:
INSERT INTO cancelamentos (id_atendente, id_consulta, id_paciente) VALUES
(3, 1, 1), (5, 2, 2), (2, 3, 3), (7, 4, 4), (1, 5, 5),
(4, 6, 6), (9, 7, 7), (6, 8, 8), (8, 9, 9), (10, 10, 10);

-- Tabela Atualizações:
INSERT INTO atualizacoes (id_atendente, id_consulta, id_paciente) VALUES
(1, 11, 1), (2, 12, 2), (3, 13, 3), (4, 14, 4), (5, 15, 5),
(6, 16, 6), (7, 17, 7), (8, 18, 8), (9, 19, 9), (10, 20, 10);


-- ##################################################################################################################################################################

-- UPDATES & EXCLUSÕES:

UPDATE procedimentos_odontologicos 
	SET nome_procedimento = 'Facetas dentárias'
		WHERE id_procedimento = 1;

UPDATE atendentes
	SET nome_atendente = 'Matheus Tedesco'
		WHERE id_atendente = 6

UPDATE dentistas
	SET cro = '1337RJ'
		WHERE id_dentista = 3;


DELETE FROM procedimentos_odontologicos WHERE nome_procedimento = 'Cirurgia periodontal'

DELETE FROM pacientes WHERE nome_completo = 'Carlos Souza'

DELETE FROM consultas WHERE prescricao = 'Tratamento de canal dente 45'


-- ##################################################################################################################################################################

-- CRIANDO ÍNDICES:
CREATE INDEX idx_consultas_data_horario ON consultas (data_horario_consulta); -- INDICE DO HORARIO DAS CONSULTAS

CREATE INDEX idx_consultas_dentista_especialidade ON consultas (id_dentista, especialidade); -- INDICE DAS ESPECIALIDADES DO DENTISTA DA CONSULTA

-- ##################################################################################################################################################################


-- CONSULTAS:

-- Q1. Quantidade de consultas por especialidade
SELECT especialidade AS Especialidade,
	COUNT(*) AS Todas_as_consultas
FROM consultas
GROUP BY especialidade
ORDER BY Todas_as_consultas ASC;

-- Q2. Quantidade de consultas realizadas por cada dentista
SELECT 
	d.nome_completo_dentista AS Nome_dentista,
	COUNT(c.id_consulta) AS Numero_de_consultas
FROM consultas c
JOIN dentistas d ON c.id_dentista = d.id_dentista
GROUP BY d.nome_completo_dentista
ORDER BY Numero_de_consultas DESC;

-- Q3. Pacientes com maior número de consultas
SELECT p.nome_completo AS Nome_paciente, 
	COUNT(a.id_consulta) AS Numero_de_consultas
FROM agendamentos a
JOIN pacientes p ON a.id_paciente = p.id_paciente
GROUP BY p.nome_completo
ORDER BY Numero_de_consultas DESC;

-- Q4. View com lista de consultas ordenadas por data
CREATE VIEW lista_consultas_ordenadas AS
	SELECT
		c.id_consulta,
		p.nome_completo AS nome_paciente,
		d.nome_completo_dentista AS nome_dentista,
		c.data_horario_consulta AS data_consulta,
		c.prescricao AS procedimentos_realizados
	FROM consultas c
	JOIN agendamentos a ON c.id_consulta = a.id_consulta
	JOIN pacientes p ON a.id_paciente = p.id_paciente
	JOIN dentistas d ON c.id_dentista = d.id_dentista
	ORDER BY data_consulta DESC;

SELECT * FROM lista_consultas_ordenadas;

-- Q5. Média de consultas por dentista
SELECT d.nome_completo_dentista AS Nome_dentistas,
    ROUND (AVG(num_consultas), 2) AS Media_de_consultas
FROM (SELECT c.id_dentista,
		COUNT(c.id_consulta) AS num_consultas
	FROM consultas c
 	GROUP BY c.id_dentista) AS subquery
JOIN dentistas d ON subquery.id_dentista = d.id_dentista
GROUP BY d.nome_completo_dentista;