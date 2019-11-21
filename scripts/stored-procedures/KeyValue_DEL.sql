USE [CobranzasData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Axel Dolce
-- Create date: 2019-07-23
-- Description:	DELETE key
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[KeyValue_DEL]
	@key VARCHAR(100)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRAN KeyValue_DEL

	DELETE
	FROM KeyValue
	WHERE [key] = @key
	SELECT @@ROWCOUNT as reply

	COMMIT TRAN KeyValue_DEL

END
GO
