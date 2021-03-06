create or replace package UDO_PKG_FTP_UTIL as

  -- --------------------------------------------------------------------------
  -- Name         : http://www.oracle-base.com/dba/miscellaneous/ftp.pks
  -- Author       : DR Timothy S Hall
  -- Description  : Basic FTP API. For usage notes see:
  --                  http://www.oracle-base.com/articles/misc/FTPFromPLSQL.php
  -- Requirements : UTL_TCP
  -- Ammedments   :
  --   When         Who       What
  --   ===========  ========  =================================================
  --   14-AUG-2003  Tim Hall  Initial Creation
  --   10-MAR-2004  Tim Hall  Add convert_crlf procedure.
  --                          Make get_passive function visible.
  --                          Added get_direct and put_direct procedures.
  --   03-OCT-2006  Tim Hall  Add list, rename, delete, mkdir, rmdir procedures.
  --   15-Jan-2008  Tim Hall  login: Include timeout parameter (suggested by Dmitry Bogomolov).
  --   12-Jun-2008  Tim Hall  get_reply: Moved to pakage specification.
  --   22-Apr-2009  Tim Hall  nlst: Added to return list of file names only (suggested by Julian and John Duncan)
  -- --------------------------------------------------------------------------

  type T_STRING_TABLE is table of varchar2(32767);

  function LOGIN
  (
    P_HOST    in varchar2,
    P_PORT    in varchar2,
    P_USER    in varchar2,
    P_PASS    in varchar2,
    P_TIMEOUT in number := null
  ) return UTL_TCP.CONNECTION;

  function GET_PASSIVE(P_CONN in out nocopy UTL_TCP.CONNECTION)
    return UTL_TCP.CONNECTION;

  procedure LOGOUT
  (
    P_CONN  in out nocopy UTL_TCP.CONNECTION,
    P_REPLY in boolean := true
  );

  procedure SEND_COMMAND
  (
    P_CONN    in out nocopy UTL_TCP.CONNECTION,
    P_COMMAND in varchar2,
    P_REPLY   in boolean := true
  );

  procedure GET_REPLY(P_CONN in out nocopy UTL_TCP.CONNECTION);

  function GET_LOCAL_ASCII_DATA
  (
    P_DIR  in varchar2,
    P_FILE in varchar2
  ) return clob;

  function GET_LOCAL_BINARY_DATA
  (
    P_DIR  in varchar2,
    P_FILE in varchar2
  ) return blob;

  function GET_REMOTE_ASCII_DATA
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FILE in varchar2
  ) return clob;

  function GET_REMOTE_BINARY_DATA
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FILE in varchar2
  ) return blob;

  procedure PUT_LOCAL_ASCII_DATA
  (
    P_DATA in clob,
    P_DIR  in varchar2,
    P_FILE in varchar2
  );

  procedure PUT_LOCAL_BINARY_DATA
  (
    P_DATA in blob,
    P_DIR  in varchar2,
    P_FILE in varchar2
  );

  procedure PUT_REMOTE_ASCII_DATA
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FILE in varchar2,
    P_DATA in clob
  );

  procedure PUT_REMOTE_BINARY_DATA
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FILE in varchar2,
    P_DATA in blob
  );

  procedure GET
  (
    P_CONN      in out nocopy UTL_TCP.CONNECTION,
    P_FROM_FILE in varchar2,
    P_TO_DIR    in varchar2,
    P_TO_FILE   in varchar2
  );

  procedure PUT
  (
    P_CONN      in out nocopy UTL_TCP.CONNECTION,
    P_FROM_DIR  in varchar2,
    P_FROM_FILE in varchar2,
    P_TO_FILE   in varchar2
  );

  procedure GET_DIRECT
  (
    P_CONN      in out nocopy UTL_TCP.CONNECTION,
    P_FROM_FILE in varchar2,
    P_TO_DIR    in varchar2,
    P_TO_FILE   in varchar2
  );

  procedure PUT_DIRECT
  (
    P_CONN      in out nocopy UTL_TCP.CONNECTION,
    P_FROM_DIR  in varchar2,
    P_FROM_FILE in varchar2,
    P_TO_FILE   in varchar2
  );

  procedure HELP(P_CONN in out nocopy UTL_TCP.CONNECTION);

  procedure ASCII(P_CONN in out nocopy UTL_TCP.CONNECTION);

  procedure BINARY(P_CONN in out nocopy UTL_TCP.CONNECTION);

  procedure LIST
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_DIR  in varchar2,
    P_LIST out T_STRING_TABLE
  );

  procedure NLST
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_DIR  in varchar2,
    P_LIST out T_STRING_TABLE
  );

  procedure RENAME
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FROM in varchar2,
    P_TO   in varchar2
  );

  procedure delete
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FILE in varchar2
  );

  procedure MKDIR
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_DIR  in varchar2
  );

  procedure RMDIR
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_DIR  in varchar2
  );

  procedure CONVERT_CRLF(P_STATUS in boolean);

end UDO_PKG_FTP_UTIL;
/


grant execute on UDO_PKG_FTP_UTIL to public;

/* �������������� ����� */
create table UDO_LINKEDDOCS
(
/* ���������������  ����� */
RN                number( 17 ) not null,
/* �����������  (������ �� COMPANIES(RN)) */
COMPANY           number( 17 ) not null,
/* ��� ����� �� ������� (GUID) */
INT_NAME          varchar2( 36 ) not null
                  constraint UDO_C_LINKEDDOCS_INTNAME_NB check( RTRIM(INT_NAME) IS NOT NULL ),
/* �������� ������� */
UNITCODE          varchar2( 40 ) not null,
/* ��������������� ����� ��������� � ������� */
DOCUMENT          number( 17 ) not null,
/* ��� ����� */
REAL_NAME         varchar2( 160 ) not null
                  constraint UDO_C_LINKEDDOCS_REAL_NAME_NB check( RTRIM(REAL_NAME) IS NOT NULL ),
/* ���� � ����� �������� */
UPLOAD_TIME       date not null,
/* ���� �������� */
SAVE_TILL         date,
/* ������ ����� */
FILESIZE          number( 15 ),
/* ������������ ����������� �������� */
AUTHID            varchar2( 30 ) not null
                  constraint UDO_C_LINKEDDOCS_AUTHID_NB check( RTRIM(AUTHID) IS NOT NULL ),
/* ���������� */
NOTE              varchar2( 4000 ),
/* ������� ���������� �� ����� ����� */
FILE_DELETED      number( 1 ) default 0 not null
                  constraint UDO_C_LINKEDDOCS_FILE_DEL_VAL check( FILE_DELETED IN (0,1) ),
/* ����� �������� */
FILESTORE         number( 17 ) not null,
/* ����� */
constraint UDO_C_LINKEDDOCS_PK primary key (RN),
constraint UDO_C_LINKEDDOCS_INTNAME_UK unique (INT_NAME,COMPANY),
constraint UDO_C_LINKEDDOCS_REAL_NAME_UK unique (DOCUMENT,REAL_NAME,UNITCODE)
);


create or replace package UDO_PKG_FILE_API is

  /*
  ��� ������������� � ������� SYSDBA ����������
  1. C������ ����������. ��������:
    create or replace directory UDO_PARUS_LINKED_FILES as '/home/oracle/linkfilesstore';
  2. ���� ����� ��������� ����� ����� �� ������ � ������ � ���� ����������. ��������:
    grant read, write on directory UDO_PARUS_LINKED_FILES to PARUS;
  3. ���� Java ���������� �� �������� � ����� ������������ ������� ��������������� ����������. ��������:
    EXEC dbms_java.grant_permission( 'PARUS', 'SYS:java.io.FilePermission', '/home/oracle/linkfilesstore', 'read' );
    EXEC dbms_java.grant_permission( 'PARUS', 'SYS:java.io.FilePermission', '/home/oracle/linkfilesstore/-', 'read,write,delete' );
  */

  function GET_DIRECTORY_PATH(P_DIRECTORY_NAME in varchar2) return varchar2;

  function READ_FILE
  (
    P_DIRECTORY_NAME in varchar2,
    P_FILE_NAME      in varchar2,
    P_FOLDER         in varchar2 default null
  ) return blob;

  procedure DELETE_FILE
  (
    P_DIRECTORY_NAME in varchar2,
    P_FILE_NAME      in varchar2,
    P_FOLDER         in varchar2 default null
  );

  procedure WRITE_FILE
  (
    P_DIRECTORY_NAME in varchar2,
    P_FILE_NAME      in varchar2,
    P_FILEDATA       in blob,
    P_FOLDER         in varchar2 default null
  );

  procedure MKDIR
  (
    P_DIRECTORY_NAME in varchar2,
    P_FOLDER         in varchar2
  );

end UDO_PKG_FILE_API;
/


create or replace and compile java source named "FileHandler" as
import java.util.*;
import java.lang.*;
import java.io.*;
import oracle.sql.*;
import java.sql.*;

public class FileHandler
{
  private static int SUCCESS = 1;
  private static  int FAILURE = 0;

  public static int exists (String path)
  {
    File lFile = new File (path);
    if (lFile.exists()) return SUCCESS;
    else return FAILURE;
  }

  public static int write(String path, BLOB blob)
  throws    Exception,
            SQLException,
            IllegalAccessException,
            InstantiationException,
            ClassNotFoundException
  {
    try
    {
      File              lFile   = new File(path);
      FileOutputStream  lOutStream  = new FileOutputStream(lFile);
      InputStream       lInStream   = blob.getBinaryStream();

      int     lLength  = -1;
      int     lSize    = blob.getBufferSize();
      byte[]  lBuffer  = new byte[lSize];

      while ((lLength = lInStream.read(lBuffer)) != -1)
      {
        lOutStream.write(lBuffer, 0, lLength);
        lOutStream.flush();
      }

      lInStream.close();
      lOutStream.close();
      return SUCCESS;
    }
    catch (Exception e)
    {
      e.printStackTrace();
      throw e;
    }
  }

  public static int delete (String path) {
    File lFile = new File (path);
    if (lFile.delete()) return SUCCESS; else return FAILURE;
  }

  public static int isDirectory (String path) {
    File lFile = new File (path);
    if (lFile.isDirectory()) return SUCCESS; else return FAILURE;
  }

  public static String getPathSeparator() {
    return File.separator;
  }

  public static int isFile (String path) {
    File lFile = new File (path);
    if (lFile.isFile()) return SUCCESS; else return FAILURE;
  }

  public static int createDirectory (String path)
  throws    Exception,
            IllegalAccessException,
            InstantiationException,
            ClassNotFoundException
  {
    File lDir = new File (path);
    if (!lDir.exists()) {
       try {
        lDir.mkdir();
        return SUCCESS;
       }
       catch(Exception e){
          e.printStackTrace();
          throw e;
       }
    } else {
        return FAILURE;
    }
  }
}
/


/* ������� �� �������� */
create or replace trigger UDO_T_LINKEDDOCS_BDELETE
  before delete on UDO_LINKEDDOCS for each row
