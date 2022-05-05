package com.example.myapplication;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;

public class LoginActivity extends AppCompatActivity
{
    protected EditText txtEmail = null;
    protected EditText txtPassword = null;
    protected Button button = null;
    public UsuarioSQLite sqLite = null;

    private AlertDialog.Builder errorDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        //Se almacenan referencias a elementos de la interface
        txtEmail = (EditText) findViewById(R.id.txtEmail);
        txtPassword = (EditText) findViewById(R.id.txtContraseña);
        button = (Button) findViewById(R.id.btnIngreso);

        //Se genera instancia de SQLite
        sqLite = new UsuarioSQLite(this);

        //Se genera constructor de diálogo
        errorDialog = new AlertDialog.Builder(this);
        // Se añade botón aceptar
        errorDialog.setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                // User clicked OK button
            }
        });
    }
    //Método que obtiene los datos y registra al usuario
    public void verificarUsuario(android.view.View view)
    {
        //Se obtienen los datos de la interface
        String email = txtEmail.getText().toString();
        String password = txtPassword.getText().toString();
        //Se verifica que se completen los campos de manera correcta
        if(!email.equals("") && !password.equals("")) {
            //Se comparan las contraseñas
            Usuario usuario = sqLite.seleccionarUsuario(email);
            if(usuario.get_email().equals(""))
            {
                //No se ha encontrado un usuario con el correo indicado
                mostrarError(R.string.alert_userNotFound);
            }
            else if (usuario.get_password().equals(password))
            {
                mostrarError(R.string.alert_done);
            }
            else
                //Si la contraseña es incorrecta se generá un error
                mostrarError(R.string.alert_wrongPassword);
        }else{
            //De no ser así se generá un mensaje de error.
            mostrarError(R.string.alert_lackOfData);
        }
    }
    //Método que generá los mensajes que se muestran en pantalla
    private void mostrarError(int msj)
    {
        //Asignar mensaje a contructor de dialogo de alerta
        errorDialog.setMessage(msj)
                .setTitle(R.string.alert_title);
        //Generar mensaje y mostrarlo en pantalla
        AlertDialog dialog = errorDialog.create();
        dialog.show();
    }
}