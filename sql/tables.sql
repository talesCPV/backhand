use d2soft98_backhand;
use backha49_main_db;

-- DROP TABLE tb_sport;
CREATE TABLE tb_sport (
    id int(11) NOT NULL AUTO_INCREMENT,
    nome varchar(15) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_evento;
CREATE TABLE tb_evento (
    id int(11) NOT NULL AUTO_INCREMENT,
    nome varchar(15) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_usuario;
CREATE TABLE tb_usuario (
    id int(11) NOT NULL AUTO_INCREMENT,
    email varchar(70) NOT NULL,
    hash varchar(77) NOT NULL,
    nome varchar(60) NOT NULL,
    nick varchar(15) DEFAULT NULL,
    cel varchar(14) DEFAULT NULL,
    class int(11) DEFAULT 0,
	lat double DEFAULT NULL,
    lng double DEFAULT NULL,
    nivel double DEFAULT 1,
    cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	UNIQUE KEY (hash),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

ALTER TABLE tb_usuario
ADD COLUMN cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- DROP TABLE tb_quadra;
CREATE TABLE tb_quadra (
    id int(11) NOT NULL AUTO_INCREMENT,
    nome varchar(30) NOT NULL,
    lat double NOT NULL,
    lng double NOT NULL,
    tipo varchar(10) DEFAULT "tennis",    
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_minhasquadras;
CREATE TABLE tb_minhasquadras (
    id_usuario int(11) NOT NULL,
    id_quadra int(11) NOT NULL, 
	FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
	FOREIGN KEY (id_quadra) REFERENCES tb_quadra(id),    
    PRIMARY KEY (id_usuario,id_quadra)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_atividades;
CREATE TABLE tb_atividades (
  id int(11) NOT NULL AUTO_INCREMENT,
  id_usuario int(11) NOT NULL,
  id_quadra int(11) NOT NULL,
  id_sport int(11) NOT NULL,
  id_evento int(11) NOT NULL,
  nome varchar(30) NOT NULL,
  dia datetime NOT NULL,
  duracao DOUBLE NOT NULL,
  ranking BOOLEAN DEFAULT FALSE,
  amistoso BOOLEAN DEFAULT TRUE,
  peso double DEFAULT 0,
  nao_usuario varchar(50) DEFAULT NULL,
  FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
  FOREIGN KEY (id_quadra) REFERENCES tb_quadra(id),
  FOREIGN KEY (id_sport) REFERENCES tb_sport(id),
  FOREIGN KEY (id_evento) REFERENCES tb_evento(id),
  PRIMARY KEY (id)
)ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

ALTER TABLE tb_atividades
ADD COLUMN amistoso BOOLEAN DEFAULT TRUE;

 DROP TABLE tb_ativ_guest;
CREATE TABLE tb_ativ_guest (
	id int(11) NOT NULL,
    id_ativ int(11) NOT NULL,
    team varchar(1) NOT NULL DEFAULT "A", 
    nome varchar(30) NOT NULL,
	FOREIGN KEY (id_ativ) REFERENCES tb_atividades(id),
    PRIMARY KEY (id,id_ativ)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_ativ_atleta;
CREATE TABLE tb_ativ_atleta (
  id_ativ int(11) NOT NULL,
  id_atleta int(11) NOT NULL,
  ativ_owner BOOLEAN DEFAULT FALSE,
  team varchar(1) NOT NULL DEFAULT "A",
  confirm BOOLEAN DEFAULT FALSE,
  ask BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (id_atleta) REFERENCES tb_usuario(id),
  FOREIGN KEY (id_ativ) REFERENCES tb_atividades(id),
  PRIMARY KEY (id_ativ,id_atleta)
)ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_kudos;
CREATE TABLE tb_kudos (
    id_usuario int(11) NOT NULL,
    id_atividade int(11) NOT NULL, 
	FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
	FOREIGN KEY (id_atividade) REFERENCES tb_atividades(id),
    PRIMARY KEY (id_usuario,id_atividade)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_message;
CREATE TABLE tb_message (
	id int(11) NOT NULL AUTO_INCREMENT,
    id_usuario int(11) NOT NULL,
    id_atividade int(11) NOT NULL, 
    scrap varchar(600) DEFAULT NULL,
	FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
	FOREIGN KEY (id_atividade) REFERENCES tb_atividades(id),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_sets;
CREATE TABLE tb_sets (
	id int(11) NOT NULL,
    id_atividade int(11) NOT NULL, 
    p1_score int(11) NOT NULL DEFAULT 0,
    p2_score int(11) NOT NULL DEFAULT 0,
    obs varchar(255) DEFAULT NULL,
	FOREIGN KEY (id_atividade) REFERENCES tb_atividades(id),
    PRIMARY KEY (id,id_atividade)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_following;
CREATE TABLE tb_following (
	id_host int(11) NOT NULL,
    id_guest int(11) NOT NULL,
	FOREIGN KEY (id_host) REFERENCES tb_usuario(id),
	FOREIGN KEY (id_guest) REFERENCES tb_usuario(id),
    PRIMARY KEY (id_host,id_guest)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

INSERT INTO tb_following VALUES (3,1);

-- DROP TABLE tb_equip;
CREATE TABLE tb_equip (
	id int(11) NOT NULL AUTO_INCREMENT,
    id_owner int(11) NOT NULL,
    descricao varchar(15) DEFAULT "RAQUETE",
    marca varchar(15) DEFAULT NULL,
    aquisicao date DEFAULT NULL,
    ativo boolean DEFAULT TRUE,
    obs varchar(255) DEFAULT NULL,
	FOREIGN KEY (id_owner) REFERENCES tb_usuario(id),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_equip_manut;
CREATE TABLE tb_equip_manut (
	id int(11) NOT NULL AUTO_INCREMENT,
    id_equip int(11) NOT NULL, 
    servico varchar(40) DEFAULT NULL,    
    data date DEFAULT NULL,
    obs varchar(255) DEFAULT NULL,
	FOREIGN KEY (id_equip) REFERENCES tb_equip(id),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

 DROP TABLE tb_torneio;
CREATE TABLE tb_torneio (
	id int(11) NOT NULL AUTO_INCREMENT,
    id_owner int(11) NOT NULL, 
    nome varchar(50) NOT NULL DEFAULT NULL,
    modelo int DEFAULT 1,    
    num_players int DEFAULT 4,
    num_grupos int DEFAULT 0,
    playOff int DEFAULT 0,
    regras varchar(1000) DEFAULT NULL,
    criado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status int DEFAULT 0,
	FOREIGN KEY (id_owner) REFERENCES tb_usuario(id),
	FOREIGN KEY (id_quadras) REFERENCES tb_quadra(id),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

ALTER TABLE tb_torneio
ADD COLUMN id_quadras int(11) NOT NULL;

 DROP TABLE tb_jogo;
CREATE TABLE tb_jogo (
	id int NOT NULL,
    id_torn int(11) NOT NULL, 
    id_P1 int(11) DEFAULT NULL,
    id_P2 int(11) DEFAULT NULL,
    P1_nome varchar(30) DEFAULT NULL,
    P2_nome varchar(30) DEFAULT NULL,    
    P1_score int DEFAULT 0,
    P2_score int DEFAULT 0,
	id_Ativ int(11) DEFAULT NULL,
    grupo int DEFAULT 1,
    data date DEFAULT NULL,    
	FOREIGN KEY (id_torn) REFERENCES tb_torneio(id),
	FOREIGN KEY (id_P1) REFERENCES tb_usuario(id),
	FOREIGN KEY (id_P2) REFERENCES tb_usuario(id),
    PRIMARY KEY (id,id_torn)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

ALTER TABLE tb_jogo
ADD COLUMN data date DEFAULT NULL;

-- DROP TABLE tb_torn_gamesets;
CREATE TABLE tb_torn_gamesets (
	id int NOT NULL,
    id_torn int(11) NOT NULL,
    id_jogo int(11) NOT NULL,
    P1_score int DEFAULT 0,
    P2_score int DEFAULT 0,
	FOREIGN KEY (id_torn) REFERENCES tb_torneio(id),
	FOREIGN KEY (id_jogo) REFERENCES tb_jogo(id),
    PRIMARY KEY (id,id_torn, id_jogo)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;


 DROP TABLE tb_torn_atleta;
CREATE TABLE tb_torn_atleta (
	id int NOT NULL,
    id_torn int(11) NOT NULL, 
    id_atleta int(11) DEFAULT NULL,
    nome_atleta VARCHAR(30) DEFAULT NULL,
    nivel_atleta double DEFAULT NULL,
    accept BOOLEAN DEFAULT NULL,
	ask BOOLEAN DEFAULT 1,  
	FOREIGN KEY (id_torn) REFERENCES tb_torneio(id),
	FOREIGN KEY (id_atleta) REFERENCES tb_usuario(id),
    PRIMARY KEY (id,id_torn)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

-- DROP TABLE tb_torn_quadra;
CREATE TABLE tb_torn_quadra (
    id_torn int(11) NOT NULL,
    id_quadra int(11) NOT NULL, 
	FOREIGN KEY (id_torn) REFERENCES tb_torn(id),
	FOREIGN KEY (id_quadra) REFERENCES tb_quadra(id),    
    PRIMARY KEY (id_torn,id_quadra)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