begin
  /* ����������� ������� */
  if ( PKG_IUD.PROLOGUE('UDO_LINKEDDOCS', 'D') ) then
    PKG_IUD.REG_RN('RN', :old.RN);
    PKG_IUD.REG_COMPANY('COMPANY', :old.COMPANY);
    PKG_IUD.REG('INT_NAME', :old.INT_NAME);
    PKG_IUD.REG(1, 'UNITCODE', :old.UNITCODE);
    PKG_IUD.REG(2, 'DOCUMENT', :old.DOCUMENT);
    PKG_IUD.REG(3, 'REAL_NAME', :old.REAL_NAME);
    PKG_IUD.REG('UPLOAD_TIME', :old.UPLOAD_TIME);
    PKG_IUD.REG('SAVE_TILL', :old.SAVE_TILL);
    PKG_IUD.REG('FILESIZE', :old.FILESIZE);
    PKG_IUD.REG('AUTHID', :old.AUTHID);
    PKG_IUD.REG('NOTE', :old.NOTE);
    PKG_IUD.REG('FILE_DELETED', :old.FILE_DELETED);
    PKG_IUD.REG('FILESTORE', :old.FILESTORE);
    PKG_IUD.EPILOGUE;
  end if;
end;
/
show errors trigger UDO_T_LINKEDDOCS_BDELETE;


/* ������� ����� �������� */
create or replace trigger UDO_T_LINKEDDOCS_ADELETE
  after delete on UDO_LINKEDDOCS for each row
begin
  /* �������������� ��������� ����� �������� ������ ������� */
  P_LOG_DELETE( :old.RN,'UdoLinkedFiles' );
end;
/
show errors trigger UDO_T_LINKEDDOCS_ADELETE;


/* ������� �� ����������� */
create or replace trigger UDO_T_LINKEDDOCS_BUPDATE
  before update on UDO_LINKEDDOCS for each row
begin
  /* �������� ������������ �������� ����� */
  PKG_UNCHANGE.CHECK_NE('UDO_LINKEDDOCS', 'RN', :new.RN, :old.RN);
  PKG_UNCHANGE.CHECK_NE('UDO_LINKEDDOCS', 'COMPANY', :new.COMPANY, :old.COMPANY);
  PKG_UNCHANGE.CHECK_NE('UDO_LINKEDDOCS', 'INT_NAME', :new.INT_NAME, :old.INT_NAME);
  PKG_UNCHANGE.CHECK_NE('UDO_LINKEDDOCS', 'DOCUMENT', :new.DOCUMENT, :old.DOCUMENT);
  PKG_UNCHANGE.CHECK_NE('UDO_LINKEDDOCS', 'FILESTORE', :new.FILESTORE, :old.FILESTORE);
  PKG_UNCHANGE.CHECK_NE('UDO_LINKEDDOCS', 'AUTHID', :new.AUTHID, :old.AUTHID);

  /* ����������� ������� */
  if ( PKG_IUD.PROLOGUE('UDO_LINKEDDOCS', 'U') ) then
    PKG_IUD.REG_RN('RN', :new.RN, :old.RN);
    PKG_IUD.REG_COMPANY('COMPANY', :new.COMPANY, :old.COMPANY);
    PKG_IUD.REG('INT_NAME', :new.INT_NAME, :old.INT_NAME);
    PKG_IUD.REG(1, 'UNITCODE', :new.UNITCODE, :old.UNITCODE);
    PKG_IUD.REG(2, 'DOCUMENT', :new.DOCUMENT, :old.DOCUMENT);
    PKG_IUD.REG(3, 'REAL_NAME', :new.REAL_NAME, :old.REAL_NAME);
    PKG_IUD.REG('UPLOAD_TIME', :new.UPLOAD_TIME, :old.UPLOAD_TIME);
    PKG_IUD.REG('SAVE_TILL', :new.SAVE_TILL, :old.SAVE_TILL);
    PKG_IUD.REG('FILESIZE', :new.FILESIZE, :old.FILESIZE);
    PKG_IUD.REG('AUTHID', :new.AUTHID, :old.AUTHID);
    PKG_IUD.REG('NOTE', :new.NOTE, :old.NOTE);
    PKG_IUD.REG('FILE_DELETED', :new.FILE_DELETED, :old.FILE_DELETED);
    PKG_IUD.REG('FILESTORE', :new.FILESTORE, :old.FILESTORE);
    PKG_IUD.EPILOGUE;
  end if;
end;
/
show errors trigger UDO_T_LINKEDDOCS_BUPDATE;


create or replace package UDO_PKG_LINKEDDOCS is

  -- Author  : IGOR-GO
  -- Created : 15.01.2016 9:32:04
  -- Purpose :

  cursor CUR_LINKEDDOCS is
    select
    /* ���������������  ����� */
     T.RN as NRN,
     /* �����������  (������ �� COMPANIES(RN)) */
     T.COMPANY as NCOMPANY,
     /* ��� ����� �� ������� (GUID) */
     T.INT_NAME as SINT_NAME,
     /* �������� ������� */
     T.UNITCODE as SUNITCODE,
     /* ��������������� ����� ��������� � ������� */
     T.DOCUMENT as NDOCUMENT,
     /* ��� ����� */
     T.REAL_NAME as SREAL_NAME,
     /* ���� � ����� �������� */
     T.UPLOAD_TIME as DUPLOAD_TIME,
     /* ���� �������� */
     T.SAVE_TILL as DSAVE_TILL,
     /* ����� �������� */
     T.FILESTORE as NFILESTORE,
     /* ������ ����� */
     T.FILESIZE as NFILESIZE,
     /* ������������ ����������� �������� */
     T.AUTHID as SAUTHID,
     /* ������ ��� ������������ */
     U.NAME as SUSERFULLNAME,
     /* ���������� */
     T.NOTE as SNOTE,
     /* ������� ���������� �� ����� �����*/
     T.FILE_DELETED as NFILE_DELETED
      from UDO_LINKEDDOCS T,
           USERLIST       U
     where T.AUTHID = U.AUTHID;

  type T_LINKEDDOCS is table of CUR_LINKEDDOCS%rowtype;

  function V
  (
    NCOMPANY  in number,
    NDOCUMENT in number,
    SUNITCODE in varchar2
  ) return T_LINKEDDOCS
    pipelined;

  procedure DOC_INSERT
  (
    NCOMPANY   in number, -- �����������  (������ �� COMPANIES(RN))
    SUNITCODE  in varchar2, -- �������� �������
    NDOCUMENT  in number, -- ��������������� ����� ��������� � �������
    SREAL_NAME in varchar2, -- ��� �����
    SNOTE      in varchar2, -- ����������
    BFILEDATA  in blob, -- ����
    NRN        out number -- ���������������  �����
  );

  procedure DOC_UPDATE
  (
    NCOMPANY in number, -- �����������  (������ �� COMPANIES(RN))
    NRN      in number, -- ���������������  �����
    SNOTE    in varchar2 -- ����������
  );

  procedure DOC_DELETE
  (
    NCOMPANY in number, -- �����������  (������ �� COMPANIES(RN))
    NRN      in number -- ���������������  �����
  );

  procedure DOWNLOAD
  (
    NCOMPANY  in number, -- �����������  (������ �� COMPANIES(RN))
    NIDENT    in number, -- ������������� ������ ������
    NDOCUMENT in number, -- RN ������ ��������� �������
    SUNITCODE in varchar2, -- ��� ��������� �������
    NFBIDENT  in number -- ������������� ��������� ������
  );

  procedure CLEAR_EXPIRED(NCOMPANY in number);

end UDO_PKG_LINKEDDOCS;
/


grant execute on UDO_PKG_LINKEDDOCS to public;

/* ������� �� ���������� */
create or replace trigger UDO_T_LINKEDDOCS_BINSERT
  before insert on UDO_LINKEDDOCS for each row
begin
  /* ����������� ������� */
  if ( PKG_IUD.PROLOGUE('UDO_LINKEDDOCS', 'I') ) then
    PKG_IUD.REG_RN('RN', :new.RN);
    PKG_IUD.REG_COMPANY('COMPANY', :new.COMPANY);
    PKG_IUD.REG('INT_NAME', :new.INT_NAME);
    PKG_IUD.REG(1, 'UNITCODE', :new.UNITCODE);
    PKG_IUD.REG(2, 'DOCUMENT', :new.DOCUMENT);
    PKG_IUD.REG(3, 'REAL_NAME', :new.REAL_NAME);
    PKG_IUD.REG('UPLOAD_TIME', :new.UPLOAD_TIME);
    PKG_IUD.REG('SAVE_TILL', :new.SAVE_TILL);
    PKG_IUD.REG('FILESIZE', :new.FILESIZE);
    PKG_IUD.REG('AUTHID', :new.AUTHID);
    PKG_IUD.REG('NOTE', :new.NOTE);
    PKG_IUD.REG('FILE_DELETED', :new.FILE_DELETED);
    PKG_IUD.REG('FILESTORE', :new.FILESTORE);
    PKG_IUD.EPILOGUE;
  end if;
end;
/
show errors trigger UDO_T_LINKEDDOCS_BINSERT;


/* ������� ����� ����������� */
create or replace trigger UDO_T_LINKEDDOCS_AUPDATE
  after update on UDO_LINKEDDOCS for each row
begin
  /* �������������� ��������� ����� ����������� ������ ������� */
  P_LOG_UPDATE( :new.RN,'UdoLinkedFiles',null,null,null,null );
end;
/
show errors trigger UDO_T_LINKEDDOCS_AUPDATE;


/* ���� ������� ������ */
alter table UDO_LINKEDDOCS
add
(
-- ����� � �������� �������������
constraint UDO_C_LINKEDDOCS_AUTHID_FK foreign key (AUTHID)
  references USERLIST(AUTHID),
-- ������ �� ������������
constraint UDO_C_LINKEDDOCS_COMPANY_FK foreign key (COMPANY)
  references COMPANIES(RN),
-- ����� � �������� ������ �������� ������ (�����)�
constraint UDO_C_LINKEDDOCS_FILESTORE_FK foreign key (FILESTORE)
  references UDO_FILEFOLDERS(RN),
-- ����� � �������� �������� ��������
constraint UDO_C_LINKEDDOCS_UNIT_FK foreign key (UNITCODE)
  references UNITLIST(UNITCODE)
);


