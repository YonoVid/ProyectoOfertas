package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.List;

public class OfertaListar extends AppCompatActivity
{
    private ListView listViewOfertas;
    //OfertaSQLite sqlite = null;
    //ArrayList<String> listaOferta = null;
    Spinner listar = null;
    OfertaSQLite sqlite = null;
    EditText txtId = null;
    EditText txtNombre = null;
    EditText txtMarca = null;
    EditText txtPrecio = null;
    ArrayList<String> listaOferta;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_listar_oferta);
        //Almacenar elementos de interface en variables
        listar = findViewById(R.id.spnListar);
        txtId = findViewById(R.id.txtListId);
        txtNombre = findViewById(R.id.txtListNombre);
        txtMarca = findViewById(R.id.txtListMarca);
        txtPrecio = findViewById(R.id.txtListaPrecio);
        //Se genera instancia de SQLite
        sqlite = new OfertaSQLite(this);

        List<Oferta> sqlOferta = sqlite.leerOferta();

        listaOferta = new ArrayList<String>();
        listaOferta.add("Seleccionar ID de Oferta");
        for(int i = 0; i<sqlOferta.size(); i++) {
            listaOferta.add(String.valueOf(sqlOferta.get(i).getId_oferta()));
        }
        ArrayAdapter<CharSequence> adaptador = new ArrayAdapter(this,android.R.layout.simple_list_item_1,listaOferta);
        listar.setAdapter(adaptador);
        listar.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int position, long l) {
                if(position != 0){
                    txtId.setText(String.valueOf(sqlOferta.get(position-1).getId_tienda()));
                    txtNombre.setText(sqlOferta.get(position-1).getNombre_producto());
                    txtMarca.setText(sqlOferta.get(position-1).getMarca());
                    txtPrecio.setText("$"+(String.valueOf(sqlOferta.get(position-1).getPrecio())));

                }else{
                    txtId.setText("");
                    txtNombre.setText("");
                    txtMarca.setText("");
                    txtPrecio.setText("");
                }

            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }
}