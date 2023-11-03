CREATE TABLE TB_TIPO_DOMINIO (
    IDENT BIGINT NOT NULL,
    DS_TIPO VARCHAR(150),
    DT_CADASTRO TIMESTAMP NOT NULL,
    COD_TIPO_DOMINIO VARCHAR(70) NOT NULL,
    PRIMARY KEY (IDENT),
    CONSTRAINT UNIQUE_COD_TIPO_DOMINIO UNIQUE(COD_TIPO_DOMINIO)
);

CREATE TABLE TB_DOMINIO (
    IDENT BIGINT NOT NULL,
    COD_DOMINIO VARCHAR(70) NOT NULL,
    DOMINIO VARCHAR(150),
    ID_DOM_SITUACAO INTEGER,
    ID_TIPO INTEGER NOT NULL,
    DT_CADASTRO TIMESTAMP NOT NULL,
    PRIMARY KEY (IDENT),
    CONSTRAINT UNIQUE_COD_DOMINIO UNIQUE(COD_DOMINIO),
    CONSTRAINT FK_DOM_SITUACAO FOREIGN KEY (ID_DOM_SITUACAO) REFERENCES TB_DOMINIO(IDENT),
    CONSTRAINT FK_TIPO_DOMINIO FOREIGN KEY (ID_TIPO) REFERENCES TB_TIPO_DOMINIO(IDENT)
); 

CREATE TABLE TB_PESSOA (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    DS_NOME VARCHAR(255),
    DS_EMAIL VARCHAR(100),    
    DT_ATUALIZACAO TIMESTAMP(6) WITH TIME ZONE,
    ID_DOM_SITUACAO BIGINT,
    DS_TELEFONE VARCHAR(11),
    SG_TIPO_PESSOA VARCHAR(15) NOT NULL CHECK (
        SG_TIPO_PESSOA IN ('PESSOA_JURIDICA', 'PESSOA_FISSICA')
    ),
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_DOM_SITUACAO_PESSOA FOREIGN KEY (ID_DOM_SITUACAO) REFERENCES TB_DOMINIO(IDENT)
);

CREATE TABLE TB_PESSOA_FISICA (
    ID_PESSOA BIGINT NOT NULL,
    ID_DOM_GENERO BIGINT,
    CD_CPF VARCHAR(11),
    PRIMARY KEY (ID_PESSOA),
    CONSTRAINT FK_ID_PF_PESSOA FOREIGN KEY (ID_PESSOA) REFERENCES TB_PESSOA(IDENT),
    CONSTRAINT FK_DOM_GENERO_PF FOREIGN KEY (ID_DOM_GENERO) REFERENCES TB_DOMINIO(IDENT)
);

CREATE TABLE TB_PESSOA_JURIDICA (
    ID_PESSOA BIGINT NOT NULL,
    CD_CNPJ VARCHAR(14),
    DS_NOME_FANTASIA VARCHAR(255),
    ID_DOM_RAMO_ATIV INTEGER,
    PRIMARY KEY (ID_PESSOA),
    CONSTRAINT FK_ID_PJ_PESSOA FOREIGN KEY (ID_PESSOA) REFERENCES TB_PESSOA(IDENT),
    CONSTRAINT FK_ID_DOM_RAMO_PJ FOREIGN KEY (ID_DOM_RAMO_ATIV) REFERENCES TB_DOMINIO(IDENT)
);

CREATE TABLE TB_TENANT (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    CD_TENANT VARCHAR(200),
    DT_INICIO_AMOSTRA_GRATIS TIMESTAMP(6) WITH TIME ZONE,
    DT_FIM_AMOSTRA_GRATIS TIMESTAMP(6) WITH TIME ZONE,
    DT_ATUALIZACAO TIMESTAMP(6) WITH TIME ZONE,
    DT_CADASTRO TIMESTAMP(6) WITH TIME ZONE,
    ID_PESSOA_JURIDICA BIGINT NOT NULL UNIQUE,
    DS_NOME VARCHAR(255),
    QT_USUARIO INTEGER DEFAULT 0,
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_ID_PJ_TENANT FOREIGN KEY (ID_PESSOA_JURIDICA) REFERENCES TB_PESSOA_JURIDICA(ID_PESSOA),
    CONSTRAINT UNIQUE_CD_TENANT UNIQUE(CD_TENANT)
);

CREATE TABLE TB_PRECO_USUARIO (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    DT_CADASTRO TIMESTAMP(6) WITH TIME ZONE,
    DS_NOME VARCHAR(255),
    PRIMARY KEY (IDENT)
);

CREATE TABLE TB_SERVICO (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    DS_SERVICO VARCHAR(255),
    VL_UNIT NUMERIC(38,2),
    DT_ATUALIZACAO TIMESTAMP(6) WITH TIME ZONE,
    ID_DOM_SITUACAO BIGINT,
    ID_DOM_TIPO BIGINT,
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_DOM_SITUACAO_SERVICO FOREIGN KEY (ID_DOM_SITUACAO) REFERENCES TB_DOMINIO(IDENT),
    CONSTRAINT FK_DOM_TIPO_SERVICO FOREIGN KEY (ID_DOM_TIPO) REFERENCES TB_DOMINIO(IDENT)
);