create or replace package body UDO_PKG_FTP_UTIL as

  -- --------------------------------------------------------------------------
  -- Name         : http://www.oracle-base.com/dba/miscellaneous/ftp.pkb
  -- Author       : DR Timothy S Hall
  -- Description  : Basic FTP API. For usage notes see:
  --                  http://www.oracle-base.com/articles/misc/FTPFromPLSQL.php
  -- Requirements : http://www.oracle-base.com/dba/miscellaneous/ftp.pks
  -- Ammedments   :
  --   When         Who       What
  --   ===========  ========  =================================================
  --   14-AUG-2003  Tim Hall  Initial Creation
  --   10-MAR-2004  Tim Hall  Add convert_crlf procedure.
  --                          Incorporate CRLF conversion functionality into
  --                          put_local_ascii_data and put_remote_ascii_data
  --                          functions.
  --                          Make get_passive function visible.
  --                          Added get_direct and put_direct procedures.
  --   23-DEC-2004  Tim Hall  The get_reply procedure was altered to deal with
  --                          banners starting with 4 white spaces. This fix is
  --                          a small variation on the resolution provided by
  --                          Gary Mason who spotted the bug.
  --   10-NOV-2005  Tim Hall  Addition of get_reply after doing a transfer to
  --                          pickup the 226 Transfer complete message. This
  --                          allows gets and puts with a single connection.
  --                          Issue spotted by Trevor Woolnough.
  --   03-OCT-2006  Tim Hall  Add list, rename, delete, mkdir, rmdir procedures.
  --   12-JAN-2007  Tim Hall  A final call to get_reply was added to the get_remote%
  --                          procedures to allow multiple transfers per connection.
  --   15-Jan-2008  Tim Hall  login: Include timeout parameter (suggested by Dmitry Bogomolov).
  --   21-Jan-2008  Tim Hall  put_%: "l_pos < l_clob_len" to "l_pos <= l_clob_len" to prevent
  --                          potential loss of one character for single-byte files or files
  --                          sized 1 byte bigger than a number divisible by the buffer size
  --                          (spotted by Michael Surikov).
  --   23-Jan-2008  Tim Hall  send_command: Possible solution for ORA-29260 errors included,
  --                          but commented out (suggested by Kevin Phillips).
  --   12-Feb-2008  Tim Hall  put_local_binary_data and put_direct: Open file with "wb" for
  --                          binary writes (spotted by Dwayne Hoban).
  --   03-Mar-2008  Tim Hall  list: get_reply call and close of passive connection added
  --                          (suggested by Julian, Bavaria).
  --   12-Jun-2008  Tim Hall  A final call to get_reply was added to the put_remote%
  --                          procedures, but commented out. If uncommented, it may cause the
  --                          operation to hang, but it has been reported (morgul) to allow
  --                          multiple transfers per connection.
  --                          get_reply: Moved to pakage specification.
  --   24-Jun-2008  Tim Hall  get_remote% and put_remote%: Exception handler added to close the passive
  --                          connection and reraise the error (suggested by Mark Reichman).
  --   22-Apr-2009  Tim Hall  get_remote_ascii_data: Remove unnecessary logout (suggested by John Duncan).
  --                          get_reply and list: Handle 400 messages as well as 500 messages (suggested by John Duncan).
  --                          logout: Added a call to UTL_TCP.close_connection, so not necessary to close
  --                          any connections manually (suggested by Victor Munoz).
  --                          get_local_*_data: Check for zero length files to prevent exception (suggested by Daniel)
  --                          nlst: Added to return list of file names only (suggested by Julian and John Duncan)
  -- --------------------------------------------------------------------------

  G_REPLY        T_STRING_TABLE := T_STRING_TABLE();
  G_BINARY       boolean := true;
  G_DEBUG        boolean := true;
  G_CONVERT_CRLF boolean := true;

  procedure DEBUG(P_TEXT in varchar2);

  -- --------------------------------------------------------------------------
  function LOGIN
  (
    P_HOST    in varchar2,
    P_PORT    in varchar2,
    P_USER    in varchar2,
    P_PASS    in varchar2,
    P_TIMEOUT in number := null
  ) return UTL_TCP.CONNECTION is
    -- --------------------------------------------------------------------------
    L_CONN UTL_TCP.CONNECTION;
  begin
    G_REPLY.DELETE;

    L_CONN := UTL_TCP.OPEN_CONNECTION(P_HOST, P_PORT, TX_TIMEOUT => P_TIMEOUT);
    GET_REPLY(L_CONN);
    SEND_COMMAND(L_CONN, 'USER ' || P_USER);
    SEND_COMMAND(L_CONN, 'PASS ' || P_PASS);
    return L_CONN;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  function GET_PASSIVE(P_CONN in out nocopy UTL_TCP.CONNECTION)
    return UTL_TCP.CONNECTION is
    -- --------------------------------------------------------------------------
    L_CONN  UTL_TCP.CONNECTION;
    L_REPLY varchar2(32767);
    L_HOST  varchar(100);
    L_PORT1 number(10);
    L_PORT2 number(10);
  begin
    SEND_COMMAND(P_CONN, 'PASV');
    L_REPLY := G_REPLY(G_REPLY.LAST);

    L_REPLY := replace(SUBSTR(L_REPLY,
                              INSTR(L_REPLY, '(') + 1,
                              (INSTR(L_REPLY, ')')) - (INSTR(L_REPLY, '(')) - 1),
                       ',',
                       '.');
    L_HOST  := SUBSTR(L_REPLY, 1, INSTR(L_REPLY, '.', 1, 4) - 1);

    L_PORT1 := TO_NUMBER(SUBSTR(L_REPLY,
                                INSTR(L_REPLY, '.', 1, 4) + 1,
                                (INSTR(L_REPLY, '.', 1, 5) - 1) -
                                (INSTR(L_REPLY, '.', 1, 4))));
    L_PORT2 := TO_NUMBER(SUBSTR(L_REPLY, INSTR(L_REPLY, '.', 1, 5) + 1));

    L_CONN := UTL_TCP.OPEN_CONNECTION(L_HOST, 256 * L_PORT1 + L_PORT2);
    return L_CONN;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure LOGOUT
  (
    P_CONN  in out nocopy UTL_TCP.CONNECTION,
    P_REPLY in boolean := true
  ) as
    -- --------------------------------------------------------------------------
  begin
    SEND_COMMAND(P_CONN, 'QUIT', P_REPLY);
    UTL_TCP.CLOSE_CONNECTION(P_CONN);
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure SEND_COMMAND
  (
    P_CONN    in out nocopy UTL_TCP.CONNECTION,
    P_COMMAND in varchar2,
    P_REPLY   in boolean := true
  ) is
    -- --------------------------------------------------------------------------
    L_RESULT pls_integer;
  begin
    L_RESULT := UTL_TCP.WRITE_LINE(P_CONN, P_COMMAND);
    -- If you get ORA-29260 after the PASV call, replace the above line with the following line.
    -- l_result := UTL_TCP.write_text(p_conn, p_command || utl_tcp.crlf, length(p_command || utl_tcp.crlf));

    if P_REPLY then
      GET_REPLY(P_CONN);
    end if;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure GET_REPLY(P_CONN in out nocopy UTL_TCP.CONNECTION) is
    -- --------------------------------------------------------------------------
    L_REPLY_CODE varchar2(3) := null;
  begin
    loop
      G_REPLY.EXTEND;
      G_REPLY(G_REPLY.LAST) := UTL_TCP.GET_LINE(P_CONN, true);
      DEBUG(G_REPLY(G_REPLY.LAST));
      if L_REPLY_CODE is null then
        L_REPLY_CODE := SUBSTR(G_REPLY(G_REPLY.LAST), 1, 3);
      end if;
      if SUBSTR(L_REPLY_CODE, 1, 1) in ('4', '5') then
        RAISE_APPLICATION_ERROR(-20000, G_REPLY(G_REPLY.LAST));
      elsif (SUBSTR(G_REPLY(G_REPLY.LAST), 1, 3) = L_REPLY_CODE and
            SUBSTR(G_REPLY(G_REPLY.LAST), 4, 1) = ' ') then
        exit;
      end if;
    end loop;
  exception
    when UTL_TCP.END_OF_INPUT then
      null;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  function GET_LOCAL_ASCII_DATA
  (
    P_DIR  in varchar2,
    P_FILE in varchar2
  ) return clob is
    -- --------------------------------------------------------------------------
    L_BFILE bfile;
    L_DATA  clob;
  begin
    DBMS_LOB.CREATETEMPORARY(LOB_LOC => L_DATA,
                             CACHE   => true,
                             DUR     => DBMS_LOB.CALL);

    L_BFILE := BFILENAME(P_DIR, P_FILE);
    DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);

    if DBMS_LOB.GETLENGTH(L_BFILE) > 0 then
      DBMS_LOB.LOADFROMFILE(L_DATA, L_BFILE, DBMS_LOB.GETLENGTH(L_BFILE));
    end if;

    DBMS_LOB.FILECLOSE(L_BFILE);

    return L_DATA;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  function GET_LOCAL_BINARY_DATA
  (
    P_DIR  in varchar2,
    P_FILE in varchar2
  ) return blob is
    -- --------------------------------------------------------------------------
    L_BFILE bfile;
    L_DATA  blob;
  begin
    DBMS_LOB.CREATETEMPORARY(LOB_LOC => L_DATA,
                             CACHE   => true,
                             DUR     => DBMS_LOB.CALL);

    L_BFILE := BFILENAME(P_DIR, P_FILE);
    DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
    if DBMS_LOB.GETLENGTH(L_BFILE) > 0 then
      DBMS_LOB.LOADFROMFILE(L_DATA, L_BFILE, DBMS_LOB.GETLENGTH(L_BFILE));
    end if;
    DBMS_LOB.FILECLOSE(L_BFILE);

    return L_DATA;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  function GET_REMOTE_ASCII_DATA
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FILE in varchar2
  ) return clob is
    -- --------------------------------------------------------------------------
    L_CONN   UTL_TCP.CONNECTION;
    L_AMOUNT pls_integer;
    L_BUFFER varchar2(32767);
    L_DATA   clob;
  begin
    DBMS_LOB.CREATETEMPORARY(LOB_LOC => L_DATA,
                             CACHE   => true,
                             DUR     => DBMS_LOB.CALL);

    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'RETR ' || P_FILE, true);
    --logout(l_conn, FALSE);

    begin
      loop
        L_AMOUNT := UTL_TCP.READ_TEXT(L_CONN, L_BUFFER, 32767);
        DBMS_LOB.WRITEAPPEND(L_DATA, L_AMOUNT, L_BUFFER);
      end loop;
    exception
      when UTL_TCP.END_OF_INPUT then
        null;
      when others then
        null;
    end;
    UTL_TCP.CLOSE_CONNECTION(L_CONN);
    GET_REPLY(P_CONN);

    return L_DATA;

  exception
    when others then
      UTL_TCP.CLOSE_CONNECTION(L_CONN);
      raise;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  function GET_REMOTE_BINARY_DATA
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FILE in varchar2
  ) return blob is
    -- --------------------------------------------------------------------------
    L_CONN   UTL_TCP.CONNECTION;
    L_AMOUNT pls_integer;
    L_BUFFER raw(32767);
    L_DATA   blob;
  begin
    DBMS_LOB.CREATETEMPORARY(LOB_LOC => L_DATA,
                             CACHE   => true,
                             DUR     => DBMS_LOB.CALL);

    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'RETR ' || P_FILE, true);

    begin
      loop
        L_AMOUNT := UTL_TCP.READ_RAW(L_CONN, L_BUFFER, 32767);
        DBMS_LOB.WRITEAPPEND(L_DATA, L_AMOUNT, L_BUFFER);
      end loop;
    exception
      when UTL_TCP.END_OF_INPUT then
        null;
      when others then
        null;
    end;
    UTL_TCP.CLOSE_CONNECTION(L_CONN);
    GET_REPLY(P_CONN);

    return L_DATA;

  exception
    when others then
      UTL_TCP.CLOSE_CONNECTION(L_CONN);
      raise;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure PUT_LOCAL_ASCII_DATA
  (
    P_DATA in clob,
    P_DIR  in varchar2,
    P_FILE in varchar2
  ) is
    -- --------------------------------------------------------------------------
    L_OUT_FILE UTL_FILE.FILE_TYPE;
    L_BUFFER   varchar2(32767);
    L_AMOUNT   binary_integer := 32767;
    L_POS      integer := 1;
    L_CLOB_LEN integer;
  begin
    L_CLOB_LEN := DBMS_LOB.GETLENGTH(P_DATA);

    L_OUT_FILE := UTL_FILE.FOPEN(P_DIR, P_FILE, 'w', 32767);

    while L_POS <= L_CLOB_LEN loop
      DBMS_LOB.READ(P_DATA, L_AMOUNT, L_POS, L_BUFFER);
      if G_CONVERT_CRLF then
        L_BUFFER := replace(L_BUFFER, CHR(13), null);
      end if;

      UTL_FILE.PUT(L_OUT_FILE, L_BUFFER);
      UTL_FILE.FFLUSH(L_OUT_FILE);
      L_POS := L_POS + L_AMOUNT;
    end loop;

    UTL_FILE.FCLOSE(L_OUT_FILE);
  exception
    when others then
      if UTL_FILE.IS_OPEN(L_OUT_FILE) then
        UTL_FILE.FCLOSE(L_OUT_FILE);
      end if;
      raise;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure PUT_LOCAL_BINARY_DATA
  (
    P_DATA in blob,
    P_DIR  in varchar2,
    P_FILE in varchar2
  ) is
    -- --------------------------------------------------------------------------
    L_OUT_FILE UTL_FILE.FILE_TYPE;
    L_BUFFER   raw(32767);
    L_AMOUNT   binary_integer := 32767;
    L_POS      integer := 1;
    L_BLOB_LEN integer;
  begin
    L_BLOB_LEN := DBMS_LOB.GETLENGTH(P_DATA);

    L_OUT_FILE := UTL_FILE.FOPEN(P_DIR, P_FILE, 'wb', 32767);

    while L_POS <= L_BLOB_LEN loop
      DBMS_LOB.READ(P_DATA, L_AMOUNT, L_POS, L_BUFFER);
      UTL_FILE.PUT_RAW(L_OUT_FILE, L_BUFFER, true);
      UTL_FILE.FFLUSH(L_OUT_FILE);
      L_POS := L_POS + L_AMOUNT;
    end loop;

    UTL_FILE.FCLOSE(L_OUT_FILE);
  exception
    when others then
      if UTL_FILE.IS_OPEN(L_OUT_FILE) then
        UTL_FILE.FCLOSE(L_OUT_FILE);
      end if;
      raise;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure PUT_REMOTE_ASCII_DATA
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FILE in varchar2,
    P_DATA in clob
  ) is
    -- --------------------------------------------------------------------------
    L_CONN     UTL_TCP.CONNECTION;
    L_RESULT   pls_integer;
    L_BUFFER   varchar2(32767);
    L_AMOUNT   binary_integer := 32767;
    L_POS      integer := 1;
    L_CLOB_LEN integer;
  begin
    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'STOR ' || P_FILE, true);

    L_CLOB_LEN := DBMS_LOB.GETLENGTH(P_DATA);

    while L_POS <= L_CLOB_LEN loop
      DBMS_LOB.READ(P_DATA, L_AMOUNT, L_POS, L_BUFFER);
      if G_CONVERT_CRLF then
        L_BUFFER := replace(L_BUFFER, CHR(13), null);
      end if;
      L_RESULT := UTL_TCP.WRITE_TEXT(L_CONN, L_BUFFER, LENGTH(L_BUFFER));
      UTL_TCP.FLUSH(L_CONN);
      L_POS := L_POS + L_AMOUNT;
    end loop;

    UTL_TCP.CLOSE_CONNECTION(L_CONN);
    -- The following line allows some people to make multiple calls from one connection.
    -- It causes the operation to hang for me, hence it is commented out by default.
    -- get_reply(p_conn);

  exception
    when others then
      UTL_TCP.CLOSE_CONNECTION(L_CONN);
      raise;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure PUT_REMOTE_BINARY_DATA
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FILE in varchar2,
    P_DATA in blob
  ) is
    -- --------------------------------------------------------------------------
    L_CONN     UTL_TCP.CONNECTION;
    L_RESULT   pls_integer;
    L_BUFFER   raw(32767);
    L_AMOUNT   binary_integer := 32767;
    L_POS      integer := 1;
    L_BLOB_LEN integer;
  begin
    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'STOR ' || P_FILE, true);

    L_BLOB_LEN := DBMS_LOB.GETLENGTH(P_DATA);

    while L_POS <= L_BLOB_LEN loop
      DBMS_LOB.READ(P_DATA, L_AMOUNT, L_POS, L_BUFFER);
      L_RESULT := UTL_TCP.WRITE_RAW(L_CONN, L_BUFFER, L_AMOUNT);
      UTL_TCP.FLUSH(L_CONN);
      L_POS := L_POS + L_AMOUNT;
    end loop;

    UTL_TCP.CLOSE_CONNECTION(L_CONN);
    -- The following line allows some people to make multiple calls from one connection.
    -- It causes the operation to hang for me, hence it is commented out by default.
    -- get_reply(p_conn);

  exception
    when others then
      UTL_TCP.CLOSE_CONNECTION(L_CONN);
      raise;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure GET
  (
    P_CONN      in out nocopy UTL_TCP.CONNECTION,
    P_FROM_FILE in varchar2,
    P_TO_DIR    in varchar2,
    P_TO_FILE   in varchar2
  ) as
    -- --------------------------------------------------------------------------
  begin
    if G_BINARY then
      PUT_LOCAL_BINARY_DATA(P_DATA => GET_REMOTE_BINARY_DATA(P_CONN,
                                                             P_FROM_FILE),
                            P_DIR  => P_TO_DIR,
                            P_FILE => P_TO_FILE);
    else
      PUT_LOCAL_ASCII_DATA(P_DATA => GET_REMOTE_ASCII_DATA(P_CONN, P_FROM_FILE),
                           P_DIR  => P_TO_DIR,
                           P_FILE => P_TO_FILE);
    end if;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure PUT
  (
    P_CONN      in out nocopy UTL_TCP.CONNECTION,
    P_FROM_DIR  in varchar2,
    P_FROM_FILE in varchar2,
    P_TO_FILE   in varchar2
  ) as
    -- --------------------------------------------------------------------------
  begin
    if G_BINARY then
      PUT_REMOTE_BINARY_DATA(P_CONN => P_CONN,
                             P_FILE => P_TO_FILE,
                             P_DATA => GET_LOCAL_BINARY_DATA(P_FROM_DIR,
                                                             P_FROM_FILE));
    else
      PUT_REMOTE_ASCII_DATA(P_CONN => P_CONN,
                            P_FILE => P_TO_FILE,
                            P_DATA => GET_LOCAL_ASCII_DATA(P_FROM_DIR,
                                                           P_FROM_FILE));
    end if;
    GET_REPLY(P_CONN);
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure GET_DIRECT
  (
    P_CONN      in out nocopy UTL_TCP.CONNECTION,
    P_FROM_FILE in varchar2,
    P_TO_DIR    in varchar2,
    P_TO_FILE   in varchar2
  ) is
    -- --------------------------------------------------------------------------
    L_CONN       UTL_TCP.CONNECTION;
    L_OUT_FILE   UTL_FILE.FILE_TYPE;
    L_AMOUNT     pls_integer;
    L_BUFFER     varchar2(32767);
    L_RAW_BUFFER raw(32767);
  begin
    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'RETR ' || P_FROM_FILE, true);
    if G_BINARY then
      L_OUT_FILE := UTL_FILE.FOPEN(P_TO_DIR, P_TO_FILE, 'wb', 32767);
    else
      L_OUT_FILE := UTL_FILE.FOPEN(P_TO_DIR, P_TO_FILE, 'w', 32767);
    end if;

    begin
      loop
        if G_BINARY then
          L_AMOUNT := UTL_TCP.READ_RAW(L_CONN, L_RAW_BUFFER, 32767);
          UTL_FILE.PUT_RAW(L_OUT_FILE, L_RAW_BUFFER, true);
        else
          L_AMOUNT := UTL_TCP.READ_TEXT(L_CONN, L_BUFFER, 32767);
          if G_CONVERT_CRLF then
            L_BUFFER := replace(L_BUFFER, CHR(13), null);
          end if;
          UTL_FILE.PUT(L_OUT_FILE, L_BUFFER);
        end if;
        UTL_FILE.FFLUSH(L_OUT_FILE);
      end loop;
    exception
      when UTL_TCP.END_OF_INPUT then
        null;
      when others then
        null;
    end;
    UTL_FILE.FCLOSE(L_OUT_FILE);
    UTL_TCP.CLOSE_CONNECTION(L_CONN);
  exception
    when others then
      if UTL_FILE.IS_OPEN(L_OUT_FILE) then
        UTL_FILE.FCLOSE(L_OUT_FILE);
      end if;
      raise;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure PUT_DIRECT
  (
    P_CONN      in out nocopy UTL_TCP.CONNECTION,
    P_FROM_DIR  in varchar2,
    P_FROM_FILE in varchar2,
    P_TO_FILE   in varchar2
  ) is
    -- --------------------------------------------------------------------------
    L_CONN       UTL_TCP.CONNECTION;
    L_BFILE      bfile;
    L_RESULT     pls_integer;
    L_AMOUNT     pls_integer := 32767;
    L_RAW_BUFFER raw(32767);
    L_LEN        number;
    L_POS        number := 1;
    EX_ASCII exception;
  begin
    if not G_BINARY then
      raise EX_ASCII;
    end if;

    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'STOR ' || P_TO_FILE, true);

    L_BFILE := BFILENAME(P_FROM_DIR, P_FROM_FILE);

    DBMS_LOB.FILEOPEN(L_BFILE, DBMS_LOB.FILE_READONLY);
    L_LEN := DBMS_LOB.GETLENGTH(L_BFILE);

    while L_POS <= L_LEN loop
      DBMS_LOB.READ(L_BFILE, L_AMOUNT, L_POS, L_RAW_BUFFER);
      DEBUG(L_AMOUNT);
      L_RESULT := UTL_TCP.WRITE_RAW(L_CONN, L_RAW_BUFFER, L_AMOUNT);
      L_POS    := L_POS + L_AMOUNT;
    end loop;

    DBMS_LOB.FILECLOSE(L_BFILE);
    UTL_TCP.CLOSE_CONNECTION(L_CONN);
  exception
    when EX_ASCII then
      RAISE_APPLICATION_ERROR(-20000,
                              'PUT_DIRECT not available in ASCII mode.');
    when others then
      if DBMS_LOB.FILEISOPEN(L_BFILE) = 1 then
        DBMS_LOB.FILECLOSE(L_BFILE);
      end if;
      raise;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure HELP(P_CONN in out nocopy UTL_TCP.CONNECTION) as
    -- --------------------------------------------------------------------------
  begin
    SEND_COMMAND(P_CONN, 'HELP', true);
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure ASCII(P_CONN in out nocopy UTL_TCP.CONNECTION) as
    -- --------------------------------------------------------------------------
  begin
    SEND_COMMAND(P_CONN, 'TYPE A', true);
    G_BINARY := false;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure BINARY(P_CONN in out nocopy UTL_TCP.CONNECTION) as
    -- --------------------------------------------------------------------------
  begin
    SEND_COMMAND(P_CONN, 'TYPE I', true);
    G_BINARY := true;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure LIST
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_DIR  in varchar2,
    P_LIST out T_STRING_TABLE
  ) as
    -- --------------------------------------------------------------------------
    L_CONN       UTL_TCP.CONNECTION;
    L_LIST       T_STRING_TABLE := T_STRING_TABLE();
    L_REPLY_CODE varchar2(3) := null;
  begin
    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'LIST ' || P_DIR, true);

    begin
      loop
        L_LIST.EXTEND;
        L_LIST(L_LIST.LAST) := UTL_TCP.GET_LINE(L_CONN, true);
        DEBUG(L_LIST(L_LIST.LAST));
        if L_REPLY_CODE is null then
          L_REPLY_CODE := SUBSTR(L_LIST(L_LIST.LAST), 1, 3);
        end if;
        if SUBSTR(L_REPLY_CODE, 1, 1) in ('4', '5') then
          RAISE_APPLICATION_ERROR(-20000, L_LIST(L_LIST.LAST));
        elsif (SUBSTR(G_REPLY(G_REPLY.LAST), 1, 3) = L_REPLY_CODE and
              SUBSTR(G_REPLY(G_REPLY.LAST), 4, 1) = ' ') then
          exit;
        end if;
      end loop;
    exception
      when UTL_TCP.END_OF_INPUT then
        null;
    end;

    L_LIST.DELETE(L_LIST.LAST);
    P_LIST := L_LIST;

    UTL_TCP.CLOSE_CONNECTION(L_CONN);
    GET_REPLY(P_CONN);
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure NLST
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_DIR  in varchar2,
    P_LIST out T_STRING_TABLE
  ) as
    -- --------------------------------------------------------------------------
    L_CONN       UTL_TCP.CONNECTION;
    L_LIST       T_STRING_TABLE := T_STRING_TABLE();
    L_REPLY_CODE varchar2(3) := null;
  begin
    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'NLST ' || P_DIR, true);

    begin
      loop
        L_LIST.EXTEND;
        L_LIST(L_LIST.LAST) := UTL_TCP.GET_LINE(L_CONN, true);
        DEBUG(L_LIST(L_LIST.LAST));
        if L_REPLY_CODE is null then
          L_REPLY_CODE := SUBSTR(L_LIST(L_LIST.LAST), 1, 3);
        end if;
        if SUBSTR(L_REPLY_CODE, 1, 1) in ('4', '5') then
          RAISE_APPLICATION_ERROR(-20000, L_LIST(L_LIST.LAST));
        elsif (SUBSTR(G_REPLY(G_REPLY.LAST), 1, 3) = L_REPLY_CODE and
              SUBSTR(G_REPLY(G_REPLY.LAST), 4, 1) = ' ') then
          exit;
        end if;
      end loop;
    exception
      when UTL_TCP.END_OF_INPUT then
        null;
    end;

    L_LIST.DELETE(L_LIST.LAST);
    P_LIST := L_LIST;

    UTL_TCP.CLOSE_CONNECTION(L_CONN);
    GET_REPLY(P_CONN);
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure RENAME
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FROM in varchar2,
    P_TO   in varchar2
  ) as
    -- --------------------------------------------------------------------------
    L_CONN UTL_TCP.CONNECTION;
  begin
    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'RNFR ' || P_FROM, true);
    SEND_COMMAND(P_CONN, 'RNTO ' || P_TO, true);
    LOGOUT(L_CONN, false);
  end RENAME;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure delete
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_FILE in varchar2
  ) as
    -- --------------------------------------------------------------------------
    L_CONN UTL_TCP.CONNECTION;
  begin
    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'DELE ' || P_FILE, true);
    LOGOUT(L_CONN, false);
  end delete;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure MKDIR
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_DIR  in varchar2
  ) as
    -- --------------------------------------------------------------------------
    L_CONN UTL_TCP.CONNECTION;
  begin
    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'MKD ' || P_DIR, true);
    LOGOUT(L_CONN, false);
  end MKDIR;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure RMDIR
  (
    P_CONN in out nocopy UTL_TCP.CONNECTION,
    P_DIR  in varchar2
  ) as
    -- --------------------------------------------------------------------------
    L_CONN UTL_TCP.CONNECTION;
  begin
    L_CONN := GET_PASSIVE(P_CONN);
    SEND_COMMAND(P_CONN, 'RMD ' || P_DIR, true);
    LOGOUT(L_CONN, false);
  end RMDIR;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure CONVERT_CRLF(P_STATUS in boolean) as
    -- --------------------------------------------------------------------------
  begin
    G_CONVERT_CRLF := P_STATUS;
  end;
  -- --------------------------------------------------------------------------

  -- --------------------------------------------------------------------------
  procedure DEBUG(P_TEXT in varchar2) is
    -- --------------------------------------------------------------------------
  begin
    if G_DEBUG then
      DBMS_OUTPUT.PUT_LINE(SUBSTR(P_TEXT, 1, 255));
    end if;
  end;
  -- --------------------------------------------------------------------------

