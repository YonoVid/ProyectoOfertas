package com.example.myapplication;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;

public class OfertaCRUD extends AppCompatActivity
{
    //Variables que almacenan los elementos de la interface
    protected EditText txtId = null;
    protected EditText txtName = null;
    protected EditText txtBrand = null;
    protected EditText txtPrice = null;
    protected EditText txtStoreId = null;
    protected Spinner actionSelector = null;
    protected Button btnListar = null;
    //Variable de SQLite
    public OfertaSQLite sqLite = null;
    //Variable que para clase que generá mensajes que aparecen en pantalla
    private AlertDialog.Builder errorDialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_crud_oferta);
        //Se almacena referencia a elementos de la interface
        txtId = (EditText) findViewById(R.id.txtid);
        //Bloquea alterar id por defecto
        txtId.setInputType(0);
        txtName = (EditText) findViewById(R.id.txtnombreproducto);
        txtBrand = (EditText) findViewById(R.id.txtmarca);
        txtPrice = (EditText) findViewById(R.id.txtprecio);
        txtStoreId = (EditText) findViewById(R.id.txtidtienda);
        btnListar = findViewById(R.id.buttonListarOfertas);


        //Se colocan las opciones dentro del spinner
        actionSelector = (Spinner) findViewById(R.id.spinnerOfertaCRUD);
        // Crea acaptador de arrray a partir de recurso y layout básico
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(this,
                R.array.crud_array, R.layout.layout_spinner_style);
        // Escecificar el layout que aparecerá
        adapter.setDropDownViewResource(R.layout.layout_spinner_style);
        // Aplicar al spinner
        actionSelector.setAdapter(adapter);
        //Para alterar la interacción del usuario al cambiar de acción
        actionSelector.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener()
        {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                // An item was selected. You can retrieve the selected item using
                // parent.getItemAtPosition(pos)
                int multiplier = 0;
                if(i < 2) multiplier = 1;
                txtName.setInputType(multiplier * 61);
                txtName.setText("");
                txtBrand.setInputType(multiplier * 61);
                txtBrand.setText("");
                txtPrice.setInputType(multiplier * 2);
                txtPrice.setText("");
                txtStoreId.setInputType(multiplier * 2);
                txtStoreId.setText("");
                if(i == 0)
                {
                    txtId.setText("");
                    txtId.setInputType(0);
                }
                else txtId.setInputType(2);
            }

            public void onNothingSelected(AdapterView<?> parent) {
                // Another interface callback
            }
        });

        //Se crea instancia de SQLite
        sqLite = new OfertaSQLite (this);

        //Se genera constructor de diálogo
        errorDialog = new AlertDialog.Builder(this);
        // Se añade boton de aceptar
        errorDialog.setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                // User clicked OK button
            }
        });
        //Se asocia función a botón listar
        btnListar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(OfertaCRUD.this, OfertaListar.class));
            }
        });
    }

    public void realizarAccion(android.view.View view){
        //Se obtienen los datos de la interface
        String id = txtId.getText().toString();
        String name = txtName.getText().toString();
        String brand = txtBrand.getText().toString();
        String price = txtPrice.getText().toString();
        String storeId = txtStoreId.getText().toString();
        //Se realiza la funcion seleccionada en el spinner
        switch((int)actionSelector.getSelectedItemId())
        {
            case 0:
                agregarOferta(name, price, brand, storeId);
                break;
            case 1:
                editarOferta(id, name, price, brand, storeId);
                break;
            case 2:
                eliminarOferta(id);
                break;
            case 3:
                seleccionarOferta(id);
                break;

        }
    }

    public void agregarOferta(String name, String price, String brand, String storeId)
    {
        sqLite.ingresarOferta(name, price, brand, storeId);
        mostrarError(R.string.alert_done);
        limpiar();
    }

    public void editarOferta(String id, String name, String price, String brand, String storeId)
    {
        if(!id.equals(""))
        {
            if(sqLite.seleccionarOferta(id).getId_oferta() != -1)
            {
                sqLite.actualizarOferta(id, name, price, brand, storeId);
                mostrarError(R.string.alert_done);
                limpiar();
            }
            else
                mostrarError(R.string.alert_offerNotFound);
        }
        else
            mostrarError(R.string.alert_lackOfData);
    }

    public void eliminarOferta(String id)
    {
        if(!id.equals(""))
        {
            if(sqLite.seleccionarOferta(id).getId_oferta() != -1)
            {
                sqLite.eliminarOferta(id);
                mostrarError(R.string.alert_done);
            }
            else
                mostrarError(R.string.alert_offerNotFound);
        }
        else
            mostrarError(R.string.alert_lackOfData);
    }

    public void seleccionarOferta(String id)
    {
        if(!id.equals(""))
        {
            Oferta oferta = sqLite.seleccionarOferta(id);
            if(oferta.getId_oferta() != -1)
            {
                txtName.setText(oferta.getNombre_producto());
                txtBrand.setText(oferta.getMarca());
                txtPrice.setText(String.valueOf(oferta.getPrecio()));
                txtStoreId.setText(String.valueOf(oferta.getId_tienda()));
            }
            else
                mostrarError(R.string.alert_offerNotFound);
        }
        else
            mostrarError(R.string.alert_lackOfData);
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
        txtId.setText("");
        txtBrand.setText("");
        txtPrice.setText("");
        txtName.setText("");
        txtStoreId.setText("");
    }
}