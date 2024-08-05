
-- (curiosidades) utilizado varchar 40 pois o maior nome taxonomico é 39 caracteres para a planta:
-- Mimosa pudica var. unijuga 'alba' forma paucijuga chamada de "Mimosa Gigante".



CREATE EXTENSION IF NOT EXISTS postgis;


CREATE TABLE reinos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE filos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE,
    reino_id INT REFERENCES reinos(id) ON DELETE CASCADE
);

CREATE TABLE classes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE,
    filo_id INT REFERENCES filos(id) ON DELETE CASCADE
);

CREATE TABLE ordens (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE,
    classe_id INT REFERENCES classes(id) ON DELETE CASCADE
);

CREATE TABLE familias (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE,
    ordem_id INT REFERENCES ordens(id) ON DELETE CASCADE
);

CREATE TABLE generos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(40) NOT NULL UNIQUE,
    familia_id INT REFERENCES familias(id) ON DELETE CASCADE
);

CREATE TABLE especies (
    id SERIAL PRIMARY KEY,
    nome_cientifico VARCHAR(40) NOT NULL UNIQUE,
    nome_comum VARCHAR(40),
    descricao TEXT,
    status_conservacao VARCHAR(25),
    comportamento_migratorio VARCHAR(50),
    grupo_taxonomico VARCHAR(50),
    regiao_endemica VARCHAR(100),
    genero_id INT REFERENCES generos(id) ON DELETE CASCADE
);


CREATE TABLE localizacao (
    id SERIAL PRIMARY KEY,
    coordenadas GEOMETRY(Polygon, 4326) NOT NULL,
    descricao TEXT,
    altitude FLOAT CHECK (altitude >= 0),
    regiao VARCHAR(100) CHECK (regiao != ''),
    area_protegida BOOLEAN NOT NULL DEFAULT FALSE,
    area_desmatada BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT unique_coordenadas UNIQUE (coordenadas)
);

CREATE TABLE observacoes (
    id SERIAL PRIMARY KEY,
    especie_id INT REFERENCES especies(id) ON DELETE CASCADE,
    localizacao_id INT REFERENCES localizacao(id) ON DELETE CASCADE,
    data_hora TIMESTAMP NOT NULL,
    observador VARCHAR(150),
    notas TEXT
);


CREATE TABLE doencas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    taxa_mortalidade FLOAT CHECK (taxa_mortalidade >= 0 AND taxa_mortalidade <= 100)
);

CREATE TABLE especie_doencas (
    id SERIAL PRIMARY KEY,
    especie_id INT REFERENCES especies(id) ON DELETE CASCADE,
    doenca_id INT REFERENCES doencas(id) ON DELETE CASCADE
);

CREATE TABLE tipos_interacoes (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(30) NOT NULL CHECK (tipo IN ('Predação', 'Parasitismo', 'Mutualismo', 'Comensalismo', 'Competição', 'Amensalismo', 'Neutralismo', 'Simbiose', 'Cooperação', 'Antagonismo'))
);

CREATE TABLE interacoes (
    id SERIAL PRIMARY KEY,
    especie1_id INT REFERENCES especies(id) ON DELETE CASCADE,
    especie2_id INT REFERENCES especies(id) ON DELETE CASCADE,
    tipo_interacao_id INT REFERENCES tipos_interacoes(id) ON DELETE CASCADE,
    descricao TEXT
);


CREATE TABLE habitats (
    id SERIAL PRIMARY KEY,
    descricao TEXT
);

CREATE TABLE especie_habitats (
    id SERIAL PRIMARY KEY,
    especie_id INT REFERENCES especies(id) ON DELETE CASCADE,
    habitat_id INT REFERENCES habitats(id) ON DELETE CASCADE
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


CREATE TABLE populacao_especies (
    id SERIAL PRIMARY KEY,
    especie_id INT REFERENCES especies(id) ON DELETE CASCADE,
    ano INT NOT NULL,
    populacao_estimada INT,
    observacoes TEXT
);

CREATE TABLE altura_voo (
    id SERIAL PRIMARY KEY,
    especie_id INT REFERENCES especies(id) ON DELETE CASCADE,
    altura_minima FLOAT CHECK (altura_minima >= 0),
    altura_maxima FLOAT CHECK (altura_maxima >= 0),
    media_altura FLOAT GENERATED ALWAYS AS ((altura_minima + altura_maxima) / 2) STORED,
    descricao TEXT
);

CREATE TABLE interacoes_ecologicas (
    id SERIAL PRIMARY KEY,
    especie_id_1 INT REFERENCES especies(id) ON DELETE CASCADE,
    especie_id_2 INT REFERENCES especies(id) ON DELETE CASCADE,
    tipo_interacao VARCHAR(50),
    descricao TEXT,
    CONSTRAINT unique_interaction UNIQUE (especie_id_1, especie_id_2, tipo_interacao)
);
