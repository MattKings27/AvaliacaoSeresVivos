
-- (curiosidades) utilizado varchar 40 pois o maior nome taxonomico é 39 caracteres para a planta:
-- Mimosa pudica var. unijuga 'alba' forma paucijuga chamada de "Mimosa Gigante".



-- extensão para utilização do geometry
CREATE EXTENSION IF NOT EXISTS postgis;


CREATE TABLE reinos (
id SERIAL PRIMARY KEY,
 nome varchar(40) NOT NULL
);

CREATE TABLE filos (
id SERIAL PRIMARY KEY,
  nome varchar(40) NOT NULL,
 reino_id INT REFERENCES reinos(id) ON DELETE CASCADE
);

CREATE TABLE classes (
id SERIAL PRIMARY KEY,
 nome varchar(40) NOT NULL,
  filo_id INT REFERENCES filos(id) ON DELETE CASCADE
);

CREATE TABLE ordens (
id SERIAL PRIMARY KEY,
 nome varchar(40) NOT NULL,
  classe_id int REFERENCES classes(id) ON DELETE CASCADE
);

CREATE TABLE familias (
id serial PRIMARY KEY,
 nome varchar(40) NOT NULL,
  ordem_id int REFERENCES ordens(id) ON DELETE CASCADE
);

CREATE TABLE generos (
id serial PRIMARY KEY,
 nome varchar(40) NOT NULL,
  familia_id int REFERENCES familias(id) ON DELETE CASCADE
);

CREATE TABLE especies (
 id SERIAL PRIMARY KEY,
nome_cientifico Varchar(40) NOT NULL,
nome_comum VARCHAR(40),
 descricao text,
 status_conservacao varchar(25),
 genero_id int REFERENCES generos(id) ON DELETE CASCADE
);



CREATE TABLE doencas (
id SERIAL PRIMARY KEY,
 nome VARCHAR(50) NOT NULL,
 descricao text,
 taxa_mortalidade float
);

CREATE TABLE especie_doencas (
id SERIAL PRIMARY KEY,
 especie_id int REFERENCES especies(id) ON DELETE CASCADE,
  doenca_id int REFERENCES doencas(id) ON DELETE CASCADE
	 afeta_humanos BOOLEAN DEFAULT TRUE
);

CREATE table tipos_interacoes (
id SERIAL PRIMARY KEY,
 tipo Varchar(30) NOT NULL CHECK (tipo IN ('Predação', 'Parasitismo', 'Mutualismo', 'Comensalismo', 'Competição', 'Amensalismo', 'Neutralismo', 'Simbiose', 'Cooperação', 'Antagonismo' ))
);

CREATE TABLE interacoes (
id SERIAL PRIMARY KEY,
especie1_id int REFERENCES especies(id) ON DELETE CASCADE,
 especie2_id INT REFERENCES especies(id) ON DELETE CASCADE,
  tipo_interacao_id INT REFERENCES tipos_interacoes(id) ON DELETE CASCADE,
  descricao text
);

CREATE TABLE habitats (
id SERIAL PRIMARY KEY,
  descricao text
);

CREATE TABLE especie_habitats (
id SERIAL PRIMARY KEY,
 especie_id int REFERENCES especies(id) ON DELETE CASCADE,
  habitat_id int REFERENCES habitats(id) ON DELETE CASCADE
);

CREATE TABLE localizacao (
id SERIAL PRIMARY KEY,
coordenadas GEOMETRY NOT NULL,
 descricao text,
 altitude float,
 area_protegida Boolean,
 area_desmatada Boolean
);

CREATE TABLE observacoes (
id SERIAL PRIMARY KEY,
especie_id INT REFERENCES especies(id) ON DELETE CASCADE,
 localizacao_id INT REFERENCES localizacao(id) ON DELETE CASCADE,
 data_hora TIMESTAMP NOT NULL,
observador VARCHAR(150),
 notas TEXT
);


CREATE TABLE diversidade_genetica (
id SERIAL PRIMARY KEY,
 especie_id INT REFERENCES especies(id) ON DELETE CASCADE,
 localizacao_id INT REFERENCES localizacao(id) ON DELETE CASCADE,
 diversidade_genetica FLOAT
);

CREATE TABLE polinizadores (
id SERIAL PRIMARY KEY,
 especie_id INT REFERENCES especies(id) ON DELETE CASCADE,
  comprimento_proboscide FLOAT
);

CREATE TABLE plantas_polinizadas (
id SERIAL PRIMARY KEY,
 especie_id INT REFERENCES especies(id) ON DELETE CASCADE,
  tamanho_corola FLOAT,
  polinizador_id INT REFERENCES polinizadores(id) ON DELETE CASCADE
);

CREATE TABLE macroinvertebrados (
id SERIAL PRIMARY KEY,
 especie_id INT REFERENCES especies(id) ON DELETE CASCADE
);

CREATE TABLE efeitos_pesticidas (
id SERIAL PRIMARY KEY,
pesticida VARCHAR(150) NOT NULL,
macroinvertebrado_id INT REFERENCES macroinvertebrados(id) ON DELETE CASCADE,
reducao_abundancia FLOAT,
localizacao_id INT REFERENCES localizacao(id) ON DELETE CASCADE
);