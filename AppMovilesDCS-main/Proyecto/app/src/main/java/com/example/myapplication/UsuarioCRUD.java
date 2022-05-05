package com.example.myapplication;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

public class UsuarioCRUD extends AppCompatActivity
{
    //Variables que almacenan los elementos de la interface
    protected EditText txtName = null;
    protected EditText txtPassword = null;
    protected EditText txtEmail = null;
    protected EditText txtCodePhone = null;
    protected EditText txtPhone = null;
    protected Spinner actionSelector = null;
    protected Button btnListar = null;
    //Variable de SQLite
    public UsuarioSQLite sqLite = null;
    //Variable que para clase que generá mensajes que aparecen en pantalla
    private AlertDialog.Builder errorDialog;

    //Al iniciar la actividad
    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_crud_usuario);
        //Se almacenan referencias a los elementos de la interface
        txtName = (EditText) findViewById(R.id.inputUsuarioName);
        txtPassword = (EditText) findViewById(R.id.inputUsuarioPassword);
        txtEmail = (EditText) findViewById(R.id.inputUsuarioEmail);
        txtCodePhone = (EditText) findViewById(R.id.inputUsuarioPhoneCode);
        txtPhone = (EditText) findViewById(R.id.inputUsuarioPhone);
        //Se coloca valor por defecto de codigo de telefono
        txtCodePhone.setText("56");

        //Se colocan las opciones dentro del spinner
        actionSelector = (Spinner) findViewById(R.id.spinnerUsuarioCRUD);
        // Crea acaptador de arrray a partir de recurso y layout básico
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
                R.array.crud_array, R.layout.layout_spinner_style);
        // Escecificar el layout que aparecerá
        adapter.setDropDownViewResource(R.layout.layout_spinner_style);
        // Aplicar al spinner
        actionSelector.setAdapter(adapter);
        //Para alterar la interacción del usuario al cambiar de acción
        actionSelector.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {

            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                // An item was selected. You can retrieve the selected item using
                // parent.getItemAtPosition(pos)
                int multiplier = 0;
                if(i < 2) multiplier = 1;
                txtName.setInputType(multiplier * 61);
                txtName.setText("");
                txtPassword.setInputType(multiplier * 61);
                txtPassword.setText("");
                txtPhone.setInputType(multiplier * 3);
                txtPhone.setText("");
                txtCodePhone.setInputType(multiplier * 3);
                txtCodePhone.setText("");
            }

            public void onNothingSelected(AdapterView<?> parent) {
                // Another interface callback
            }
        });

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
        //Se asocia función a botón listar
        btnListar = findViewById(R.id.buttonListar);
        btnListar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(UsuarioCRUD.this, UsuarioListar.class));
            }
        });
    }
    //Método que obtiene los datos y registra al usuario
    public void realizarAccion(android.view.View view){
        //Se obtienen los datos de la interface
        String name = txtName.getText().toString();
        String password = txtPassword.getText().toString();
        String email = txtEmail.getText().toString();
        String phone = txtCodePhone.getText().toString() + txtPhone.getText().toString();

        switch((int)actionSelector.getSelectedItemId())
        {
            case 0:
                agregarUsuario(name, password, email, phone);
                break;
            case 1:
                editarUsuario(name, password, email, phone);
                break;
            case 2:
                eliminarUsuario(email);
                break;
            case 3:
                seleccionarUsuario(email);
                break;
        }
    }

    private int agregarUsuario(String name, String password, String email, String phone)
    {
        //Se verifica que se completen los campos de manera correcta
        if(!name.equals("") && !password.equals("") && !email.equals("") && !phone.equals(""))
        {
            //Se verifica que el formato del correo y el teléfono sean correctos
            if(!email.matches("\\b[^\\s]+@[^\\s]+.[^\\s]+\\b") ||
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
                limpiar();
            }
        }else{
            //De no ser así se generá un mensaje de error.
            mostrarError(R.string.alert_lackOfData);
        }
        return 0;
    }

    private int editarUsuario(String name, String password, String email, String phone)
    {
        //Se verifica que se completen los campos de manera correcta
        if(!email.equals("") && (!name.equals("") || !password.equals("") || !phone.equals("")))
        {
            //Se verifica que el formato del correo y el teléfono sean correctos
            if(!phone.equals("") && !phone.matches("\\b[+]?[0-9]{11}\\b"))
                mostrarError(R.string.alert_wrongValueFormat);
            else if(!email.equals("") && !email.matches("\\b[^\\s]+@[^\\s]+.[^\\s]+\\b"))
                mostrarError(R.string.alert_wrongValueFormat);
            //Se verifica que un usuario con el mismo correo exista
            else if(sqLite.seleccionarUsuario(email).get_email().equals(""))
                mostrarError(R.string.alert_userNotFound);
            //Si no hay error se realiza la acción solicitada
            else
            {
                //Se envía la solicitud a la base de datos y se indica que se realizo la acción
                sqLite.actualizarUsuario(new Usuario(name, password, email,
                                                     phone.startsWith("+")?phone: "+" + phone));
                mostrarError(R.string.alert_done);
            }
        }else{
            //De no ser así se generá un mensaje de error.
            mostrarError(R.string.alert_lackOfData);
        }
        return 0;
    }

    private int eliminarUsuario(String email)
    {
        //Se verifica que se completen los campos de manera correcta
        if(!email.equals(""))
        {
            //Se verifica que el formato del correo y el teléfono sean correctos
            if(!email.matches("\\b[^\\s]+@[^\\s]+.[^\\s]+\\b"))
                mostrarError(R.string.alert_wrongValueFormat);
            //Se verifica que exista un usuario con el correo exista
            else if(sqLite.seleccionarUsuario(email).get_email().equals(""))
                mostrarError(R.string.alert_userNotFound);
            //Si no hay error se realiza la acción solicitada
            else
            {
                //Se envía la solicitud a la base de datos y se indica que se realizo la acción
                sqLite.eliminarUsuario(email);
                mostrarError(R.string.alert_done);
            }
        }else{
            //De no ser así se generá un mensaje de error.
            mostrarError(R.string.alert_lackOfData);
        }
        return 0;
    }

    private int seleccionarUsuario(String email)
    {
        Usuario user = sqLite.seleccionarUsuario(email);
        if(!user.get_email().equals(""))
        {
            txtName.setText(user.get_name());
            txtPassword.setText(user.get_password());
            int phoneLength = user.get_phone().length();
            txtCodePhone.setText(user.get_phone().substring(0, phoneLength - 9));
            txtPhone.setText(user.get_phone().substring(phoneLength - 9,phoneLength));
        }
        else
            mostrarError(R.string.alert_userNotFound);
        return 0;
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

    public void limpiar(){
        txtName.setText("");
        txtEmail.setText("");
        txtPassword.setText("");
        txtCodePhone.setText("");
        txtPhone.setText("");

    }
}