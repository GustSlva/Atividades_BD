-- Pessoa: dados das pessoas que podem ser paciente e/ou médicos
CREATE TABLE IF NOT EXISTS Pessoa  (
    cpf        CHAR(11)     NOT NULL,
    email      VARCHAR(50)  NOT NULL,
    nome       VARCHAR(150) NOT NULL,
    data_nasc  DATE         NOT NULL,
    endereco   VARCHAR(300) NOT NULL,
    telefone   VARCHAR(15)  NULL,
    CONSTRAINT pk_pessoa PRIMARY KEY (cpf),
    CONSTRAINT pessoa_un UNIQUE (email, nome)
);

-- Paciente: especialização de Pessoa
CREATE TABLE IF NOT EXISTS Paciente (
    codigo       INTEGER      NOT NULL,
    cpf          CHAR(11)     NOT NULL,
    senha        VARCHAR(10)  NOT NULL,
    plano_saude  BOOLEAN      NOT NULL,
    CONSTRAINT pk_paciente PRIMARY KEY (codigo),
    CONSTRAINT paciente_cpf_un UNIQUE (cpf),
    CONSTRAINT fk_paciente_pessoa FOREIGN KEY (cpf) REFERENCES Pessoa (cpf),
    -- senha alfanumérica com 5 a 10 símbolos
    CONSTRAINT ck_paciente_senha CHECK (senha ~ '^[A-Za-z0-9]{5,10}$')
);

-- Médico: especialização de Pessoa
CREATE TABLE IF NOT EXISTS Medico (
    crm  VARCHAR(10) NOT NULL,
    cpf  CHAR(11)    NOT NULL,
    CONSTRAINT pk_medico PRIMARY KEY (crm),
    CONSTRAINT medico_cpf_un UNIQUE (cpf),
    CONSTRAINT fk_medico_pessoa FOREIGN KEY (cpf) REFERENCES Pessoa (cpf)
);

-- Especialidade
CREATE TABLE IF NOT EXISTS Especialidade (
    id         INTEGER      NOT NULL,
    descricao  VARCHAR(100) NOT NULL,
    CONSTRAINT pk_especialidade PRIMARY KEY (id)
);

-- Relação N:N Médico x Especialidade ("possui")
CREATE TABLE IF NOT EXISTS Medico_Especialidade (
    crm               VARCHAR(10) NOT NULL,
    id_especialidade  INTEGER     NOT NULL,
    CONSTRAINT pk_medico_especialidade PRIMARY KEY (crm, id_especialidade),
    CONSTRAINT fk_me_medico FOREIGN KEY (crm) REFERENCES Medico (crm),
    CONSTRAINT fk_me_especialidade FOREIGN KEY (id_especialidade) REFERENCES Especialidade (id)
);

-- Agendamento: Paciente x Médico em uma data/hora
CREATE TABLE IF NOT EXISTS Agendamento (
    codigo_paciente  INTEGER       NOT NULL,
    crm              VARCHAR(10)   NOT NULL,
    dt_consulta      TIMESTAMP     NOT NULL,
    dt_agendamento   TIMESTAMP     NOT NULL,
    valor_consulta   NUMERIC(10,2) NOT NULL,
    CONSTRAINT pk_agendamento PRIMARY KEY (codigo_paciente, crm, dt_consulta),
    CONSTRAINT fk_agend_paciente FOREIGN KEY (codigo_paciente) REFERENCES Paciente (codigo),
    CONSTRAINT fk_agend_medico FOREIGN KEY (crm) REFERENCES Medico (crm),
    CONSTRAINT ck_agend_valor CHECK (valor_consulta >= 0),
    CONSTRAINT ck_agend_datas CHECK (dt_agendamento <= dt_consulta)
);