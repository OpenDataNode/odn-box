CREATE TABLE "usr_organization"
(
  "id" INTEGER,
  usr VARCHAR(256) NOT NULL,
  organization  VARCHAR(256) NOT NULL,
  PRIMARY KEY ("id")
);

CREATE SEQUENCE "seq_usr_organization" START 1;
