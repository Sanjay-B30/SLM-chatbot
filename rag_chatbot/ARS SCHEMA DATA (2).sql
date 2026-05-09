

CREATE TABLE [dbo].[PersonalMas](
	[Persidno] [int] IDENTITY(1,1) NOT NULL,
	[Employeeid] [int] NOT NULL,
	[EmpcodeinDevice] [int] NOT NULL,
	[Empname] [varchar](50) NOT NULL,
	[Cardtype] [varchar](10) NOT NULL,
	[Cardno] [varchar](10) NOT NULL,
	[Shiftid] [int] NOT NULL,
	[Weeklyoffid] [int] NOT NULL,
	[Joineddt] [datetime] NOT NULL,
	[Circleid] [int] NOT NULL,
	[Deptid] [int] NOT NULL,
	[Sectionid] [int] NULL,
	[Sectionid2] [int] NULL,
	[SectionDet] [int] NULL,
	[workinunit] [char](6) NULL,
	[Unitid] [char](6) NOT NULL,
	[Status] [char](1) NOT NULL,
	[Delreason] [varchar](150) NULL,
	[DELREMARKS] [varchar](300) NULL,
	[Deldate] [datetime] NULL,
	[Entryby] [int] NOT NULL,
	[Entereddate] [datetime] NOT NULL,
	[Machinename] [varchar](20) NOT NULL,
	[PrintedNo] [int] NULL,
	[Cardtext] [char](11) NULL,
	[ShiftGroup] [char](1) NULL,
	[BRANCH] [varchar](20) NULL,
	[MOBILENO] [varchar](100) NULL,
	[DTOB] [date] NULL,
	[PREMPNO] [varchar](20) NULL,
	[Hostel] [char](1) NULL,
	[ESINO] [bigint] NULL,
	[FUNCT] [char](1) NULL,
	[QUALIFICATION] [int] NULL,
	[GENDER] [varchar](300) NULL,
	[ULB] [varchar](10) NULL,
	[WHATSAPP] [varchar](100) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PersonalMas] ADD  CONSTRAINT [DF_PersonalMas_Status]  DEFAULT ('Y') FOR [Status]
GO

ALTER TABLE [dbo].[PersonalMas] ADD  CONSTRAINT [DF_PersonalMas_Entereddate]  DEFAULT (getdate()) FOR [Entereddate]
GO

ALTER TABLE [dbo].[PersonalMas] ADD  CONSTRAINT [DF_PersonalMas_Machinename]  DEFAULT (host_name()) FOR [Machinename]
GO

ALTER TABLE [dbo].[PersonalMas] ADD  CONSTRAINT [DF_PersonalMas_PREMPNO]  DEFAULT ('') FOR [PREMPNO]
GO



