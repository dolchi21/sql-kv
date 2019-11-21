USE [CobranzasData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Axel Dolce
-- Create date: 2019-07-23
-- Description:	Get value
-- =============================================
ALTER PROCEDURE [dbo].[KeyValue_GET]
	@key VARCHAR(100)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRAN KeyValue_GET

	SELECT [value] as reply
	FROM KeyValue
	WHERE [key] = @key 
	AND (
		expireAt IS NULL
		OR
		GETUTCDATE() < expireAt
	)

	COMMIT TRAN KeyValue_GET

END
