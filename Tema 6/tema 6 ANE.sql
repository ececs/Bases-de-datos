
DELIMITER //

CREATE PROCEDURE listarAgentesPorOficina()
BEGIN

    -- Listar los agentes de la oficina dada
    SELECT * FROM agentes;
END;
//

DELIMITER ;

DELIMITER //

CREATE PROCEDURE TotalAgentesPorFamilias(IN pfamilia INT)
BEGIN

    -- Listar  por familias
    SELECT count(*) FROM agentes WHERE familia = pfamilia;
END;
//

DELIMITER ;








DELIMITER //
CREATE PROCEDURE trasladarAgentesOficina(IN origen INT, IN destino INT)
BEGIN
  DECLARE ex1, ex2 INT;
  DECLARE nom1, nom2 VARCHAR(50);

  SELECT COUNT(*) INTO ex1 FROM oficinas WHERE identificador = origen;
  SELECT COUNT(*) INTO ex2 FROM oficinas WHERE identificador = destino;

  IF origen = destino THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las oficinas deben ser distintas';
  END IF;
  IF ex1 = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Oficina origen no existe';
  END IF;
  IF ex2 = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Oficina destino no existe';
  END IF;

  SELECT nombre INTO nom1 FROM oficinas WHERE identificador = origen;
  SELECT nombre INTO nom2 FROM oficinas WHERE identificador = destino;

  UPDATE agentes SET oficina = destino WHERE oficina = origen;
  SELECT CONCAT('Se han trasladado ', ROW_COUNT(), ' agentes de la oficina ', nom1, ' a ', nom2) AS mensaje;
END;
//
DELIMITER ;


CREATE TABLE log_agentes(
	id INT AUTO_INCREMENT PRIMARY KEY,
    operacion VARCHAR(20),
    fecha DATETIME,
    usuario VARCHAR(20)
);


