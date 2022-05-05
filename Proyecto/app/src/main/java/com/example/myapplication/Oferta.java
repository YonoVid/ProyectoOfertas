package com.example.myapplication;

public class Oferta {
    private int id_oferta = -1;
    private String nombre_producto;
    private String marca;
    private int precio;
    private int id_tienda;

    public Oferta(int id_oferta, String nombre_producto, String marca, int precio, int id_tienda) {
        this.id_oferta = id_oferta;
        this.nombre_producto = nombre_producto;
        this.marca = marca;
        this.precio = precio;
        this.id_tienda = id_tienda;
    }

    public Oferta() {

    }

    public int getId_oferta() {
        return id_oferta;
    }
    public void setId_oferta(int id_oferta) {
        this.id_oferta = id_oferta;
    }
    public String getNombre_producto() {
        return nombre_producto;
    }
    public void setNombre_producto(String nombre_producto) {
        this.nombre_producto = nombre_producto;
    }
    public String getMarca() {
        return marca;
    }
    public void setMarca(String marca) {
        this.marca = marca;
    }
    public int getPrecio() {
        return precio;
    }
    public void setPrecio(int precio) {
        this.precio = precio;
    }
    public int getId_tienda() {
        return id_tienda;
    }
    public void setId_tienda(int id_tienda) {
        this.id_tienda = id_tienda;
    }
}
