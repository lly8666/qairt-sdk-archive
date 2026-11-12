package io.github.tasaudit.runtimeinventory;

import android.content.ContentProvider;
import android.content.ContentValues;
import android.database.Cursor;
import android.database.MatrixCursor;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import android.provider.OpenableColumns;

import java.io.File;
import java.io.FileNotFoundException;

/** Read-only share of selected nonprivate OS ELF files, never private user data. */
public final class SystemFileExportProvider extends ContentProvider {
    public static final String AUTHORITY="io.github.tasaudit.runtimeinventory.v11.export";
    public static final String ZIP_NAME="TAS_AN00_System_ELF_Samples.zip";
    public static final Uri CONTENT_URI=Uri.parse("content://"+AUTHORITY+"/system-elfs.zip");

    @Override public boolean onCreate(){return true;}
    @Override public String getType(Uri uri){
        if(!CONTENT_URI.equals(uri))return null;
        return "application/zip";
    }
    @Override public Cursor query(Uri uri,String[] projection,String selection,
                                  String[] selectionArgs,String sortOrder){
        if(!CONTENT_URI.equals(uri))return null;
        String[] columns=projection==null?new String[]{
            OpenableColumns.DISPLAY_NAME,OpenableColumns.SIZE}:projection;
        MatrixCursor cursor=new MatrixCursor(columns);
        Object[] row=new Object[columns.length];
        File zip=new File(getContext().getCacheDir(),ZIP_NAME);
        for(int i=0;i<columns.length;i++) {
            if(OpenableColumns.DISPLAY_NAME.equals(columns[i]))row[i]=ZIP_NAME;
            else if(OpenableColumns.SIZE.equals(columns[i]))row[i]=zip.length();
            else row[i]=null;
        }
        cursor.addRow(row);
        return cursor;
    }
    @Override public ParcelFileDescriptor openFile(Uri uri,String mode) throws FileNotFoundException{
        if(!CONTENT_URI.equals(uri)||!"r".equals(mode))
            throw new FileNotFoundException("read-only export");
        File f=new File(getContext().getCacheDir(),ZIP_NAME);
        return ParcelFileDescriptor.open(f,ParcelFileDescriptor.MODE_READ_ONLY);
    }
    @Override public int delete(Uri uri,String selection,String[] selectionArgs){return 0;}
    @Override public Uri insert(Uri uri,ContentValues values){return null;}
    @Override public int update(Uri uri,ContentValues values,String selection,String[] selectionArgs){return 0;}
}