CREATE TABLE [dbo].[Shiftmas](
	[Shiftid] [int] IDENTITY(1,1) NOT NULL,
	[Shiftname] [varchar](30) NOT NULL,
	[Shiftcode] [char](2) NOT NULL,
	[Shiftstart] [int] NOT NULL,
	[Shiftend] [int] NOT NULL,
	[Lunchstart] [int] NOT NULL,
	[Lunchend] [int] NOT NULL,
	[Unitid] [char](6) NOT NULL,
	[Status] [char](1) NOT NULL,
	[Oldshiftcode] [char](4) NOT NULL,
	[AttCode] [char](1) NULL,
 CONSTRAINT [PK_Shiftmas] PRIMARY KEY CLUSTERED 
(
	[Shiftid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Shiftmas] ADD  CONSTRAINT [DF_Shiftmas_Shiftstart]  DEFAULT (0) FOR [Shiftstart]
GO

ALTER TABLE [dbo].[Shiftmas] ADD  CONSTRAINT [DF_Shiftmas_Shiftend]  DEFAULT (0) FOR [Shiftend]
GO

ALTER TABLE [dbo].[Shiftmas] ADD  CONSTRAINT [DF_Shiftmas_Lunchstart]  DEFAULT (0) FOR [Lunchstart]
GO

ALTER TABLE [dbo].[Shiftmas] ADD  CONSTRAINT [DF_Shiftmas_Lunchend]  DEFAULT (0) FOR [Lunchend]
GO

ALTER TABLE [dbo].[Shiftmas] ADD  CONSTRAINT [DF_Shiftmas_Status]  DEFAULT ('Y') FOR [Status]
GO

ALTER TABLE [dbo].[Shiftmas] ADD  CONSTRAINT [DF_Shiftmas_Oldshiftcode]  DEFAULT ('') FOR [Oldshiftcode]
GO


CREATE TABLE [dbo].[LeaveDefMas](
	[LeaveDefid] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](20) NOT NULL,
	[Type] [char](1) NOT NULL,
	[Lookup] [char](10) NULL,
	[Unitid] [char](6) NOT NULL,
	[Entryby] [int] NOT NULL,
	[Entereddate] [datetime] NOT NULL,
	[Machinename] [varchar](20) NOT NULL,
	[Status] [char](1) NOT NULL,
 CONSTRAINT [PK_LeaveDefMas] PRIMARY KEY CLUSTERED 
(
	[LeaveDefid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[ELIGLEAVEMAS](
	[EligLeaveid] [int] IDENTITY(1,1) NOT NULL,
	[Employeeid] [int] NOT NULL,
	[Leavedefid] [int] NOT NULL,
	[Elgdys] [numeric](9, 2) NOT NULL,
	[Availed] [numeric](9, 2) NOT NULL,
	[Encashed] [numeric](9, 2) NOT NULL,
	[Year] [int] NOT NULL,
	[Unitid] [char](6) NOT NULL,
	[Entryby] [int] NOT NULL,
	[Entereddate] [datetime] NOT NULL,
	[Machinename] [varchar](300) NULL,
	[Status] [char](1) NOT NULL,
 CONSTRAINT [PK_ELIGLEAVEMAS] PRIMARY KEY CLUSTERED 
(
	[EligLeaveid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ELIGLEAVEMAS] ADD  CONSTRAINT [DF_ELIGLEAVEMAS_Availed]  DEFAULT ((0)) FOR [Availed]
GO

ALTER TABLE [dbo].[ELIGLEAVEMAS] ADD  CONSTRAINT [DF_ELIGLEAVEMAS_Encashed]  DEFAULT ((0)) FOR [Encashed]
GO

ALTER TABLE [dbo].[ELIGLEAVEMAS] ADD  CONSTRAINT [DF_ELIGLEAVEMAS_Machinename]  DEFAULT (host_name()) FOR [Machinename]
GO

ALTER TABLE [dbo].[ELIGLEAVEMAS] ADD  CONSTRAINT [DF_ELIGLEAVEMAS_Status]  DEFAULT ('Y') FOR [Status]
GO


CREATE TABLE [dbo].[Leavetran](
	[Leaveid] [int] IDENTITY(1,1) NOT NULL,
	[Applnno] [int] NOT NULL,
	[Aplndate] [datetime] NOT NULL,
	[Type] [char](10) NOT NULL,
	[Leavedefid] [int] NOT NULL,
	[Employeeid] [int] NOT NULL,
	[DateFrom] [datetime] NOT NULL,
	[Dateto] [datetime] NOT NULL,
	[Leavedays] [decimal](10, 2) NOT NULL,
	[Halfid] [char](1) NULL,
	[Status] [char](1) NOT NULL,
	[Closedate] [datetime] NULL,
	[Unitid] [char](6) NOT NULL,
	[Entryby] [int] NOT NULL,
	[Enterdate] [datetime] NOT NULL,
	[Machine] [varchar](1000) NULL,
	[APPROVED] [char](1) NULL,
	[APPDT] [datetime] NULL,
	[APPBY] [varchar](50) NULL,
	[DOC] [image] NULL,
 CONSTRAINT [PK__Leavetran__3F3159AB] PRIMARY KEY CLUSTERED 
(
	[Leaveid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


CREATE TABLE [dbo].[deptmas](
	[Deptid] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NULL,
	[Lookup] [char](15) NULL,
	[Olddeptcode] [char](4) NOT NULL,
	[Status] [char](1) NOT NULL,
	[deptOrder] [int] NOT NULL,
	[moncnt] [int] NULL
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[sectionmas](
	[Sectionid] [int] NOT NULL,
	[Sectionname] [char](40) NOT NULL,
	[Lookup] [char](10) NOT NULL,
	[Status] [char](1) NOT NULL,
	[EntryDate] [datetime] NOT NULL,
	[Entryby] [int] NOT NULL,
	[FUNCTI] [varchar](10) NULL,
	[ULP] [char](10) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[sectionmas2](
	[Sectionid] [int] NOT NULL,
	[Sectionname] [varchar](500) NULL,
	[Lookup] [char](10) NOT NULL,
	[Status] [char](1) NOT NULL,
	[EntryDate] [datetime] NOT NULL,
	[Entryby] [int] NOT NULL,
	[UNIT_CODE] [varchar](10) NULL,
	[secdept] [int] NULL,
	[ULP] [char](10) NULL
) ON [PRIMARY]
GO