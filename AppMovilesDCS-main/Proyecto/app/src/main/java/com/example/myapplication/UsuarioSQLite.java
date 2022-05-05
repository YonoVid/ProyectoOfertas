package com.example.myapplication;

import android.annotation.SuppressLint;
import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseErrorHandler;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;

public class UsuarioSQLite extends SQLiteOpenHelper
{
    public UsuarioSQLite(Context context) {
        super(context, "usuario", null, 1);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        //Duda, no deberíamos hacer que la primary key fuera email(?
        //mmmm sep talvez, igual no deberia haber problema verdad
        db.execSQL("CREATE TABLE USUARIOS (NAME VARCHAR(30),PASSWORD VARCHAR(30),EMAIL VARCHAR(50) PRIMARY KEY,PHONE VARCHAR(12));");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int i, int i1) {
        db.execSQL("DROP TABLE IF EXISTS USUARIOS");
        onCreate(db);
    }

    public void crearUsuario(Usuario usuario){
        SQLiteDatabase db = getWritableDatabase();
        db.execSQL("INSERT INTO USUARIOS (NAME,PASSWORD,EMAIL,PHONE) VALUES ('"+usuario.get_name()+"','"+usuario.get_password()+"','"+usuario.get_email()+"','"+usuario.get_phone()+"');");
        db.close();
    }
    public void crearUsuario(String name, String password, String email, String phone){
        SQLiteDatabase db = getWritableDatabase();
        db.execSQL("INSERT INTO USUARIOS (NAME,PASSWORD,EMAIL,PHONE) VALUES ('"+name+
                    "','"+password+"','"+email+"','"+phone+"');");
        db.close();
    }
    public void actualizarUsuario(Usuario usuario){
        SQLiteDatabase db = getWritableDatabase();
        String data = "UPDATE USUARIOS SET ";
        if(!usuario.get_name().equals("")) data += "NAME = '" + usuario.get_name() + "'";
        if(!usuario.get_password().equals(""))
        {
            if(!(data.charAt(data.length() - 1) == ' ')) data += ", ";
            data += "PASSWORD = '" + usuario.get_password() + "'";
        }
        if(!usuario.get_phone().equals("") && !usuario.get_phone().equals("+"))
        {
            if(!(data.charAt(data.length() - 1) == ' ')) data += ", ";
            data += "PHONE = '" + usuario.get_phone() + "'";
        }
        if(!(data.charAt(data.length() - 1) == ' '))
        {
            db.execSQL(data +" WHERE EMAIL = '" + usuario.get_email() + "'");
        }
        db.close();
    }
    public void eliminarUsuario(Usuario usuario){
        SQLiteDatabase db = getWritableDatabase();
        db.execSQL("DELETE FROM USUARIOS WHERE EMAIL = " + usuario.get_email());
        db.close();

    }
    public void eliminarUsuario(String email){
        SQLiteDatabase db = getWritableDatabase();
        db.execSQL("DELETE FROM USUARIOS WHERE EMAIL = '" + email + "'");
        db.close();

    }
    @SuppressLint("Range")
    public Usuario seleccionarUsuario(String email){
        SQLiteDatabase db = getReadableDatabase();
        Cursor data = db.rawQuery("SELECT * FROM USUARIOS WHERE EMAIL =  ? ", new String[] {email});
        if(data.moveToNext())
        {
            return new Usuario(data.getString(data.getColumnIndex("NAME")),
                    data.getString(data.getColumnIndex("PASSWORD")),
                    data.getString(data.getColumnIndex("EMAIL")),
                    data.getString(data.getColumnIndex("PHONE")));
        }
        data.close();
        db.close();
        return new Usuario();
    }
    public List<Usuario> leerUsuario(){
        ArrayList<Usuario> usuarios = new ArrayList<>();
        SQLiteDatabase db = getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT * FROM USUARIOS",null);
        while(cursor.moveToNext()){
            Usuario usuario = new Usuario(cursor.getString(0),
                                           cursor.getString(1),
                                            cursor.getString(2),
                                            cursor.getString(3));
            usuarios.add(usuario);
        }
                cursor.close();
                db.close();
                return usuarios;
    }
}
