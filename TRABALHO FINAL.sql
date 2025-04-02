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
	id_paciente INT PRIMARY KEY,
	nome_completo VARCHAR(100) NOT NULL,
	CPF VARCHAR(14) UNIQUE NOT NULL,
	telefone VARCHAR(15),
	email VARCHAR(100) UNIQUE NOT NULL,
	endereco VARCHAR(200) NOT NULL,
	data_nascimento DATE NOT NULL
);

-- Tabela Atendentes:
CREATE TABLE atendentes (
	id_atendente INT PRIMARY KEY,
	nome_atendente VARCHAR(100) NOT NULL,
	email_atendente VARCHAR(100) UNIQUE NOT NULL,
	CPF VARCHAR(14) UNIQUE NOT NULL,
	senha VARCHAR(100) NOT NULL
);

-- Tabela Dentistas:
CREATE TABLE dentistas (
	id_dentista INT PRIMARY KEY,
	CPF VARCHAR(14) UNIQUE NOT NULL,
	CRO VARCHAR(20) UNIQUE NOT NULL,
	nome_completo_dentista VARCHAR(100) NOT NULL,
	especialidade_dentista VARCHAR(100) NOT NULL
);

-- Tabela Consultas:
CREATE TABLE consultas (
	id_consulta SERIAL PRIMARY KEY,
	id_dentista SERIAL,
	data_horario_consulta DATE NOT NULL,
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
	id_procedimento serial PRIMARY KEY,
	id_dentista serial,
	nome_procedimento varchar(30) NOT NULL,
	descricao varchar(200) NOT NULL,
	duracao_media int NOT NULL,
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

-- ##################################################################################################################################################################

-- ALIMENTANDO AS TABELAS:

