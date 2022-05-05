package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.List;

public class UsuarioListar extends AppCompatActivity
{
    EditText txtNombre = null;
    EditText txtContraseña = null;
    EditText txtTelefono = null;
    Spinner comboListaUsuario = null;
    UsuarioSQLite sqLite = null;
    ArrayList<String> listaUsuarios = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_listar_usuario);
        comboListaUsuario = findViewById(R.id.spnListarUsuario);
        txtNombre = findViewById(R.id.txtNombreUser);
        txtContraseña = findViewById(R.id.txtContraseñaUser);
        txtTelefono = findViewById(R.id.txtTelefonoUser);
        //Genera instancia de SQLite
        sqLite = new UsuarioSQLite(this);
        List<Usuario> sqlUsuarios = sqLite.leerUsuario();
        listaUsuarios = new ArrayList<String>();
        listaUsuarios.add("Seleccionar correo de Usuario");
        for(int i=0 ; i<sqlUsuarios.size() ; i++){
            listaUsuarios.add(sqlUsuarios.get(i).get_email());
        }
        ArrayAdapter<CharSequence> adaptador = new ArrayAdapter(this,android.R.layout.simple_list_item_1,listaUsuarios);
        comboListaUsuario.setAdapter(adaptador);
        comboListaUsuario.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                if(position != 0){
                    txtNombre.setText(sqlUsuarios.get(position-1).get_name());
                    txtContraseña.setText(sqlUsuarios.get(position-1).get_password());
                    txtTelefono.setText(sqlUsuarios.get(position-1).get_phone());

                }else{
                    txtNombre.setText("");
                    txtContraseña.setText("");
                    txtTelefono.setText("");
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });

    }
}