end UDO_PKG_FTP_UTIL;
/


create or replace package body UDO_PKG_FILE_API is

  PATH_SEPARATOR varchar2(1);

  /*������� Java ������� */
  function SEPARATOR_ return varchar2 is
    language java name 'FileHandler.getPathSeparator() return java.lang.String';

  function EXISTS_(P_FILENAME in varchar2) return number is
    language java name 'FileHandler.exists(java.lang.String) return integer';

  function MAKE_DIR_(P_FILENAME in varchar2) return number is
    language java name 'FileHandler.createDirectory(java.lang.String) return integer';

  function DELETE_(P_FILENAME in varchar2) return number is
    language java name 'FileHandler.delete(java.lang.String) return integer';

  function WRITE_
  (
    P_FILENAME in varchar2,
    P_BLOB     in blob
  ) return number is
    language java name 'FileHandler.write(java.lang.String, oracle.sql.BLOB) return integer';

  function IS_DIRECTORY_(P_FILENAME in varchar2) return number is
    language java name 'FileHandler.isDirectory(java.lang.String) return integer';

  function IS_FILE_(P_FILENAME in varchar2) return number is
    language java name 'FileHandler.isFile(java.lang.String) return integer';

  function GET_DIRECTORY_PATH(P_DIRECTORY_NAME in varchar2) return varchar2 is
    cursor LC_DIR is
      select DIRECTORY_PATH
        from ALL_DIRECTORIES
       where DIRECTORY_NAME = P_DIRECTORY_NAME;
    L_DIRECTORY_PATH PKG_STD.TSTRING;
  begin
    open LC_DIR;
    fetch LC_DIR
      into L_DIRECTORY_PATH;
    close LC_DIR;
    return L_DIRECTORY_PATH;
  end;

  function GET_FULL_FILE_NAME_
  (
    P_DIRECTORY_NAME in varchar2,
    P_FILE_NAME      in varchar2,
    P_FOLDER         in varchar2
  ) return varchar2 is
    L_FILE_NAME PKG_STD.TSTRING;
  begin
    if P_FOLDER is null then
      L_FILE_NAME := P_FILE_NAME;
    else
      L_FILE_NAME := P_FOLDER || PATH_SEPARATOR || P_FILE_NAME;
    end if;
    return GET_DIRECTORY_PATH(P_DIRECTORY_NAME) || PATH_SEPARATOR || L_FILE_NAME;
  end;

  procedure DELETE_FILE
  (
    P_DIRECTORY_NAME in varchar2,
    P_FILE_NAME      in varchar2,
    P_FOLDER         in varchar2 default null
  ) is
  begin
    if DELETE_(GET_FULL_FILE_NAME_(P_DIRECTORY_NAME, P_FILE_NAME, P_FOLDER)) = 0 then
      P_EXCEPTION(0, '������ �������� �����');
    end if;
  end;

  procedure WRITE_FILE
  (
    P_DIRECTORY_NAME in varchar2,
    P_FILE_NAME      in varchar2,
    P_FILEDATA       in blob,
    P_FOLDER         in varchar2 default null
  ) is
  begin
    if WRITE_(GET_FULL_FILE_NAME_(P_DIRECTORY_NAME, P_FILE_NAME, P_FOLDER), P_FILEDATA) = 0 then
      P_EXCEPTION(0, '������ ������ �����');
    end if;
  end;

  procedure MKDIR
  (
    P_DIRECTORY_NAME in varchar2,
    P_FOLDER         in varchar2
  ) is
    L_PATH PKG_STD.TSTRING;
  begin
    L_PATH := GET_DIRECTORY_PATH(P_DIRECTORY_NAME) || PATH_SEPARATOR || P_FOLDER;
    if MAKE_DIR_(L_PATH) = 0 then
      P_EXCEPTION(0, '������ �������� �����');
    end if;
  end;

  function READ_FILE
  (
    P_DIRECTORY_NAME in varchar2,
    P_FILE_NAME      in varchar2,
    P_FOLDER         in varchar2 default null
  ) return blob is
    L_BLOB      blob;
    L_BLOB_TMP  blob;
    L_FILE      bfile;
    L_FILE_NAME PKG_STD.TSTRING;
  begin
    if P_FOLDER is null then
      L_FILE_NAME := P_FILE_NAME;
    else
      L_FILE_NAME := P_FOLDER || PATH_SEPARATOR || P_FILE_NAME;
    end if;
    L_FILE := BFILENAME(P_DIRECTORY_NAME, L_FILE_NAME);
    DBMS_LOB.OPEN(L_FILE, DBMS_LOB.LOB_READONLY);
    DBMS_LOB.CREATETEMPORARY(L_BLOB_TMP, false);
    DBMS_LOB.LOADFROMFILE(DEST_LOB => L_BLOB_TMP,
                          SRC_LOB  => L_FILE,
                          AMOUNT   => DBMS_LOB.GETLENGTH(L_FILE));
    DBMS_LOB.CLOSE(L_FILE);
    L_BLOB := L_BLOB_TMP;
    DBMS_LOB.FREETEMPORARY(L_BLOB_TMP);
    return L_BLOB;
  end;

