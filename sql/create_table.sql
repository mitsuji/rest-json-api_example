CREATE TABLE [dbo].[TTest_TodoList](
    [todoID] [int] IDENTITY(1,1) NOT NULL,
    [todoContent] [nvarchar](50) NOT NULL,
    [todoCreated] [datetime] NOT NULL,
    [todoModified] [datetime] NULL,
 CONSTRAINT [PK_TTest_TodoList] PRIMARY KEY CLUSTERED 
(
    [todoID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

