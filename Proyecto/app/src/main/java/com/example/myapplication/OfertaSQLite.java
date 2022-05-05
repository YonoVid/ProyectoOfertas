package com.example.myapplication;

import android.annotation.SuppressLint;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

    public class OfertaSQLite extends SQLiteOpenHelper
    {
        public OfertaSQLite(Context context) {
            super(context, "ofertas", null, 1);
        }

        @Override
        public void onCreate(SQLiteDatabase db) {
            db.execSQL("CREATE TABLE OFERTAS (ID_OFERTA integer primary key autoincrement" +
                       ", NOMBRE_PRODUCTO varchar(50), MARCA varchar (30), PRECIO int" +
                       ", FK_ID_TIENDA int);");
        }

        @Override
        public void onUpgrade(SQLiteDatabase db, int i, int i1) {
            db.execSQL("DROP TABLE IF EXISTS OFERTAS");
            onCreate(db);
        }

        @Override
        public void onDowngrade(SQLiteDatabase db, int i, int i1) {
            db.execSQL("DROP TABLE IF EXISTS OFERTAS");
            onCreate(db);
        }

        public void ingresarOferta(Oferta oferta){
            SQLiteDatabase db = getWritableDatabase();
            db.execSQL("INSERT INTO OFERTAS (NOMBRE_PRODUCTO, MARCA, PRECIO, FK_ID_TIENDA) " +
                       "VALUES ('"+oferta.getNombre_producto()+"', '"+oferta.getMarca()+"'"+
                       ", '"+oferta.getPrecio()+"', '"+oferta.getId_tienda()+"');");
            db.close();
        }

        public void ingresarOferta(String nombre_producto, String precio, String marca, String id_tienda) {
            SQLiteDatabase db = getWritableDatabase();
            db.execSQL("INSERT INTO OFERTAS (NOMBRE_PRODUCTO, MARCA, PRECIO, FK_ID_TIENDA) " +
                    "VALUES ('"+nombre_producto+"', '"+marca+"'"+", '"+precio+"', '"+id_tienda+"');");
            db.close();
        }

        public void actualizarOferta(String id, String nombre_producto, String precio, String marca, String id_tienda)
        {
            SQLiteDatabase db = getWritableDatabase();
            String data = "UPDATE OFERTAS SET ";
            if(!nombre_producto.equals("")) data += "NOMBRE_PRODUCTO = '" + nombre_producto + "'";
            if(!marca.equals(""))
            {
                if(!(data.charAt(data.length() - 1) == ' ')) data += ", ";
                data += "MARCA = '" + marca + "'";
            }
            if(!precio.equals(""))
            {
                if(!(data.charAt(data.length() - 1) == ' ')) data += ", ";
                data += "PRECIO = " + precio;
            }
            if(!id_tienda.equals(""))
            {
                if(!(data.charAt(data.length() - 1) == ' ')) data += ", ";
                data += "FK_ID_TIENDA = " + id_tienda;
            }
            if(!(data.charAt(data.length() - 1) == ' '))
            {
                db.execSQL(data +" WHERE ID_OFERTA = " + id);
            }
            db.close();
        }

        public void eliminarOferta(String id_oferta){
            SQLiteDatabase db = getWritableDatabase();
            db.execSQL("DELETE FROM OFERTAS WHERE ID_OFERTA = " + id_oferta);
            db.close();
        }

        public Oferta seleccionarOferta(String id_oferta){
            SQLiteDatabase db = getWritableDatabase();
            Cursor data = db.rawQuery("SELECT * FROM OFERTAS WHERE ID_OFERTA =  ? ", new String[] {id_oferta});
            if(data.moveToNext())
            {
                @SuppressLint("Range") Oferta resultado = new Oferta(data.getInt(data.getColumnIndex("ID_OFERTA")),
                                        data.getString(data.getColumnIndex("NOMBRE_PRODUCTO")),
                                        data.getString(data.getColumnIndex("MARCA")),
                                        data.getInt(data.getColumnIndex("PRECIO")),
                                        data.getInt(data.getColumnIndex("FK_ID_TIENDA")));
                return resultado;
            }
            data.close();
            return new Oferta();
        }
        /*
        public int seleccionaridOferta(String nombre_producto){
            SQLiteDatabase db = getWritableDatabase();
            int id_oferta = Integer.parseInt(null);
            Cursor data = db.rawQuery("SELECT id_oferta FROM OFERTAS WHERE nombre_producto =  ? ", new String[] {nombre_producto});
            db.close();
            data.close();
            return id_oferta;
        }
        */
        public List<Oferta> leerOferta(){
            ArrayList<Oferta> todas_las_ofertas= new ArrayList<>();
            SQLiteDatabase db=getReadableDatabase();
            Cursor cursor=db.rawQuery("SELECT * FROM OFERTAS;",null);
            while(cursor.moveToNext()){
                Oferta oferta = new Oferta(cursor.getInt(0),
                                           cursor.getString(1),
                                           cursor.getString(2),
                                           cursor.getInt(3),
                                           cursor.getInt(4));
                todas_las_ofertas.add(oferta);
            }
            cursor.close();
            db.close();
            return todas_las_ofertas;
        }
    }