begin
  PATH_SEPARATOR := SEPARATOR_;
end UDO_PKG_FILE_API;
/


create or replace package UDO_PKG_LINKEDDOCS_BASE is
  procedure DOC_INSERT
  (
    NCOMPANY   in number, -- �����������  (������ �� COMPANIES(RN))
    SUNITCODE  in varchar2, -- �������� �������
    NDOCUMENT  in number, -- ��������������� ����� ��������� � �������
    SREAL_NAME in varchar2, -- ��� �����
    SNOTE      in varchar2, -- ����������
    NFILESIZE  in number, -- ������ �����
    NFILESTORE in number, -- ���������
    NLIFETIME  in number, -- ���� ��������
    BFILEDATA  in blob, -- ����
    NRN        out number -- ���������������  �����
  );

  procedure DOC_UPDATE
  (
    NRN           in number, -- ���������������  �����
    NCOMPANY      in number, -- �����������  (������ �� COMPANIES(RN))
    SREAL_NAME    in varchar2, -- ��� �����
    SNOTE         in varchar2, -- ����������
    NFILE_DELETED in number -- ������� ���������� �� ����� �����
  );

  /* ���������� ������ */
  procedure DOC_EXISTS
  (
    NRN      in number, -- ���������������  �����
    NCOMPANY in number, -- �����������  (������ �� COMPANIES(RN))
    REC      out UDO_LINKEDDOCS%rowtype
  );

  /* �������� ������ */
  procedure DOC_DELETE
  (
    NCOMPANY      in number, -- �����������  (������ �� COMPANIES(RN))
    NRN           in number, -- ���������������  �����
    ONLY_IN_STORE in boolean default false -- ������� ������ � ���������
  );

  procedure FILE_TO_BUFFER
  (
    NFILE   in number,
    NBUFFER in number
  );

end UDO_PKG_LINKEDDOCS_BASE;
/


