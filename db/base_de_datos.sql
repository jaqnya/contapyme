/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ *
 *                                  DATABASE                                  *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
DROP DATABASE contapyme;

CREATE DATABASE IF NOT EXISTS contapyme
    DEFAULT CHARACTER SET utf8
    DEFAULT COLLATE utf8_general_ci;

USE contapyme;

/* -------------------------------------------------------------------------- */
CREATE TABLE empresa (
    codigo MEDIUMINT UNSIGNED NOT NULL,
    nombre VARCHAR(35) NOT NULL,
    periodo CHAR(4) NOT NULL,
    ruc VARCHAR(15) NOT NULL,
    rep_legal VARCHAR(35) NOT NULL,
    contador VARCHAR(35) NOT NULL,
    ruc_contad VARCHAR(15) NOT NULL,
    pf_desde DATE NOT NULL,
    pf_hasta DATE NOT NULL,
    formulario VARCHAR(5) NULL DEFAULT NULL,
    nro_orden VARCHAR(10) NULL DEFAULT NULL,
    impuesto CHAR(1) NOT NULL DEFAULT 'I',
    ccosto TINYINT UNSIGNED NOT NULL DEFAULT 0,
    mmoneda TINYINT UNSIGNED NOT NULL DEFAULT 0,
    asentar_ld TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

ALTER TABLE empresa
    ADD CONSTRAINT pk_empresa_codigo
        PRIMARY KEY (codigo),
    ADD CONSTRAINT uk_empresa_nombre
        UNIQUE KEY (nombre, periodo),
    ADD CONSTRAINT uk_empresa_ruc
        UNIQUE KEY (periodo, ruc),
    ADD CONSTRAINT chk_empresa_codigo
        CHECK (codigo > 0),
    ADD CONSTRAINT chk_empresa_nombre
        CHECK (nombre <> ''),
    ADD CONSTRAINT chk_empresa_periodo
        CHECK (periodo <> ''),
    ADD CONSTRAINT chk_empresa_ruc
        CHECK (ruc <> ''),
    ADD CONSTRAINT chk_empresa_rep_legal
        CHECK (rep_legal <> ''),
    ADD CONSTRAINT chk_empresa_contador
        CHECK (contador <> ''),
    ADD CONSTRAINT chk_empresa_ruc_contad
        CHECK (ruc_contad <> ''),
    ADD CONSTRAINT chk_empresa_formulario
        CHECK (ISNULL(formulario) OR formulario <> ''),
    ADD CONSTRAINT chk_empresa_nro_orden
        CHECK (ISNULL(nro_orden) OR nro_orden <> ''),
    ADD CONSTRAINT chk_empresa_impuesto
        CHECK (impuesto IN ('I', 'T')),
    ADD CONSTRAINT chk_empresa_ccosto
        CHECK (ccosto IN (0, 1)),
    ADD CONSTRAINT chk_empresa_mmoneda
        CHECK (mmoneda IN (0, 1)),
    ADD CONSTRAINT chk_empresa_asentar_ld
        CHECK (asentar_ld IN (0, 1));

/* -------------------------------------------------------------------------- */
CREATE TABLE ccosto (
    empresa MEDIUMINT UNSIGNED NOT NULL,
    codigo MEDIUMINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

ALTER TABLE ccosto
    ADD CONSTRAINT pk_ccosto_codigo
        PRIMARY KEY (empresa, codigo),
    ADD CONSTRAINT fk_ccosto_empresa
        FOREIGN KEY (empresa) REFERENCES empresa (codigo)
            ON DELETE CASCADE
            ON UPDATE RESTRICT,
    ADD CONSTRAINT uk_ccosto_nombre
        UNIQUE KEY (empresa, nombre),
    ADD CONSTRAINT chk_ccosto_codigo
        CHECK (codigo > 0),
    ADD CONSTRAINT chk_ccosto_nombre
        CHECK (nombre <> '');

/* -------------------------------------------------------------------------- */
CREATE TABLE clieprov (
    empresa MEDIUMINT UNSIGNED NOT NULL,
    codigo MEDIUMINT UNSIGNED NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(50) NULL DEFAULT NULL,
    telefono VARCHAR(20) NULL DEFAULT NULL,
    ruc VARCHAR(15) NOT NULL
) ENGINE=InnoDB;

ALTER TABLE clieprov
    ADD CONSTRAINT pk_clieprov_codigo
        PRIMARY KEY (empresa, codigo),
    ADD CONSTRAINT fk_clieprov_empresa
        FOREIGN KEY (empresa) REFERENCES empresa (codigo)
            ON DELETE CASCADE
            ON UPDATE RESTRICT,
    ADD CONSTRAINT uk_clieprov_nombre
        UNIQUE KEY (empresa, nombre),
    ADD CONSTRAINT uk_clieprov_ruc
        UNIQUE KEY (empresa, ruc),
    ADD CONSTRAINT chk_clieprov_codigo
        CHECK (codigo > 0),
    ADD CONSTRAINT chk_clieprov_nombre
        CHECK (nombre <> ''),
    ADD CONSTRAINT chk_clieprov_ruc
        CHECK (ruc <> '');

/* -------------------------------------------------------------------------- */
CREATE TABLE cuenta (
    empresa MEDIUMINT UNSIGNED NOT NULL,
    codigo CHAR(18) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    asentable TINYINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB;

ALTER TABLE cuenta
    ADD CONSTRAINT pk_cuenta_codigo
        PRIMARY KEY (empresa, codigo),
    ADD CONSTRAINT fk_cuenta_empresa
        FOREIGN KEY (empresa) REFERENCES empresa (codigo)
            ON DELETE CASCADE
            ON UPDATE RESTRICT,
    ADD CONSTRAINT uk_cuenta_nombre
        UNIQUE KEY (empresa, nombre),
    ADD CONSTRAINT chk_cuenta_codigo
        CHECK (codigo <> ''),
    ADD CONSTRAINT chk_cuenta_nombre
        CHECK (nombre <> ''),
    ADD CONSTRAINT chk_cuenta_asentable
        CHECK (asentable IN (0, 1));

/* -------------------------------------------------------------------------- */
CREATE TABLE cabeasnt (
    empresa MEDIUMINT UNSIGNED NOT NULL,
    codigo MEDIUMINT UNSIGNED NOT NULL,
    fecha DATE NOT NULL
) ENGINE=InnoDB;

ALTER TABLE cabeasnt
    ADD CONSTRAINT pk_cabeasnt_codigo
        PRIMARY KEY (empresa, codigo),
    ADD CONSTRAINT fk_cabeasnt_empresa
        FOREIGN KEY (empresa) REFERENCES empresa (codigo)
            ON DELETE CASCADE
            ON UPDATE RESTRICT;

/* -------------------------------------------------------------------------- */
CREATE TABLE detaasnt (
    empresa MEDIUMINT UNSIGNED NOT NULL,
    codigo MEDIUMINT UNSIGNED NOT NULL,
    cuenta CHAR(18) NOT NULL,
    tipomovi CHAR(1) NOT NULL,
    monto NUMERIC(10) NOT NULL,
    concepto VARCHAR(40) NOT NULL,
    ccosto MEDIUMINT UNSIGNED NULL DEFAULT NULL
) ENGINE=InnoDB;

ALTER TABLE detaasnt
    ADD CONSTRAINT pk_detaasnt_codigo
        PRIMARY KEY (empresa, codigo, cuenta),
    ADD CONSTRAINT fk_detaasnt_empresa
        FOREIGN KEY (empresa) REFERENCES empresa (codigo)
            ON DELETE CASCADE
            ON UPDATE RESTRICT,
    ADD CONSTRAINT fk_detaasnt_codigo
        FOREIGN KEY (empresa, codigo) REFERENCES cabeasnt (empresa, codigo)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,
    ADD CONSTRAINT fk_detaasnt_cuenta
        FOREIGN KEY (empresa, cuenta) REFERENCES cuenta (empresa, codigo)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,
    ADD CONSTRAINT fk_detaasnt_ccosto
        FOREIGN KEY (empresa, ccosto) REFERENCES ccosto (empresa, ccosto)
            ON DELETE RESTRICT
            ON UPDATE RESTRICT,
    ADD CONSTRAINT chk_detaasnt_tipomovi
        CHECK (impuesto IN ('D', 'C'));
