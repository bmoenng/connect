DROP TABLE EVENT;
CREATE TABLE EVENT
	(ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 0) NOT NULL PRIMARY KEY,
	DATE_CREATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	EVENT CLOB NOT NULL,
	EVENT_LEVEL VARCHAR(40) NOT NULL,
	DESCRIPTION CLOB,
	ATTRIBUTES CLOB);

ALTER TABLE MESSAGE DROP FOREIGN KEY CHANNEL_ID_FK;
DROP TABLE CHANNEL;
CREATE TABLE CHANNEL
	(ID VARCHAR(255) NOT NULL PRIMARY KEY,
	NAME VARCHAR(40) NOT NULL,
	DESCRIPTION CLOB,
	IS_ENABLED SMALLINT,
	VERSION VARCHAR(40),
	REVISION INTEGER,
	DIRECTION VARCHAR(40),
	PROTOCOL VARCHAR(40),
	MODE VARCHAR(40),
	SOURCE_CONNECTOR CLOB,
	DESTINATION_CONNECTORS CLOB,
	PROPERTIES CLOB,
	PREPROCESSING_SCRIPT CLOB);

DROP TABLE MESSAGE;
CREATE TABLE MESSAGE
	(SEQUENCE_ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 0) NOT NULL PRIMARY KEY,
	ID VARCHAR(255) NOT NULL,
	CHANNEL_ID VARCHAR(255) NOT NULL,
	SOURCE VARCHAR(255),
	TYPE VARCHAR(255),
	DATE_CREATED TIMESTAMP NOT NULL,
	VERSION VARCHAR(40),
	IS_ENCRYPTED SMALLINT NOT NULL,
	STATUS VARCHAR(40),
	RAW_DATA CLOB,
	RAW_DATA_PROTOCOL VARCHAR(40),
	TRANSFORMED_DATA CLOB,
	TRANSFORMED_DATA_PROTOCOL VARCHAR(40),
	ENCODED_DATA CLOB,
	ENCODED_DATA_PROTOCOL VARCHAR(40),
	VARIABLE_MAP CLOB,
	CONNECTOR_NAME VARCHAR(255),
	ERRORS CLOB,
	CORRELATION_ID VARCHAR(255),
	UNIQUE (ID),
	CONSTRAINT CHANNEL_ID_FK FOREIGN KEY(CHANNEL_ID) REFERENCES CHANNEL(ID) ON DELETE CASCADE);

CREATE INDEX MESSAGE_INDEX1 ON MESSAGE(SEQUENCE_ID, DATE_CREATED, CHANNEL_ID);
CREATE INDEX MESSAGE_INDEX2 ON MESSAGE(STATUS, CHANNEL_ID);
CREATE INDEX MESSAGE_INDEX3 ON MESSAGE(CORRELATION_ID, CHANNEL_ID);
CREATE INDEX MESSAGE_INDEX4 ON MESSAGE(CHANNEL_ID);
	
DROP TABLE SCRIPT;
CREATE TABLE SCRIPT
	(ID VARCHAR(255) NOT NULL PRIMARY KEY,
	SCRIPT CLOB);

DROP TABLE TEMPLATE;
CREATE TABLE TEMPLATE
	(ID VARCHAR(255) NOT NULL PRIMARY KEY,
	TEMPLATE CLOB);
	
DROP TABLE PERSON;
CREATE TABLE PERSON
	(ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 0) NOT NULL PRIMARY KEY,
	USERNAME VARCHAR(40) NOT NULL,
	PASSWORD VARCHAR(40) NOT NULL,
	FULLNAME VARCHAR(255),
	EMAIL VARCHAR(255),
	PHONENUMBER VARCHAR(40),
	DESCRIPTION VARCHAR(255));

DROP TABLE ALERT;
CREATE TABLE ALERT
	(ID VARCHAR(255) NOT NULL PRIMARY KEY,
	NAME VARCHAR(255) NOT NULL,
	IS_ENABLED SMALLINT NOT NULL,
	EXPRESSION VARCHAR(255),
	TEMPLATE VARCHAR(255));
	
DROP TABLE CHANNEL_ALERT;
CREATE TABLE CHANNEL_ALERT
	(CHANNEL_ID VARCHAR(255) NOT NULL,
	ALERT_ID VARCHAR(255) NOT NULL,
	CONSTRAINT ALERT_ID_CA_FK FOREIGN KEY(ALERT_ID) REFERENCES ALERT(ID) ON DELETE CASCADE);

