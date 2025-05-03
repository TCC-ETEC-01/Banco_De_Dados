create database dbViagens;
use dbViagens;

-- tabela cliente
create table tbCliente (
  Nome varchar(50) not null,
  Sexo enum('M', 'F') not null,
  Email varchar(50) not null,
  Telefone numeric(11) not null,
  Cpf char(11) not null,
  IdCliente int auto_increment primary key
);

-- tabela exclusao de cliente
create table tbExclusaoCliente(
  IdCliente int not null,
  IdFuncionario int not null
);

-- tabela funcionario
create table tbFuncionario (
  Nome varchar(50) not null,
  Sexo char(1) not null,
  Email varchar(50) not null,
  Telefone numeric(11) not null,
  Cargo varchar(50) not null,
  Cpf char(11) not null,
  IdFuncionario int auto_increment primary key
);

-- tabela produto 
create table tbProduto (
  IdProduto int auto_increment primary key, 
  NomeProduto varchar(50) not null,
  Valor decimal(10,2) not null,
  Descricao Text not null
);

-- tabela pacote
create table tbPacote (
  IdPacote int auto_increment primary key,
  NomePacote varchar(50) not null,
  Descricao text not null,
  Valor decimal(10,2) not null
);

-- tabela viagem
create table tbViagem (
  IdViagem int auto_increment primary key,
  DataRetorno datetime not null,
  Origem varchar(200) not null,
  Destino varchar(200) not null,
  TipoTransporte enum('Ônibus', 'Avião') not null,
  DataPartida datetime not null
);

-- tabela passagem
create table tbPassagem (
  IdPassagem int auto_increment primary key,
  Assento int not null,
  DataCompra datetime not null,
  IdViagem int not null,
  IdCliente int not null
);


-- criando foreign keys via alter table
alter table tbPassagem
add constraint FkViagem foreign key (IdViagem) references tbViagem(IdViagem),
add constraint FkPassagemCliente foreign key (IdCliente) references tbCliente(IdCliente);

alter table tbExclusaoCliente
add constraint Fk_IdCliente_Excluido foreign key (IdCliente) references tbCliente(IdCliente),
add constraint Fk_IdFuncionario_Excluiu foreign key (IdFuncionario) references tbFuncionario(IdFuncionario);

-- inserts
-- insert cliente
insert into tbCliente(Nome, Sexo, Email, Telefone, Cpf) values(
('João Silva', 'M', 'joao@email.com', 11999998888, 12345678900),
('Maria Souza', 'F', 'maria@email.com', 11988887777, 98765432100),
('Pedro Santos', 'M', 'pedro@email.com', 11977776666, 45678912300)
);
-- insert funcionario
insert into tbFuncionario(Nome, Sexo, Email, Telefone, Cpf, Cargo) values(
('Ana Pereira', 'F', 'ana.pereira@email.com', 11955556666, 11223344556, 'Administrador'),
('Carlos Silva', 'M', 'carlos.silva@email.com', 11944445555, 22334455667, 'Gerente'),
('Juliana Costa', 'F', 'juliana.costa@email.com', 11933334444, 33445566778, 'Vendedor')
);

-- insert pacote
insert into tbPacote (NomePacote, Descricao, Valor) values(
('Pacote Nordeste', 'Viagem para Salvador com hospedagem e café da manhã.', 2500.00),
('Pacote Sul', 'Viagem para Gramado com passeios e hospedagem inclusos.', 3200.50),
('Pacote Europa', 'Pacote completo para Paris com city tour e hotel 5 estrelas.', 12000.00)
);


-- criando procedures
/*
delimiter $$
create procedure ComprarPacote(
in NomePacote varchar(50), 
in IdCliente int 
)
begin
    declare vIdPacote int;
	declare vValorPacote decimal(10,2);
    declare vIdVenda int;
    declare vIdFuncionario int default 1;
    
    -- buscando o id e o valor do pacote
    select IdPacote, Valor
    into vIdPacote, vValorPacote
    from tbPacote
    where tbPacote.NomePacote = NomePacote
    limit 1;
    
    -- criando a venda
  insert into tbVenda (IdCliente, IdFuncionario, DataVenda, Valor)
    values (IdCliente, vIdFuncionario, CURDATE(), vValorPacote);
	
	-- pegando o id da venda recém-criada
    set vIdVenda = 1;
    -- inserindo na nota fiscal
       insert into tbNotaFiscal (IdVenda)
    values (vIdVenda);
end  $$
delimiter ;
*/

-- inner joins
select p.NomeProduto as nome, p.Valor as balor, p.Descricao as descricao
from tbProduto p
inner join tbPacote pa on p.IdProduto = pa.IdProduto;

select c.Nome as nome, c.Sexo as sexo, c.Cpf as cpf, c.Email as email, c.Telefone as telefone
from tbCliente c
inner join tbExclusaoCliente ec on c.IdCliente = ec.IdCliente;

/* c.nome as Nome, p.nomePacote as NomePacote
from tbCliente c
inner join tbVenda v on c.IdCliente = v.IdCliente
inner join tbFuncionario f on f.IdFuncionario = f.IdFuncionario
inner join tbNotaFiscal NF on v.IdVenda = NF.IdVenda
inner join tbPacote p on NF.IdPacote = p.IdPacote;
*/



-- triggers
-- exclusão de cliente
delimiter $$
create trigger exclusao
before delete on tbCliente
for each row
begin
	insert into tbExclusaoCliente(
		IdCliente
    )
	values(
    old.IdCliente
    );
    end $$
delimiter ;
