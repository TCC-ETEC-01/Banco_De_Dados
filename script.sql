CREATE DATABASE dbViagens;
USE dbViagens;

-- tabela cliente
create table tbCliente(
Sexo char(1) not null,
Email varchar(50) not null,
Telefone numeric(11) not null,
IdCliente int auto_increment primary key
);

-- tabela funcionario
create table tbFuncionario(
Sexo char(1) not null,
Email varchar(50) not null,
Telefone numeric(11) not null,
Cargo varchar(50) not null,
IdFuncionario int auto_increment primary key
);

-- tabela pacote
create table tbPacote(
IdPacote int primary key auto_increment,
NomePacote varchar(50) not null,


);