DROP TABLE ALERT_EMAIL;
CREATE TABLE ALERT_EMAIL
	(ALERT_ID VARCHAR(255) NOT NULL,
	EMAIL VARCHAR(255) NOT NULL,
	CONSTRAINT ALERT_ID_AE_FK FOREIGN KEY(ALERT_ID) REFERENCES ALERT(ID) ON DELETE CASCADE);

DROP TABLE TRANSPORT;
CREATE TABLE TRANSPORT
	(NAME VARCHAR(255) NOT NULL PRIMARY KEY,
	CLASS_NAME VARCHAR(255) NOT NULL,
	PROTOCOL VARCHAR(255) NOT NULL,
	TRANSFORMERS VARCHAR(255) NOT NULL,
	TYPE VARCHAR(255) NOT NULL);

DROP TABLE CONFIGURATION;
CREATE TABLE CONFIGURATION
	(ID INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 0) NOT NULL PRIMARY KEY,
	DATE_CREATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	DATA CLOB NOT NULL);
	
DROP TABLE ENCRYPTION_KEY;
CREATE TABLE ENCRYPTION_KEY
	(DATA CLOB NOT NULL);
	
INSERT INTO PERSON (USERNAME, PASSWORD) VALUES('admin', 'admin');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('FTP Reader', 'org.mule.providers.ftp.FtpConnector', 'ftp', 'ByteArrayToString', 'LISTENER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('SFTP Reader', 'org.mule.providers.sftp.SftpConnector', 'sftp', 'ByteArrayToString', 'LISTENER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('JMS Reader', 'org.mule.providers.jms.JmsConnector', 'jms', 'JMSMessageToObject ObjectToString', 'LISTENER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('SOAP Listener', 'org.mule.providers.soap.axis.AxisConnector', 'axis', 'SOAPRequestToString', 'LISTENER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('File Reader', 'org.mule.providers.file.FileConnector', 'file', 'ByteArrayToString', 'LISTENER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('Database Reader', 'org.mule.providers.jdbc.JdbcConnector', 'jdbc', 'ResultMapToXML', 'LISTENER');

INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('LLP Listener', 'org.mule.providers.mllp.MllpConnector', 'mllp', 'ByteArrayToString', 'LISTENER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('TCP Listener', 'org.mule.providers.tcp.TcpConnector', 'tcp', 'ByteArrayToString', 'LISTENER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('Channel Reader', 'org.mule.providers.vm.VMConnector', 'vm', '', 'LISTENER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('HTTP Listener', 'org.mule.providers.http.HttpConnector', 'http', '', 'LISTENER');

INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('FTP Writer', 'org.mule.providers.ftp.FtpConnector', 'ftp', '', 'SENDER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('JMS Writer', 'org.mule.providers.jms.JmsConnector', 'jms', 'MessageObjectToJMSMessage', 'SENDER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('SOAP Sender', 'org.mule.providers.soap.axis.AxisConnector', 'axis', '', 'SENDER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('PDF Writer', 'org.mule.providers.pdf.PdfConnector', 'pdf', '', 'SENDER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('File Writer', 'org.mule.providers.file.FileConnector', 'file', '', 'SENDER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('Database Writer', 'org.mule.providers.jdbc.JdbcConnector', 'jdbc', '', 'SENDER');

INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('LLP Sender', 'org.mule.providers.mllp.MllpConnector', 'mllp', '', 'SENDER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('TCP Sender', 'org.mule.providers.tcp.TcpConnector', 'tcp', '', 'SENDER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('Channel Writer', 'org.mule.providers.vm.VMConnector', 'vm', '', 'SENDER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('HTTP Listener', 'org.mule.providers.http.HttpsConnector', 'http', 'HttpRequestToString', 'LISTENER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('HTTPS Listener', 'org.mule.providers.http.HttpConnector', 'https', 'HttpRequestToString', 'LISTENER');
INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('Email Sender', 'org.mule.providers.smtp.SmtpConnector', 'smtp', '', 'SENDER');=======
-- INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('HTTP Listener', 'org.mule.providers.http.HttpsConnector', 'http', 'HttpRequestToString', 'LISTENER');
-- INSERT INTO TRANSPORT (NAME, CLASS_NAME, PROTOCOL, TRANSFORMERS, TYPE) VALUES ('HTTPS Listener', 'org.mule.providers.http.HttpConnector', 'https', 'HttpRequestToString', 'LISTENER');