create or replace package body UDO_PKG_LINKEDDOCS is
  FUNC_STANDART_INSERT  constant integer := 1;
  FUNC_STANDART_UPDATE  constant integer := 2;
  FUNC_STANDART_DELETE  constant integer := 3;
  LINKEDDOC_FUNC_INSERT constant varchar2(30) := 'UDO_LINKEDDOCS_INSERT';
  LINKEDDOC_FUNC_UPDATE constant varchar2(30) := 'UDO_LINKEDDOCS_UPDATE';
  LINKEDDOC_FUNC_DELETE constant varchar2(30) := 'UDO_LINKEDDOCS_DELETE';
  LINKEDDOC_FUNC_DLOAD  constant varchar2(30) := 'UDO_LINKEDDOCS_DOWNLOAD';
  LINKEDDOC_TABLENAME   constant varchar2(30) := 'UDO_LINKEDDOCS';
  LINKEDDOC_UNITCODE    constant varchar2(30) := 'UdoLinkedFiles';
  NOPRIV_INS_MSG        constant varchar2(200) := '� ��� ����� �� ������������� ������ � ���� ������ �������.';
  NOPRIV_UPD_MSG        constant varchar2(200) := '� ��� ����� �� ��������� �������������� � ���� ������ ������� ������.';
  NOPRIV_DEL_MSG        constant varchar2(200) := '� ��� ����� �� �������� �������������� � ���� ������ ������� ������.';
  EXMSG_ADD_NOTALLOW    constant varchar2(200) := '���������� �������������� ������ � ������ ������� �%S� ����������.';
  EXMSG_ADD_BLOCKED     constant varchar2(200) := '���������� �������������� ������ � ������ ������� �%S� ������������� ���������������.';
  EXMSG_EMPTY_FILE      constant varchar2(200) := '���������� ������� ����� �����������.';
  EXMSG_TOOBIG_FILE     constant varchar2(200) := '���������� ����������. ������ ����� �� ������ ��������� %S �����.';
  EXMSG_TOOMANY_FILES   constant varchar2(200) := '���������� ����������. ������������ ���������� �������������� ������ - %S.';

  procedure GET_UNIT_ATTRIBUTES
  (
    NCOMPANY       in number,
    NDOCUMENT      in number,
    SUNITCODE      in varchar2,
    NCRN           out number,
    NJUR_PERS      out number,
    NSHARE_COMPANY out number,
    SMASTERCODE    out varchar2
  ) is
    cursor LC_UNITPARAMS is
      select R.RN,
             NVL(U.MASTERCODE, U.UNITCODE) MASTERCODE
        from UDO_FILERULES R,
             UNITLIST      U
       where R.COMPANY = NCOMPANY
         and R.UNITCODE = SUNITCODE
         and R.UNITCODE = U.UNITCODE;
    L_UNITPARAMS LC_UNITPARAMS%rowtype;
    L_FOUND      boolean;
    L_COMPANY    COMPANIES.RN%type;
    L_VERSION    VERSIONS.RN%type;
    L_HIERARCHY  HIERARCHY.RN%type;
  begin
    /* ���������� ��������� ������� */
    open LC_UNITPARAMS;
    fetch LC_UNITPARAMS
      into L_UNITPARAMS;
    close LC_UNITPARAMS;

    if L_UNITPARAMS.RN is null then
      return;
    end if;
    PKG_DOCUMENT.GET_ATTRS(NFLAG_SMART => 0,
                           SUNITCODE   => SUNITCODE,
                           NDOCUMENT   => NDOCUMENT,
                           BFOUND      => L_FOUND,
                           NCOMPANY    => L_COMPANY,
                           NVERSION    => L_VERSION,
                           NCATALOG    => NCRN,
                           NJUR_PERS   => NJUR_PERS,
                           NHIERARCHY  => L_HIERARCHY);

    if L_VERSION is not null then
      NSHARE_COMPANY := NCOMPANY;
    else
      NSHARE_COMPANY := L_COMPANY;
    end if;
    SMASTERCODE := L_UNITPARAMS.MASTERCODE;
  end;

  procedure CHECK_PRIVILEGE
  (
    NCOMPANY  in number,
    NDOCUMENT in number,
    SUNITCODE in varchar2,
    NFUNC     in number, -- FUNC_STANDART_INSERT-INSERT,2-UPDATE',3-DELETE
    SMESS     in varchar2
  ) is
    cursor LC_FUNCCODE is
      select CODE
        from UNITFUNC T
       where T.UNITCODE = SUNITCODE
         and T.STANDARD = NFUNC;
    L_FUNC          UNITFUNC.CODE%type;
    L_CRN           ACATALOG.RN%type;
    L_JURPERS       JURPERSONS.RN%type;
    L_SHARE_COMPANY COMPANIES.RN%type;
    L_MASTERCODE    UNITLIST.UNITCODE%type;
  begin
    open LC_FUNCCODE;
    fetch LC_FUNCCODE
      into L_FUNC;
    close LC_FUNCCODE;
    GET_UNIT_ATTRIBUTES(NCOMPANY, NDOCUMENT, SUNITCODE, L_CRN, L_JURPERS, L_SHARE_COMPANY, L_MASTERCODE);
    PKG_ENV.ACCESS(NCOMPANY  => L_SHARE_COMPANY,
                   NVERSION  => null,
                   NCATALOG  => L_CRN,
                   NJUR_PERS => L_JURPERS,
                   SUNIT     => SUNITCODE,
                   SACTION   => L_FUNC,
                   SALTMSG   => SMESS);
  end;

  /* ���������� ������������� */
  function V
  (
    NCOMPANY  in number,
    NDOCUMENT in number,
    SUNITCODE in varchar2
  ) return T_LINKEDDOCS
    pipelined is
    type T_RES_CUR_TYP is ref cursor;
    L_RES_CUR T_RES_CUR_TYP;
    C_SQL            constant PKG_STD.TSQL := 'select T.RN           as NRN,' || CHR(10) ||
                                              '       T.COMPANY      as NCOMPANY,' || CHR(10) ||
                                              '       T.INT_NAME     as SINT_NAME,' || CHR(10) ||
                                              '       T.UNITCODE     as SUNITCODE,' || CHR(10) ||
                                              '       T.DOCUMENT     as NDOCUMENT,' || CHR(10) ||
                                              '       T.REAL_NAME    as SREAL_NAME,' || CHR(10) ||
                                              '       T.UPLOAD_TIME  as DUPLOAD_TIME,' || CHR(10) ||
                                              '       T.SAVE_TILL    as DSAVE_TILL,' || CHR(10) ||
                                              '       T.FILESTORE    as NFILESTORE,' || CHR(10) ||
                                              '       T.FILESIZE     as NFILESIZE,' || CHR(10) ||
                                              '       T.AUTHID       as SAUTHID,' || CHR(10) ||
                                              '       U.NAME         as SUSERFULLNAME,' || CHR(10) ||
                                              '       T.NOTE         as SNOTE,' || CHR(10) ||
                                              '       T.FILE_DELETED as NFILE_DELETED' || CHR(10) ||
                                              '  from UDO_LINKEDDOCS T,' || CHR(10) || '       USERLIST       U' ||
                                              CHR(10) || ' where T.AUTHID = U.AUTHID' || CHR(10) ||
                                              '   and T.DOCUMENT = :1' || CHR(10) || '   and T.UNITCODE = :2';
    C_SQL_CTLG_PRIV  constant PKG_STD.TSQL := CHR(10) ||
                                              '   and exists(select * from V_USERPRIV UP where UP.CATALOG  = :3)';
    C_SQL_JPERS_PRIV constant PKG_STD.TSQL := CHR(10) ||
                                              '   and exists( select * from V_USERPRIV UP where UP.JUR_PERS = :4 and UP.UNITCODE=:5)';
    L_CRN           ACATALOG.RN%type;
    L_JURPERS       JURPERSONS.RN%type;
    L_RES_ROW       CUR_LINKEDDOCS%rowtype;
    L_SHARE_COMPANY COMPANIES.RN%type;
    L_MASTERCODE    UNITLIST.UNITCODE%type;
  begin
    GET_UNIT_ATTRIBUTES(NCOMPANY, NDOCUMENT, SUNITCODE, L_CRN, L_JURPERS, L_SHARE_COMPANY, L_MASTERCODE);

    if L_CRN is null and L_JURPERS is null then
      open L_RES_CUR for C_SQL
        using NDOCUMENT, SUNITCODE;
    elsif L_CRN is not null and L_JURPERS is null then
      open L_RES_CUR for C_SQL || C_SQL_CTLG_PRIV
        using NDOCUMENT, SUNITCODE, L_CRN;
    elsif L_CRN is null and L_JURPERS is not null then
      open L_RES_CUR for C_SQL || C_SQL_JPERS_PRIV
        using NDOCUMENT, SUNITCODE, L_JURPERS, L_MASTERCODE;
    else
      /*      P_EXCEPTION(0,C_SQL || C_SQL_CTLG_PRIV || C_SQL_JPERS_PRIV || CR ||
            'NDOCUMENT=%S'||CR||'SUNITCODET=%S'||CR||'L_CRNT=%S'||CR||'L_JURPERST=%S'||CR||'SUNITCODE=%S',
            NDOCUMENT, SUNITCODE, L_CRN, L_JURPERS, SUNITCODE
            );
      */
      open L_RES_CUR for C_SQL || C_SQL_CTLG_PRIV || C_SQL_JPERS_PRIV
        using NDOCUMENT, SUNITCODE, L_CRN, L_JURPERS, L_MASTERCODE;
    end if;
    loop
      fetch L_RES_CUR
        into L_RES_ROW;
      exit when L_RES_CUR%notfound;
      pipe row(L_RES_ROW);
    end loop;

    close L_RES_CUR;
  end V;

  procedure DOC_INSERT
  (
    NCOMPANY   in number, -- �����������  (������ �� COMPANIES(RN))
    SUNITCODE  in varchar2, -- �������� �������
    NDOCUMENT  in number, -- ��������������� ����� ��������� � �������
    SREAL_NAME in varchar2, -- ��� �����
    SNOTE      in varchar2, -- ����������
    BFILEDATA  in blob, -- ����
    NRN        out number -- ���������������  �����
  ) is
    cursor LC_RULE is
      select T.*,
             (select RS.TEXT
                from V_RESOURCES_LOCAL RS
               where RS.TABLE_NAME = 'UNITLIST'
                 and RS.COLUMN_NAME = 'UNITNAME'
                 and RS.RN = UL.RN) as UNITNAME
        from UDO_FILERULES T,
             UNITLIST      UL
       where T.COMPANY = NCOMPANY
         and T.UNITCODE(+) = UL.UNITCODE
         and UL.UNITCODE = SUNITCODE;
    L_RULE LC_RULE%rowtype;

    cursor LC_FILESCNT is
      select count(*)
        from UDO_LINKEDDOCS T
       where T.COMPANY = NCOMPANY
         and T.DOCUMENT = NDOCUMENT
         and T.UNITCODE = SUNITCODE;
    L_FILESCNT number;
    L_FILESIZE number;
  begin
    /* ��������� ������� �������� �������������� ������ */
    open LC_RULE;
    fetch LC_RULE
      into L_RULE;
    close LC_RULE;
    /* ������������� ���������� */
    if L_RULE.BLOCKED is null then
      P_EXCEPTION(0, EXMSG_ADD_NOTALLOW, L_RULE.UNITNAME);
    end if;
    /* ������������� ������������� */
    if L_RULE.BLOCKED = 1 then
      P_EXCEPTION(0, EXMSG_ADD_BLOCKED, L_RULE.UNITNAME);
    end if;
    /* ���������� ������ ����� � ������� */
    L_FILESIZE := DBMS_LOB.GETLENGTH(BFILEDATA) / 1024;
    /* ������ ���� */
    if BFILEDATA is null or L_FILESIZE = 0 then
      P_EXCEPTION(0, EXMSG_EMPTY_FILE);
    end if;
    /* ��������� ����������� ���������� ������ */
    if L_RULE.MAXFILESIZE > 0 and L_FILESIZE > L_RULE.MAXFILESIZE then
      P_EXCEPTION(0, EXMSG_TOOBIG_FILE, L_RULE.MAXFILESIZE);
    end if;
    /* ��������� ����������� ���������� �-�� ������ */
    if L_RULE.MAXFILES > 0 then
      open LC_FILESCNT;
      fetch LC_FILESCNT
        into L_FILESCNT;
      close LC_FILESCNT;
      if L_FILESCNT >= L_RULE.MAXFILES then
        P_EXCEPTION(0, EXMSG_TOOMANY_FILES, L_RULE.MAXFILES);
      end if;
    end if;
    /* ��������� ����� �� ���������� ������ � ������� */
    CHECK_PRIVILEGE(NCOMPANY, NDOCUMENT, SUNITCODE, FUNC_STANDART_INSERT, NOPRIV_INS_MSG);
    /* �������� ������ ���������� �������� */
    PKG_ENV.PROLOGUE(NCOMPANY, null, null, null, null, LINKEDDOC_UNITCODE, LINKEDDOC_FUNC_INSERT, LINKEDDOC_TABLENAME);
    UDO_PKG_LINKEDDOCS_BASE.DOC_INSERT(NCOMPANY   => NCOMPANY,
                                       SUNITCODE  => SUNITCODE,
                                       NDOCUMENT  => NDOCUMENT,
                                       SREAL_NAME => SREAL_NAME,
                                       SNOTE      => SNOTE,
                                       NFILESIZE  => L_FILESIZE,
                                       NFILESTORE => L_RULE.FILESTORE,
                                       NLIFETIME  => L_RULE.LIFETIME,
                                       BFILEDATA  => BFILEDATA,
                                       NRN        => NRN);
    /* �������� ��������� ���������� �������� */
    PKG_ENV.EPILOGUE(NCOMPANY,
                     null,
                     null,
                     null,
                     null,
                     LINKEDDOC_UNITCODE,
                     LINKEDDOC_FUNC_INSERT,
                     LINKEDDOC_TABLENAME,
                     NRN);
  end;

  procedure DOC_UPDATE
  (
    NCOMPANY in number, -- �����������  (������ �� COMPANIES(RN))
    NRN      in number, -- ���������������  �����
    SNOTE    in varchar2 -- ����������
  ) is
    L_REC UDO_LINKEDDOCS%rowtype;
  begin
    /* ���������� ������ */
    UDO_PKG_LINKEDDOCS_BASE.DOC_EXISTS(NRN => NRN, NCOMPANY => NCOMPANY, REC => L_REC);

    /* ��������� ����� �� ���������� ������ � ������� */
    CHECK_PRIVILEGE(NCOMPANY, L_REC.DOCUMENT, L_REC.UNITCODE, FUNC_STANDART_UPDATE, NOPRIV_UPD_MSG);

    /* �������� ������ ���������� �������� */
    PKG_ENV.PROLOGUE(NCOMPANY,
                     null,
                     null,
                     null,
                     null,
                     LINKEDDOC_UNITCODE,
                     LINKEDDOC_FUNC_UPDATE,
                     LINKEDDOC_TABLENAME,
                     NRN);

    /* ������� ����������� */
    UDO_PKG_LINKEDDOCS_BASE.DOC_UPDATE(NRN           => NRN,
                                       NCOMPANY      => NCOMPANY,
                                       SREAL_NAME    => L_REC.REAL_NAME,
                                       SNOTE         => SNOTE,
                                       NFILE_DELETED => L_REC.FILE_DELETED);

    /* �������� ��������� ���������� �������� */
    PKG_ENV.EPILOGUE(NCOMPANY,
                     null,
                     null,
                     null,
                     null,
                     LINKEDDOC_UNITCODE,
                     LINKEDDOC_FUNC_UPDATE,
                     LINKEDDOC_TABLENAME,
                     NRN);
  end;

  procedure DOC_DELETE
  (
    NCOMPANY in number, -- �����������  (������ �� COMPANIES(RN))
    NRN      in number -- ���������������  �����
  ) is
    L_REC UDO_LINKEDDOCS%rowtype;
  begin
    /* ���������� ������ */
    UDO_PKG_LINKEDDOCS_BASE.DOC_EXISTS(NRN => NRN, NCOMPANY => NCOMPANY, REC => L_REC);

    /* ��������� ����� �� ���������� ������ � ������� */
    CHECK_PRIVILEGE(NCOMPANY, L_REC.DOCUMENT, L_REC.UNITCODE, FUNC_STANDART_DELETE, NOPRIV_DEL_MSG);

    /* �������� ������ ���������� �������� */
    PKG_ENV.PROLOGUE(NCOMPANY,
                     null,
                     null,
                     null,
                     null,
                     LINKEDDOC_UNITCODE,
                     LINKEDDOC_FUNC_DELETE,
                     LINKEDDOC_TABLENAME,
                     NRN);

    /* ������� �������� */
    UDO_PKG_LINKEDDOCS_BASE.DOC_DELETE(NRN => NRN, NCOMPANY => NCOMPANY, ONLY_IN_STORE => false);

    /* �������� ��������� ���������� �������� */
    PKG_ENV.EPILOGUE(NCOMPANY,
                     null,
                     null,
                     null,
                     null,
                     LINKEDDOC_UNITCODE,
                     LINKEDDOC_FUNC_DELETE,
                     LINKEDDOC_TABLENAME,
                     NRN);
  end DOC_DELETE;

  procedure DOWNLOAD
  (
    NCOMPANY  in number, -- �����������  (������ �� COMPANIES(RN))
    NIDENT    in number, -- ������������� ������ ������
    NDOCUMENT in number, -- RN ������ ��������� �������
    SUNITCODE in varchar2, -- ��� ��������� �������
    NFBIDENT  in number -- ������������� ��������� ������
  ) is
    cursor LC_FILES is
      select T.NRN,
             T.NFILE_DELETED
        from table(V(NCOMPANY, NDOCUMENT, SUNITCODE)) T
       where T.NRN in (select S.DOCUMENT from SELECTLIST S where S.IDENT = NIDENT);
    L_FILE LC_FILES%rowtype;
  begin
    /* �������� ������ ���������� �������� */
    PKG_ENV.PROLOGUE(NCOMPANY,
                     null,
                     null,
                     null,
                     null,
                     LINKEDDOC_UNITCODE,
                     LINKEDDOC_FUNC_DLOAD,
                     LINKEDDOC_TABLENAME,
                     NDOCUMENT);
    open LC_FILES;
    loop
      fetch LC_FILES
        into L_FILE;
      exit when LC_FILES%notfound;
      if L_FILE.NFILE_DELETED = 0 then
        UDO_PKG_LINKEDDOCS_BASE.FILE_TO_BUFFER(L_FILE.NRN, NFBIDENT);
      end if;
    end loop;
    close LC_FILES;
    /* �������� ��������� ���������� �������� */
    PKG_ENV.EPILOGUE(NCOMPANY,
                     null,
                     null,
                     null,
                     null,
                     LINKEDDOC_UNITCODE,
                     LINKEDDOC_FUNC_DLOAD,
                     LINKEDDOC_TABLENAME,
                     NDOCUMENT);
  end;

  procedure CLEAR_EXPIRED(NCOMPANY in number) is
    cursor LC_FILES is
      select RN
        from UDO_LINKEDDOCS T
       where T.FILE_DELETED = 0
         and T.SAVE_TILL < sysdate
         and T.COMPANY = NCOMPANY;
    L_NRN PKG_STD.TREF;
  begin
    open LC_FILES;
    loop
      fetch LC_FILES
        into L_NRN;
      exit when LC_FILES%notfound;
      /* ������� �������� */
      UDO_PKG_LINKEDDOCS_BASE.DOC_DELETE(NRN => L_NRN, NCOMPANY => NCOMPANY, ONLY_IN_STORE => true);
    end loop;
    close LC_FILES;
  end;