CREATE TABLE TB_MODULO (
    ID_SERVICO BIGINT NOT NULL,
    NM_MODULO VARCHAR(255),
    ID_DOM_MODULO BIGINT,
    PRIMARY KEY (ID_SERVICO),
    CONSTRAINT FK_ID_SERVICO_MODULO FOREIGN KEY (ID_SERVICO) REFERENCES TB_SERVICO(IDENT),
    CONSTRAINT FK_DOM_TIPO_MODULO FOREIGN KEY (ID_DOM_MODULO) REFERENCES TB_DOMINIO(IDENT)
);

CREATE TABLE TB_TRANSACAO (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    VL_TRANSACAO NUMERIC(38,2),
    DT_CADASTRO TIMESTAMP(6) WITH TIME ZONE,
    ID_PESSOA_FISICA BIGINT,
    ID_TENANT VARCHAR(255) NOT NULL,
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_PESSOA_FISICA FOREIGN KEY (ID_PESSOA_FISICA) REFERENCES TB_PESSOA_FISICA(ID_PESSOA),
    CONSTRAINT FK_TENANT_TRANSACAO FOREIGN KEY (ID_TENANT) REFERENCES TB_TENANT(CD_TENANT)
);

CREATE TABLE TB_TENANT_MODULO (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    FLAG_POSSUI_CUSTOM BOOLEAN,
    DT_ATUALIZACAO TIMESTAMP(6) WITH TIME ZONE,
    DT_CADASTRO TIMESTAMP(6) WITH TIME ZONE,
    DT_EXPIRACAO TIMESTAMP(6) WITH TIME ZONE,
    ID_DOM_SITUACAO BIGINT,
    ID_MODULO BIGINT,
    ID_TENANT VARCHAR(255) NOT NULL,
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_DOM_SITUACAO_TENANT_MODULO FOREIGN KEY (ID_DOM_SITUACAO) REFERENCES TB_DOMINIO(IDENT),
    CONSTRAINT FK_DOM_TENANT_MODULO FOREIGN KEY (ID_MODULO) REFERENCES TB_MODULO(ID_SERVICO),
    CONSTRAINT FK_TENANT_MODULO FOREIGN KEY (ID_TENANT) REFERENCES TB_TENANT(CD_TENANT)
);

CREATE TABLE TB_FUNCIONALIDADE (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    DS_DESCRICAO VARCHAR(255),
    VL_FUNCIONALIDADE NUMERIC(38,2), 
    ID_MODULO BIGINT,
    ID_DOM_TIPO BIGINT,
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_FUNCIONALIDADE_MODULO FOREIGN KEY (ID_MODULO) REFERENCES TB_MODULO(ID_SERVICO),
    CONSTRAINT FK_DOM_TIPO_FUNCIONALIDADE FOREIGN KEY (ID_DOM_TIPO) REFERENCES TB_DOMINIO(IDENT)
);

CREATE TABLE TB_MOVIMENTACAO (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
	VL_UNIT NUMERIC(38,2),
    VL_MOVIMENTACAO NUMERIC(38,2),
    DT_MOVIMENTACAO TIMESTAMP(6) WITH TIME ZONE,
    ID_DOM_TIPO BIGINT,
    ID_TRANSACAO BIGINT,
    QT_MOVIM INTEGER DEFAULT 1,
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_DOM_TIPO FOREIGN KEY (ID_DOM_TIPO) REFERENCES TB_DOMINIO(IDENT),
    CONSTRAINT FK_TRANSACAO_MOVIM FOREIGN KEY (ID_TRANSACAO) REFERENCES TB_TRANSACAO(IDENT)
);

CREATE TABLE TB_MOVIM_MODULO (
    ID_MOVIMENTACAO BIGINT NOT NULL,
    ID_FUNCIONALIDADE BIGINT,
    ID_TENANT_MODULO BIGINT,
    PRIMARY KEY (ID_MOVIMENTACAO),
    CONSTRAINT FK_ID_MOVIM_MODULO_MOVIM FOREIGN KEY (ID_MOVIMENTACAO) REFERENCES TB_MOVIMENTACAO(IDENT),
    CONSTRAINT FK_FUNC_MOVIM_MODULO FOREIGN KEY (ID_FUNCIONALIDADE) REFERENCES TB_FUNCIONALIDADE(IDENT),
    CONSTRAINT FK_TENANT_MODULO_MOVIM FOREIGN KEY (ID_TENANT_MODULO) REFERENCES TB_TENANT_MODULO(IDENT)
);

