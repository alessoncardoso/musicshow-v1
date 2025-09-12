CREATE TABLE "tb_usuario" ( 
  "id" SERIAL PRIMARY KEY,
  "nome" VARCHAR(45) NOT NULL,
  "email" VARCHAR(100) NOT NULL UNIQUE,
  "senha" VARCHAR(60) NOT NULL,
  "data_criacao" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "status" INT NOT NULL
);

CREATE TABLE "tb_banda" (
  "id" SERIAL PRIMARY KEY,
  "id_usuario" INTEGER NOT NULL,
  "nome" VARCHAR(45) NOT NULL,
  "qtd_integrante" INT NOT NULL,
  "qtd_repertorio" INT NOT NULL,
  "data_criacao" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "status" INT NOT NULL,
  FOREIGN KEY ("id_usuario") REFERENCES "tb_usuario"("id") ON DELETE CASCADE
);

CREATE TABLE "tb_musica" (
  "id" SERIAL PRIMARY KEY,
  "id_usuario" INTEGER NOT NULL,
  "titulo" VARCHAR(45) NOT NULL,
  "arquivo" VARCHAR(255) NOT NULL,
  "data_criacao" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "status" INT NOT NULL,
  FOREIGN KEY ("id_usuario") REFERENCES "tb_usuario"("id") ON DELETE CASCADE
);

CREATE TABLE "tb_repertorio" (
  "id" SERIAL PRIMARY KEY,
  "id_banda" INTEGER NOT NULL,
  "nome" VARCHAR(45) NOT NULL,
  "qtd_musica" INT NOT NULL,
  "data_criacao" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "status" INT NOT NULL,
  FOREIGN KEY ("id_banda") REFERENCES "tb_banda"("id") ON DELETE CASCADE
);

CREATE TABLE "tb_usuario_banda" (
  "id" SERIAL PRIMARY KEY,
  "id_banda" INTEGER NOT NULL,
  "id_usuario" INTEGER NOT NULL,
  "papel_user" TEXT NOT NULL,
  "data_inclusao" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("id_usuario") REFERENCES "tb_usuario"("id") ON DELETE CASCADE,
  FOREIGN KEY ("id_banda") REFERENCES "tb_banda"("id") ON DELETE CASCADE
);

CREATE TABLE "tb_banda_musica" (
  "id" SERIAL PRIMARY KEY,
  "id_banda" INTEGER NOT NULL,
  "id_musica" INTEGER NOT NULL,
  "id_repertorio" INTEGER NOT NULL,
  "data_inclusao" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "ordem" INT NOT NULL,
  CONSTRAINT "UK_tb_banda_musica" UNIQUE ("id_banda", "id_musica", "id_repertorio"),
  FOREIGN KEY ("id_banda") REFERENCES "tb_banda"("id") ON DELETE CASCADE,
  FOREIGN KEY ("id_musica") REFERENCES "tb_musica"("id") ON DELETE CASCADE,
  FOREIGN KEY ("id_repertorio") REFERENCES "tb_repertorio"("id") ON DELETE CASCADE
);
