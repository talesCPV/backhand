use d2soft98_backhand;

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
	UNIQUE KEY (hash),
    PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=utf8;

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
  nome varchar(30) NOT NULL,
  id_sport int(11) NOT NULL,
  id_evento int(11) NOT NULL,
  parceiro varchar(30) NOT NULL,
  dia datetime NOT NULL,
  duracao DOUBLE NOT NULL,
  id_quadra int(11) NOT NULL,
  FOREIGN KEY (id_usuario) REFERENCES tb_usuario(id),
  FOREIGN KEY (id_quadra) REFERENCES tb_quadra(id),
  FOREIGN KEY (id_sport) REFERENCES tb_sport(id),
  FOREIGN KEY (id_evento) REFERENCES tb_evento(id),
  PRIMARY KEY (id)
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

