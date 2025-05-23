-- drop database dbAnu;
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
  Senha char(8) not null,
  IdFuncionario int auto_increment primary key
);

create table tbProduto (
  IdProduto int auto_increment primary key, 
  NomeProduto varchar(50) not null,
  Valor decimal(8,2) not null,
  Descricao Text not null,
  Quantidade int not null
);

create table tbPacote (
  IdPacote int auto_increment primary key,
  IdProduto int not null,
  IdPassagem int not null,
  NomePacote varchar(50) not null,
  Descricao text not null,
  Valor decimal(8,2) not null
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

create table tbPassagem (
  IdPassagem int auto_increment primary key,
  Assento char(5) not null,
  Valor decimal(8,2) not null,
  DataCompra datetime,
  IdViagem int not null,
  IdCliente int,
  Situacao varchar(50)
);

create table tbLogs(
	Usuario varchar(50) not null,
    DataLog timestamp default current_timestamp not null,
    Acao Text not null
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
insert into tbCliente (Nome, Sexo, Email, Telefone, Cpf) values
('Ana Silva', 'F', 'ana@gmail.com', '11987654321', '12345678901'),
('Carlos Souza', 'M', 'carlos@hotmail.com', '21987654321', '23456789012'),
('Beatriz Costa', 'F', 'bea@yahoo.com', '11911223344', '34567890123'),
('Diego Ramos', 'M', 'diego@outlook.com', '11955667788', '45678901234');
  

-- insert funcionario
INSERT INTO tbFuncionario (Nome, Sexo, Email, Telefone, Cargo, Cpf, Senha) VALUES
('João Pedro', 'M', 'joao@empresa.com', '31987654321', 'Atendente', '56789012345', 'abc12345'),
('Mariana Lima', 'F', 'mariana@empresa.com', '41987654321', 'Gerente', '67890123456', 'def67890'),
('Rafael Torres', 'M', 'rafa@empresa.com', '51987654321', 'Consultor', '78901234567', 'ghi45678'),
('Larissa Mendes', 'F', 'larissa@empresa.com', '61987654321', 'Vendedora', '89012345678', 'jkl98765');

-- insert produto
insert into tbProduto (NomeProduto, Valor, Descricao, Quantidade) values
('Passeio de Lancha', 299.99, 'Passeio de lancha de 2 horas', 10),
('Trilha na Mata', 150.00, 'Trilha com guia turístico', 25),
('Mergulho com Cilindro', 400.00, 'Experiência de mergulho com instrutor', 5),
('Tour Gastronômico', 180.00, 'Visita a restaurantes típicos com guia', 15);

-- insert viagem
insert into tbViagem (DataRetorno, Descricao, Origem, Destino, TipoTransporte, DataPartida) values
('2025-07-20 18:00:00', 'Viagem ao litoral com paradas em praias.', 'São Paulo', 'Ubatuba', 'Ônibus', '2025-07-18 08:00:00'),
('2025-08-10 22:00:00', 'Pacote aéreo para o nordeste brasileiro.', 'Rio de Janeiro', 'Salvador', 'Avião', '2025-08-05 10:30:00'),
('2025-09-15 21:00:00', 'Excursão para trilhas ecológicas.', 'Belo Horizonte', 'Chapada dos Veadeiros', 'Ônibus', '2025-09-10 06:00:00'),
('2025-12-01 20:00:00', 'Viagem de fim de ano com festas e passeios.', 'Curitiba', 'Florianópolis', 'Ônibus', '2025-11-28 09:00:00');


-- insert passagem
insert into tbPassagem (Assento, Valor, DataCompra, IdViagem, IdCliente, Situacao) values
('12A', 180.00, '2025-06-01 14:00:00', 1, 1, 'Confirmada'),
('7C', 450.00, '2025-06-02 10:00:00', 2, 2, 'Confirmada'),
('18B', 300.00, '2025-06-05 11:00:00', 3, 3, 'Pendente'),
('5D', 250.00, '2025-06-07 16:00:00', 4, 4, 'Confirmada');


-- insert pacote
insert into tbPacote (IdProduto, IdPassagem, NomePacote, Descricao, Valor) values
(1, 1, 'Pacote Litoral Plus', 'Inclui passeio de lancha e transporte ida e volta.', 479.99),
(2, 2, 'Pacote Trilha Nordeste', 'Inclui trilha e transporte aéreo.', 599.99),
(3, 3, 'Pacote Mergulho Top', 'Mergulho com cilindro + hospedagem.', 699.99),
(4, 4, 'Pacote Gourmet Sul', 'Tour gastronômico e transporte.', 420.00);

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

delimiter $$
create procedure DeletarClientePassagem(
in p_IdCliente int
)
	begin
		update tbPassagem
        set IdCliente = null
        where IdCliente = p_IdCliente;
        
        delete from tbCliente
        where IdCliente = p_IdCliente;
	end $$
    delimiter ;
call DeletarClientePassagem(1);
select * from tbPassagem;
select * from tbLogs;

delimiter $$
create procedure DeletarPassagemPacote(
in p_IdPassagem int,
in p_IdPacote int
)
	begin
		delete from tbPacote
        where IdPacote = p_IdPacote;
        
        delete from tbPassagem
        where IdPassagem = p_IdPassagem;
	end $$
    delimiter ;
    call DeletarPassagemPacote(1, 1);
    select * from tbPacote;
    select * from tbPassagem;
    
    delimiter $$
create procedure DeletarProdutoPacote(
in p_IdProduto int,
in p_IdPacote int
)
	begin
		delete from tbPacote
        where IdPacote = p_IdPacote;
        
        delete from tbProduto
        where IdProduto = p_IdProduto;
	end $$
    delimiter ;
    call DeletarProdutoPacote(2,2);
    select * from tbPacote;
    select * from tbProduto;
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

select p.IdPassagem, p.Assento, p.Valor as ValorPassagem, p.Situacao,
       pac.NomePacote, pac.Valor as ValorPacote
from tbPassagem p
left join tbPacote pac on p.IdPassagem = pac.IdPassagem;

select pac.IdPacote, pac.NomePacote, prod.NomeProduto, prod.Valor as ValorProduto
from tbPacote pac
inner join tbProduto prod on pac.IdProduto = prod.IdProduto;

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
select * from tbLogs;

-- trigger exclusão
delimiter $$
create trigger deleteCliente
before delete on tbCliente
	for each row
		begin
        insert into tbLogs(Usuario, DataLog, Acao) values (current_user(), now(),  concat('Cliente excluído: ID ', old.IdCliente, ' - Nome: ', old.Nome));
        end $$
delimiter ;

