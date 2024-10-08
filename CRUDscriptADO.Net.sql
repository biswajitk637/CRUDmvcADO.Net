USE [master]
GO
/****** Object:  Database [CRUD]    Script Date: 18-12-2022 18:13:05 ******/
CREATE DATABASE [CRUD]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CRUD', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CRUD.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CRUD_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CRUD_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [CRUD] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CRUD].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CRUD] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CRUD] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CRUD] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CRUD] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CRUD] SET ARITHABORT OFF 
GO
ALTER DATABASE [CRUD] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [CRUD] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CRUD] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CRUD] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CRUD] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CRUD] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CRUD] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CRUD] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CRUD] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CRUD] SET  ENABLE_BROKER 
GO
ALTER DATABASE [CRUD] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CRUD] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CRUD] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CRUD] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CRUD] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CRUD] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CRUD] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CRUD] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CRUD] SET  MULTI_USER 
GO
ALTER DATABASE [CRUD] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CRUD] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CRUD] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CRUD] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CRUD] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CRUD] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [CRUD] SET QUERY_STORE = OFF
GO
USE [CRUD]
GO
/****** Object:  Table [dbo].[EMPLOYEE]    Script Date: 18-12-2022 18:13:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLOYEE](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[Price] [decimal](8, 2) NOT NULL,
	[Qty] [int] NOT NULL,
	[Remarks] [nvarchar](50) NULL,
 CONSTRAINT [PK__EMPLOYEE__3214EC27B85327F3] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[EMPLOYEE] ON 

INSERT [dbo].[EMPLOYEE] ([ProductID], [ProductName], [Price], [Qty], [Remarks]) VALUES (1, N'Mango', CAST(250.00 AS Decimal(8, 2)), 1, N'ok')
INSERT [dbo].[EMPLOYEE] ([ProductID], [ProductName], [Price], [Qty], [Remarks]) VALUES (8, N'Orange', CAST(400.00 AS Decimal(8, 2)), 23, N'Test')
SET IDENTITY_INSERT [dbo].[EMPLOYEE] OFF
GO
/****** Object:  StoredProcedure [dbo].[sp_DeleteProducts]    Script Date: 18-12-2022 18:13:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sp_DeleteProducts] 
( 
@ProductID int,
@OutpurMessage varchar(50) out
)
as
begin
declare @rowCount int =0;
begin try
set @rowCount=(select count(1) from EMPLOYEE where ProductID=@ProductID)
if(@rowCount >0)
begin
  begin tran
  delete from EMPLOYEE
	where ProductID=@ProductID
	set @OutpurMessage='Product deleted Successfully''!'
	end
else
begin
set @OutpurMessage='Product Not Available with id' + CONVERT(varchar,@ProductID)
end
commit tran
end try
begin catch
rollback tran
set @OutpurMessage=ERROR_MESSAGE()
end catch
end
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllProducts]    Script Date: 18-12-2022 18:13:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[sp_GetAllProducts]
as
begin
select ProductId,ProductName,Price,Qty,Remarks from EMPLOYEE with (nolock)
end
GO
/****** Object:  StoredProcedure [dbo].[sp_GetProductID]    Script Date: 18-12-2022 18:13:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sp_GetProductID]
(
@ProductID int
)
as
begin
select ProductID,ProductName,Price,Qty,Remarks from EMPLOYEE where ProductID=@ProductID
end
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertProducts]    Script Date: 18-12-2022 18:13:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sp_InsertProducts]
(@ProductName nvarchar(50),
@Price decimal(8,2),
@Qty int,
@Remarks varchar(50)=''
)
as

begin
declare @RowCount int =0
set @RowCount=(select count(1) from EMPLOYEE where ProductName=@ProductName)
begin try
begin tran
if(@RowCount=0)
begin
insert into EMPLOYEE (ProductName,Price,Qty,Remarks)
values (@ProductName,@Price,@Qty,@Remarks)
end
commit tran
end try
begin catch
rollback tran
select ERROR_MESSAGE()
end catch
end
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateProducts]    Script Date: 18-12-2022 18:13:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sp_UpdateProducts] 
( 
@ProductID int,
@ProductName nvarchar(50),
@Price decimal(8,2),
@Qty int,
@Remarks nvarchar(50)=null
)
as

begin
declare @RowCount int =0
set @RowCount=(select count(1) from EMPLOYEE where ProductName=@ProductName and ProductID<>@ProductID)
begin try
begin tran
if(@RowCount=0)
begin
Update EMPLOYEE
set ProductName=@ProductName,
    Price=@Price,
    Qty=@Qty,
    Remarks=@Remarks
	where ProductID=@ProductID
end
commit tran
end try
begin catch
rollback tran
select ERROR_MESSAGE()
end catch
end
GO
USE [master]
GO
ALTER DATABASE [CRUD] SET  READ_WRITE 
GO
