package com.example.myapplication;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.os.Bundle;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;

public class RegistroActivity extends AppCompatActivity
{
    //Variables que almacenan los elementos de la interface
    protected EditText txtName = null;
    protected EditText txtPassword = null;
    protected EditText txtConfmmPassword = null;
    protected EditText txtEmail = null;
    protected EditText txtCodePhone = null;
    protected EditText txtPhone = null;
    protected CheckBox cbTerms = null;
    protected Button btnRegistrar = null;
    //Variable de SQLite
    public UsuarioSQLite sqLite = null;
    //Variable que para clase que generá mensajes que aparecen en pantalla
    private AlertDialog.Builder errorDialog;

    //Al iniciar la actividad
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registro);
        //Se almacenan referencias a los elementos de la interface
        txtName = (EditText) findViewById(R.id.inputUsuarioName);
        txtPassword = (EditText) findViewById(R.id.inputUsuarioPassword);
        txtConfmmPassword = (EditText) findViewById(R.id.inputConfirmPassword);
        txtEmail = (EditText) findViewById(R.id.inputUsuarioEmail);
        txtCodePhone = (EditText) findViewById(R.id.inputUsuarioPhoneCode);
        txtPhone = (EditText) findViewById(R.id.inputUsuarioPhone);
        cbTerms = (CheckBox) findViewById(R.id.checkBoxTermsRegister);
        //Se coloca valor por defecto de codigo de telefono
        txtCodePhone.setText("56");

        //Se crea instancia de SQLite
        sqLite = new UsuarioSQLite(this);

        //Se genera constructor de diálogo
        errorDialog = new AlertDialog.Builder(this);
        // Se añade boton de aceptar
        errorDialog.setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                // User clicked OK button
            }
        });

    }
    //Método que obtiene los datos y registra al usuario
    public void registrarUsuario(android.view.View view){
        //Se obtienen los datos de la interface
        String name = txtName.getText().toString();
        String password = txtPassword.getText().toString();
        String checkPassword = txtConfmmPassword.getText().toString();
        String email = txtEmail.getText().toString();
        String phone = txtCodePhone.getText().toString() + txtPhone.getText().toString();
        //Se verifica que se completen los campos de manera correcta
        if(!name.equals("") && !password.equals("") && !email.equals("") && !phone.equals("") &&
                !checkPassword.equals("") && cbTerms.isChecked())
        {
            //Se verifica que ambas contraseñas ingresadas sean identicas
            if(!password.equals(checkPassword))
                mostrarError(R.string.alert_wrongPasswordConfirmation);
            //Se verifica que el formato del correo y el teléfono sean correctos
            else if(!email.matches("\\b[^\\s]+@[^\\s]+.[^\\s]+\\b") ||
                    !phone.matches("\\b[+]?[0-9]{11}\\b"))
                mostrarError(R.string.alert_wrongValueFormat);
            //Se verifica que un usuario con el mismo correo no exista
            else if(!sqLite.seleccionarUsuario(email).get_email().equals(""))
                mostrarError(R.string.alert_userAlreadyExist);
            //Si no hay error se realiza la acción solicitada
            else
            {
                //Se envía la solicitud a la base de datos y se indica que se realizo la acción
                sqLite.crearUsuario(name, password, email, phone.startsWith("+")?phone: "+" + phone);
                mostrarError(R.string.alert_done);
            }
        }else{
            //De no ser así se generá un mensaje de error.
            mostrarError(R.string.alert_lackOfData);
        }
    }

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