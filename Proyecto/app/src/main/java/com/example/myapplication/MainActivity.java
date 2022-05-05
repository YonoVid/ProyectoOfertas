package com.example.myapplication;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends AppCompatActivity
{
    Button btnLogIn = null;
    Button btnSignIn = null;
    Button btnCRUDUser = null;
    Button btnCRUDOffer =null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        btnLogIn = (Button) findViewById(R.id.btnLogIn);
        btnSignIn = (Button) findViewById(R.id.btnSignIn);
        btnCRUDUser = (Button) findViewById(R.id.btnCRUDUsuario);
        btnCRUDOffer = (Button) findViewById(R.id.btnCRUDOfertas);

        btnLogIn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(MainActivity.this,LoginActivity.class));
            }
        });

        btnSignIn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(MainActivity.this,RegistroActivity.class));
            }
        });

        btnCRUDUser.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(MainActivity.this,UsuarioCRUD.class));
            }
        });

        btnCRUDOffer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(MainActivity.this,OfertaCRUD.class));
            }
        });

    }

}