CREATE TABLE TB_TENANT_MODULO_FUNC_CUSTOM (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    VL_ULTIMA_CONTRATACAO NUMERIC(38, 2),
    DT_CADASTRO TIMESTAMP(6) WITH TIME ZONE,
    DT_EXPIRACAO TIMESTAMP(6) WITH TIME ZONE,
    ID_DOM_SITUACAO BIGINT,
    ID_FUNCIONALIDADE BIGINT,
    ID_TENANT_MODULO BIGINT,
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_DOM_SITUACAO_FUNC_CUSTOM FOREIGN KEY (ID_DOM_SITUACAO) REFERENCES TB_DOMINIO(IDENT),
    CONSTRAINT FK_FUNCIONALIDADE_FUNC_CUSTOM FOREIGN KEY (ID_FUNCIONALIDADE) REFERENCES TB_FUNCIONALIDADE(IDENT),
    CONSTRAINT FK_TENANT_MODULO_FUNC_CUSTOM FOREIGN KEY (ID_TENANT_MODULO) REFERENCES TB_TENANT_MODULO(IDENT)
);

CREATE TABLE tb_modulo_sub_modulo (
	IDENT BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	id_modulo BIGINT NOT NULL,
	id_sub_modulo BIGINT NULL,
	dt_atualizacao TIMESTAMP(6) WITH TIME ZONE NULL,
	id_dom_situacao BIGINT NULL,
	CONSTRAINT tb_modulo_sub_modulo_pkey PRIMARY KEY (ident),
	CONSTRAINT fk_dom_situacao_sub_modulo FOREIGN KEY (id_dom_situacao) REFERENCES tb_dominio(ident),
	CONSTRAINT fk_id_modulo_dependencia_ck FOREIGN KEY (id_sub_modulo) REFERENCES TB_MODULO(ID_SERVICO),
	CONSTRAINT fk_id_modulo_dependente_ck FOREIGN KEY (id_modulo) REFERENCES TB_MODULO(ID_SERVICO)
);

CREATE TABLE TB_USUARIO (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    ID_PESSOA INTEGER,
    DT_ATUALIZACAO TIMESTAMP(6) WITH TIME ZONE,
    ID_DOM_SITUACAO BIGINT,
    ID_TENANT_SELECIONADO VARCHAR(255),
    DS_SENHA VARCHAR(255),
    DS_TOKEN VARCHAR(255),
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_DOM_SITUACAO_USUARIO FOREIGN KEY (ID_DOM_SITUACAO) REFERENCES TB_DOMINIO(IDENT),
    CONSTRAINT FK_ID_PESSOA_USUARIO FOREIGN KEY (ID_PESSOA) REFERENCES TB_PESSOA_FISICA(ID_PESSOA),
    CONSTRAINT FK_ID_TENANT_SELECIONADO FOREIGN KEY (ID_TENANT_SELECIONADO) REFERENCES TB_TENANT(CD_TENANT)
);

CREATE TABLE TB_USUARIO_TENANT (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    DT_ATUALIZACAO TIMESTAMP(6) WITH TIME ZONE,
    ID_DOM_SITUACAO BIGINT,
    ID_TENANT VARCHAR(255),
    ID_USUARIO BIGINT,
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_DOM_SITUACAO_TENANT_USUARIO FOREIGN KEY (ID_DOM_SITUACAO) REFERENCES TB_DOMINIO(IDENT),
    CONSTRAINT FK_ID_TENANT_USUARIO FOREIGN KEY (ID_TENANT) REFERENCES TB_TENANT(CD_TENANT),
    CONSTRAINT FK_ID_USUARIO_TENANT FOREIGN KEY (ID_USUARIO) REFERENCES TB_USUARIO(IDENT)
);

CREATE TABLE TB_VINCULO_FUNCIONARIO (
    IDENT BIGINT GENERATED BY DEFAULT AS IDENTITY,
    DT_ATUALIZACAO TIMESTAMP(6) WITH TIME ZONE,
    ID_DOM_CARGO BIGINT,
    ID_DOM_SITUACAO BIGINT,
    ID_PESSOA_FISICA BIGINT,
    ID_PESSOA_JURIDICA BIGINT,
    PRIMARY KEY (IDENT),
    CONSTRAINT FK_DOM_SIT_FUNC FOREIGN KEY (ID_DOM_SITUACAO) REFERENCES TB_DOMINIO(IDENT),
    CONSTRAINT FK_DOM_CARGO_FUNC FOREIGN KEY (ID_DOM_CARGO) REFERENCES TB_DOMINIO(IDENT),
    CONSTRAINT FK_ID_PF_FUNC FOREIGN KEY (ID_PESSOA_FISICA) REFERENCES TB_PESSOA_FISICA(ID_PESSOA),
    CONSTRAINT FK_ID_PJ_FUNC FOREIGN KEY (ID_PESSOA_JURIDICA) REFERENCES TB_PESSOA_JURIDICA(ID_PESSOA)
);