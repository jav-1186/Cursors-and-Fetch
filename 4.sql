DROP TABLE CONTRACT CASCADE CONSTRAINTS; 
DROP TABLE TASK CASCADE CONSTRAINTS; 

CREATE TABLE TASK (
TaskID CHAR(3),
TaskName VARCHAR(20),
ContractCount NUMERIC(1,0) DEFAULT 0, 
CONSTRAINT PK_TASK PRIMARY KEY (TaskID)
);

CREATE TABLE CONTRACT 
(
TaskID CHAR(3),
WorkerID CHAR(7),
Payment NUMERIC(6,2),
CONSTRAINT PK_CONTRACT PRIMARY KEY (TaskID, WorkerID),
CONSTRAINT FK_CONTRACTTASK FOREIGN KEY (TaskID) REFERENCES TASK (TaskID) 
);

INSERT INTO TASK (TaskID, TaskName) VALUES ('333', 'Security' );
INSERT INTO TASK (TaskID, TaskName) VALUES ('322', 'Infrastructure');
INSERT INTO TASK (TaskID, TaskName) VALUES ('896', 'Compliance' );

SELECT * FROM TASK;
COMMIT; 

CREATE OR REPLACE TRIGGER NewContract 
BEFORE INSERT ON CONTRACT

FOR EACH ROW

DECLARE
   contractCount number;
   
BEGIN
   select CONTRACTCOUNT into contractCount from task where TaskID=:new.TaskID;
   
   if contractCount < 3 then
       update task set ContractCount = ContractCount + 1 where TaskID =: new.TaskID;
   else
      raise_application_error(-20112,'Contract Count Limit Exceeded!');
   end if;
END;
/

CREATE OR REPLACE TRIGGER EndContract 
AFTER DELETE ON CONTRACT

FOR EACH ROW

DECLARE
   contractCount number;
   
BEGIN
       update task set ContractCount = ContractCount - 1 where TaskID=: old.TaskID;
END;
/

CREATE OR REPLACE TRIGGER NoChanges 
BEFORE update ON CONTRACT

BEGIN
    raise_application_error(-20112,'Cannot update Contract!');
END;
/

insert into task (TaskId, TaskName) Values ('435', 'Test');
update task set contractcount = 4 where TaskId = '333';
insert into Contract values('333', '1234566',7);
update Contract set WorkerId = '4444441' where WorkerId = '1234566';
delete from Contract where TaskId = '333';
