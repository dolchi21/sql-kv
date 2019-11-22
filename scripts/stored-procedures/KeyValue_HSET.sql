USE [CobranzasData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Axel Dolce
-- Create date: 2019-07-24
-- Description:	set value
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[KeyValue_HSET]
	@key NVARCHAR(100),
    @prop NVARCHAR(100)
	@value NVARCHAR(MAX),
	-- @nx: if true only sets if not exists
	@nx BIT = 0,
	-- @ex: expires in seconds
	@ex INT = null
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRAN KeyValue_HSET

	/* Get current key value if exists */
	DECLARE @db_id INT;
	DECLARE @db_expireAt DATETIME;
	SELECT TOP 1
		@db_id=id, @db_expireAt=expireAt
	FROM KeyValue
	WHERE [key]=@key

	IF @nx = 1 AND @db_id IS NOT NULL BEGIN
		IF @db_expireAt IS NULL BEGIN
			print 'nx=true & exists'
			SELECT 0 as reply
			COMMIT TRAN KeyValue_HSET
			RETURN
		END
		IF GETUTCDATE() < @db_expireAt BEGIN
			print 'expired'
			SELECT 0 as reply
			COMMIT TRAN KeyValue_HSET
			RETURN
		END
	END

	DECLARE @expireAt DATETIME; SET @expireAt = NULL;
	IF (@ex IS NOT NULL) BEGIN
		print 'expire=true'
		SET @expireAt = DATEADD(s, @ex, GETUTCDATE())
	END

	IF (@db_id IS NOT NULL) BEGIN
		print 'updating'
		UPDATE KeyValue
		SET value=JSON_MODIFY(value, '$.' + @prop, @value), expireAt=@expireAt, updatedAt=GETUTCDATE()
		WHERE id=@db_id
	END ELSE BEGIN
		print 'inserting'
		INSERT INTO KeyValue
			([key], value, expireAt)
		VALUES
			(@key, JSON_MODIFY('{}', '$.' + @prop, @value), @expireAt)
	END
	SELECT 1 as reply

	COMMIT TRAN KeyValue_HSET

END
