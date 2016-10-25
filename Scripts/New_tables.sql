CREATE TABLE Medhok.Batch_Process_Event
(
    ID INT IDENTITY(1,1) NOT NULL
      CONSTRAINT idx__batch_process_event__id
      PRIMARY KEY CLUSTERED (ID),
    ExecutionLogID INT NOT NULL,
    Description VARCHAR(MAX) NOT NULL,
    Normal BIT DEFAULT 1,
    RegisteredAt DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Medhok.Mailing_Data_File
(
    ID INT IDENTITY(1,1) NOT NULL
      CONSTRAINT idx__mailing_data_file__id
		  PRIMARY KEY CLUSTERED (ID),
    ExecutionLogID INT NOT NULL,
    FileName VARCHAR(254) NOT NULL,
    RegisteredAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    Loaded BIT DEFAULT 0,
    CounterpartFound BIT DEFAULT 0,
    Adjudicated BIT DEFAULT 0,
    AdjudicationDate DATETIME2 NULL,
    ErrorsFound INT NOT NULL DEFAULT 0,
    TotalRecords INT NOT NULL DEFAULT 0,
    TotalRecordsProcessed INT NOT NULL DEFAULT 0,
    TotalRecordsExcluded INT NOT NULL DEFAULT 0
);

CREATE TABLE Medhok.Mailing_Data_File_Cache
(
    ParentID INT NOT NULL,
    CorrespondenceID VARCHAR(50),
    FileName VARCHAR(133) NOT NULL,
    Mailing_Date VARCHAR(14) NOT NULL
);
GO

CREATE TABLE Medhok.Mailing_Data_Exception
(
    ID INT IDENTiTY(1,1) NOT NULL
      CONSTRAINT idx__mailing_data_exception__id
      PRIMARY KEY CLUSTERED (ID),
    ExecutionLogID INT NOT NULL,
    ParentID INT NOT NULL,
    CorrespondenceID VARCHAR(50),
    FileName VARCHAR(133),
    Mailing_Date VARCHAR(14),
    Description NVARCHAR(1024)
);
GO

CREATE TABLE Medhok.Mailing_Data_Load_Exception
(
    ExecutionLogID INT NOT NULL,
    Description VARCHAR(1024)
);

CREATE TABLE Medhok.Mailing_Data_Buffer
(
    LetterID INT NOT NULL
      CONSTRAINT idx__mailing_data_buffer__LetterID
      PRIMARY KEY CLUSTERED (LetterID),
    ParentID INT NOT NULL,
    MailingDate DATETIME2 NOT NULL
);
GO

CREATE TABLE Medhok.Mailing_Data_NoMatch
(
    ID INT IDENTITY(1,1) NOT NULL
      CONSTRAINT idx__mailing_data_nomatch__id
      PRIMARY KEY CLUSTERED (ID),
    ExecutionLogID INT NOT NULL,
    ParentID INT NOT NULL,
    LetterName VARCHAR(133) NOT NULL
);
GO

CREATE TABLE Medhok.Mailing_Data_Row_Error
(
    ID INT IDENTITY(1,1) NOT NULL
      CONSTRAINT idx__mailing_data_row_error__id
      PRIMARY KEY CLUSTERED (ID),
    ParentID INT,
    FileName VARCHAR(133),
    MailingDate VARCHAR(19),
    ErrorCode INT,
    ErrorColumn INT,
    ExecutionLogID INT
);
GO

CREATE TABLE Medhok.Mailing_Data_File_Error
(
    ID INT IDENTITY(1,1) NOT NULL
      CONSTRAINT idx__mailing_data_file_error__id
      PRIMARY KEY CLUSTERED (ID),
    Source VARCHAR(MAX) DEFAULT '',
    ErrorCode INT DEFAULT 0,
    ErrorColumn INT DEFAULT 0,
    ExecutionLogID INT DEFAULT 0,
    --FileName NVARCHAR(254) DEFAULT 'Unknown',
    ParentID INT DEFAULT 0
);
GO

CREATE TABLE Medhok.Mailing_Data_File_Dest
(
    ID INT IDENTITY(1,1) NOT NULL
      CONSTRAINT idx__mailing_data_file_dest__id
      PRIMARY KEY CLUSTERED (ID),
    DestPath VARCHAR(750) NOT NULL,
      CONSTRAINT unq___mailing_data_file_dest__destpath
      UNIQUE (DestPath),
    IndexFilePrefix VARCHAR(15) NOT NULL
);
GO

INSERT INTO  Medhok.Mailing_Data_File_Dest
    VALUES
      ('\DIP\MEDHOK\BH_Mailing_Data', 'BHMD'),
      ('\DIP\MEDHOK\CM_Mailing_Data', 'CMMD'),
      ('\DIP\MEDHOK\PA_Mailing_Data', 'PAMD'),
      ('\DIP\MEDHOK\RX_Mailing_Data', 'RXMD')
;
GO

CREATE TABLE Medhok.Mailing_Data_File_Type
(
    ID INT IDENTITY(1,1) NOT NULL
      CONSTRAINT idx__mailing_data_file_type__id
      PRIMARY KEY CLUSTERED (ID),
    FileTypePrefix VARCHAR(15) NOT NULL,
    DestID INT DEFAULT 0
    CONSTRAINT fk__mailing_data_file_dest__id
        FOREIGN KEY REFERENCES Medhok.Mailing_Data_File_Dest (ID)
        ON DELETE SET DEFAULT,
    CONSTRAINT unq__mailing_data_file_type__filetypeprefix
        UNIQUE (FileTypePrefix)
);
GO

INSERT INTO Medhok.Mailing_Data_File_Type
    VALUES
      ('BHAUT', 1),
      ('BHPHPAUT', 1),
      ('BHDEN', 1),
      ('BHPHPDEN', 1),
      ('BHCMCL', 1),
      ('BHCMWC', 1),
      ('BHCMNC', 1),
      ('BHCMEM', 1),
      ('BHCMLT', 1),
      ('BHCMCP', 1),
      ('ICP', 2),
      ('NC', 2),
      ('CMICT', 2),
      ('CMWC', 2),
      ('CMCP', 2),
      ('CMCL', 2),
      ('CMNC', 2),
      ('DMCP', 2),
      ('DPUDS', 2),
      ('SSDW', 2),
      ('SSDCL', 2),
      ('SSDUR', 2),
      ('SSDCOR', 2),
      ('UMNDEN', 3),
      ('UMDEN', 3),
      ('UMAUT', 3),
      ('RX', 4),
      ('RXREJECTS', 4)
;
GO

ALTER TABLE
  Medhok.Letter
ADD
  CorrespondenceID	VARCHAR(254) NOT NULL DEFAULT '',
  PageCount	        INT	NOT NULL DEFAULT 0,
  CaseNumber	      VARCHAR(254) NOT NULL DEFAULT '',
  MemberID	        VARCHAR(52)	NOT NULL DEFAULT '',
  MailingDate	      DATETIME2 DEFAULT NULL,
  Tag	              VARCHAR(254) DEFAULT NULL;