-- Nonequijoins - É um JOIN realizado entre tabelas
-- Quando a condição de ligação não é uma condição de IGUALDADE

-- Nonequijoins
-- Este primeiro exemplo mostra a tabela employees é relacionada com a tabela job_grades
-- Quando o e.salary estiver dentro do valor minimo e alto dos campos j.lowest_sal AND j.highest_sal
SELECT
		e.employee_id,
		e.salary,
		j.grade_level,
		j.lowest_sal,
		j.highest_sal
FROM     employees e 
JOIN   job_grades j ON  NVL(e.salary,0) BETWEEN j.lowest_sal AND j.highest_sal
ORDER BY e.salary;

-- O mesmo objetivo é realizado nesta query abaixo, porém agora utilizando operador de comparação e não BETWEEN
SELECT
		e.employee_id,
		e.salary,
		j.grade_level,
		j.lowest_sal,
		j.highest_sal
FROM     employees e
JOIN   job_grades j ON  NVL(e.salary,0) >= j.lowest_sal AND NVL(e.salary,0) <= j.highest_sal
ORDER BY e.salary;

-- Abaixo script para criação e validação das querys acima utilizadas
-- Removendo a Tabela JOB_GRADES
DROP TABLE job_grades;

-- Criando a tabela JOB_GRADES
CREATE TABLE job_grades (
 grade_level   VARCHAR2 (2) NOT NULL,
 lowest_sal    NUMBER (11,2),
 highest_sal   NUMBER (11,2),
 CONSTRAINT job_grades_pk PRIMARY KEY (grade_level));
 
-- Inserindo linhas na tabela JOB_GRADES
INSERT INTO job_grades VALUES ('A',1000,2999); 
INSERT INTO job_grades VALUES ('B',3000,5999);
INSERT INTO job_grades VALUES ('C',6000,9999);
INSERT INTO job_grades VALUES ('D',10000,14999);
INSERT INTO job_grades VALUES ('E',15000,24999);
INSERT INTO job_grades VALUES ('F',25000,40000);

-- Efetivando a Transação
COMMIT;