end UDO_PKG_LINKEDDOCS;
/


create or replace package body UDO_PKG_LINKEDDOCS_BASE is
  LINKEDDOC_UNITCODE constant varchar2(30) := 'UdoLinkedFiles';

  function GET_NEW_UNIQUE_NAME return varchar2 is
  begin
    return SYS_GUID();
  end GET_NEW_UNIQUE_NAME;

  procedure UPLOAD_FTP
  (
    SHOST       in varchar2,
    NPORT       in number,
    SUSER       in varchar2,
    SPASS       in varchar2,
    SROOT       in varchar2,
    SFOLDER     in varchar2,
    SFILENAME   in varchar2,
    BFILEDATA   in blob,
    ISNEWFOLDER in boolean := false
  ) is
    L_CONN UTL_TCP.CONNECTION;
  begin
    L_CONN := UDO_PKG_FTP_UTIL.LOGIN(P_HOST => SHOST,
                                     P_PORT => NPORT,
                                     P_USER => SUSER,
                                     P_PASS => SPASS);

    if ISNEWFOLDER then
      UDO_PKG_FTP_UTIL.MKDIR(P_CONN => L_CONN, P_DIR => SROOT || '/' || SFOLDER);
    end if;
    UDO_PKG_FTP_UTIL.PUT_REMOTE_BINARY_DATA(P_CONN => L_CONN,
                                            P_FILE => SROOT || '/' || SFOLDER || '/' || SFILENAME,
                                            P_DATA => BFILEDATA);
    UDO_PKG_FTP_UTIL.LOGOUT(L_CONN);
  end UPLOAD_FTP;

  procedure UPLOAD_DIRECTORY
  (
    SDIRECTORY  in varchar2,
    SFOLDER     in varchar2,
    SFILENAME   in varchar2,
    BFILEDATA   in blob,
    ISNEWFOLDER in boolean := false
  ) is
  begin
    if ISNEWFOLDER then
      UDO_PKG_FILE_API.MKDIR(P_DIRECTORY_NAME => SDIRECTORY, P_FOLDER => SFOLDER);
    end if;
    UDO_PKG_FILE_API.WRITE_FILE(P_DIRECTORY_NAME => SDIRECTORY,
                                P_FILE_NAME      => SFILENAME,
                                P_FILEDATA       => BFILEDATA,
                                P_FOLDER         => SFOLDER);
  end;

  /* ���������� ������ */
  procedure DOC_EXISTS
  (
    NRN      in number, -- ���������������  �����
    NCOMPANY in number, -- �����������  (������ �� COMPANIES(RN))
    REC      out UDO_LINKEDDOCS%rowtype
  ) is
    cursor LC_REC is
      select *
        from UDO_LINKEDDOCS
       where RN = NRN
         and COMPANY = NCOMPANY;
  begin
    /* ����� ������ */
    open LC_REC;
    fetch LC_REC
      into REC;
    close LC_REC;

    if (REC.RN is null) then
      PKG_MSG.RECORD_NOT_FOUND(NRN, 'UdoLinkedFiles');
    end if;
  end;

  procedure DOC_INSERT
  (
    NCOMPANY   in number, -- �����������  (������ �� COMPANIES(RN))
    SUNITCODE  in varchar2, -- �������� �������
    NDOCUMENT  in number, -- ��������������� ����� ��������� � �������
    SREAL_NAME in varchar2, -- ��� �����
    SNOTE      in varchar2, -- ����������
    NFILESIZE  in number, -- ������ �����
    NFILESTORE in number, -- ���������
    NLIFETIME  in number, -- ���� ��������
    BFILEDATA  in blob, -- ����
    NRN        out number -- ���������������  �����
  ) is
    cursor LC_STORE is
      select *
        from UDO_FILESTORES
       where RN = NFILESTORE;
    L_STORE LC_STORE%rowtype;
    cursor LC_FOLDER(A_MAXFILES number) is
      select *
        from UDO_FILEFOLDERS T
       where T.PRN = NFILESTORE
         and T.FILECNT < A_MAXFILES
       order by T.FILECNT desc;
    L_FOLDER    LC_FOLDER%rowtype;
    L_INT_NAME  UDO_LINKEDDOCS.INT_NAME%type;
    ISNEWFOLDER boolean := false;
  begin

    /* ���������� ���������� ��������� */
    open LC_STORE;
    fetch LC_STORE
      into L_STORE;
    close LC_STORE;
    /* ������ ����� �� ������� */
    open LC_FOLDER(L_STORE.MAXFILES);
    fetch LC_FOLDER
      into L_FOLDER;
    close LC_FOLDER;

    if L_FOLDER.RN is null then
      /* ��������� ����� ����� */
      ISNEWFOLDER      := true;
      L_FOLDER.NAME    := GET_NEW_UNIQUE_NAME;
      L_FOLDER.FILECNT := 0;
      UDO_P_FILEFOLDERS_BASE_INSERT(NCOMPANY => NCOMPANY,
                                    NPRN     => NFILESTORE,
                                    SNAME    => L_FOLDER.NAME,
                                    NFILECNT => L_FOLDER.FILECNT,
                                    NRN      => L_FOLDER.RN);
    end if;

    /* ���������� ���������� ��� ����� */
    L_INT_NAME := GET_NEW_UNIQUE_NAME;

    /* �������� ����� */
    if L_STORE.STORE_TYPE = 2 then
      UPLOAD_FTP(SHOST       => COALESCE(L_STORE.IPADDRESS, L_STORE.DOMAINNAME),
                 NPORT       => L_STORE.PORT,
                 SUSER       => L_STORE.USERNAME,
                 SPASS       => L_STORE.PASSWORD,
                 SROOT       => L_STORE.ROOTFOLDER,
                 SFOLDER     => L_FOLDER.NAME,
                 SFILENAME   => L_INT_NAME,
                 BFILEDATA   => BFILEDATA,
                 ISNEWFOLDER => ISNEWFOLDER);
    elsif L_STORE.STORE_TYPE = 1 then
      UPLOAD_DIRECTORY(SDIRECTORY  => L_STORE.ORA_DIRECTORY,
                       SFOLDER     => L_FOLDER.NAME,
                       SFILENAME   => L_INT_NAME,
                       BFILEDATA   => BFILEDATA,
                       ISNEWFOLDER => ISNEWFOLDER);
    end if;

    /* ��������� ���������������� ������ */
    NRN := GEN_ID;

    /* ���������� ������ � ������� */
    insert into UDO_LINKEDDOCS
      (RN, COMPANY, INT_NAME, UNITCODE, DOCUMENT, REAL_NAME, UPLOAD_TIME, SAVE_TILL, FILESTORE,
       FILESIZE, authid, NOTE, FILE_DELETED)
    values
      (NRN, NCOMPANY, L_INT_NAME, SUNITCODE, NDOCUMENT, SREAL_NAME, sysdate,
       ADD_MONTHS(sysdate, NLIFETIME), L_FOLDER.RN, NFILESIZE, UTILIZER, SNOTE, 0);

    /* ����������� ���������� ������ � ����� */
    UDO_P_FILEFOLDERS_BASE_UPDATE(NRN      => L_FOLDER.RN,
                                  NCOMPANY => NCOMPANY,
                                  SNAME    => L_FOLDER.NAME,
                                  NFILECNT => L_FOLDER.FILECNT + 1);
  end;

  /* ������� ����������� */
  procedure DOC_UPDATE
  (
    NRN           in number, -- ���������������  �����
    NCOMPANY      in number, -- �����������  (������ �� COMPANIES(RN))
    SREAL_NAME    in varchar2, -- ��� �����
    SNOTE         in varchar2, -- ����������
    NFILE_DELETED in number -- ������� ���������� �� ����� �����
  ) as
  begin
    /* ����������� ������ � ������� */
    update UDO_LINKEDDOCS
       set REAL_NAME    = SREAL_NAME,
           NOTE         = SNOTE,
           FILE_DELETED = NFILE_DELETED
     where RN = NRN
       and COMPANY = NCOMPANY;

    if (sql%notfound) then
      PKG_MSG.RECORD_NOT_FOUND(NRN, LINKEDDOC_UNITCODE);
    end if;
  end;

  procedure ERASE_DIRECTORY
  (
    SDIRECTORY in varchar2,
    SFOLDER    in varchar2,
    SFILENAME  in varchar2
  ) is
  begin
    UDO_PKG_FILE_API.DELETE_FILE(P_DIRECTORY_NAME => SDIRECTORY,
                                 P_FILE_NAME      => SFILENAME,
                                 P_FOLDER         => SFOLDER);
  end;

  procedure ERASE_FTP
  (
    SHOST     in varchar2,
    NPORT     in varchar2,
    SUSER     in varchar2,
    SPASS     in varchar2,
    SROOT     in varchar2,
    SFOLDER   in varchar2,
    SFILENAME in varchar2
  ) is
    L_CONN UTL_TCP.CONNECTION;
  begin
    L_CONN := UDO_PKG_FTP_UTIL.LOGIN(P_HOST => SHOST,
                                     P_PORT => NPORT,
                                     P_USER => SUSER,
                                     P_PASS => SPASS);

    UDO_PKG_FTP_UTIL.DELETE(P_CONN => L_CONN,
                            P_FILE => SROOT || '/' || SFOLDER || '/' || SFILENAME);
    UDO_PKG_FTP_UTIL.LOGOUT(L_CONN);
  end ERASE_FTP;

  /* ������� �������� */
  procedure DOC_DELETE
  (
    NCOMPANY      in number, -- �����������  (������ �� COMPANIES(RN))
    NRN           in number, -- ���������������  �����
    ONLY_IN_STORE in boolean default false -- ������� ������ � ���������
  ) is

    cursor LC_FILE is
      select T.FILE_DELETED,
             F.RN as FOLDER_RN,
             T.INT_NAME,
             F.NAME as FOLDER_NAME,
             COALESCE(S.IPADDRESS, S.DOMAINNAME) as HOST,
             F.FILECNT as FOLDER_CNT,
             S.PORT,
             S.USERNAME,
             S.PASSWORD,
             S.ROOTFOLDER,
             S.STORE_TYPE,
             S.ORA_DIRECTORY
        from UDO_LINKEDDOCS  T,
             UDO_FILEFOLDERS F,
             UDO_FILESTORES  S
       where T.RN = NRN
         and F.RN = T.FILESTORE
         and S.RN = F.PRN;
    L_FILE LC_FILE%rowtype;
  begin
    /* ���������� ����� */
    open LC_FILE;
    fetch LC_FILE
      into L_FILE;
    close LC_FILE;
    if ONLY_IN_STORE then
      /* ����������� ������ � ������� */
      update UDO_LINKEDDOCS
         set FILE_DELETED = 1
       where RN = NRN
         and COMPANY = NCOMPANY;
    else
      /* �������� ������ �� ������� */
      delete UDO_LINKEDDOCS
       where RN = NRN
         and COMPANY = NCOMPANY;
    end if;

    if L_FILE.FILE_DELETED = 0 then
      /* ��������� ���������� ������ � ����� */
      UDO_P_FILEFOLDERS_BASE_UPDATE(NRN      => L_FILE.FOLDER_RN,
                                    NCOMPANY => NCOMPANY,
                                    SNAME    => L_FILE.FOLDER_NAME,
                                    NFILECNT => L_FILE.FOLDER_CNT - 1);

      /* �������� ����� */
      if L_FILE.STORE_TYPE = 2 then
        ERASE_FTP(SHOST     => L_FILE.HOST,
                  NPORT     => L_FILE.PORT,
                  SUSER     => L_FILE.USERNAME,
                  SPASS     => L_FILE.PASSWORD,
                  SROOT     => L_FILE.ROOTFOLDER,
                  SFOLDER   => L_FILE.FOLDER_NAME,
                  SFILENAME => L_FILE.INT_NAME);
      elsif L_FILE.STORE_TYPE = 1 then
        ERASE_DIRECTORY(SDIRECTORY => L_FILE.ORA_DIRECTORY,
                        SFOLDER    => L_FILE.FOLDER_NAME,
                        SFILENAME  => L_FILE.INT_NAME);
      end if;
    end if;

  end DOC_DELETE;

  function DOWNLOAD_FTP
  (
    SHOST     in varchar2,
    NPORT     in number,
    SUSER     in varchar2,
    SPASS     in varchar2,
    SROOT     in varchar2,
    SFOLDER   in varchar2,
    SFILENAME in varchar2
  ) return blob is
    L_CONN     UTL_TCP.CONNECTION;
    L_FILEDATA blob;
  begin
    L_CONN     := UDO_PKG_FTP_UTIL.LOGIN(P_HOST => SHOST,
                                         P_PORT => NPORT,
                                         P_USER => SUSER,
                                         P_PASS => SPASS);
    L_FILEDATA := UDO_PKG_FTP_UTIL.GET_REMOTE_BINARY_DATA(P_CONN => L_CONN,
                                                          P_FILE => SROOT || '/' || SFOLDER || '/' ||
                                                                    SFILENAME);
    UDO_PKG_FTP_UTIL.LOGOUT(L_CONN);
    return L_FILEDATA;
  end;

  function DOWNLOAD_DIRECTORY
  (
    SDIRECTORY in varchar2,
    SFOLDER    in varchar2,
    SFILENAME  in varchar2
  ) return blob is
  begin
    return UDO_PKG_FILE_API.READ_FILE(P_DIRECTORY_NAME => SDIRECTORY,
                                      P_FILE_NAME      => SFILENAME,
                                      P_FOLDER         => SFOLDER);
  end;

  procedure FILE_TO_BUFFER
  (
    NFILE   in number,
    NBUFFER in number
  ) is
    cursor LC_FILE is
      select T.FILE_DELETED,
             T.REAL_NAME,
             F.RN as FOLDER_RN,
             T.INT_NAME,
             F.NAME as FOLDER_NAME,
             COALESCE(S.IPADDRESS, S.DOMAINNAME) as HOST,
             F.FILECNT as FOLDER_CNT,
             S.PORT,
             S.USERNAME,
             S.PASSWORD,
             S.ROOTFOLDER,
             S.STORE_TYPE,
             S.ORA_DIRECTORY
        from UDO_LINKEDDOCS  T,
             UDO_FILEFOLDERS F,
             UDO_FILESTORES  S
       where T.RN = NFILE
         and F.RN = T.FILESTORE
         and S.RN = F.PRN;
    L_FILE     LC_FILE%rowtype;
    L_FILEDATA blob;
  begin
    /* ���������� ����� */
    open LC_FILE;
    fetch LC_FILE
      into L_FILE;
    close LC_FILE;
    if L_FILE.STORE_TYPE = 2 then
      L_FILEDATA := DOWNLOAD_FTP(SHOST     => L_FILE.HOST,
                                 NPORT     => L_FILE.PORT,
                                 SUSER     => L_FILE.USERNAME,
                                 SPASS     => L_FILE.PASSWORD,
                                 SROOT     => L_FILE.ROOTFOLDER,
                                 SFOLDER   => L_FILE.FOLDER_NAME,
                                 SFILENAME => L_FILE.INT_NAME);
    elsif L_FILE.STORE_TYPE = 1 then
      L_FILEDATA := DOWNLOAD_DIRECTORY(SDIRECTORY => L_FILE.ORA_DIRECTORY,
                                       SFOLDER    => L_FILE.FOLDER_NAME,
                                       SFILENAME  => L_FILE.INT_NAME);
    end if;
    if DBMS_LOB.GETLENGTH(L_FILEDATA) > 0 then
      P_FILE_BUFFER_INSERT(NIDENT    => NBUFFER,
                           CFILENAME => L_FILE.REAL_NAME,
                           CDATA     => null,
                           BLOBDATA  => L_FILEDATA);
    end if;
  end;

end UDO_PKG_LINKEDDOCS_BASE;
/

