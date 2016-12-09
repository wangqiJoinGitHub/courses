VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "HotWordManager"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Ext_KEY = "RVB_UniqueId" ,"3DB2F1850320"
Attribute VB_Ext_KEY = "RVB_ModelStereotype" ,"Class Module"
Option Explicit

'##ModelId=3DB3EA5C02E5
Implements IMaintData

'##ModelId=3DB6A74703CA
Private Const ErrClassName = "MainBusiness.HotWordManager"


'δʹ��
'##ModelId=3DB5543901F2
Private Function IMaintData_GetListByUserID(UserID As Long) As Recordset
    '(empty)
End Function


'�õ�ָ�����˴ʡ�
'������
'ID: long
'��ʶ
'##ModelId=3DB3F0010347
Private Function IMaintData_GetListByID(UserID As Long) As Recordset
    Const ErrFuncName = "IMaintData_GetListByID"
    On Error GoTo ErrHandler

    Dim rs As ADODB.Recordset
    Set rs = CreateObject("adodb.recordset")
    rs.ActiveConnection = dbConnString
    rs.Source = "SELECT * FROM HotWords WHERE ID=" & UserID
    rs.LockType = adLockBatchOptimistic
    rs.CursorLocation = adUseClient
    rs.CursorType = adOpenStatic
    
    rs.Open
    
    Set rs.ActiveConnection = Nothing
    Set IMaintData_GetListByID = rs

    Exit Function
ErrHandler:
    ErrorLog ErrClassName, ErrFuncName, Err
    Resume Next
End Function


'�õ��յĹ��˴ʼ�¼���ȴ��ͻ������ӡ�
'##ModelId=3DB3F0010395
Private Function IMaintData_GetEmpty() As Recordset
    Const ErrFuncName = "IMaintData_GetEmpty"
    On Error GoTo ErrHandler

    Dim rs As Recordset
    Set rs = CreateObject("ADODB.Recordset")

    rs.ActiveConnection = dbConnString
    rs.Source = "SELECT * FROM HotWords WHERE 0=1"
    rs.CursorLocation = adUseClient
    rs.CursorType = adOpenStatic
    rs.LockType = adLockBatchOptimistic
    rs.Open
    rs.AddNew

    Set rs.ActiveConnection = Nothing
    Set IMaintData_GetEmpty = rs

    Exit Function
ErrHandler:
    ErrorLog ErrClassName, ErrFuncName, Err
    Resume Next
End Function


'ɾ��ָ�����˴�
'##ModelId=3DB3F00103B5
Private Sub IMaintData_Delete(ID As Long)
    Const ErrFuncName = "IMaintData_Delete"
    On Error GoTo ErrHandler

    Dim conn As ADODB.Connection
    Set conn = CreateObject("ADODB.Connection")
    conn.ConnectionString = dbConnString
    conn.Open
    conn.Execute "DELETE FROM HotWords WHERE ID=" & ID
    conn.Close
    Set conn = Nothing

    Exit Sub
ErrHandler:
    ErrorLog ErrClassName, ErrFuncName, Err
    Resume Next
End Sub


'�õ����еĹ��˴ʡ�
'������
'return: recordset
'�������еļ�¼��
'##ModelId=3DB3F002000B
Private Function IMaintData_GetAll() As Recordset
    Const ErrFuncName = "IMaintData_GetAll"
    On Error GoTo ErrHandler

    Dim rs As ADODB.Recordset
    Set rs = CreateObject("ADODB.Recordset")

    rs.ActiveConnection = dbConnString
    rs.Source = "SELECT * FROM HotWords"
    rs.LockType = adLockReadOnly
    rs.CursorLocation = adUseClient
    rs.CursorType = adOpenStatic

    rs.Open

    Set rs.ActiveConnection = Nothing
    Set IMaintData_GetAll = rs
    
    Exit Function
ErrHandler:
    ErrorLog ErrClassName, ErrFuncName, Err
    Resume Next
End Function


'���浥�����˴�
'##ModelId=3DB3F16E001C
Private Sub IMaintData_Save(rs As Recordset)
    Const ErrFuncName = "IMaintData_Save"
    On Error GoTo ErrHandler
    
    rs.ActiveConnection = dbConnString
    rs.UpdateBatch
    
    Exit Sub
ErrHandler:
    ErrorLog ErrClassName, ErrFuncName, Err
    Resume Next
End Sub

'�鿴�ַ������Ƿ�������дʻ�
'������
's: string
'Ҫ�����ַ���
'return: integer
'����0������û�����дʣ��������������дʵĶ���

Public Function IsIncludeHotWord(s As String) As Integer
    Dim rs As ADODB.Recordset
    Set rs = CreateObject("ADODB.Recordset")

    rs.ActiveConnection = dbConnString
    rs.Source = "SELECT * FROM HotWords"
    rs.LockType = adLockReadOnly
    rs.CursorLocation = adUseClient
    rs.CursorType = adOpenStatic

    rs.Open
    
    Dim b As Boolean
    b = True

    If Not rs.EOF Then rs.MoveFirst
    'check if this string contain Hot Word
    Do Until rs.EOF
        If InStr(1, s, rs!Word, vbTextCompare) <> 0 Then
            b = False
            Exit Do
        End If
        rs.MoveNext
    Loop

    If b Then
        IsIncludeHotWord = 0
        Exit Function
    End If
    
    'return a Action form SysConfig

    rs.Close

    rs.ActiveConnection = dbConnString
    rs.Source = "SELECT * FROM Configuration"
    rs.LockType = adLockReadOnly
    rs.CursorLocation = adUseClient
    rs.CursorType = adOpenStatic

    rs.Open
    
    rs.Filter = "CFGName='HotAction'"
    IsIncludeHotWord = CInt(rs!Value)
    
    rs.Close
    Set rs = Nothing
End Function