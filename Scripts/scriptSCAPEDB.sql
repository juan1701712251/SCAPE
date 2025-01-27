USE [SCAPEDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[documentId] [varchar](500) NOT NULL UNIQUE,
	[firstName] [varchar](500) NOT NULL,
	[lastName] [varchar](500) NOT NULL,
	[email] [varchar](500) NULL,
	[sex] [char] NULL,
	[dateBirth] [datetime]  NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [SCAPEDB]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employer](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[documentId] [varchar](500) NOT NULL UNIQUE,
	[firstName] [varchar](500) NOT NULL,
	[lastName] [varchar](500) NOT NULL,
	[email] [varchar](500) NULL
 CONSTRAINT [PK_Employer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkPlace](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](1000) NOT NULL,
	[address] [varchar](1000) NULL,
	[latitudePosition] [varchar](500) NULL,
	[description] [varchar](500) NULL,
	[longitudePosition] [varchar](500) NULL,
	[idEmployer] [int] NOT NULL,
	[faceListId] [varchar](500) NULL,
 CONSTRAINT [PK_WorkPlace] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_WorkPlace](
	[idEmployee] [int]  NOT NULL,
	[idWorkPlace] [int]  NOT NULL,
	[startJobDate] [datetime] NULL,
	[endJobDate] [datetime] NULL
	
 CONSTRAINT [PK_EmployeeWorkPlace] PRIMARY KEY CLUSTERED 
(
	[idEmployee], [idWorkPlace] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_Schedule](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idEmployee] [int]  NOT NULL,
	[idWorkPlace] [int]  NOT NULL,
	[startMinute] [int] NOT NULL,
	[endMinute] [int] NOT NULL,
	[dayOfWeek] [int] NOT NULL,
	
 CONSTRAINT [PK_Employee_Schedule] PRIMARY KEY CLUSTERED 
(
	[id], [idEmployee], [idWorkPlace] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attendance](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[date] [datetime] NOT NULL,
	[type] [char] NOT NULL,
	[idEmployee] [int] NOT NULL,
	[idWorkPlace] [int]  NOT NULL,
 CONSTRAINT [PK_Attendance] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Image](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[image] [varbinary](max) NULL,
	[persistenceFaceId] [varchar](500) NULL,
	[idEmployee] [int] NOT NULL,

 CONSTRAINT [PK_Image] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[email] [varchar](500) NOT NULL,
	[password] [varchar](100) NOT NULL,
	[role] [varchar](20) NOT NULL

 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [dbo].[Employee] ON 

INSERT [dbo].[Employee] ([id], [documentId], [firstName], [lastName], [email],[sex],[dateBirth]) VALUES (1, 1234, 'Juan', 'Molina', 'juan@gmail.com', 'M', '20120618 10:34:09 AM')
INSERT [dbo].[Employee] ([id], [documentId], [firstName], [lastName], [email],[sex],[dateBirth]) VALUES (2, 12345, 'Pedro', 'Sanchez', 'pedro@gmail.com', 'M', '20120618 10:34:09 AM')

SET IDENTITY_INSERT [dbo].[Employee] OFF

ALTER TABLE [dbo].[Employee_WorkPlace]  WITH NOCHECK ADD  CONSTRAINT [FK_EmployeeWorkPlace] FOREIGN KEY([idEmployee])
REFERENCES [dbo].[Employee] ([id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Employee_WorkPlace] CHECK CONSTRAINT [FK_EmployeeWorkPlace]
GO
ALTER TABLE [dbo].[Employee_WorkPlace]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkPlace] FOREIGN KEY([idWorkPlace])
REFERENCES [dbo].[WorkPlace] ([id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Employee_WorkPlace] CHECK CONSTRAINT [FK_WorkPlace]
GO
ALTER TABLE [dbo].[Attendance]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee] FOREIGN KEY([idEmployee])
REFERENCES [dbo].[Employee] ([id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Attendance] CHECK CONSTRAINT [FK_Employee]

GO
ALTER TABLE [dbo].[Attendance]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkPlaceAttendance] FOREIGN KEY([idWorkPlace])
REFERENCES [dbo].[WorkPlace] ([id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Attendance] CHECK CONSTRAINT [FK_WorkPlaceAttendance]


ALTER TABLE [dbo].[Image]  WITH NOCHECK ADD  CONSTRAINT [FK_EmployeeImage] FOREIGN KEY([idEmployee])
REFERENCES [dbo].[Employee] ([id]) ON DELETE CASCADE

GO
ALTER TABLE [dbo].[Image] CHECK CONSTRAINT [FK_EmployeeImage]

ALTER TABLE [dbo].[WorkPlace]  WITH NOCHECK ADD  CONSTRAINT [FK_Employer_WorkPlace] FOREIGN KEY([idEmployer])
REFERENCES [dbo].[Employer] ([id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkPlace] CHECK CONSTRAINT [FK_Emloyer_WorkPlace]

-- Constraints Employee Schedule

GO
ALTER TABLE [dbo].[Employee_Schedule]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_WorkPlace_Schedule] FOREIGN KEY([idWorkPlace])
REFERENCES [dbo].[WorkPlace] ([id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Employee_Schedule] CHECK CONSTRAINT [FK_Employee_WorkPlace_Schedule]

GO
ALTER TABLE [dbo].[Employee_Schedule]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_WorkPlace_Schedule_2] FOREIGN KEY([idEmployee])
REFERENCES [dbo].[Employee] ([id]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Employee_Schedule] CHECK CONSTRAINT [FK_Employee_WorkPlace_Schedule_2]



CREATE UNIQUE INDEX [IX_EMAIL_EMPLOYER] ON [dbo].[Employer]([email]) WHERE [email] IS NOT NULL;
CREATE UNIQUE INDEX [IX_EMAIL] ON [dbo].[Employee]([email]) WHERE [email] IS NOT NULL;
