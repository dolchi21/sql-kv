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
CREATE OR ALTER PROCEDURE [dbo].[KeyValue_GET]
	@key VARCHAR(100)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @id INT = NULL
	DECLARE @value NVARCHAR(max) = NULL
	DECLARE @expireAt [datetime2](7) = NULL

	BEGIN TRAN KeyValue_GET

	SELECT @id=id, @value=[value], @expireAt=expireAt
	FROM KeyValue
	WHERE [key] = @key
	
	IF 0 < @id BEGIN
		IF @expireAt IS NULL BEGIN
			SELECT @value as reply
		END ELSE BEGIN
			IF @expireAt < GETUTCDATE() BEGIN
				SELECT @value as reply
			END ELSE BEGIN
				DELETE KeyValue WHERE id=@id
			END
		END
	END

	COMMIT TRAN KeyValue_GET

END
