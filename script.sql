drop database dbAnu;
create database dbAnu;
use dbAnu;
show tables;

-- tabela cliente
create table tbCliente (
  Nome varchar(50) not null,
  Sexo enum('M', 'F') not null,
  Email varchar(50) not null,
  Telefone char(11) not null,
  Cpf char(11) not null,
  IdCliente int auto_increment primary key
);

create table tbFuncionario (
  Nome varchar(50) not null,
  Sexo enum('M', 'F') not null,
  Email varchar(50) not null,
  Telefone char(11) not null,
  Cargo varchar(50) not null,
  Cpf char(11) not null,
  IdFuncionario int auto_increment primary key
);

create table tbProduto (
  IdProduto int auto_increment primary key, 
  NomeProduto varchar(50) not null,
  Valor decimal(10,2) not null,
  Descricao Text not null
);

create table tbPacote (
  IdPacote int auto_increment primary key,
  IdProduto int not null,
  IdPassagem int not null,
  NomePacote varchar(50) not null,
  Descricao text not null,
  Valor decimal(10,2) not null
);

create table tbViagem (
  IdViagem int auto_increment primary key,
  DataRetorno datetime not null,
  Descricao text not null,
  Origem varchar(200) not null,
  Destino varchar(200) not null,
  TipoTransporte enum('Ônibus', 'Avião') not null,
  DataPartida datetime not null
);

drop table tbPassagem;
create table tbPassagem (
  IdPassagem int auto_increment primary key,
  Assento chaR(5) not null,
  Valor decimal(10,2) not null,
  DataCompra datetime,
  IdViagem int not null,
  IdCliente int,
  Situacao varchar(50)
);

create table tbLogs(
	Usuario varchar(50),
    DataLog datetime,
    Acao varchar(50)
);
-- criando foreign keys via alter table
alter table tbPassagem
add constraint FkViagem foreign key (IdViagem) references tbViagem(IdViagem),
add constraint FkPassagemCliente foreign key (IdCliente) references tbCliente(IdCliente);

alter table tbPacote 
add constraint FkPassagemPacote foreign key(IdPassagem) references tbPassagem(IdPassagem),
add constraint FkProdutoPacote foreign key(IdProduto) references tbProduto(IdProduto);

-- inserts
-- insert cliente
insert into tbCliente(Nome, Sexo, Email, Telefone, Cpf) values(
'João Silva', 'M', 'joao@email.com', '11999998888', '12345678900'),
('Maria Souza', 'F', 'maria@email.com', 11988887777, 98765432100),
('Pedro Santos', 'M', 'pedro@email.com', 11977776666, 45678912300);


-- insert funcionario
insert into tbFuncionario(Nome, Sexo, Email, Telefone, Cpf, Cargo) values(
'Ana Pereira', 'F', 'ana.pereira@email.com', 11955556666, 11223344556, 'Administrador'),
('Carlos Silva', 'M', 'carlos.silva@email.com', 11944445555, 22334455667, 'Gerente'),
('Juliana Costa', 'F', 'juliana.costa@email.com', 11933334444, 33445566778, 'Vendedor');
-- insert passagem
insert into tbPassagem (IdViagem, IdCliente, Assento, Valor, Situacao)
values (1, null, '12A', 750.00, 'Disponível');
-- insert viagem
insert into tbViagem (DataRetorno, Descricao, Origem, Destino, TipoTransporte, DataPartida)
values 
('2025-05-20 14:00:00', 'Viagem para o Rio de Janeiro com hospedagem e city tour', 'São Paulo', 'Rio de Janeiro', 'Ônibus', '2025-05-18 08:00:00'),
('2025-06-10 18:00:00', 'Passagem aérea para Buenos Aires com pacote completo', 'São Paulo', 'Buenos Aires', 'Avião', '2025-06-08 12:00:00'),
('2025-07-01 16:00:00', 'Excursão para Foz do Iguaçu com guias especializados', 'Curitiba', 'Foz do Iguaçu', 'Ônibus', '2025-06-29 07:00:00');
-- insert pacote
insert into tbPacote (IdProduto, IdPassagem, NomePacote, Descricao, Valor)
values
(1, 1, 'Pacote Verão 2025', 'Pacote completo para a viagem de verão com passagens e hospedagem', 1500.00);
-- insert produto
insert into tbProduto (NomeProduto, Descricao, Valor)
values
('Camiseta Estampada', 'Camiseta de algodão com estampa exclusiva da marca.', 59.90);

-- selects
select * from tbPassagem;
select * from tbProduto;
select * from tbPacote;
select * from tbCliente;
select * from tbFuncionario;
select * from tbViagem;
select * from tbLogs;

-- criando procedures
delimiter $$
create procedure situacaoPassagem(
in Id int 
)
	begin
	
		select * from tbPassagem
        where IdCliente is null and Situacao = 'Disponivel';
    end $$
    delimiter ;
call situacaoPassagem(0);
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
select p.NomeProduto as nomeProd, p.Valor as valorProd, p.Descricao as descricaoProd, pass.Assento as assento, pass.Valor as valor, pass.Situacao as situacao
from tbProduto p
inner join tbPacote pa on p.IdProduto = pa.IdProduto
inner join tbPassagem pass on pa.IdPacote = pass.IdPassagem;


/* c.nome as Nome, p.nomePacote as NomePacote
from tbCliente c
inner join tbVenda v on c.IdCliente = v.IdCliente
inner join tbFuncionario f on f.IdFuncionario = f.IdFuncionario
inner join tbNotaFiscal NF on v.IdVenda = NF.IdVenda
inner join tbPacote p on NF.IdPacote = p.IdPacote;
*/

-- triggers
delimiter $$
create trigger updateCliente
after update on tbCliente
for each row
begin
	  insert into tbLogs (Usuario, DataLog, Acao)
    values (current_user(), now(), concat('Cliente atualizado: ID ', old.IdCliente, 
           ' | Nome antigo: ', old.Nome, ' → Novo nome: ', new.Nome));
end $$
delimiter ;
update tbCliente 
set Nome = 'João Silva Oliveira', 
    Email = 'joao.novo@email.com'
where IdCliente = 1;  -- Alterando os dados do cliente com ID 1

-- trigger exclusão
delimiter $$
create trigger deleteCliente
before delete on tbCliente
	for each row
		begin
        insert into tbLogs(Usuario, DataLog, Acao) values (current_user(), now(),  concat('Cliente excluído: ID ', old.IdCliente, ' - Nome: ', old.Nome));
        end $$
delimiter ;
delete from tbCliente where IdCliente = 1;